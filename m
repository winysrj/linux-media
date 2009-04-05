Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39723 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZDESQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 14:16:27 -0400
Received: by ewy9 with SMTP id 9so1627348ewy.37
        for <linux-media@vger.kernel.org>; Sun, 05 Apr 2009 11:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5ec8ebd50904050933w660c130wd31b1d46a53884df@mail.gmail.com>
References: <5ec8ebd50903271106n14f0e2b7m1495ef135be0cd90@mail.gmail.com>
	 <49CD2868.9080502@kaiser-linux.li>
	 <5ec8ebd50903311144h316c7e3bmd30ce2c3d5a268ee@mail.gmail.com>
	 <49D4EAB2.4090206@control.lth.se>
	 <5ec8ebd50904050933w660c130wd31b1d46a53884df@mail.gmail.com>
Date: Sun, 5 Apr 2009 21:16:23 +0300
Message-ID: <5ec8ebd50904051116l62b9529l690b03b8a9957c5a@mail.gmail.com>
Subject: Fwd: topro 6800 driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 2, 2009 at 7:41 PM, Anders Blomdell
<anders.blomdell@control.lth.se> wrote:
>> However I still no luck with it neither on F-9 kernel nor 2.6.29+ (git
>> HEAD from Saturday).
>> The driver is loaded ok, but no program can capture a picture.
> What programs did you try?
>
> On my 2.6.27.19-170.2.35.fc10.i686 the following works:
Ok, today I've updated system to F-10.

[andy@dhcppc38 ~]$ uname -a
Linux dhcppc38 2.6.27.21-170.2.56.fc10.i686 #1 SMP Mon Mar 23 23:37:54
EDT 2009 i686 i686 i386 GNU/Linux

[andy@dhcppc38 ~]$ modinfo tp6800
filename:       /lib/modules/2.6.27.21-170.2.56.fc10.i686/extra/tp6800.ko
license:        GPL
author:         Anders Blomdell <anders.blomdell@control.lth.se>
description:    Topro TP6800 gspca webcam driver
srcversion:     1FF6924D74770F52CB21F9F
alias:          usb:v06A2p0003d*dc*dsc*dp*ic*isc*ip*
depends:        gspca_main
vermagic:       2.6.27.21-170.2.56.fc10.i686 SMP mod_unload 686 4KSTACKS

[andy@dhcppc38 ~]$ lsusb
...
Bus 002 Device 003: ID 06a2:0003 Topro Technology, Inc.
...

>  mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480

[andy@dhcppc38 ~]$ mplayer tv:// -tv
driver=v4l2:device=/dev/video0:width=640:height=480
MPlayer SVN-r28461-4.3.2 (C) 2000-2009 MPlayer Team
...
Selected device: USB Camera (06a2:0003)
...
 Current format: unknown (0x4745504a)
tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
v4l2: ioctl enum norm failed: Invalid argument
Error: Cannot set norm!
Selected input hasn't got a tuner!
v4l2: Cannot get fps
v4l2: ioctl set mute failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmjpeg] vfm: ffmpeg (FFmpeg MJPEG decoder)
==========================================================================
Audio: no sound
Starting playback...
v4l2: select timeout ??% ??,?% 0 0
v4l2: select timeout ??% ??,?% 0 0
v4l2: select timeout ??% ??,?% 0 0
V:   0.0   8/  8 ??% ??% ??,?% 0 0

MPlayer interrupted by signal 2 in module: video_read_frame
v4l2: select timeout
v4l2: select timeout ??% ??,?% 0 0
v4l2: ioctl set mute failed: Invalid argument
v4l2: 0 frames successfully processed, 1 frames dropped.

Exiting... (Quit)

So, the same effect on 2.6.29.

vlc:
[andy@dhcppc38 ~]$ vlc v4l2://dev/video0:width=640:height=480
VLC media player 0.9.8a Grishenko
[00000001] main libvlc debug: VLC media player - version 0.9.8a
Grishenko - (c) 1996-2008 the VideoLAN team
[00000001] main libvlc debug: libvlc was configured with ./configure
'--build=i686-pc-linux-gnu' '--host=i686-pc-linux-gnu'
'--target=i386-redhat-linux-gnu' '--program-prefix=' '--prefix=/usr'
'--exec-prefix=/usr' '--bindir=/usr/bin' '--sbindir=/usr/sbin'
'--sysconfdir=/etc' '--datadir=/usr/share' '--includedir=/usr/include'
'--libdir=/usr/lib' '--libexecdir=/usr/libexec' '--localstatedir=/var'
'--sharedstatedir=/usr/com' '--mandir=/usr/share/man'
'--infodir=/usr/share/info' '--disable-dependency-tracking'
'--disable-rpath' '--enable-release' '--with-tuning=no'
'--enable-switcher' '--enable-shout' '--enable-live555'
'--enable-opencv' '--enable-v4l' '--enable-pvr' '--enable-gnomevfs'
'--enable-cddax' '--enable-faad' '--enable-twolame' '--enable-real'
'--enable-realrtsp' '--enable-flac' '--enable-tremor' '--enable-speex'
'--enable-tarkin' '--enable-theora' '--enable-svg' '--enable-snapshot'
'--enable-svgalib' '--enable-xvmc' '--enable-directfb' '--enable-aa'
'--enable-caca' '--enable-jack' '--enable-portaudio' '--enable-pulse'
'--enable-ncurses' '--enable-xosd' '--enable-fbosd'
'--enable-galaktos' '--enable-lirc' '--enable-loader'
'--enable-mozilla' 'build_alias=i686-pc-linux-gnu'
'host_alias=i686-pc-linux-gnu' 'target_alias=i386-redhat-linux-gnu'
'CFLAGS=-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions
-fstack-protector --param=ssp-buffer-size=4 -m32 -march=i386
-mtune=generic -fasynchronous-unwind-tables' 'CXXFLAGS=-O2 -g -pipe
-Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m32 -march=i386 -mtune=generic
-fasynchronous-unwind-tables'
'PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig'
[00000001] main libvlc debug: translation test: code is "ru"
[00000001] main libvlc: Running vlc with the default interface. Use
'cvlc' to use vlc without interface.
[00000432] v4l2 demux error: cannot open video device (No such file or
directory)
ALSA lib pcm.c:2202:(snd_pcm_open_noupdate) Unknown PCM dev/video0
[00000432] v4l2 demux error: cannot open device dev/video0 for ALSA
audio (No such file or directory)
[00000432] v4l2 demux error: cannot open device dev/video0 for OSS
audio (No such file or directory)
libv4l2: error dequeuing buf: Input/output error
[00000432] v4l2 demux error: Failed to wait (VIDIOC_DQBUF)
libv4l2: error dequeuing buf: Input/output error

What did you do specific in F-10 to start camera?

-- 
With Best Regards,
Andy Shevchenko
