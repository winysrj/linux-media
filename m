Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34178 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaFGV50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:26 -0400
Received: by mail-pd0-f178.google.com with SMTP id v10so3801989pde.23
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:26 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 25/43] imx-drm: ipu-cpmem: Add ipu_cpmem_set_rotation()
Date: Sat,  7 Jun 2014 14:56:27 -0700
Message-Id: <1402178205-22697-26-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_rotation().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c |    9 +++++++++
 include/linux/platform_data/imx-ipu-v3.h   |    2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
index 4d5a9fe..bd76a38 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -64,6 +64,7 @@ struct ipu_cpmem {
 #define IPU_FIELD_BNDM		IPU_CPMEM_WORD(0, 114, 3)
 #define IPU_FIELD_BM		IPU_CPMEM_WORD(0, 117, 2)
 #define IPU_FIELD_ROT		IPU_CPMEM_WORD(0, 119, 1)
+#define IPU_FIELD_ROT_HF_VF	IPU_CPMEM_WORD(0, 119, 3)
 #define IPU_FIELD_HF		IPU_CPMEM_WORD(0, 120, 1)
 #define IPU_FIELD_VF		IPU_CPMEM_WORD(0, 121, 1)
 #define IPU_FIELD_THE		IPU_CPMEM_WORD(0, 122, 1)
@@ -271,6 +272,14 @@ void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch)
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_block_mode);
 
+void ipu_cpmem_set_rotation(struct ipuv3_channel *ch,
+			    enum ipu_rotate_mode rot)
+{
+	u32 temp_rot = bitrev8(rot) >> 5;
+	ipu_ch_param_write_field(ch, IPU_FIELD_ROT_HF_VF, temp_rot);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_rotation);
+
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
 			     const struct ipu_rgb *rgb)
 {
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 6486217..53aab16 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -231,6 +231,8 @@ void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
 void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
+void ipu_cpmem_set_rotation(struct ipuv3_channel *ch,
+			    enum ipu_rotate_mode rot);
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
 			     const struct ipu_rgb *rgb);
 int ipu_cpmem_set_format_passthrough(struct ipuv3_channel *ch, int width);
-- 
1.7.9.5

