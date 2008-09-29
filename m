Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail14.opentransfer.com ([76.162.254.14])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dcoates@systemoverload.net>) id 1KkAty-00013U-Fl
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 07:02:38 +0200
From: "Dustin Coates" <dcoates@systemoverload.net>
To: "'Dustin Coates'" <dcoates@systemoverload.net>,
	<linux-dvb@linuxtv.org>
References: <000001c91f6f$e23ab920$a6b02b60$@net>
In-Reply-To: <000001c91f6f$e23ab920$a6b02b60$@net>
Date: Mon, 29 Sep 2008 00:01:52 -0500
Message-ID: <000001c921f0$7d4aede0$77e0c9a0$@net>
MIME-Version: 1.0
Content-Language: en-us
Subject: Re: [linux-dvb] HVR-1800 Analouge Issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1620105866=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============1620105866==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0001_01C921C6.9474E5E0"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_0001_01C921C6.9474E5E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 

 

From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org]
On Behalf Of Dustin Coates
Sent: Thursday, September 25, 2008 7:36 PM
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1800 Analouge Issues

 

Hi Everyone, 

 

                Ok I've recently decided to start seeing if I can figure out
the issue with the Analouge, on this card, first my normal dmesg.

 

[   32.347715] Linux video capture interface: v2.00

[   32.445802] ivtv:  Start initialization, version 1.4.0

[   32.445864] ivtv0: Initializing card #0

[   32.445867] ivtv0: Autodetected Hauppauge card (cx23416 based)

[   32.446300] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 19 (level, low) ->
IRQ 21

[   32.446310] ivtv0: Unreasonably low latency timer, setting to 64 (was 32)

[   32.499240] tveeprom 0-0050: Hauppauge model 26582, rev E6B2, serial#
10301641

[   32.499244] tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, type
50)

[   32.499246] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)

[   32.499248] tveeprom 0-0050: audio processor is CX25843 (idx 37)

[   32.499250] tveeprom 0-0050: decoder processor is CX25843 (idx 30)

[   32.499252] tveeprom 0-0050: has no radio

[   32.499255] ivtv0: Autodetected Hauppauge WinTV PVR-150

[   32.574169] cx23885 driver version 0.0.1 loaded

[   32.660069] cx25840 0-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)

[   32.662409] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)

[   32.662430] wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)

[   32.877320] tuner-simple 0-0061: creating new instance

[   32.877324] tuner-simple 0-0061: type set to 50 (TCL 2002N)

[   32.878545] ivtv0: Registered device video0 for encoder MPG (4096 kB)

[   32.878564] ivtv0: Registered device video32 for encoder YUV (2048 kB)

[   32.878585] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)

[   32.878606] ivtv0: Registered device video24 for encoder PCM (320 kB)

[   32.878608] ivtv0: Initialized card #0: Hauppauge WinTV PVR-150

[   32.878622] ivtv:  End initialization

[   32.878728] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) ->
IRQ 16

[   32.878747] CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge
WinTV-HVR1800 [card=2,autodetected]

[   33.047755] cx23885[0]: i2c bus 0 registered

[   33.072606] tuner' 2-0042: chip found @ 0x84 (cx23885[0])

[   33.110360] tda829x 2-0042: could not clearly identify tuner address,
defaulting to 60

[   33.116934] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) ->
IRQ 22

[   33.116952] PCI: Setting latency timer of device 0000:00:1b.0 to 64

[   33.151842] tda18271 2-0060: creating new instance

[   33.184736] TDA18271HD/C1 detected @ 2-0060

[   34.351502] tda829x 2-0042: type set to tda8295+18271

[   35.456907] cx23885[0]: i2c bus 1 registered

[   35.457882] cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])

[   35.458252] cx23885[0]: i2c bus 2 registered

[   35.485029] tveeprom 1-0050: Hauppauge model 78521, rev C1E9, serial#
4851744

