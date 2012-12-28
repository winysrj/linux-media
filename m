Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48829 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2L1K0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:26:20 -0500
Received: by mail-pb0-f43.google.com with SMTP id um15so5844327pbc.2
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 02:26:19 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 1/3] [media] s5p-mfc: use mfc_err instead of printk
Date: Fri, 28 Dec 2012 15:48:26 +0530
Message-Id: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use mfc_err for consistency. Also silences checkpatch warning.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index bf7d010..bb99d3d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -187,8 +187,7 @@ int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
 		if (IS_ERR(ctx->bank1_buf)) {
 			ctx->bank1_buf = NULL;
-			printk(KERN_ERR
-			       "Buf alloc for decoding failed (port A)\n");
+			mfc_err("Buf alloc for decoding failed (port A)\n");
 			return -ENOMEM;
 		}
 		ctx->bank1_phys = s5p_mfc_mem_cookie(
-- 
1.7.4.1

