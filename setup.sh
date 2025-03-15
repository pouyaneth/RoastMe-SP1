#!/bin/bash

# Create directory structure for the frontend
mkdir -p ~/blockchain-roaster/frontend
cd ~/blockchain-roaster/frontend

# Clean existing files if any
rm -rf node_modules package-lock.json

# Create directory structure
mkdir -p src/components src/pages public

# Initialize package.json
cat > package.json << 'EOF'
{
  "name": "blockchain-roaster-frontend",
  "version": "1.0.0",
  "description": "Frontend for Blockchain Persona Roaster",
  "main": "index.js",
  "scripts": {
    "start": "webpack serve --mode development --open",
    "build": "webpack --mode production"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
EOF

# Install dependencies (will be done after script runs)
echo "Dependencies will be installed after the script completes."

# Create webpack.config.js
cat > webpack.config.js << 'EOF'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react']
          }
        }
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx'],
    fallback: {
      "stream": require.resolve("stream-browserify"),
      "crypto": require.resolve("crypto-browserify"),
      "path": require.resolve("path-browserify"),
      "os": require.resolve("os-browserify/browser"),
      "http": require.resolve("stream-http"),
      "https": require.resolve("https-browserify"),
      "buffer": require.resolve("buffer/"),
      "process": require.resolve("process/browser"),
    }
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './public/index.html'
    }),
    new webpack.ProvidePlugin({
      process: 'process/browser',
      Buffer: ['buffer', 'Buffer']
    })
  ],
  devServer: {
    historyApiFallback: true,
    port: 8080
  }
};
EOF

# Create .env file
cat > .env << 'EOF'
REACT_APP_BACKEND_URL=http://localhost:3000
REACT_APP_THIRDWEB_CLIENT_ID=your-thirdweb-client-id
EOF

# Create HTML file
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blockchain Persona Roaster</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
  <div id="root"></div>
</body>
</html>
EOF

# Create React files
cat > src/index.js << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import { ThirdwebProvider } from '@thirdweb-dev/react';
import App from './App';
import './styles.css';

// Supported chains
const supportedChains = [
  "ethereum", 
  "polygon", 
  "optimism",
  "base"
];

const root = createRoot(document.getElementById('root'));
root.render(
  <ThirdwebProvider
    activeChain="ethereum"
    clientId={process.env.REACT_APP_THIRDWEB_CLIENT_ID || ""}
    supportedChains={supportedChains}
  >
    <App />
  </ThirdwebProvider>
);
EOF

cat > src/App.js << 'EOF'
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import HomePage from './pages/HomePage';
import RoastPage from './pages/RoastPage';
import MintPage from './pages/MintPage';

