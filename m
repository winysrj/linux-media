Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33439 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbcFNWvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:07 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so306098pfb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:06 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 03/38] gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
Date: Tue, 14 Jun 2016 15:48:59 -0700
Message-Id: <1465944574-15745-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_get_burstsize().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 6 ++++++
 include/video/imx-ipu-v3.h     | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index a36c35e..fcb7dc8 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -275,6 +275,12 @@ void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id)
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_axi_id);
 
+int ipu_cpmem_get_burstsize(struct ipuv3_channel *ch)
+{
+	return ipu_ch_param_read_field(ch, IPU_FIELD_NPB) + 1;
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_get_burstsize);
+
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize)
 {
 	ipu_ch_param_write_field(ch, IPU_FIELD_NPB, burstsize - 1);
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 904fd12..60540ead 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -197,6 +197,7 @@ void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off);
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
+int ipu_cpmem_get_burstsize(struct ipuv3_channel *ch);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
 void ipu_cpmem_set_block_mode(struct ipuv3_channel *ch);
 void ipu_cpmem_set_rotation(struct ipuv3_channel *ch,
-- 
1.9.1

