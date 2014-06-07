Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48519 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaFGV5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:03 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp16so3896700pbb.6
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:02 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 03/43] imx-drm: ipu-v3: Add ipu_get_num()
Date: Sat,  7 Jun 2014 14:56:05 -0700
Message-Id: <1402178205-22697-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds of-alias id to ipu_soc and retrieve with ipu_get_num().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    8 ++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |    1 +
 include/linux/platform_data/imx-ipu-v3.h    |    5 +++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 2aca7dd..f8e8c56 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -55,6 +55,12 @@ static inline void ipu_idmac_write(struct ipu_soc *ipu, u32 value,
 	writel(value, ipu->idmac_reg + offset);
 }
 
+int ipu_get_num(struct ipu_soc *ipu)
+{
+	return ipu->id;
+}
+EXPORT_SYMBOL_GPL(ipu_get_num);
+
 void ipu_srm_dp_sync_update(struct ipu_soc *ipu)
 {
 	u32 val;
@@ -1104,6 +1110,7 @@ static int ipu_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(imx_ipu_dt_ids, &pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	struct ipu_soc *ipu;
 	struct resource *res;
 	unsigned long ipu_base;
@@ -1132,6 +1139,7 @@ static int ipu_probe(struct platform_device *pdev)
 		ipu->channel[i].ipu = ipu;
 	ipu->devtype = devtype;
 	ipu->ipu_type = devtype->type;
+	ipu->id = of_alias_get_id(np, "ipu");
 
 	spin_lock_init(&ipu->lock);
 	mutex_init(&ipu->channel_lock);
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 40211f6..9e4cf4b 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -164,6 +164,7 @@ struct ipu_soc {
 	void __iomem		*idmac_reg;
 	struct ipu_ch_param __iomem	*cpmem_base;
 
+	int			id;
 	int			usecount;
 
 	struct clk		*clk;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index c083a2a..ca91dd9 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -92,6 +92,11 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 #define IPU_IRQ_VSYNC_PRE_1		(448 + 15)
 
 /*
+ * IPU Common functions
+ */
+int ipu_get_num(struct ipu_soc *ipu);
+
+/*
  * IPU Image DMA Controller (idmac) functions
  */
 struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned channel);
-- 
1.7.9.5

