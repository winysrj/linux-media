Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39732 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALQXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:47 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so2893067eaj.29
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 4/8] em28xx: move v4l2_device_disconnect() call from the core to the v4l extension
Date: Sun, 12 Jan 2014 17:24:21 +0100
Message-Id: <1389543865-2534-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   10 ----------
 drivers/media/usb/em28xx/em28xx-video.c |    5 +++++
 2 Dateien geändert, 5 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e0040f8..34ff918b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3338,16 +3338,6 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	flush_request_modules(dev);
 
-	mutex_lock(&dev->lock);
-
-	v4l2_device_disconnect(&dev->v4l2_dev);
-
-	if (dev->users)
-		em28xx_warn("device %s is open! Deregistration and memory deallocation are deferred on close.\n",
-			    video_device_node_name(dev->vdev));
-
-	mutex_unlock(&dev->lock);
-
 	em28xx_close_extension(dev);
 
 	/* NOTE: must be called BEFORE the resources are released */
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 634e88a..7535762 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1893,6 +1893,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	v4l2_device_disconnect(&dev->v4l2_dev);
+
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
 	if (dev->radio_dev) {
@@ -1921,6 +1923,9 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		dev->vdev = NULL;
 	}
 
+	if (dev->users)
+		em28xx_warn("Device is open ! Deregistration and memory deallocation are deferred on close.\n");
+
 	return 0;
 }
 
-- 
1.7.10.4

