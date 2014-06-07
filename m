Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61379 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFGV5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:30 -0400
Received: by mail-pb0-f41.google.com with SMTP id uo5so3917962pbc.14
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:30 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 29/43] imx-drm: ipu-v3: Add ipu_dump()
Date: Sat,  7 Jun 2014 14:56:31 -0700
Message-Id: <1402178205-22697-30-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_dump() which dumps IPU register state to debug.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   41 +++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 42 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 2ee6370..1526cec 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -1326,6 +1326,47 @@ static void ipu_irq_exit(struct ipu_soc *ipu)
 	irq_domain_remove(ipu->domain);
 }
 
+void ipu_dump(struct ipu_soc *ipu)
+{
+	int i;
+	dev_dbg(ipu->dev, "IPU_CONF = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_CONF));
+	dev_dbg(ipu->dev, "IDMAC_CONF = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_CONF));
+	dev_dbg(ipu->dev, "IDMAC_CHA_EN1 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_CHA_EN(0)));
+	dev_dbg(ipu->dev, "IDMAC_CHA_EN2 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_CHA_EN(32)));
+	dev_dbg(ipu->dev, "IDMAC_CHA_PRI1 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_CHA_PRI(0)));
+	dev_dbg(ipu->dev, "IDMAC_CHA_PRI2 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_CHA_PRI(32)));
+	dev_dbg(ipu->dev, "IDMAC_BAND_EN1 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_BAND_EN(0)));
+	dev_dbg(ipu->dev, "IDMAC_BAND_EN2 = \t0x%08X\n",
+		ipu_idmac_read(ipu, IDMAC_BAND_EN(32)));
+	dev_dbg(ipu->dev, "IPU_CHA_DB_MODE_SEL0 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_CHA_DB_MODE_SEL(0)));
+	dev_dbg(ipu->dev, "IPU_CHA_DB_MODE_SEL1 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_CHA_DB_MODE_SEL(32)));
+	dev_dbg(ipu->dev, "IPU_CHA_TRB_MODE_SEL0 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_CHA_TRB_MODE_SEL(0)));
+	dev_dbg(ipu->dev, "IPU_CHA_TRB_MODE_SEL1 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_CHA_TRB_MODE_SEL(32)));
+	dev_dbg(ipu->dev, "IPU_FS_PROC_FLOW1 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_FS_PROC_FLOW1));
+	dev_dbg(ipu->dev, "IPU_FS_PROC_FLOW2 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_FS_PROC_FLOW2));
+	dev_dbg(ipu->dev, "IPU_FS_PROC_FLOW3 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_FS_PROC_FLOW3));
+	dev_dbg(ipu->dev, "IPU_FS_DISP_FLOW1 = \t0x%08X\n",
+		ipu_cm_read(ipu, IPU_FS_DISP_FLOW1));
+	for (i = 0; i < 15; i++)
+		dev_dbg(ipu->dev, "IPU_INT_CTRL(%d) = \t%08X\n", i,
+			ipu_cm_read(ipu, IPU_INT_CTRL(i)));
+}
+EXPORT_SYMBOL_GPL(ipu_dump);
+
 static int ipu_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 811b93b..1698d5d 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -185,6 +185,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
  * IPU Common functions
  */
 int ipu_get_num(struct ipu_soc *ipu);
+void ipu_dump(struct ipu_soc *ipu);
 
 /*
  * IPU Image DMA Controller (idmac) functions
-- 
1.7.9.5

