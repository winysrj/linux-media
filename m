Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <alex.petri@gmx.de>) id 1JjDoN-0000gL-7s
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 15:24:33 +0200
From: "Alexander Petri" <alex.petri@gmx.de>
To: <linux-dvb@linuxtv.org>
References: 
In-Reply-To: 
Date: Tue, 8 Apr 2008 15:23:53 +0200
Message-ID: <003601c8997b$cad6c8c0$60845a40$@petri@gmx.de>
MIME-Version: 1.0
Content-Language: de
Subject: Re: [linux-dvb] [ubuntu 7.10] Typhoon DVB-T Stick => wrong firmware?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1569323545=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dies ist eine mehrteilige Nachricht im MIME-Format.

--===============1569323545==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0037_01C8998C.8E5F98C0"
Content-Language: de

Dies ist eine mehrteilige Nachricht im MIME-Format.

------=_NextPart_000_0037_01C8998C.8E5F98C0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Has no one any suggestion for me?

=20

Von: Alexander Petri [mailto:alex.petri@gmx.de]=20
Gesendet: Dienstag, 25. M=E4rz 2008 23:11
An: 'linux-dvb@linuxtv.org'
Betreff: [ubuntu 7.10] Typhoon DVB-T Stick =3D> wrong firmware?

=20

Hi,
ich have some Troubles brining my Typhoon DVB-T USB to work:
i called the following:

=20


xysfsdf@asdf:~$ lsusb

Bus 001 Device 001: ID 0000:0000

Bus 005 Device 003: ID eb1a:e361 eMPIA Technology, Inc.

Bus 005 Device 001: ID 0000:0000

Bus 004 Device 001: ID 0000:0000

Bus 003 Device 001: ID 0000:0000

Bus 002 Device 001: ID 0000:0000

xysfsdf@asdf:~$ dmesg | grep dvb

[ 9380.608000] dvb-usb: found a 'MSI Digivox Mini SL' in cold state, =
will
try to load a firmware

[ 9380.744000] dvb-usb: downloading firmware from file
'dvb-usb-dibusb-6.0.0.8.fw'

[ 9380.808000] usbcore: registered new interface driver =
dvb_usb_dibusb_mc

[ 9380.812000] dvb-usb: generic DVB-USB module successfully =
deinitialized
and disconnected.

[ 9382.704000] dvb-usb: found a 'MSI Digivox Mini SL' in warm state.

[ 9382.704000] dvb-usb: will pass the complete MPEG2 transport stream to =
the
software demuxer.

[ 9383.360000] dvb-usb: schedule remote query interval to 150 msecs.

[ 9383.360000] dvb-usb: MSI Digivox Mini SL successfully initialized and
connected.

xysfsdf@asdf:~$ dmesg | grep DVB

[ 9380.812000] dvb-usb: generic DVB-USB module successfully =
deinitialized
and disconnected.

[ 9382.708000] DVB: registering new adapter (MSI Digivox Mini SL).

[ 9382.712000] DVB: registering frontend 0 (DiBcom 3000MC/P)...

[ 9383.360000] input: IR-receiver inside an USB DVB receiver as
/class/input/input4

=20

As you can see ubuntu shows me that there is as MSI Digivox MiniSL

So I guess the wrong firmware is loaded..

If I scan for channels I get this output

=20


xysfsdf@asdf:~$ scan -c

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

dumping lists (0 services)

Done.

Also the following could be useful:


x@x-desktop:~$ tail -f /var/log/messages

Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] usb 5-2: configuration =
#1
chosen from 1 choice

Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: found a 'MSI
Digivox Mini SL' in warm state.

Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.

Mar 25 21:00:41 x-desktop kernel: [ 9382.708000] DVB: registering new
adapter (MSI Digivox Mini SL).

Mar 25 21:00:41 x-desktop kernel: [ 9382.712000] DVB: registering =
frontend 0
(DiBcom 3000MC/P)...

Mar 25 21:00:41 x-desktop kernel: [ 9382.900000] MT2060: successfully
identified (IF1 =3D 1220)

Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] input: IR-receiver =
inside
an USB DVB receiver as /class/input/input4

Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: schedule =
remote
query interval to 150 msecs.

Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: MSI Digivox =
Mini
SL successfully initialized and connected.

Mar 25 21:24:59 x-desktop -- MARK --

=20

How can i force ubuntu to use the right firmware? Or is there the =
digivox
chip inside the typhoon box?

How can I use my Stick? Why cant I scan for channels?

=20

Thx for any comment.


------=_NextPart_000_0037_01C8998C.8E5F98C0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>

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
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
h3
	{mso-style-priority:9;
	mso-style-link:"=DCberschrift 3 Zchn";
	mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:13.5pt;
	font-family:"Times New Roman","serif";}
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
	mso-style-link:"HTML Vorformatiert Zchn";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Sprechblasentext Zchn";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.berschrift3Zchn
	{mso-style-name:"=DCberschrift 3 Zchn";
	mso-style-priority:9;
	mso-style-link:"=DCberschrift 3";
	font-family:"Times New Roman","serif";
	font-weight:bold;}
span.HTMLVorformatiertZchn
	{mso-style-name:"HTML Vorformatiert Zchn";
	mso-style-priority:99;
	mso-style-link:"HTML Vorformatiert";
	font-family:"Courier New";}
