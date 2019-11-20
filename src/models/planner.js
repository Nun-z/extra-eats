"use strict";

var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var ObjectId = mongoose.Schema.Types.ObjectId;

var UserSchema = new Schema({
	email: {
		type: [String],
		required: true,
		unique: true
	}
});

module.exports = mongoose.model("Planner", UserSchema);