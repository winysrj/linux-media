Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55662 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3GQKJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 06:09:27 -0400
Received: by mail-pb0-f50.google.com with SMTP id wz7so1735074pbc.37
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 03:09:27 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	pawel.moll@arm.com, t.katayama@jp.fujitsu.com,
	vikas.sajjan@linaro.org, linaro-kernel@lists.linaro.org,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH 1/2] Fixed for compatible with kernel 3.10.0-rc6
Date: Wed, 17 Jul 2013 18:08:56 +0800
Message-Id: <1374055737-6643-2-git-send-email-show.liu@linaro.org>
In-Reply-To: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
References: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/video/Kconfig |    2 ++
 drivers/video/fbmon.c |   12 +++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2e14e0b..b0a0947 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -324,6 +324,7 @@ config FB_ARMCLCD
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB_MODE_HELPERS if OF
+	select VIDEOMODE_HELPERS
 	help
 	  This framebuffer device driver is for the ARM PrimeCell PL110
 	  Colour LCD controller.  ARM PrimeCells provide the building
@@ -340,6 +341,7 @@ config FB_ARMHDLCD
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VIDEOMODE_HELPERS
 	help
 	  This framebuffer device driver is for the ARM High Definition
 	  Colour LCD controller.
diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 304cf37..aaa5be7 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1440,17 +1440,15 @@ void videomode_from_fb_var_screeninfo(const struct fb_var_screeninfo *var,
 	vm->vback_porch = var->upper_margin;
 	vm->vsync_len = var->vsync_len;
 
-	vm->dmt_flags = 0;
+	vm->flags = 0;
 	if (var->sync & FB_SYNC_HOR_HIGH_ACT)
-		vm->dmt_flags |= VESA_DMT_HSYNC_HIGH;
+		vm->flags |= DISPLAY_FLAGS_HSYNC_HIGH;
 	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
-		vm->dmt_flags |= VESA_DMT_VSYNC_HIGH;
-
-	vm->data_flags = 0;
+		vm->flags |= DISPLAY_FLAGS_VSYNC_HIGH;
 	if (var->vmode & FB_VMODE_INTERLACED)
-		vm->data_flags |= DISPLAY_FLAGS_INTERLACED;
+		vm->flags |= DISPLAY_FLAGS_INTERLACED;
 	if (var->vmode & FB_VMODE_DOUBLE)
-		vm->data_flags |= DISPLAY_FLAGS_DOUBLESCAN;
+		vm->flags |= DISPLAY_FLAGS_DOUBLESCAN;
 }
 EXPORT_SYMBOL_GPL(videomode_from_fb_var_screeninfo);
 
-- 
1.7.9.5

