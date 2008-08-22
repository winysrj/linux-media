Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.wp.pl ([212.77.101.5])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from <kc0@wp.pl>)
	id 1KWRva-00059k-Jp
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 10:23:28 +0200
Received: from cqd74.neoplus.adsl.tpnet.pl (HELO [192.168.0.2])
	(kc0@[83.31.235.74]) (envelope-sender <kc0@wp.pl>)
	by smtp.wp.pl (WP-SMTPD) with SMTP
	for <linux-dvb@linuxtv.org>; 22 Aug 2008 10:23:20 +0200
Message-ID: <48AE7777.3050106@wp.pl>
Date: Fri, 22 Aug 2008 10:23:19 +0200
From: Kristo Czaja <kc0@wp.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DVB-T DiBcom STK7070P: no video
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I am new to dvb.

I've got an X3MTV-tuner TU1100 DVB-T USB 2.0 stick and I am trying to
get it working under gentoo.

As it sais here
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
and here
http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices#DiB0700_USB2.0_DVB-=
T_devices
I compiled the modules (do I need any others maybe?):
lsmod:
dvb_usb_dib0700        39560  0
dib7000p               17480  2 dvb_usb_dib0700
dib7000m               16260  1 dvb_usb_dib0700
dvb_usb                21196  1 dvb_usb_dib0700
dib3000mc              13320  1 dvb_usb_dib0700
dibx000_common          3844  3 dib7000p,dib7000m,dib3000mc
dib0070                 8196  2 dvb_usb_dib0700
i2c_i801               10204  0
i2c_core               22112  9
dvb_usb_dib0700,dib7000p,dib7000m,dvb_usb,dib3000mc,dibx000_common,dib0070,=
nvidia,i2c_i801

I got this firmware:
http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw=
, =


and created a link to the name dvb-usb-dib0700-1.10.fw

dmesg |tail:
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'DiBcom STK7070P reference design' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'DiBcom STK7070P reference design' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DiBcom STK7070P reference design)
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /class/input/input4
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: DiBcom STK7070P reference design successfully initialized and
connected.


Then:
cat pl-Warsaw:
T 690000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
T 746000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO

dvbscan pl-Warsaw:
TVP1:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:104:1
TVP2:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:204:2
TVP
INFO:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSM=
ISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:304:3
TVP
SPORT:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANS=
MISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:704:7
PR2:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMI=
SSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:213:12
PR3:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMI=
SSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:313:13
PR1:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMI=
SSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:113:11
TVP
HD:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:404:4
TVN:746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRA=
NSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:1612:1101
Polsat:746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:=
TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:1613:1201
Polsat Sport HD
test:746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TR=
ANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:1615:1601
TV4:746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRA=
NSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:1614:1202


I put the last output to "channels.conf".

Next, I follow this
http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device.
In one terminal:
tzap -s -r -c /etc/mplayer/channels.conf TVP1:
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/etc/mplayer/channels.conf'
tuning to 690000000 Hz
video pid 0x0066, audio pid 0x0067

While in a second terminal:

mplayer /dev/dvb/adapter0/dvr0:
MPlayer dev-SVN-r27458-4.3.1 (C) 2000-2008 MPlayer Team
CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model:
15, Stepping: 6)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Skompilowano dla procesora x86 z rozszerzeniami: MMX MMX2 SSE SSE2

Odtwarzam /dev/dvb/adapter0/dvr0.
Wykryto format pliku TS.
VIDEO MPEG2(pid=3D102) AUDIO A52(pid=3D103) NO SUBS (yet)!  PROGRAM N. 0