[   35.485031] tveeprom 1-0050: MAC address is 00-0D-FE-4A-08-20

[   35.485034] tveeprom 1-0050: tuner model is Philips 18271_8295 (idx 149,
type 54)

[   35.485036] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)

[   35.485038] tveeprom 1-0050: audio processor is CX23887 (idx 42)

[   35.485040] tveeprom 1-0050: decoder processor is CX23887 (idx 37)

[   35.485042] tveeprom 1-0050: has radio

[   35.485044] cx23885[0]: hauppauge eeprom: model=78521

[   35.488563] cx23885[0]/0: registered device video1 [v4l2]

[   37.182722] cx25840' 3-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)

[   37.196379] cx23885[0]: registered device video2 [mpeg]

[   37.196382] cx23885[0]: cx23885 based dvb card

[   37.273126] MT2131: successfully identified at address 0x61

[   37.273130] DVB: registering new adapter (cx23885[0])

[   37.273132] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...

[   37.273330] cx23885_dev_checkrevision() Hardware revision = 0xb1

[   37.273337] cx23885[0]/0: found at 0000:02:00.0, rev: 15, irq: 16,
latency: 0, mmio: 0xe9000000

[   37.273344] PCI: Setting latency timer of device 0000:02:00.0 to 64

 

As you can see I have two cards. First thing I have done is unload all the
tuner drivers, using make unload. Then reloaded the 1800 drivers via. 

 

modprobe cx25840 debug=1

modprobe cx23885 debug=1

 

Then tried a cat /dev/video1 > test.mpg. This resulted in nothing but a
black empty video. Weird thing is the dmesg output started outputting crazy
erros. Below: 

 

 [ 1400.099478] cx23885[0]/0: queue is not empty - append to active

[ 1400.099482] cx23885[0]/0: [e9d12540/22] cx23885_buf_queue - append to
active

[ 1400.110132] cx23885[0]/0: queue is not empty - append to active

[ 1400.110137] cx23885[0]/0: [e9d12900/23] cx23885_buf_queue - append to
active

[ 1400.158662] cx23885[0]/0: queue is not empty - append to active

[ 1400.158666] cx23885[0]/0: [e9f569c0/24] cx23885_buf_queue - append to
active

[ 1400.169318] cx23885[0]/0: queue is not empty - append to active

[ 1400.169323] cx23885[0]/0: [e9f560c0/25] cx23885_buf_queue - append to
active

[ 1400.181000] cx23885[0]/0: queue is not empty - append to active

[ 1400.181004] cx23885[0]/0: [e9f56a80/26] cx23885_buf_queue - append to
active

[ 1400.255398] cx23885[0]/0: queue is not empty - append to active

[ 1400.255403] cx23885[0]/0: [e9c79780/27] cx23885_buf_queue - append to
active

[ 1400.266050] cx23885[0]/0: queue is not empty - append to active

[ 1400.266055] cx23885[0]/0: [e9c79840/28] cx23885_buf_queue - append to
active

[ 1400.277940] cx23885[0]/0: queue is not empty - append to active

[ 1400.277944] cx23885[0]/0: [e9c79c00/29] cx23885_buf_queue - append to
active

[ 1400.780966] cx23885[0]/0: cx23885_cancel_buffers()

[ 1400.780973] cx23885[0]/0: cx23885_stop_dma()

[ 1400.781090] cx23885[0]/0: [e9c79480/31] cancel - dma=0x29db0000

[ 1400.781094] cx23885[0]/0: [e9c889c0/0] cancel - dma=0x238b1000

[ 1400.781097] cx23885[0]/0: [df8e9c00/1] cancel - dma=0x1fbb2000

[ 1400.781100] cx23885[0]/0: [df8e9cc0/2] cancel - dma=0x1fa81000

[ 1400.781104] cx23885[0]/0: [e9d3acc0/3] cancel - dma=0x29daa000

