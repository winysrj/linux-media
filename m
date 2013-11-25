Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56526 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3KYJ6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:55 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00ADXD26E230@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:54 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 07/16] s5p-jpeg: Fix lack of spin_lock protection
Date: Mon, 25 Nov 2013 10:58:14 +0100
Message-id: <1385373503-1657-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
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
index 583fcdd..628fde8 100644
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
@@ -1418,12 +1422,15 @@ static int s5p_jpeg_runtime_suspend(struct device *dev)
 static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+	unsigned long flags;
 	int ret;
 
 	ret = clk_prepare_enable(jpeg->clk);
 	if (ret < 0)
 		return ret;
 
+	spin_lock_irqsave(&jpeg->slock, flags);
+
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component
 	 * We fill table 0 for each component
@@ -1433,6 +1440,8 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	s5p_jpeg_set_hactbl(jpeg->regs);
 	s5p_jpeg_set_hactblg(jpeg->regs);
 
+	spin_unlock_irqrestore(&jpeg->slock, flags);
+
 	return 0;
 }
 
-- 
1.7.9.5

