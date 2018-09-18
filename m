Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41835 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbeIRPGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:06:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v3 13/16] gpu: ipu-v3: image-convert: fix bytesperline adjustment
Date: Tue, 18 Sep 2018 11:34:18 +0200
Message-Id: <20180918093421.12930-14-p.zabel@pengutronix.de>
In-Reply-To: <20180918093421.12930-1-p.zabel@pengutronix.de>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For planar formats, bytesperline does not depend on BPP. It must always
be larger than width and aligned to tile width alignment restrictions.

The input bytesperline to ipu_image_convert_adjust() may be
uninitialized, so don't rely on input bytesperline as the
minimum value for clamp_align(). Use 2 << w_align as the minimum
instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[steve_longerbeam@mentor.com: clamp input bytesperline]
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v2:
 - clamp uninitialized input bytesperline
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index abf02b9d4b66..16d400b2b3d2 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1898,10 +1898,18 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
 
 	/* set input/output strides and image sizes */
-	in->pix.bytesperline = (in->pix.width * infmt->bpp) >> 3;
-	in->pix.sizeimage = in->pix.height * in->pix.bytesperline;
-	out->pix.bytesperline = (out->pix.width * outfmt->bpp) >> 3;
-	out->pix.sizeimage = out->pix.height * out->pix.bytesperline;
+	in->pix.bytesperline = infmt->planar ?
+		clamp_align(in->pix.width, 2 << w_align, MAX_W, w_align) :
+		clamp_align((in->pix.width * infmt->bpp) >> 3,
+			    2 << w_align, MAX_W, w_align);
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
2.19.0
