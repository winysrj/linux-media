Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2IXGVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:21:32 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so6542460pbb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 23:21:31 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sachin.kamat@linaro.org,
	m.szyprowski@samsung.com, pawel@osciak.com, patches@linaro.org
Subject: [PATCH 3/4] [media] mem2mem_testdev: Use pr_err instead of printk
Date: Mon, 24 Sep 2012 11:47:47 +0530
Message-Id: <1348467468-19854-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

printk(KERN_ERR...) is replaced with pr_err to silence checkpatch
warning.

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ...
then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/mem2mem_testdev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 570e880..f7d15ec 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -397,8 +397,7 @@ static void device_isr(unsigned long priv)
 	curr_ctx = v4l2_m2m_get_curr_priv(m2mtest_dev->m2m_dev);
 
 	if (NULL == curr_ctx) {
-		printk(KERN_ERR
-			"Instance released before the end of transaction\n");
+		pr_err("Instance released before the end of transaction\n");
 		return;
 	}
 
-- 
1.7.4.1

