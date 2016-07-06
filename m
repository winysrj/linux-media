Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36416 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbcGFXHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:35 -0400
Received: by mail-pa0-f65.google.com with SMTP id ib6so90656pad.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:35 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 13/28] gpu: ipu-v3: Fix IRT usage
Date: Wed,  6 Jul 2016 16:06:43 -0700
Message-Id: <1467846418-12913-14-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There can be multiple IC tasks using the IRT, so the IRT needs
a separate use counter. Create a private ipu_irt_enable() to
enable the IRT module when any IC task requires rotation, and
ipu_irt_disable() when a task no longer needs the IRT.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index f306a9c..5329bfe 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -160,6 +160,7 @@ struct ipu_ic_priv {
 	spinlock_t lock;
 	struct ipu_soc *ipu;
 	int use_count;
+	int irt_use_count;
 	struct ipu_ic task[IC_NUM_TASKS];
 };
 
@@ -379,8 +380,6 @@ void ipu_ic_task_disable(struct ipu_ic *ic)
 
 	ipu_ic_write(ic, ic_conf, IC_CONF);
 
-	ic->rotation = ic->graphics = false;
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
@@ -639,22 +638,44 @@ int ipu_ic_set_src(struct ipu_ic *ic, int csi_id, bool vdi)
 }
 EXPORT_SYMBOL_GPL(ipu_ic_set_src);
 
+static void ipu_irt_enable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+
+	if (!priv->irt_use_count)
+		ipu_module_enable(priv->ipu, IPU_CONF_ROT_EN);
+
+	priv->irt_use_count++;
+}
+
+static void ipu_irt_disable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+
+	priv->irt_use_count--;
+
+	if (!priv->irt_use_count)
+		ipu_module_disable(priv->ipu, IPU_CONF_ROT_EN);
+
+	if (priv->irt_use_count < 0)
+		priv->irt_use_count = 0;
+}
+
 int ipu_ic_enable(struct ipu_ic *ic)
 {
 	struct ipu_ic_priv *priv = ic->priv;
 	unsigned long flags;
-	u32 module = IPU_CONF_IC_EN;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (ic->rotation)
-		module |= IPU_CONF_ROT_EN;
-
 	if (!priv->use_count)
-		ipu_module_enable(priv->ipu, module);
+		ipu_module_enable(priv->ipu, IPU_CONF_IC_EN);
 
 	priv->use_count++;
 
+	if (ic->rotation)
+		ipu_irt_enable(ic);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -665,18 +686,22 @@ int ipu_ic_disable(struct ipu_ic *ic)
 {
 	struct ipu_ic_priv *priv = ic->priv;
 	unsigned long flags;
-	u32 module = IPU_CONF_IC_EN | IPU_CONF_ROT_EN;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
 	priv->use_count--;
 
 	if (!priv->use_count)
-		ipu_module_disable(priv->ipu, module);
+		ipu_module_disable(priv->ipu, IPU_CONF_IC_EN);
 
 	if (priv->use_count < 0)
 		priv->use_count = 0;
 
+	if (ic->rotation)
+		ipu_irt_disable(ic);
+
+	ic->rotation = ic->graphics = false;
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
-- 
1.9.1

