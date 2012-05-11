Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3222 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2EKHza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/16] vivi: add more pixelformats.
Date: Fri, 11 May 2012 09:54:56 +0200
Message-Id: <71fcfe387293eaf2fe6f12ca2aa65659ac1b2450.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is very useful for testing whether userspace can handle the various formats
correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |  165 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 135 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index d64d482..2a0198f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -95,6 +95,16 @@ static struct vivi_fmt formats[] = {
 		.depth    = 16,
 	},
 	{
+		.name     = "4:2:2, packed, YVYU",
+		.fourcc   = V4L2_PIX_FMT_YVYU,
+		.depth    = 16,
+	},
+	{
+		.name     = "4:2:2, packed, VYUY",
+		.fourcc   = V4L2_PIX_FMT_VYUY,
+		.depth    = 16,
+	},
+	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.depth    = 16,
@@ -114,6 +124,26 @@ static struct vivi_fmt formats[] = {
 		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
 		.depth    = 16,
 	},
+	{
+		.name     = "RGB24 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
+		.depth    = 24,
+	},
+	{
+		.name     = "RGB24 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
+		.depth    = 24,
+	},
+	{
+		.name     = "RGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
+		.depth    = 32,
+	},
+	{
+		.name     = "RGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
+		.depth    = 32,
+	},
 };
 
 static struct vivi_fmt *get_format(struct v4l2_format *f)
@@ -204,8 +234,9 @@ struct vivi_dev {
 	enum v4l2_field		   field;
 	unsigned int		   field_count;
 
-	u8 			   bars[9][3];
-	u8 			   line[MAX_WIDTH * 4];
+	u8			   bars[9][3];
+	u8			   line[MAX_WIDTH * 8];
+	unsigned int		   pixelsize;
 };
 
 /* ------------------------------------------------------------------
@@ -284,6 +315,8 @@ static void precalculate_bars(struct vivi_dev *dev)
 		switch (dev->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 		case V4L2_PIX_FMT_UYVY:
+		case V4L2_PIX_FMT_YVYU:
+		case V4L2_PIX_FMT_VYUY:
 			is_yuv = 1;
 			break;
 		case V4L2_PIX_FMT_RGB565:
@@ -298,6 +331,11 @@ static void precalculate_bars(struct vivi_dev *dev)
 			g >>= 3;
 			b >>= 3;
 			break;
+		case V4L2_PIX_FMT_RGB24:
+		case V4L2_PIX_FMT_BGR24:
+		case V4L2_PIX_FMT_RGB32:
+		case V4L2_PIX_FMT_BGR32:
+			break;
 		}
 
 		if (is_yuv) {
@@ -317,7 +355,8 @@ static void precalculate_bars(struct vivi_dev *dev)
 #define TSTAMP_INPUT_X	10
 #define TSTAMP_MIN_X	(54 + TSTAMP_INPUT_X)
 
-static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos)
+/* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
+static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 {
 	u8 r_y, g_u, b_v;
 	int color;
@@ -327,46 +366,56 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos)
 	g_u = dev->bars[colorpos][1]; /* G or precalculated U */
 	b_v = dev->bars[colorpos][2]; /* B or precalculated V */
 
