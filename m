Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2428 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3LMQOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 8/9] vb2: Improve file I/O emulation to handle buffers in any order
Date: Fri, 13 Dec 2013 17:13:45 +0100
Message-Id: <1386951226-27655-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
References: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

videobuf2 file I/O emulation assumed that buffers dequeued from the
driver would return in the order they were enqueued in the driver.

Improve the file I/O emulator's book-keeping to remove this assumption.

Also set the buf->size properly if a write() dequeues a buffer and the
VB2_FILEIO_WRITE_IMMEDIATELY flag is set.

Based on an initial patch by Andy Walls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/v4l2-core/videobuf2-core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8d61e6d..08c4a87 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2354,6 +2354,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
 		}
+		fileio->index = q->num_buffers;
 	}
 
 	/*
@@ -2429,15 +2430,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	}
 	fileio = q->fileio;
 
-	index = fileio->index;
-	buf = &fileio->bufs[index];
-
 	/*
 	 * Check if we need to dequeue the buffer.
 	 */
-	if (buf->queued) {
-		struct vb2_buffer *vb;
-
+	index = fileio->index;
+	if (index >= q->num_buffers) {
 		/*
 		 * Call vb2_dqbuf to get buffer back.
 		 */
@@ -2450,12 +2447,18 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			return ret;
 		fileio->dq_count += 1;
 
+		index = fileio->b.index;
+		buf = &fileio->bufs[index];
+
 		/*
 		 * Get number of bytes filled by the driver
 		 */
-		vb = q->bufs[index];
-		buf->size = vb2_get_plane_payload(vb, 0);
+		buf->pos = 0;
 		buf->queued = 0;
+		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
+				 : vb2_plane_size(q->bufs[index], 0);
+	} else {
+		buf = &fileio->bufs[index];
 	}
 
 	/*
@@ -2518,13 +2521,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 */
 		buf->pos = 0;
 		buf->queued = 1;
-		buf->size = q->bufs[0]->v4l2_planes[0].length;
+		buf->size = vb2_plane_size(q->bufs[index], 0);
 		fileio->q_count += 1;
-
-		/*
-		 * Switch to the next buffer
-		 */
-		fileio->index = (index + 1) % q->num_buffers;
+		if (fileio->index < q->num_buffers)
+			fileio->index++;
 	}
 
 	/*
-- 
1.8.4.3

