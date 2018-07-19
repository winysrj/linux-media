Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42329 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbeGSLZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 07:25:23 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH] media: coda: let CODA960 firmware set frame cropping in SPS header
Date: Thu, 19 Jul 2018 12:42:28 +0200
Message-Id: <20180719104228.32311-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When encoding h.264, if visible resolution is not aligned to macroblock
size, frame cropping has to be set in the SPS header to produce correct
streams. The CODA960 firmware can do this on its own if asked to.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 529fc187ccfd..c255c8e9db52 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -536,6 +536,8 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 {
 	struct vb2_buffer *vb = &buf->vb2_buf;
 	struct coda_dev *dev = ctx->dev;
+	struct coda_q_data *q_data_src;
+	struct v4l2_rect *r;
 	size_t bufsize;
 	int ret;
 	int i;
@@ -549,6 +551,23 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 	if (dev->devtype->product == CODA_960)
 		bufsize /= 1024;
 	coda_write(dev, bufsize, CODA_CMD_ENC_HEADER_BB_SIZE);
+	if (dev->devtype->product == CODA_960 &&
+	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264 &&
+	    header_code == CODA_HEADER_H264_SPS) {
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		r = &q_data_src->rect;
+
+		if (r->width % 16 || r->height % 16) {
+			u32 crop_right = round_up(r->width, 16) -  r->width;
+			u32 crop_bottom = round_up(r->height, 16) - r->height;
+
+			coda_write(dev, crop_right,
+				   CODA9_CMD_ENC_HEADER_FRAME_CROP_H);
+			coda_write(dev, crop_bottom,
+				   CODA9_CMD_ENC_HEADER_FRAME_CROP_V);
+			header_code |= CODA9_HEADER_FRAME_CROP;
+		}
+	}
 	coda_write(dev, header_code, CODA_CMD_ENC_HEADER_CODE);
 	ret = coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER);
 	if (ret < 0) {
-- 
2.18.0
