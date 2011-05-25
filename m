Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3011 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab1EYNeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/11] vb2_poll: don't start DMA, leave that to the first read().
Date: Wed, 25 May 2011 15:33:50 +0200
Message-Id: <56353a4500047353bd8371ad2ba1aad1e40df016.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2_poll function would start read-DMA if called without any streaming
in progress. This unfortunately does not work if the application just wants
to poll for exceptions. This information of what the application is polling
for is sadly unavailable in the driver.

Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
call to read() start the DMA. This initial read() call will return EAGAIN
since no actual data is available yet, but it does start the DMA.

Applications must handle EAGAIN in any case since there can be other reasons
for EAGAIN as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..ad75c95 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1372,27 +1372,16 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	unsigned long flags;
-	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
-			ret = __vb2_init_fileio(q, 1);
-			if (ret)
-				return POLLERR;
-		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
-			ret = __vb2_init_fileio(q, 0);
-			if (ret)
-				return POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
+			return POLLIN | POLLRDNORM;
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
 			return POLLOUT | POLLWRNORM;
-		}
 	}
 
 	/*
-- 
1.7.1

