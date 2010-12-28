Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab0L1RDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:24 -0500
Date: Tue, 28 Dec 2010 18:03:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/15] [media] s5p-fimc: Enable interworking without subdev
 s_stream
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-10-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Prevent VIDIOC_STREAMON failing when s_stream callback is
not implemented by a sensor subdev driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 431ec8e..fc48368 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -191,7 +191,8 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 			   FIMC_SHUTDOWN_TIMEOUT);
 
 	ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);
-	if (ret)
+
+	if (ret && ret != -ENOIOCTLCMD)
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "s_stream(0) failed\n");
 
 	spin_lock_irqsave(&fimc->slock, flags);
-- 
1.7.2.3

