Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40321 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaCVNAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 09:00:37 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so2732991eek.4
        for <linux-media@vger.kernel.org>; Sat, 22 Mar 2014 06:00:36 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/5] em28xx: move norm_maxw() and norm_maxh() from em28xx.h to em28xx-video.c
Date: Sat, 22 Mar 2014 14:01:03 +0100
Message-Id: <1395493263-2158-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 23 +++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       | 22 ----------------------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index e15ac75..ac499ae 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -141,6 +141,29 @@ static struct em28xx_fmt format[] = {
 	},
 };
 
+/*FIXME: maxw should be dependent of alt mode */
+static inline unsigned int norm_maxw(struct em28xx *dev)
+{
+	if (dev->board.is_webcam)
+		return dev->sensor_xres;
+
+	if (dev->board.max_range_640_480)
+		return 640;
+
+	return 720;
+}
+
+static inline unsigned int norm_maxh(struct em28xx *dev)
+{
+	if (dev->board.is_webcam)
+		return dev->sensor_yres;
+
+	if (dev->board.max_range_640_480)
+		return 480;
+
+	return (dev->norm & V4L2_STD_625_50) ? 576 : 480;
+}
+
 static int em28xx_vbi_supported(struct em28xx *dev)
 {
 	/* Modprobe option to manually disable */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index dd6190c..4beb1fa 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -793,26 +793,4 @@ int em28xx_init_camera(struct em28xx *dev);
 	printk(KERN_WARNING "%s: "fmt,\
 			dev->name , ##arg); } while (0)
 
-/*FIXME: maxw should be dependent of alt mode */
-static inline unsigned int norm_maxw(struct em28xx *dev)
-{
-	if (dev->board.is_webcam)
-		return dev->sensor_xres;
-
-	if (dev->board.max_range_640_480)
-		return 640;
-
-	return 720;
-}
-
-static inline unsigned int norm_maxh(struct em28xx *dev)
-{
-	if (dev->board.is_webcam)
-		return dev->sensor_yres;
-
-	if (dev->board.max_range_640_480)
-		return 480;
-
-	return (dev->norm & V4L2_STD_625_50) ? 576 : 480;
-}
 #endif
-- 
1.8.4.5

