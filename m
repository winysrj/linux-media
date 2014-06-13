Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaFMQJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/30] [media] coda: fix h.264 quantization parameter range
Date: Fri, 13 Jun 2014 18:08:29 +0200
Message-Id: <1402675736-15379-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If bitrate is not set, the encoder is running in VBR mode, with the
I- and P-frame quantization parameters configured from userspace.
For the quantization parameters, 0 is a valid value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 453ac4b..544360e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2385,9 +2385,9 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
+		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 0, 51, 1, 25);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
+		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 0, 51, 1, 25);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-- 
2.0.0.rc2

