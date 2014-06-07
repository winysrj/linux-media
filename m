Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46513 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFGV5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:06 -0400
Received: by mail-pb0-f42.google.com with SMTP id md12so3915221pbc.1
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:06 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 06/43] imx-drm: ipu-v3: Add functions to set CSI/IC source muxes
Date: Sat,  7 Jun 2014 14:56:08 -0700
Message-Id: <1402178205-22697-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds two new functions, ipu_set_csi_src_mux() and ipu_set_ic_src_mux(),
that select the inputs to the CSI and IC respectively. Both muxes are
programmed in the IPU_CONF register.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   51 +++++++++++++++++++++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |    3 ++
 2 files changed, 54 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 635dafe..1c606b5 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -777,6 +777,57 @@ static int ipu_memory_reset(struct ipu_soc *ipu)
 	return 0;
 }
 
+/*
+ * Set the source mux for the given CSI. Selects either parallel or
+ * MIPI CSI2 sources. This is not exported because it is used only
+ * by ipu.
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
+
+/*
+ * Set the source mux for the IC. Selects either CSI[01] or the VDI.
+ * This is not exported because it is used only by ipu.
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
+
 struct ipu_devtype {
 	const char *name;
 	unsigned long cm_ofs;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 90c0c50..69d99b0 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -190,6 +190,9 @@ void ipu_srm_dp_sync_update(struct ipu_soc *ipu);
 int ipu_module_enable(struct ipu_soc *ipu, u32 mask);
 int ipu_module_disable(struct ipu_soc *ipu, u32 mask);
 
+void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
+void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
+
 int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
 		unsigned long base, u32 module, struct clk *ipu_clk);
 void ipu_di_exit(struct ipu_soc *ipu, int id);
-- 
1.7.9.5

