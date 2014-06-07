Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51257 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFGV5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:11 -0400
Received: by mail-pd0-f181.google.com with SMTP id z10so3819365pdj.12
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:11 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Subject: [PATCH 11/43] imx-drm: ipu-v3: Add helper function checking if pixfmt is planar
Date: Sat,  7 Jun 2014 14:56:13 -0700
Message-Id: <1402178205-22697-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add simple helper function returning true if passed pixel format is one
of supported planar ones.

Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   12 ++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 02577cc..d005ed5 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -551,6 +551,18 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 }
 EXPORT_SYMBOL_GPL(ipu_pixelformat_to_colorspace);
 
+bool ipu_pixelformat_is_planar(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(ipu_pixelformat_is_planar);
+
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code)
 {
 	switch (mbus_code & 0xf000) {
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index ffcfe20..dcf2c57 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -467,6 +467,7 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
+bool ipu_pixelformat_is_planar(u32 pixelformat);
 int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
 			    bool hflip, bool vflip);
 int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
-- 
1.7.9.5

