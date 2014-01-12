Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44642 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaALQXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:46 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so1034523eek.0
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:45 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 3/8] em28xx: move usb transfer uninit on device disconnect from the core to the v4l-extension
Date: Sun, 12 Jan 2014 17:24:20 +0100
Message-Id: <1389543865-2534-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    4 +---
 drivers/media/usb/em28xx/em28xx-video.c |    2 ++
 2 Dateien geändert, 3 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4d89df9..e0040f8 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3342,12 +3342,10 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	v4l2_device_disconnect(&dev->v4l2_dev);
 
-	if (dev->users) {
+	if (dev->users)
 		em28xx_warn("device %s is open! Deregistration and memory deallocation are deferred on close.\n",
 			    video_device_node_name(dev->vdev));
 
-		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
-	}
 	mutex_unlock(&dev->lock);
 
 	em28xx_close_extension(dev);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 83c99e6..634e88a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1893,6 +1893,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
+
 	if (dev->radio_dev) {
 		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
-- 
1.7.10.4

