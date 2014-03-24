Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64332 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCXTdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:02 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so4852388eek.13
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:01 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 08/19] em28xx: move v4l2 frame resolutions and scale data from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:14 +0100
Message-Id: <1395689605-2705-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-vbi.c   | 10 +++--
 drivers/media/usb/em28xx/em28xx-video.c | 80 +++++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx.h       | 16 ++++---
 3 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index db3d655..6d7f657 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -47,12 +47,13 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	unsigned long size;
 
 	if (fmt)
 		size = fmt->fmt.pix.sizeimage;
 	else
-		size = dev->vbi_width * dev->vbi_height * 2;
+		size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
 	if (0 == *nbuffers)
 		*nbuffers = 32;
@@ -69,11 +70,12 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx        *dev  = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx_v4l2   *v4l2 = dev->v4l2;
+	struct em28xx_buffer *buf  = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long        size;
 
-	size = dev->vbi_width * dev->vbi_height * 2;
+	size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		printk(KERN_INFO "%s data will not fit into plane (%lu < %lu)\n",
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 301acef..ecc4411 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -218,6 +218,7 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 {
 	int ret;
 	u8 fmt, vinctrl;
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
 	fmt = dev->format->reg;
 	if (!dev->is_em25xx)
@@ -243,8 +244,8 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 	if (em28xx_vbi_supported(dev) == 1) {
 		vinctrl |= EM28XX_VINCTRL_VBI_RAW;
 		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
-		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, dev->vbi_width/4);
-		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, dev->vbi_height);
+		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, v4l2->vbi_width/4);
+		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, v4l2->vbi_height);
 		if (dev->norm & V4L2_STD_525_60) {
 			/* NTSC */
 			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x09);
