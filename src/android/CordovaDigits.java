package com.jimmymakesthings.plugins.digits;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import java.util.*;
import android.app.Activity;
import android.util.Log;
import android.os.Bundle;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterAuthToken;
import com.twitter.sdk.android.core.TwitterCore;
import io.fabric.sdk.android.Fabric;

import com.digits.sdk.android.*;
import com.crashlytics.android.Crashlytics;

public class CordovaDigits extends CordovaPlugin {
  volatile DigitsClient digitsClient;
  private static final String META_DATA_KEY = "io.fabric.ConsumerKey";
  private static final String META_DATA_SECRET = "io.fabric.ConsumerSecret";
  private static final String TAG = "CORDOVA PLUGIN DIGITS";

  private AuthCallback authCallback;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);

    TwitterAuthConfig authConfig = getTwitterConfig();
    Fabric.with(cordova.getActivity().getApplicationContext(), new Crashlytics(), new TwitterCore(authConfig), new Digits());
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    Log.i(TAG, "executing action " + action + " called with options: " + args);

    if ("authenticate".equals(action)) {
      authenticate(callbackContext);
    } else if ("logout".equals(action)) {
      logout(callbackContext);
    } else if (action.equals("addLog")) {
			addLog(args, callbackContext);
		} else if (action.equals("sendCrash")) {
			sendCrash(args, callbackContext);
		} else if (action.equals("sendNonFatalCrash")) {
			sendNonFatalCrash(args, callbackContext);
		} else if (action.equals("setUserIdentifier")) {
			setUserIdentifier(args, callbackContext);
		} else if (action.equals("setUserName")) {
			setUserName(args, callbackContext);
		} else if (action.equals("setUserEmail")) {
			setUserEmail(args, callbackContext);
		} else if (action.equals("setStringValueForKey")) {
			setStringValueForKey(args, callbackContext);
		} else if (action.equals("setIntValueForKey")) {
			setIntValueForKey(args, callbackContext);
		} else if (action.equals("setBoolValueForKey")) {
			setBoolValueForKey(args, callbackContext);
		} else if (action.equals("setFloatValueForKey")) {
			setFloatValueForKey(args, callbackContext);
    } else {
      Log.w(TAG, "unknown action `" + action + "`");
			callbackContext.error(TAG + ": Method '" + action + "' not supported.");
			return false;
		}

		return true;
  }

  public void authenticate(final CallbackContext callbackContext) {
    authCallback = new AuthCallback() {
      @Override
      public void success(DigitsSession session, String phoneNumber) {
        // Do something with the session and phone number
        Log.i(TAG, "authentication successful");

        TwitterAuthConfig authConfig = TwitterCore.getInstance().getAuthConfig();
        TwitterAuthToken authToken = (TwitterAuthToken) session.getAuthToken();
        DigitsOAuthSigning oauthSigning = new DigitsOAuthSigning(authConfig, authToken);
        Map<String, String> authHeaders = oauthSigning.getOAuthEchoHeadersForVerifyCredentials();

        String result = new JSONObject(authHeaders).toString();
        callbackContext.success(result);
      }

      @Override
      public void failure(DigitsException exception) {
        // Do something on failure
        Log.e(TAG, "error " + exception.getMessage());
        callbackContext.error(exception.getMessage());
      }
    };

    Digits.authenticate(authCallback, cordova.getActivity().getResources().getIdentifier("CustomDigitsTheme", "style", cordova.getActivity().getPackageName()));
  }

  public void logout(final CallbackContext callbackContext) {
    Digits.getSessionManager().clearActiveSession();
  }

  private TwitterAuthConfig getTwitterConfig() {
    String key = getMetaData(META_DATA_KEY);
    String secret = getMetaData(META_DATA_SECRET);

    return new TwitterAuthConfig(key, secret);
  }

  private String getMetaData(String name) {
    try {
      Context context = cordova.getActivity().getApplicationContext();
      ApplicationInfo ai = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);

      Bundle metaData = ai.metaData;
      if(metaData == null) {
        Log.w(TAG, "metaData is null. Unable to get meta data for " + name);
      }
      else {
        String value = metaData.getString(name);
        return value;
      }
    } catch (NameNotFoundException e) {
      e.printStackTrace();
    }
    return null;
  }


  /* Crashlytics Events */

	private void addLog(final JSONArray data, final CallbackContext callbackContext) {

		String message = data.optString(0);
		Crashlytics.log(message);
		callbackContext.success();
	}

	private void sendCrash(final JSONArray data, final CallbackContext callbackContext) {

		this.cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				throw new RuntimeException("This is a crash");
			}
		});
	}

	private void sendNonFatalCrash(final JSONArray data, final CallbackContext callbackContext) {

		this.cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Crashlytics.logException(new Throwable(data.optString(0, "No Message Provided")));
			}
		});
	}

	private void setUserIdentifier(final JSONArray data, final CallbackContext callbackContext) {

		String identifier = data.optString(0);
		Crashlytics.setUserIdentifier(identifier);
		callbackContext.success();
	}

	private void setUserName(final JSONArray data, final CallbackContext callbackContext) {

		String userName = data.optString(0);
		Crashlytics.setUserName(userName);
		callbackContext.success();
	}

	private void setUserEmail(final JSONArray data, final CallbackContext callbackContext) {

		String email = data.optString(0);
		Crashlytics.setUserEmail(email);
		callbackContext.success();
	}

	private void setStringValueForKey(final JSONArray data, final CallbackContext callbackContext) {

		String value = data.optString(0);
		String key = data.optString(1);
		Crashlytics.setString(key, value);
		callbackContext.success();
	}

	private void setIntValueForKey(final JSONArray data, final CallbackContext callbackContext) {

		int value = data.optInt(0);
		String key = data.optString(1);

		Crashlytics.setInt(key, value);
		callbackContext.success();
	}

	private void setBoolValueForKey(final JSONArray data, final CallbackContext callbackContext) {

		boolean value = data.optBoolean(0);
		String key = data.optString(1);

		Crashlytics.setBool(key, value);
		callbackContext.success();
	}

	private void setFloatValueForKey(final JSONArray data, final CallbackContext callbackContext) {

		double value = data.optDouble(0);
		String key = data.optString(1);

		Crashlytics.setDouble(key, value);
		callbackContext.success();
	}
}