-	for (color = 0; color < 4; color++) {
+	for (color = 0; color < dev->pixelsize; color++) {
 		p = buf + color;
 
 		switch (dev->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 			switch (color) {
 			case 0:
-			case 2:
 				*p = r_y;
 				break;
 			case 1:
-				*p = g_u;
-				break;
-			case 3:
-				*p = b_v;
+				*p = odd ? b_v : g_u;
 				break;
 			}
 			break;
 		case V4L2_PIX_FMT_UYVY:
 			switch (color) {
+			case 0:
+				*p = odd ? b_v : g_u;
+				break;
 			case 1:
-			case 3:
 				*p = r_y;
 				break;
+			}
+			break;
+		case V4L2_PIX_FMT_YVYU:
+			switch (color) {
+			case 0:
+				*p = r_y;
+				break;
+			case 1:
+				*p = odd ? g_u : b_v;
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_VYUY:
+			switch (color) {
 			case 0:
-				*p = g_u;
+				*p = odd ? g_u : b_v;
 				break;
-			case 2:
-				*p = b_v;
+			case 1:
+				*p = r_y;
 				break;
 			}
 			break;
 		case V4L2_PIX_FMT_RGB565:
 			switch (color) {
 			case 0:
-			case 2:
 				*p = (g_u << 5) | b_v;
 				break;
 			case 1:
-			case 3:
 				*p = (r_y << 3) | (g_u >> 3);
 				break;
 			}
@@ -374,11 +423,9 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos)
 		case V4L2_PIX_FMT_RGB565X:
 			switch (color) {
 			case 0:
-			case 2:
 				*p = (r_y << 3) | (g_u >> 3);
 				break;
 			case 1:
-			case 3:
 				*p = (g_u << 5) | b_v;
 				break;
 			}
@@ -386,11 +433,9 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos)
 		case V4L2_PIX_FMT_RGB555:
 			switch (color) {
 			case 0:
-			case 2:
 				*p = (g_u << 5) | b_v;
 				break;
 			case 1:
-			case 3:
 				*p = (r_y << 2) | (g_u >> 3);
 				break;
 			}
@@ -398,15 +443,71 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos)
 		case V4L2_PIX_FMT_RGB555X:
 			switch (color) {
 			case 0:
-			case 2:
 				*p = (r_y << 2) | (g_u >> 3);
 				break;
 			case 1:
-			case 3:
 				*p = (g_u << 5) | b_v;
 				break;
 			}
 			break;
+		case V4L2_PIX_FMT_RGB24:
+			switch (color) {
+			case 0:
+				*p = r_y;
+				break;
+			case 1:
+				*p = g_u;
+				break;
+			case 2:
+				*p = b_v;
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			switch (color) {
+			case 0:
+				*p = b_v;
+				break;
+			case 1:
+				*p = g_u;
+				break;
+			case 2:
+				*p = r_y;
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_RGB32:
+			switch (color) {
+			case 0:
+				*p = 0;
+				break;
+			case 1:
+				*p = r_y;
+				break;
+			case 2:
+				*p = g_u;
+				break;
+			case 3:
+				*p = b_v;
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_BGR32:
+			switch (color) {
+			case 0:
+				*p = b_v;
+				break;
+			case 1:
+				*p = g_u;
+				break;
+			case 2:
+				*p = r_y;
+				break;
+			case 3:
+				*p = 0;
+				break;
+			}
+			break;
 		}
 	}
 }
@@ -415,10 +516,10 @@ static void precalculate_line(struct vivi_dev *dev)
 {
 	int w;
 
-	for (w = 0; w < dev->width * 2; w += 2) {
-		int colorpos = (w / (dev->width / 8) % 8);
+	for (w = 0; w < dev->width * 2; w++) {
+		int colorpos = w / (dev->width / 8) % 8;
 
-		gen_twopix(dev, dev->line + w * 2, colorpos);
+		gen_twopix(dev, dev->line + w * dev->pixelsize, colorpos, w & 1);
 	}
 }
 
@@ -434,7 +535,7 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 	/* Print stream time */
 	for (line = y; line < y + 16; line++) {
 		int j = 0;
-		char *pos = basep + line * dev->width * 2 + x * 2;
+		char *pos = basep + line * dev->width * dev->pixelsize + x * dev->pixelsize;
 		char *s;
 
 		for (s = text; *s; s++) {
@@ -444,9 +545,9 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 			for (i = 0; i < 7; i++, j++) {
 				/* Draw white font on black background */
 				if (chr & (1 << (7 - i)))
-					gen_twopix(dev, pos + j * 2, WHITE);
+					gen_twopix(dev, pos + j * dev->pixelsize, WHITE, (x+y) & 1);
 				else
-					gen_twopix(dev, pos + j * 2, TEXT_BLACK);
+					gen_twopix(dev, pos + j * dev->pixelsize, TEXT_BLACK, (x+y) & 1);
 			}
 		}
 	}
@@ -467,7 +568,9 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 		return;
 
 	for (h = 0; h < hmax; h++)
-		memcpy(vbuf + h * wmax * 2, dev->line + (dev->mv_count % wmax) * 2, wmax * 2);
+		memcpy(vbuf + h * wmax * dev->pixelsize,
+		       dev->line + (dev->mv_count % wmax) * dev->pixelsize,
+		       wmax * dev->pixelsize);
 
 	/* Updates stream time */
 
@@ -662,7 +765,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
 
-	size = dev->width * dev->height * 2;
+	size = dev->width * dev->height * dev->pixelsize;
 
 	if (0 == *nbuffers)
 		*nbuffers = 32;
@@ -726,7 +829,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	    dev->height < 32 || dev->height > MAX_HEIGHT)
 		return -EINVAL;
 
-	size = dev->width * dev->height * 2;
+	size = dev->width * dev->height * dev->pixelsize;
 	if (vb2_plane_size(vb, 0) < size) {
 		dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), size);
@@ -920,6 +1023,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	dev->fmt = get_format(f);
+	dev->pixelsize = dev->fmt->depth / 8;
 	dev->width = f->fmt.pix.width;
 	dev->height = f->fmt.pix.height;
 	dev->field = f->fmt.pix.field;
@@ -1266,6 +1370,7 @@ static int __init vivi_create_instance(int inst)
 	dev->fmt = &formats[0];
 	dev->width = 640;
 	dev->height = 480;
+	dev->pixelsize = dev->fmt->depth / 8;
 	hdl = &dev->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 11);
 	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
-- 
1.7.10

