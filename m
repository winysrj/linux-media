Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64412 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3AVFIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 00:08:51 -0500
Received: by mail-pb0-f45.google.com with SMTP id mc8so3719290pbc.4
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2013 21:08:51 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-mfc: Use WARN_ON(condition) directly
Date: Tue, 22 Jan 2013 10:30:06 +0530
Message-Id: <1358830806-5610-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use WARN_ON(condition) directly instead of wrapping around an if
condition.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b1d7f9a..37a17b8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -596,8 +596,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 
 	clear_work_bit(ctx);
 
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		WARN_ON(1);
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
 	s5p_mfc_clock_off();
 	wake_up(&ctx->queue);
-- 
1.7.4.1

