Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63085 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3DVOGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:34 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	stable@vger.kernel.org
Subject: [PATCH 08/12] exynos4-is: Set fimc-lite subdev subdev owner module
Date: Mon, 22 Apr 2013 16:03:43 +0200
Message-id: <1366639427-14253-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIMC-LITE.n subdevs have currently sd->owner field not set,
the exynos-fimc-lite module can be removed at any time, regardless
it is in use by other modules. When this module is unloaded the
kernel can crash easily by accessing video or media device nodes.

Cc: stable@vger.kernel.org
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 7ecf4e7..14bb7bc 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1399,6 +1399,7 @@ static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 	sd->ctrl_handler = handler;
 	sd->internal_ops = &fimc_lite_subdev_internal_ops;
 	sd->entity.ops = &fimc_lite_subdev_media_ops;
+	sd->owner = THIS_MODULE;
 	v4l2_set_subdevdata(sd, fimc);
 
 	return 0;
-- 
1.7.9.5

