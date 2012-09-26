Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2IZD5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 23:57:40 -0400
Received: by pbbrr4 with SMTP id rr4so1201919pbb.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 20:57:40 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH Resend] [media] s5p-fimc: Fix incorrect condition in fimc_lite_reqbufs()
Date: Wed, 26 Sep 2012 09:23:59 +0530
Message-Id: <1348631639-17432-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a typo in a conditional evaluation.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 9289008..505200d 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -825,7 +825,7 @@ static int fimc_lite_reqbufs(struct file *file, void *priv,
 
 	reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
 	ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
-	if (!ret < 0)
+	if (!ret)
 		fimc->reqbufs_count = reqbufs->count;
 
 	return ret;
-- 
1.7.4.1

