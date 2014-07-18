Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761394AbaGRKXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:23:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 10/11] [media] coda: default to h.264 decoder on invalid formats
Date: Fri, 18 Jul 2014 12:22:44 +0200
Message-Id: <1405678965-10473-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the user provides an invalid format, let the decoder device
default to h.264.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 922c276..db859c1 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -685,7 +685,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_codec *codec;
+	struct coda_codec *codec = NULL;
 	struct vb2_queue *src_vq;
 	int ret;
 
@@ -738,6 +738,12 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	/* Determine codec by encoded format, returns NULL if raw or invalid */
 	codec = coda_find_codec(ctx->dev, f->fmt.pix.pixelformat,
 				V4L2_PIX_FMT_YUV420);
+	if (!codec && ctx->inst_type == CODA_INST_DECODER) {
+		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_H264,
+					V4L2_PIX_FMT_YUV420);
+		if (!codec)
+			return -EINVAL;
+	}
 
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
-- 
2.0.1

