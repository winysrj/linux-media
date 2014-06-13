Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44541 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaFMQJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 26/30] [media] coda: add bytesperline to queue data
Date: Fri, 13 Jun 2014 18:08:52 +0200
Message-Id: <1402675736-15379-27-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bytesperline is calculated in multiple places, store it in the coda_q_data
structure. This will be more useful later when adding JPEG support.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index e71898e..0697436 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -119,6 +119,7 @@ struct coda_devtype {
 struct coda_q_data {
 	unsigned int		width;
 	unsigned int		height;
+	unsigned int		bytesperline;
 	unsigned int		sizeimage;
 	unsigned int		fourcc;
 	struct v4l2_rect	rect;
@@ -640,10 +641,7 @@ static int coda_g_fmt(struct file *file, void *priv,
 	f->fmt.pix.pixelformat	= q_data->fourcc;
 	f->fmt.pix.width	= q_data->width;
 	f->fmt.pix.height	= q_data->height;
-	if (coda_format_is_yuv(f->fmt.pix.pixelformat))
-		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
-	else /* encoded formats h.264/mpeg4 */
-		f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.bytesperline = q_data->bytesperline;
 
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
 	f->fmt.pix.colorspace	= ctx->colorspace;
@@ -791,6 +789,7 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	q_data->fourcc = f->fmt.pix.pixelformat;
 	q_data->width = f->fmt.pix.width;
 	q_data->height = f->fmt.pix.height;
+	q_data->bytesperline = f->fmt.pix.bytesperline;
 	q_data->sizeimage = f->fmt.pix.sizeimage;
 	q_data->rect.left = 0;
 	q_data->rect.top = 0;
@@ -1403,14 +1402,16 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 	switch (q_data_src->fourcc) {
 	case V4L2_PIX_FMT_YVU420:
 		/* Switch Cb and Cr for YVU420 format */
-		picture_cr = picture_y + q_data_src->width * q_data_src->height;
-		picture_cb = picture_cr + q_data_src->width / 2 *
+		picture_cr = picture_y + q_data_src->bytesperline *
+				q_data_src->height;
+		picture_cb = picture_cr + q_data_src->bytesperline / 2 *
 				q_data_src->height / 2;
 		break;
 	case V4L2_PIX_FMT_YUV420:
 	default:
-		picture_cb = picture_y + q_data_src->width * q_data_src->height;
-		picture_cr = picture_cb + q_data_src->width / 2 *
+		picture_cb = picture_y + q_data_src->bytesperline *
+				q_data_src->height;
+		picture_cr = picture_cb + q_data_src->bytesperline / 2 *
 				q_data_src->height / 2;
 		break;
 	}
@@ -2587,10 +2588,12 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
-	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
-	if (dev->devtype->product == CODA_7541)
-		coda_write(dev, round_up(q_data_src->width, 8),
+	coda_write(dev, q_data_src->bytesperline,
+			CODA_CMD_SET_FRAME_BUF_STRIDE);
+	if (dev->devtype->product == CODA_7541) {
+		coda_write(dev, q_data_src->bytesperline,
 				CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
+	}
 	if (dev->devtype->product != CODA_DX6) {
 		coda_write(dev, ctx->iram_info.buf_bit_use,
 				CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
-- 
2.0.0.rc2

