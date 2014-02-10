Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3596 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaBJKCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:02:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [REVIEW PATCH for 3.14 2/2] vb2: fix read/write regression
Date: Mon, 10 Feb 2014 11:01:49 +0100
Message-Id: <1392026509-48039-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392026509-48039-1-git-send-email-hverkuil@xs4all.nl>
References: <1392026509-48039-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Commit 88e268702bfba78448abd20a31129458707383aa ("vb2: Improve file I/O
emulation to handle buffers in any order") broke read/write support if
the size of the buffer being read/written is less than the size of the
image.

When the commit was tested originally I used qv4l2, which call read()
with exactly the size of the image. But if you try 'cat /dev/video0'
then it will fail and typically hang after reading two buffers.

This patch fixes the behavior by adding a new buf_index field that
contains the index of the field currently being filled/read, or it
is num_buffers in which case a new buffer needs to be dequeued.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/v4l2-core/videobuf2-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5a5fb7f..2adc4a9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2255,6 +2255,7 @@ struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
 	struct v4l2_buffer b;
 	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+	unsigned int buf_index;
 	unsigned int index;
 	unsigned int q_count;
 	unsigned int dq_count;
@@ -2356,6 +2357,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			fileio->bufs[i].queued = 1;
 		}
 		fileio->index = q->num_buffers;
+		fileio->buf_index = q->num_buffers;
 	}
 
 	/*
@@ -2434,7 +2436,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	/*
 	 * Check if we need to dequeue the buffer.
 	 */
-	index = fileio->index;
+	index = fileio->buf_index;
 	if (index >= q->num_buffers) {
 		/*
 		 * Call vb2_dqbuf to get buffer back.
@@ -2448,7 +2450,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			return ret;
 		fileio->dq_count += 1;
 
-		index = fileio->b.index;
+		fileio->buf_index = index = fileio->b.index;
 		buf = &fileio->bufs[index];
 
 		/*
@@ -2526,6 +2528,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->q_count += 1;
 		if (fileio->index < q->num_buffers)
 			fileio->index++;
+		fileio->buf_index = fileio->index;
 	}
 
 	/*
-- 
1.8.5.2

