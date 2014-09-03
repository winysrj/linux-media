Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH 40/46] [media] marvel-ccic: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:12 -0300
Message-Id: <85652b7edb36b905a7765dab8c9b52453554aa9e.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 93f9cf2ebcd6..9d8d885558e5 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -313,7 +313,6 @@ static int isp_video_release(struct file *file)
 	struct fimc_is_video *ivc = &isp->video_capture;
 	struct media_entity *entity = &ivc->ve.vdev.entity;
 	struct media_device *mdev = entity->parent;
-	int ret = 0;
 
 	mutex_lock(&isp->video_lock);
 
@@ -335,7 +334,7 @@ static int isp_video_release(struct file *file)
 	pm_runtime_put(&isp->pdev->dev);
 	mutex_unlock(&isp->video_lock);
 
-	return ret;
+	return 0;
 }
 
 static const struct v4l2_file_operations isp_video_fops = {
-- 
1.9.3

