Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44249 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaALQXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:50 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so2881909eae.33
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:49 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 6/8] em28xx: move v4l2 dummy clock deregistration from the core to the v4l extension
Date: Sun, 12 Jan 2014 17:24:23 +0100
Message-Id: <1389543865-2534-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    3 ---
 drivers/media/usb/em28xx/em28xx-video.c |    6 ++++++
 2 Dateien geändert, 6 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 34ff918b..cc7677a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -36,7 +36,6 @@
 #include <media/tvaudio.h>
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
-#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
 #include "em28xx.h"
@@ -2831,8 +2830,6 @@ void em28xx_release_resources(struct em28xx *dev)
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
-	if (dev->clk)
-		v4l2_clk_unregister_fixed(dev->clk);
 
 	usb_put_dev(dev->udev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3ac8700..f209f95 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -42,6 +42,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-clk.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
 
@@ -1926,6 +1927,11 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
+	if (dev->clk) {
+		v4l2_clk_unregister_fixed(dev->clk);
+		dev->clk = NULL;
+	}
+
 	if (dev->users)
 		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
 
-- 
1.7.10.4

