
/*
	HTML Starter Template - Developer Tools Detection JavaScript
	Original Source: https://github.com/AsisYu/html-starter-qwpicu.git
	License: Open Source
	Author: AsisYu
	Description: Developer tools detection and redirection functionality
*/

let devToolsOpen = false;
        function detectDevTool() {
            const threshold = 160;
            if (window.outerWidth - window.innerWidth > threshold || window.outerHeight - window.innerHeight > threshold) {
                if (!devToolsOpen) {
                    window.location.href = 'http://bing.com';
                    window.stop;
                    debugger;
                }
                devToolsOpen = true;
            } else {
                devToolsOpen = false;
            }
        }

        setInterval(detectDevTool, 1);