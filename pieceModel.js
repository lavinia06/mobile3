const mongoose = require('mongoose')

const itemSchema = mongoose.Schema(
    {
        frontendId: { type: Number, required: false },
        name: {
            type: String, 
            required: [true, "Please enter a piece name"]
        },
        style: {
            type: String, 
            required: [true, "Please enter a piece style"]
        }, 
        season: {
            type: String, 
            required: [true, "Please enter an piece season"]
        },
        purchaseDate: {
            type: Date,
            required: [true, "Please enter an piece purchase date"]
        }

    },
    {
        timestamps: true
    }
)

const Piece = mongoose.model('Piece', itemSchema);

module.exports = Piece;