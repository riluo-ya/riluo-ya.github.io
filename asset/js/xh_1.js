/*
	HTML Starter Template - Snow Effect JavaScript
	Original Source: https://github.com/AsisYu/html-starter-qwpicu.git
	License: Open Source
	Author: AsisYu
	Description: Snow animation effect for winter theme
*/

//创建雪花元素
function snow() {
    //获取视窗的宽高
    var width = window.innerWidth;
    var height = window.innerHeight;

    var snow = document.createElement("div");             //创建元素
    
    //初始化雪花样式
    size = Math.random()*15 + 5;                          //随机生成雪花大小
    snow.style.width = size + "px";
    snow.style.height = size + "px";
    // snow.style.background = "url(img/雪花-0" + Math.floor((Math.random()*6)+1) + ".png) no-repeat";     //随机选择雪花的图片
    snow.style.background = "url(img/雪花.png) no-repeat";
    snow.style.backgroundSize = '100% 100%';
    snow.style.position = "fixed";                        //元素的位置相对于浏览器窗口是固定位置，即使窗口是滚动的它也不会移动
    snow.style.filter = "blur(1px)";                      //给图片设置高斯模糊
    snow.style.left = Math.random()*width + 'px';         //随机生成雪花的初始位置
    snow.style.top = "10px";
    snow.style.opacity = parseInt(Math.random()*10)/10;   //随机生成雪花的透明度

    //向body添加元素
    document.body.appendChild(snow);

    //创建定时器，每30ms雪花下落一次
    var timer = setInterval(function() {
        snow.style.top = parseInt(snow.style.top) + 8 + 'px';     //每次下落8px
        
        //当雪花到达底部后清除元素
        if(parseInt(snow.style.top) >= height) {
            clearInterval(timer);
            snow.parentNode.removeChild(snow)
        }
    },30)
}

//页面加载完成执行函数
window.onload = function play() {
    //创建定时器，每50ms生成一朵雪花
    setInterval(function() {
        snow()
    },50)
}

