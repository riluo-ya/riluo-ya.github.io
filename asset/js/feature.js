/*
	HTML Starter Template - Feature JavaScript
	Original Source: https://github.com/AsisYu/html-starter-qwpicu.git
	License: Open Source
	Author: AsisYu
	Description: Page feature enhancements and mobile optimizations
*/

// 每次访问清除缓存
window.onpageshow = function (event) {
  if (event.persisted) {
    window.location.reload()
  }
};
var fresh_link = new Date().getTime();

// 移除页面加载初始样式
window.onload = function () { 
  document.body.classList.remove('is-preload'); 
}
// 禁止触摸滑动
window.ontouchmove = function () { 
  return false; 
}
// 屏幕旋转后重置滚动位置
window.onorientationchange = function () { 
  document.body.scrollTop = 0; 
}
