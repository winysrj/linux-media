Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:58819 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaALQXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:51 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so2916136ead.10
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:50 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 7/8] em28xx: always call em28xx_release_resources() in the usb disconnect handler
Date: Sun, 12 Jan 2014 17:24:24 +0100
Message-Id: <1389543865-2534-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the usb device is disconnected, the resources are no longer available,
so there is no reason to keep them registered.

This will also fix the various sysfs group removal warnings which we can see
since kernel 3.13.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   12 +++++-------
 drivers/media/usb/em28xx/em28xx-video.c |    1 -
 2 Dateien geändert, 5 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index cc7677a..4150829 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2827,6 +2827,8 @@ void em28xx_release_resources(struct em28xx *dev)
 {
 	/*FIXME: I2C IR should be disconnected */
 
+	mutex_lock(&dev->lock);
+
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
@@ -2835,6 +2837,8 @@ void em28xx_release_resources(struct em28xx *dev)
 
 	/* Mark device as unused */
 	clear_bit(dev->devno, &em28xx_devused);
+
+	mutex_unlock(&dev->lock);
 };
 EXPORT_SYMBOL_GPL(em28xx_release_resources);
 
@@ -3337,13 +3341,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	em28xx_close_extension(dev);
 
-	/* NOTE: must be called BEFORE the resources are released */
-
-	mutex_lock(&dev->lock);
-	if (!dev->users)
-		em28xx_release_resources(dev);
-
-	mutex_unlock(&dev->lock);
+	em28xx_release_resources(dev);
 
 	if (!dev->users) {
 		kfree(dev->alt_max_pkt_size_isoc);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f209f95..87b140f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1959,7 +1959,6 @@ static int em28xx_v4l2_close(struct file *filp)
 		   free the remaining resources */
 
 		if (dev->disconnected) {
-			em28xx_release_resources(dev);
 			kfree(dev->alt_max_pkt_size_isoc);
 			goto exit;
 		}
-- 
1.7.10.4

