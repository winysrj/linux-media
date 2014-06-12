Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 02/26] gpu: ipu-v3: Register IC with IPUv3
Date: Thu, 12 Jun 2014 19:06:16 +0200
Message-Id: <1402592800-2925-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-common.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-prv.h    |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 719788c..a4910d8 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -914,8 +914,18 @@ static int ipu_submodules_init(struct ipu_soc *ipu,
 		goto err_smfc;
 	}
 
+	ret = ipu_ic_init(ipu, dev, ipu_base + devtype->cm_ofs +
+			IPU_CM_IC_REG_OFS, ipu_base + devtype->tpm_ofs,
+			ipu_base + devtype->vdi_ofs);
+	if (ret) {
+		unit = "ic";
+		goto err_ic;
+	}
+
 	return 0;
 
+err_ic:
+	ipu_smfc_exit(ipu);
 err_smfc:
 	ipu_dp_exit(ipu);
 err_dp:
@@ -995,6 +1005,7 @@ static void ipu_submodules_exit(struct ipu_soc *ipu)
 	ipu_dc_exit(ipu);
 	ipu_di_exit(ipu, 1);
 	ipu_di_exit(ipu, 0);
+	ipu_ic_exit(ipu);
 }
 
 static int platform_remove_devices_fn(struct device *dev, void *unused)
@@ -1052,6 +1063,18 @@ static const struct ipu_platform_reg client_reg[] = {
 		},
 		.reg_offset = IPU_CM_CSI1_REG_OFS,
 		.name = "imx-ipuv3-camera",
+	}, {
+		.pdata = {
+			.dma[0] = IPUV3_CHANNEL_MEM_FG_SYNC,
+		},
+		.name = "imx-ipuv3-scaler",
+	}, {
+		.pdata = {
+			.dma[0] = IPUV3_CHANNEL_MEM_FG_SYNC,
+		},
+		.name = "imx-ipuv3-ovl",
+	}, {
+		.name = "imx-ipuv3-vdic",
 	},
 };
 
@@ -1179,6 +1202,7 @@ static int ipu_probe(struct platform_device *pdev)
 	unsigned long ipu_base;
 	int i, ret, irq_sync, irq_err;
 	const struct ipu_devtype *devtype;
+	u32 reg;
 
 	devtype = of_id->data;
 
@@ -1272,6 +1296,9 @@ static int ipu_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_failed_reset;
 
+	/* Set sync refresh channels as high priority */
+	ipu_idmac_write(ipu, 0x18800000, IDMAC_CHA_PRI(0));
+
 	/* Set MCU_T to divide MCU access window into 2 */
 	ipu_cm_write(ipu, 0x00400000L | (IPU_MCU_T_DEFAULT << 18),
 			IPU_DISP_GEN);
@@ -1280,6 +1307,14 @@ static int ipu_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_submodules_init;
 
+	reg = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	reg |= (5 << 24);
+	ipu_cm_write(ipu, reg, IPU_FS_PROC_FLOW1);
+
+	reg = ipu_cm_read(ipu, IPU_CONF);
+	reg |= IPU_CONF_IC_INPUT;
+	ipu_cm_write(ipu, reg, IPU_CONF);
+
 	ret = ipu_add_client_devices(ipu, ipu_base);
 	if (ret) {
 		dev_err(&pdev->dev, "adding client devices failed with %d\n",
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index acf1811..e869ac1 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -152,6 +152,7 @@ struct ipu_dc_priv;
 struct ipu_dmfc_priv;
 struct ipu_di;
 struct ipu_smfc_priv;
+struct ipu_ic_priv;
 
 struct ipu_devtype;
 
@@ -181,6 +182,7 @@ struct ipu_soc {
 	struct ipu_dmfc_priv	*dmfc_priv;
 	struct ipu_di		*di_priv[2];
 	struct ipu_smfc_priv	*smfc_priv;
+	struct ipu_ic_priv	*ic_priv;
 };
 
 void ipu_srm_dp_sync_update(struct ipu_soc *ipu);
@@ -209,4 +211,8 @@ void ipu_cpmem_exit(struct ipu_soc *ipu);
 int ipu_smfc_init(struct ipu_soc *ipu, struct device *dev, unsigned long base);
 void ipu_smfc_exit(struct ipu_soc *ipu);
 
+int ipu_ic_init(struct ipu_soc *ipu, struct device *dev, unsigned long ic_base,
+		unsigned long tpm_base, unsigned long vdi_base);
+void ipu_ic_exit(struct ipu_soc *ipu);
+
 #endif				/* __IPU_PRV_H__ */
-- 
2.0.0.rc2

