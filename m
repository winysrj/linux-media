Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36921 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753961AbdFMThC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 15:37:02 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 06/11] [media] vimc: common: Add vimc_colorimetry_clamp
Date: Tue, 13 Jun 2017 16:35:34 -0300
Message-Id: <1497382545-16408-7-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
References: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Colorimetry value will always be checked in the same way. Adding a
helper macro for that

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v4:
[media] vimc: common: Add vimc_colorimetry_clamp
	- this is a new patch in the series

Changes in v3: None
Changes in v2: None


---
 drivers/media/platform/vimc/vimc-common.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 60ebde2..43483ee 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -23,6 +23,32 @@
 #include <media/v4l2-device.h>
 
 /**
+ * struct vimc_colorimetry_clamp - Adjust colorimetry parameters
+ *
+ * @fmt:		the pointer to struct v4l2_pix_format or
+ *			struct v4l2_mbus_framefmt
+ *
+ * Entities must check if colorimetry given by the userspace is valid, if not
+ * then set them as DEFAULT
+ */
+#define vimc_colorimetry_clamp(fmt)					\
+do {									\
+	if ((fmt)->colorspace == V4L2_COLORSPACE_DEFAULT		\
+	    || (fmt)->colorspace > V4L2_COLORSPACE_DCI_P3) {		\
+		(fmt)->colorspace = V4L2_COLORSPACE_DEFAULT;		\
+		(fmt)->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;		\
+		(fmt)->quantization = V4L2_QUANTIZATION_DEFAULT;	\
+		(fmt)->xfer_func = V4L2_XFER_FUNC_DEFAULT;		\
+	}								\
+	if ((fmt)->ycbcr_enc > V4L2_YCBCR_ENC_SMPTE240M)		\
+		(fmt)->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;		\
+	if ((fmt)->quantization > V4L2_QUANTIZATION_LIM_RANGE)		\
+		(fmt)->quantization = V4L2_QUANTIZATION_DEFAULT;	\
+	if ((fmt)->xfer_func > V4L2_XFER_FUNC_SMPTE2084)		\
+		(fmt)->xfer_func = V4L2_XFER_FUNC_DEFAULT;		\
+} while (0)
+
+/**
  * struct vimc_pix_map - maps media bus code with v4l2 pixel format
  *
  * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
-- 
2.7.4
