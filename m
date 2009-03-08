Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752098AbZCHP1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 11:27:06 -0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="iso-8859-1"
Date: Sun, 08 Mar 2009 16:27:02 +0100
From: "Andreas Kurz" <kurz.andi@gmx.at>
In-Reply-To: <20090223131909.126d0d8c@free.fr>
Message-ID: <20090308152702.258090@gmx.net>
MIME-Version: 1.0
References: <20090218092217.232120@gmx.net>	<20090218103353.64bf6400@free.fr>
	<20090223113439.90620@gmx.net> <20090223131909.126d0d8c@free.fr>
Subject: Re: TT 3650
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi...

Still having some problems getting this card to work for me (Suse 11.1, KDE 4.1).
I have successfully installed the suggested non-main-repo, szap-s2 and dvbstream. 
Unter Yast/TV-card I used the Experts button to tell the system to use a unknown tv-card with v4l2. Unfotunately dvbstream -o 8192 | vlc leaves me with 

scyth@NotebookMMC:~> dvbstream -o 8192 | vlc
VLC media player 0.9.8a Grishenko
[00000001] main libvlc debug: VLC media player - version 0.9.8a Grishenko - (c) 1996-2008 the VideoLAN team
[00000001] main libvlc debug: libvlc was configured with ./configure  '--host=i686-suse-linux-gnu' '--build=i686-suse-linux-gnu' '--target=i586-suse-linux' '--program-prefix=' '--prefix=/usr' '--exec-prefix=/usr' '--bindir=/usr/bin' '--sbindir=/usr/sbin' '--sysconfdir=/etc' '--datadir=/usr/share' '--includedir=/usr/include' '--libdir=/usr/lib' '--libexecdir=/usr/lib' '--localstatedir=/var' '--sharedstatedir=/usr/com' '--mandir=/usr/share/man' '--infodir=/usr/share/info' '--disable-dependency-tracking' '--enable-gnomevfs' '--enable-ncurses' '--enable-wxwidgets' '--disable-pda' '--disable-macosx' '--disable-qnx' '--enable-xosd' '--enable-gnutls' '--enable-visual' '--disable-goom' '--enable-slp' '--enable-lirc' '--disable-joystick' '--disable-corba' '--enable-dvdread' '--enable-dvdnav' '--disable-dshow' '--enable-v4l' '--enable-v4l2' '--enable-pvr' '--enable-vcd' '--enable-satellite' '--enable-ogg' '--enable-mkv' '--enable-mod' '--enable-libcdio' '--enable-vcdx' '--enable-cddax' '--enable-libcddb' '--enable-x11' '--enable-xvideo' '--enable-glx' '--enable-fb' '--enable-mga' '--enable-freetype' '--enable-fribidi' '--disable-svg' '--disable-directx' '--disable-wingdi' '--disable-glide' '--enable-aa' '--enable-caca' '--enable-oss' '--disable-esd' '--enable-arts' '--enable-waveout' '--disable-coreaudio' '--disable-hd1000a' '--disable-hd1000v' '--enable-mad' '--enable-ffmpeg' '--enable-faad' '--enable-a52' '--enable-dca' '--enable-flac' '--enable-libmpeg2' '--enable-vorbis' '--enable-tremor' '--enable-speex' '--disable-tarkin' '--enable-theora' '--enable-cmml' '--enable-utf8' '--enable-pth' '--disable-st' '--disable-gprof' '--disable-cprof' '--disable-testsuite' '--enable-optimizations' '--disable-altivec' '--disable-debug' '--enable-release' '--enable-sout' '--with-ffmpeg-faac' '--disable-galaktos' '--enable-httpd' '--enable-jack' '--enable-mozilla' '--enable-alsa' '--enable-real' '--enable-realrtsp' '--enable-live555' '--with-live555-tree=/usr/lib/live' '--enable-fast-install' '--enable-dvbpsi' '--enable-dvb' '--enable-lua' '--enable-pulse' '--enable-asademux' '--enable-libproxy' '--enable-libass' '--enable-kate' '--enable-smb' '--enable-taglib' 'build_alias=i686-suse-linux-gnu' 'host_alias=i686-suse-linux-gnu' 'target_alias=i586-suse-linux' 'CFLAGS=-march=i586 -mtune=i686 -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables' 'CXXFLAGS=-march=i586 -mtune=i686 -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables'
[00000001] main libvlc debug: translation test: code is "de"
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
dvbstream will stop after -1 seconds (71582788 minutes)
FD 0: DEMUX DEVICE: : No such file or directory
[00000001] main libvlc: vlc wird mit dem Standard-Interface ausgeführt. Benutzen Sie 'cvlc', um vlc ohne Interface zu verwenden.


With the most important part: 

FD 0: DEMUX DEVICE: : No such file or directory


lsusb gives me:
Bus 004 Device 003: ID 0b48:300d TechnoTrend AG TT-connect CT-3650 CI

lsmod
v4l1_compat            12380  1 videodev

dmesg | grep v4l
uvcvideo: disagrees about version of symbol v4l_compat_translate_ioctl
uvcvideo: Unknown symbol v4l_compat_translate_ioctl


Thank you in advance...

Andy

-------- Original-Nachricht --------
> Datum: Mon, 23 Feb 2009 13:19:09 +0100
> Von: Jean-Francois Moine <moinejf@free.fr>
> An: "Andreas Kurz" <kurz.andi@gmx.at>
> CC: linux-media@vger.kernel.org
> Betreff: Re: TT 3650

> On Mon, 23 Feb 2009 12:34:39 +0100
> "Andreas Kurz" <kurz.andi@gmx.at> wrote:
> 
> > Concerning this card (TT 3650 CI) in combination with the
> > non-repo-driver (suggested below): which tuner should I use? Is there
> > a special one needed?
> 
> Hi Andreas,
> 
> By tuner, do you mean the program to watch TV?
> 
> I use 'vlc' with a playing list for DVB-S. For DVB-S2, I must use
> 'szap-s2' to select the transponder and 'dvbstream' + 'vlc':
> 	dvbstream -o 8192 | vlc -
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/

-- 
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
für nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a

-- 
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
für nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a
