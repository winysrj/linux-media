Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751787Ab0DSQnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 12:43:16 -0400
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: kmemleak from module dvb_usb_dib0700
Date: Mon, 19 Apr 2010 18:43:12 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004191843.13249.toralf.foerster@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

with current git kernel -rc4 I get this kmemleak if I plugin this stick 
('Terratec Cinergy T USB XXS (HD)/ T3') into my ThinkPad T400 under a stable 
Gentoo system :

tfoerste@n22 ~ $ cat /sys/kernel/debug/kmemleak
unreferenced object 0xf40c0fa0 (size 32):
  comm "modprobe", pid 28848, jiffies 21186033 (age 3785.635s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c122caed>] kmemleak_alloc+0x3d/0x60
    [<c109c137>] kmem_cache_alloc+0xa7/0xe0
    [<fc630a35>] dib0700_rc_setup+0xb5/0x170 [dvb_usb_dib0700]
    [<fc630b76>] dib0700_probe+0x86/0xa0 [dvb_usb_dib0700]
    [<f8716c81>] usb_probe_interface+0xc1/0x1e0 [usbcore]
    [<c1186f4d>] driver_probe_device+0x7d/0x190
    [<c11870f1>] __driver_attach+0x91/0xa0
    [<c11867f3>] bus_for_each_dev+0x53/0x80
    [<c1186dd9>] driver_attach+0x19/0x20
    [<c11860bf>] bus_add_driver+0xaf/0x260
    [<c1187395>] driver_register+0x75/0x170
    [<f871690c>] usb_register_driver+0x7c/0x140 [usbcore]
    [<fc63f030>] 0xfc63f030
    [<c1001123>] do_one_initcall+0x23/0x180
    [<c105fc7f>] sys_init_module+0xaf/0x210
    [<c1002cd7>] sysenter_do_call+0x12/0x26

I'm wondering whether this is harmful or not. - OTOH my system do not wakeup 
after suspend2ram if the stick was plugged in ...

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

