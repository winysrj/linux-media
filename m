Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3EaOlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:41:03 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO00ELB3G99NW0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:41:02 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 05/11] exynos4-is: Do not use asynchronous runtime PM
 in release fop
Date: Fri, 31 May 2013 16:37:21 +0200
Message-id: <1370011047-11488-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use pm_runtime_put_sync() instead of pm_runtime_put() to avoid races
in handling the 'state' bit flags when the fimc-capture drivers'
runtime_resume callback is called from the PM workqueue.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 3b24f29..534ea68 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -496,7 +496,7 @@ static int fimc_capture_open(struct file *file)
 
 	ret = v4l2_fh_open(file);
 	if (ret) {
-		pm_runtime_put(&fimc->pdev->dev);
+		pm_runtime_put_sync(&fimc->pdev->dev);
 		goto unlock;
 	}
 
@@ -564,7 +564,7 @@ static int fimc_capture_release(struct file *file)
 		fimc_md_graph_unlock(&vc->ve);
 	}
 
-	pm_runtime_put(&fimc->pdev->dev);
+	pm_runtime_put_sync(&fimc->pdev->dev);
 	mutex_unlock(&fimc->lock);
 
 	return ret;
-- 
1.7.9.5

