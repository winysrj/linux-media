Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <aslam@hcscomm.com>) id 1Nh0yc-0008Kt-Hj
	for linux-dvb@linuxtv.org; Mon, 15 Feb 2010 14:27:03 +0100
Received: from [82.205.218.163] (helo=alhimss.alhgroup.net)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nh0ya-0006Qa-PJ; Mon, 15 Feb 2010 14:27:02 +0100
From: Aslam Mullapilly <aslam@hcscomm.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Mon, 15 Feb 2010 16:26:50 +0300
Message-ID: <425356A9213FA046A466287AF4E18B193E7A7A9874@ALH-MAIL.alhgroup.net>
Content-Language: en-US
MIME-Version: 1.0
Subject: [linux-dvb] DVB STREAM mult channels
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1074023778=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1074023778==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_425356A9213FA046A466287AF4E18B193E7A7A9874ALHMAILalhgro_"


--_000_425356A9213FA046A466287AF4E18B193E7A7A9874ALHMAILalhgro_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Let me explain my problem.

Stream is working only in UDP. If I run it on RTP, the picture is getting c=
orrectly. It is freezing.

I run the command and getting following output:-

DVB# dvbstream -f 11938 -p V -s 27500 -c 0 -udp -r 1234 4151 4152 -ps
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 11938 Hz
Using DVB card "ST STV0299 DVB-S", freq=3D11938
tuning DVB-S to Freq: 1338000, Pol:V Srate=3D27500000, 22kHz tone=3Doff, LN=
B: 0
Setting only tone ON and voltage 13V
DISEQC SETTING SUCCEDED
Getting frontend status
Event:  Frequency: 11938714
        SymbolRate: 27500000
        FEC_inner:  3

Bit error rate: 5777
Signal strength: 47278
SNR: 48021
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_S=
YNC
dvbstream will stop after -1 seconds (71582788 minutes)
Using 224.0.1.2:1234:2
version=3D2
Streaming 2 streams
Audiostream: Layer: 1  Bit rate: free  Freq: 0.0 kHz
Videostream: ASPECT: 4:3  Size =3D 704x576  FRate: 25 fps  BRate: 15.00 Mbi=
t/s


This is working perfectly and I can see the channels in LAN with vlc.

When I give multiple pid, I'm getting the error like this.
 # dvbstream -f 11938 -p V -s 27500 -udp -net 224.0.1.2:1234 4011 4012 4021=
 4022 4031 4032
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 11938 Hz
Using DVB card "ST STV0299 DVB-S", freq=3D11938
tuning DVB-S to Freq: 1338000, Pol:V Srate=3D27500000, 22kHz tone=3Doff, LN=
B: 0
Setting only tone ON and voltage 13V
DISEQC SETTING SUCCEDED
Getting frontend status
Event:  Frequency: 11938713
        SymbolRate: 27500000
        FEC_inner:  3

Bit error rate: 18576
Signal strength: 47555
SNR: 48072
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_S=
YNC

MAP 0, addr 224.0.1.2:1234 From -1 secs, To -1 secs, 6 PIDs -  4011 4012 40=
21 4022 4031 4032
dvbstream will stop after -1 seconds (71582788 minutes)
Streaming 6 streams


But no channels are coming.

Also in first option without -ps, it is freezing and not clear.


Please help me.

Aslam


--_000_425356A9213FA046A466287AF4E18B193E7A7A9874ALHMAILalhgro_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
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

<p class=3DMsoNormal>Hi,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Let me explain my problem.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Stream is working only in UDP. If I run it on RTP, the=
 picture
is getting correctly. It is freezing.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I run the command and getting following output:-<o:p><=
/o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span style=3D'color:red'>DVB# dvbstream -f 11938 -p V=
 -s
27500 -c 0 -udp -r 1234 4151 4152 -ps<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>dvbstream v0.6 - (C) Dave Ch=
apman
2001-2004<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Released under the GPL.<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Latest version available fro=
m
http://www.linuxstb.org/<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Tuning to 11938 Hz<o:p></o:p=
></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Using DVB card &quot;ST STV0=
299
DVB-S&quot;, freq=3D11938<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>tuning DVB-S to Freq: 133800=
0, Pol:V
Srate=3D27500000, 22kHz tone=3Doff, LNB: 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Setting only tone ON and vol=
tage 13V<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>DISEQC SETTING SUCCEDED<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Getting frontend status<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Event:&nbsp; Frequency: 1193=
8714<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>&nbsp; &nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;SymbolRate:
27500000<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;
FEC_inner:&nbsp; 3<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Bit error rate: 5777<o:p></o=
:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Signal strength: 47278<o:p><=
/o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>SNR: 48021<o:p></o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:red'>FE_STATUS: FE_HAS_SIGNAL FE_=
HAS_LOCK
FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>dvbstream will stop after -1=
 seconds
(71582788 minutes)<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Using 224.0.1.2:1234:2<o:p><=
/o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>version=3D2<o:p></o:p></span=
></p>

<p class=3DMsoNormal><span style=3D'color:red'>Streaming 2 streams<o:p></o:=
p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Audiostream: Layer: 1&nbsp; =
Bit
rate: free&nbsp; Freq: 0.0 kHz<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Videostream: ASPECT: 4:3&nbs=
p; Size
=3D 704x576&nbsp; FRate: 25 fps&nbsp; BRate: 15.00 Mbit/s<o:p></o:p></span>=
</p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>This is working perfectly and I can see the channels i=
n LAN
with vlc.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>When I give multiple pid, I&#8217;m getting the error =
like
this.<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<span style=3D'color:red'># dvbstream -f 11938 -=
p V -s
27500 -udp -net 224.0.1.2:1234 4011 4012 4021 4022 4031 4032<o:p></o:p></sp=
an></p>

<p class=3DMsoNormal><span style=3D'color:red'>dvbstream v0.6 - (C) Dave Ch=
apman
2001-2004<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Released under the GPL.<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Latest version available fro=
m
http://www.linuxstb.org/<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Tuning to 11938 Hz<o:p></o:p=
></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Using DVB card &quot;ST STV0=
299
DVB-S&quot;, freq=3D11938<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>tuning DVB-S to Freq: 133800=
0, Pol:V
Srate=3D27500000, 22kHz tone=3Doff, LNB: 0<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Setting only tone ON and vol=
tage 13V<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>DISEQC SETTING SUCCEDED<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Getting frontend status<o:p>=
</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Event:&nbsp; Frequency: 1193=
8713<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;
SymbolRate: 27500000<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;
FEC_inner:&nbsp; 3<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Bit error rate: 18576<o:p></=
o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Signal strength: 47555<o:p><=
/o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>SNR: 48072<o:p></o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:red'>FE_STATUS: FE_HAS_SIGNAL FE_=
HAS_LOCK
FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>MAP 0, addr 224.0.1.2:1234 F=
rom -1
secs, To -1 secs, 6 PIDs -&nbsp; 4011 4012 4021 4022 4031 4032<o:p></o:p></=
span></p>

<p class=3DMsoNormal><span style=3D'color:red'>dvbstream will stop after -1=
 seconds
(71582788 minutes)<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:red'>Streaming 6 streams<o:p></o:=
p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>But no channels are coming.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Also in first option without &#8211;ps, it is freezing=
 and
not clear.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Please help me.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Aslam<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_425356A9213FA046A466287AF4E18B193E7A7A9874ALHMAILalhgro_--


--===============1074023778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1074023778==--
