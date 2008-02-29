Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV8Q8-0000jx-G9
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 17:49:16 +0100
Received: by rv-out-0910.google.com with SMTP id b22so3264303rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 08:48:58 -0800 (PST)
Message-ID: <d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>
Date: Fri, 29 Feb 2008 17:48:58 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C83611.1040805@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C83611.1040805@powercraft.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Pinnacle PCTV Hybrid Pro Stick 330e - Installation
	Guide - v0.1.2j
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

Hi Jelle,

On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> This message contains the following attachment(s):
> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
>

the correct mailinglist for those devices is em28xx at mcentral dot de

I added some comments below and prefixed them with /////////

This message contains the following attachment(s):
 Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt

#!/bin/bash

 #       Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.1j.txt
 #
 #       Copyright 2008 Jelle de Jong <jelledejong@powercraft.nl>
 #
 #       This program is free software; you can redistribute it and/or modify
 #       it under the terms of the GNU General Public License as published by
 #       the Free Software Foundation; either version 2 of the License, or
 #       (at your option) any later version.
 #
 #       This program is distributed in the hope that it will be useful,
 #       but WITHOUT ANY WARRANTY; without even the implied warranty of
 #       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #       GNU General Public License for more details.
 #
 #       You should have received a copy of the GNU General Public License
 #       along with this program; if not, write to the Free Software
 #       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 #       MA 02110-1301, USA.

 # to-do:
 # howto add group for created devices so that all users in that group
can use the devices?

 # notes:
 # there is less then 10% cpu load on an ASUS eeepc when watching
analog tv with xawtv, is there hardware encoding?
 # how to watch teletext?
 # no audio yet, need to find out how to channel the audio to my
primary soundcard, without lossing sync!

///////////
use tvtime from mcentral.de it runs well on my eeePC and audio is also
in sync, I tested it with NTSC, PAL-BG and SECAM.


 # support:
 # email the linux-dvb mailinglist
//////////
email the em28xx mailinglist!

 # step 0: only do this if you already tried to compile some linux drivers
 sudo apt-get remove linux-image-(uname -r) linux-headers linux-source
linux-headers-$(uname -r)
 sudo apt-get autoremove
 sudo rm -r -f /usr/src/*
 sudo rm -r -f /lib/modules/*

 sudo apt-get install atl2-modules-2.6.24-1-686 linux-image-2.6.24-1-686
 sudo update-grub

 # step 1: update your system
 sudo apt-get clean
 sudo apt-get update
 sudo apt-get upgrade
 sudo apt-get autoremove

 # step 2: clean your system
 sudo apt-get remove linux-headers linux-source linux-headers-$(uname -r)
 sudo apt-get autoremove

 # step 3: install the necessary tools
 sudo apt-get install linux-source linux-headers-$(uname -r)
build-essential mercurial

 # step 4: extract the kernel source
 cd /usr/src
 sudo tar --bzip2 -xvf linux-source-2.6.*.tar.bz2
 cd ~

 # step 5: remove old symlinks when present
 sudo rm /usr/src/linux
 sudo rm /lib/modules/$(uname -r)/source

 # step 6: create new sysmlinks, change the kernel to its current version
 sudo ln -s /usr/src/linux-source-2.6.24 /usr/src/linux
 sudo ln -s /usr/src/linux-source-2.6.24 /lib/modules/$(uname -r)/source

 # step 7: copy your orignal config to the kernel source root tree
 sudo cp --verbose /boot/config-$(uname -r) /usr/src/linux/.config

 # step 8: check if the symlink and kernel source is there
 ls -hal /usr/src/
 #total 44M
 #drwxrwsr-x  6 root src  4.0K Feb 29 15:16 .
 #drwxr-xr-x 11 root root 4.0K Feb 23 00:32 ..
 #lrwxrwxrwx  1 root src    28 Feb 29 15:16 linux ->
/usr/src/linux-source-2.6.24
 #drwxr-xr-x  4 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-686
 #drwxr-xr-x 18 root root 4.0K Feb 29 15:10 linux-headers-2.6.24-1-common
 #drwxr-xr-x  3 root root 4.0K Feb 29 15:10 linux-kbuild-2.6.24
 #drwxr-xr-x 20 root root 4.0K Feb 29 15:17 linux-source-2.6.24
 #-rw-r--r--  1 root root  44M Feb 11 12:42 linux-source-2.6.24.tar.bz2

 # step 9: make sure all these files and locations excist
 ls -hal /lib/modules/$(uname -r)/source
 ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dmxdev.h
 ls -hal /lib/modules/$(uname
-r)/source/drivers/media/dvb/dvb-core/dvb_frontend.h
 ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_demux.h
 ls -hal /lib/modules/$(uname -r)/source/drivers/media/dvb/dvb-core/dvb_net.h
 ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h
 ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
 ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_demux.h
 ls -hal /usr/src/linux/drivers/media/dvb/dvb-core/dvb_net.h

 # step 10: download and build the first driver necessary to build the
second one
 cd ~
 sudo rm -r userspace-drivers
 hg clone http://mcentral.de/hg/~mrec/userspace-drivers
 cd userspace-drivers
 sudo ./build.sh
 cd ~

 # step 11: download and build the second driver after you build the first one
 cd ~
 sudo rm -r em28xx-userspace2
 hg clone http://mcentral.de/hg/~mrec/em28xx-userspace2
 cd em28xx-userspace2
 sudo ./build.sh
 cd ~

 # step 12: reboot your computer just to be on the save side
 sudo shutdown -r now

 # step 12: load the main userspace kernel module that should load all others to
 sudo modprobe em28xx-dvb

////////
the module gets loaded automatically, this is not needed at all.

 # step 13: plugin the device and check the dmesg output
 dmesg

 # step 14: install completed exiting, please look at the uing guide
for more info
 exit

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
