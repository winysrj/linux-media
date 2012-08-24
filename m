Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44905 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HXMI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 08:08:29 -0400
Received: by pbbrr13 with SMTP id rr13so3354626pbb.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 05:08:29 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] mem2mem_testdev: Make m2mtest_dev_release function static
Date: Fri, 24 Aug 2012 17:36:15 +0530
Message-Id: <1345809975-20141-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warning:
drivers/media/platform/mem2mem_testdev.c:73:6: warning:
symbol 'm2mtest_dev_release' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/mem2mem_testdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0b496f3..771a84f 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -70,7 +70,7 @@ MODULE_VERSION("0.1.1");
 	v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
 
-void m2mtest_dev_release(struct device *dev)
+static void m2mtest_dev_release(struct device *dev)
 {}
 
 static struct platform_device m2mtest_pdev = {
-- 
1.7.4.1

