<?php
session_start();
if(!isset($_SESSION['userid'])){
        require_once ('login.php');
        exit;
}
define("OK", true);
require_once("global.php");
$date=date("Y-m-d H:i:s D");
?>

<html>
<meta name="Author" content="Gaby_chen">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
a:link { color:#000000;text-decoration:none}
a:hover {color:#666666;}
a:visited {color:#000000;text-decoration:none}

td {FONT-SIZE: 9pt; FILTER: dropshadow(color=#FFFFFF,offx=1,offy=1); COLOR: #000000; FONT-FAMILY: "瀹嬩綋"}
img {filter:Alpha(opacity:100); chroma(color=#FFFFFF)}
</style>
<base target="main">
<script>
/*
function preloadImg(src)
{
	var img=new image();
	img.src=src
}
preloadImg("images/admin_top_open.gif");
*/
var displayBar=true;
function switchBar(obj)
{
	if (displayBar)
	{
		parent.frame.cols="0,*";
		displayBar=false;
		obj.src="images/admin_top_open.gif";
		obj.title="打开左边管理功能表";
	}
	else{
		parent.frame.cols="180,*";
		displayBar=true;
		obj.src="images/admin_top_close.gif";
		obj.title="关闭左边管理功能表";
	}
}
//onload="alert('hello')";
</script>
</head>

<body background="images/admin_top_bg.gif" leftmargin="0" topmargin="0" >
<table height="100%" wIdth="100%" border=0 cellpadding=0 cellspacing=0>
<tr valign=mIddle>
	<td wIdth=50>
	<img onClick="switchBar(this)" src="images/admin_top_close.gif" title="关闭左边管理功能表" style="cursor:hand">
	</td>

	<td wIdth=40>
		<img src="images/admin_top_icon_1.gif">
	</td>

	<td wIdth=200>
		<?php echo $date ?>
	</td>

	<td wIdth=40>&nbsp;
	</td>
	<td wIdth=100>&nbsp;</td>	
	<td align="right"><a href="" onClick="parent.location.href='en/index.php'; ">English</a>&nbsp;&nbsp;&nbsp; <?php echo $version." ".$bdate ?></td>
</tr>
</table>
</body>
</html>


