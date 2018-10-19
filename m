Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40417 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbeJSUVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 19/22] gpu: ipu-v3: image-convert: fix bytesperline adjustment
Date: Fri, 19 Oct 2018 14:15:36 +0200
Message-Id: <20181019121539.12778-20-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For planar formats, bytesperline does not depend on BPP. It must always
be larger than width and aligned to tile width alignment restrictions.

The input bytesperline to ipu_image_convert_adjust() may be
uninitialized, so don't rely on input bytesperline as the
minimum value for clamp_align(). Use 2 << w_align as the minimum
instead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[slongerbeam@gmail.com: clamp input bytesperline]
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 0829723a7599..b735065fe288 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1915,10 +1915,18 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
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
