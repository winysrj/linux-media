Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60456 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFGV5J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:09 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so3805935pdj.6
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:09 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 09/43] imx-drm: ipu-v3: Add ipu_mbus_code_to_colorspace()
Date: Sat,  7 Jun 2014 14:56:11 -0700
Message-Id: <1402178205-22697-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ipu_mbus_code_to_colorspace() to find ipu_color_space from a
media bus pixel format code.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   13 +++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 3d7e28d..9c29e19 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -551,6 +551,19 @@ enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 }
 EXPORT_SYMBOL_GPL(ipu_pixelformat_to_colorspace);
 
+enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code)
+{
+	switch (mbus_code & 0xf000) {
+	case 0x1000:
+		return IPUV3_COLORSPACE_RGB;
+	case 0x2000:
+		return IPUV3_COLORSPACE_YUV;
+	default:
+		return IPUV3_COLORSPACE_UNKNOWN;
+	}
+}
+EXPORT_SYMBOL_GPL(ipu_mbus_code_to_colorspace);
+
 struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned num)
 {
 	struct ipuv3_channel *channel;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index b4bc549..21226a2 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -466,6 +466,7 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
+enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
 
 static inline void ipu_cpmem_set_burstsize(struct ipu_ch_param __iomem *p,
 		int burstsize)
-- 
1.7.9.5

