Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38057 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbaGYPJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 11:09:15 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/11] [media] coda: skip calling coda_find_codec in encoder try_fmt_vid_out
Date: Fri, 25 Jul 2014 17:08:33 +0200
Message-Id: <1406300917-18169-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
References: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We know that it will return NULL in this case, so we can just as well
skip it altogether.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c84634b..c38c8bd 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -426,15 +426,16 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	const struct coda_codec *codec;
+	const struct coda_codec *codec = NULL;
 
 	/* Determine codec by encoded format, returns NULL if raw or invalid */
-	codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
-				V4L2_PIX_FMT_YUV420);
-	if (!codec && ctx->inst_type == CODA_INST_DECODER) {
-		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_H264,
+	if (ctx->inst_type == CODA_INST_DECODER) {
+		codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
 					V4L2_PIX_FMT_YUV420);
 		if (!codec)
+			codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_H264,
+						V4L2_PIX_FMT_YUV420);
+		if (!codec)
 			return -EINVAL;
 	}
 
-- 
2.0.1

