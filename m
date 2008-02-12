Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtpi1.ngi.it ([88.149.128.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eddi@depieri.net>) id 1JOspR-0008WD-UU
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 11:57:34 +0100
From: "Eddi" <eddi@depieri.net>
To: "'Craig Whitmore'" <lennon@orcon.net.nz>,
	"'linux-dvb'" <linux-dvb@linuxtv.org>
Date: Tue, 12 Feb 2008 11:56:54 +0100
MIME-Version: 1.0
In-Reply-To: <C36C2AD2C1B74AA98CA40F6A1C0644EF@CraigPC>
Message-Id: <20080212105656.46E402183E4@tux.dpeddi.com>
Subject: [linux-dvb] R:  Multi Frontend Drivers for HVR4000 (And others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0293101107=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0293101107==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000F_01C86D6E.5C741240"

This is a multi-part message in MIME format.

------=_NextPart_000_000F_01C86D6E.5C741240
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Vdr don=92t allocate a device if its device is locked or busy

=20

Try my patch for hvr3000/flydvb trio

http://tux.dpeddi.com/lr319sta/

http://tux.dpeddi.com/lr319sta/downloads/vdr_1.4.5_eddi-multiple-frontend=
_v5
.patch

=20

it isn=92t perfect but should overcome this problem.

=20

Eddi

=20

  _____ =20

Da: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] =
Per
conto di Craig Whitmore
Inviato: marted=EC 12 febbraio 2008 1.52
A: linux-dvb
Oggetto: [linux-dvb] Multi Frontend Drivers for HVR4000 (And others)

=20

I've been playing with the latest http://dev.kewl.org/hauppauge/ drivers
(Multi frontend Support) for the HVR4000
(http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff)
<http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff)%20and>  and =
they
seem to work well.  I can use either DVB-S or DVB-T (via mythtv and swap
easily between them) (butt not use them at the same time which is just a
limitation of the device)

=20

But a couple of problems.

Not many programs support the multifrontend as of yet. Like the biggest =
one
Mythtv :-)

You have to do the below so it sees two cards

=20

mkdir /dev/dvb/adapter1

ln -s /dev/dvb/adapter1/frontend1 /dev/dvb/adapter1/frontend0

ln -s /dev/dvb/adapter1/net1 /dev/dvb/adapter1/net0

ln -s /dev/dvb/adapter1/dvr1 /dev/dvb/adapter1/dvr0

ln -s /dev/dvb/adapter1/demux1 /dev/dvb/adapter1/demux0

=20

Analog TV Tuning Stops working after you 1st use the DVB-T or DVB-S =
device

=20

a few i2c errors when it first boots up.

=20

tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...

it says registering frontend 0 both times, but thats just cosmetic and
should easily be fixed

=20

dmesg

-------------------

cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000
DVB-S/S2/T/Hybrid [card=3D59,autodetected], frontend(s): 2
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx2388x alsa driver version 0.0.6 loaded
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tveeprom 2-0050: Hauppauge model 69009, rev B2D3, serial# 2807241
tveeprom 2-0050: MAC address is 00-0D-FE-2A-D5-C9
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 2-0050: audio processor is CX882 (idx 33)
tveeprom 2-0050: decoder processor is CX882 (idx 25)
tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=3D69009
input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input3
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:04:08.2[A] -> Link [APC1] -> GSI 16 (level, =
low) ->
IRQ 21
cx88[0]/2: found at 0000:04:08.2, rev: 5, irq: 21, latency: 32, mmio:
0xf8000000
cx8802_probe() allocating 2 frontend(s)
ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, =
low) ->
IRQ 21
cx88[0]/0: found at 0000:04:08.0, rev: 5, irq: 21, latency: 32, mmio:
0xfa000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000
DVB-S/S2/T/Hybrid [card=3D59]
cx88[0]/2: cx2388x based DVB/ATSC card
tuner' 2-0043: chip found @ 0x86 (cx88[0])
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner' 2-0063: chip found @ 0xc6 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, =
low) ->
IRQ 17
tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.20.79.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.20.79.0
cx24116_firmware_ondemand: Firmware upload complete
------------------

=20

Thanks

=20

=20


------=_NextPart_000_000F_01C86D6E.5C741240
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:blue;
	text-decoration:underline;}
span.StileMessaggioDiPostaElettronica17
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 2.0cm 2.0cm 2.0cm;}
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

