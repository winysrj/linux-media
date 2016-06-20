Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36344 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbcFTNG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 09:06:59 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 2/4] vb2: Merge vb2_internal_dqbuf and vb2_dqbuf
Date: Mon, 20 Jun 2016 14:47:23 +0200
Message-Id: <1466426845-25673-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1466426845-25673-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1466426845-25673-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After all the code refactoring, vb2_internal_dqbuf is only called by
vb2_dqbuf.

Since the function it is very simple, there is no need to have two
functions.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 39 ++++++++++++++------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 6d14df3d615d..7dff2b688a9f 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -621,27 +621,6 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
-		bool nonblocking)
-{
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	ret = vb2_core_dqbuf(q, NULL, b, nonblocking);
-
-	/*
-	 *  After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
-	 *  cleared.
-	 */
-	b->flags &= ~V4L2_BUF_FLAG_DONE;
-
-	return ret;
-}
-
 /**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
@@ -665,11 +644,27 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
+	int ret;
+
 	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_dqbuf(q, b, nonblocking);
+
+	if (b->type != q->type) {
+		dprintk(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	ret = vb2_core_dqbuf(q, NULL, b, nonblocking);
+
+	/*
+	 *  After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
+	 *  cleared.
+	 */
+	b->flags &= ~V4L2_BUF_FLAG_DONE;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
-- 
2.8.1

