Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:36015 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbbCEH5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 02:57:47 -0500
Message-ID: <54F80AB4.90102@free.fr>
Date: Thu, 05 Mar 2015 08:50:12 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
MIME-Version: 1.0
CC: eric.valette@free.fr
Subject: usb 2-1: BOGUS urb xfer, pipe 3 != type 1 while loading a USB
 dvb-t driver (Terratec Cinergy DT USB XS Diversity/ T5 stick)
References: <54F371A3.9030203@free.fr>
In-Reply-To: <54F371A3.9030203@free.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: CPU: 0 PID: 172 at 
/usr/src/linux-3.14.34/drivers/usb/core/urb.c:450 
usb_submit_urb+0x297/0x449()
[    4.133281] usb 2-1: BOGUS urb xfer, pipe 3 != type 1
[    4.133285] Modules linked in: dvb_usb_dib0700(+) dib3000mc dib8000 
dvb_usb dib0070 dib7000m dib0090 dib7000p dibx000_common nvidia(PO)
[    4.133313] CPU: 0 PID: 172 Comm: systemd-udevd Tainted: P 
O 3.14.34 #23
[    4.133323] Hardware name: To Be Filled By O.E.M. To Be Filled By 
O.E.M./MCP7A-ION, BIOS 080015  07/17/2009
[    4.133330]  0000000000000006 ffffffff814a6a64 ffff88005cf2bb48 
ffffffff8103285e
[    4.133339]  ffffffff8130d68b ffff88005cea1a80 ffff88005cf2bba0 
ffff88005d981000
[    4.133347]  0000000000000003 ffffffff810328b6 ffffffff817f667d 
0000000000000030
[    4.133355] Call Trace:
[    4.133369]  [<ffffffff814a6a64>] ? dump_stack+0x49/0x6a
[    4.133380]  [<ffffffff8103285e>] ? warn_slowpath_common+0x6f/0x84
[    4.133395]  [<ffffffff8130d68b>] ? usb_submit_urb+0x297/0x449
[    4.133404]  [<ffffffff810328b6>] ? warn_slowpath_fmt+0x43/0x4b
[    4.133414]  [<ffffffff8130de30>] ? usb_control_msg+0xdc/0xed
[    4.133423]  [<ffffffff8130d68b>] ? usb_submit_urb+0x297/0x449
[    4.133447]  [<ffffffffa204edcd>] ? dib0700_rc_setup+0xc1/0xf1 
[dvb_usb_dib0700]
[    4.133473]  [<ffffffffa204ee9c>] ? dib0700_probe+0x9f/0xb8 
[dvb_usb_dib0700]
[    4.133485]  [<ffffffff81310ee6>] ? usb_probe_interface+0x126/0x1bf
[    4.133498]  [<ffffffff812b649f>] ? driver_probe_device+0xa0/0x1cc
[    4.133508]  [<ffffffff812b664f>] ? __driver_attach+0x53/0x73
[    4.133517]  [<ffffffff812b65fc>] ? __device_attach+0x31/0x31
[    4.133532]  [<ffffffff812b4d2e>] ? bus_for_each_dev+0x61/0x78
[    4.133542]  [<ffffffff812b5d5f>] ? bus_add_driver+0x100/0x1ba
[    4.133552]  [<ffffffff812b6b4a>] ? driver_register+0x83/0xbb
[    4.133562]  [<ffffffff813100a8>] ? usb_register_driver+0x76/0x11b
[    4.133572]  [<ffffffffa2070000>] ? 0xffffffffa206ffff
[    4.133582]  [<ffffffff8100029e>] ? do_one_initcall+0x88/0x11c
[    4.133597]  [<ffffffff8107c1bf>] ? load_module+0x164d/0x1b86
[    4.133608]  [<ffffffff810c73af>] ? kernel_read+0x3b/0x4e
[    4.133617]  [<ffffffff8107c7e0>] ? SyS_finit_module+0x51/0x5c
[    4.133625]  [<ffffffff8107c7e0>] ? SyS_finit_module+0x51/0x5c
[    4.133636]  [<ffffffff814ad8e2>] ? system_call_fastpath+0x16/0x1b
[    4.133642] ---[ end trace f01d0726672810da ]---
[    4.133648] dib0700: rc submit urb failed
[    4.134055] usbcore: registered new interface driver dvb_usb_dib0700
-- 
    __
   /  `                   	Eric Valette
  /--   __  o _.          	6 rue Paul Le Flem
(___, / (_(_(__         	35740 Pace

Tel: +33 (0)2 99 85 26 76	Fax: +33 (0)2 99 85 26 76
E-mail: eric.valette@free.fr



