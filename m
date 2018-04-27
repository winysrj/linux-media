Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40927 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757457AbeD0QTa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 12:19:30 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Tomasz Figa <tfiga@google.com>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 3/3] media: coda: set colorimetry on coded queue
Date: Fri, 27 Apr 2018 18:19:17 +0200
Message-Id: <20180427161917.18398-3-p.zabel@pengutronix.de>
In-Reply-To: <20180427161917.18398-1-p.zabel@pengutronix.de>
References: <20180427161917.18398-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not set context colorimetry on the raw (OUTPUT) queue for encoders.
Always set colorimetry on the coded queue (CAPTURE for encoders, OUTPUT
for decoders).
This also skips propagation of capture queue format and selection
rectangle on S_FMT(OUTPUT) to the CAPTURE queue for encoders.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Added patch since v1 [1]:
 - remove automatic format propagation on S_FMT(OUT) for encoders
 - adding S_FMT(CAP) propagation from capture to output queue for
   encoders is left for a later time, this isn't even documented yet.

[1] https://patchwork.linuxtv.org/patch/48266/
---

 drivers/media/platform/coda/coda-common.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index d3e22c14fad4..c7631e117dd3 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -779,7 +779,19 @@ static int coda_s_fmt_vid_cap(struct file *file, void *priv,
 	r.width = q_data_src->width;
 	r.height = q_data_src->height;
 
-	return coda_s_fmt(ctx, f, &r);
+	ret = coda_s_fmt(ctx, f, &r);
+	if (ret)
+		return ret;
+
+	if (ctx->inst_type != CODA_INST_ENCODER)
+		return 0;
+
+	ctx->colorspace = f->fmt.pix.colorspace;
+	ctx->xfer_func = f->fmt.pix.xfer_func;
+	ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	ctx->quantization = f->fmt.pix.quantization;
+
+	return 0;
 }
 
 static int coda_s_fmt_vid_out(struct file *file, void *priv,
@@ -798,6 +810,9 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
+	if (ctx->inst_type != CODA_INST_DECODER)
+		return 0;
+
 	ctx->colorspace = f->fmt.pix.colorspace;
 	ctx->xfer_func = f->fmt.pix.xfer_func;
 	ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
-- 
2.17.0
