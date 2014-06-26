Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50020 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbaFZBHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:38 -0400
Received: by mail-pd0-f176.google.com with SMTP id ft15so2321507pdb.7
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:38 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 28/28] gpu: ipu-v3: Add ipu_dump()
Date: Wed, 25 Jun 2014 18:05:55 -0700
Message-Id: <1403744755-24944-29-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_dump() which dumps IPU register state to debug.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   38 ++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 39 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 115572e..af00e8c 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1310,6 +1310,44 @@ static void ipu_irq_exit(struct ipu_soc *ipu)
 	irq_domain_remove(ipu->domain);
 }
 
+void ipu_dump(struct ipu_soc *ipu)
+{
+	int i;
+
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 62f9c4b..1ed1062 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -187,6 +187,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 int ipu_get_num(struct ipu_soc *ipu);
 void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
 void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
+void ipu_dump(struct ipu_soc *ipu);
 
 /*
  * IPU Image DMA Controller (idmac) functions
-- 
1.7.9.5

