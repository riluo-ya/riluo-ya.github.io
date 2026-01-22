/*!
    流星小屋原创首发
    流星小屋地址 : www.liuxingyu.icu
    百度搜索 : 流星小屋
  */

/* 自定义配置 */
// $(function () {
//     var url = "../setting.json"
//     $.getJSON(
//         url,
//         function (data) {
//             /* 页头数据 */
//             $('title').text(data.title);
//             $('#loading-title').html(data.title);
//             $("meta[name='description']").attr('content', data.description);
//             $("meta[name='keywords']").attr('content', data.keywords);
//             $("meta[name='author']").attr('content', data.author);
//             /* 基础信息 */
//             $("#logo-img").attr("src", data.logo_img);
//             $('#logo-text-1').html(data.logo_text_1);
//             $('#logo-text-2').html("." + data.logo_text_2);
//             $('#logo-title-other').html(data.logo_text_1);
//             $('#logo-title-other-small').html("." + data.logo_text_2);
//             $('#logo-text-small').html(data.logo_text_1 + "." + data.logo_text_2);
//             $('#change').html(data.des_title[0]);
//             $('#change1').html(data.des_title[1]);
//             localStorage.setItem('des_tip', data.des_title[0]);
//             localStorage.setItem('des_tip_change', data.des_title_change[0]);
//             localStorage.setItem('des_title', data.des_title[1]);
//             localStorage.setItem('des_title_change', data.des_title_change[1]);
//             /* 社交链接 */
//             $('#github').attr('href', "/" + data.github);
//             $('#qq').attr('href', "https://wpa.qq.com/msgrd?v=3&uin=2550863610&site=qq&menu=yes");
//             $('#email').attr('href', "mailto:" + data.email);
//             $('#telegram').attr('/');
//             $('#twitter').attr('href', "https://www.liuxingyy.cn/" + data.twitter);
//             /* 天气 API */
//             localStorage.setItem('weather_api', data.weather_api);
//             /* 快捷链接 */
//             $('#link-url-1').attr('href', data.link_1[0]);
//             $('#link-icon-1').attr('class', data.link_1[1]);
//             $('#link-name-1').html(data.link_1[2]);
//             $('#link-url-2').attr('href', data.link_2[0]);
//             $('#link-icon-2').attr('class', data.link_2[1]);
//             $('#link-name-2').html(data.link_2[2]);
//             $('#link-url-3').attr('href', data.link_3[0]);
//             $('#link-icon-3').attr('class', data.link_3[1]);
//             $('#link-name-3').html(data.link_3[2]);
//             $('#link-url-4').attr('href', data.link_4[0]);
//             $('#link-icon-4').attr('class', data.link_4[1]);
//             $('#link-name-4').html(data.link_4[2]);
//             $('#link-url-5').attr('href', data.link_5[0]);
//             $('#link-icon-5').attr('class', data.link_5[1]);
//             $('#link-name-5').html(data.link_5[2]);
//             $('#link-url-6').attr('href', data.link_6[0]);
//             $('#link-icon-6').attr('class', data.link_6[1]);
//             $('#link-name-6').html(data.link_6[2]);
//             //壁纸 API
//             $('#wallpaper_text1').html(data.wallpaper_api[0][0]);
//             localStorage.setItem('wallpaper_api_1', data.wallpaper_api[0][1]);
//             $('#wallpaper_text2').html(data.wallpaper_api[1][0]);
//             localStorage.setItem('wallpaper_api_2', data.wallpaper_api[1][1]);
//             $('#wallpaper_text3').html(data.wallpaper_api[2][0]);
//             localStorage.setItem('wallpaper_api_3', data.wallpaper_api[2][1]);
//             //页脚版权
//             $('#power-year').html(data.Copyright_year);
//             $('#power-text').html(data.Copyright_text);
//         }
//     )
// });

