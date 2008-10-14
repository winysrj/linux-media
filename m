Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <htmoore@comcast.net>) id 1KptYv-00071X-3P
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 01:44:27 +0200
From: "Tom Moore" <htmoore@comcast.net>
To: <linux-dvb@linuxtv.org>
Date: Tue, 14 Oct 2008 18:43:21 -0500
Message-ID: <001501c92e56$a4903870$edb0a950$@net>
MIME-Version: 1.0
Content-Language: en-us
Subject: [linux-dvb] Duel Hauppauge HVR-1600
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0007638048=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============0007638048==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0016_01C92E2C.BBBA3070"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_0016_01C92E2C.BBBA3070
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I just bought two Hauppauge HVR-1600 cards and I'm trying to set them up in 

Mythdorra 5. I have the cx18 drivers installed but it is only initializing
one 

card. I'm getting the following message when I do a dmesg | grep cx18. Has 

anyone ran accross this problem before with duel cards of the same model and
if 

so, how do I fix it? Any help will be greatly appreciated.

 

Thanks,

Tom Moore

Houston, TX

 

dmesg | grep cx18

cx18:  Start initialization, version 1.0.1

cx18-0: Initializing card #0

cx18-0: Autodetected Hauppauge card

cx18-0: Unreasonably low latency timer, setting to 64 (was 32)

cx18-0: cx23418 revision 01010000 (B)

cx18-0: Autodetected Hauppauge HVR-1600

cx18-0: VBI is not yet supported

tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)

cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)

cx18-0: Disabled encoder IDX device

cx18-0: Registered device video0 for encoder MPEG (2 MB)

DVB: registering new adapter (cx18)

cx18-0: DVB Frontend registered

cx18-0: Registered device video32 for encoder YUV (2 MB)

cx18-0: Registered device video24 for encoder PCM audio (1 MB)

cx18-0: Initialized card #0: Hauppauge HVR-1600

cx18-1: Initializing card #1

cx18-1: Autodetected Hauppauge card

cx18-1: Unreasonably low latency timer, setting to 64 (was 32)

cx18-1: ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h

cx18-1: or disabling CONFIG_HIGHMEM4G into the kernel would help

cx18-1: Error -12 on initialization

cx18: probe of 0000:02:04.0 failed with error -12

cx18:  End initialization

 


------=_NextPart_000_0016_01C92E2C.BBBA3070
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
	{margin:0in;
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>I just bought two Hauppauge HVR-1600 =
cards
and I'm trying to set them up in <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>Mythdorra 5. I have the cx18 drivers
installed but it is only initializing one <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>card. I'm getting the following =
message when
I do a dmesg | grep cx18. Has <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>anyone ran accross this problem before =
with
duel cards of the same model and if <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>so, how do I fix it? Any help will be =
greatly
appreciated.<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>Thanks,<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>Tom Moore<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>Houston, TX<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>dmesg | grep =
cx18<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18:&nbsp; Start initialization, =
version
1.0.1<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Initializing card =
#0<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Autodetected Hauppauge =
card<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Unreasonably low latency =
timer,
setting to 64 (was 32)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: cx23418 revision 01010000 =
(B)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Autodetected Hauppauge =
HVR-1600<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: VBI is not yet =
supported<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>tuner 2-0061: chip found @ 0xc2 (cx18 =
i2c
driver #0-1)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cs5345 1-004c: chip found @ 0x98 (cx18 =
i2c
driver #0-0)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Disabled encoder IDX =
device<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Registered device video0 for =
encoder
MPEG (2 MB)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>DVB: registering new adapter =
(cx18)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: DVB Frontend =
registered<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Registered device video32 for =
encoder
YUV (2 MB)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Registered device video24 for =
encoder
PCM audio (1 MB)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-0: Initialized card #0: Hauppauge
HVR-1600<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: Initializing card =
#1<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: Autodetected Hauppauge =
card<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: Unreasonably low latency =
timer,
setting to 64 (was 32)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: ioremap failed, perhaps =
increasing
__VMALLOC_RESERVE in page.h<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: or disabling CONFIG_HIGHMEM4G =
into
the kernel would help<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18-1: Error -12 on =
initialization<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18: probe of 0000:02:04.0 failed =
with error
-12<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'line-height:19.2pt'><span =
style=3D'font-size:12.0pt;
font-family:"Arial","sans-serif"'>cx18:&nbsp; End =
initialization<o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

------=_NextPart_000_0016_01C92E2C.BBBA3070--



--===============0007638048==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0007638048==--
