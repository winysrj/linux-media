Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44116 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZBSX1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 18:27:45 -0500
Received: by bwz5 with SMTP id 5so1867407bwz.13
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 15:27:43 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 00:27:42 +0100
Message-ID: <bcb3ef430902191527hb68e16fveffae7e43c704190@mail.gmail.com>
Subject: Terratec Cinergy C HD (PCI, DVB-C): how to make it work?
From: MartinG <gronslet@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, I'm new to this list and new to DVB in general.
I've just bought a Terratec Cinergy C HD DVB-C card,
since I've read it is working in Linux.

However, I've got into some trouble when trying to compile the modules.
I've read http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C where
it is suggested to use the s2-liplianin driver from
http://mercurial.intuxication.org/hg/s2-liplianin
(a bit strange, as that seems to be a DVB-S2 driver, while this card
is DVB-C...)
Anyway, it failed building. So I tried the mantis driver from
http://jusst.de/hg/mantis, but also failed:

$ make
make -C /home/gronslet/Download/mantis/v4l
make[1]: Entering directory `/home/gronslet/Download/mantis/v4l'
No version yet, using 2.6.29-rc2
make[1]: Leaving directory `/home/gronslet/Download/mantis/v4l'
make[1]: Entering directory `/home/gronslet/Download/mantis/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.29
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/gronslet/Download/mantis/v4l'
make[1]: Entering directory `/home/gronslet/Download/mantis/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.29-rc2/source
./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
Kernel build directory is /lib/modules/2.6.29-rc2/build
make -C /lib/modules/2.6.29-rc2/build
SUBDIRS=/home/gronslet/Download/mantis/v4l  modules
make[2]: Entering directory `/mythmedia/buffer/drm-2.6'
  CC [M]  /home/gronslet/Download/mantis/v4l/tuner-xc2028.o
In file included from /home/gronslet/Download/mantis/v4l/tuner-xc2028.h:11,
                 from /home/gronslet/Download/mantis/v4l/tuner-xc2028.c:22:
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:52: error: field
'fe_params' has incomplete type
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:297: warning:
'struct dvbfe_info' declared inside parameter list
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:297: warning: its
scope is only this definition or declaration, which is probably not
what you want
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:298: warning: 'enum
dvbfe_delsys' declared inside parameter list
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:299: warning: 'enum
dvbfe_delsys' declared inside parameter list
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:316: error: field
'fe_events' has incomplete type
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:317: error: field
'fe_params' has incomplete type
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:354: warning: 'enum
dvbfe_fec' declared inside parameter list
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:354: warning: 'enum
dvbfe_modulation' declared inside parameter list
/home/gronslet/Download/mantis/v4l/dvb_frontend.h:359: warning: 'enum
dvbfe_delsys' declared inside parameter list
make[3]: *** [/home/gronslet/Download/mantis/v4l/tuner-xc2028.o] Error 1
make[2]: *** [_module_/home/gronslet/Download/mantis/v4l] Error 2
make[2]: Leaving directory `/mythmedia/buffer/drm-2.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/gronslet/Download/mantis/v4l'
make: *** [all] Error 2

I also tried:
$ hg clone http://linuxtv.org/hg/v4l-dvb
$ cd v4l-dvb
$ make
$ sudo make install

and that worked.
But it didn't install a "mantis" module, so I'm not sure what to modprobe...
A reboot didn't give any interesting info from "dmesg" either,
possibly except for this:

w83627ehf: Found W83627DHG chip at 0x290
ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region
HWRE [0x290-0x299]
ACPI: Device needs an ACPI driver

The full dmesg output can be found here: http://fpaste.org/paste/4085

This is using a 2.6.29 kernel from git (since my first attempts using
a Fedora kernel (and -headers, -devel) from the repos failed)

Actually, I've also tried "make reload" (in the v4l-dvb directory),
and gave a bunch of info/errors, see http://fpaste.org/paste/4086.
Among them:
ivtv: Start initialization, version 1.4.0
ivtv: End initialization

So I guess my questions are:
1) what modules do I need to get this card working?
2) what is the latest kernel version known to work?
3) Is this the right place to ask? (If not, where?  should I file a
bug somewhere?)

Some more info:
# lspci -vnn -s 04:00.0
04:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at fdfff000 (32-bit, prefetchable) [size=4K]

# uname -r
2.6.29-rc2
(from commit 1de9e8e70f5acc441550ca75433563d91b269bbe Author: Linus Torvalds)

Any suggestions appreciated!

-MartinG
