import express, { Application, Request, Response } from "express";
import bodyParser from "body-parser";
const app: Application = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.get("/", (req: Request, res: Response) => {
  res.send("TS App is Running");
});
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`server is running on PORT ${PORT}`);
});

app.get("/key", (req, res) => {
  const result = calculate(4);
  res.send({ key: result });
});

function calculate(baseNumber) {
  let result = 0;
  for (let i = Math.pow(baseNumber, 7); i >= 0; i--) {
    result += Math.atan(i) * Math.tan(i);
  }
  return result;
}
