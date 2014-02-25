Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1867 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBYJsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 10/14] vb2: don't init the list if there are still buffers
Date: Tue, 25 Feb 2014 10:48:23 +0100
Message-Id: <1393321707-9749-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

__vb2_queue_free() would init the queued_list at all times, even if
q->num_buffers > 0. This should only happen if num_buffers == 0.

This situation can happen if a CREATE_BUFFERS call couldn't allocate
enough buffers and had to free those it did manage to allocate before
returning an error.

While we're at it: __vb2_queue_alloc() returns the number of buffers
allocated, not an error code. So stick the result in allocated_buffers
instead of ret as that's very confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2a7815c..90374c0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -452,9 +452,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	}
 
 	q->num_buffers -= buffers;
-	if (!q->num_buffers)
+	if (!q->num_buffers) {
 		q->memory = 0;
-	INIT_LIST_HEAD(&q->queued_list);
+		INIT_LIST_HEAD(&q->queued_list);
+	}
 	return 0;
 }
 
@@ -820,14 +821,12 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	}
 
 	/* Finally, allocate buffers and video memory */
-	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
-	if (ret == 0) {
+	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
+	if (allocated_buffers == 0) {
 		dprintk(1, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	allocated_buffers = ret;
-
 	/*
 	 * Check if driver can handle the allocated number of buffers.
 	 */
@@ -851,6 +850,10 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	q->num_buffers = allocated_buffers;
 
 	if (ret < 0) {
+		/*
+		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
+		 * from q->num_buffers.
+		 */
 		__vb2_queue_free(q, allocated_buffers);
 		return ret;
 	}
@@ -924,20 +927,18 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	}
 
 	/* Finally, allocate buffers and video memory */
-	ret = __vb2_queue_alloc(q, create->memory, num_buffers,
+	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
 				num_planes);
-	if (ret == 0) {
+	if (allocated_buffers == 0) {
 		dprintk(1, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	allocated_buffers = ret;
-
 	/*
 	 * Check if driver can handle the so far allocated number of buffers.
 	 */
-	if (ret < num_buffers) {
-		num_buffers = ret;
+	if (allocated_buffers < num_buffers) {
+		num_buffers = allocated_buffers;
 
 		/*
 		 * q->num_buffers contains the total number of buffers, that the
@@ -960,6 +961,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	q->num_buffers += allocated_buffers;
 
 	if (ret < 0) {
+		/*
+		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
+		 * from q->num_buffers.
+		 */
 		__vb2_queue_free(q, allocated_buffers);
 		return -ENOMEM;
 	}
-- 
1.9.0

