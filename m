Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:2333 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZAXQQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 11:16:57 -0500
From: "Wayne and Holly" <wayneandholly@alice.it>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Leadtek WinFast PxDVR3200 H
Date: Sat, 24 Jan 2009 17:05:42 +0100
Message-ID: <000201c97e3d$9bad71f0$0202a8c0@speedy>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01C97E45.FD744AF0"
In-Reply-To: <20090123015815.GA22113@shibaya.lonestar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0003_01C97E45.FD744AF0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello list,
I have a Leadtek WinFast PxDVR3200 H that I am attempting to utilise =
with
MythTV.  The Wiki site states that experimental support exists for the =
DVB
side and that "Successful tuning of typical Australian channels" has =
been
achieved.
I am able to create a channels.conf (attached) using scan, and am then =
able
to tune using mythtv-setup, however none of these channels are viewable =
with
the mythfrontend due to it being unable to gain a lock.

Relevant bits and pieces:

scan, using the latest it-Varese file scan is able to tune to three of =
the
five transponders as per the attached file "scan".  It also scans on
800000000Hz but I have no idea why.

The file leadtek.dmesg contains the relevant info from dmesg (and
messages.log) regarding the initialisation of the card itself.  There =
are no
error messages at any time (that I am aware of) despite all of my =
fiddling
about.

Of the three transponders that are in my channels.conf file, the third =
one
(618000000Hz) causes an error when tuning in mythtv-setup.  It states =
that
channels are found but the tsid is incorrect.  As such, only the first =
two
successful transponders (706000000 and 602000000) are tuned by myth.

When I attempt to view the tuned channels, myth is unable to gain a lock =
on
any of them.  The reported signal strength is about 58% and the S/N =
varies
between 3 and 3.8dB.  I am able to tune DVB-T channels on my TV using =
the
same aerial cable but am wondering if signal strength is an issue.

I am running it on Kubuntu with a 2.6.24-19 kernel, I have a recent =
version
of the v4l-dvb tree (approx Nov 08) and am using firmware version 2.7.  =
I
haven't updated the drivers or the firmware as I have no reason to =
believe
there are changes that would effect this.  That said, if someone thinks
there has been changes I will get straight on it.

I am more than happy to provide more debugging info if required (if you =
are
willing to tell me where else to look) and appreciate any help provided.

Cheers
Wayne

------=_NextPart_000_0003_01C97E45.FD744AF0
Content-Type: application/octet-stream;
	name="scan"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="scan"

