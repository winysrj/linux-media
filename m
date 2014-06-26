Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45514 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaFZBHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:17 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so2427955pab.36
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:17 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 03/28] gpu: ipu-v3: Add functions to set CSI/IC source muxes
Date: Wed, 25 Jun 2014 18:05:30 -0700
Message-Id: <1403744755-24944-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds two new functions, ipu_set_csi_src_mux() and ipu_set_ic_src_mux(),
that select the inputs to the CSI and IC respectively. Both muxes are
programmed in the IPU_CONF register.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   51 +++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    2 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index a92f48b..1155eb9 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -832,6 +832,57 @@ static int ipu_memory_reset(struct ipu_soc *ipu)
 	return 0;
 }
 
+/*
+ * Set the source mux for the given CSI. Selects either parallel or
+ * MIPI CSI2 sources.
+ */
+void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2)
+{
+	unsigned long flags;
+	u32 val, mask;
+
+	mask = (csi_id == 1) ? IPU_CONF_CSI1_DATA_SOURCE :
+		IPU_CONF_CSI0_DATA_SOURCE;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	val = ipu_cm_read(ipu, IPU_CONF);
+	if (mipi_csi2)
+		val |= mask;
+	else
+		val &= ~mask;
+	ipu_cm_write(ipu, val, IPU_CONF);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_set_csi_src_mux);
+
+/*
+ * Set the source mux for the IC. Selects either CSI[01] or the VDI.
+ */
+void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	val = ipu_cm_read(ipu, IPU_CONF);
+	if (vdi) {
+		val |= IPU_CONF_IC_INPUT;
+	} else {
+		val &= ~IPU_CONF_IC_INPUT;
+		if (csi_id == 1)
+			val |= IPU_CONF_CSI_SEL;
+		else
+			val &= ~IPU_CONF_CSI_SEL;
+	}
+	ipu_cm_write(ipu, val, IPU_CONF);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_set_ic_src_mux);
+
 struct ipu_devtype {
 	const char *name;
 	unsigned long cm_ofs;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 739d204..52fa277 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -96,6 +96,8 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
  * IPU Common functions
  */
 int ipu_get_num(struct ipu_soc *ipu);
+void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
+void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
 
 /*
  * IPU Image DMA Controller (idmac) functions
-- 
1.7.9.5

