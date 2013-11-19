Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55604 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KSO1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:49 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00M2MLI2NH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:48 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 07/16] s5p-jpeg: Fix lack of spin_lock protection
Date: Tue, 19 Nov 2013 15:26:59 +0100
Message-id: <1384871228-6648-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_jpeg_device_run and s5p_jpeg_runtime_resume callbacks should
have spin_lock protection as they alter device registers.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 328bb8b..650c4d3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -930,7 +930,9 @@ static void s5p_jpeg_device_run(void *priv)
 	struct s5p_jpeg_ctx *ctx = priv;
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct vb2_buffer *src_buf, *dst_buf;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, flags;
+
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -998,6 +1000,8 @@ static void s5p_jpeg_device_run(void *priv)
 	}
 
 	jpeg_start(jpeg->regs);
+
+	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
 }
 
 static int s5p_jpeg_job_ready(void *priv)
@@ -1418,9 +1422,12 @@ static int s5p_jpeg_runtime_suspend(struct device *dev)
 static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+	unsigned long flags;
 
 	clk_prepare_enable(jpeg->clk);
 
+	spin_lock_irqsave(&jpeg->slock, flags);
+
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component
 	 * We fill table 0 for each component
@@ -1430,6 +1437,8 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	s5p_jpeg_set_hactbl(jpeg->regs);
 	s5p_jpeg_set_hactblg(jpeg->regs);
 
+	spin_unlock_irqrestore(&jpeg->slock, flags);
+
 	return 0;
 }
 
-- 
1.7.9.5

