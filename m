Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33926 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0L3FyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 00:54:21 -0500
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: [PATCH] [media] s5p-fimc: clean up duplicate INIT_LIST_HEAD
Date: Thu, 30 Dec 2010 14:35:07 +0900
Message-Id: <1293687307-26204-1-git-send-email-sungchun.kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Because active_q and pending_q are initialized at start_streaming,
it seems to unnecessary that in fimc_probe.

Reviewed-by Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
This patch is depended on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

 drivers/media/video/s5p-fimc/fimc-capture.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..877ebef 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -861,8 +861,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	/* Default color format for image sensor */
 	vid_cap->fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
 
-	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
-	INIT_LIST_HEAD(&vid_cap->active_buf_q);
 	spin_lock_init(&ctx->slock);
 	vid_cap->ctx = ctx;
 
-- 
1.6.2.5

