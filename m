Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59918 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3DVOGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:21 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN006ONTTN4QE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:06:20 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/12] exynos4-is: Unregister fimc-is subdevs from the media
 device properly
Date: Mon, 22 Apr 2013 16:03:42 +0200
Message-id: <1366639427-14253-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing v4l2_device_unregister_subdev() call for the FIMC-IS subdevs
(currently there is only the FIMC-IS-ISP subdev) so corresponding resources
are properly freed upon the media device driver module removal.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 1dbd554..a371ee5 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -823,6 +823,10 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
 		fmd->sensor[i].subdev = NULL;
 	}
+
+	if (fmd->fimc_is)
+		v4l2_device_unregister_subdev(&fmd->fimc_is->isp.subdev);
+
 	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
 }
 
-- 
1.7.9.5

