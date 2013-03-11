Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58366 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3CKTAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:00:52 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 01/11] s5p-fimc: Added error checks for pipeline stream on
 callbacks
Date: Mon, 11 Mar 2013 20:00:16 +0100
Message-id: <1363028426-2771-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>

set_stream error for pipelines is logged or reported to user
space if possible.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 2a1da4c..52abc9f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -286,8 +286,8 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		fimc_activate_capture(ctx);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
-					   &fimc->pipeline, 1);
+			return fimc_pipeline_call(fimc, set_stream,
+						  &fimc->pipeline, 1);
 	}
 
 	return 0;
@@ -443,12 +443,17 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (vb2_is_streaming(&vid_cap->vbq) &&
 	    vid_cap->active_buf_cnt >= min_bufs &&
 	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
+		int ret;
+
 		fimc_activate_capture(ctx);
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
-		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
-					   &fimc->pipeline, 1);
+		if (test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
+			return;
+
+		ret = fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 1);
+		if (ret < 0)
+			v4l2_err(&vid_cap->vfd, "stream on failed: %d\n", ret);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
-- 
1.7.9.5