[ 1400.781107] cx23885[0]/0: [e9d3ad80/4] cancel - dma=0x23885000

[ 1400.781110] cx23885[0]/0: [e9d3aa80/5] cancel - dma=0x1f96c000

[ 1400.781113] cx23885[0]/0: [e9d3a780/6] cancel - dma=0x2391d000

[ 1400.781116] cx23885[0]/0: [e9d3a6c0/7] cancel - dma=0x23962000

[ 1400.781119] cx23885[0]/0: [e9d3a0c0/8] cancel - dma=0x2398f000

[ 1400.781122] cx23885[0]/0: [e9d3ae40/9] cancel - dma=0x37428000

[ 1400.781125] cx23885[0]/0: [e9d3a600/10] cancel - dma=0x29e67000

[ 1400.781128] cx23885[0]/0: [e9d3a300/11] cancel - dma=0x29d26000

[ 1400.781131] cx23885[0]/0: [e9d3a9c0/12] cancel - dma=0x239dd000

[ 1400.781134] cx23885[0]/0: [e9d3a540/13] cancel - dma=0x29fac000

[ 1400.781137] cx23885[0]/0: [e9d3ac00/14] cancel - dma=0x29e7f000

 

There were enough of these errors to fill up the scroll back buffer on
putty. 

 

I was wondering where I would go from here to try to help the developer's
figure out the issues with this card. I've been diving through the code, but
my C/C++ is 10 years rusty so it's slow going. 

 

Oh, and the drivers were pulled down as most recent an hour ago. 

 

Anyone that can point me in the right direction, I would appreciated it, I
have no problem getting my hands "dirty". 

 

Thanks.

Dustin Coates

[Dustin Coates] 

 

Ok to reply to my post. 

 

I reloaded the dirvers with debug=1 again. And I am getting this in dmesg. 

..

[ 7096.996487] tda829x 2-0042: could not clearly identify tuner address,
defaulting to 60

 

Don't know if the above is relivent 

..

[273587.699388] Firmware and/or mailbox pointer not initialized or
corrupted, signature = 0xfeffffff, cmd = PING_FW

[273754.893472] format_by_fourcc(0x32315559) NOT FOUND

[273754.893480] format_by_fourcc(0x50323234) NOT FOUND

[273777.997742] format_by_fourcc(0x32315559) NOT FOUND

[273777.997751] format_by_fourcc(0x50323234) NOT FOUND

..

 

Here is my lspci -vnn

 

02:00.0 Multimedia video controller [0400]: Conexant Unknown device
[14f1:8880] (rev 0f)

        Subsystem: Hauppauge computer works Inc. Unknown device [0070:7801]

        Flags: bus master, fast devsel, latency 0, IRQ 16

        Memory at e9000000 (64-bit, non-prefetchable) [size=2M]

        Capabilities: <access denied>

 

I really hope to get analogue resovled for this card..there are a lot of
owners of this card, that can't use them for the purpose they bought them..

 

I.E. http://ubuntuforums.org/showthread.php?t=785476 ten page topic begging
for support of this card. 

 

Recently I've had to tell people asking for opinion's of the HVR-1800 to go
with a different option since they need it for analogue support. Sorry for
being presistiant but I read in another email on the mailing list, that
presitiance helps. I've already offered several times that I'll help if
someone can point me in the right direction..

 

Keep up the good work.

 

Thanks

Dustin  


------=_NextPart_000_0001_01C921C6.9474E5E0
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
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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

<p class=3DMsoNormal><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt =
0in 0in 0in'>

