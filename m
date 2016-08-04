Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36321 "EHLO
	mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934199AbcHDWAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 18:00:35 -0400
Received: by mail-qt0-f172.google.com with SMTP id 52so165877057qtq.3
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2016 15:00:35 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] media: tw686x: Rework initial hardware configuration
Date: Thu,  4 Aug 2016 19:00:22 -0300
Message-Id: <20160804220022.1157-1-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the hardware is not given a complete initial
configuration.

In order to fix this, this rather large commit reworks
standard, frame format and input configuration. While
at it, we introduce proper functions to configure
each parameter, and as a result the code is a bit cleaner.

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-video.c | 139 +++++++++++++++++++-------------
 1 file changed, 81 insertions(+), 58 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index cdb16de770fe..be257d0257a6 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -672,30 +672,20 @@ static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
+static int tw686x_set_format(struct tw686x_video_channel *vc,
+			     unsigned int pixelformat, unsigned int width,
+			     unsigned int height, bool realloc)
 {
-	struct tw686x_video_channel *vc = video_drvdata(file);
 	struct tw686x_dev *dev = vc->dev;
-	u32 val, width, line_width, height;
-	unsigned long bitsperframe;
+	u32 val, dma_width, dma_height, dma_line_width;
 	int err, pb;
 
-	if (vb2_is_busy(&vc->vidq))
-		return -EBUSY;
-
-	bitsperframe = vc->width * vc->height * vc->format->depth;
-	err = tw686x_try_fmt_vid_cap(file, priv, f);
-	if (err)
-		return err;
-
-	vc->format = format_by_fourcc(f->fmt.pix.pixelformat);
-	vc->width = f->fmt.pix.width;
-	vc->height = f->fmt.pix.height;
+	vc->format = format_by_fourcc(pixelformat);
+	vc->width = width;
+	vc->height = height;
 
 	/* We need new DMA buffers if the framesize has changed */
-	if (dev->dma_ops->alloc &&
-	    bitsperframe != vc->width * vc->height * vc->format->depth) {
+	if (dev->dma_ops->alloc && realloc) {
 		for (pb = 0; pb < 2; pb++)
 			dev->dma_ops->free(vc, pb);
 
@@ -739,14 +729,36 @@ static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
 	reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
 
 	/* Program the DMA frame size */
-	width = (vc->width * 2) & 0x7ff;
-	height = vc->height / 2;
-	line_width = (vc->width * 2) & 0x7ff;
-	val = (height << 22) | (line_width << 11)  | width;
+	dma_width = (vc->width * 2) & 0x7ff;
+	dma_height = vc->height / 2;
+	dma_line_width = (vc->width * 2) & 0x7ff;
+	val = (dma_height << 22) | (dma_line_width << 11)  | dma_width;
 	reg_write(vc->dev, VDMA_WHP[vc->ch], val);
 	return 0;
 }
 
+static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+	unsigned long area;
+	bool realloc;
+	int err;
+
+	if (vb2_is_busy(&vc->vidq))
+		return -EBUSY;
+
+	area = vc->width * vc->height;
+	err = tw686x_try_fmt_vid_cap(file, priv, f);
+	if (err)
+		return err;
+
+	realloc = area != (f->fmt.pix.width * f->fmt.pix.height);
+	return tw686x_set_format(vc, f->fmt.pix.pixelformat,
+				 f->fmt.pix.width, f->fmt.pix.height,
+				 realloc);
+}
+
 static int tw686x_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
@@ -763,17 +775,9 @@ static int tw686x_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
+static int tw686x_set_standard(struct tw686x_video_channel *vc, v4l2_std_id id)
 {
-	struct tw686x_video_channel *vc = video_drvdata(file);
-	struct v4l2_format f;
-	u32 val, ret;
-
-	if (vc->video_standard == id)
-		return 0;
-
-	if (vb2_is_busy(&vc->vidq))
-		return -EBUSY;
+	u32 val;
 
 	if (id & V4L2_STD_NTSC)
 		val = 0;
@@ -802,14 +806,31 @@ static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
 		val |= (1 << (SYS_MODE_DMA_SHIFT + vc->ch));
 	reg_write(vc->dev, VIDEO_CONTROL1, val);
 
+	return 0;
+}
+
+static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct v4l2_format f;
+	int ret;
+
+	if (vc->video_standard == id)
+		return 0;
+
+	if (vb2_is_busy(&vc->vidq))
+		return -EBUSY;
+
+	ret = tw686x_set_standard(vc, id);
+	if (ret)
+		return ret;
 	/*
 	 * Adjust format after V4L2_STD_525_60/V4L2_STD_625_50 change,
 	 * calling g_fmt and s_fmt will sanitize the height
 	 * according to the standard.
 	 */
-	ret = tw686x_g_fmt_vid_cap(file, priv, &f);
-	if (!ret)
-		tw686x_s_fmt_vid_cap(file, priv, &f);
+	tw686x_g_fmt_vid_cap(file, priv, &f);
+	tw686x_s_fmt_vid_cap(file, priv, &f);
 
 	/*
 	 * Frame decimation depends on the chosen standard,
@@ -928,10 +949,21 @@ static int tw686x_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static void tw686x_set_input(struct tw686x_video_channel *vc, unsigned int i)
+{
+	u32 val;
+
+	vc->input = i;
+
+	val = reg_read(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch]);
+	val &= ~(0x3 << 30);
+	val |= i << 30;
+	reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
+}
+
 static int tw686x_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
-	u32 val;
 
 	if (i >= TW686X_INPUTS_PER_CH)
 		return -EINVAL;
@@ -943,12 +975,7 @@ static int tw686x_s_input(struct file *file, void *priv, unsigned int i)
 	if (vb2_is_busy(&vc->vidq))
 		return -EBUSY;
 
-	vc->input = i;
-
-	val = reg_read(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch]);
-	val &= ~(0x3 << 30);
-	val |= i << 30;
-	reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
+	tw686x_set_input(vc, i);
 	return 0;
 }
 
@@ -1104,7 +1131,7 @@ void tw686x_video_free(struct tw686x_dev *dev)
 
 int tw686x_video_init(struct tw686x_dev *dev)
 {
-	unsigned int ch, val, pb;
+	unsigned int ch, val;
 	int err;
 
 	if (dev->dma_mode == TW686X_DMA_MODE_MEMCPY)
@@ -1138,27 +1165,23 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->ch = ch;
 
 		/* default settings */
-		vc->format = &formats[0];
-		vc->video_standard = V4L2_STD_NTSC;
-		vc->width = TW686X_VIDEO_WIDTH;
-		vc->height = TW686X_VIDEO_HEIGHT(vc->video_standard);
-		vc->input = 0;
+		err = tw686x_set_standard(vc, V4L2_STD_NTSC);
+		if (err)
+			goto error;
 
-		reg_write(vc->dev, SDT[ch], 0);
-		tw686x_set_framerate(vc, 30);
+		err = tw686x_set_format(vc, formats[0].fourcc,
+				TW686X_VIDEO_WIDTH,
+				TW686X_VIDEO_HEIGHT(vc->video_standard),
+				true);
+		if (err)
+			goto error;
 
+		tw686x_set_input(vc, 0);
+		tw686x_set_framerate(vc, 30);
 		reg_write(dev, VDELAY_LO[ch], 0x14);
 		reg_write(dev, HACTIVE_LO[ch], 0xd0);
 		reg_write(dev, VIDEO_SIZE[ch], 0);
 
-		if (dev->dma_ops->alloc) {
-			for (pb = 0; pb < 2; pb++) {
-				err = dev->dma_ops->alloc(vc, pb);
-				if (err)
-					goto error;
-			}
-		}
-
 		vc->vidq.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
 		vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		vc->vidq.drv_priv = vc;
-- 
2.9.0

