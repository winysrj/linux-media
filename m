Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:36030 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdGQKe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:34:59 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 02/23] [media] v4l2-mediabus: Add helper functions
Date: Mon, 17 Jul 2017 13:33:28 +0300
Message-Id: <1500287629-23703-3-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions for mbus to/from mplane pixel format conversion.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 include/media/v4l2-mediabus.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e..125afcd 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -113,4 +113,30 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 	mbus_fmt->code = code;
 }
 
+static inline void v4l2_fill_pix_format_mplane(
+				struct v4l2_pix_format_mplane *pix_mp_fmt,
+				const struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	pix_mp_fmt->width = mbus_fmt->width;
+	pix_mp_fmt->height = mbus_fmt->height;
+	pix_mp_fmt->field = mbus_fmt->field;
+	pix_mp_fmt->colorspace = mbus_fmt->colorspace;
+	pix_mp_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
+	pix_mp_fmt->quantization = mbus_fmt->quantization;
+	pix_mp_fmt->xfer_func = mbus_fmt->xfer_func;
+}
+
+static inline void v4l2_fill_mbus_format_mplane(
+				struct v4l2_mbus_framefmt *mbus_fmt,
+				const struct v4l2_pix_format_mplane *pix_mp_fmt)
+{
+	mbus_fmt->width = pix_mp_fmt->width;
+	mbus_fmt->height = pix_mp_fmt->height;
+	mbus_fmt->field = pix_mp_fmt->field;
+	mbus_fmt->colorspace = pix_mp_fmt->colorspace;
+	mbus_fmt->ycbcr_enc = pix_mp_fmt->ycbcr_enc;
+	mbus_fmt->quantization = pix_mp_fmt->quantization;
+	mbus_fmt->xfer_func = pix_mp_fmt->xfer_func;
+}
+
 #endif
-- 
2.7.4
