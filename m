Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1DSDGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 23:06:51 -0400
Received: by ewy4 with SMTP id 4so1575839ewy.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 20:06:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 13:06:49 +1000
Message-ID: <BANLkTinp69oB1qCK_ieX8vYm3F+Qd=e2mg@mail.gmail.com>
Subject: imon: spews to dmesg
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi list,

I just (2011-04-19) upgraded to the current media_build with build.sh
 commit bcfdefe9f4538abf12fca1cdb631c80e3d598026
 Author: Mauro Carvalho Chehab <mchehab@nehalem.(none)>
 Date:   Sun Apr 17 08:21:25 2011 -0300
and hit a problem.

I have an Antec case with an LCD screen. It needs the imon driver.
The LCD screen has been working well using media_build from 2011-01-30.

The imon kernel module now spews this at a high rate:
[   38.532581] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.544545] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.552548] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.560560] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.568546] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.576557] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.584554] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.592558] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.600533] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.608551] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.620024] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.636034] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.652034] imon 9-1:1.0: lcd_write: write 8 bytes to LCD

If I stop LCDd
 # /etc/init.d/LCDd stop
the spew stops.


I'm running on ubuntu 10.04 i386, with lcdproc 0.5.3-0ubuntu2.
$ uname -a
Linux ubuntu  2.6.32-27-generic #49-Ubuntu SMP Wed Dec 1 23:52:12 UTC
2010 i686 GNU/Linux
$ modinfo imon
filename:       /lib/modules/2.6.32-27-generic/kernel/drivers/media/rc/imon.ko
license:        GPL
version:        0.9.2
description:    Driver for SoundGraph iMON MultiMedia IR/Display
author:         Jarod Wilson <jarod@wilsonet.com>
srcversion:     268453AC090EFB24F487BE7
alias:          usb:v15C2p0046d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0045d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0044d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0043d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0042d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0041d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0040d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p003Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0039d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0038d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0037d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0036d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0035d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2p0034d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C2pFFDCd*dc*dsc*dp*ic*isc*ip*
depends:        rc-core
vermagic:       2.6.32-27-generic SMP mod_unload modversions 586
parm:           debug:Debug messages: 0=no, 1=yes (default: no) (bool)
parm:           display_type:Type of attached display. 0=autodetect,
1=vfd, 2=lcd, 3=vga, 4=none (default: autodetect) (int)
parm:           pad_stabilize:Apply stabilization algorithm to iMON
PAD presses in arrow key mode. 0=disable, 1=enable (default). (int)
parm:           nomouse:Disable mouse input device mode when IR device
is open. 0=don't disable, 1=disable. (default: don't disable) (bool)
parm:           pad_thresh:Threshold at which a pad push registers as
an arrow key in kbd mode (default: 28) (int)

The module load looks normal:
$ dmesg|grep imon
[    4.454786] imon 9-1:1.0: imon_probe: found iMON device (15c2:ffdc, intf0)
[    4.454794] imon 9-1:1.0: imon_find_endpoints: found IR endpoint
[    4.454794] imon 9-1:1.0: imon_find_endpoints: found display endpoint
[    4.472053] imon 9-1:1.0: 0xffdc iMON LCD, MCE IR (id 0x9f)
[    5.024035] Registered IR keymap rc-imon-mce
[    5.024173] imon 9-1:1.0: Configuring IR receiver for MCE protocol
[    5.032117] imon 9-1:1.0: Registering iMON display with sysfs
[    5.032173] imon 9-1:1.0: iMON device (15c2:ffdc, intf0) on
usb<9:2> initialized
[    5.032198] usbcore: registered new interface driver imon

Then the display port is opened...
[   38.519700] imon 9-1:1.0: display port opened
[   38.532581] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.544545] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.552548] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.560560] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.568546] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.576557] imon 9-1:1.0: lcd_write: write 8 bytes to LCD
[   38.584554] imon 9-1:1.0: lcd_write: write 8 bytes to LCD

I don't have any load options defined for the imon module.

Can anyone shed light on why the module is spewing to dmesg,
and what should I do to fix it ?

Thanks
Vince