span.SprechblasentextZchn
	{mso-style-name:"Sprechblasentext Zchn";
	mso-style-priority:99;
	mso-style-link:Sprechblasentext;
	font-family:"Tahoma","sans-serif";}
span.E-MailFormatvorlage22
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.E-MailFormatvorlage23
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
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

<body lang=3DDE link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Has no one any =
suggestion for
me?<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span></p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt =
0cm 0cm 0cm'>

<p class=3DMsoNormal><b><span =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>Von:</span><=
/b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'> Alexander =
Petri
[mailto:alex.petri@gmx.de] <br>
<b>Gesendet:</b> Dienstag, 25. M=E4rz 2008 23:11<br>
<b>An:</b> 'linux-dvb@linuxtv.org'<br>
<b>Betreff:</b> [ubuntu 7.10] Typhoon DVB-T Stick =3D&gt; wrong =
firmware?<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>Hi,<br>
ich have some Troubles brining my Typhoon DVB-T USB to work:<br>
i called the following:<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New =
Roman","serif"'><o:p>&nbsp;</o:p></span></p>

<table class=3DMsoNormalTable border=3D0 cellpadding=3D0>
 <tr>
  <td style=3D'padding:.75pt .75pt .75pt .75pt'>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>xysfsdf@asdf:~$
  lsusb<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  001 Device 001: ID 0000:0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  005 Device 003: ID eb1a:e361 eMPIA Technology, =
Inc.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  005 Device 001: ID 0000:0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  004 Device 001: ID 0000:0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  003 Device 001: ID 0000:0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Bus
  002 Device 001: ID 0000:0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>xysfsdf@asdf:~$
  dmesg | grep dvb<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9380.608000] dvb-usb: found a 'MSI Digivox Mini SL' in cold state, =
will try
  to load a firmware<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9380.744000] dvb-usb: downloading firmware from file
  'dvb-usb-dibusb-6.0.0.8.fw'<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9380.808000] usbcore: registered new interface driver =
dvb_usb_dibusb_mc<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9380.812000] dvb-usb: generic DVB-USB module successfully =
deinitialized and
  disconnected.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9382.704000] dvb-usb: found a 'MSI Digivox Mini SL' in warm =
state.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9382.704000] dvb-usb: will pass the complete MPEG2 transport stream to =
the
  software demuxer.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9383.360000] dvb-usb: schedule remote query interval to 150 =
msecs.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9383.360000] dvb-usb: MSI Digivox Mini SL successfully initialized and
  connected.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>xysfsdf@asdf:~$
  dmesg | grep DVB<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9380.812000] dvb-usb: generic DVB-USB module successfully =
deinitialized and
  disconnected.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9382.708000] DVB: registering new adapter (MSI Digivox Mini =
SL).<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9382.712000] DVB: registering frontend 0 (DiBcom =
3000MC/P)...<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>[
  9383.360000] input: IR-receiver inside an USB DVB receiver as
  /class/input/input4<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New =
Roman","serif"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>As
you can see ubuntu shows me that there is as MSI Digivox =
MiniSL<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>So
I guess the wrong firmware is loaded..<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>If
I scan for channels I get this output<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:12.0pt;font-family:"Times New =
Roman","serif"'><o:p>&nbsp;</o:p></span></p>

<table class=3DMsoNormalTable border=3D0 cellpadding=3D0>
 <tr>
  <td style=3D'padding:.75pt .75pt .75pt .75pt'>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>xysfsdf@asdf:~$
  scan -c<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>using
  '/dev/dvb/adapter0/frontend0' and =
'/dev/dvb/adapter0/demux0'<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>WARNING:
  filter timeout pid 0x0011<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>WARNING:
  filter timeout pid 0x0000<o:p></o:p></span></p>
  <p class=3DMsoNormal><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>dumping
  lists (0 services)<o:p></o:p></span></p>
  <p class=3DMsoNormal><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Done.<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><span lang=3DEN-US
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>Also =
the
following could be useful:<o:p></o:p></span></p>

<table class=3DMsoNormalTable border=3D0 cellpadding=3D0>
 <tr>
  <td style=3D'padding:.75pt .75pt .75pt .75pt'>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>x@x-desktop:~$
  tail -f /var/log/messages<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] usb 5-2: configuration #1 =
chosen
  from 1 choice<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: found a 'MSI =
Digivox Mini
  SL' in warm state.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: will pass the =
complete
  MPEG2 transport stream to the software demuxer.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.708000] DVB: registering new =
adapter
  (MSI Digivox Mini SL).<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.712000] DVB: registering frontend =
0
  (DiBcom 3000MC/P)...<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:41 x-desktop kernel: [ 9382.900000] MT2060: successfully =
identified
  (IF1 =3D 1220)<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] input: IR-receiver inside =
an USB
  DVB receiver as /class/input/input4<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: schedule remote =
query
  interval to 150 msecs.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: MSI Digivox Mini =
SL
  successfully initialized and connected.<o:p></o:p></span></p>
  <p class=3DMsoNormal><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Mar
  25 21:24:59 x-desktop -- MARK --<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span lang=3DEN-US>How can i force ubuntu to use =
the right
firmware? Or is there the digivox chip inside the typhoon =
box?<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>How can I use my Stick? Why cant =
I scan for
channels?<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Thx for any =
comment.<o:p></o:p></span></p>

</div>

</body>

</html>

------=_NextPart_000_0037_01C8998C.8E5F98C0--



--===============1569323545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1569323545==--
