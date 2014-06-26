Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50554 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbaFZBHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:17 -0400
Received: by mail-pb0-f50.google.com with SMTP id rp16so2401396pbb.23
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:16 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 02/28] gpu: ipu-v3: Add ipu_get_num()
Date: Wed, 25 Jun 2014 18:05:29 -0700
Message-Id: <1403744755-24944-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds of-alias id to ipu_soc and retrieve with ipu_get_num().

ipu_get_num() is used to select inputs to CSI units in IOMUXC.
It is also used to select an SMFC channel for video capture.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |    8 ++++++++
 drivers/gpu/ipu-v3/ipu-prv.h    |    1 +
 include/video/imx-ipu-v3.h      |    5 +++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 04e7b2e..a92f48b 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
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
@@ -1205,6 +1211,7 @@ static int ipu_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(imx_ipu_dt_ids, &pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	struct ipu_soc *ipu;
 	struct resource *res;
 	unsigned long ipu_base;
@@ -1233,6 +1240,7 @@ static int ipu_probe(struct platform_device *pdev)
 		ipu->channel[i].ipu = ipu;
 	ipu->devtype = devtype;
 	ipu->ipu_type = devtype->type;
+	ipu->id = of_alias_get_id(np, "ipu");
 
 	spin_lock_init(&ipu->lock);
 	mutex_init(&ipu->channel_lock);
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index c93f50e..55ae20c 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -166,6 +166,7 @@ struct ipu_soc {
 	void __iomem		*idmac_reg;
 	struct ipu_ch_param __iomem	*cpmem_base;
 
+	int			id;
 	int			usecount;
 
 	struct clk		*clk;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 3e43e22..739d204 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -93,6 +93,11 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
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

