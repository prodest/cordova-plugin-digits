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
  }

};

module.exports = digits;
