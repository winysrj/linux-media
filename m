Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:59271 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZGENrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 09:47:16 -0400
Received: by pzk31 with SMTP id 31so1740829pzk.33
        for <linux-media@vger.kernel.org>; Sun, 05 Jul 2009 06:47:20 -0700 (PDT)
Date: Sun, 5 Jul 2009 21:51:21 +0800
From: Zhenyu Wang <zhen78@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: Add support for Gadmei UTV330+
Message-ID: <20090705135121.GC16160@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Add support for Gadmei UTV330+

Signed-off-by: Zhenyu Wang <zhen78@gmail.com>
---

This had been sent to mcentral.de long time ago, but I'm sad to notice
this hasn't been in mainline till now, when I'm trying to view TV in summer
again. I don't know what's the problem with origin em28xx tree, but I do
hope this can be mainline asap. Thanks.

diff -r 05e6c5c9bcb4 -r 647f4c1e5283 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Jun 23 21:11:47 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sun Jul 05 21:28:02 2009 +0800
@@ -1672,6 +1672,8 @@
 			.driver_info = EM2861_BOARD_PLEXTOR_PX_TV100U },
 	{ USB_DEVICE(0x04bb, 0x0515),
 			.driver_info = EM2820_BOARD_IODATA_GVMVP_SZ },
+	{ USB_DEVICE(0xeb1a, 0x50a6),
+			.driver_info = EM2860_BOARD_GADMEI_UTV330 },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);

