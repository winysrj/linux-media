Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54206 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaFZBHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:33 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so2302623pdj.8
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:33 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 22/28] gpu: ipu-cpmem: Add ipu_cpmem_set_block_mode()
Date: Wed, 25 Jun 2014 18:05:49 -0700
Message-Id: <1403744755-24944-23-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_block_mode().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c |    6 ++++++
 include/video/imx-ipu-v3.h     |    1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 7adfa78..28adf39 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -260,6 +260,12 @@ void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize)
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index a86a98a..6146bc7 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -231,6 +231,7 @@ void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
+void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
 int ipu_cpmem_set_format_rgb(struct ipuv3_channel *ch,
 			     const struct ipu_rgb *rgb);
 int ipu_cpmem_set_format_passthrough(struct ipuv3_channel *ch, int width);
-- 
1.7.9.5

