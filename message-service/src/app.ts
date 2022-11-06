import express, { Application, Request, Response } from "express";
import bodyParser from "body-parser";
import {MongoClient, ObjectID} from "mongodb";

const app: Application = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.get("/", (req: Request, res: Response) => {
  res.send("TS App is Running");
});
const PORT = 4000;

const mongoDbPassword = process.env.MONGODB_PASSWORD;
const mongoDbUrl = `mongodb://root:${mongoDbPassword}@message-mongodb.default.svc.cluster.local:27017`;
const mongoClient = new MongoClient(mongoDbUrl);

app.listen(PORT, () => {
  console.log(`server is running on PORT ${PORT}`);
});

app.get("/messages", async (req, res) => {
  await mongoClient.connect();
  const messageCollection = mongoClient.db("messages").collection("messages");

  const messages = await messageCollection.find().toArray();

  res.send(messages);
});

app.post("/messages", async (req, res) => {
  await mongoClient.connect();
  const messageCollection = mongoClient.db("messages").collection("messages");

  await messageCollection.insertOne(req.body);

  res.send();
});

app.delete("/messages/:messageId", async (req, res) => {
  await mongoClient.connect();
  const messageCollection = mongoClient.db("messages").collection("messages");

  await messageCollection.deleteOne({ _id: new ObjectID(req.params.messageId) });

  res.send();
});
