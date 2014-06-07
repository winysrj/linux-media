Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61510 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaFGV5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:24 -0400
Received: by mail-pd0-f176.google.com with SMTP id p10so3798443pdj.7
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:24 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 23/43] imx-drm: ipu-cpmem: Add ipu_cpmem_set_block_mode()
Date: Sat,  7 Jun 2014 14:56:25 -0700
Message-Id: <1402178205-22697-24-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_block_mode().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c |    6 ++++++
 include/linux/platform_data/imx-ipu-v3.h   |    1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
index 06471ee..c7910cc 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -258,6 +258,12 @@ void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize)
 };
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_burstsize);
 
+void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_BM, 1);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_block_mode);
+
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
 			     const struct ipu_rgb *rgb)
 {
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 91986ed..beb2e4b 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -229,6 +229,7 @@ void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
+void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
 			     const struct ipu_rgb *rgb);
 int ipu_cpmem_set_format_passthrough(struct ipuv3_channel *ch, int width);
-- 
1.7.9.5

