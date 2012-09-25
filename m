Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56770 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2IYLWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:22:44 -0400
Received: by padhz1 with SMTP id hz1so1591877pad.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 04:22:43 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-fimc: Fix incorrect condition in fimc_lite_reqbufs()
Date: Tue, 25 Sep 2012 16:49:04 +0530
Message-Id: <1348571944-7139-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When precedence rules are applied, the condition always evaluates
to be false which was not the intention. Adding the missing braces
for correct evaluation of the expression and subsequent functionality.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 9289008..20e5e24 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -825,7 +825,7 @@ static int fimc_lite_reqbufs(struct file *file, void *priv,
 
 	reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
 	ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
-	if (!ret < 0)
+	if (!(ret < 0))
 		fimc->reqbufs_count = reqbufs->count;
 
 	return ret;
-- 
1.7.4.1

