Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35578 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcFNWvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:08 -0400
Received: by mail-pf0-f193.google.com with SMTP id t190so301510pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:07 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 04/38] gpu: ipu-v3: Add ipu_get_num()
Date: Tue, 14 Jun 2016 15:49:00 -0700
Message-Id: <1465944574-15745-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds of-alias id to ipu_soc and retrieve with ipu_get_num().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 8 ++++++++
 drivers/gpu/ipu-v3/ipu-prv.h    | 1 +
 include/video/imx-ipu-v3.h      | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 30dc115..49af121 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -45,6 +45,12 @@ static inline void ipu_cm_write(struct ipu_soc *ipu, u32 value, unsigned offset)
 	writel(value, ipu->cm_reg + offset);
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
@@ -1220,6 +1226,7 @@ static int ipu_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(imx_ipu_dt_ids, &pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	struct ipu_soc *ipu;
 	struct resource *res;
 	unsigned long ipu_base;
@@ -1248,6 +1255,7 @@ static int ipu_probe(struct platform_device *pdev)
 		ipu->channel[i].ipu = ipu;
 	ipu->devtype = devtype;
 	ipu->ipu_type = devtype->type;
+	ipu->id = of_alias_get_id(np, "ipu");
 
 	spin_lock_init(&ipu->lock);
 	mutex_init(&ipu->channel_lock);
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index 845f64c..02057d8 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -153,6 +153,7 @@ struct ipu_soc {
 	void __iomem		*cm_reg;
 	void __iomem		*idmac_reg;
 
+	int			id;
 	int			usecount;
 
 	struct clk		*clk;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 60540ead..b174f8a 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -148,6 +148,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 /*
  * IPU Common functions
  */
+int ipu_get_num(struct ipu_soc *ipu);
 void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
 void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
 void ipu_dump(struct ipu_soc *ipu);
-- 
1.9.1