<body bgcolor=3Dwhite lang=3DIT link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Vdr don&#8217;t allocate a device =
if its
device is locked or busy<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Try my patch for hvr3000/flydvb =
trio<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>http://tux.dpeddi.com/lr319sta/<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><a
href=3D"http://tux.dpeddi.com/lr319sta/downloads/vdr_1.4.5_eddi-multiple-=
frontend_v5.patch">http://tux.dpeddi.com/lr319sta/downloads/vdr_1.4.5_edd=
i-multiple-frontend_v5.patch</a><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>it isn&#8217;t perfect but should =
overcome
this problem.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Eddi<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;
font-family:Tahoma;font-weight:bold'>Da:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] =
<b><span
style=3D'font-weight:bold'>Per conto di </span></b>Craig Whitmore<br>
<b><span style=3D'font-weight:bold'>Inviato:</span></b> marted=EC 12 =
febbraio 2008
1.52<br>
<b><span style=3D'font-weight:bold'>A:</span></b> linux-dvb<br>
<b><span style=3D'font-weight:bold'>Oggetto:</span></b> [linux-dvb] =
Multi
Frontend Drivers for HVR4000 (And others)</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I've been playing with the latest <a
href=3D"http://dev.kewl.org/hauppauge/">http://dev.kewl.org/hauppauge/</a=
>&nbsp;drivers
(Multi frontend Support) for the HVR4000 (<a
href=3D"http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff)%20and">=
http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff)
and</a> they seem to work well.&nbsp; I can use either DVB-S or DVB-T =
(via
mythtv and swap easily between them) (butt not use them at the same time =
which
is just a limitation of the device)</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>But a couple of =
problems.</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Not many programs support the multifrontend as of =
yet. Like
the biggest one Mythtv :-)</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>You have to do the below so it sees two =
cards</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>mkdir /dev/dvb/adapter1</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ln -s /dev/dvb/adapter1/frontend1
/dev/dvb/adapter1/frontend0</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ln -s /dev/dvb/adapter1/net1 =
/dev/dvb/adapter1/net0</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ln -s /dev/dvb/adapter1/dvr1 =
/dev/dvb/adapter1/dvr0</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ln -s /dev/dvb/adapter1/demux1 =
/dev/dvb/adapter1/demux0</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Analog TV Tuning Stops working after you 1st use the =
DVB-T
or DVB-S device</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>a few i2c errors when it first boots =
up.</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should =
be 4)<br>
DVB: registering new adapter (cx88[0])<br>
DVB: registering frontend 0 (Conexant CX24116/CX24118)...<br>
DVB: registering frontend 0 (Conexant CX22702 =
DVB-T)...</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>it says registering frontend 0 both times, but thats =
just
cosmetic and should easily be fixed</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>dmesg</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>-------------------</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 =
loaded<br>
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 =
DVB-S/S2/T/Hybrid
[card=3D59,autodetected], frontend(s): 2<br>
cx88[0]: TV tuner type 63, Radio tuner type -1<br>
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<br>
cx2388x alsa driver version 0.0.6 loaded<br>
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner<br>
tveeprom 2-0050: Hauppauge model 69009, rev B2D3, serial# 2807241<br>
tveeprom 2-0050: MAC address is 00-0D-FE-2A-D5-C9<br>
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type =
63)<br>
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) =
ATSC/DVB
Digital (eeprom 0xf4)<br>
tveeprom 2-0050: audio processor is CX882 (idx 33)<br>
tveeprom 2-0050: decoder processor is CX882 (idx 25)<br>
tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter<br>
cx88[0]: hauppauge eeprom: model=3D69009<br>
input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input3<br>
cx88[0]/2: cx2388x 8802 Driver Manager<br>
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16<br>
ACPI: PCI Interrupt 0000:04:08.2[A] -&gt; Link [APC1] -&gt; GSI 16 =
(level, low)
-&gt; IRQ 21<br>
cx88[0]/2: found at 0000:04:08.2, rev: 5, irq: 21, latency: 32, mmio:
0xf8000000<br>
cx8802_probe() allocating 2 frontend(s)<br>
ACPI: PCI Interrupt 0000:04:08.0[A] -&gt; Link [APC1] -&gt; GSI 16 =
(level, low)
-&gt; IRQ 21<br>
cx88[0]/0: found at 0000:04:08.0, rev: 5, irq: 21, latency: 32, mmio:
0xfa000000<br>
cx88/2: cx2388x dvb driver version 0.0.6 loaded<br>
cx88/2: registering cx8802 driver, type: dvb access: shared<br>
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000
DVB-S/S2/T/Hybrid [card=3D59]<br>
cx88[0]/2: cx2388x based DVB/ATSC card<br>
tuner' 2-0043: chip found @ 0x86 (cx88[0])<br>
tda9887 2-0043: tda988[5/6/7] found<br>
tuner' 2-0061: chip found @ 0xc2 (cx88[0])<br>
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid =
Tuner)<br>
tuner' 2-0063: chip found @ 0xc6 (cx88[0])<br>
cx88[0]/0: registered device video0 [v4l2]<br>
cx88[0]/0: registered device vbi0<br>
cx88[0]/0: registered device radio0<br>
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards<br>
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22<br>
ACPI: PCI Interrupt 0000:00:10.1[B] -&gt; Link [AAZA] -&gt; GSI 22 =
(level, low)
-&gt; IRQ 17<br>
tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be 4)<br>
DVB: registering new adapter (cx88[0])<br>
DVB: registering frontend 0 (Conexant CX24116/CX24118)...<br>
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...<br>
cx24116_firmware_ondemand: Waiting for firmware upload =
(dvb-fe-cx24116.fw)...<br>
cx24116_firmware_ondemand: Waiting for firmware upload(2)...<br>
cx24116_load_firmware: FW version 1.20.79.0<br>
cx24116_firmware_ondemand: Firmware upload complete<br>
cx24116_firmware_ondemand: Waiting for firmware upload =
(dvb-fe-cx24116.fw)...<br>
cx24116_firmware_ondemand: Waiting for firmware upload(2)...<br>
cx24116_load_firmware: FW version 1.20.79.0<br>
cx24116_firmware_ondemand: Firmware upload complete<br>
------------------</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

</div>

</body>

</html>

------=_NextPart_000_000F_01C86D6E.5C741240--



--===============0293101107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0293101107==--
