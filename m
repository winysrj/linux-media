Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:45720 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750977AbdGGIS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 04:18:28 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: hansverk@cisco.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] [media] v4l2-mediabus: Add helper functions
Date: Fri,  7 Jul 2017 11:18:07 +0300
Message-Id: <1499415487-15785-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions for mbus to/from mplane pixel format conversion.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 include/media/v4l2-mediabus.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e..f97fd4a 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -113,4 +113,30 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 	mbus_fmt->code = code;
 }
 
+static inline void v4l2_fill_pix_format_mplane(
+				struct v4l2_pix_format_mplane *pix_fmt,
+				const struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	pix_fmt->width = mbus_fmt->width;
+	pix_fmt->height = mbus_fmt->height;
+	pix_fmt->field = mbus_fmt->field;
+	pix_fmt->colorspace = mbus_fmt->colorspace;
+	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
+	pix_fmt->quantization = mbus_fmt->quantization;
+	pix_fmt->xfer_func = mbus_fmt->xfer_func;
+}
+
+static inline void v4l2_fill_mbus_format_mplane(
+				struct v4l2_mbus_framefmt *mbus_fmt,
+				const struct v4l2_pix_format_mplane *pix_fmt)
+{
+	mbus_fmt->width = pix_fmt->width;
+	mbus_fmt->height = pix_fmt->height;
+	mbus_fmt->field = pix_fmt->field;
+	mbus_fmt->colorspace = pix_fmt->colorspace;
+	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
+	mbus_fmt->quantization = pix_fmt->quantization;
+	mbus_fmt->xfer_func = pix_fmt->xfer_func;
+}
+
 #endif
-- 
1.9.1
