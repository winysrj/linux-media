Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:36197 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165928AbeBOR4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:56:12 -0500
Received: by mail-pl0-f65.google.com with SMTP id v3so248066plg.3
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 09:56:12 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v13 1/8] v4l2-dv-timings: add v4l2_hdmi_colorimetry()
Date: Thu, 15 Feb 2018 09:55:29 -0800
Message-Id: <1518717336-6271-2-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518717336-6271-1-git-send-email-tharvey@gateworks.com>
References: <1518717336-6271-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Add the v4l2_hdmi_colorimetry() function so we have a single function
that determines the colorspace, YCbCr encoding, quantization range and
transfer function from the InfoFrame data.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
v9:
 - fix kernel-doc format (Randy)

 drivers/media/v4l2-core/v4l2-dv-timings.c | 141 ++++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           |  21 +++++
 2 files changed, 162 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 930f9c5..5663d86 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -27,6 +27,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
 #include <linux/math64.h>
+#include <linux/hdmi.h>
 
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
@@ -814,3 +815,143 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 	return aspect;
 }
 EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
+
+/** v4l2_hdmi_rx_colorimetry - determine HDMI colorimetry information
+ *	based on various InfoFrames.
+ * @avi: the AVI InfoFrame
+ * @hdmi: the HDMI Vendor InfoFrame, may be NULL
+ * @height: the frame height
+ *
+ * Determines the HDMI colorimetry information, i.e. how the HDMI
+ * pixel color data should be interpreted.
+ *
+ * Note that some of the newer features (DCI-P3, HDR) are not yet
+ * implemented: the hdmi.h header needs to be updated to the HDMI 2.0
+ * and CTA-861-G standards.
+ */
+struct v4l2_hdmi_colorimetry
+v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
+			 const struct hdmi_vendor_infoframe *hdmi,
+			 unsigned int height)
+{
+	struct v4l2_hdmi_colorimetry c = {
+		V4L2_COLORSPACE_SRGB,
+		V4L2_YCBCR_ENC_DEFAULT,
+		V4L2_QUANTIZATION_FULL_RANGE,
+		V4L2_XFER_FUNC_SRGB
+	};
+	bool is_ce = avi->video_code || (hdmi && hdmi->vic);
+	bool is_sdtv = height <= 576;
+	bool default_is_lim_range_rgb = avi->video_code > 1;
+
+	switch (avi->colorspace) {
+	case HDMI_COLORSPACE_RGB:
+		/* RGB pixel encoding */
+		switch (avi->colorimetry) {
+		case HDMI_COLORIMETRY_EXTENDED:
+			switch (avi->extended_colorimetry) {
+			case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB:
+				c.colorspace = V4L2_COLORSPACE_ADOBERGB;
+				c.xfer_func = V4L2_XFER_FUNC_ADOBERGB;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_BT2020:
+				c.colorspace = V4L2_COLORSPACE_BT2020;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			default:
+				break;
+			}
+			break;
+		default:
+			break;
+		}
+		switch (avi->quantization_range) {
+		case HDMI_QUANTIZATION_RANGE_LIMITED:
+			c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			break;
+		case HDMI_QUANTIZATION_RANGE_FULL:
+			break;
+		default:
+			if (default_is_lim_range_rgb)
+				c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
+			break;
+		}
+		break;
+
+	default:
+		/* YCbCr pixel encoding */
+		c.quantization = V4L2_QUANTIZATION_LIM_RANGE;
+		switch (avi->colorimetry) {
+		case HDMI_COLORIMETRY_NONE:
+			if (!is_ce)
+				break;
+			if (is_sdtv) {
+				c.colorspace = V4L2_COLORSPACE_SMPTE170M;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
+			} else {
+				c.colorspace = V4L2_COLORSPACE_REC709;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_709;
+			}
+			c.xfer_func = V4L2_XFER_FUNC_709;
+			break;
+		case HDMI_COLORIMETRY_ITU_601:
+			c.colorspace = V4L2_COLORSPACE_SMPTE170M;
+			c.ycbcr_enc = V4L2_YCBCR_ENC_601;
+			c.xfer_func = V4L2_XFER_FUNC_709;
+			break;
+		case HDMI_COLORIMETRY_ITU_709:
+			c.colorspace = V4L2_COLORSPACE_REC709;
+			c.ycbcr_enc = V4L2_YCBCR_ENC_709;
+			c.xfer_func = V4L2_XFER_FUNC_709;
+			break;
+		case HDMI_COLORIMETRY_EXTENDED:
+			switch (avi->extended_colorimetry) {
+			case HDMI_EXTENDED_COLORIMETRY_XV_YCC_601:
+				c.colorspace = V4L2_COLORSPACE_REC709;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_XV709;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_XV_YCC_709:
+				c.colorspace = V4L2_COLORSPACE_REC709;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_XV601;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_S_YCC_601:
+				c.colorspace = V4L2_COLORSPACE_SRGB;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
+				c.xfer_func = V4L2_XFER_FUNC_SRGB;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601:
+				c.colorspace = V4L2_COLORSPACE_ADOBERGB;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
+				c.xfer_func = V4L2_XFER_FUNC_ADOBERGB;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_BT2020:
+				c.colorspace = V4L2_COLORSPACE_BT2020;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_BT2020;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			case HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM:
+				c.colorspace = V4L2_COLORSPACE_BT2020;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_BT2020_CONST_LUM;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			default: /* fall back to ITU_709 */
+				c.colorspace = V4L2_COLORSPACE_REC709;
+				c.ycbcr_enc = V4L2_YCBCR_ENC_709;
+				c.xfer_func = V4L2_XFER_FUNC_709;
+				break;
+			}
+			break;
+		default:
+			break;
+		}
+		/*
+		 * YCC Quantization Range signaling is more-or-less broken,
+		 * let's just ignore this.
+		 */
+		break;
+	}
+	return c;
+}
+EXPORT_SYMBOL_GPL(v4l2_hdmi_rx_colorimetry);
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 61a1889..835aef7 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -223,5 +223,26 @@ static inline  bool can_reduce_fps(struct v4l2_bt_timings *bt)
 	return false;
 }
 
+/**
+ * struct v4l2_hdmi_rx_colorimetry - describes the HDMI colorimetry information
+ * @colorspace:		enum v4l2_colorspace, the colorspace
+ * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
+ * @quantization:	enum v4l2_quantization, colorspace quantization
+ * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
+ */
+struct v4l2_hdmi_colorimetry {
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+	enum v4l2_xfer_func xfer_func;
+};
+
+struct hdmi_avi_infoframe;
+struct hdmi_vendor_infoframe;
+
+struct v4l2_hdmi_colorimetry
+v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
+			 const struct hdmi_vendor_infoframe *hdmi,
+			 unsigned int height);
 
 #endif
-- 
2.7.4
