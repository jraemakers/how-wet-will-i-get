require('dotenv').config();
const axios = require('axios');
const express = require('express');
const app = express();

const getWeather = async (location) => {
    const apiKey = process.env.API_KEY;

    try {
        const response = await axios.get(
            `https://api.openweathermap.org/data/2.5/forecast?q=${location}&units=metric&cnt=2&appid=${apiKey}`,
        );
        return response.data;
    } catch (error) {
        console.error(error);
        throw Error('Failed to fetch weather data');
    }
};

app.get('/weather', async (req, res) => {
    const location = req.query.location;

    if (!location) {
        return res.status(400).json({ error: 'Location parameter is missing' });
    }

    try {
        const weatherData = await getWeather(location);
        res.json(weatherData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: `An error occurred: ${error.message}` });
    }
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
