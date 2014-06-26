Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64330 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaFZBHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:34 -0400
Received: by mail-pb0-f41.google.com with SMTP id ma3so2402293pbc.14
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:34 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 23/28] gpu: ipu-cpmem: Add ipu_cpmem_set_axi_id()
Date: Wed, 25 Jun 2014 18:05:50 -0700
Message-Id: <1403744755-24944-24-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_axi_id() to set which AXI bus master the channel
will use to transfer data onto AXI bus.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c |    7 +++++++
 include/video/imx-ipu-v3.h     |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 28adf39..2d1b376 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -254,6 +254,13 @@ void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 6146bc7..066b10d 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -230,6 +230,7 @@ void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
+void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
 void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
-- 
1.7.9.5