<p class=3DMsoNormal><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>
linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] =
<b>On
Behalf Of </b>Dustin Coates<br>
<b>Sent:</b> Thursday, September 25, 2008 7:36 PM<br>
<b>To:</b> linux-dvb@linuxtv.org<br>
<b>Subject:</b> [linux-dvb] HVR-1800 Analouge =
Issues<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Hi Everyone, <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Ok I&#8217;ve recently decided to start seeing if I can figure out the =
issue
with the Analouge, on this card, first my normal dmesg.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.347715] Linux video capture =
interface:
v2.00<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.445802] ivtv:&nbsp; Start =
initialization, version
1.4.0<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.445864] ivtv0: Initializing card =
#0<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.445867] ivtv0: Autodetected =
Hauppauge card
(cx23416 based)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.446300] ACPI: PCI Interrupt =
0000:05:01.0[A]
-&gt; GSI 19 (level, low) -&gt; IRQ 21<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.446310] ivtv0: Unreasonably low =
latency timer,
setting to 64 (was 32)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499240] tveeprom 0-0050: Hauppauge =
model
26582, rev E6B2, serial# 10301641<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499244] tveeprom 0-0050: tuner =
model is TCL
M2523_5N_E (idx 112, type 50)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499246] tveeprom 0-0050: TV =
standards
NTSC(M) (eeprom 0x08)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499248] tveeprom 0-0050: audio =
processor is
CX25843 (idx 37)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499250] tveeprom 0-0050: decoder =
processor
is CX25843 (idx 30)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499252] tveeprom 0-0050: has no =
radio<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.499255] ivtv0: Autodetected =
Hauppauge WinTV
PVR-150<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.574169] cx23885 driver version =
0.0.1 loaded<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.660069] cx25840 0-0044: cx25843-24 =
found @
0x88 (ivtv i2c driver #0)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.662409] tuner 0-0061: chip found @ =
0xc2
(ivtv i2c driver #0)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.662430] wm8775 0-001b: chip found =
@ 0x36
(ivtv i2c driver #0)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.877320] tuner-simple 0-0061: =
creating new
instance<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.877324] tuner-simple 0-0061: type =
set to 50
(TCL 2002N)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878545] ivtv0: Registered device =
video0 for
encoder MPG (4096 kB)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878564] ivtv0: Registered device =
video32
for encoder YUV (2048 kB)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878585] ivtv0: Registered device =
vbi0 for
encoder VBI (1024 kB)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878606] ivtv0: Registered device =
video24
for encoder PCM (320 kB)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878608] ivtv0: Initialized card =
#0:
Hauppauge WinTV PVR-150<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878622] ivtv:&nbsp; End =
initialization<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878728] ACPI: PCI Interrupt =
0000:02:00.0[A]
-&gt; GSI 16 (level, low) -&gt; IRQ 16<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 32.878747] CORE cx23885[0]: =
subsystem:
0070:7801, board: Hauppauge WinTV-HVR1800 =
[card=3D2,autodetected]<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.047755] cx23885[0]: i2c bus 0 =
registered<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.072606] tuner' 2-0042: chip found =
@ 0x84
(cx23885[0])<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.110360] tda829x 2-0042: could not =
clearly
identify tuner address, defaulting to 60<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.116934] ACPI: PCI Interrupt =
0000:00:1b.0[A]
-&gt; GSI 22 (level, low) -&gt; IRQ 22<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.116952] PCI: Setting latency timer =
of
device 0000:00:1b.0 to 64<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.151842] tda18271 2-0060: creating =
new
instance<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 33.184736] TDA18271HD/C1 detected @ =
2-0060<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 34.351502] tda829x 2-0042: type set =
to
tda8295+18271<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.456907] cx23885[0]: i2c bus 1 =
registered<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.457882] cx25840' 3-0044: =
cx25&nbsp; 0-21
found @ 0x88 (cx23885[0])<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.458252] cx23885[0]: i2c bus 2 =
registered<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485029] tveeprom 1-0050: Hauppauge =
model
78521, rev C1E9, serial# 4851744<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485031] tveeprom 1-0050: MAC =
address is
00-0D-FE-4A-08-20<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485034] tveeprom 1-0050: tuner =
model is
Philips 18271_8295 (idx 149, type 54)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485036] tveeprom 1-0050: TV =
standards
NTSC(M) ATSC/DVB Digital (eeprom 0x88)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485038] tveeprom 1-0050: audio =
processor is
CX23887 (idx 42)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485040] tveeprom 1-0050: decoder =
processor
is CX23887 (idx 37)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485042] tveeprom 1-0050: has =
radio<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.485044] cx23885[0]: hauppauge =
eeprom:
model=3D78521<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 35.488563] cx23885[0]/0: registered =
device
video1 [v4l2]<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.182722] cx25840' 3-0044: loaded =
v4l-cx23885-avcore-01.fw
firmware (16382 bytes)<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.196379] cx23885[0]: registered =
device
video2 [mpeg]<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.196382] cx23885[0]: cx23885 based =
dvb card<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273126] MT2131: successfully =
identified at
address 0x61<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273130] DVB: registering new =
adapter
(cx23885[0])<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273132] DVB: registering frontend =
0
(Samsung S5H1409 QAM/8VSB Frontend)...<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273330] =
cx23885_dev_checkrevision()
Hardware revision =3D 0xb1<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273337] cx23885[0]/0: found at
0000:02:00.0, rev: 15, irq: 16, latency: 0, mmio: =
0xe9000000<o:p></o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp; 37.273344] PCI: Setting latency timer =
of
device 0000:02:00.0 to 64<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>As you can see I have two cards. First thing I have =
done is
unload all the tuner drivers, using make unload. Then reloaded the 1800 =
drivers
via. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><i><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>modprobe
cx25840 debug=3D1<o:p></o:p></span></i></p>

