Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47748 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab3E1H05 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 03:26:57 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNH00BQBZAWJB70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 08:26:56 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 2/3] s5p-mfc: v4l2 controls setup routine moved to
 initialization code
Date: Tue, 28 May 2013 09:26:15 +0200
Message-id: <1369725976-7828-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Callback .start_streaming is called once for every queue,
so v4l2_ctrl_handler_setup was called twice during stream start.
Moving v4l2_ctrl_handler_setup to context initialization
reduces numbers of calls and seems to be more consistent with API.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4f6b553..64bb31e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1760,7 +1760,6 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
@@ -1920,6 +1919,7 @@ int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
 		if (controls[i].is_volatile && ctx->ctrls[i])
 			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	}
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
 	return 0;
 }
 
-- 
1.8.1.2

