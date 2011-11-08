Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56861 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727Ab1KHJr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 04:47:29 -0500
Received: by mail-bw0-f43.google.com with SMTP id zt12so277782bkb.30
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 01:47:28 -0800 (PST)
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: linux-media@vger.kernel.org, hvaibhav@ti.com
Cc: archit@ti.com, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] omap_vout: fix section mismatch
Date: Tue,  8 Nov 2011 11:47:08 +0200
Message-Id: <1320745628-20603-1-git-send-email-tomi.valkeinen@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warning by using platform_driver_probe() instead of
platform_driver_register():

WARNING: drivers/media/video/omap/omap-vout.o(.data+0x24): Section
mismatch in reference from the variable omap_vout_driver to the function
.init.text:omap_vout_probe()
The variable omap_vout_driver references
the function __init omap_vout_probe()

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 9c5c19f..a323c09 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2254,13 +2254,12 @@ static struct platform_driver omap_vout_driver = {
 	.driver = {
 		.name = VOUT_NAME,
 	},
-	.probe = omap_vout_probe,
 	.remove = omap_vout_remove,
 };
 
 static int __init omap_vout_init(void)
 {
-	if (platform_driver_register(&omap_vout_driver) != 0) {
+	if (platform_driver_probe(&omap_vout_driver, omap_vout_probe) != 0) {
 		printk(KERN_ERR VOUT_NAME ":Could not register Video driver\n");
 		return -EINVAL;
 	}
-- 
1.7.4.1

