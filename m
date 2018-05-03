Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53465 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbeECQlY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 12:41:24 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de
Subject: [PATCH 1/2] media: imx: capture: refactor enum_/try_fmt
Date: Thu,  3 May 2018 18:41:19 +0200
Message-Id: <20180503164120.9912-2-jlu@pengutronix.de>
In-Reply-To: <20180503164120.9912-1-jlu@pengutronix.de>
References: <20180503164120.9912-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By checking and handling the internal IPU formats (ARGB or AYUV) first,
we don't need to check whether it's a bayer format, as we can default to
passing the input format on in all other cases.

This simplifies handling the different configurations for RGB565 between
parallel and MIPI CSI-2, as we don't need to check the details of the
format anymore.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-capture.c | 38 +++++++++----------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 0ccabe04b0e1..64c23ef92931 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -170,23 +170,22 @@ static int capture_enum_fmt_vid_cap(struct file *file, void *fh,
 	}
 
 	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
-	if (!cc_src)
-		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
-						    CS_SEL_ANY, true);
-	if (!cc_src)
-		return -EINVAL;
-
-	if (cc_src->bayer) {
-		if (f->index != 0)
-			return -EINVAL;
-		fourcc = cc_src->fourcc;
-	} else {
+	if (cc_src) {
 		u32 cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
 			CS_SEL_YUV : CS_SEL_RGB;
 
 		ret = imx_media_enum_format(&fourcc, f->index, cs_sel);
 		if (ret)
 			return ret;
+	} else {
+		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
+						    CS_SEL_ANY, true);
+		if (WARN_ON(!cc_src))
+			return -EINVAL;
+
+		if (f->index != 0)
+			return -EINVAL;
+		fourcc = cc_src->fourcc;
 	}
 
 	f->pixelformat = fourcc;
@@ -219,15 +218,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 		return ret;
 
 	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
-	if (!cc_src)
-		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
-						    CS_SEL_ANY, true);
-	if (!cc_src)
-		return -EINVAL;
-
-	if (cc_src->bayer) {
-		cc = cc_src;
-	} else {
+	if (cc_src) {
 		u32 fourcc, cs_sel;
 
 		cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
@@ -239,6 +230,13 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 			imx_media_enum_format(&fourcc, 0, cs_sel);
 			cc = imx_media_find_format(fourcc, cs_sel, false);
 		}
+	} else {
+		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
+						    CS_SEL_ANY, true);
+		if (WARN_ON(!cc_src))
+			return -EINVAL;
+
+		cc = cc_src;
 	}
 
 	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
-- 
2.17.0
