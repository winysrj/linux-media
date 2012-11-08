Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:29 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:28 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 08/21] em28xx: rename function em28xx_uninit_isoc to em28xx_uninit_usb_xfer
Date: Thu,  8 Nov 2012 20:11:40 +0200
Message-Id: <1352398313-3698-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function will be used to uninitialize USB bulk transfers, too.
Also rename the local variable isoc_bufs to usb_bufs.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    4 +--
 drivers/media/usb/em28xx/em28xx-core.c  |   43 ++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 drivers/media/usb/em28xx/em28xx.h       |    2 +-
 4 Dateien geändert, 26 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 7cd2faf..e474ccf 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3394,7 +3394,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 		     video_device_node_name(dev->vdev));
 
 		dev->state |= DEV_MISCONFIGURED;
-		em28xx_uninit_isoc(dev, dev->mode);
+		em28xx_uninit_usb_xfer(dev, dev->mode);
 		dev->state |= DEV_DISCONNECTED;
 	} else {
 		dev->state |= DEV_DISCONNECTED;
@@ -3402,7 +3402,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	}
 
 	/* free DVB isoc buffers */
-	em28xx_uninit_isoc(dev, EM28XX_DIGITAL_MODE);
+	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
 	mutex_unlock(&dev->lock);
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 8f50f5c..a1ebd08 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -962,49 +962,50 @@ static void em28xx_irq_callback(struct urb *urb)
 /*
  * Stop and Deallocate URBs
  */
-void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode)
+void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 {
 	struct urb *urb;
-	struct em28xx_usb_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *usb_bufs;
 	int i;
 
-	em28xx_isocdbg("em28xx: called em28xx_uninit_isoc in mode %d\n", mode);
+	em28xx_isocdbg("em28xx: called em28xx_uninit_usb_xfer in mode %d\n",
+		       mode);
 
 	if (mode == EM28XX_DIGITAL_MODE)
-		isoc_bufs = &dev->usb_ctl.digital_bufs;
+		usb_bufs = &dev->usb_ctl.digital_bufs;
 	else
-		isoc_bufs = &dev->usb_ctl.analog_bufs;
+		usb_bufs = &dev->usb_ctl.analog_bufs;
 
-	for (i = 0; i < isoc_bufs->num_bufs; i++) {
-		urb = isoc_bufs->urb[i];
+	for (i = 0; i < usb_bufs->num_bufs; i++) {
+		urb = usb_bufs->urb[i];
 		if (urb) {
 			if (!irqs_disabled())
 				usb_kill_urb(urb);
 			else
 				usb_unlink_urb(urb);
 
-			if (isoc_bufs->transfer_buffer[i]) {
+			if (usb_bufs->transfer_buffer[i]) {
 				usb_free_coherent(dev->udev,
 					urb->transfer_buffer_length,
-					isoc_bufs->transfer_buffer[i],
+					usb_bufs->transfer_buffer[i],
 					urb->transfer_dma);
 			}
 			usb_free_urb(urb);
-			isoc_bufs->urb[i] = NULL;
+			usb_bufs->urb[i] = NULL;
 		}
-		isoc_bufs->transfer_buffer[i] = NULL;
+		usb_bufs->transfer_buffer[i] = NULL;
 	}
 
-	kfree(isoc_bufs->urb);
-	kfree(isoc_bufs->transfer_buffer);
+	kfree(usb_bufs->urb);
+	kfree(usb_bufs->transfer_buffer);
 
-	isoc_bufs->urb = NULL;
-	isoc_bufs->transfer_buffer = NULL;
-	isoc_bufs->num_bufs = 0;
+	usb_bufs->urb = NULL;
+	usb_bufs->transfer_buffer = NULL;
+	usb_bufs->num_bufs = 0;
 
 	em28xx_capture_start(dev, 0);
 }
-EXPORT_SYMBOL_GPL(em28xx_uninit_isoc);
+EXPORT_SYMBOL_GPL(em28xx_uninit_usb_xfer);
 
 /*
  * Stop URBs
@@ -1051,7 +1052,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		isoc_bufs = &dev->usb_ctl.analog_bufs;
 
 	/* De-allocates all pending stuff */
-	em28xx_uninit_isoc(dev, mode);
+	em28xx_uninit_usb_xfer(dev, mode);
 
 	isoc_bufs->num_bufs = num_bufs;
 
@@ -1081,7 +1082,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		urb = usb_alloc_urb(isoc_bufs->num_packets, GFP_KERNEL);
 		if (!urb) {
 			em28xx_err("cannot alloc usb_ctl.urb %i\n", i);
-			em28xx_uninit_isoc(dev, mode);
+			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
 		isoc_bufs->urb[i] = urb;
@@ -1093,7 +1094,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 					" buffer %i%s\n",
 					sb_size, i,
 					in_interrupt() ? " while in int" : "");
-			em28xx_uninit_isoc(dev, mode);
+			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
 		memset(isoc_bufs->transfer_buffer[i], 0, sb_size);
@@ -1171,7 +1172,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		if (rc) {
 			em28xx_err("submit of urb %i failed (error=%i)\n", i,
 				   rc);
-			em28xx_uninit_isoc(dev, mode);
+			em28xx_uninit_usb_xfer(dev, mode);
 			return rc;
 		}
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b334885..1207a73 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2272,7 +2272,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 		/* do this before setting alternate! */
-		em28xx_uninit_isoc(dev, EM28XX_ANALOG_MODE);
+		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 		em28xx_set_mode(dev, EM28XX_SUSPEND);
 
 		/* set alternate 0 */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 6773ca8..8fb3504 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -667,7 +667,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		     int num_packets, int num_bufs, int max_pkt_size,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
-void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode);
+void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
 int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
-- 
1.7.10.4

