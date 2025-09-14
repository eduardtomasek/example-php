// Simple navigation functions
function goToTime() {
    window.location.href = '?route=time';
}

function goHome() {
    window.location.href = '?route=home';
}

function goToDebug() {
    window.location.href = '?route=debug';
}

// Add some nice animations on page load
document.addEventListener('DOMContentLoaded', function() {
    const container = document.querySelector('.container');
    container.style.opacity = '0';
    container.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        container.style.transition = 'all 0.5s ease';
        container.style.opacity = '1';
        container.style.transform = 'translateY(0)';
    }, 100);
    
    // Add debug link on home page
    const homeContent = document.querySelector('.home-content');
    if (homeContent) {
        const debugBtn = document.createElement('button');
        debugBtn.textContent = '🐛 Debug Info';
        debugBtn.className = 'back-btn';
        debugBtn.style.marginTop = '1rem';
        debugBtn.onclick = goToDebug;
        homeContent.appendChild(debugBtn);
    }
});