Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3AKP3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 10:29:52 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG004GPWDRUL10@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:52 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGG00G15WDC1520@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:51 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	a.hajda@samsung.com, Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/3] s5p-mfc: end-of-stream handling in encoder bug fix
Date: Fri, 11 Jan 2013 16:29:34 +0100
Message-id: <1357918174-4651-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1357918174-4651-1-git-send-email-k.debski@samsung.com>
References: <1357918174-4651-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In some circumstances after issuing the V4L2_ENC_CMD_STOP the application
could freeze. This patch prevents this behavior.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index f92f6dd..2356fd5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1534,6 +1534,8 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
 		if (list_empty(&ctx->src_queue)) {
 			mfc_debug(2, "EOS: empty src queue, entering finishing state");
 			ctx->state = MFCINST_FINISHING;
+			if (s5p_mfc_ctx_ready(ctx))
+				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
-- 
1.7.9.5

