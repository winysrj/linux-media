Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26141 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab1FBKN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:13:28 -0400
Date: Thu, 02 Jun 2011 12:12:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] s5p-fimc: Remove empty buf_init operation
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307009524-1208-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The buf_init buffer queue operation is optional and
buffer_init() does nothing, remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 44fc26f..6901643 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -286,12 +286,6 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
-{
-	/* TODO: */
-	return 0;
-}
-
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
@@ -371,7 +365,6 @@ static struct vb2_ops fimc_capture_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
-	.buf_init		= buffer_init,
 	.wait_prepare		= fimc_unlock,
 	.wait_finish		= fimc_lock,
 	.start_streaming	= start_streaming,
-- 
1.7.5.2