scanning ./it-Varese=0A=
using '/dev/dvb/adapter7/frontend0' and '/dev/dvb/adapter7/demux0'=0A=
initial transponder 226500000 1 2 9 3 1 0 0=0A=
initial transponder 706000000 0 2 9 3 1 0 0=0A=
initial transponder 602000000 0 2 9 3 1 0 0=0A=
initial transponder 514000000 0 2 9 3 1 0 0=0A=
initial transponder 610000000 0 2 9 3 1 0 0=0A=
>>> tune to: =
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
0x0000 0x000b: pmt_pid 0x006f (null) -- Servizio OTA11 (running)=0A=
0x0000 0x000c: pmt_pid 0x0070 (null) -- Servizio OTA12 (running)=0A=
0x0000 0x000d: pmt_pid 0x0071 (null) -- Servizio 13 (running)=0A=
0x0000 0x000e: pmt_pid 0x0072 (null) -- Servizio 14 (running)=0A=
0x0000 0x000f: pmt_pid 0x0073 (null) -- Servizio 15 (running)=0A=
0x0000 0x0010: pmt_pid 0x0074 (null) -- Servizio 16 (running)=0A=
0x0000 0x0011: pmt_pid 0x0075 (null) -- Servizio 17 (running)=0A=
0x0000 0x0012: pmt_pid 0x0076 (null) -- Servizio 18 (running)=0A=
0x0000 0x0014: pmt_pid 0x0078 (null) -- Servizio 20 (running)=0A=
0x0000 0x006d: pmt_pid 0x00d1 Mediaset -- Disney Channel - Premium =
(running, scrambled)=0A=
0x0000 0x006f: pmt_pid 0x00d3 Mediaset -- Joi - Premium (running, =
scrambled)=0A=
0x0000 0x0070: pmt_pid 0x00d4 Mediaset -- Mya - Premium (running, =
scrambled)=0A=
0x0000 0x0071: pmt_pid 0x00d5 Mediaset -- Steel - Premium (running, =
scrambled)=0A=
0x0000 0x0072: pmt_pid 0x00d6 Mediaset -- Joi+1 - Premium (running, =
scrambled)=0A=
0x0000 0x0073: pmt_pid 0x00d7 Mediaset -- Mya+1 - Premium (running, =
scrambled)=0A=
0x0000 0x0074: pmt_pid 0x00d8 Mediaset -- Steel+1 - Premium (running, =
scrambled)=0A=
0x0000 0x00ac: pmt_pid 0x0110 Mediaset -- Mediashopping (running)=0A=
0x0000 0x03e7: pmt_pid 0x0063 (null) -- Servizio M_e (running)=0A=
0x0000 0x1f4f: pmt_pid 0x1b67 (null) -- HUMAX DOWNLOAD SVC (running)=0A=
Network Name 'DFree'=0A=
>>> tune to: =
602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
0x0000 0x0001: pmt_pid 0x0100 MBone -- LA7 (running, scrambled)=0A=
0x0000 0x0004: pmt_pid 0x0167 MBone -- TIMB  TEST 2 (running, scrambled)=0A=
0x0000 0x0006: pmt_pid 0x0121 MBone -- Cartapiu' A (running, scrambled)=0A=
0x0000 0x0007: pmt_pid 0x0124 MBone -- Cartapiu' B (running, scrambled)=0A=
0x0000 0x0008: pmt_pid 0x0127 MBone -- Cartapiu' C (running, scrambled)=0A=
0x0000 0x0009: pmt_pid 0x012a MBone -- Cartapiu' D (running, scrambled)=0A=
0x0000 0x000a: pmt_pid 0x012d MBone -- Cartapiu' E (running, scrambled)=0A=
0x0000 0x000b: pmt_pid 0x0130 MBone -- Cartapiu' Attivazione (running, =
scrambled)=0A=
0x0000 0x000c: pmt_pid 0x0000 MBone -- TIMB TEST (running, scrambled)=0A=
0x0000 0x000e: pmt_pid 0x010d MBone -- TIMB TEST 4 (running, scrambled)=0A=
0x0000 0x000f: pmt_pid 0x011e MBone -- Cartapiu' GOL! (running, =
scrambled)=0A=
0x0000 0x0011: pmt_pid 0x0000 MBone -- TIMB TEST 3 (running, scrambled)=0A=
0x0000 0x0013: pmt_pid 0x0157 MBone -- PIU' SERVIZI (running, scrambled)=0A=
0x0000 0x1f4f: pmt_pid 0x0000 MBone -- HUMAX DOWNLOAD SVC (running, =
scrambled)=0A=
Network Name 'MBone'=0A=
>>> tune to: =
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
610000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
610000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
800000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISS=
ION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
800000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISS=
ION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)=0A=
WARNING: >>> tuning failed!!!=0A=
>>> tune to: =
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISS=
ION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE=0A=
0x0202 0x0001: pmt_pid 0x0000 Bergamo Digitale -- Video Bergamo (running)=0A=
0x0202 0x0002: pmt_pid 0x0000 Bergamo digitale -- Enti&ComuniTV (running)=0A=
0x0202 0x0007: pmt_pid 0x0000 Radio Number One -- Radio Number One =
(running)=0A=
0x0202 0x0008: pmt_pid 0x0000 Radio Bergamo -- Radio Bergamo (running)=0A=
0x0202 0x0009: pmt_pid 0x0000 Radio Millenote -- Radio Millenote =
(running)=0A=
0x0202 0x0006: pmt_pid 0x0000 Scopus Network Technologies -- NUMBERONE =
CHANNEL (running)=0A=
0x0202 0x20db: pmt_pid 0x0000 Telespazio -- Radio Italia TV (running)=0A=
0x0202 0x000c: pmt_pid 0x0000 Scopus Network Technologies -- BETTING =
CHANNEL (running)=0A=
WARNING: filter timeout pid 0x0010=0A=
dumping lists (41 services)=0A=
Done.=0A=
=0A=

