Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:18880 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3ARQCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 11:02:44 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT00C3PWKJDEY0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 01:02:43 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGT008T3WKC6W30@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 01:02:42 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, dh09.lee@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] s5p-fimc: fimc-lite: Remove empty s_power subdev callback
Date: Fri, 18 Jan 2013 17:02:31 +0100
Message-id: <1358524952-25156-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The .s_power FIMC-LITE subdev callback is now empty and
unneeded. The FIMC-LITE IP power handling will be done
by the FIMC-IS driver, so just remove the callback.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index e3e3370..15db03e2 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1281,18 +1281,6 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
-static int fimc_lite_subdev_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
-
-	if (fimc->out_path == FIMC_IO_DMA)
-		return -ENOIOCTLCMD;
-
-	/* TODO: */
-
-	return 0;
-}
-
 static int fimc_lite_log_status(struct v4l2_subdev *sd)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
@@ -1392,7 +1380,6 @@ static const struct v4l2_subdev_video_ops fimc_lite_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_core_ops fimc_lite_core_ops = {
-	.s_power = fimc_lite_subdev_s_power,
 	.log_status = fimc_lite_log_status,
 };
 
-- 
1.7.9.5

