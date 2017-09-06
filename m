Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdIFTUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 15:20:16 -0400
MIME-Version: 1.0
Message-ID: <trinity-e1aa6ee8-e9cc-4001-8e19-92255757329d-1504725614678@3c-app-gmx-bs76>
From: =?UTF-8?Q?=22Oliver_M=C3=BCller=22?= <oliver.mueller85@gmx.net>
To: linux-media@vger.kernel.org
Subject: BUGREPORT: IR keytable 1.12.3
Content-Type: text/plain; charset=UTF-8
Date: Wed, 6 Sep 2017 21:20:14 +0200
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BUG IR keytable 1.12.3
 
OS: Distributor ID:    Debian
    Description:    Debian GNU/Linux 9.1 (stretch)
    Release:    9.1
    Codename:    stretch
 
Kernel: 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u3 (2017-08-06) x86_64 GNU/Linux
 
Programversion: IR keytable control version 1.12.3
 
IR-Device: I: Bus=0003 Vendor=0471 Product=20cc Version=0100
           N: Name="PHILIPS MCE USB IR Receiver- Spinel plus"
           P: Phys=usb-0000:06:00.0-2/input0
           S: Sysfs=/devices/pci0000:00/0000:00:15.2/0000:06:00.0/usb1/1-2/1-2:1.0/0003:0471:20CC.0006/input/input14
           U: Uniq=
           H: Handlers=sysrq kbd leds event3
           B: PROP=0
           B: EV=120013
           B: KEY=c0000 40000000000 0 58000 8001f84000c004 e0beffdf01cfffff fffffffffffffffe
           B: MSC=10
           B: LED=1f
 
ir-keytable gives /sys/class/rc/: No such file or directory
 
using ir-keytable -d /dev/input/event3 I get this output with no mention of the protocol(s):
Name: PHILIPS MCE USB IR Receiver- Spi
bus: 3, vendor/product: 0471:20cc, version: 0x0100
 
if I use ir-keytable -s rc0 instead it comes back to /sys/class/rc/: No such file or directory which is also true
 
ir-keytable -d /dev/input/event3 -t works, ir-keytable -d /dev/input/event3 -r also works
 
after I introduce the new keymap, like so ir-keytable -d /dev/input/event3 -c -w /etc/rc_keymaps/rc6_mce_zotac_zbox-ad05br it doesn't work. I can't read the newly introduced keymap nor can I test it. Of course can't I be sure which protocol to use because it's not displayed in the initial output.
 
thx in advance
