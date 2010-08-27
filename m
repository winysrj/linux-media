Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752758Ab0H0Txd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 15:53:33 -0400
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: new kmemleak in kernel 2.6.35.4
Date: Fri, 27 Aug 2010 21:53:30 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008272153.30664.toralf.foerster@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

compared to  2.6.34.x this kmemleak seems to be new at my ThinkPad T400 under 
an almost stable Gentoo Linux w/ a 'Terratec Cinergy T USB XXS (HD)/ T3' :

tfoerste@n22 ~ $ cat /sys/kernel/debug/kmemleak
unreferenced object 0xcabeb320 (size 32):
  comm "modprobe", pid 9285, jiffies 16386098 (age 7416.020s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c122f8d7>] kmemleak_alloc+0x27/0x50
    [<c109c34f>] kmem_cache_alloc+0x9f/0xe0
    [<fcb8d91d>] dib0700_rc_setup+0x7d/0x120 [dvb_usb_dib0700]
    [<fcb8da54>] dib0700_probe+0x94/0xb0 [dvb_usb_dib0700]
    [<f86385b4>] usb_probe_interface+0xf4/0x1c0 [usbcore]
    [<c11892cb>] driver_probe_device+0x7b/0x190
    [<c1189471>] __driver_attach+0x91/0xa0
    [<c1188b88>] bus_for_each_dev+0x48/0x70
    [<c1189159>] driver_attach+0x19/0x20
    [<c1188567>] bus_add_driver+0x187/0x250
    [<c1189705>] driver_register+0x65/0x120
    [<f863829c>] usb_register_driver+0x7c/0x140 [usbcore]
    [<fcb9c030>] 0xfcb9c030
    [<c100112d>] do_one_initcall+0x2d/0x180
    [<c105ecf9>] sys_init_module+0x99/0x1e0
    [<c1002d97>] sysenter_do_call+0x12/0x26



-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

