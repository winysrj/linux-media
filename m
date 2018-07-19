Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54897 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732166AbeGSQOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 12:14:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v2 13/16] gpu: ipu-v3: image-convert: fix bytesperline adjustment
Date: Thu, 19 Jul 2018 17:30:39 +0200
Message-Id: <20180719153042.533-14-p.zabel@pengutronix.de>
In-Reply-To: <20180719153042.533-1-p.zabel@pengutronix.de>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For planar formats, bytesperline does not depend on BPP. It must always
be larger than width and aligned to tile width alignment restrictions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index a8d7939d58d9..a0d9c154c951 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1863,10 +1863,19 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
 
 	/* set input/output strides and image sizes */
-	in->pix.bytesperline = (in->pix.width * infmt->bpp) >> 3;
-	in->pix.sizeimage = in->pix.height * in->pix.bytesperline;
-	out->pix.bytesperline = (out->pix.width * outfmt->bpp) >> 3;
-	out->pix.sizeimage = out->pix.height * out->pix.bytesperline;
+	in->pix.bytesperline = infmt->planar ?
+		clamp_align(in->pix.width,
+			    in->pix.bytesperline, MAX_W, w_align) :
+		clamp_align((in->pix.width * infmt->bpp) >> 3,
+			    in->pix.bytesperline, MAX_W, w_align);
+	in->pix.sizeimage = infmt->planar ?
+		(in->pix.height * in->pix.bytesperline * infmt->bpp) >> 3 :
+		in->pix.height * in->pix.bytesperline;
+	out->pix.bytesperline = outfmt->planar ? out->pix.width :
+		(out->pix.width * outfmt->bpp) >> 3;
+	out->pix.sizeimage = outfmt->planar ?
+		(out->pix.height * out->pix.bytesperline * outfmt->bpp) >> 3 :
+		out->pix.height * out->pix.bytesperline;
 }
 EXPORT_SYMBOL_GPL(ipu_image_convert_adjust);
 
-- 
2.18.0
