Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34663 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcFNWvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id 66so305630pfy.1
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:06 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 02/38] gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
Date: Tue, 14 Jun 2016 15:48:58 -0700
Message-Id: <1465944574-15745-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_set_uv_offset(), to set planar U/V offsets.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 7 +++++++
 include/video/imx-ipu-v3.h     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 6494a4d..a36c35e 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -253,6 +253,13 @@ void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf)
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_buffer);
 
+void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off)
+{
+	ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_off / 8);
+	ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_off / 8);
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
+
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
 {
 	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 22662a1..904fd12 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -194,6 +194,7 @@ void ipu_cpmem_set_resolution(struct ipuv3_channel *ch, int xres, int yres);
 void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
+void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
-- 
1.9.1

