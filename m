Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:32982 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbcFTMcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 08:32:47 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 2/4] vb2: Merge vb2_internal_qbuf and vb2_qbuf
Date: Mon, 20 Jun 2016 14:30:07 +0200
Message-Id: <1466425809-23469-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1466425809-23469-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1466425809-23469-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After all the code refactoring, vb2_internal_dqbuf is only called by
vb2_dqbuf.

Since the function it is very simple, there is no need to have
two functions.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 07d8b409ce05..ba3467468e55 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -427,7 +427,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_internal_qbuf().
+		 * this will be handled later in vb2_qbuf().
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
@@ -586,13 +586,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
-static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
-}
-
 /**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
@@ -612,12 +605,15 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	int ret;
+
 	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
 
-	return vb2_internal_qbuf(q, b);
+	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+	return ret ? ret : vb2_core_qbuf(q, b->index, b);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
-- 
2.8.1

