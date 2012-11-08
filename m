Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:16 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:15 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 03/21] em28xx: rename isoc packet number constants and parameters
Date: Thu,  8 Nov 2012 20:11:35 +0200
Message-Id: <1352398313-3698-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename EM28XX_NUM_PACKETS to EM28XX_NUM_ISOC_PACKETS and
EM28XX_DVB_MAX_PACKETS to EM28XX_DVB_NUM_ISOC_PACKETS to
clarify that these values are used only for isoc usb transfers.
Also use the term num_packets instead of max_packets, as this
is how these values are used and called in struct urb.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 drivers/media/usb/em28xx/em28xx-core.c  |    8 ++++----
 drivers/media/usb/em28xx/em28xx-dvb.c   |    5 +++--
 drivers/media/usb/em28xx/em28xx-video.c |    4 ++--
 drivers/media/usb/em28xx/em28xx.h       |   10 +++++-----
 5 Dateien geändert, 15 Zeilen hinzugefügt(+), 14 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 619bffb..7cd2faf 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3323,7 +3323,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_dvb) {
 		/* pre-allocate DVB isoc transfer buffers */
 		retval = em28xx_alloc_isoc(dev, EM28XX_DIGITAL_MODE,
-					   EM28XX_DVB_MAX_PACKETS,
+					   EM28XX_DVB_NUM_ISOC_PACKETS,
 					   EM28XX_DVB_NUM_BUFS,
 					   dev->dvb_max_pkt_size);
 		if (retval) {
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index bed07a6..2520a16 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1034,7 +1034,7 @@ EXPORT_SYMBOL_GPL(em28xx_stop_urbs);
  * Allocate URBs
  */
 int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		      int max_packets, int num_bufs, int max_pkt_size)
+		      int num_packets, int num_bufs, int max_pkt_size)
 {
 	struct em28xx_usb_isoc_bufs *isoc_bufs;
 	int i;
@@ -1069,7 +1069,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	}
 
 	isoc_bufs->max_pkt_size = max_pkt_size;
-	isoc_bufs->num_packets = max_packets;
+	isoc_bufs->num_packets = num_packets;
 	dev->isoc_ctl.vid_buf = NULL;
 	dev->isoc_ctl.vbi_buf = NULL;
 
@@ -1129,7 +1129,7 @@ EXPORT_SYMBOL_GPL(em28xx_alloc_isoc);
  * Allocate URBs and start IRQ
  */
 int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		     int max_packets, int num_bufs, int max_pkt_size,
+		     int num_packets, int num_bufs, int max_pkt_size,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb))
 {
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
@@ -1153,7 +1153,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	}
 
 	if (alloc) {
-		rc = em28xx_alloc_isoc(dev, mode, max_packets,
+		rc = em28xx_alloc_isoc(dev, mode, num_packets,
 				       num_bufs, max_pkt_size);
 		if (rc)
 			return rc;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 63f2e70..833f10b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -173,11 +173,12 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		return max_dvb_packet_size;
 	dprintk(1, "Using %d buffers each with %d x %d bytes\n",
 		EM28XX_DVB_NUM_BUFS,
-		EM28XX_DVB_MAX_PACKETS,
+		EM28XX_DVB_NUM_ISOC_PACKETS,
 		max_dvb_packet_size);
 
 	return em28xx_init_isoc(dev, EM28XX_DIGITAL_MODE,
-				EM28XX_DVB_MAX_PACKETS, EM28XX_DVB_NUM_BUFS,
+				EM28XX_DVB_NUM_ISOC_PACKETS,
+				EM28XX_DVB_NUM_BUFS,
 				max_dvb_packet_size, em28xx_dvb_isoc_copy);
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7c88a40..e51284c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -764,13 +764,13 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	if (urb_init) {
 		if (em28xx_vbi_supported(dev) == 1)
 			rc = em28xx_init_isoc(dev, EM28XX_ANALOG_MODE,
-					      EM28XX_NUM_PACKETS,
+					      EM28XX_NUM_ISOC_PACKETS,
 					      EM28XX_NUM_BUFS,
 					      dev->max_pkt_size,
 					      em28xx_isoc_copy_vbi);
 		else
 			rc = em28xx_init_isoc(dev, EM28XX_ANALOG_MODE,
-					      EM28XX_NUM_PACKETS,
+					      EM28XX_NUM_ISOC_PACKETS,
 					      EM28XX_NUM_BUFS,
 					      dev->max_pkt_size,
 					      em28xx_isoc_copy);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index ad9eec0..36a7864 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -157,12 +157,12 @@
 #define EM28XX_NUM_BUFS 5
 #define EM28XX_DVB_NUM_BUFS 5
 
-/* number of packets for each buffer
+/* isoc transfers: number of packets for each buffer
    windows requests only 64 packets .. so we better do the same
    this is what I found out for all alternate numbers there!
  */
-#define EM28XX_NUM_PACKETS 64
-#define EM28XX_DVB_MAX_PACKETS 64
+#define EM28XX_NUM_ISOC_PACKETS 64
+#define EM28XX_DVB_NUM_ISOC_PACKETS 64
 
 #define EM28XX_INTERLACED_DEFAULT 1
 
@@ -667,9 +667,9 @@ int em28xx_set_outfmt(struct em28xx *dev);
 int em28xx_resolution_set(struct em28xx *dev);
 int em28xx_set_alternate(struct em28xx *dev);
 int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		      int max_packets, int num_bufs, int max_pkt_size);
+		      int num_packets, int num_bufs, int max_pkt_size);
 int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
-		     int max_packets, int num_bufs, int max_pkt_size,
+		     int num_packets, int num_bufs, int max_pkt_size,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
 void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode);
 void em28xx_stop_urbs(struct em28xx *dev);
-- 
1.7.10.4

