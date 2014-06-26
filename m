Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46029 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaFZBHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:21 -0400
Received: by mail-pb0-f53.google.com with SMTP id uo5so2376235pbc.26
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:21 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 08/28] gpu: ipu-v3: smfc: Add ipu_smfc_set_watermark()
Date: Wed, 25 Jun 2014 18:05:35 -0700
Message-Id: <1403744755-24944-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_smfc_set_watermark() which programs a channel's SMFC FIFO
levels at which the watermark signal is set and cleared.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-smfc.c |   20 ++++++++++++++++++++
 include/video/imx-ipu-v3.h    |    1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-smfc.c b/drivers/gpu/ipu-v3/ipu-smfc.c
index a6429ca..6ca9b43 100644
--- a/drivers/gpu/ipu-v3/ipu-smfc.c
+++ b/drivers/gpu/ipu-v3/ipu-smfc.c
@@ -80,6 +80,26 @@ int ipu_smfc_map_channel(struct ipu_smfc *smfc, int csi_id, int mipi_id)
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_map_channel);
 
+int ipu_smfc_set_watermark(struct ipu_smfc *smfc, u32 set_level, u32 clr_level)
+{
+	struct ipu_smfc_priv *priv = smfc->priv;
+	unsigned long flags;
+	u32 val, shift;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	shift = smfc->chno * 6 + (smfc->chno > 1 ? 4 : 0);
+	val = readl(priv->base + SMFC_WMC);
+	val &= ~(0x3f << shift);
+	val |= ((clr_level << 3) | set_level) << shift;
+	writel(val, priv->base + SMFC_WMC);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_smfc_set_watermark);
+
 int ipu_smfc_enable(struct ipu_smfc *smfc)
 {
 	struct ipu_smfc_priv *priv = smfc->priv;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 27fb980..e69b247 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -297,6 +297,7 @@ int ipu_smfc_enable(struct ipu_smfc *smfc);
 int ipu_smfc_disable(struct ipu_smfc *smfc);
 int ipu_smfc_map_channel(struct ipu_smfc *smfc, int csi_id, int mipi_id);
 int ipu_smfc_set_burstsize(struct ipu_smfc *smfc, int burstsize);
+int ipu_smfc_set_watermark(struct ipu_smfc *smfc, u32 set_level, u32 clr_level);
 
 #define IPU_CPMEM_WORD(word, ofs, size) ((((word) * 160 + (ofs)) << 8) | (size))
 
-- 
1.7.9.5

