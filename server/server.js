require('dotenv').config();
const axios = require('axios');
const express = require('express');
const app = express();

const getWeather = async (location) => {
    if (!location) {
        throw new Error('Location parameter is missing');
    }

    const apiKey = process.env.API_KEY;

    if (!apiKey) {
        throw new Error('API key is missing');
    }

    try {
        const response = await axios.get(
            `https://api.openweathermap.org/data/2.5/forecast?q=${location}&units=metric&cnt=2&appid=${apiKey}`,
        );
        return response.data;
    } catch (error) {
        console.error(error);
        throw new Error('Failed to fetch weather data');
    }
};

function getCurrentDateTime() {
    const now = new Date();

    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');

    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

const calcConditionCode = (rain) => {
    if (typeof rain !== 'number' || isNaN(rain)) {
        throw new Error('Input is not a number');
    }

    if (rain < 0) {
        throw new Error('Input is less than 0');
    }

    switch (true) {
        case rain === 0:
            return 0;
        case rain <= 2.5:
            return 1;
        case rain <= 7.5:
            return 2;
        case rain > 7.5:
            return 3;
    }

    throw new Error('Unexpected error occurred');
};

const formatWeatherData = (weatherData) => {
    if (
        !weatherData ||
        !weatherData.city ||
        !weatherData.city.name ||
        !weatherData.list ||
        !Array.isArray(weatherData.list)
    ) {
        throw new Error('Invalid weather data format');
    }

    try {
        return {
            current_datetime: getCurrentDateTime(),
            location: weatherData.city.name,
            weather_data: weatherData.list.map((item) => {
                return {
                    timestamp: item.dt_txt,
                    rain: item.rain ? item.rain['3h'] : 0,
                    temperature: item.main.temp,
                    condition_code: calcConditionCode(
                        item.rain ? item.rain['3h'] : 0,
                    ),
                };
            }),
        };
    } catch (error) {
        throw new Error('Error formatting weather data');
    }
};

app.get('/weather', async (req, res) => {
    const location = req.query.location;

    if (!location) {
        return res.status(400).json({ error: 'Location parameter is missing' });
    }

    try {
        const weatherData = await getWeather(location);

        const data = formatWeatherData(weatherData);

        res.json(data);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: `An error occurred: ${error.message}` });
    }
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
