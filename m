Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39944 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0L3F7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 00:59:19 -0500
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: [PATCH] [media] s5p-fimc: fimc_stop_capture bug fix
Date: Thu, 30 Dec 2010 14:35:28 +0900
Message-Id: <1293687328-26239-1-git-send-email-sungchun.kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

When is called fimc_stop_capture, it seems that wait_event_timeout
used improperly. It should be wake up by irq handler.

Reviewed-by Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
This patch is depended on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..821f927 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -187,7 +187,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	wait_event_timeout(fimc->irq_queue,
-			   test_bit(ST_CAPT_SHUT, &fimc->state),
+			   !test_bit(ST_CAPT_SHUT, &fimc->state),
 			   FIMC_SHUTDOWN_TIMEOUT);
 
 	ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);
-- 
1.6.2.5

