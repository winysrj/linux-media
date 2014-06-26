Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62229 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbaFZBHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:22 -0400
Received: by mail-pb0-f41.google.com with SMTP id ma3so2402072pbc.14
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:22 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 09/28] gpu: ipu-v3: Add ipu_mbus_code_to_colorspace()
Date: Wed, 25 Jun 2014 18:05:36 -0700
Message-Id: <1403744755-24944-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ipu_mbus_code_to_colorspace() to find ipu_color_space from a
media bus pixel format code.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   13 +++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 85220ae..579f03c 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index e69b247..91aeb65 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -447,6 +447,7 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
+enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
 
 static inline void ipu_cpmem_set_burstsize(struct ipu_ch_param __iomem *p,
 		int burstsize)
-- 
1.7.9.5

