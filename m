Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2IXGVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:21:25 -0400
Received: by pbbrr4 with SMTP id rr4so6542460pbb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 23:21:25 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sachin.kamat@linaro.org,
	m.szyprowski@samsung.com, pawel@osciak.com, patches@linaro.org
Subject: [PATCH 1/4] [media] mem2mem_testdev: Fix incorrect location of v4l2_m2m_release()
Date: Mon, 24 Sep 2012 11:47:45 +0530
Message-Id: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_release() was placed after the return statement and outside
any of the goto labels and hence was not getting executed under the
error exit path. This patch moves it under the exit path label.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/mem2mem_testdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 771a84f..fc95559 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -1067,8 +1067,8 @@ static int m2mtest_probe(struct platform_device *pdev)
 
 	return 0;
 
-	v4l2_m2m_release(dev->m2m_dev);
 err_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(dev->vfd);
 rel_vdev:
 	video_device_release(vfd);
-- 
1.7.4.1

