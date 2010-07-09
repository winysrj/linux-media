Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <andreaz@t-online.de>) id 1OXJ1i-00046h-Ip
	for linux-dvb@linuxtv.org; Fri, 09 Jul 2010 21:14:22 +0200
Received: from mailout03.t-online.de ([194.25.134.81])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OXJ1h-0004OM-C0; Fri, 09 Jul 2010 21:14:22 +0200
From: "Andreas Witte" <andreaz@t-online.de>
To: <linux-dvb@linuxtv.org>
Date: Fri, 9 Jul 2010 21:13:03 +0200
Message-ID: <005b01cb1f9a$c11a9300$434fb900$@de>
MIME-Version: 1.0
Content-Language: de
Subject: [linux-dvb] Strange Problem with Antti's af9015 driver on gentoo
	2.6.30-r5
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1677522957=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1677522957==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_005C_01CB1FAB.84A36300"
Content-Language: de

This is a multi-part message in MIME format.

------=_NextPart_000_005C_01CB1FAB.84A36300
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello TV-Friends,

 

today i checked out Antti's last af9015 (af9013) driver and encountered a
strange problem

on my gentoo 2.6.30-r5 box. If i install this driver, udev (149) start to
behave strange and 

take a long time to finish. When it comes to set to utf8 the whole box hang
without any

chance to do anything. I need to erase all the modules in the
/lib/modules/./media -tree 

(chroot from a boot-cd) to make it boot again. With the driver from around
May all seems 

to work (except that weird bug with not getting a lock anymore sometimes on
my digivox-stick).

 

I wonder what changed in the meantime and what i missed on my gentoo-box to
make

it work..? Am i need a more recent kernel? More recent udev-version?

 

Any help would be nice, cause i would love to test the last change of that
driver and all

your wonderful work.

 

Thanks in advance,

Andreas


------=_NextPart_000_005C_01CB1FAB.84A36300
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.E-MailFormatvorlage17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DDE link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal>Hello TV-Friends,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>today i checked out Antti's last af9015 (af9013) =
driver and
encountered a strange problem<o:p></o:p></p>

<p class=3DMsoNormal>on my gentoo 2.6.30-r5 box. If i install this =
driver, udev
(149) start to behave strange and <o:p></o:p></p>

<p class=3DMsoNormal>take a long time to finish. When it comes to set to =
utf8 the
whole box hang without any<o:p></o:p></p>

<p class=3DMsoNormal>chance to do anything. I need to erase all the =
modules in
the /lib/modules/&#8230;/media -tree <o:p></o:p></p>

<p class=3DMsoNormal>(chroot from a boot-cd) to make it boot again. With =
the
driver from around May all seems <o:p></o:p></p>

<p class=3DMsoNormal>to work (except that weird bug with not getting a =
lock
anymore sometimes on my digivox-stick).<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I wonder what changed in the meantime and what i =
missed on
my gentoo-box to make<o:p></o:p></p>

<p class=3DMsoNormal>it work..? Am i need a more recent kernel? More =
recent
udev-version?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Any help would be nice, cause i would love to test =
the last
change of that driver and all<o:p></o:p></p>

<p class=3DMsoNormal>your wonderful work.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks in advance,<o:p></o:p></p>

<p class=3DMsoNormal>Andreas<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_005C_01CB1FAB.84A36300--



--===============1677522957==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1677522957==--
