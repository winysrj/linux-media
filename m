Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55694 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729814AbeJSCEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 22:04:53 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 5/5] media: cedrus: Get rid of interrupt bottom-half
Date: Thu, 18 Oct 2018 15:02:24 -0300
Message-Id: <20181018180224.3392-6-ezequiel@collabora.com>
In-Reply-To: <20181018180224.3392-1-ezequiel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the mem2mem framework guarantees that .device_run
won't be called from interrupt context, it is safe to call
v4l2_m2m_job_finish directly in the top-half.

So this means the bottom-half is no longer needed and we
can get rid of it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++++---------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index 32adbcbe6175..493e65b17b30 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -98,23 +98,6 @@ void cedrus_dst_format_set(struct cedrus_dev *dev,
 	}
 }
 
-static irqreturn_t cedrus_bh(int irq, void *data)
-{
-	struct cedrus_dev *dev = data;
-	struct cedrus_ctx *ctx;
-
-	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
-	if (!ctx) {
-		v4l2_err(&dev->v4l2_dev,
-			 "Instance released before the end of transaction\n");
-		return IRQ_HANDLED;
-	}
-
-	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
-
-	return IRQ_HANDLED;
-}
-
 static irqreturn_t cedrus_irq(int irq, void *data)
 {
 	struct cedrus_dev *dev = data;
@@ -165,7 +148,9 @@ static irqreturn_t cedrus_irq(int irq, void *data)
 
 	spin_unlock_irqrestore(&dev->irq_lock, flags);
 
-	return IRQ_WAKE_THREAD;
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
+
+	return IRQ_HANDLED;
 }
 
 int cedrus_hw_probe(struct cedrus_dev *dev)
@@ -187,9 +172,8 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 		return irq_dec;
 	}
-	ret = devm_request_threaded_irq(dev->dev, irq_dec, cedrus_irq,
-					cedrus_bh, 0, dev_name(dev->dev),
-					dev);
+	ret = devm_request_irq(dev->dev, irq_dec, cedrus_irq,
+			       0, dev_name(dev->dev), dev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
 
-- 
2.19.1
