Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 14/21] [media] coda: don't ever use subsampling ping-pong buffers as reconstructed reference buffers
Date: Fri, 23 Jan 2015 17:51:28 +0100
Message-Id: <1422031895-7740-15-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On i.MX6, two subsampling ping-pong buffers are used for motion estimation and
deblocking They should not be counted as framebuffers, or they will be also used
to store reconstructed frames, causing visible artifacts in P-frames.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 6ecfd29..7cdddd5 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -718,6 +718,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	struct vb2_buffer *buf;
 	int gamma, ret, value;
 	u32 dst_fourcc;
+	int num_fb;
 	u32 stride;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -983,12 +984,14 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
 			goto out;
 		}
+		num_fb = 2;
 		stride = q_data_src->bytesperline;
 	} else {
 		ctx->num_internal_frames = 0;
+		num_fb = 0;
 		stride = 0;
 	}
-	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
+	coda_write(dev, num_fb, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, stride, CODA_CMD_SET_FRAME_BUF_STRIDE);
 
 	if (dev->devtype->product == CODA_7541) {
-- 
2.1.4

