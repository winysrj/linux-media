Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54222 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbeFATuM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 15:50:12 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] rockchip/rga: Remove unrequired wait in .job_abort
Date: Fri,  1 Jun 2018 16:49:52 -0300
Message-Id: <20180601194952.17440-3-ezequiel@collabora.com>
In-Reply-To: <20180601194952.17440-1-ezequiel@collabora.com>
References: <20180601194952.17440-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As per the documentation, job_abort is not required
to wait until the current job finishes. It is redundant
to do so, as the core will perform the wait operation.

Remove the wait infrastructure completely.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/rockchip/rga/rga.c | 13 +------------
 drivers/media/platform/rockchip/rga/rga.h |  2 --
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index d508a8ba6f89..5a5a6139e18a 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -41,14 +41,7 @@ module_param(debug, int, 0644);
 
 static void job_abort(void *prv)
 {
-	struct rga_ctx *ctx = prv;
-	struct rockchip_rga *rga = ctx->rga;
-
-	if (!rga->curr)	/* No job currently running */
-		return;
-
-	wait_event_timeout(rga->irq_queue,
-			   !rga->curr, msecs_to_jiffies(RGA_TIMEOUT));
+	/* Can't do anything rational here */
 }
 
 static void device_run(void *prv)
@@ -104,8 +97,6 @@ static irqreturn_t rga_isr(int irq, void *prv)
 		v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 		v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
 		v4l2_m2m_job_finish(rga->m2m_dev, ctx->fh.m2m_ctx);
-
-		wake_up(&rga->irq_queue);
 	}
 
 	return IRQ_HANDLED;
@@ -838,8 +829,6 @@ static int rga_probe(struct platform_device *pdev)
 	spin_lock_init(&rga->ctrl_lock);
 	mutex_init(&rga->mutex);
 
-	init_waitqueue_head(&rga->irq_queue);
-
 	ret = rga_parse_dt(rga);
 	if (ret)
 		dev_err(&pdev->dev, "Unable to parse OF data\n");
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 5d43e7ea88af..72d8a159fa7b 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -86,8 +86,6 @@ struct rockchip_rga {
 	/* ctrl parm lock */
 	spinlock_t ctrl_lock;
 
-	wait_queue_head_t irq_queue;
-
 	struct rga_ctx *curr;
 	dma_addr_t cmdbuf_phy;
 	void *cmdbuf_virt;
-- 
2.17.1
