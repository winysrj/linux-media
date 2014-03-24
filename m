Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55805 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaCXTdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:06 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so4761665eei.5
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 12/19] em28xx: move progressive/interlaced fields from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:18 +0100
Message-Id: <1395689605-2705-13-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  2 --
 drivers/media/usb/em28xx/em28xx-video.c | 27 +++++++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h       | 10 +++++-----
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a21cce1..64ea25a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2682,8 +2682,6 @@ static void em28xx_card_setup(struct em28xx *dev)
 	if (dev->board.is_webcam) {
 		if (em28xx_detect_sensor(dev) < 0)
 			dev->board.is_webcam = 0;
-		else
-			dev->progressive = 1;
 	}
 
 	switch (dev->model) {
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c316147..abb4e8e 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -447,9 +447,10 @@ static void em28xx_copy_video(struct em28xx *dev,
 			      unsigned char *usb_buf,
 			      unsigned long len)
 {
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	void *fieldstart, *startwrite, *startread;
 	int  linesdone, currlinedone, offset, lencopy, remain;
-	int bytesperline = dev->v4l2->width << 1;
+	int bytesperline = v4l2->width << 1;
 
 	if (buf->pos + len > buf->length)
 		len = buf->length - buf->pos;
@@ -457,7 +458,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 	startread = usb_buf;
 	remain = len;
 
-	if (dev->progressive || buf->top_field)
+	if (v4l2->progressive || buf->top_field)
 		fieldstart = buf->vb_buf;
 	else /* interlaced mode, even nr. of lines */
 		fieldstart = buf->vb_buf + bytesperline;
@@ -465,7 +466,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 	linesdone = buf->pos / bytesperline;
 	currlinedone = buf->pos % bytesperline;
 
-	if (dev->progressive)
+	if (v4l2->progressive)
 		offset = linesdone * bytesperline + currlinedone;
 	else
 		offset = linesdone * bytesperline * 2 + currlinedone;
@@ -489,7 +490,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 	remain -= lencopy;
 
 	while (remain > 0) {
-		if (dev->progressive)
+		if (v4l2->progressive)
 			startwrite += lencopy;
 		else
 			startwrite += lencopy + bytesperline;
@@ -611,7 +612,9 @@ finish_field_prepare_next(struct em28xx *dev,
 			  struct em28xx_buffer *buf,
 			  struct em28xx_dmaqueue *dma_q)
 {
-	if (dev->progressive || dev->top_field) { /* Brand new frame */
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+
+	if (v4l2->progressive || dev->top_field) { /* Brand new frame */
 		if (buf != NULL)
 			finish_buffer(dev, buf);
 		buf = get_next_buf(dev, dma_q);
@@ -1234,10 +1237,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	/* FIXME: TOP? NONE? BOTTOM? ALTENATE? */
-	if (dev->progressive)
+	if (v4l2->progressive)
 		f->fmt.pix.field = V4L2_FIELD_NONE;
 	else
-		f->fmt.pix.field = dev->interlaced ?
+		f->fmt.pix.field = v4l2->interlaced_fieldmode ?
 			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
 	return 0;
 }
@@ -1258,6 +1261,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh    = priv;
 	struct em28xx         *dev   = fh->dev;
+	struct em28xx_v4l2    *v4l2  = dev->v4l2;
 	unsigned int          width  = f->fmt.pix.width;
 	unsigned int          height = f->fmt.pix.height;
 	unsigned int          maxw   = norm_maxw(dev);
@@ -1299,10 +1303,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = (width * fmt->depth + 7) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	if (dev->progressive)
+	if (v4l2->progressive)
 		f->fmt.pix.field = V4L2_FIELD_NONE;
 	else
-		f->fmt.pix.field = dev->interlaced ?
+		f->fmt.pix.field = v4l2->interlaced_fieldmode ?
 			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
 	f->fmt.pix.priv = 0;
 
@@ -2316,6 +2320,9 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2_ctrl_handler_init(hdl, 8);
 	v4l2->v4l2_dev.ctrl_handler = hdl;
 
+	if (dev->board.is_webcam)
+		v4l2->progressive = 1;
+
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
 	 */
@@ -2430,7 +2437,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* set default norm */
 	v4l2->norm = V4L2_STD_PAL;
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, v4l2->norm);
-	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
+	v4l2->interlaced_fieldmode = EM28XX_INTERLACED_DEFAULT;
 
 	/* Analog specific initialization */
 	v4l2->format = &format[0];
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index dd93a37..1491879 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -521,6 +521,11 @@ struct em28xx_v4l2 {
 	struct em28xx_fmt *format;
 	v4l2_std_id norm;	/* selected tv norm */
 
+	/* Progressive/interlaced mode */
+	bool progressive;
+	int interlaced_fieldmode; /* 1=interlaced fields, 0=just top fields */
+	/* FIXME: everything else than interlaced_fieldmode=1 doesn't work */
+
 	/* Frame properties */
 	int width;		/* current frame width */
 	int height;		/* current frame height */
@@ -600,9 +605,6 @@ struct em28xx {
 	int sensor_xres, sensor_yres;
 	int sensor_xtal;
 
-	/* Progressive (non-interlaced) mode */
-	int progressive;
-
 	/* Controls audio streaming */
 	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
 	atomic_t       stream_started;	/* stream should be running if true */
@@ -640,8 +642,6 @@ struct em28xx {
 	int mute;
 	int volume;
 
-	int interlaced;		/* 1=interlace fileds, 0=just top fileds */
-
 	unsigned long hash;	/* eeprom hash - for boards with generic ID */
 	unsigned long i2c_hash;	/* i2c devicelist hash -
 				   for boards with generic ID */
-- 
1.8.4.5

