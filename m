Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35583 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbcFNWvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:09 -0400
Received: by mail-pf0-f196.google.com with SMTP id t190so301570pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:08 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 06/38] gpu: ipu-v3: Add ipu_set_vdi_src_mux()
Date: Tue, 14 Jun 2016 15:49:02 -0700
Message-Id: <1465944574-15745-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_set_vdi_src_mux() that selects the VDIC input
(from CSI or memory).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 20 ++++++++++++++++++++
 include/video/imx-ipu-v3.h      |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 6d1676e..374100e 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -730,6 +730,26 @@ void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi)
 }
 EXPORT_SYMBOL_GPL(ipu_set_ic_src_mux);
 
+/*
+ * Set the source for the VDIC. Selects either from CSI[01] or memory.
+ */
+void ipu_set_vdi_src_mux(struct ipu_soc *ipu, bool csi)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	val = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	val &= ~(0x3 << 28);
+	if (csi)
+		val |= (0x01 << 28);
+	ipu_cm_write(ipu, val, IPU_FS_PROC_FLOW1);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_set_vdi_src_mux);
+
 
 /* IDMAC Channel Linking */
 
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 0a39c64..586979e 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -152,6 +152,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 int ipu_get_num(struct ipu_soc *ipu);
 void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
 void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
+void ipu_set_vdi_src_mux(struct ipu_soc *ipu, bool csi);
 void ipu_dump(struct ipu_soc *ipu);
 
 /*
-- 
1.9.1

