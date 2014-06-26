Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34195 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaFZBHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:20 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so2329661pdi.13
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:20 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 06/28] gpu: ipu-v3: smfc: Move enable/disable to ipu-smfc.c
Date: Wed, 25 Jun 2014 18:05:33 -0700
Message-Id: <1403744755-24944-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   12 ------------
 drivers/gpu/ipu-v3/ipu-smfc.c   |   12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 0ac2103..85220ae 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -667,18 +667,6 @@ int ipu_module_disable(struct ipu_soc *ipu, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ipu_module_disable);
 
-int ipu_smfc_enable(struct ipu_soc *ipu)
-{
-	return ipu_module_enable(ipu, IPU_CONF_SMFC_EN);
-}
-EXPORT_SYMBOL_GPL(ipu_smfc_enable);
-
-int ipu_smfc_disable(struct ipu_soc *ipu)
-{
-	return ipu_module_disable(ipu, IPU_CONF_SMFC_EN);
-}
-EXPORT_SYMBOL_GPL(ipu_smfc_disable);
-
 int ipu_idmac_get_current_buffer(struct ipuv3_channel *channel)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/drivers/gpu/ipu-v3/ipu-smfc.c b/drivers/gpu/ipu-v3/ipu-smfc.c
index e4f85ad..87ac624d 100644
--- a/drivers/gpu/ipu-v3/ipu-smfc.c
+++ b/drivers/gpu/ipu-v3/ipu-smfc.c
@@ -71,6 +71,18 @@ int ipu_smfc_map_channel(struct ipu_soc *ipu, int channel, int csi_id, int mipi_
 }
 EXPORT_SYMBOL_GPL(ipu_smfc_map_channel);
 
+int ipu_smfc_enable(struct ipu_soc *ipu)
+{
+	return ipu_module_enable(ipu, IPU_CONF_SMFC_EN);
+}
+EXPORT_SYMBOL_GPL(ipu_smfc_enable);
+
+int ipu_smfc_disable(struct ipu_soc *ipu)
+{
+	return ipu_module_disable(ipu, IPU_CONF_SMFC_EN);
+}
+EXPORT_SYMBOL_GPL(ipu_smfc_disable);
+
 int ipu_smfc_init(struct ipu_soc *ipu, struct device *dev,
 		  unsigned long base)
 {
-- 
1.7.9.5

