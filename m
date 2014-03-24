Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62889 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaCXTdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:10 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so4826908eek.11
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:09 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 14/19] em28xx: move capture state tracking fields from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:20 +0100
Message-Id: <1395689605-2705-15-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 44 +++++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx.h       | 13 +++++-----
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 640c0b0..496dcef 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -434,7 +434,7 @@ static inline void finish_buffer(struct em28xx *dev,
 {
 	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
-	buf->vb.v4l2_buf.sequence = dev->field_count++;
+	buf->vb.v4l2_buf.sequence = dev->v4l2->field_count++;
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
@@ -616,13 +616,13 @@ finish_field_prepare_next(struct em28xx *dev,
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (v4l2->progressive || dev->top_field) { /* Brand new frame */
+	if (v4l2->progressive || v4l2->top_field) { /* Brand new frame */
 		if (buf != NULL)
 			finish_buffer(dev, buf);
 		buf = get_next_buf(dev, dma_q);
 	}
 	if (buf != NULL) {
-		buf->top_field = dev->top_field;
+		buf->top_field = v4l2->top_field;
 		buf->pos = 0;
 	}
 
@@ -656,17 +656,17 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 			data_len -= 4;
 		} else if (data_pkt[0] == 0x33 && data_pkt[1] == 0x95) {
 			/* Field start (VBI mode) */
-			dev->capture_type = 0;
-			dev->vbi_read = 0;
+			v4l2->capture_type = 0;
+			v4l2->vbi_read = 0;
 			em28xx_isocdbg("VBI START HEADER !!!\n");
-			dev->top_field = !(data_pkt[2] & 1);
+			v4l2->top_field = !(data_pkt[2] & 1);
 			data_pkt += 4;
 			data_len -= 4;
 		} else if (data_pkt[0] == 0x22 && data_pkt[1] == 0x5a) {
 			/* Field start (VBI disabled) */
-			dev->capture_type = 2;
+			v4l2->capture_type = 2;
 			em28xx_isocdbg("VIDEO START HEADER !!!\n");
-			dev->top_field = !(data_pkt[2] & 1);
+			v4l2->top_field = !(data_pkt[2] & 1);
 			data_pkt += 4;
 			data_len -= 4;
 		}
@@ -674,37 +674,37 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 	/* NOTE: With bulk transfers, intermediate data packets
 	 * have no continuation header */
 
-	if (dev->capture_type == 0) {
+	if (v4l2->capture_type == 0) {
 		vbi_buf = finish_field_prepare_next(dev, vbi_buf, vbi_dma_q);
 		dev->usb_ctl.vbi_buf = vbi_buf;
-		dev->capture_type = 1;
+		v4l2->capture_type = 1;
 	}
 
-	if (dev->capture_type == 1) {
+	if (v4l2->capture_type == 1) {
 		int vbi_size = v4l2->vbi_width * v4l2->vbi_height;
-		int vbi_data_len = ((dev->vbi_read + data_len) > vbi_size) ?
-				   (vbi_size - dev->vbi_read) : data_len;
+		int vbi_data_len = ((v4l2->vbi_read + data_len) > vbi_size) ?
+				   (vbi_size - v4l2->vbi_read) : data_len;
 
 		/* Copy VBI data */
 		if (vbi_buf != NULL)
 			em28xx_copy_vbi(dev, vbi_buf, data_pkt, vbi_data_len);
-		dev->vbi_read += vbi_data_len;
+		v4l2->vbi_read += vbi_data_len;
 
 		if (vbi_data_len < data_len) {
 			/* Continue with copying video data */
-			dev->capture_type = 2;
+			v4l2->capture_type = 2;
 			data_pkt += vbi_data_len;
 			data_len -= vbi_data_len;
 		}
 	}
 
-	if (dev->capture_type == 2) {
+	if (v4l2->capture_type == 2) {
 		buf = finish_field_prepare_next(dev, buf, dma_q);
 		dev->usb_ctl.vid_buf = buf;
-		dev->capture_type = 3;
+		v4l2->capture_type = 3;
 	}
 
-	if (dev->capture_type == 3 && buf != NULL && data_len > 0)
+	if (v4l2->capture_type == 3 && buf != NULL && data_len > 0)
 		em28xx_copy_video(dev, buf, data_pkt, data_len);
 }
 
@@ -717,6 +717,7 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 {
 	struct em28xx_buffer    *buf = dev->usb_ctl.vid_buf;
 	struct em28xx_dmaqueue  *dmaq = &dev->vidq;
+	struct em28xx_v4l2      *v4l2 = dev->v4l2;
 	bool frame_end = 0;
 
 	/* Check for header */
@@ -725,7 +726,7 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 	if (data_len >= 2) {	/* em25xx header is only 2 bytes long */
 		if ((data_pkt[0] == EM25XX_FRMDATAHDR_BYTE1) &&
 		    ((data_pkt[1] & ~EM25XX_FRMDATAHDR_BYTE2_MASK) == 0x00)) {
-			dev->top_field = !(data_pkt[1] &
+			v4l2->top_field = !(data_pkt[1] &
 					   EM25XX_FRMDATAHDR_BYTE2_FRAME_ID);
 			frame_end = data_pkt[1] &
 				    EM25XX_FRMDATAHDR_BYTE2_FRAME_END;
@@ -921,6 +922,7 @@ buffer_prepare(struct vb2_buffer *vb)
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct v4l2_frequency f;
 	int rc = 0;
 
@@ -943,7 +945,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		*/
 		em28xx_wake_i2c(dev);
 
-		dev->capture_type = -1;
+		v4l2->capture_type = -1;
 		rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
 					  dev->analog_xfer_bulk,
 					  EM28XX_NUM_BUFS,
@@ -966,7 +968,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 			f.type = V4L2_TUNER_RADIO;
 		else
 			f.type = V4L2_TUNER_ANALOG_TV;
-		v4l2_device_call_all(&dev->v4l2->v4l2_dev,
+		v4l2_device_call_all(&v4l2->v4l2_dev,
 				     0, tuner, s_frequency, &f);
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f447108..91bb624 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -538,6 +538,12 @@ struct em28xx_v4l2 {
 	unsigned vscale;	/* vertical scale factor (see datasheet) */
 	unsigned int vbi_width;
 	unsigned int vbi_height; /* lines per field */
+
+	/* Capture state tracking */
+	int capture_type;
+	bool top_field;
+	int vbi_read;
+	unsigned int field_count;
 };
 
 struct em28xx_audio {
@@ -648,11 +654,6 @@ struct em28xx {
 	unsigned long i2c_hash;	/* i2c devicelist hash -
 				   for boards with generic ID */
 
-	/* capture state tracking */
-	int capture_type;
-	unsigned char top_field:1;
-	int vbi_read;
-
 	struct work_struct         request_module_wk;
 
 	/* locks */
@@ -672,8 +673,6 @@ struct em28xx {
 	struct em28xx_usb_ctl usb_ctl;
 	spinlock_t slock;
 
-	unsigned int field_count;
-
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
 	u8 ifnum;		/* number of the assigned usb interface */
-- 
1.8.4.5