But nothing else, no window...
mplayer -v /dev/dvb/adapter0/dvr0:
MPlayer dev-SVN-r27458-4.3.1 (C) 2000-2008 MPlayer Team
CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (Family: 6, Model:
15, Stepping: 6)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Skompilowano dla procesora x86 z rozszerzeniami: MMX MMX2 SSE SSE2
get_path('codecs.conf') -> '/home/kristo/.mplayer/codecs.conf'
Wczytuj=EA /home/kristo/.mplayer/codecs.conf: Nie mog=EA otworzy=E6
'/home/kristo/.mplayer/codecs.conf': No such file or directory
Wczytuj=EA /etc/mplayer/codecs.conf: Nie mog=EA otworzy=E6
'/etc/mplayer/codecs.conf': No such file or directory
U=BFywam wbudowanego codecs.conf.
Configuration: --cc=3Dx86_64-pc-linux-gnu-gcc
--host-cc=3Dx86_64-pc-linux-gnu-gcc --prefix=3D/usr --confdir=3D/etc/mplayer
--datadir=3D/usr/share/mplayer --libdir=3D/usr/lib64 --enable-menu
--enable-network --disable-tv-bsdbt848 --disable-faad-external
--disable-ivtv --disable-fribidi --disable-enca --disable-ftp
--disable-nemesi --disable-libcdio --disable-cdparanoia --disable-cddb
--disable-ass --charset=3DUTF-8 --disable-lirc --disable-lircc
--disable-joystick --disable-inet6 --disable-unrarexec --disable-rtc
--disable-pvr --disable-radio-v4l2 --disable-radio-bsdbt848
--disable-musepack --disable-pnm --disable-tga --disable-xanim
--disable-libdirac-lavc --disable-libschroedinger-lavc
--disable-libamr_nb --disable-libamr_wb --disable-libdca
--disable-liblzo --disable-twolame --disable-toolame
--realcodecsdir=3D/usr/lib64/codecs --disable-directfb --disable-ggi
--disable-md5sum --disable-xinerama --disable-aa --disable-fbdev
--disable-caca --disable-vesa --disable-vidix --disable-vidix-pcidb
--disable-zr --disable-dxr2 --disable-dxr3 --enable-gui --enable-xvmc
--with-xvmclib=3DXvMCW --disable-3dfx --disable-tdfxvid --disable-tdfxfb
--disable-arts --disable-esd --disable-jack --disable-ladspa
--disable-nas --disable-openal --disable-pulse --disable-ossaudio
--disable-altivec
WierszPolece=F1: '-v' '/dev/dvb/adapter0/dvr0'
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
Using nanosleep() timing
get_path('input.conf') -> '/home/kristo/.mplayer/input.conf'
Parsing input config file /home/kristo/.mplayer/input.conf
Input config file /home/kristo/.mplayer/input.conf parsed: 7 binds
get_path('dvr0.conf') -> '/home/kristo/.mplayer/dvr0.conf'

