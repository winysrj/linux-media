Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3901 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaBNKlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 05:41:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 08/11] vb2: q->num_buffers was updated too soon
Date: Fri, 14 Feb 2014 11:41:09 +0100
Message-Id: <1392374472-18393-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl>
References: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In __reqbufs() and __create_bufs() the q->num_buffers field was updated
with the number of newly allocated buffers, but right after that those are
freed again if some error had occurred before. Move the line updating
num_buffers to *after* that error check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ad3db83..96c5ac6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -848,13 +848,13 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 */
 	}
 
-	q->num_buffers = allocated_buffers;
-
 	if (ret < 0) {
 		__vb2_queue_free(q, allocated_buffers);
 		return ret;
 	}
 
+	q->num_buffers = allocated_buffers;
+
 	/*
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
@@ -957,13 +957,13 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 */
 	}
 
-	q->num_buffers += allocated_buffers;
-
 	if (ret < 0) {
 		__vb2_queue_free(q, allocated_buffers);
 		return -ENOMEM;
 	}
 
+	q->num_buffers += allocated_buffers;
+
 	/*
 	 * Return the number of successfully allocated buffers
 	 * to the userspace.
-- 
1.8.4.rc3

