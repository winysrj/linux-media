Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail3.riotinto.com ([210.8.150.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Tom.George@riotinto.com>) id 1KEbpx-0005zh-3g
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 05:19:57 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Fri, 4 Jul 2008 11:19:15 +0800
Message-ID: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
From: "George, Tom \(RTIO\)" <Tom.George@riotinto.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] dvb_usb_dib0700 tuning problems?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0317356509=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0317356509==
Content-Transfer-Encoding: 7bit
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8DD84.BD631929"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8DD84.BD631929
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Hi,

Hoping someone can shed some light on this!

I have an Asus U3000 mini usb dvb-t tuner and I'm struggling to get it
working properly. I have tested the card in windows xp with the same
antenna and it works flawlessly, receiving all channels.

I am using ubuntu hardy heron with the 2.6.24-19-generic kernel which
(should) work out of the box. Device is recognised and the correct
dvb_usb_dib0700 module is loaded, with the correct devices created etc
etc. Correct firmware is in /lib/firmware/2.6.24-19-generic.

Scanning using kaffeine gets me some channels (I'm based in Perth,
Western Australia) - I get SBS & SBS HD but no other channels.=20

It appears to me that there is an issue with the tuner changing
frequency (check the output of scan...), I'm new to dvb and a little
stuck, any help would be massively appreciated!!!

Here's some technical output:

root@jaws:/home/tom# cat /var/log/dmesg | grep dvb
[ 57.721601] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in
cold state, will try to load a firmware
[ 57.773379] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[ 58.465269] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in
warm state.
[ 58.465328] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 58.871555] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner successfully
initialized and connected.
[ 58.871833] usbcore: registered new interface driver dvb_usb_dib0700

root@jaws:/home/tom# lsmod | grep dvb
dvb_usb_dib0700 26376 0
dib7000p 17672 2 dvb_usb_dib0700
dib7000m 16516 1 dvb_usb_dib0700
dvb_usb 19852 1 dvb_usb_dib0700
dvb_core 81404 1 dvb_usb
dib3000mc 13960 1 dvb_usb_dib0700
dib0070 9092 1 dvb_usb_dib0700
i2c_core 24832 8 mt2266,dib7000p,dib7000m,dvb_usb,nvidia,dib3000mc,
dibx000_common,dib0070
usbcore 146028 9 dvb_usb_dib0700,dvb_usb,hci_usb,usb_storage,usbhid
,libusual,ohci_hcd,ehci_hcd


root@jaws:/home/tom# ls -la /dev/dvb/adapter1
total 0
drwxr-xr-x 2 root root 120 2008-07-04 08:01 .
drwxr-xr-x 3 root root 60 2008-07-04 08:01 ..
crw-rw----+ 1 root video 212, 68 2008-07-04 08:01 demux0
crw-rw----+ 1 root video 212, 69 2008-07-04 08:01 dvr0
crw-rw----+ 1 root video 212, 67 2008-07-04 08:01 frontend0
crw-rw----+ 1 root video 212, 71 2008-07-04 08:01 net0

root@jaws:/home/tom# scan -a 1
/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536500000 1 2 9 3 1 2 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_16:HIERARCHY_NONE
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
22 Invalid argument
>>> tune to: 536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_8:HIERARCHY_NONE
0x0000 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)
0x0000 0x0321: pmt_pid 0x0401 SBS -- SBS (running)
0x0000 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)
0x0000 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)
0x0000 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)
0x0000 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)
Network Name 'SBS NETWORK'
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
0x0320 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)
0x0320 0x0321: pmt_pid 0x0401 SBS -- SBS (running)
0x0320 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)
0x0320 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)
0x0320 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)
0x0320 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)
Network Name 'SBS NETWORK'
>>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (12 services)
SBS HD:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_
3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV
AL_1_8:HIERARCHY_NONE:102:103:800
SBS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2
_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER
VAL_1_8:HIERARCHY_NONE:161:81:801
SBS NEWS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_
2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE
RVAL_1_8:HIERARCHY_NONE:162:83:802
SBS 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:161:81:803
SBS RADIO 1:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:201:814
SBS RADIO 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:202:815
SBS HD:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_
3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV
AL_1_8:HIERARCHY_NONE:102:103:800
SBS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2
_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER
VAL_1_8:HIERARCHY_NONE:161:81:801
SBS NEWS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_
2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE
RVAL_1_8:HIERARCHY_NONE:162:83:802
SBS 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:161:81:803
SBS RADIO 1:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:201:814
SBS RADIO 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:202:815
Done.

Anyone got an idea what is going on here???????

CHeers,

Tom

=20

=20

Tom George

RTIO WA Demand Coordinator - Office of the CIO

=20

Rio Tinto

Central Park, 152 - 158 St Georges Terrace, Perth, 6000, Western
Australia

=20

T: +61 (9) 8 94247251   M: +61 (0) 417940173   F: +61 (0) 8 9327 2456

