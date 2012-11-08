Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:22 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:21 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 05/21] em28xx: rename struct em28xx_usb_isoc_ctl to em28xx_usb_ctl
Date: Thu,  8 Nov 2012 20:11:37 +0200
Message-Id: <1352398313-3698-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also rename the corresponding field isoc_ctl in struct em28xx
to usb_ctl.
We will use this struct for USB bulk transfers, too.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c  |   24 ++++++++++++------------
 drivers/media/usb/em28xx/em28xx-vbi.c   |    4 ++--
 drivers/media/usb/em28xx/em28xx-video.c |   24 ++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h       |   12 ++++++------
 4 Dateien geändert, 32 Zeilen hinzugefügt(+), 32 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index b250a63..0892d92 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -941,7 +941,7 @@ static void em28xx_irq_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock(&dev->slock);
-	dev->isoc_ctl.isoc_copy(dev, urb);
+	dev->usb_ctl.urb_data_copy(dev, urb);
 	spin_unlock(&dev->slock);
 
 	/* Reset urb buffers */
@@ -970,9 +970,9 @@ void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode)
 	em28xx_isocdbg("em28xx: called em28xx_uninit_isoc in mode %d\n", mode);
 
 	if (mode == EM28XX_DIGITAL_MODE)
-		isoc_bufs = &dev->isoc_ctl.digital_bufs;
+		isoc_bufs = &dev->usb_ctl.digital_bufs;
 	else
