Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2079 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaB1Rmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 12:42:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [REVIEWv3 PATCH 02/17] vb2: fix read/write regression
Date: Fri, 28 Feb 2014 18:42:00 +0100
Message-Id: <1393609335-12081-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Commit 88e268702bfba78448abd20a31129458707383aa ("vb2: Improve file I/O
emulation to handle buffers in any order") broke read/write support if
the size of the buffer being read/written is less than the size of the
image.

When the commit was tested originally I used qv4l2, which calls read()
with exactly the size of the image. But if you try 'cat /dev/video0'
then it will fail and typically hang after reading two buffers.

This patch fixes the behavior by adding a new cur_index field that
contains the index of the field currently being filled/read, or it
is num_buffers in which case a new buffer needs to be dequeued.

The old index field has been renamed to initial_index in order to be
a bit more descriptive.

This has been tested with both read and write.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/v4l2-core/videobuf2-core.c | 46 +++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index a127925..f1a2857c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2251,6 +2251,22 @@ struct vb2_fileio_buf {
 /**
  * struct vb2_fileio_data - queue context used by file io emulator
  *
+ * @cur_index:	the index of the buffer currently being read from or
+ *		written to. If equal to q->num_buffers then a new buffer
+ *		must be dequeued.
+ * @initial_index: in the read() case all buffers are queued up immediately
+ *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
+ *		buffers. However, in the write() case no buffers are initially
+ *		queued, instead whenever a buffer is full it is queued up by
+ *		__vb2_perform_fileio(). Only once all available buffers have
+ *		been queued up will __vb2_perform_fileio() start to dequeue
+ *		buffers. This means that initially __vb2_perform_fileio()
+ *		needs to know what buffer index to use when it is queuing up
+ *		the buffers for the first time. That initial index is stored
+ *		in this field. Once it is equal to q->num_buffers all
+ *		available buffers have been queued and __vb2_perform_fileio()
+ *		should start the normal dequeue/queue cycle.
+ *
  * vb2 provides a compatibility layer and emulator of file io (read and
  * write) calls on top of streaming API. For proper operation it required
  * this structure to save the driver state between each call of the read
@@ -2260,7 +2276,8 @@ struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
 	struct v4l2_buffer b;
 	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
-	unsigned int index;
+	unsigned int cur_index;
+	unsigned int initial_index;
 	unsigned int q_count;
 	unsigned int dq_count;
 	unsigned int flags;
@@ -2360,7 +2377,12 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
 		}
-		fileio->index = q->num_buffers;
+		/*
+		 * All buffers have been queued, so mark that by setting
+		 * initial_index to q->num_buffers
+		 */
+		fileio->initial_index = q->num_buffers;
+		fileio->cur_index = q->num_buffers;
 	}
 
 	/*
@@ -2439,7 +2461,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	/*
 	 * Check if we need to dequeue the buffer.
 	 */
-	index = fileio->index;
+	index = fileio->cur_index;
 	if (index >= q->num_buffers) {
 		/*
 		 * Call vb2_dqbuf to get buffer back.
@@ -2453,7 +2475,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			return ret;
 		fileio->dq_count += 1;
 
-		index = fileio->b.index;
+		fileio->cur_index = index = fileio->b.index;
 		buf = &fileio->bufs[index];
 
 		/*
@@ -2529,8 +2551,20 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		buf->queued = 1;
 		buf->size = vb2_plane_size(q->bufs[index], 0);
 		fileio->q_count += 1;
-		if (fileio->index < q->num_buffers)
-			fileio->index++;
+		/*
+		 * If we are queuing up buffers for the first time, then
+		 * increase initial_index by one.
+		 */
+		if (fileio->initial_index < q->num_buffers)
+			fileio->initial_index++;
+		/*
+		 * The next buffer to use is either a buffer that's going to be
+		 * queued for the first time (initial_index < q->num_buffers)
+		 * or it is equal to q->num_buffers, meaning that the next
+		 * time we need to dequeue a buffer since we've now queued up
+		 * all the 'first time' buffers.
+		 */
+		fileio->cur_index = fileio->initial_index;
 	}
 
 	/*
-- 
1.9.rc1

