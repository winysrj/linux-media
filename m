Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57061 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaALQXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:45 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so277703eek.8
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:44 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 2/8] em28xx: move usb buffer pre-allocation and transfer uninit from the core to the dvb extension
Date: Sun, 12 Jan 2014 17:24:19 +0100
Message-Id: <1389543865-2534-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   21 ---------------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   23 +++++++++++++++++++++++
 2 Dateien geändert, 23 Zeilen hinzugefügt(+), 21 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b2cfd5d..4d89df9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3290,26 +3290,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 		em28xx_info("dvb set to %s mode.\n",
 			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
-
-		/* pre-allocate DVB usb transfer buffers */
-		if (dev->dvb_xfer_bulk) {
-			retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
-					    dev->dvb_xfer_bulk,
-					    EM28XX_DVB_NUM_BUFS,
-					    512,
-					    EM28XX_DVB_BULK_PACKET_MULTIPLIER);
-		} else {
-			retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
-					    dev->dvb_xfer_bulk,
-					    EM28XX_DVB_NUM_BUFS,
-					    dev->dvb_max_pkt_size_isoc,
-					    EM28XX_DVB_NUM_ISOC_PACKETS);
-		}
-		if (retval) {
-			printk(DRIVER_NAME
-			       ": Failed to pre-allocate USB transfer buffers for DVB.\n");
-			goto err_free;
-		}
 	}
 
 	request_modules(dev);
@@ -3367,7 +3347,6 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 			    video_device_node_name(dev->vdev));
 
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
-		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	}
 	mutex_unlock(&dev->lock);
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9d0fcc8..60510f0 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1013,6 +1013,27 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	dev->dvb = dvb;
 	dvb->fe[0] = dvb->fe[1] = NULL;
 
+	/* pre-allocate DVB usb transfer buffers */
+	if (dev->dvb_xfer_bulk) {
+		result = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
+					   dev->dvb_xfer_bulk,
+					   EM28XX_DVB_NUM_BUFS,
+					   512,
+					   EM28XX_DVB_BULK_PACKET_MULTIPLIER);
+	} else {
+		result = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE,
+					   dev->dvb_xfer_bulk,
+					   EM28XX_DVB_NUM_BUFS,
+					   dev->dvb_max_pkt_size_isoc,
+					   EM28XX_DVB_NUM_ISOC_PACKETS);
+	}
+	if (result) {
+		em28xx_errdev("em28xx_dvb: failed to pre-allocate USB transfer buffers for DVB.\n");
+		kfree(dvb);
+		dev->dvb = NULL;
+		return result;
+	}
+
 	mutex_lock(&dev->lock);
 	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	/* init frontend */
@@ -1449,6 +1470,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
+		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
+
 		if (dev->disconnected) {
 			/* We cannot tell the device to sleep
 			 * once it has been unplugged. */
-- 
1.7.10.4