const App = () => {
  return (
    <Router>
      <div className="app-container">
        <Navbar />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/roast" element={<RoastPage />} />
            <Route path="/mint" element={<MintPage />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </Router>
  );
};

export default App;
EOF

cat > src/styles.css << 'EOF'
:root {
  --primary: #3B82F6;
  --primary-dark: #2563EB;
  --secondary: #10B981;
  --dark: #1E293B;
  --dark-light: #334155;
  --light: #F1F5F9;
  --light-dark: #CBD5E1;
  --text: #0F172A;
  --text-light: #64748B;
  --error: #EF4444;
  --success: #10B981;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', sans-serif;
  background-color: var(--light);
  color: var(--text);
  line-height: 1.5;
}

.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.card {
  background: white;
  border-radius: 0.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.btn {
  display: inline-block;
  padding: 0.5rem 1rem;
  background-color: var(--primary);
  color: white;
  border: none;
  border-radius: 0.25rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.btn:hover {
  background-color: var(--primary-dark);
}

.btn-secondary {
  background-color: var(--secondary);
}

.btn-secondary:hover {
  background-color: var(--secondary);
  opacity: 0.9;
}

.btn-outline {
  background-color: transparent;
  border: 1px solid var(--primary);
  color: var(--primary);
}

.btn-outline:hover {
  background-color: var(--primary);
  color: white;
}

.input-group {
  margin-bottom: 1rem;
}

.input-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.input-group input,
.input-group textarea,
.input-group select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--light-dark);
  border-radius: 0.25rem;
  font-family: inherit;
}

.input-group input:focus,
.input-group textarea:focus,
.input-group select:focus {
  outline: none;
  border-color: var(--primary);
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100px;
}

.loading-spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-left-color: var(--primary);
  border-radius: 50%;
  width: 30px;
  height: 30px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error {
  color: var(--error);
  margin-bottom: 1rem;
}

.success {
  color: var(--success);
  margin-bottom: 1rem;
}
EOF

# Create components
cat > src/components/Navbar.js << 'EOF'
import React from 'react';
import { Link } from 'react-router-dom';
import { useAddress, ConnectWallet } from '@thirdweb-dev/react';
import './Navbar.css';

const Navbar = () => {
  const address = useAddress();

  return (
    <nav className="navbar">
      <div className="container navbar-container">
        <Link to="/" className="navbar-logo">
          <span className="logo-text">Blockchain Roaster</span>
        </Link>
        
        <div className="navbar-links">
          <Link to="/" className="navbar-link">Home</Link>
          <Link to="/roast" className="navbar-link">Get Roasted</Link>
          {address && <Link to="/mint" className="navbar-link">Mint NFT</Link>}
        </div>
        
        <div className="navbar-wallet">
          <ConnectWallet />
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
EOF

cat > src/components/Navbar.css << 'EOF'
.navbar {
  background-color: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 1rem 0;
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-logo {
  text-decoration: none;
  display: flex;
  align-items: center;
}

.logo-text {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--primary);
  margin-left: 0.5rem;
}

.navbar-links {
  display: flex;
  gap: 1.5rem;
}

.navbar-link {
  text-decoration: none;
  color: var(--text);
  font-weight: 500;
  padding: 0.5rem;
  transition: color 0.2s;
}

.navbar-link:hover {
  color: var(--primary);
}

.navbar-wallet {
  display: flex;
  align-items: center;
}

@media (max-width: 768px) {
  .navbar-container {
    flex-direction: column;
    gap: 1rem;
  }
  
  .navbar-links {
    width: 100%;
    justify-content: center;
  }
  
  .navbar-wallet {
    width: 100%;
    justify-content: center;
  }
}
EOF

cat > src/components/Footer.js << 'EOF'
import React from 'react';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="container footer-container">
        <div className="footer-content">
          <p className="footer-text">
            Blockchain Persona Roaster &copy; {new Date().getFullYear()}
          </p>
          <p className="footer-text">
            Powered by SP1 Zero-Knowledge Proofs
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
EOF

cat > src/components/Footer.css << 'EOF'
.footer {
  background-color: var(--dark);
  padding: 2rem 0;
  color: white;
  margin-top: 2rem;
}

.footer-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.footer-content {
  text-align: center;
}

.footer-text {
  margin-bottom: 0.5rem;
  color: var(--light);
}
EOF

# Create pages
cat > src/pages/HomePage.js << 'EOF'
import React from 'react';
import { Link } from 'react-router-dom';
import './HomePage.css';

const HomePage = () => {
  return (
    <div className="home-page">
      <section className="hero">
        <div className="hero-content">
          <h1 className="hero-title">
            Blockchain Persona Roaster
          </h1>
          <p className="hero-subtitle">
            Get roasted based on your crypto identity, and mint your personalized roast as an NFT
          </p>
          <div className="hero-buttons">
            <Link to="/roast" className="btn btn-primary hero-btn">
              Get Roasted
            </Link>
          </div>
        </div>
      </section>

      <section className="features">
        <div className="container">
          <h2 className="section-title">How It Works</h2>
          <div className="feature-cards">
            <div className="feature-card">
              <div className="feature-icon">1</div>
              <h3 className="feature-title">Enter Wallet or ENS</h3>
              <p className="feature-description">
                Provide your Ethereum address, ENS name, or Farcaster username
              </p>
            </div>
            
            <div className="feature-card">
              <div className="feature-icon">2</div>
              <h3 className="feature-title">Get Your Crypto Persona</h3>
              <p className="feature-description">
                We analyze your on-chain data to create a personalized crypto persona
              </p>
            </div>
            
            <div className="feature-card">
              <div className="feature-icon">3</div>
              <h3 className="feature-title">Generate AI Roast</h3>
              <p className="feature-description">
                Our AI creates a humorous, personalized roast based on your crypto persona
              </p>
            </div>
            
            <div className="feature-card">
              <div className="feature-icon">4</div>
              <h3 className="feature-title">Mint as NFT</h3>
              <p className="feature-description">
                Immortalize your roast by minting it as an NFT on your preferred blockchain
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default HomePage;
EOF

cat > src/pages/HomePage.css << 'EOF'
.home-page {
  padding-bottom: 2rem;
}

.hero {
  background: linear-gradient(135deg, #3B82F6 0%, #10B981 100%);
  padding: 5rem 0;
  text-align: center;
  color: white;
  border-radius: 0.5rem;
  margin-bottom: 3rem;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 1rem;
}

.hero-title {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.hero-subtitle {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.hero-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.hero-btn {
  padding: 0.75rem 1.5rem;
  font-size: 1.1rem;
}

.section-title {
  text-align: center;
  margin-bottom: 2rem;
  font-size: 2rem;
  color: var(--text);
}

.feature-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: white;
  border-radius: 0.5rem;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.2s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-icon {
  width: 60px;
  height: 60px;
  background: var(--primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem;
  font-size: 1.5rem;
  font-weight: 700;
}

.feature-title {
  margin-bottom: 1rem;
  font-size: 1.2rem;
}

.feature-description {
  color: var(--text-light);
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .feature-cards {
    grid-template-columns: 1fr;
  }
}
EOF

cat > src/pages/RoastPage.js << 'EOF'
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import './RoastPage.css';

const BACKEND_URL = 'http://localhost:3000'; // Update this with your backend URL

const RoastPage = () => {
  const navigate = useNavigate();
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [persona, setPersona] = useState(null);
  const [roast, setRoast] = useState('');
  const [proofHash, setProofHash] = useState('');
  
  const handleInputChange = (e) => {
    setInput(e.target.value);
  };
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!input) {
      setError('Please enter an Ethereum address, ENS name, or Farcaster username');
      return;
    }
    
    setIsLoading(true);
    setError('');
    
    try {
      // Analyze input to get persona
      const personaResponse = await axios.post(`${BACKEND_URL}/analyze`, { input });
      const personaData = personaResponse.data.persona;
      setPersona(personaData);
      
      // Generate roast based on persona
      const roastResponse = await axios.post(`${BACKEND_URL}/generate-roast`, { persona: personaData });
      const roastText = roastResponse.data.roast;
      setRoast(roastText);
      
      // Generate proof
      try {
        const proofResponse = await axios.post(`${BACKEND_URL}/generate-proof`, { input, roast: roastText });
        if (proofResponse.data.hash) {
          setProofHash(proofResponse.data.hash);
        }
      } catch (proofError) {
        console.error("Error generating proof:", proofError);
        // Continue even if proof generation fails
      }
      
    } catch (err) {
      console.error("Error:", err);
      setError(err.response?.data?.error || 'Failed to analyze input or generate roast');
    } finally {
      setIsLoading(false);
    }
  };
  
  const handleMint = () => {
    // Store data in localStorage for the mint page
    localStorage.setItem('mintData', JSON.stringify({
      input,
      persona,
      roast,
      proofHash
    }));
    
    // Navigate to mint page
    navigate('/mint');
  };
  
  return (
    <div className="roast-page">
      <h1 className="page-title">Get Roasted</h1>
      
      <div className="card input-card">
        <form onSubmit={handleSubmit}>
          <div className="input-group">
            <label htmlFor="crypto-input">Enter Ethereum Address, ENS Name, or Farcaster Username</label>
            <input
              type="text"
              id="crypto-input"
              value={input}
              onChange={handleInputChange}
              placeholder="e.g. 0x123... or vitalik.eth"
              disabled={isLoading}
            />
          </div>
          
          {error && <div className="error">{error}</div>}
          
          <button type="submit" className="btn btn-primary" disabled={isLoading}>
            {isLoading ? 'Analyzing...' : 'Analyze & Roast'}
          </button>
        </form>
      </div>
      
      {isLoading && (
        <div className="loading">
          <div className="loading-spinner"></div>
          <p>Analyzing on-chain data and generating roast...</p>
        </div>
      )}
      
      {persona && roast && (
        <div className="result-section">
          <div className="card persona-card">
            <h2>Your Crypto Persona</h2>
            <div className="persona-details">
              <div className="persona-item">
                <strong>Archetypes:</strong>
                <span>{persona.archetypes?.join(', ') || 'Crypto Explorer'}</span>
              </div>
              
              <div className="persona-item">
                <strong>Traits:</strong>
                <span>{persona.traits?.join(', ') || 'Cautious'}</span>
              </div>
              
              {persona.profile?.tokenPreferences && (
                <div className="persona-item">
                  <strong>Token Preferences:</strong>
                  <span>{persona.profile.tokenPreferences.join(', ')}</span>
                </div>
              )}
              
              {persona.profile?.nftCollections && persona.profile.nftCollections.length > 0 && (
                <div className="persona-item">
                  <strong>NFT Collections:</strong>
                  <span>{persona.profile.nftCollections.join(', ')}</span>
                </div>
              )}
            </div>
          </div>
          
          <div className="card roast-card">
            <h2>Your Personalized Roast</h2>
            <div className="roast-content">
              <p>{roast}</p>
            </div>
            
            {proofHash && (
              <div className="proof-info">
                <p><strong>Proof Hash:</strong> {proofHash.substring(0, 10)}...</p>
              </div>
            )}
            
            <button onClick={handleMint} className="btn btn-secondary">
              Mint as NFT
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default RoastPage;
EOF

cat > src/pages/RoastPage.css << 'EOF'
.roast-page {
  max-width: 800px;
  margin: 0 auto;
}

.page-title {
  text-align: center;
  margin-bottom: 2rem;
  font-size: 2rem;
}

.input-card {
  margin-bottom: 2rem;
}

.result-section {
  margin-top: 2rem;
}

.persona-card,
.roast-card {
  padding: 1.5rem;
}

.persona-card h2,
.roast-card h2 {
  margin-bottom: 1rem;
  font-size: 1.5rem;
  color: var(--primary);
}

.persona-details {
  display: grid;
  gap: 1rem;
}

.persona-item {
  display: flex;
  flex-direction: column;
}

.persona-item strong {
  margin-bottom: 0.25rem;
  font-weight: 600;
}

.roast-content {
  background-color: var(--light);
  padding: 1.5rem;
  border-radius: 0.5rem;
  margin-bottom: 1.5rem;
  font-style: italic;
  line-height: 1.6;
}

.proof-info {
  margin-bottom: 1.5rem;
  padding: 0.75rem;
  background-color: var(--light);
  border-radius: 0.25rem;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .persona-item {
    flex-direction: column;
  }
  
  .persona-item strong {
    margin-bottom: 0.25rem;
    margin-right: 0;
  }
}
EOF

cat > src/pages/MintPage.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAddress, useChain, useChainId, useSwitchChain } from '@thirdweb-dev/react';
import axios from 'axios';
import './MintPage.css';

const BACKEND_URL = 'http://localhost:3000'; // Update this with your backend URL

const MintPage = () => {
  const navigate = useNavigate();
  const address = useAddress();
  const chain = useChain();
  const chainId = useChainId();
  const switchChain = useSwitchChain();
  
  const [mintData, setMintData] = useState(null);
  const [selectedChain, setSelectedChain] = useState('polygon');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [transactionHash, setTransactionHash] = useState('');
  
  useEffect(() => {
    // Load data from localStorage
    const savedData = localStorage.getItem('mintData');
    if (savedData) {
      setMintData(JSON.parse(savedData));
    } else {
      // Redirect to roast page if no data is available
      navigate('/roast');
    }
  }, [navigate]);
  
  const handleChainChange = (e) => {
    setSelectedChain(e.target.value);
  };
  
  const handleMint = async () => {
    if (!address) {
      setError('Please connect your wallet to mint');
      return;
    }
    
    if (!mintData) {
      setError('No roast data available to mint');
      return;
    }
    
    setIsLoading(true);
    setError('');
    setSuccess('');
    
    try {
      // Call backend to mint NFT
      const response = await axios.post(`${BACKEND_URL}/mint-nft`, {
        chain: selectedChain,
        address: address,
        persona: mintData.persona,
        roast: mintData.roast,
        proofHash: mintData.proofHash
      });
      
      setSuccess('NFT minted successfully!');
      setTransactionHash(response.data.transactionHash);
      
      // Clear localStorage after successful mint
      localStorage.removeItem('mintData');
      
    } catch (err) {
      console.error("Error minting NFT:", err);
      setError(err.response?.data?.error || 'Failed to mint NFT');
    } finally {
      setIsLoading(false);
    }
  };
  
  const getExplorerUrl = () => {
    switch (selectedChain) {
      case 'ethereum':
        return `https://etherscan.io/tx/${transactionHash}`;
      case 'polygon':
        return `https://polygonscan.com/tx/${transactionHash}`;
      case 'optimism':
        return `https://optimistic.etherscan.io/tx/${transactionHash}`;
      case 'base':
        return `https://basescan.org/tx/${transactionHash}`;
      default:
        return `https://etherscan.io/tx/${transactionHash}`;
    }
  };
  
  if (!mintData) {
    return (
      <div className="mint-page">
        <div className="loading">
          <div className="loading-spinner"></div>
          <p>Loading roast data...</p>
        </div>
      </div>
    );
  }
  
  return (
    <div className="mint-page">
      <h1 className="page-title">Mint Your Roast as NFT</h1>
      
      <div className="card mint-card">
        <h2>Roast Preview</h2>
        <div className="roast-preview">
          <p>{mintData.roast}</p>
        </div>
        
        {mintData.proofHash && (
          <div className="proof-info">
            <p><strong>Proof Hash:</strong> {mintData.proofHash.substring(0, 10)}...</p>
          </div>
        )}
        
        <div className="mint-options">
          <div className="input-group">
            <label htmlFor="chain-select">Select Blockchain</label>
            <select 
              id="chain-select" 
              value={selectedChain} 
              onChange={handleChainChange}
              disabled={isLoading}
            >
              <option value="polygon">Polygon</option>
              <option value="optimism">Optimism</option>
              <option value="base">Base</option>
              <option value="ethereum">Ethereum</option>
            </select>
          </div>
          
          {!address && (
            <div className="error">Please connect your wallet to mint</div>
          )}
          
          {error && <div className="error">{error}</div>}
          {success && <div className="success">{success}</div>}
          
          <button 
            onClick={handleMint} 
            className="btn btn-primary"
            disabled={isLoading || !address}
          >
            {isLoading ? 'Minting...' : 'Mint as NFT'}
          </button>
        </div>
        
        {transactionHash && (
          <div className="transaction-info">
            <p>Transaction successful!</p>
            <a 
              href={getExplorerUrl()} 
              target="_blank" 
              rel="noopener noreferrer"
              className="explorer-link"
            >
              View on Blockchain Explorer
            </a>
          </div>
        )}
      </div>
    </div>
  );
};

export default MintPage;
EOF

cat > src/pages/MintPage.css << 'EOF'
.mint-page {
  max-width: 800px;
  margin: 0 auto;
}

.page-title {
  text-align: center;
  margin-bottom: 2rem;
  font-size: 2rem;
}

.mint-card h2 {
  margin-bottom: 1rem;
  font-size: 1.5rem;
  color: var(--primary);
}

.roast-preview {
  background-color: var(--light);
  padding: 1.5rem;
  border-radius: 0.5rem;
  margin-bottom: 1.5rem;
  font-style: italic;
  line-height: 1.6;
}

.proof-info {
  margin-bottom: 1.5rem;
  padding: 0.75rem;
  background-color: var(--light);
  border-radius: 0.25rem;
  font-size: 0.9rem;
}

.mint-options {
  margin-top: 1.5rem;
}

.transaction-info {
  margin-top: 1.5rem;
  padding: 1rem;
  background-color: var(--light);
  border-radius: 0.5rem;
  text-align: center;
}

.explorer-link {
  display: inline-block;
  margin-top: 0.5rem;
  color: var(--primary);
  text-decoration: none;
  font-weight: 500;
}

.explorer-link:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .mint-options {
    flex-direction: column;
  }
}
EOF

echo "Frontend files created successfully!"
echo "Next steps:"
echo "1. Install dependencies: npm install --legacy-peer-deps"
echo "2. Start the application: npm start"
