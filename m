Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <vnishimoto@ibest.com.br>) id 1Tibg5-0006oS-I1
	for linux-dvb@linuxtv.org; Wed, 12 Dec 2012 03:04:06 +0100
Received: from mail-gg0-f171.google.com ([209.85.161.171])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Tibg3-0003Kk-G9; Wed, 12 Dec 2012 03:04:03 +0100
Received: by mail-gg0-f171.google.com with SMTP id 4so32609ggm.16
	for <linux-dvb@linuxtv.org>; Tue, 11 Dec 2012 18:04:01 -0800 (PST)
Message-ID: <50C7E60E.5000208@ibest.com.br>
Date: Wed, 12 Dec 2012 00:03:58 -0200
From: Vagner Nishimoto <vnishimoto@ibest.com.br>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DBV API v5
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi,

I'm using DiBcom 8000 ISDB-T driver and openSUSE 12.2 kernel 3.4.11.
The problem is mplayer and others players can't sintonize.
The only program that work is VLC 2.0

mplayer dvb://globo -v

MPlayer dev-SVN-r35127-4.7-openSUSE Linux 12.2 (x86_64)-Packman (C) 2000-20=
12 =

MPlayer Team
CPU vendor name: GenuineIntel  max cpuid level: 13
CPU: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz (Family: 6, Model: 23, =

Stepping: 10)
extended cpuid-level: 8
extended cache-info: 402686016
Detected cache-line size is 64 bytes
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNowExt: 0 SSE: 1 SSE2: 1 SSSE3: 1
Compiled with runtime CPU detection.
get_path('codecs.conf') -> '/home/vagner/.mplayer/codecs.conf'
Reading optional codecs config file /home/vagner/.mplayer/codecs.conf: No s=
uch =

file or directory
Reading optional codecs config file /etc/mplayer/codecs.conf: No such file =
or =

directory
Using built-in default codecs.conf.
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
get_path('fonts') -> '/home/vagner/.mplayer/fonts'
Configuration: --enable-debug --prefix=3D/usr --confdir=3D/etc/mplayer =

--datadir=3D/usr/share/mplayer --libdir=3D/usr/lib64 --mandir=3D/usr/share/=
man =

--disable-libdvdcss-internal --enable-runtime-cpudetection --enable-bl =

--enable-fbdev --enable-gui --enable-menu --language=3Dall --enable-xvmc =

--with-xvmclib=3DXvMCW --enable-smb --enable-joystick --enable-radio =

--enable-radio-capture --enable-dvdnav --disable-nemesi --disable-wii =

--enable-faad --disable-tv-v4l1 --enable-v4l2 --disable-zr --disable-qtx =

--disable-arts --disable-esd --disable-mp3lib
CommandLine: 'dvb://globo' '-v'
Using nanosleep() timing
get_path('input.conf') -> '/home/vagner/.mplayer/input.conf'
Parsing input config file /home/vagner/.mplayer/input.conf
Input config file /home/vagner/.mplayer/input.conf parsed: 92 binds
get_path('globo.conf') -> '/home/vagner/.mplayer/globo.conf'

Playing dvb://globo.
get_path('sub/') -> '/home/vagner/.mplayer/sub/'
TUNER TYPE SEEMS TO BE DVB-T
get_path('channels.conf') -> '/home/vagner/.mplayer/channels.conf'
get_path('channels.conf.ter') -> '/home/vagner/.mplayer/channels.conf.ter'
get_path('channels.conf') -> '/home/vagner/.mplayer/channels.conf'
CONFIG_READ FILE: /home/vagner/.mplayer/channels.conf, type: 2
TER, NUM: 0, NUM_FIELDS: 11, NAME: cultura, FREQ: 533142857 PIDS:  8196  81=
96  0
TER, NUM: 1, NUM_FIELDS: 11, NAME: sbt, FREQ: 557142857 PIDS:  8196  8196  0
TER, NUM: 2, NUM_FIELDS: 11, NAME: globo, FREQ: 497142857 PIDS:  8196  8196=
  0
TER, NUM: 3, NUM_FIELDS: 11, NAME: record, FREQ: 509142857 PIDS:  8196  819=
6  0
TER, NUM: 4, NUM_FIELDS: 11, NAME: redetv, FREQ: 563142857 PIDS:  8196  819=
6  0
TER, NUM: 5, NUM_FIELDS: 11, NAME: gazeta, FREQ: 491142857 PIDS:  8196  819=
6  0
TER, NUM: 6, NUM_FIELDS: 11, NAME: band, FREQ: 527142857 PIDS:  8196  8196 =
 0
