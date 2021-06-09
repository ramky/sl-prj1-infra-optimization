const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const TodosSchema = new Schema({
  title: {
    type: String,
    required: true,
    trim: true,
    minlength: 3,
  },
  desc: {
    type: String,
    required: true,
    trim: true,
    minlength: 5,
  },
});

module.exports = mongoose.model("Todos", TodosSchema);
