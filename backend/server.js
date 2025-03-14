const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

app.post('/api/generate-proof', async (req, res) => {
    try {
        const { name } = req.body;
        if (!name) {
            return res.status(400).json({ success: false, error: "Name is required" });
        }

        console.log('Received:', { name });

        console.log("Running SP1 proof generator...");
        const scriptPath = path.join(__dirname, '..', 'roast_proof', 'script');
        const command = `cd "${scriptPath}" && cargo run --bin roast_prove --release -- "${name}"`;

        exec(command, (error, stdout, stderr) => {
            console.log("SP1 output:", stdout);
            if (stderr) console.error("SP1 errors:", stderr);

            const isRealProof = !error && stdout.includes("Proof verified successfully");
            const proofHash = isRealProof
                ? `0xSP1_${Buffer.from(name).toString('hex')}`
                : `0xFAILED_${Buffer.from(name).toString('hex')}`;

            const response = {
                success: isRealProof,
                isRealProof: isRealProof, // Ensure this is included
                proofHash: proofHash,
                output: stdout,
                roastData: { name }
            };

            if (isRealProof) {
                console.log("✅ Real SP1 Proof Generated!");
            } else {
                console.log("⚠️ Proof Generation Failed");
            }

            res.json(response);
        });
    } catch (error) {
        console.error('Proof generation error:', error);
        res.status(500).json({ success: false, error: error.message });
    }
});

app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
    console.log(`Proof Server running on http://localhost:${PORT}`);
});
