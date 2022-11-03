import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
    stages: [
        { duration: '10s', target: 1000 },
        { duration: '10s', target: 2000 },
        { duration: '10s', target: 3000 },
        { duration: '10s', target: 4000 },
        { duration: '10s', target: 5000 },
        { duration: '10s', target: 6000 },
        { duration: '10s', target: 7000 },
        { duration: '10s', target: 8000 },
    ],
};

export default function () {
    http.get('http://localhost:30201/key');
    sleep(1);
}