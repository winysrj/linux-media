Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:40900 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbZCVJHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 05:07:04 -0400
Subject: Re: TT 3650
From: Alain Kalker <miki@dds.nl>
To: Andreas Kurz <kurz.andi@gmx.at>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090308152702.258090@gmx.net>
References: <20090218092217.232120@gmx.net>
	 <20090218103353.64bf6400@free.fr> <20090223113439.90620@gmx.net>
	 <20090223131909.126d0d8c@free.fr>  <20090308152702.258090@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Mar 2009 10:06:56 +0100
Message-Id: <1237712816.6182.4.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op zondag 08-03-2009 om 16:27 uur [tijdzone +0100], schreef Andreas
Kurz:
> Hi...
> 
> Still having some problems getting this card to work for me (Suse 11.1, KDE 4.1).
> I have successfully installed the suggested non-main-repo, szap-s2 and dvbstream. 
> Unter Yast/TV-card I used the Experts button to tell the system to use a unknown tv-card with v4l2. Unfotunately dvbstream -o 8192 | vlc leaves me with 
> 
> scyth@NotebookMMC:~> dvbstream -o 8192 | vlc
> VLC media player 0.9.8a Grishenko
> [00000001] main libvlc debug: VLC media player - version 0.9.8a Grishenko - (c) 1996-2008 the VideoLAN team
> [00000001] main libvlc debug: libvlc was configured with ./configure  '--host=i686-suse-linux-gnu' '--build=i686-suse-linux-gnu' '--target=i586-suse-linux' '--program-prefix=' '--prefix=/usr' '--exec-prefix=/usr' '--bindir=/usr/bin' '--sbindir=/usr/sbin' '--sysconfdir=/etc' '--datadir=/usr/share' '--includedir=/usr/include' '--libdir=/usr/lib' '--libexecdir=/usr/lib' '--localstatedir=/var' '--sharedstatedir=/usr/com' '--mandir=/usr/share/man' '--infodir=/usr/share/info' '--disable-dependency-tracking' '--enable-gnomevfs' '--enable-ncurses' '--enable-wxwidgets' '--disable-pda' '--disable-macosx' '--disable-qnx' '--enable-xosd' '--enable-gnutls' '--enable-visual' '--disable-goom' '--enable-slp' '--enable-lirc' '--disable-joystick' '--disable-corba' '--enable-dvdread' '--enable-dvdnav' '--disable-dshow' '--enable-v4l' '--enable-v4l2' '--enable-pvr' '--enable-vcd' '--enable-satellite' '--enable-ogg' '--enable-mkv' '--enable-mod' '--enable-libcdio' '--enable-vcdx' '--enable-cddax' '--enable-libcddb' '--enable-x11' '--enable-xvideo' '--enable-glx' '--enable-fb' '--enable-mga' '--enable-freetype' '--enable-fribidi' '--disable-svg' '--disable-directx' '--disable-wingdi' '--disable-glide' '--enable-aa' '--enable-caca' '--enable-oss' '--disable-esd' '--enable-arts' '--enable-waveout' '--disable-coreaudio' '--disable-hd1000a' '--disable-hd1000v' '--enable-mad' '--enable-ffmpeg' '--enable-faad' '--enable-a52' '--enable-dca' '--enable-flac' '--enable-libmpeg2' '--enable-vorbis' '--enable-tremor' '--enable-speex' '--disable-tarkin' '--enable-theora' '--enable-cmml' '--enable-utf8' '--enable-pth' '--disable-st' '--disable-gprof' '--disable-cprof' '--disable-testsuite' '--enable-optimizations' '--disable-altivec' '--disable-debug' '--enable-release' '--enable-sout' '--with-ffmpeg-faac' '--disable-galaktos' '--enable-httpd' '--enable-jack' '--enable-mozilla' '--enable-alsa' '--enable-real' '--enable-realrtsp' '--enable-live555' '--with-live555-tree=/usr/lib/live' '--enable-fast-install' '--enable-dvbpsi' '--enable-dvb' '--enable-lua' '--enable-pulse' '--enable-asademux' '--enable-libproxy' '--enable-libass' '--enable-kate' '--enable-smb' '--enable-taglib' 'build_alias=i686-suse-linux-gnu' 'host_alias=i686-suse-linux-gnu' 'target_alias=i586-suse-linux' 'CFLAGS=-march=i586 -mtune=i686 -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables' 'CXXFLAGS=-march=i586 -mtune=i686 -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables'
> [00000001] main libvlc debug: translation test: code is "de"
> dvbstream v0.6 - (C) Dave Chapman 2001-2004
> Released under the GPL.
> Latest version available from http://www.linuxstb.org/
> dvbstream will stop after -1 seconds (71582788 minutes)
> FD 0: DEMUX DEVICE: : No such file or directory
> [00000001] main libvlc: vlc wird mit dem Standard-Interface ausgeführt. Benutzen Sie 'cvlc', um vlc ohne Interface zu verwenden.
> 
> 
> With the most important part: 
> 
> FD 0: DEMUX DEVICE: : No such file or directory
> 
> 
> lsusb gives me:
> Bus 004 Device 003: ID 0b48:300d TechnoTrend AG TT-connect CT-3650 CI

Forgive me for asking, but does this card really work with the s2api
driver? If I'm not mistaken, the S2-3650 and the CT-3650 are different
beasts, one is DVB-S, the other is DVB-C/T and uses totally different
chipset, see:

http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026288.html

Kind regards,

Alain

