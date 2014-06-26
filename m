Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38251 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbaFZBHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:23 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so2431218pac.33
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 10/28] gpu: ipu-v3: Add rotation mode conversion utilities
Date: Wed, 25 Jun 2014 18:05:37 -0700
Message-Id: <1403744755-24944-11-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two functions:

- ipu_degrees_to_rot_mode(): converts a degrees, hflip, and vflip setting
  to an IPU rotation mode.
- ipu_rot_mode_to_degrees(): converts an IPU rotation mode with given hflip
  and vflip settings to degrees.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   64 +++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    4 +++
 2 files changed, 68 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 579f03c..d472b27 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 91aeb65..99cf370 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -448,6 +448,10 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
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

