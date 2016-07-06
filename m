Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35353 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbcGFXHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:38 -0400
Received: by mail-pf0-f194.google.com with SMTP id t190so96696pfb.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:38 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 15/28] gpu: ipu-ic: allow multiple handles to ic
Date: Wed,  6 Jul 2016 16:06:45 -0700
Message-Id: <1467846418-12913-16-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The image converter kernel API supports conversion contexts and
job queues, so we should allow more than one handle to the IC, so
that multiple users can add jobs to the queue.

Note however that users that control the IC manually (that do not
use the image converter APIs but setup the IC task by hand via calls
to ipu_ic_task_enable(), ipu_ic_enable(), etc.) must still be careful not
to share the IC handle with other threads. At this point, the only user
that still controls the IC manually is the i.mx capture driver. In that
case the capture driver only allows one open context to get a handle
to the IC at a time, so we should be ok there.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index f6a1125..51e34a1 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -342,7 +342,6 @@ struct ipu_ic {
 	enum ipu_color_space out_cs;
 	bool graphics;
 	bool rotation;
-	bool in_use;
 
 	struct image_converter cvt;
 
@@ -2380,38 +2379,16 @@ EXPORT_SYMBOL_GPL(ipu_ic_disable);
 struct ipu_ic *ipu_ic_get(struct ipu_soc *ipu, enum ipu_ic_task task)
 {
 	struct ipu_ic_priv *priv = ipu->ic_priv;
-	unsigned long flags;
-	struct ipu_ic *ic, *ret;
 
 	if (task >= IC_NUM_TASKS)
 		return ERR_PTR(-EINVAL);
 
-	ic = &priv->task[task];
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (ic->in_use) {
-		ret = ERR_PTR(-EBUSY);
-		goto unlock;
-	}
-
-	ic->in_use = true;
-	ret = ic;
-
-unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return ret;
+	return &priv->task[task];
 }
 EXPORT_SYMBOL_GPL(ipu_ic_get);
 
 void ipu_ic_put(struct ipu_ic *ic)
 {
-	struct ipu_ic_priv *priv = ic->priv;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ic->in_use = false;
-	spin_unlock_irqrestore(&priv->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ipu_ic_put);
 
-- 
1.9.1

