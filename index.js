const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.post('/new-form-assignment', (req, res) => {
  console.log('✅ Received form:', req.body);
  res.send({ status: 'ok', message: 'Form assignment received successfully' });
});

app.get('/', (req, res) => {
  res.send('API is live!');
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});
