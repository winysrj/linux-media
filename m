Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:33 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:32 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 10/21] em28xx: create a common function for isoc and bulk USB transfer initialization
Date: Thu,  8 Nov 2012 20:11:42 +0200
Message-Id: <1352398313-3698-11-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- rename em28xx_init_isoc to em28xx_init_usb_xfer
- add parameter for isoc/bulk transfer selection which is passed to em28xx_alloc_urbs
- rename local variable isoc_buf to usb_bufs

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c  |   30 ++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |    9 +++++----
 drivers/media/usb/em28xx/em28xx-video.c |   20 ++++++++++----------
 drivers/media/usb/em28xx/em28xx.h       |    8 +++++---
 4 Dateien geändert, 36 Zeilen hinzugefügt(+), 31 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 42388de..d8a8e8b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1141,33 +1141,35 @@ EXPORT_SYMBOL_GPL(em28xx_alloc_urbs);
 /*
  * Allocate URBs and start IRQ
  */
-int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		     int num_packets, int num_bufs, int max_pkt_size,
-		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb))
+int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
+		    int xfer_bulk, int num_bufs, int max_pkt_size,
+		    int packet_multiplier,
+		    int (*urb_data_copy) (struct em28xx *dev, struct urb *urb))
 {
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue *vbi_dma_q = &dev->vbiq;
-	struct em28xx_usb_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *usb_bufs;
 	int i;
 	int rc;
 	int alloc;
 
-	em28xx_isocdbg("em28xx: called em28xx_init_isoc in mode %d\n", mode);
+	em28xx_isocdbg("em28xx: called em28xx_init_usb_xfer in mode %d\n",
+		       mode);
 
-	dev->usb_ctl.urb_data_copy = isoc_copy;
+	dev->usb_ctl.urb_data_copy = urb_data_copy;
 
 	if (mode == EM28XX_DIGITAL_MODE) {
-		isoc_bufs = &dev->usb_ctl.digital_bufs;
-		/* no need to free/alloc isoc buffers in digital mode */
+		usb_bufs = &dev->usb_ctl.digital_bufs;
+		/* no need to free/alloc usb buffers in digital mode */
 		alloc = 0;
 	} else {
-		isoc_bufs = &dev->usb_ctl.analog_bufs;
+		usb_bufs = &dev->usb_ctl.analog_bufs;
 		alloc = 1;
 	}
 
 	if (alloc) {
-		rc = em28xx_alloc_urbs(dev, mode, 0, num_bufs,
-				       max_pkt_size, num_packets);
+		rc = em28xx_alloc_urbs(dev, mode, xfer_bulk, num_bufs,
+				       max_pkt_size, packet_multiplier);
 		if (rc)
 			return rc;
 	}
@@ -1178,8 +1180,8 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	em28xx_capture_start(dev, 1);
 
 	/* submit urbs and enables IRQ */
-	for (i = 0; i < isoc_bufs->num_bufs; i++) {
-		rc = usb_submit_urb(isoc_bufs->urb[i], GFP_ATOMIC);
+	for (i = 0; i < usb_bufs->num_bufs; i++) {
+		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
 		if (rc) {
 			em28xx_err("submit of urb %i failed (error=%i)\n", i,
 				   rc);
@@ -1190,7 +1192,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(em28xx_init_isoc);
+EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
 
 /*
  * em28xx_wake_i2c()
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 833f10b..eeabc25 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -176,10 +176,11 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		EM28XX_DVB_NUM_ISOC_PACKETS,
 		max_dvb_packet_size);
 
-	return em28xx_init_isoc(dev, EM28XX_DIGITAL_MODE,
-				EM28XX_DVB_NUM_ISOC_PACKETS,
-				EM28XX_DVB_NUM_BUFS,
-				max_dvb_packet_size, em28xx_dvb_isoc_copy);
+	return em28xx_init_usb_xfer(dev, EM28XX_DIGITAL_MODE, 0,
+				    EM28XX_DVB_NUM_BUFS,
+				    max_dvb_packet_size,
+				    EM28XX_DVB_NUM_ISOC_PACKETS,
+				    em28xx_dvb_isoc_copy);
 }
 
 static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1207a73..4024dfc 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -763,17 +763,17 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 
 	if (urb_init) {
 		if (em28xx_vbi_supported(dev) == 1)
-			rc = em28xx_init_isoc(dev, EM28XX_ANALOG_MODE,
-					      EM28XX_NUM_ISOC_PACKETS,
-					      EM28XX_NUM_BUFS,
-					      dev->max_pkt_size,
-					      em28xx_isoc_copy_vbi);
+			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE, 0,
+						  EM28XX_NUM_BUFS,
+						  dev->max_pkt_size,
+						  EM28XX_NUM_ISOC_PACKETS,
+						  em28xx_isoc_copy_vbi);
 		else
-			rc = em28xx_init_isoc(dev, EM28XX_ANALOG_MODE,
-					      EM28XX_NUM_ISOC_PACKETS,
-					      EM28XX_NUM_BUFS,
-					      dev->max_pkt_size,
-					      em28xx_isoc_copy);
+			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE, 0,
+						  EM28XX_NUM_BUFS,
+						  dev->max_pkt_size,
+						  EM28XX_NUM_ISOC_PACKETS,
+						  em28xx_isoc_copy);
 		if (rc < 0)
 			goto fail;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7bc2ddd..950a717 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -664,9 +664,11 @@ int em28xx_resolution_set(struct em28xx *dev);
 int em28xx_set_alternate(struct em28xx *dev);
 int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		      int num_bufs, int max_pkt_size, int packet_multiplier);
-int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		     int num_packets, int num_bufs, int max_pkt_size,
-		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
+int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
+			 int xfer_bulk,
+			 int num_bufs, int max_pkt_size, int packet_multiplier,
+			 int (*urb_data_copy)
+					(struct em28xx *dev, struct urb *urb));
 void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
 int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
-- 
1.7.10.4