Tom.george@riotinto.com   http://www.riotinto.com=20
=20
This email (including all attachments) is the sole property of Rio Tinto =
Limited and may be confidential.  If you are not the intended recipient, =
you must not use or forward the information contained in it.  This =
message may not be reproduced or otherwise republished without the =
written consent of the sender.  If you have received this message in =
error, please delete the e-mail and notify the sender.

------_=_NextPart_001_01C8DD84.BD631929
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<HTML >
<HEAD>
<META http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"State"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Georgia;
	panose-1:2 4 5 2 5 4 5 2 3 3;}
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
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Verdana;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</HEAD>
<BODY lang=3DEN-AU link=3Dblue vlink=3Dpurple>
<DIV>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D1 color=3Dblack face=3DVerdana><span
style=3D'font-size:9.0pt;font-family:Verdana;color:black'>Hi,<br>
<br>
Hoping someone can shed some light on this!<br>
<br>
I have an Asus U3000 mini usb dvb-t tuner and I'm struggling to get it =
working
properly. I have tested the card in windows xp with the same antenna and =
it
works flawlessly, receiving all channels.<br>
<br>
I am using ubuntu hardy heron with the 2.6.24-19-generic kernel which =
(should)
work out of the box. Device is recognised and the correct =
dvb_usb_dib0700
module is loaded, with the correct devices created etc etc. Correct =
firmware is
in /lib/firmware/2.6.24-19-generic.<br>
<br>
Scanning using kaffeine gets me some channels (I'm based in <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">Perth</st1:City>, <st1:State w:st=3D"on">Western =
Australia</st1:State></st1:place>)
- I get SBS &amp; SBS HD but no other channels. <br>
<br>
It appears to me that there is an issue with the tuner changing =
frequency
(check the output of scan...), I'm new to dvb and a little stuck, any =
help
would be massively appreciated!!!<br>
<br>
Here's some technical output:<br>
<br>
root@jaws:/home/tom# cat /var/log/dmesg | grep dvb<br>
[ 57.721601] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in =
cold
state, will try to load a firmware<br>
[ 57.773379] dvb-usb: downloading firmware from file =
'dvb-usb-dib0700-1.10.fw'<br>
[ 58.465269] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in =
warm
state.<br>
[ 58.465328] dvb-usb: will pass the complete MPEG2 transport stream to =
the
software demuxer.<br>
[ 58.871555] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner successfully
initialized and connected.<br>
[ 58.871833] usbcore: registered new interface driver =
dvb_usb_dib0700<br>
<br>
root@jaws:/home/tom# lsmod | grep dvb<br>
dvb_usb_dib0700 26376 0<br>
dib7000p 17672 2 dvb_usb_dib0700<br>
dib7000m 16516 1 dvb_usb_dib0700<br>
dvb_usb 19852 1 dvb_usb_dib0700<br>
dvb_core 81404 1 dvb_usb<br>
dib3000mc 13960 1 dvb_usb_dib0700<br>
dib0070 9092 1 dvb_usb_dib0700<br>
i2c_core 24832 8 mt2266,dib7000p,dib7000m,dvb_usb,nvidia,dib3000mc,
dibx000_common,dib0070<br>
usbcore 146028 9 dvb_usb_dib0700,dvb_usb,hci_usb,usb_storage,usbhid
,libusual,ohci_hcd,ehci_hcd<br>
<br>
<br>
root@jaws:/home/tom# ls -la /dev/dvb/adapter1<br>
total 0<br>
drwxr-xr-x 2 root root 120 2008-07-04 08:01 .<br>
drwxr-xr-x 3 root root 60 2008-07-04 08:01 ..<br>
crw-rw----+ 1 root video 212, 68 2008-07-04 08:01 demux0<br>
crw-rw----+ 1 root video 212, 69 2008-07-04 08:01 dvr0<br>
crw-rw----+ 1 root video 212, 67 2008-07-04 08:01 frontend0<br>
crw-rw----+ 1 root video 212, 71 2008-07-04 08:01 net0<br>
<br>
root@jaws:/home/tom# scan -a 1 =
/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-<st1:City
w:st=3D"on"><st1:place w:st=3D"on">Perth</st1:place></st1:City><br>
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth<br>
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'<br>
initial transponder 226500000 1 3 9 3 1 1 0<br>
initial transponder 177500000 1 2 9 3 1 1 0<br>
initial transponder 191625000 1 3 9 3 1 1 0<br>
initial transponder 219500000 1 3 9 3 1 1 0<br>
initial transponder 536500000 1 2 9 3 1 2 0<br>
&gt;&gt;&gt; tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F =
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_16:HIERARCHY_NONE<br>
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: =
22
Invalid argument<br>
&gt;&gt;&gt; tune to: 536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL =
_1_8:HIERARCHY_NONE<br>
0x0000 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)<br>
0x0000 0x0321: pmt_pid 0x0401 SBS -- SBS (running)<br>
0x0000 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)<br>
0x0000 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)<br>
0x0000 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)<br>
0x0000 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)<br>
Network Name 'SBS NETWORK'<br>
&gt;&gt;&gt; tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ =
1_8:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F =
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_
1_8:HIERARCHY_NONE (tuning failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ =
1_8:HIERARCHY_NONE<br>
0x0320 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)<br>
0x0320 0x0321: pmt_pid 0x0401 SBS -- SBS (running)<br>
0x0320 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)<br>
0x0320 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)<br>
0x0320 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)<br>
0x0320 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)<br>
Network Name 'SBS NETWORK'<br>
&gt;&gt;&gt; tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ =
1_8:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE =
(tuning
failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ =
1_8:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE =
(tuning
failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ =
1_8:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F
EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE =
(tuning
failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>
dumping lists (12 services)<br>
SBS HD:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_
3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV =
AL_1_8:HIERARCHY_NONE:102:103:800<br>
SBS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2
_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER
VAL_1_8:HIERARCHY_NONE:161:81:801<br>
SBS NEWS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_
2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE
RVAL_1_8:HIERARCHY_NONE:162:83:802<br>
SBS 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:161:81:803<br>
SBS RADIO 1:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:201:814<br>
SBS RADIO 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:202:815<br>
SBS HD:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_
3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV
AL_1_8:HIERARCHY_NONE:102:103:800<br>
SBS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2
_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER
VAL_1_8:HIERARCHY_NONE:161:81:801<br>
SBS NEWS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_
2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE
RVAL_1_8:HIERARCHY_NONE:162:83:802<br>
SBS 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:161:81:803<br>
SBS RADIO 1:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA
L_1_8:HIERARCHY_NONE:0:201:814<br>
SBS RADIO 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA =
L_1_8:HIERARCHY_NONE:0:202:815<br>
Done.<br>
<br>
Anyone got an idea what is going on here???????<br>
<br>
CHeers,<br>
<br>
Tom<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3DGeorgia><span lang=3DEN-US =
style=3D'font-size:
12.0pt;font-family:Georgia'>Tom <a name=3D"OLE_LINK2"></a><a =
name=3D"OLE_LINK1">George</a></span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D3 face=3DGeorgia><span lang=3DEN-US =
style=3D'font-size:
12.0pt;font-family:Georgia'>RTIO WA Demand Coordinator &#8211; Office of =
the
CIO<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><u1:place u2:st=3D"on"><u1:City =
u2:st=3D"on"><st1:place w:st=3D"on"><font
 size=3D3 color=3Dred face=3DGeorgia><span lang=3DEN-US =
style=3D'font-size:12.0pt;
 =
font-family:Georgia;color:red'>Rio</u1:City></u1:place></span></font></st=
1:place><font
color=3Dred face=3DGeorgia><span lang=3DEN-US =
style=3D'font-family:Georgia;color:red'>
Tinto</span></font><font size=3D2 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
10.0pt;font-family:Arial'>Central Park, 152 - 158 St Georges Terrace, =
<u1:City u2:st=3D"on"><st1:City
w:st=3D"on">Perth</u1:City></st1:City>, 6000, </span></font><u1:State =
u2:st=3D"on"><u1:place u2:st=3D"on"><st1:State
w:st=3D"on"><st1:place w:st=3D"on"><font size=3D2 face=3DArial><span =
style=3D'font-size:
  10.0pt;font-family:Arial'>Western </span></font><font size=3D2 =
face=3DArial><span
  lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:Arial'>Australia</span></font></st1=
:place></st1:State></u1:place></u1:State><font
size=3D2 face=3DArial><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:Arial'><o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DFR =
style=3D'font-size:10.0pt;
font-family:Arial'>T: +61 (9) 8 94247251&nbsp;&nbsp; M: +61 (0) =
417940173&nbsp;&nbsp; F: +61 (0) 8
9327 2456<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DFR =
style=3D'font-size:10.0pt;
font-family:Arial'>Tom.george@riotinto.com&nbsp;&nbsp; =
http://www.riotinto.com</span></font><font
size=3D2 face=3DArial><span lang=3DFR =
style=3D'font-size:10.0pt;font-family:Arial'><o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

 </DIV>
<DIV>&nbsp;</DIV>
<DIV><SPAN STYLE=3D"FONT-SIZE: 9pt; FONT-FAMILY: 'Courier New'">This =
email (including all attachments) is the sole property of Rio Tinto =
Limited and may be confidential.&nbsp; If you are not the intended =
recipient, you must not use or forward the information contained in it. =
&nbsp;This message may not be reproduced or otherwise republished =
without the written consent of the sender.&nbsp; If you have received =
this message in error, please delete the e-mail and notify the =
sender.</SPAN></DIV></BODY></HTML>

------_=_NextPart_001_01C8DD84.BD631929--


--===============0317356509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0317356509==--