-		isoc_bufs = &dev->isoc_ctl.analog_bufs;
+		isoc_bufs = &dev->usb_ctl.analog_bufs;
 
 	for (i = 0; i < isoc_bufs->num_bufs; i++) {
 		urb = isoc_bufs->urb[i];
@@ -1012,7 +1012,7 @@ void em28xx_stop_urbs(struct em28xx *dev)
 {
 	int i;
 	struct urb *urb;
-	struct em28xx_usb_bufs *isoc_bufs = &dev->isoc_ctl.digital_bufs;
+	struct em28xx_usb_bufs *isoc_bufs = &dev->usb_ctl.digital_bufs;
 
 	em28xx_isocdbg("em28xx: called em28xx_stop_urbs\n");
 
@@ -1045,9 +1045,9 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	em28xx_isocdbg("em28xx: called em28xx_alloc_isoc in mode %d\n", mode);
 
 	if (mode == EM28XX_DIGITAL_MODE)
-		isoc_bufs = &dev->isoc_ctl.digital_bufs;
+		isoc_bufs = &dev->usb_ctl.digital_bufs;
 	else
-		isoc_bufs = &dev->isoc_ctl.analog_bufs;
+		isoc_bufs = &dev->usb_ctl.analog_bufs;
 
 	/* De-allocates all pending stuff */
 	em28xx_uninit_isoc(dev, mode);
@@ -1070,8 +1070,8 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 
 	isoc_bufs->max_pkt_size = max_pkt_size;
 	isoc_bufs->num_packets = num_packets;
-	dev->isoc_ctl.vid_buf = NULL;
-	dev->isoc_ctl.vbi_buf = NULL;
+	dev->usb_ctl.vid_buf = NULL;
+	dev->usb_ctl.vbi_buf = NULL;
 
 	sb_size = isoc_bufs->num_packets * isoc_bufs->max_pkt_size;
 
@@ -1079,7 +1079,7 @@ int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 	for (i = 0; i < isoc_bufs->num_bufs; i++) {
 		urb = usb_alloc_urb(isoc_bufs->num_packets, GFP_KERNEL);
 		if (!urb) {
-			em28xx_err("cannot alloc isoc_ctl.urb %i\n", i);
+			em28xx_err("cannot alloc usb_ctl.urb %i\n", i);
 			em28xx_uninit_isoc(dev, mode);
 			return -ENOMEM;
 		}
@@ -1141,14 +1141,14 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 
 	em28xx_isocdbg("em28xx: called em28xx_init_isoc in mode %d\n", mode);
 
-	dev->isoc_ctl.isoc_copy = isoc_copy;
+	dev->usb_ctl.urb_data_copy = isoc_copy;
 
 	if (mode == EM28XX_DIGITAL_MODE) {
-		isoc_bufs = &dev->isoc_ctl.digital_bufs;
+		isoc_bufs = &dev->usb_ctl.digital_bufs;
 		/* no need to free/alloc isoc buffers in digital mode */
 		alloc = 0;
 	} else {
-		isoc_bufs = &dev->isoc_ctl.analog_bufs;
+		isoc_bufs = &dev->usb_ctl.analog_bufs;
 		alloc = 1;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 2b4c9cb..d74713b 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -60,8 +60,8 @@ free_buffer(struct videobuf_queue *vq, struct em28xx_buffer *buf)
 	   VIDEOBUF_ACTIVE, it won't be, though.
 	*/
 	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->isoc_ctl.vbi_buf == buf)
-		dev->isoc_ctl.vbi_buf = NULL;
+	if (dev->usb_ctl.vbi_buf == buf)
+		dev->usb_ctl.vbi_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	videobuf_vmalloc_free(&buf->vb);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index e51284c..b334885 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -165,7 +165,7 @@ static inline void buffer_filled(struct em28xx *dev,
 	buf->vb.field_count++;
 	do_gettimeofday(&buf->vb.ts);
 
-	dev->isoc_ctl.vid_buf = NULL;
+	dev->usb_ctl.vid_buf = NULL;
 
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
@@ -182,7 +182,7 @@ static inline void vbi_buffer_filled(struct em28xx *dev,
 	buf->vb.field_count++;
 	do_gettimeofday(&buf->vb.ts);
 
-	dev->isoc_ctl.vbi_buf = NULL;
+	dev->usb_ctl.vbi_buf = NULL;
 
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
@@ -368,7 +368,7 @@ static inline void get_next_buf(struct em28xx_dmaqueue *dma_q,
 
 	if (list_empty(&dma_q->active)) {
 		em28xx_isocdbg("No active queue to serve\n");
-		dev->isoc_ctl.vid_buf = NULL;
+		dev->usb_ctl.vid_buf = NULL;
 		*buf = NULL;
 		return;
 	}
@@ -380,7 +380,7 @@ static inline void get_next_buf(struct em28xx_dmaqueue *dma_q,
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
 	memset(outp, 0, (*buf)->vb.size);
 
-	dev->isoc_ctl.vid_buf = *buf;
+	dev->usb_ctl.vid_buf = *buf;
 
 	return;
 }
@@ -396,7 +396,7 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
 
 	if (list_empty(&dma_q->active)) {
 		em28xx_isocdbg("No active queue to serve\n");
-		dev->isoc_ctl.vbi_buf = NULL;
+		dev->usb_ctl.vbi_buf = NULL;
 		*buf = NULL;
 		return;
 	}
@@ -407,7 +407,7 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
 	memset(outp, 0x00, (*buf)->vb.size);
 
-	dev->isoc_ctl.vbi_buf = *buf;
+	dev->usb_ctl.vbi_buf = *buf;
 
 	return;
 }
@@ -435,7 +435,7 @@ static inline int em28xx_isoc_copy(struct em28xx *dev, struct urb *urb)
 			return 0;
 	}
 
-	buf = dev->isoc_ctl.vid_buf;
+	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
 		outp = videobuf_to_vmalloc(&buf->vb);
 
@@ -531,11 +531,11 @@ static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
 			return 0;
 	}
 
-	buf = dev->isoc_ctl.vid_buf;
+	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
 		outp = videobuf_to_vmalloc(&buf->vb);
 
-	vbi_buf = dev->isoc_ctl.vbi_buf;
+	vbi_buf = dev->usb_ctl.vbi_buf;
 	if (vbi_buf != NULL)
 		vbioutp = videobuf_to_vmalloc(&vbi_buf->vb);
 
@@ -725,8 +725,8 @@ static void free_buffer(struct videobuf_queue *vq, struct em28xx_buffer *buf)
 	   VIDEOBUF_ACTIVE, it won't be, though.
 	*/
 	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->isoc_ctl.vid_buf == buf)
-		dev->isoc_ctl.vid_buf = NULL;
+	if (dev->usb_ctl.vid_buf == buf)
+		dev->usb_ctl.vid_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	videobuf_vmalloc_free(&buf->vb);
@@ -758,7 +758,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 			goto fail;
 	}
 
-	if (!dev->isoc_ctl.analog_bufs.num_bufs)
+	if (!dev->usb_ctl.analog_bufs.num_bufs)
 		urb_init = 1;
 
 	if (urb_init) {
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e062a27..17310e6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -220,19 +220,19 @@ struct em28xx_usb_bufs {
 	char				**transfer_buffer;
 };
 
-struct em28xx_usb_isoc_ctl {
-		/* isoc transfer buffers for analog mode */
+struct em28xx_usb_ctl {
+		/* isoc/bulk transfer buffers for analog mode */
 	struct em28xx_usb_bufs		analog_bufs;
 
-		/* isoc transfer buffers for digital mode */
+		/* isoc/bulk transfer buffers for digital mode */
 	struct em28xx_usb_bufs		digital_bufs;
 
 		/* Stores already requested buffers */
 	struct em28xx_buffer    	*vid_buf;
 	struct em28xx_buffer    	*vbi_buf;
 
-		/* isoc urb callback */
-	int (*isoc_copy) (struct em28xx *dev, struct urb *urb);
+		/* copy data from URB */
+	int (*urb_data_copy) (struct em28xx *dev, struct urb *urb);
 
 };
 
@@ -582,7 +582,7 @@ struct em28xx {
 	/* Isoc control struct */
 	struct em28xx_dmaqueue vidq;
 	struct em28xx_dmaqueue vbiq;
-	struct em28xx_usb_isoc_ctl isoc_ctl;
+	struct em28xx_usb_ctl usb_ctl;
 	spinlock_t slock;
 
 	/* usb transfer */
-- 
1.7.10.4

