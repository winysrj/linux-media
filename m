Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38125 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbaFZBHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:21 -0400
Received: by mail-pb0-f42.google.com with SMTP id ma3so2420662pbc.29
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:20 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 07/28] gpu: ipu-v3: smfc: Convert to per-channel
Date: Wed, 25 Jun 2014 18:05:34 -0700
Message-Id: <1403744755-24944-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the smfc object to be specific to a single smfc channel.
Add ipu_smfc_{get|put} to retrieve and release a single smfc channel
for exclusive use, and add use counter to ipu_smfc_{enable|disable}.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-smfc.c |  132 +++++++++++++++++++++++++++++++++--------
 include/video/imx-ipu-v3.h    |   10 ++--
 2 files changed, 112 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-smfc.c b/drivers/gpu/ipu-v3/ipu-smfc.c
index 87ac624d..a6429ca 100644
--- a/drivers/gpu/ipu-v3/ipu-smfc.c
+++ b/drivers/gpu/ipu-v3/ipu-smfc.c
@@ -21,9 +21,18 @@
 
 #include "ipu-prv.h"
 
+struct ipu_smfc {
+	struct ipu_smfc_priv *priv;
+	int chno;
+	bool inuse;
+};
+
 struct ipu_smfc_priv {
 	void __iomem *base;
 	spinlock_t lock;
+	struct ipu_soc *ipu;
+	struct ipu_smfc channel[4];
+	int use_count;
 };
 
 /*SMFC Registers */
@@ -31,75 +40,146 @@ struct ipu_smfc_priv {
 #define SMFC_WMC	0x0004
 #define SMFC_BS		0x0008
 
-int ipu_smfc_set_burstsize(struct ipu_soc *ipu, int channel, int burstsize)
+int ipu_smfc_set_burstsize(struct ipu_smfc *smfc, int burstsize)
 {
-	struct ipu_smfc_priv *smfc = ipu->smfc_priv;
+	struct ipu_smfc_priv *priv = smfc->priv;
 	unsigned long flags;
 	u32 val, shift;
 
-	spin_lock_irqsave(&smfc->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	shift = channel * 4;
-	val = readl(smfc->base + SMFC_BS);
+	shift = smfc->chno * 4;
+	val = readl(priv->base + SMFC_BS);
 	val &= ~(0xf << shift);
 	val |= burstsize << shift;
-	writel(val, smfc->base + SMFC_BS);
+	writel(val, priv->base + SMFC_BS);
 
-	spin_unlock_irqrestore(&smfc->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_set_burstsize);
 
-int ipu_smfc_map_channel(struct ipu_soc *ipu, int channel, int csi_id, int mipi_id)
+int ipu_smfc_map_channel(struct ipu_smfc *smfc, int csi_id, int mipi_id)
 {
-	struct ipu_smfc_priv *smfc = ipu->smfc_priv;
+	struct ipu_smfc_priv *priv = smfc->priv;
 	unsigned long flags;
 	u32 val, shift;
 
-	spin_lock_irqsave(&smfc->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	shift = channel * 3;
-	val = readl(smfc->base + SMFC_MAP);
+	shift = smfc->chno * 3;
+	val = readl(priv->base + SMFC_MAP);
 	val &= ~(0x7 << shift);
 	val |= ((csi_id << 2) | mipi_id) << shift;
-	writel(val, smfc->base + SMFC_MAP);
+	writel(val, priv->base + SMFC_MAP);
 
-	spin_unlock_irqrestore(&smfc->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_map_channel);
 
-int ipu_smfc_enable(struct ipu_soc *ipu)
+int ipu_smfc_enable(struct ipu_smfc *smfc)
 {
-	return ipu_module_enable(ipu, IPU_CONF_SMFC_EN);
+	struct ipu_smfc_priv *priv = smfc->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (!priv->use_count)
+		ipu_module_enable(priv->ipu, IPU_CONF_SMFC_EN);
+
+	priv->use_count++;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_enable);
 
-int ipu_smfc_disable(struct ipu_soc *ipu)
+int ipu_smfc_disable(struct ipu_smfc *smfc)
 {
-	return ipu_module_disable(ipu, IPU_CONF_SMFC_EN);
+	struct ipu_smfc_priv *priv = smfc->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->use_count--;
+
+	if (!priv->use_count)
+		ipu_module_disable(priv->ipu, IPU_CONF_SMFC_EN);
+
+	if (priv->use_count < 0)
+		priv->use_count = 0;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_disable);
 
+struct ipu_smfc *ipu_smfc_get(struct ipu_soc *ipu, unsigned int chno)
+{
+	struct ipu_smfc_priv *priv = ipu->smfc_priv;
+	struct ipu_smfc *smfc, *ret;
+	unsigned long flags;
+
+	if (chno >= 4)
+		return ERR_PTR(-EINVAL);
+
+	smfc = &priv->channel[chno];
+	ret = smfc;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (smfc->inuse) {
+		ret = ERR_PTR(-EBUSY);
+		goto unlock;
+	}
+
+	smfc->inuse = true;
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_smfc_get);
+
+void ipu_smfc_put(struct ipu_smfc *smfc)
+{
+	struct ipu_smfc_priv *priv = smfc->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	smfc->inuse = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_smfc_put);
+
 int ipu_smfc_init(struct ipu_soc *ipu, struct device *dev,
 		  unsigned long base)
 {
-	struct ipu_smfc_priv *smfc;
+	struct ipu_smfc_priv *priv;
+	int i;
 
-	smfc = devm_kzalloc(dev, sizeof(*smfc), GFP_KERNEL);
-	if (!smfc)
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
 
-	ipu->smfc_priv = smfc;
-	spin_lock_init(&smfc->lock);
+	ipu->smfc_priv = priv;
+	spin_lock_init(&priv->lock);
+	priv->ipu = ipu;
 
-	smfc->base = devm_ioremap(dev, base, PAGE_SIZE);
-	if (!smfc->base)
+	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
+	if (!priv->base)
 		return -ENOMEM;
 
-	pr_debug("%s: ioremap 0x%08lx -> %p\n", __func__, base, smfc->base);
+	for (i = 0; i < 4; i++) {
+		priv->channel[i].priv = priv;
+		priv->channel[i].chno = i;
+	}
+
+	pr_debug("%s: ioremap 0x%08lx -> %p\n", __func__, base, priv->base);
 
 	return 0;
 }
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 580a88c..27fb980 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -291,10 +291,12 @@ void ipu_ic_dump(struct ipu_ic *ic);
 /*
  * IPU Sensor Multiple FIFO Controller (SMFC) functions
  */
-int ipu_smfc_enable(struct ipu_soc *ipu);
-int ipu_smfc_disable(struct ipu_soc *ipu);
-int ipu_smfc_map_channel(struct ipu_soc *ipu, int channel, int csi_id, int mipi_id);
-int ipu_smfc_set_burstsize(struct ipu_soc *ipu, int channel, int burstsize);
+struct ipu_smfc *ipu_smfc_get(struct ipu_soc *ipu, unsigned int chno);
+void ipu_smfc_put(struct ipu_smfc *smfc);
+int ipu_smfc_enable(struct ipu_smfc *smfc);
+int ipu_smfc_disable(struct ipu_smfc *smfc);
+int ipu_smfc_map_channel(struct ipu_smfc *smfc, int csi_id, int mipi_id);
+int ipu_smfc_set_burstsize(struct ipu_smfc *smfc, int burstsize);
 
 #define IPU_CPMEM_WORD(word, ofs, size) ((((word) * 160 + (ofs)) << 8) | (size))
 
-- 
1.7.9.5

