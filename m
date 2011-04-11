Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27968 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1DKJHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:07:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Apr 2011 11:07:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/4] s5p-fimc: Add support for the buffer timestamps and
	sequence
In-reply-to: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1302512865-20379-5-git-send-email-s.nawrocki@samsung.com>
References: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add support for buffer timestamps and the sequence number in
the video capture driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index ef4e3f6..dc91a85 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -361,10 +361,20 @@ static void fimc_capture_irq_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *v_buf;
+	struct timeval *tv;
+	struct timespec ts;
 
 	if (!list_empty(&cap->active_buf_q) &&
 	    test_bit(ST_CAPT_RUN, &fimc->state)) {
+		ktime_get_real_ts(&ts);
+
 		v_buf = active_queue_pop(cap);
+
+		tv = &v_buf->vb.v4l2_buf.timestamp;
+		tv->tv_sec = ts.tv_sec;
+		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
+
 		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
 	}
 
-- 
1.7.4.3
