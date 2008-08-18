Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KVA5F-00032f-75
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 21:08:10 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1090742yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 12:07:59 -0700 (PDT)
Message-ID: <7641eb8f0808181207u232793f6p8fcf150d97f139a5@mail.gmail.com>
Date: Mon, 18 Aug 2008 21:07:58 +0200
From: Beth <beth.null@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <7641eb8f0808180233j126ef0b7v13caec258811d573@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
	<7641eb8f0808180233j126ef0b7v13caec258811d573@mail.gmail.com>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Another test I made, with interesting news.

It seems that the stream is coming but at a very low speed, if I run
the following command:

 mplayer -v - < /dev/dvb/adapter0/dvr0

I get this output:

*************************************************************************************************************

MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ (Family: 15,
Model: 43, Stepping: 1)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
get_path('codecs.conf') -> '/home/xxx/.mplayer/codecs.conf'
Reading /home/xxx/.mplayer/codecs.conf: Can't open
'/home/xxx/.mplayer/codecs.conf': No such file or directory
Reading /etc/mplayer/codecs.conf: Can't open
'/etc/mplayer/codecs.conf': No such file or directory
Using built-in default codecs.conf.
Configuration: --enable-runtime-cpudetection --target=i586-linux
--prefix=/usr --confdir=/etc/mplayer --mandir=/usr/share/man
--win32codecsdir=/usr/lib/win32 --enable-largefiles
--disable-libdvdcss-internal --enable-smb --enable-ftp
--enable-cdparanoia --enable-radio --enable-lirc --enable-joystick
--enable-xf86keysym --disable-tremor-internal --enable-liba52
--enable-musepack --enable-speex --enable-libvorbis --enable-mad
--enable-mp3lib --enable-theora --enable-libdv --enable-libmpeg2
--enable-tv-v4l2 --enable-alsa --enable-ossaudio --enable-esd
--enable-arts --enable-pulse --enable-nas --enable-xinerama
--enable-menu --enable-xv --enable-vm --enable-gl --enable-xmga
--enable-mga --enable-3dfx --enable-tdfxfb --enable-sdl --enable-aa
--enable-caca --enable-dxr3 --enable-xvmc --with-xvmclib=XvMCW
--enable-ggi --enable-fbdev --enable-freetype --enable-gif
--enable-png --enable-jpeg --enable-liblzo --enable-fribidi
--enable-ladspa --enable-libamr_nb --enable-libamr_wb --enable-faac
--enable-gui --enable-mencoder
CommandLine: '-v' '-'
init_freetype
get_path('font/font.desc') -> '/home/xxx/.mplayer/font/font.desc'
font: can't open file: /home/xxx/.mplayer/font/font.desc
font: can't open file: /usr/share/mplayer/font/font.desc
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
get_path('fonts') -> '/home/xxx/.mplayer/fonts'
Using nanosleep() timing
get_path('input.conf') -> '/home/xxx/.mplayer/input.conf'
Can't open input config file /home/xxx/.mplayer/input.conf: No such
file or directory
Parsing input config file /etc/mplayer/input.conf
Input config file /etc/mplayer/input.conf parsed: 81 binds
Setting up LIRC support...
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.
get_path('-.conf') -> '/home/xxx/.mplayer/-.conf'

Playing -.
Reading from stdin...
[file] File size is 0 bytes
STREAM: [file] -
STREAM: Description: File
STREAM: Author: Albeu
STREAM: Comment: based on the code from ??? (probably Arpi)
LAVF_check: MPEG2 transport stream format
Checking for YUV4MPEG2
ASF_check: not ASF guid!
Checking for NuppelVideo
Checking for REAL
Checking for SMJPEG
Searching demuxer type for filename - ext: (null)
Checking for Nullsoft Streaming Video

*************************************************************************************************************

And it blocks here more or less for a minute and a half, later appears
the following:

Checking for MOV
Checking for VIVO
header block 1 size: 83
AVS: avs_check_file - attempting to open file -
Win32 LoadLibrary failed to load: avisynth.dll,
/usr/lib/win32/avisynth.dll, /usr/local/lib/win32/avisynth.dll
AVS: failed to load avisynth.dll
AVS: Init failed
Checking for PVA
Checking for MPEG-TS...
TRIED UP TO POSITION 6676, FOUND 47, packet_size= 188, SEEMS A TS? 1
GOOD CC: 22, BAD CC: 0
TS file format detected.
DEMUX OPEN, AUDIO_ID: -1, VIDEO_ID: -1, SUBTITLE_ID: -2,
Checking for MPEG-TS...
TRIED UP TO POSITION 19916, FOUND 47, packet_size= 188, SEEMS A TS? 1
GOOD CC: 22, BAD CC: 0
PROBING UP TO 0, PROG: 0
COLLECT_SECTION, start: 64, size: 184, collected: 0
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 0
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=0, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------
COLLECT_SECTION, start: 64, size: 184, collected: 184
SKIP: 0+1, TID: 0, TLEN: 73, COLLECTED: 184
PARSE_PAT: section_len: 73, section 0/0
PROG: 0 (1-th of 16), PMT: 16
PROG: 30201 (2-th of 16), PMT: 1025
PROG: 30212 (3-th of 16), PMT: 1036
PROG: 30211 (4-th of 16), PMT: 1035
PROG: 30215 (5-th of 16), PMT: 1032
PROG: 30208 (6-th of 16), PMT: 1031
PROG: 30209 (7-th of 16), PMT: 1030
PROG: 30207 (8-th of 16), PMT: 1029
PROG: 30206 (9-th of 16), PMT: 1024
PROG: 30222 (10-th of 16), PMT: 1053
PROG: 30205 (11-th of 16), PMT: 1052
PROG: 30220 (12-th of 16), PMT: 1051
PROG: 30210 (13-th of 16), PMT: 1034
PROG: 30204 (14-th of 16), PMT: 1028
PROG: 30203 (15-th of 16), PMT: 1027
PROG: 30202 (16-th of 16), PMT: 1026
COLLECT_SECTION, start: 64, size: 184, collected: 368
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 184
COLLECT_SECTION, start: 0, size: 184, collected: 184
SKIP: 0+1, TID: 2, TLEN: 310, COLLECTED: 368
FILL_PMT(prog=30222), PMT_len: 368, IS_START: 0, TS_PID: 1053,
SIZE=184, M=0, ES_CNT=14, IDX=0, PMT_PTR=0x8afdcf8
...descr id: 0x52, len=1
PARSE_PMT(30222 INDEX 0), STREAM: 0, FOUND pid=0xa7 (167),
type=0x10000002, ES_DESCR_LENGTH: 3, bytes left: 289
...descr id: 0x52, len=1
...descr id: 0xa, len=4
Language Descriptor: glg
PARSE_PMT(30222 INDEX 1), STREAM: 1, FOUND pid=0x6c (108), type=0x50,
ES_DESCR_LENGTH: 9, bytes left: 275
...descr id: 0x52, len=1
...descr id: 0x56, len=5
PARSE_PMT(30222 INDEX 2), STREAM: 2, FOUND pid=0x35 (53),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 260
...descr id: 0xc6, len=5
...descr id: 0xc2, len=96
PARSE_PMT(30222 INDEX 3), STREAM: 3, FOUND pid=0xd0 (208),
type=0xffffffff, ES_DESCR_LENGTH: 105, bytes left: 150
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 4), STREAM: 4, FOUND pid=0xde (222),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 135
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 5), STREAM: 5, FOUND pid=0x135 (309),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 120
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 6), STREAM: 6, FOUND pid=0x188 (392),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 105
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 7), STREAM: 7, FOUND pid=0xd5 (213),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 90
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 8), STREAM: 8, FOUND pid=0xfd (253),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 75
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 9), STREAM: 9, FOUND pid=0x133 (307),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 60
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 10), STREAM: 10, FOUND pid=0x164 (356),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 45
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 11), STREAM: 11, FOUND pid=0x2f9 (761),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 30
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 12), STREAM: 12, FOUND pid=0x378 (888),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 15
...descr id: 0xc2, len=8
PARSE_PMT(30222 INDEX 13), STREAM: 13, FOUND pid=0x26f (623),
type=0xffffffff, ES_DESCR_LENGTH: 10, bytes left: 0
----------------------------

MPlayer interrupted by signal 2 in module: demux_open
vo: x11 uninit called but X11 not inited..

And it continues until I press ctrl+c.

It seems that the data is comming from the device, but at a very low
speed so maybe this will be the problem, but what causes this low
speed data?

Again thanks and kind regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
