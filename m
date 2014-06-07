Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49107 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFGV5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:25 -0400
Received: by mail-pb0-f48.google.com with SMTP id rr13so3891471pbb.7
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:25 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 24/43] imx-drm: ipu-cpmem: Add ipu_cpmem_set_axi_id()
Date: Sat,  7 Jun 2014 14:56:26 -0700
Message-Id: <1402178205-22697-25-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_axi_id() to set which AXI bus master the channel
will use to transfer data onto AXI bus.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c |    7 +++++++
 include/linux/platform_data/imx-ipu-v3.h   |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
index c7910cc..4d5a9fe 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -252,6 +252,13 @@ void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
 };
 EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
 
+void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id)
+{
+	id &= 0x3;
+	ipu_ch_param_write_field(ch, IPU_FIELD_ID, id);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_axi_id);
+
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize)
 {
 	ipu_ch_param_write_field(ch, IPU_FIELD_NPB, burstsize - 1);
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index beb2e4b..6486217 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -228,6 +228,7 @@ void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
+void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
 void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
-- 
1.7.9.5