@@ -323,16 +324,16 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 /* FIXME: this only function read values from dev */
 static int em28xx_resolution_set(struct em28xx *dev)
 {
-	int width, height;
-	width = norm_maxw(dev);
-	height = norm_maxh(dev);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	int width = norm_maxw(dev);
+	int height = norm_maxh(dev);
 
 	/* Properly setup VBI */
-	dev->vbi_width = 720;
+	v4l2->vbi_width = 720;
 	if (dev->norm & V4L2_STD_525_60)
-		dev->vbi_height = 12;
+		v4l2->vbi_height = 12;
 	else
-		dev->vbi_height = 18;
+		v4l2->vbi_height = 18;
 
 	em28xx_set_outfmt(dev);
 
@@ -350,15 +351,16 @@ static int em28xx_resolution_set(struct em28xx *dev)
 	else
 		em28xx_capture_area_set(dev, 0, 0, width, height);
 
-	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
+	return em28xx_scaler_set(dev, v4l2->hscale, v4l2->vscale);
 }
 
 /* Set USB alternate setting for analog video */
 static int em28xx_set_alternate(struct em28xx *dev)
 {
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	int errCode;
 	int i;
-	unsigned int min_pkt_size = dev->width * 2 + 4;
+	unsigned int min_pkt_size = v4l2->width * 2 + 4;
 
 	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
 		 bulk transfers seem to work only with alt=0 ! */
@@ -375,7 +377,7 @@ static int em28xx_set_alternate(struct em28xx *dev)
 	   the frame size should be increased, otherwise, only
 	   green screen will be received.
 	 */
-	if (dev->width * 2 * dev->height > 720 * 240 * 2)
+	if (v4l2->width * 2 * v4l2->height > 720 * 240 * 2)
 		min_pkt_size *= 2;
 
 	for (i = 0; i < dev->num_alt; i++) {
@@ -445,7 +447,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 {
 	void *fieldstart, *startwrite, *startread;
 	int  linesdone, currlinedone, offset, lencopy, remain;
-	int bytesperline = dev->width << 1;
+	int bytesperline = dev->v4l2->width << 1;
 
 	if (buf->pos + len > buf->length)
 		len = buf->length - buf->pos;
@@ -531,7 +533,7 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 	offset = buf->pos;
 	/* Make sure the bottom field populates the second half of the frame */
 	if (buf->top_field == 0)
-		offset += dev->vbi_width * dev->vbi_height;
+		offset += dev->v4l2->vbi_width * dev->v4l2->vbi_height;
 
 	memcpy(buf->vb_buf + offset, usb_buf, len);
 	buf->pos += len;
@@ -627,6 +629,7 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 					     unsigned char *data_pkt,
 					     unsigned int  data_len)
 {
+	struct em28xx_v4l2      *v4l2 = dev->v4l2;
 	struct em28xx_buffer    *buf = dev->usb_ctl.vid_buf;
 	struct em28xx_buffer    *vbi_buf = dev->usb_ctl.vbi_buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
@@ -671,7 +674,7 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 	}
 
 	if (dev->capture_type == 1) {
-		int vbi_size = dev->vbi_width * dev->vbi_height;
+		int vbi_size = v4l2->vbi_width * v4l2->vbi_height;
 		int vbi_data_len = ((dev->vbi_read + data_len) > vbi_size) ?
 				   (vbi_size - dev->vbi_read) : data_len;
 
@@ -865,12 +868,14 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	unsigned long size;
 
 	if (fmt)
 		size = fmt->fmt.pix.sizeimage;
 	else
-		size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
+		size =
+		     (v4l2->width * v4l2->height * dev->format->depth + 7) >> 3;
 
 	if (size == 0)
 		return -EINVAL;
@@ -888,12 +893,13 @@ static int
 buffer_prepare(struct vb2_buffer *vb)
 {
 	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx_v4l2   *v4l2 = dev->v4l2;
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long size;
 
 	em28xx_videodbg("%s, field=%d\n", __func__, vb->v4l2_buf.field);
 
-	size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
+	size = (v4l2->width * v4l2->height * dev->format->depth + 7) >> 3;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		em28xx_videodbg("%s data will not fit into plane (%lu < %lu)\n",
@@ -1216,12 +1222,13 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
-	f->fmt.pix.width = dev->width;
-	f->fmt.pix.height = dev->height;
+	f->fmt.pix.width = v4l2->width;
+	f->fmt.pix.height = v4l2->height;
 	f->fmt.pix.pixelformat = dev->format->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline  * dev->height;
+	f->fmt.pix.bytesperline = (v4l2->width * dev->format->depth + 7) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * v4l2->height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	/* FIXME: TOP? NONE? BOTTOM? ALTENATE? */
@@ -1304,17 +1311,19 @@ static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
 				   unsigned width, unsigned height)
 {
 	struct em28xx_fmt     *fmt;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	fmt = format_by_fourcc(fourcc);
 	if (!fmt)
 		return -EINVAL;
 
 	dev->format = fmt;
-	dev->width  = width;
-	dev->height = height;
+	v4l2->width  = width;
+	v4l2->height = height;
 
 	/* set new image size */
-	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
+	size_to_scale(dev, v4l2->width, v4l2->height,
+			   &v4l2->hscale, &v4l2->vscale);
 
 	em28xx_resolution_set(dev);
 
@@ -1357,8 +1366,9 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx_fh   *fh   = priv;
+	struct em28xx      *dev  = fh->dev;
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct v4l2_format f;
 
 	if (norm == dev->norm)
@@ -1375,12 +1385,13 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	vidioc_try_fmt_vid_cap(file, priv, &f);
 
 	/* set new image size */
-	dev->width = f.fmt.pix.width;
-	dev->height = f.fmt.pix.height;
-	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
+	v4l2->width = f.fmt.pix.width;
+	v4l2->height = f.fmt.pix.height;
+	size_to_scale(dev, v4l2->width, v4l2->height,
+			   &v4l2->hscale, &v4l2->vscale);
 
 	em28xx_resolution_set(dev);
-	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, dev->norm);
 
 	return 0;
 }
@@ -1784,16 +1795,17 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 				struct v4l2_format *format)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx_fh      *fh   = priv;
+	struct em28xx         *dev  = fh->dev;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
-	format->fmt.vbi.samples_per_line = dev->vbi_width;
+	format->fmt.vbi.samples_per_line = v4l2->vbi_width;
 	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
 	format->fmt.vbi.offset = 0;
 	format->fmt.vbi.flags = 0;
 	format->fmt.vbi.sampling_rate = 6750000 * 4 / 2;
-	format->fmt.vbi.count[0] = dev->vbi_height;
-	format->fmt.vbi.count[1] = dev->vbi_height;
+	format->fmt.vbi.count[0] = v4l2->vbi_height;
+	format->fmt.vbi.count[1] = v4l2->vbi_height;
 	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	/* Varies by video standard (NTSC, PAL, etc.) */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b02e8b1..e029136 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -514,6 +514,14 @@ struct em28xx_v4l2 {
 	struct vb2_queue vb_vbiq;
 	struct mutex vb_queue_lock;
 	struct mutex vb_vbi_queue_lock;
+
+	/* Frame properties */
+	int width;		/* current frame width */
+	int height;		/* current frame height */
+	unsigned hscale;	/* horizontal scale factor (see datasheet) */
+	unsigned vscale;	/* vertical scale factor (see datasheet) */
+	unsigned int vbi_width;
+	unsigned int vbi_height; /* lines per field */
 };
 
 struct em28xx_audio {
@@ -631,11 +639,7 @@ struct em28xx {
 	unsigned int ctl_aoutput;/* selected audio output */
 	int mute;
 	int volume;
-	/* frame properties */
-	int width;		/* current frame width */
-	int height;		/* current frame height */
-	unsigned hscale;	/* horizontal scale factor (see datasheet) */
-	unsigned vscale;	/* vertical scale factor (see datasheet) */
+
 	int interlaced;		/* 1=interlace fileds, 0=just top fileds */
 
 	unsigned long hash;	/* eeprom hash - for boards with generic ID */
@@ -646,8 +650,6 @@ struct em28xx {
 	int capture_type;
 	unsigned char top_field:1;
 	int vbi_read;
-	unsigned int vbi_width;
-	unsigned int vbi_height; /* lines per field */
 
 	struct work_struct         request_module_wk;
 
-- 
1.8.4.5

