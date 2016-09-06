const exec = require( 'cordova/exec' );

function noop() { }

const digits = {
  authenticate: function authenticate( options, authenticateSuccess, authenticateFailed ) {
    exec( function success( result ) {
      ( authenticateSuccess || noop )( JSON.parse( result ) );
    }, authenticateFailed || noop, 'Digits', 'authenticate', [ options ] );
  },

  logout: function logout() {
    exec( noop, noop, 'Digits', 'logout', [] );
  },

  /* Crashalytics */

  addLog: function addLog( message ) {
    exec( noop, noop, 'Digits', 'addLog', [ message ] );
  },

  sendCrash: function sendCrash() {
    exec( noop, noop, 'Digits', 'sendCrash', [] );
  },

  sendNonFatalCrash: function sendNonFatalCrash( message ) {
    exec( noop, noop, 'Digits', 'sendNonFatalCrash', [ message ] );
  },

  recordError: function recordError( message, code ) {
    exec( noop, noop, 'Digits', 'recordError', [ message, code ] );
  },

  setUserIdentifier: function setUserIdentifier( userIdentifier ) {
    exec( noop, noop, 'Digits', 'setUserIdentifier', [ userIdentifier ] );
  },

  setUserName: function setUserName( userName ) {
    exec( noop, noop, 'Digits', 'setUserName', [ userName ] );
  },

  setUserEmail: function setUserEmail( userEmail ) {
    exec( noop, noop, 'Digits', 'setUserEmail', [ userEmail ] );
  },

  setStringValueForKey: function setStringValueForKey( value, key ) {
    exec( noop, noop, 'Digits', 'setStringValueForKey', [ value, key ] );
  },

  setIntValueForKey: function setIntValueForKey( value, key ) {
    exec( noop, noop, 'Digits', 'setIntValueForKey', [ value, key ] );
  },

  setBoolValueForKey: function setBoolValueForKey( value, key ) {
    exec( noop, noop, 'Digits', 'setBoolValueForKey', [ value, key ] );
  },

  setFloatValueForKey: function setFloatValueForKey( value, key ) {
    exec( noop, noop, 'Digits', 'setFloatValueForKey', [ value, key ] );
  },

  /* Answers */

  sendPurchase: function sendPurchase( itemPrice, currency, success, itemName, itemType, itemId, attributes ) {
    exec( noop, noop, 'Digits', 'sendPurchase', [ itemPrice, currency, success, itemName, itemType, itemId, attributes ] );
  },

  sendAddToCart: function sendAddToCart( itemPrice, currency, itemName, itemType, itemId, attributes ) {
    exec( noop, noop, 'Digits', 'sendAddToCart', [ itemPrice, currency, itemName, itemType, itemId, attributes ] );
  },

  sendStartCheckout: function sendStartCheckout( totalPrice, currency, itemCount, attributes ) {
    exec( noop, noop, 'Digits', 'sendStartCheckout', [ totalPrice, currency, itemCount, attributes ] );
  },

  sendSearch: function sendSearch( query, attributes ) {
    exec( noop, noop, 'Digits', 'sendSearch', [ query, attributes ] );
  },

  sendShare: function sendShare( method, contentName, contentType, contentId, attributes ) {
    exec( noop, noop, 'Digits', 'sendShare', [ method, contentName, contentType, contentId, attributes ] );
  },

  sendRatedContent: function sendRatedContent( rating, contentName, contentType, contentId, attributes ) {
    exec( noop, noop, 'Digits', 'sendRatedContent', [ rating, contentName, contentType, contentId, attributes ] );
  },

  sendSignUp: function sendSignUp( method, success, attributes ) {
    exec( noop, noop, 'Digits', 'sendSignUp', [ method, success, attributes ] );
  },

  sendLogIn: function sendLogIn( method, success, attributes ) {
    exec( noop, noop, 'Digits', 'sendLogIn', [ method, success, attributes ] );
  },

  sendInvite: function sendInvite( method, attributes ) {
    exec( noop, noop, 'Digits', 'sendInvite', [ method, attributes ] );
  },

  sendLevelStart: function sendLevelStart( levelName, attributes ) {
    exec( noop, noop, 'Digits', 'sendLevelStart', [ levelName, attributes ] );
  },

  sendLevelEnd: function sendLevelEnd( levelName, score, success, attributes ) {
    exec( noop, noop, 'Digits', 'sendLevelEnd', [ levelName, score, success, attributes ] );
  },

  sendContentView: function sendContentView( name, type, id, attributes ) {
    exec( noop, noop, 'Digits', 'sendContentView', [ name, type, id, attributes ] );
  },

  sendScreenView: function sendScreenView( name, id, attributes ) {
    exec( noop, noop, 'Digits', 'sendContentView', [ name, "Screen", id, attributes ] );
  },

  sendCustomEvent: function sendCustomEvent( name, attributes ) {
    exec( noop, noop, 'Digits', 'sendCustomEvent', [ name, attributes ] );
  }
};

module.exports = digits;
