Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39942 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0L3F7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 00:59:18 -0500
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: [PATCH] [media] s5p-fimc: modify name of function for uniformity
Date: Thu, 30 Dec 2010 14:35:43 +0900
Message-Id: <1293687343-27424-1-git-send-email-sungchun.kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch modified function name about add or pop queue.

Reviewed-by Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
This patch is depended on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..fdef450 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -155,7 +155,7 @@ int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 		return ret;
 
 	if (test_bit(ST_CAPT_STREAM, &fimc->state)) {
-		fimc_pending_queue_add(cap, fimc_vb);
+		pending_queue_add(cap, fimc_vb);
 	} else {
 		/* Setup the buffer directly for processing. */
 		int buf_id = (cap->reqbufs_count == 1) ? -1 : cap->buf_index;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1f1beaa..5bd9d93 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -668,7 +668,7 @@ active_queue_pop(struct fimc_vid_cap *vid_cap)
 }
 
 /* Add video buffer to the capture pending buffers queue */
-static inline void fimc_pending_queue_add(struct fimc_vid_cap *vid_cap,
+static inline void pending_queue_add(struct fimc_vid_cap *vid_cap,
 					  struct fimc_vid_buffer *buf)
 {
 	list_add_tail(&buf->list, &vid_cap->pending_buf_q);
-- 
1.6.2.5

