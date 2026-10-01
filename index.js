const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send({ status: 'success', message: 'Hello from the Containerized Node API!' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
