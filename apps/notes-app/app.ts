import express, { Express, Request, Response } from 'express';

// import dotenv from 'dotenv';
// dotenv.config();

const app: Express = express();
const port = process.env.PORT || "3000";

const notes: string[] = []


app.get('/notes', );
app.use(express.json())
app.route('/notes')
    .get((req: Request, res: Response) => {
        res.send(notes);
    })
    .put((req: Request, res: Response) => {
        const new_note = req.body.note
        notes.push(new_note)
        res.send("successfully updated note");
    })

app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});