<p class=3DMsoNormal><i><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>modprobe
cx23885 debug=3D1<o:p></o:p></span></i></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Then tried a cat /dev/video1 &gt; test.mpg. This =
resulted in
nothing but a black empty video. Weird thing is the dmesg output started
outputting crazy erros. Below: <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>&nbsp;[ 1400.099478] cx23885[0]/0: queue is not =
empty -
append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.099482] cx23885[0]/0: [e9d12540/22] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.110132] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.110137] cx23885[0]/0: [e9d12900/23] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.158662] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.158666] cx23885[0]/0: [e9f569c0/24] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.169318] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.169323] cx23885[0]/0: [e9f560c0/25] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.181000] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.181004] cx23885[0]/0: [e9f56a80/26] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.255398] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.255403] cx23885[0]/0: [e9c79780/27] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.266050] cx23885[0]/0: queue is not empty - =
append to
active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.266055] cx23885[0]/0: [e9c79840/28] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.277940] cx23885[0]/0: queue is not empty - =
append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.277944] cx23885[0]/0: [e9c79c00/29] =
cx23885_buf_queue
- append to active<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.780966] cx23885[0]/0: =
cx23885_cancel_buffers()<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.780973] cx23885[0]/0: =
cx23885_stop_dma()<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781090] cx23885[0]/0: [e9c79480/31] cancel -
dma=3D0x29db0000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781094] cx23885[0]/0: [e9c889c0/0] cancel -
dma=3D0x238b1000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781097] cx23885[0]/0: [df8e9c00/1] cancel -
dma=3D0x1fbb2000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781100] cx23885[0]/0: [df8e9cc0/2] cancel -
dma=3D0x1fa81000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781104] cx23885[0]/0: [e9d3acc0/3] cancel -
dma=3D0x29daa000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781107] cx23885[0]/0: [e9d3ad80/4] cancel -
dma=3D0x23885000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781110] cx23885[0]/0: [e9d3aa80/5] cancel -
dma=3D0x1f96c000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781113] cx23885[0]/0: [e9d3a780/6] cancel - =
dma=3D0x2391d000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781116] cx23885[0]/0: [e9d3a6c0/7] cancel -
dma=3D0x23962000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781119] cx23885[0]/0: [e9d3a0c0/8] cancel -
dma=3D0x2398f000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781122] cx23885[0]/0: [e9d3ae40/9] cancel -
dma=3D0x37428000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781125] cx23885[0]/0: [e9d3a600/10] cancel -
dma=3D0x29e67000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781128] cx23885[0]/0: [e9d3a300/11] cancel -
dma=3D0x29d26000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781131] cx23885[0]/0: [e9d3a9c0/12] cancel -
dma=3D0x239dd000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781134] cx23885[0]/0: [e9d3a540/13] cancel -
dma=3D0x29fac000<o:p></o:p></p>

