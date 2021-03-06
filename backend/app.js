const express = require("express");
const mongoose = require("mongoose");
const path = require("path");
const cors = require("cors");
require("dotenv").config({ path: __dirname + "/../.env" });

const app = express();

app.use(cors());

app.set("view engine", "ejs");
app.set("views", "./src/pages");

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/static", express.static(path.join(`${__dirname}/public`)));

app.get("/", (req, res) => res.send("Home Route"));

const port = process.env.PORT || 8082;

const todosRouter = require("./routes/todos");

app.use("/todos-list", todosRouter);

mongoose
  .connect(process.env.DB_HOST, {
    useCreateIndex: true,
    useUnifiedTopology: true,
    useNewUrlParser: true,
    useFindAndModify: false,
  })
  .then(() => {
    app.listen(port, () =>
      console.log(
        `Server and Database running on ${port}, http://localhost:${port}`
      )
    );
  })
  .catch((err) => {
    console.log(err);
  });
