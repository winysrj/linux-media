Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42486 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaFGV5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:10 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so3912858pbb.3
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:10 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 10/43] imx-drm: ipu-v3: Add rotation mode conversion utilities
Date: Sat,  7 Jun 2014 14:56:12 -0700
Message-Id: <1402178205-22697-11-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two functions:

- ipu_degrees_to_rot_mode(): converts a degrees, hflip, and vflip setting
  to an IPU rotation mode.
- ipu_rot_mode_to_degrees(): converts an IPU rotation mode with given hflip
  and vflip settings to degrees.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   64 +++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    4 ++
 2 files changed, 68 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 9c29e19..02577cc 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -564,6 +564,70 @@ enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code)
 }
 EXPORT_SYMBOL_GPL(ipu_mbus_code_to_colorspace);
 
+int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
+			    bool hflip, bool vflip)
+{
+	u32 r90, vf, hf;
+
+	switch (degrees) {
+	case 0:
+		vf = hf = r90 = 0;
+		break;
+	case 90:
+		vf = hf = 0;
+		r90 = 1;
+		break;
+	case 180:
+		vf = hf = 1;
+		r90 = 0;
+		break;
+	case 270:
+		vf = hf = r90 = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hf ^= (u32)hflip;
+	vf ^= (u32)vflip;
+
+	*mode = (enum ipu_rotate_mode)((r90 << 2) | (hf << 1) | vf);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_degrees_to_rot_mode);
+
+int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
+			    bool hflip, bool vflip)
+{
+	u32 r90, vf, hf;
+
+	r90 = ((u32)mode >> 2) & 0x1;
+	hf = ((u32)mode >> 1) & 0x1;
+	vf = ((u32)mode >> 0) & 0x1;
+	hf ^= (u32)hflip;
+	vf ^= (u32)vflip;
+
+	switch ((enum ipu_rotate_mode)((r90 << 2) | (hf << 1) | vf)) {
+	case IPU_ROTATE_NONE:
+		*degrees = 0;
+		break;
+	case IPU_ROTATE_90_RIGHT:
+		*degrees = 90;
+		break;
+	case IPU_ROTATE_180:
+		*degrees = 180;
+		break;
+	case IPU_ROTATE_90_LEFT:
+		*degrees = 270;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_rot_mode_to_degrees);
+
 struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned num)
 {
 	struct ipuv3_channel *channel;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 21226a2..ffcfe20 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -467,6 +467,10 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
 enum ipu_color_space ipu_mbus_code_to_colorspace(u32 mbus_code);
+int ipu_degrees_to_rot_mode(enum ipu_rotate_mode *mode, int degrees,
+			    bool hflip, bool vflip);
+int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
+			    bool hflip, bool vflip);
 
 static inline void ipu_cpmem_set_burstsize(struct ipu_ch_param __iomem *p,
 		int burstsize)
-- 
1.7.9.5

