Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2IXGV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:21:28 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so6542460pbb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 23:21:28 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sachin.kamat@linaro.org,
	m.szyprowski@samsung.com, pawel@osciak.com, patches@linaro.org
Subject: [PATCH 2/4] [media] mem2mem_testdev: Add missing braces around sizeof
Date: Mon, 24 Sep 2012 11:47:46 +0530
Message-Id: <1348467468-19854-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warnings:
WARNING: sizeof *ctx should be sizeof(*ctx)
WARNING: sizeof *dev should be sizeof(*dev)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/mem2mem_testdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index fc95559..570e880 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -895,7 +895,7 @@ static int m2mtest_open(struct file *file)
 
 	if (mutex_lock_interruptible(&dev->dev_mutex))
 		return -ERESTARTSYS;
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		rc = -ENOMEM;
 		goto open_unlock;
@@ -1020,7 +1020,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	int ret;
 
-	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
-- 
1.7.4.1

