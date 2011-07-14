/**
 * logging-manager.js module
 */
 
var fs = require('fs');

var Module;

var modules = {

	daoManager: '../modules/dao-manager.js'
	
};

LoggingManagerModule = function (childDeps) {

	for (var name in modules) {
		eval('var ' + name + '= require(\'' + modules[name] + '\')');
	}

	for (var name in childDeps) {
		eval('var ' + name + '= require(\'' + childDeps[name] + '\')');
	}
	
	var constants = new constantsManager.ConstantsManagerModule();
	var dao = new daoManager.DaoManagerModule(childDeps);

	Module = this;
	
	Module.constants = constants;
	Module.dao = dao;
	Module.config = config;
	
};

LoggingManagerModule.prototype.write = function (level, message) {

	var date = new Date();
	message = date + ' ' + level + ' ' + message + '\n';

	if (enabled)
		console.log(message);
	
	if (level == Module.constants.levels.SEVERE) {
	
		Module.dao.postCloudwatch('NodeMonitorAlerts', 'None', message);
		
		var postParams = {};
		
		var data = {
			origin: Module.config.clientIP, 
			alert: message
		};
		
		postParams[date.getTime()] = escape(data);
		var date = new Date();
		
		Module.dao.postDataLongType(Module.constants.api.ALERTS + ':' + date.getUTCFullYear() + ':' + date.getUTCMonth() + ':' + date.getUTCDate(), postParams);
		
	}
	
	fs.open(Module.config.logFile, 'a', 0666, function (error, fd) {	
			
		if (error)
			return;
			
		fs.write(fd, message, null, 'utf8', function (error, written) {
			if (error)
				return;
		});
		
		fs.close(fd, function (error) {
			if (error)
				return;
		});
		
	});
	
};	

exports.LoggingManagerModule = LoggingManagerModule;