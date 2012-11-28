Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64926 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2K1TSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:18:30 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME7009ROPMTF440@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:29 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME700C69PML0A30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:18:29 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 10/12] fimc-lite: Remove empty subdev s_power callback
Date: Wed, 28 Nov 2012 20:18:16 +0100
Message-id: <1354130298-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is nothing to do in s_power callback so remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 1b309a7..d9e7d6f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1195,18 +1195,10 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	/* TODO: */
 
 	return 0;
-}
 
-static int fimc_lite_subdev_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 
-	if (fimc->out_path == FIMC_IO_DMA)
-		return -ENOIOCTLCMD;
 
-	/* TODO: */
 
-	return 0;
 }
 
 static int fimc_lite_log_status(struct v4l2_subdev *sd)
@@ -1308,7 +1300,6 @@ static const struct v4l2_subdev_video_ops fimc_lite_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_core_ops fimc_lite_core_ops = {
-	.s_power = fimc_lite_subdev_s_power,
 	.log_status = fimc_lite_log_status,
 };
 
-- 
1.7.9.5

