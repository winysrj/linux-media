Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2KHTMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:49 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 17/21] em28xx: rename some USB parameter fields in struct em28xx to clarify their role
Date: Thu,  8 Nov 2012 20:11:49 +0200
Message-Id: <1352398313-3698-18-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also improve the comments.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   20 +++++++++++---------
 drivers/media/usb/em28xx/em28xx-core.c  |    8 ++++----
 drivers/media/usb/em28xx/em28xx-dvb.c   |    4 ++--
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 drivers/media/usb/em28xx/em28xx.h       |   14 ++++++++------
 5 Dateien geändert, 26 Zeilen hinzugefügt(+), 22 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index bfce34d..873b52f 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3183,9 +3183,10 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* compute alternate max packet sizes */
-	dev->alt_max_pkt_size = kmalloc(sizeof(dev->alt_max_pkt_size[0]) *
+	dev->alt_max_pkt_size_isoc =
+				kmalloc(sizeof(dev->alt_max_pkt_size_isoc[0]) *
 					interface->num_altsetting, GFP_KERNEL);
-	if (dev->alt_max_pkt_size == NULL) {
+	if (dev->alt_max_pkt_size_isoc == NULL) {
 		em28xx_errdev("out of memory!\n");
 		kfree(dev);
 		retval = -ENOMEM;
@@ -3216,13 +3217,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 					break;
 				case EM28XX_EP_ANALOG:
 					has_video = true;
-					dev->alt_max_pkt_size[i] = size;
+					dev->alt_max_pkt_size_isoc[i] = size;
 					break;
 				case EM28XX_EP_DIGITAL:
 					has_dvb = true;
-					if (size > dev->dvb_max_pkt_size) {
-						dev->dvb_max_pkt_size = size;
-						dev->dvb_alt = i;
+					if (size > dev->dvb_max_pkt_size_isoc) {
+						dev->dvb_max_pkt_size_isoc =
+									  size;
+						dev->dvb_alt_isoc = i;
 					}
 					break;
 				}
@@ -3324,7 +3326,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		/* pre-allocate DVB isoc transfer buffers */
 		retval = em28xx_alloc_urbs(dev, EM28XX_DIGITAL_MODE, 0,
 					   EM28XX_DVB_NUM_BUFS,
-					   dev->dvb_max_pkt_size,
+					   dev->dvb_max_pkt_size_isoc,
 					   EM28XX_DVB_NUM_ISOC_PACKETS);
 		if (retval) {
 			goto unlock_and_free;
@@ -3344,7 +3346,7 @@ unlock_and_free:
 	mutex_unlock(&dev->lock);
 
 err_free:
-	kfree(dev->alt_max_pkt_size);
+	kfree(dev->alt_max_pkt_size_isoc);
 	kfree(dev);
 
 err:
@@ -3409,7 +3411,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	em28xx_close_extension(dev);
 
 	if (!dev->users) {
-		kfree(dev->alt_max_pkt_size);
+		kfree(dev->alt_max_pkt_size_isoc);
 		kfree(dev);
 	}
 }
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 8b8f783..6b588e2 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -830,14 +830,14 @@ int em28xx_set_alternate(struct em28xx *dev)
 
 	for (i = 0; i < dev->num_alt; i++) {
 		/* stop when the selected alt setting offers enough bandwidth */
-		if (dev->alt_max_pkt_size[i] >= min_pkt_size) {
+		if (dev->alt_max_pkt_size_isoc[i] >= min_pkt_size) {
 			dev->alt = i;
 			break;
 		/* otherwise make sure that we end up with the maximum bandwidth
 		   because the min_pkt_size equation might be wrong...
 		*/
-		} else if (dev->alt_max_pkt_size[i] >
-			   dev->alt_max_pkt_size[dev->alt])
+		} else if (dev->alt_max_pkt_size_isoc[i] >
+			   dev->alt_max_pkt_size_isoc[dev->alt])
 			dev->alt = i;
 	}
 
@@ -845,7 +845,7 @@ set_alt:
 	if (dev->alt != prev_alt) {
 		em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
 				min_pkt_size, dev->alt);
-		dev->max_pkt_size = dev->alt_max_pkt_size[dev->alt];
+		dev->max_pkt_size = dev->alt_max_pkt_size_isoc[dev->alt];
 		em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
 			       dev->alt, dev->max_pkt_size);
 		errCode = usb_set_interface(dev->udev, 0, dev->alt);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index b46246a..3fc7e27 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -178,12 +178,12 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	struct em28xx *dev = dvb->adapter.priv;
 	int max_dvb_packet_size;
 
-	usb_set_interface(dev->udev, 0, dev->dvb_alt);
+	usb_set_interface(dev->udev, 0, dev->dvb_alt_isoc);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
 
-	max_dvb_packet_size = dev->dvb_max_pkt_size;
+	max_dvb_packet_size = dev->dvb_max_pkt_size_isoc;
 	if (max_dvb_packet_size < 0)
 		return max_dvb_packet_size;
 	dprintk(1, "Using %d buffers each with %d x %d bytes\n",
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f435206..8767c06 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2286,7 +2286,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
-			kfree(dev->alt_max_pkt_size);
+			kfree(dev->alt_max_pkt_size_isoc);
 			mutex_unlock(&dev->lock);
 			kfree(dev);
 			kfree(fh);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 950a717..6b8d3e6b 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -4,6 +4,7 @@
    Copyright (C) 2005 Markus Rechberger <mrechberger@gmail.com>
 		      Ludovico Cavedon <cavedon@sssup.it>
 		      Mauro Carvalho Chehab <mchehab@infradead.org>
+   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 
    Based on the em2800 driver from Sascha Sommer <saschasommer@freenet.de>
 
@@ -583,12 +584,13 @@ struct em28xx {
 
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
-	int alt;		/* alternate */
-	int max_pkt_size;	/* max packet size of isoc transaction */
-	int num_alt;		/* Number of alternative settings */
-	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
-	int dvb_alt;				/* alternate for DVB */
-	unsigned int dvb_max_pkt_size;		/* wMaxPacketSize for DVB */
+	int alt;		/* alternate setting */
+	int max_pkt_size;	/* max packet size of the selected ep at alt */
+	int num_alt;		/* number of alternative settings */
+	unsigned int *alt_max_pkt_size_isoc; /* array of isoc wMaxPacketSize */
+	int dvb_alt_isoc;	/* alternate setting for DVB isoc transfers */
+	unsigned int dvb_max_pkt_size_isoc;	/* isoc max packet size of the
+						   selected DVB ep at dvb_alt */
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */
-- 
1.7.10.4

