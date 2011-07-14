/**
 * command-manager.js module
 */
 
var fs = require('fs');

var modules = {

	loggingManager: '../modules/logging-manager.js'

};

var Module;
var NodeMonitorObject;

CommandManagerModule = function (nodeMonitor, childDeps) {

	for (var name in modules) {
		eval('var ' + name + '= require(\'' + modules[name] + '\')');
	}
	
	for (var name in childDeps) {
		eval('var ' + name + '= require(\'' + childDeps[name] + '\')');
	}
	
	var utilities = new utilitiesManager.UtilitiesManagerModule();
	var constants = new constantsManager.ConstantsManagerModule();
	var logger = new loggingManager.LoggingManagerModule(nodeMonitor, childDeps);

	NodeMonitorObject = nodeMonitor;
	Module = this;
	
};

CommandManagerModule.prototype.executeCommand = function (command) {

	console.log('my command ' + command);
	
};	

exports.CommandManagerModule = CommandManagerModule;