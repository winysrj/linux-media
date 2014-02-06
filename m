Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3663 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaBFLDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 06:03:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [RFCv2 PATCH 06/10] vb2: fix read/write regression
Date: Thu,  6 Feb 2014 12:02:30 +0100
Message-Id: <1391684554-37956-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391684554-37956-1-git-send-email-hverkuil@xs4all.nl>
References: <1391684554-37956-1-git-send-email-hverkuil@xs4all.nl>
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
index 7766bf5..a3b4b4c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2418,6 +2418,7 @@ struct vb2_fileio_data {
 	struct v4l2_requestbuffers req;
 	struct v4l2_buffer b;
 	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+	unsigned int buf_index;
 	unsigned int index;
 	unsigned int q_count;
 	unsigned int dq_count;
@@ -2519,6 +2520,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			fileio->bufs[i].queued = 1;
 		}
 		fileio->index = q->num_buffers;
+		fileio->buf_index = q->num_buffers;
 	}
 
 	/*
@@ -2597,7 +2599,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	/*
 	 * Check if we need to dequeue the buffer.
 	 */
-	index = fileio->index;
+	index = fileio->buf_index;
 	if (index >= q->num_buffers) {
 		/*
 		 * Call vb2_dqbuf to get buffer back.
@@ -2611,7 +2613,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			return ret;
 		fileio->dq_count += 1;
 
-		index = fileio->b.index;
+		fileio->buf_index = index = fileio->b.index;
 		buf = &fileio->bufs[index];
 
 		/*
@@ -2689,6 +2691,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->q_count += 1;
 		if (fileio->index < q->num_buffers)
 			fileio->index++;
+		fileio->buf_index = fileio->index;
 	}
 
 	/*
-- 
1.8.5.2

