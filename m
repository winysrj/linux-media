Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34531 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934045AbeFVPwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:22 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 13/16] gpu: ipu-v3: image-convert: fix bytesperline adjustment
Date: Fri, 22 Jun 2018 17:52:14 +0200
Message-Id: <20180622155217.29302-14-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For planar formats, bytesperline does not depend on BPP. It must always
be larger than width and aligned to tile width alignment restrictions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 3eb74d41733f..43eaa512e8c2 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1858,10 +1858,19 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
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
2.17.1
