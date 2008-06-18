Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5IC5ZcD027043
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 08:05:35 -0400
Received: from n5a.bullet.mail.ac4.yahoo.com (n5a.bullet.mail.ac4.yahoo.com
	[76.13.13.68])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5IC5K4q015577
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 08:05:20 -0400
Message-ID: <393A6514A13E499AA058F7B457ADE534@voyager>
From: "Stephane Marchand" <smarchand291@yahoo.ca>
To: <video4linux-list@redhat.com>
References: <20080617160012.0E639619767@hormel.redhat.com>
Date: Wed, 18 Jun 2008 08:05:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Subject: Trying to adapt  a javascript with Motion
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all

I know it's not specifically related to V4L but I'm trying to solve a 
problem with Camserv which is not working
anymore for me "(V4L) mmap error". Motion is almost doing the job for me but 
I don't want to use a java applet to display
my webcam and Motion is a great piece of software. So since Motion is acting 
as Camserv
(sending jpeg to the browser http protocol) I hope I can use a javascript to 
display the picture in a webpage. but no go yet.

I'm still wondering what's the problem with Camserv ? I think it's having a 
bug that reference to v4l2 instead of v4l...
It's really not a problem with my bt848 card or even the kernel (2.4 -> 2.6)

anyone seeing my error in the code below ?

thanks for any help


<?php
$ip = gethostbyname('my.server.org');
?>
<html>
<head>
  <title>SMARCH</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <meta http-equiv="PRAGMA" content="NO-CACHE">
  <meta http-equiv="Refresh" 
content="1800;url=http://my.server.org/webcam/sessionoff.html">
  <link href="style.css" rel="stylesheet" type="text/css">
  <script LANGUAGE="JavaScript">
<!-- hide
// "var speed" is the refresh rate adjustment in seconds.
var speed = 1;
var y = 1;
var x = speed + y;
var time = x - y;
var now;
campicture = new Image();
function stopClock() {
	x = "off";
	document.form0.clock.value = x;
}
function startClock() {
        if (x != "off") {
	x = x - y;
	document.form0.clock.value = x;
	if (x <= 1)
        {
          reload()
        }
	timerID = setTimeout("startClock()", 1000);
        }
}
function reload() {
	now = new Date();
	var camImg = "http://<?php echo $ip;?>:9192/singleframe/" + "?" + 
now.getTime();
	document.campicture.src = camImg;
    x = speed;
    document.form0.clock.value = x;
              	  }
//end hide -->

</script>
</head>
<body style="color: rgb(204, 204, 204); background-color: rgb(0, 0, 0);" 
alink="#33ff33" link="#00cccc" vlink="#ff0000" onload="startClock()" 
leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table border="0" width=100% height=380>
    <tr>
      <td valign=top>
	<FORM action="JSCam.html" name="form0">
	<center>
	Boul Universit&eacute;, Rouyn-Noranda, Qu&eacute;bec, Canada<br>
	<IMG src="webcamstream.jpg" name="campicture" border=1 reload="60" 
width=400 height=300 alt="soyez patient...chargement">
	<br>Images intervales: 1 sec, 1 "frame". USB Logitech Quickcam Express - 
camserv</CENTER>
	<INPUT type="hidden" name="clock" size="3" value="">
	</FORM>
      </td>
      <td valign=top align=center><br>
      <a href=top2.php><img src=images/iconcegep.jpg border=0><br>Cam 2</a>
      </td>
     </tr>
</table>

</BODY>
</HTML>

 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
