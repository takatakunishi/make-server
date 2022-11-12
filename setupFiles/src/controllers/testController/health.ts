import express from "express"
import type { Health } from "../../models/testModel"

export default async (req: express.Request, res: express.Response) => {
  console.log("test/health")

  try {
    const response: Health = {message: "server is health", code: 200}
    res.json(response)
  } catch (err) {
    console.log(err)
    const response: Health = {message: "server is not health", code: 500}
    res.send(response)
  }
}