------=_NextPart_000_0003_01C97E45.FD744AF0
Content-Type: application/octet-stream;
	name="channels.conf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="channels.conf"

Servizio =
OTA11:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR=
ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:11=0A=
Servizio =
OTA12:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR=
ANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:12=0A=
Servizio =
13:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:13=0A=
Servizio =
14:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:14=0A=
Servizio =
15:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:15=0A=
Servizio =
16:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:16=0A=
Servizio =
17:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:17=0A=
Servizio =
18:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:18=0A=
Servizio =
20:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:472:20=0A=
Disney Channel - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:890:891:109=0A=
Joi - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:910:911:111=0A=
Mya - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:920:921:112=0A=
Steel - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:930:931:113=0A=
Joi+1 - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:940:941:114=0A=
Mya+1 - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:950:951:115=0A=
Steel+1 - =
Premium:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:960:961:116=0A=
Mediashopping:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:Q=
AM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:640:641:172=0A=
Servizio =
M_e:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN=
SMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:999=0A=
HUMAX DOWNLOAD =
SVC:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN=
SMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:8015=0A=
Cartapiu' =
Attivazione:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM=
_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:305:0:11=0A=
TIMB  TEST =
2:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:4=0A=
PIU' =
SERVIZI:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:345:19=0A=
Cartapiu' =
B:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:8006:0:7=0A=
Cartapiu' =
GOL!:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:8006:0:15=0A=
Cartapiu' =
C:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:8006:0:8=0A=
Cartapiu' =
D:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:8006:0:9=0A=
Cartapiu' =
E:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:8006:0:10=0A=
TIMB TEST =
4:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:270:0:14=0A=
LA7:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN=
SMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:257:258:1=0A=
Cartapiu' =
A:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:290:291:6=0A=
TIMB =
TEST:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:12=0A=
TIMB TEST =
3:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:17=0A=
HUMAX DOWNLOAD =
SVC:602000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN=
SMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:8015=0A=
Video =
Bergamo:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:T=
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:256:258:1=0A=
Enti&ComuniTV:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QA=
M_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:512:514:2=0A=
Radio Number =
One:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:519:7=0A=
Radio =
Bergamo:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:T=
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:521:8=0A=
Radio =
Millenote:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64=
:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:523:9=0A=
NUMBERONE =
CHANNEL:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:T=
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:2304:2305:6=0A=
Radio Italia =
TV:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:639:640:8411=0A=
BETTING =
CHANNEL:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:T=
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4194:4195:12=0A=

------=_NextPart_000_0003_01C97E45.FD744AF0
Content-Type: application/octet-stream;
	name="leadtek.dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="leadtek.dmesg"

[   29.781655] CORE cx23885[0]: subsystem: 107d:6681, board: Leadtek =
Winfast PxDVR3200 H [card=3D12,autodetected]=0A=
[   29.992087] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])=0A=
[   29.992740] cx23885_dvb_register() allocating 1 frontend(s)=0A=
[   29.992747] cx23885[0]: cx23885 based dvb card=0A=
[   30.082514] xc2028 1-0061: creating new instance=0A=
[   30.082518] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner=0A=
[   30.082524] DVB: registering new adapter (cx23885[0])=0A=
[   30.082527] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 =
DVB-T)...=0A=
[   30.082749] cx23885_dev_checkrevision() Hardware revision =3D 0xb0=0A=
[   30.082755] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 20, =
latency: 0, mmio: 0xfd000000=0A=
=0A=
Jan 22 14:18:47 HTPC kernel: [484270.205203] xc2028 1-0061: Loading 80 =
firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7=0A=
Jan 22 14:18:47 HTPC kernel: [484270.403473] xc2028 1-0061: Loading =
firmware for type=3DBASE F8MHZ (3), id 0000000000000000.=0A=
Jan 22 14:18:48 HTPC kernel: [484271.538905] xc2028 1-0061: Loading =
firmware for type=3DD2633 DTV8 (210), id 0000000000000000.=0A=
Jan 22 14:18:48 HTPC kernel: [484271.552649] xc2028 1-0061: Loading =
SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 =
(620003e0), id 0000000000000000.=0A=
=0A=

------=_NextPart_000_0003_01C97E45.FD744AF0--

