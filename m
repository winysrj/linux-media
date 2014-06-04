Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55954 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaFDOFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:05:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH/RFC 1/2] v4l: vb2: Don't return POLLERR during transient buffer underruns
Date: Wed,  4 Jun 2014 16:05:43 +0200
Message-Id: <1401890744-22683-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 specification states that

"When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
the poll() function succeeds, but sets the POLLERR flag in the revents
field."

The vb2_poll() function sets POLLERR when the queued buffers list is
empty, regardless of whether this is caused by the stream not being
active yet, or by a transient buffer underrun.

Bring the implementation in line with the specification by returning
POLLERR only when the queue is not streaming. Buffer underruns during
streaming are not treated specially anymore and just result in poll()
blocking until the next event.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 11d31bf..5f38774 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1984,9 +1984,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if no buffers have already been queued.
+	 * There is nothing to wait for if the queue isn't streaming.
 	 */
-	if (list_empty(&q->queued_list))
+	if (!vb2_is_streaming(q))
 		return res | POLLERR;
 
 	poll_wait(file, &q->done_wq, wait);
-- 
1.8.5.5

