Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34137 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaJBRJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:09:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 04/10] [media] coda: split out encoder control setup to specify controls per video device
Date: Thu,  2 Oct 2014 19:08:29 +0200
Message-Id: <1412269715-28388-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
References: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch splits the encoder specific controls out of the main control setup
function. This way each video device registers only relevant controls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Kept both H.264 and MPEG4 v4l2 controls for bitstream encoder device
---
 drivers/media/platform/coda/coda-common.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 45db1da..7fc0dc0 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1334,14 +1334,8 @@ static const struct v4l2_ctrl_ops coda_ctrl_ops = {
 	.s_ctrl = coda_s_ctrl,
 };
 
-static int coda_ctrls_setup(struct coda_ctx *ctx)
+static void coda_encode_ctrls(struct coda_ctx *ctx)
 {
-	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
-
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_HFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
@@ -1385,6 +1379,18 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0,
 		1920 * 1088 / 256, 1, 0);
+}
+
+static int coda_ctrls_setup(struct coda_ctx *ctx)
+{
+	v4l2_ctrl_handler_init(&ctx->ctrls, 2);
+
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_VFLIP, 0, 1, 1, 0);
+	if (ctx->inst_type == CODA_INST_ENCODER)
+		coda_encode_ctrls(ctx);
 
 	if (ctx->ctrls.error) {
 		v4l2_err(&ctx->dev->v4l2_dev,
-- 
2.1.0

