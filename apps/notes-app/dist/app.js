"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = __importDefault(require("express"));
// import dotenv from 'dotenv';
// dotenv.config();
var app = (0, express_1.default)();
var port = process.env.PORT || "3000";
var notes = [];
app.get('/notes');
app.use(express_1.default.json());
app.route('/notes')
    .get(function (req, res) {
    res.send(notes);
})
    .put(function (req, res) {
    var new_note = req.body.note;
    notes.push(new_note);
    res.send("successfully updated note");
});
app.listen(port, function () {
    console.log("\u26A1\uFE0F[server]: Server is running at http://localhost:".concat(port));
});
