Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42548 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbeIMQ4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:56:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 3/5] hdmi.h: rename ADOBE_RGB to OPRGB and ADOBE_YCC to OPYCC
Date: Thu, 13 Sep 2018 13:47:29 +0200
Message-Id: <20180913114731.16500-4-hverkuil@xs4all.nl>
In-Reply-To: <20180913114731.16500-1-hverkuil@xs4all.nl>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

These names have been renamed in the CTA-861 standard due to trademark
issues. Replace them here as well so they are in sync with the standard.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/i2c/adv7511.c               | 4 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++--
 drivers/video/hdmi.c                      | 8 ++++----
 include/linux/hdmi.h                      | 4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index a1f73d998495..f3899cc84e27 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1357,8 +1357,8 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	switch (format->format.colorspace) {
 	case V4L2_COLORSPACE_OPRGB:
 		c = HDMI_COLORIMETRY_EXTENDED;
-		ec = y ? HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601 :
-			 HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB;
+		ec = y ? HDMI_EXTENDED_COLORIMETRY_OPYCC_601 :
+			 HDMI_EXTENDED_COLORIMETRY_OPRGB;
 		break;
 	case V4L2_COLORSPACE_SMPTE170M:
 		c = y ? HDMI_COLORIMETRY_ITU_601 : HDMI_COLORIMETRY_NONE;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index facd180870d9..4e4bfb33adbe 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -876,7 +876,7 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 		switch (avi->colorimetry) {
 		case HDMI_COLORIMETRY_EXTENDED:
 			switch (avi->extended_colorimetry) {
-			case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB:
+			case HDMI_EXTENDED_COLORIMETRY_OPRGB:
 				c.colorspace = V4L2_COLORSPACE_OPRGB;
 				c.xfer_func = V4L2_XFER_FUNC_OPRGB;
 				break;
@@ -947,7 +947,7 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
 				c.xfer_func = V4L2_XFER_FUNC_SRGB;
 				break;
-			case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601:
+			case HDMI_EXTENDED_COLORIMETRY_OPYCC_601:
 				c.colorspace = V4L2_COLORSPACE_OPRGB;
 				c.ycbcr_enc = V4L2_YCBCR_ENC_601;
 				c.xfer_func = V4L2_XFER_FUNC_OPRGB;
diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 38716eb50408..8a3e8f61b991 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -592,10 +592,10 @@ hdmi_extended_colorimetry_get_name(enum hdmi_extended_colorimetry ext_col)
 		return "xvYCC 709";
 	case HDMI_EXTENDED_COLORIMETRY_S_YCC_601:
 		return "sYCC 601";
-	case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601:
-		return "Adobe YCC 601";
-	case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB:
-		return "Adobe RGB";
+	case HDMI_EXTENDED_COLORIMETRY_OPYCC_601:
+		return "opYCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_OPRGB:
+		return "opRGB";
 	case HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM:
 		return "BT.2020 Constant Luminance";
 	case HDMI_EXTENDED_COLORIMETRY_BT2020:
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index d271ff23984f..4f3febc0f971 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -101,8 +101,8 @@ enum hdmi_extended_colorimetry {
 	HDMI_EXTENDED_COLORIMETRY_XV_YCC_601,
 	HDMI_EXTENDED_COLORIMETRY_XV_YCC_709,
 	HDMI_EXTENDED_COLORIMETRY_S_YCC_601,
-	HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601,
-	HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB,
+	HDMI_EXTENDED_COLORIMETRY_OPYCC_601,
+	HDMI_EXTENDED_COLORIMETRY_OPRGB,
 
 	/* The following EC values are only defined in CEA-861-F. */
 	HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM,
-- 
2.18.0
