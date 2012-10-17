Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2JQLQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:35 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6997024pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:35 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/8] [media] s5p-g2d: Use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 17 Oct 2012 16:41:45 +0530
Message-Id: <1350472311-9748-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
as required by the common clock framework.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-g2d/g2d.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1bfbc32..adecd25 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -589,7 +589,7 @@ static void device_run(void *prv)
 	src = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	dst = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 
-	clk_enable(dev->gate);
+	clk_prepare_enable(dev->gate);
 	g2d_reset(dev);
 
 	spin_lock_irqsave(&dev->ctrl_lock, flags);
@@ -619,7 +619,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	struct vb2_buffer *src, *dst;
 
 	g2d_clear_int(dev);
-	clk_disable(dev->gate);
+	clk_disable_unprepare(dev->gate);
 
 	BUG_ON(ctx == NULL);
 
-- 
1.7.4.1