Odtwarzam /dev/dvb/adapter0/dvr0.
get_path('sub/') -> '/home/kristo/.mplayer/sub/'
[file] File size is 0 bytes
STREAM: [file] /dev/dvb/adapter0/dvr0
STREAM: Description: File
STREAM: Author: Albeu
STREAM: Comment: based on the code from ??? (probably Arpi)
LAVF_check: MPEG-2 transport stream format
Checking for YUV4MPEG2
ASF_check: not ASF guid!
Checking for NuppelVideo
Checking for REAL
Checking for SMJPEG
SUB: opened iconv descriptor.
SUB: closed iconv descriptor.
Searching demuxer type for filename /dev/dvb/adapter0/dvr0 ext: (null)
Checking for Nullsoft Streaming Video
Checking for MOV
Checking for VIVO
header block 1 size: 89
Checking for PVA
Checking for MPEG-TS...
TRIED UP TO POSITION 96, FOUND 47, packet_size=3D 188, SEEMS A TS? 1
GOOD CC: 32, BAD CC: 0
Wykryto format pliku TS.
DEMUX OPEN, AUDIO_ID: -1, VIDEO_ID: -1, SUBTITLE_ID: -2,
Checking for MPEG-TS...
TRIED UP TO POSITION 6756, FOUND 47, packet_size=3D 188, SEEMS A TS? 1
GOOD CC: 32, BAD CC: 0
PROBING UP TO 0, PROG: 0
A52_CHECK(168 input bytes), found 0 frame syncwords of 0 bytes length
A52_CHECK(352 input bytes), found 0 frame syncwords of 0 bytes length
A52_CHECK(536 input bytes), found 0 frame syncwords of 0 bytes length
A52_CHECK(720 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(904 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(1088 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(1272 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(1456 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(1640 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(1824 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(2008 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(2192 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(2376 input bytes), found 1 frame syncwords of 1792 bytes length
A52_CHECK(2560 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(2744 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(2928 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(3112 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(3296 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(3480 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(3664 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(3848 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(4032 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(4216 input bytes), found 2 frame syncwords of 1792 bytes length
A52_CHECK(4400 input bytes), found 3 frame syncwords of 1792 bytes length
VIDEO MPEG2(pid=3D102) AUDIO A52(pid=3D103) NO SUBS (yet)!  PROGRAM N. 0
=3D=3D> Znalaz=B3em strumie=F1 video: 0

ADDED VIDEO PID 102, type: 10000002 stream n. 0
=3D=3D> Znalaz=B3em strumie=F1 audio: 0

ADDED AUDIO PID 103, type: 2000 stream n. 0
Opened TS demuxer, audio: 2000(pid 0), video: 10000002(pid
0)...POS=3D11912, PROBE=3D0
Searching for sequence header...
Za du=BFo pakiet=F3w audio w buforze: (1429 w 8391088 bajtach).
Mo=BFe odtwarzasz strumie=F1/plik bez przeplotu (non-interleaved) albo kodek
nie dzia=B3a?
Spr=F3buj wymusi=E6 tryb bez przeplotu dla plik=F3w AVI opcj=B1 -ni.
ds_fill_buffer: EOF reached (stream: video)
NONE :(
MPEG: B=A3=A1D KRYTYCZNY: Wykry=B3em koniec pliku podczas poszukiwania
nag=B3=F3wka sekwencji.
Wideo: Nie mog=EA wczyta=E6 w=B3a=B6ciwo=B6ci.


And after that, audio is playing, no video.

/usr/bin/dvbtraffic:

0000     9 p/s     1 kb/s    14 kbit
0001     9 p/s     1 kb/s    14 kbit
0011     1 p/s     0 kb/s     2 kbit
0012   355 p/s    65 kb/s   534 kbit
0014     1 p/s     0 kb/s     2 kbit
0065     9 p/s     1 kb/s    14 kbit
0066  1857 p/s   340 kb/s  2793 kbit
0067   306 p/s    56 kb/s   460 kbit
0068   109 p/s    20 kb/s   164 kbit
0069   150 p/s    27 kb/s   225 kbit
006f     9 p/s     1 kb/s    14 kbit
0071   131 p/s    24 kb/s   197 kbit
00c9     9 p/s     1 kb/s    14 kbit
00ca  1760 p/s   323 kb/s  2647 kbit
00cc   109 p/s    20 kb/s   164 kbit
00cd   125 p/s    22 kb/s   188 kbit
00d4     9 p/s     1 kb/s    14 kbit
00d5   131 p/s    24 kb/s   197 kbit
012d     9 p/s     1 kb/s    14 kbit
012e  1821 p/s   334 kb/s  2740 kbit
0130   109 p/s    20 kb/s   164 kbit
0131   116 p/s    21 kb/s   175 kbit
0137     9 p/s     1 kb/s    14 kbit
0139   131 p/s    24 kb/s   197 kbit
0191     9 p/s     1 kb/s    14 kbit
0192  4782 p/s   877 kb/s  7192 kbit
0193   261 p/s    47 kb/s   393 kbit
0194   109 p/s    20 kb/s   164 kbit
02bd     9 p/s     1 kb/s    14 kbit
02be  2369 p/s   434 kb/s  3563 kbit
02bf   261 p/s    47 kb/s   393 kbit
02c0   109 p/s    20 kb/s   164 kbit
1fff  1344 p/s   246 kb/s  2021 kbit
2000 16557 p/s  3039 kb/s 24901 kbit
-PID--FREQ-----BANDWIDTH-BANDWIDTH-


Unfortunatelly, dvbstream is not available for amd64...

emerge --info:
Portage 2.1.4.4 (default/linux/amd64/2008.0/desktop, gcc-4.3.1,
glibc-2.7-r2, 2.6.25-gentoo-r7 x86_64)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
System uname: 2.6.25-gentoo-r7 x86_64 Intel(R) Core(TM)2 CPU 6600 @ 2.40GHz
Timestamp of tree: Tue, 19 Aug 2008 15:34:01 +0000
distcc 2.18.3 x86_64-pc-linux-gnu (protocols 1 and 2) (default port
3632) [disabled]
ccache version 2.4 [enabled]
app-shells/bash:     3.2_p33
dev-java/java-config: 1.3.7, 2.1.6
dev-lang/python:     2.4.4-r13, 2.5.2-r6
dev-python/pycrypto: 2.0.1-r6
dev-util/ccache:     2.4-r7
sys-apps/baselayout: 1.12.11.1
sys-apps/sandbox:    1.2.18.1-r2
sys-devel/autoconf:  2.13, 2.61-r2
sys-devel/automake:  1.5, 1.7.9-r1, 1.8.5-r3, 1.9.6-r2, 1.10.1
sys-devel/binutils:  2.18-r3
sys-devel/gcc-config: 1.4.0-r4
sys-devel/libtool:   1.5.26
virtual/os-headers:  2.6.23-r3
ACCEPT_KEYWORDS=3D"amd64"
CBUILD=3D"x86_64-pc-linux-gnu"
CFLAGS=3D"-march=3Dcore2 -O2 -pipe"
CHOST=3D"x86_64-pc-linux-gnu"
CONFIG_PROTECT=3D"/etc /usr/kde/3.5/env /usr/kde/3.5/share/config
/usr/kde/3.5/shutdown /usr/share/config /var/lib/hsqldb"
CONFIG_PROTECT_MASK=3D"/etc/ca-certificates.conf /etc/env.d
/etc/env.d/java/ /etc/fonts/fonts.conf /etc/gconf /etc/revdep-rebuild
/etc/terminfo /etc/texmf/web2c /etc/udev/rules.d"
CXXFLAGS=3D"-march=3Dcore2 -O2 -pipe"
DISTDIR=3D"/usr/portage/distfiles"
FEATURES=3D"ccache collision-protect distlocks metadata-transfer
parallel-fetch sandbox sfperms strict unmerge-orphans userfetch"
GENTOO_MIRRORS=3D"http://distfiles.gentoo.org
http://distro.ibiblio.org/pub/linux/distributions/gentoo"
LANG=3D"pl_PL.utf8"
LC_ALL=3D"en_US"
LDFLAGS=3D"-Wl,-O1"
LINGUAS=3D"pl en"
MAKEOPTS=3D"-j2"
PKGDIR=3D"/usr/portage/packages"
PORTAGE_RSYNC_OPTS=3D"--recursive --links --safe-links --perms --times
--compress --force --whole-file --delete --stats --timeout=3D180
--exclude=3D/distfiles --exclude=3D/local --exclude=3D/packages"
PORTAGE_TMPDIR=3D"/var/tmp"
PORTDIR=3D"/usr/portage"
PORTDIR_OVERLAY=3D"/usr/local/portage"
SYNC=3D"rsync://rsync.gentoo.org/gentoo-portage"
USE=3D"X a52 aac acl acpi alsa amd64 asf audiofile bash-completion berkdb
bitmap-fonts bluetooth branding bzip2 cairo cdr cli cracklib crypt cups
dbus dga divx dri dv dvb dvd dvdr dvdread eds emboss encode evo fam
ffmpeg firefox flac fortran gdbm gif gpm gstreamer gtk gtk2 hal iconv
isdnlog java jikes jpeg kde kerberos ldap libnotify mad midi mikmod mmx
mng mp3 mpeg mplayer mudflap multilib ncurses nls nptl nptlonly ogg
opengl openmp pam pcre pdf perl png ppds pppd python qt3 qt3support qt4
quicktime readline reflection samba sdl session speex spell spl sse sse2
ssl startup-notification subversion svg sysfs tcpd threads tiff truetype
truetype-fonts type1-fonts unicode usb vcd vorbis wma wmf xcomposite xml
xorg xprint xv xvid zlib" ALSA_CARDS=3D"emu10k1" ALSA_PCM_PLUGINS=3D"adpcm
alaw asym copy dmix dshare dsnoop empty extplug file hooks iec958 ioplug
ladspa lfloat linear meter mmap_emul mulaw multi null plug rate route
share shm softvol" APACHE2_MODULES=3D"actions alias auth_basic authn_alias
authn_anon authn_dbm authn_default authn_file authz_dbm authz_default
authz_groupfile authz_host authz_owner authz_user autoindex cache dav
dav_fs dav_lock deflate dir disk_cache env expires ext_filter file_cache
filter headers include info log_config logio mem_cache mime mime_magic
negotiation rewrite setenvif speling status unique_id userdir usertrack
vhost_alias" ELIBC=3D"glibc" INPUT_DEVICES=3D"evdev keyboard mouse"
KERNEL=3D"linux" LCD_DEVICES=3D"bayrad cfontz cfontz633 glk hd44780 lb216
lcdm001 mtxorb ncurses text" LINGUAS=3D"pl en" USERLAND=3D"GNU"
VIDEO_CARDS=3D"nvidia"
Unset:  CPPFLAGS, CTARGET, EMERGE_DEFAULT_OPTS, INSTALL_MASK,
PORTAGE_COMPRESS, PORTAGE_COMPRESS_FLAGS, PORTAGE_RSYNC_EXTRA_OPTS


The tuner works fine on the same computer under WinXP64.

Please help me get it working in gentoo :)

I tried kaffeine with no luck:
http://forums.gentoo.org/viewtopic-p-5189357.html#5189357


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