TER, NUM: 7, NUM_FIELDS: 11, NAME: megatv, FREQ: 479142857 PIDS:  8196  819=
6  0
TER, NUM: 8, NUM_FIELDS: 11, NAME: canal21, FREQ: 521142857 PIDS:  8196  81=
96  0
TER, NUM: 9, NUM_FIELDS: 11, NAME: cnt, FREQ: 545142857 PIDS:  8196  8196  0
TER, NUM: 10, NUM_FIELDS: 11, NAME: rit, FREQ: 569142857 PIDS:  8196  8196 =
 0
TER, NUM: 11, NUM_FIELDS: 11, NAME: mtv, FREQ: 575142857 PIDS:  8196  8196 =
 0
TER, NUM: 12, NUM_FIELDS: 11, NAME: toptv, FREQ: 587142857 PIDS:  8196  819=
6  0
TER, NUM: 13, NUM_FIELDS: 11, NAME: redevida, FREQ: 623142857 PIDS:  8196  =
8196  0
TER, NUM: 14, NUM_FIELDS: 11, NAME: tvdiario, FREQ: 701142857 PIDS:  8196  =
8196  0
TER, NUM: 15, NUM_FIELDS: 11, NAME: aparecida, FREQ: 635142857 PIDS:  8196 =
 8196  0
TER, NUM: 16, NUM_FIELDS: 11, NAME: rcnews, FREQ: 647142857 PIDS:  8196  81=
96  0
TER, NUM: 17, NUM_FIELDS: 11, NAME: ngt, FREQ: 671142857 PIDS:  8196  8196 =
 0
TER, NUM: 18, NUM_FIELDS: 11, NAME: terraviva, FREQ: 683142857 PIDS:  8196 =
 8196  0
TER, NUM: 19, NUM_FIELDS: 11, NAME: redebrasil, FREQ: 725142857 PIDS:  8192
TER, NUM: 20, NUM_FIELDS: 11, NAME: mack, FREQ: 749142857 PIDS:  8196  8196=
  0
TER, NUM: 21, NUM_FIELDS: 11, NAME: tvcamara, FREQ: 755142857 PIDS:  8196  =
8196  0
TER, NUM: 22, NUM_FIELDS: 11, NAME: tvbrasil, FREQ: 767142857 PIDS:  8196  =
8196  0
TER, NUM: 23, NUM_FIELDS: 11, NAME: tvjusti=E7a, FREQ: 773142857 PIDS:  819=
6  8196  0
DVB_CONFIG, can't open device /dev/dvb/adapter1/frontend0, skipping
DVB_CONFIG, can't open device /dev/dvb/adapter2/frontend0, skipping
DVB_CONFIG, can't open device /dev/dvb/adapter3/frontend0, skipping
OPEN_DVB: prog=3Dglobo, card=3D1, type=3D2

dvb_streaming_start(PROG: globo, CARD: 1, FILE: (null))
PROGRAM NUMBER 2: name=3Dglobo, freq=3D497142857
DVB_OPEN_DEVICES(3)
OPEN(0), file /dev/dvb/adapter0/demux0: FD=3D4, CNT=3D0
OPEN(1), file /dev/dvb/adapter0/demux0: FD=3D5, CNT=3D1
OPEN(2), file /dev/dvb/adapter0/demux0: FD=3D6, CNT=3D2
DVB_SET_CHANNEL: new channel name=3Dglobo, card: 0, channel 2
dvb_tune Freq: 497142857
TUNE_IT, fd_frontend 3, fd_sec -1
freq 497142857, srate 0, pol Using DVB card "DiBcom 8000 ISDB-T"
tuning DVB-T to 497142857 Hz, bandwidth: 2
dvb_tune, TUNING FAILED
DVBIN_CLOSE, close(2), fd=3D6, COUNT=3D2
DVBIN_CLOSE, close(1), fd=3D5, COUNT=3D1
DVBIN_CLOSE, close(0), fd=3D4, COUNT=3D0

vo: x11 uninit called but X11 not initialized..

Exiting... (End of file)

With Ubuntu 12.10 is the same.
-- =


             []s

             Vagner Nishimoto

---------------------------------------------------------------------------=
-----
vnishimoto@ibest.com.br
vnishimoto@bol.com.br
vnishimoto@ig.com.br
vnishimoto@yahoo.com.br
vnishimoto@terra.com.br
---------------------------------------------------------------------------=
-----
Get openSuSe <http://www.opensuse.org/>    Firefox Download Button
<http://www.firefox.com/>    Thunderbird Download Button
<http://www.getthunderbird.com/>    Get OpenOffice.org
<http://www.openoffice.org/> Get OpenOffice.org <http://www.libreoffice.org=
/>
---------------------------------------------------------------------------=
-----

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