<p class=3DMsoNormal>[ 1400.781137] cx23885[0]/0: [e9d3ac00/14] cancel -
dma=3D0x29e7f000<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>There were enough of these errors to fill up the =
scroll back
buffer on putty. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I was wondering where I would go from here to try =
to help
the developer&#8217;s figure out the issues with this card. I&#8217;ve =
been
diving through the code, but my C/C++ is 10 years rusty so it&#8217;s =
slow
going. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Oh, and the drivers were pulled down as most recent =
an hour
ago. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Anyone that can point me in the right direction, I =
would
appreciated it, I have no problem getting my hands &#8220;dirty&#8221;. =
<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks.<o:p></o:p></p>

<p class=3DMsoNormal>Dustin Coates<span =
style=3D'color:#1F497D'><o:p></o:p></span></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[Dustin Coates] =
<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Ok to reply to =
my post. <o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>I reloaded the =
dirvers
with debug=3D1 again. And I am getting this in dmesg. =
<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&#8230;.<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[ 7096.996487] =
tda829x
2-0042: could not clearly identify tuner address, defaulting to =
60<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Don&#8217;t =
know if the
above is relivent <o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&#8230;.<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[273587.699388] =
Firmware
and/or mailbox pointer not initialized or corrupted, signature =3D =
0xfeffffff,
cmd =3D PING_FW<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[273754.893472]
format_by_fourcc(0x32315559) NOT FOUND<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[273754.893480]
format_by_fourcc(0x50323234) NOT FOUND<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[273777.997742]
format_by_fourcc(0x32315559) NOT FOUND<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>[273777.997751]
format_by_fourcc(0x50323234) NOT FOUND<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&#8230;.<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Here is my =
lspci &#8211;vnn<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>02:00.0 =
Multimedia video
controller [0400]: Conexant Unknown device [14f1:8880] (rev =
0f)<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Subsystem: Hauppauge computer works Inc. Unknown device =
[0070:7801]<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Flags: bus master, fast devsel, latency 0, IRQ =
16<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Memory at e9000000 (64-bit, non-prefetchable) =
[size=3D2M]<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Capabilities: &lt;access denied&gt;<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>I really hope =
to get analogue
resovled for this card&#8230;.there are a lot of owners of this card, =
that can&#8217;t
use them for the purpose they bought =
them&#8230;.<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>I.E. <a
href=3D"http://ubuntuforums.org/showthread.php?t=3D785476">http://ubuntuf=
orums.org/showthread.php?t=3D785476</a>
ten page topic begging for support of this card. =
<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Recently =
I&#8217;ve had to
tell people asking for opinion&#8217;s of the HVR-1800 to go with a =
different
option since they need it for analogue support. Sorry for being =
presistiant but
I read in another email on the mailing list, that presitiance helps. =
I&#8217;ve
already offered several times that I&#8217;ll help if someone can point =
me in
the right direction&#8230;.<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Keep up the =
good work&#8230;<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span =
style=3D'color:#1F497D'>Thanks<o:p></o:p></span></i></b></p>

<p class=3DMsoNormal><b><i><span style=3D'color:#1F497D'>Dustin =
&nbsp;<o:p></o:p></span></i></b></p>

</div>

</body>

</html>

------=_NextPart_000_0001_01C921C6.9474E5E0--



--===============1620105866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1620105866==--
