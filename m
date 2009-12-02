Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbZLBD4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 22:56:50 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB23uvML002008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 22:56:57 -0500
Date: Tue, 1 Dec 2009 22:58:36 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: awilliam@redhat.com
Subject: [PATCH] bttv: add i2c addr for old WinTV card to IR probe list
Message-ID: <20091202035836.GA2033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are old bttv-driven Hauppauge WinTV series cards that have
their IR part at i2c addr 0x71, which doesn't get considered in the
new 2.6.31 i2c code.

>From a 2.6.29 kernel:

lirc_i2c: chip 0x10005 found @ 0x71 (Hauppauge PVR150)

Minor cosmetic glitch, the card in question isn't actually a PVR-150, its:

03:06.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Flags: bus master, medium devsel, latency 32, IRQ 19
	Memory at f4ffe000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

Device ID: 0x109e:0x036e, Sub-Device ID: 0x0070:0x13eb

This simply adds 0x71 to the list of addresses i2c_new_probed_device should
consider, which gets IR working on this card again.

Reported-by: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Adam Williamson <awilliam@redhat.com>

---
diff -r e0cd9a337600 linux/drivers/media/video/bt8xx/bttv-i2c.c
--- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sun Nov 29 12:08:02 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Tue Dec 01 11:23:17 2009 -0500
@@ -423,7 +423,7 @@
 		   That's why we probe 0x1a (~0x34) first. CB
 		*/
 		const unsigned short addr_list[] = {
-			0x1a, 0x18, 0x4b, 0x64, 0x30,
+			0x1a, 0x18, 0x4b, 0x64, 0x30, 0x71,
 			I2C_CLIENT_END
 		};
 
