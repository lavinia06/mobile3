const express = require('express')
const mongoose = require('mongoose')
const WebSocket = require('ws');
const http = require('http');
const app = express()
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const Piece = require('./models/pieceModel')
app.use(express.json())
const router = express.Router();
const ObjectId = mongoose.Types.ObjectId;
app.use(express.urlencoded({extended: false}))


//routes

wss.on('connection', (ws) => {
    console.log('Client connected to WebSocket.');
  
    // Send a welcome message to the connected client
    ws.send('Welcome to the WebSocket server.');
  
    // Listen for WebSocket messages from clients
    ws.on('message', (message) => {
      console.log(`Received message: ${message}`);
    });
  
    // Handle WebSocket connection closure
    ws.on('close', () => {
      console.log('Client disconnected from WebSocket.');
    });
  });


  const broadcastToClients = (message) => {
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  };
  
app.get('/', (req, res)=>{
    res.send('hello')
})


app.get('/blog', (req, res)=>{
    res.send('hello blog')
})


app.get('/list', async(req, res)=>{
    try {
        //we use await because we are going to interact with a database
        const pieces = await Piece.find({})
        res.status(200).json(pieces)
    } catch (error) {
        res.status(500).json({message: error.message})
    }
})


app.get('/list/:id', async(req, res)=>{
    try {
        const {id} = req.params
        const piece = await Piece.findById(id)
        res.status(200).json(piece)
    } catch (error) {
        res.status(500).json({message: error.message})
    }
})


app.post('/add', async (req, res) => {
    try {
        console.log('Received a POST request to /add');
        console.log('Request body:', req.body);

        // Create a new piece with the provided data and store frontend ID
        const piece = await Piece.create({
            frontendId: req.body.id,
            name: req.body.name,
            style: req.body.style,
            season: req.body.season,
            purchaseDate: req.body.purchaseDate
        });

        const message = JSON.stringify({ type: 'addPiece', data: piece });
        broadcastToClients(message);
        // Send the created piece in the response, including the MongoDB-generated _id
        res.status(200).json(piece);
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ message: error.message });
    }
});


// app.put('/update/:id', async(req, res)=>{
//     try {
//         console.log('Received a PUT request');
//         const {id} = req.params
//         const piece = await Piece.findByIdAndUpdate(id, req.body)
//         //we cannot fin d any product in the database
//         if(!piece){
//             return res.status(404).json({message: `cannot find any piece with id ${id}`})
//         }
//         const updatedPiece = await CSSMathProduct.findById(id)
//         res.status(200).json(updatedPiece)
//     } catch (error) {
//         res.status(500).json({message: error.message})

//     }
// })
app.put('/update/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { name, style, season, purchaseDate } = req.body;

        console.log('Request body:', req.body);

        // Update the document based on the frontendId field
        const updatedPiece = await Piece.updateOne({ frontendId: id }, {
            name,
            style,
            season,
            purchaseDate
        });

        // Log the updated piece
        console.log('Updated piece:', updatedPiece);

        // Check if any piece was updated
        if (updatedPiece.nModified === 0) {
            console.log(`Cannot find any piece with id ${id}`);
            return res.status(404).json({ message: `Cannot find any piece with id ${id}` });
        }

        console.log('Successfully updated piece.');
        res.status(200).json({ message: 'Successfully updated piece.' });
        const message = JSON.stringify({ type: 'updatePiece', data: updatedPiece });
        broadcastToClients(message);
    } catch (error) {
        console.error('Error updating piece:', error);
        res.status(500).json({ message: error.message });
    }
});


    



app.delete('/delete/:frontendId', async (req, res) => {
    try {
        const { frontendId } = req.params;

        console.log(frontendId)
        // Assuming your Piece model has a property named frontendId
        const piece = await Piece.findOneAndDelete({ frontendId });
        // Log the deleted piece
        console.log('Deleted Piece:', piece);

        if (!piece) {
            return res.status(404).json({ message: `Cannot find product with frontendId ${frontendId}` });
        }

        res.status(200).json(piece);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

mongoose
.connect('mongodb+srv://laviniaionel3:cybersecuritydeveloper@cluster0.pvnsk6x.mongodb.net/Node-API?retryWrites=true&w=majority')
.then(()=>{
    
    app.listen(4000, () => {
        console.log(`Node Api app is running`)
    })
    console.log('db')
}).catch((error)=>{
    console.log(error)
})

