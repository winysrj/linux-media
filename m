Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:59563 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbIQVU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 17:20:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 4/9] [media] exynos4-is: use monotonic timestamps as advertized
Date: Thu, 17 Sep 2015 23:19:35 +0200
Message-Id: <1442524780-781677-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The exynos4 fimc capture driver claims to use monotonic
timestamps but calls ktime_get_real_ts(). This is both
an incorrect API use, and a bad idea because of the y2038
problem and the fact that the wall clock time is not reliable
for timestamps across suspend or settimeofday().

This changes the driver to use the normal v4l2_get_timestamp()
function like all other drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/exynos4-is/fimc-capture.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index cfebf292e15a..776ea6d78d03 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -183,8 +183,6 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 	struct v4l2_subdev *csis = p->subdevs[IDX_CSIS];
 	struct fimc_frame *f = &cap->ctx->d_frame;
 	struct fimc_vid_buffer *v_buf;
-	struct timeval *tv;
-	struct timespec ts;
 
 	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
 		wake_up(&fimc->irq_queue);
@@ -193,13 +191,9 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 
 	if (!list_empty(&cap->active_buf_q) &&
 	    test_bit(ST_CAPT_RUN, &fimc->state) && deq_buf) {
-		ktime_get_real_ts(&ts);
-
 		v_buf = fimc_active_queue_pop(cap);
 
-		tv = &v_buf->vb.v4l2_buf.timestamp;
-		tv->tv_sec = ts.tv_sec;
-		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		v4l2_get_timestamp(&v_buf->vb.v4l2_buf.timestamp);
 		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
 
 		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
-- 
2.1.0.rc2

