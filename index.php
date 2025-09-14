<?php
// Simple PHP app with routing and Composer packages
require_once 'vendor/autoload.php';

// Import useful packages
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use Carbon\Carbon;
use Symfony\Component\VarDumper\VarDumper;

session_start();

// Initialize logger
$logger = new Logger('app');
$logger->pushHandler(new StreamHandler('php://stdout', Logger::INFO));

// Log request
$logger->info('Request received', ['route' => $_GET['route'] ?? 'home', 'time' => Carbon::now()->toISOString()]);

// Get current route
$route = $_GET['route'] ?? 'home';

function renderPage($title, $content) {
    return "
    <!DOCTYPE html>
    <html lang='cs'>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>$title</title>
        <link rel='stylesheet' href='assets/style.css'>
    </head>
    <body>
        <div class='container'>
            $content
        </div>
        <div class='debug-info'>
            <small>🐳 Docker + Composer packages working! | Server time: " . Carbon::now()->format('H:i:s') . "</small>
        </div>
        <script src='assets/script.js'></script>
    </body>
    </html>";
}

// Route handling
switch($route) {
    case 'home':
        $content = "
            <div class='home-content'>
                <h1>🚀 Docker + Composer Test App</h1>
                <p>Packages: Monolog, Carbon (nesbot), Symfony VarDumper, Guzzle</p>
                <button class='click-btn' onclick='goToTime()'>Click Me</button>
                <div class='package-info'>
                    <h3>📦 Loaded Packages:</h3>
                    <ul>
                        <li>✅ Monolog (logging)</li>
                        <li>✅ Carbon/nesbot (date/time)</li>
                        <li>✅ Symfony VarDumper (debugging)</li>
                        <li>✅ Guzzle HTTP (HTTP client)</li>
                        <li>✅ PHP DotEnv (environment)</li>
                    </ul>
                </div>
            </div>";
        echo renderPage('Docker Test App', $content);
        break;

    case 'time':
        // Use Carbon for better date handling
        $carbon = Carbon::now('Europe/Prague');
        $currentDateTime = $carbon->format('d.m.Y H:i:s');
        $humanReadable = $carbon->diffForHumans();

        // Log the time request
        $logger->info('Time page accessed', ['carbon_time' => $carbon->toISOString()]);

        $content = "
            <div class='time-content'>
                <div class='time-display'>$currentDateTime</div>
                <div class='time-extra'>
                    <p>📍 Timezone: {$carbon->getTimezone()->getName()}</p>
                    <p>📅 Day: {$carbon->format('l')}</p>
                    <p>🗓️  Week: {$carbon->weekOfYear}</p>
                    <p>⏰ Relative: $humanReadable</p>
                </div>
                <button class='back-btn' onclick='goHome()'>Zpět na hlavní stránku</button>
            </div>";
        echo renderPage('Aktuální čas', $content);
        break;

    case 'debug':
        // Debug route to test Symfony VarDumper
        $debugData = [
            'server_info' => $_SERVER['HTTP_HOST'] ?? 'unknown',
            'php_version' => PHP_VERSION,
            'loaded_extensions' => get_loaded_extensions(),
            'carbon_now' => Carbon::now(),
            'memory_usage' => memory_get_usage(true),
        ];

        ob_start();
        VarDumper::dump($debugData);
        $dumpOutput = ob_get_clean();

        $content = "
            <div class='debug-content'>
                <h2>🐛 Debug Information</h2>
                <div class='dump-output'>$dumpOutput</div>
                <button class='back-btn' onclick='goHome()'>Zpět na hlavní stránku</button>
            </div>";
        echo renderPage('Debug Info', $content);
        break;

    default:
        header('HTTP/1.0 404 Not Found');
        $logger->warning('404 - Page not found', ['route' => $route]);
        $content = "
            <div class='error-content'>
                <h1>404 - Stránka nenalezena</h1>
                <p>Route '$route' neexistuje</p>
                <button class='back-btn' onclick='goHome()'>Zpět na hlavní stránku</button>
            </div>";
        echo renderPage('Chyba 404', $content);
        break;
}