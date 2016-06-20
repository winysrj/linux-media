Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36207 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcFTJRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 05:17:30 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, Dimitrios Katsaros <patcherwork@gmail.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
Date: Mon, 20 Jun 2016 11:01:44 +0200
Message-Id: <1466413304-8328-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the doc, V4L2_BUF_FLAG_DONE is cleared after DQBUF:

V4L2_BUF_FLAG_DONE 0x00000004  ... After calling the VIDIOC_QBUF or
VIDIOC_DQBUF it is always cleared ...

Unfortunately, it seems that videobuf2 keeps it set after DQBUF. This
can be tested with vivid and dev_debug:

[257604.338082] video1: VIDIOC_DQBUF: 71:33:25.00260479 index=3,
type=vid-cap, flags=0x00002004, field=none, sequence=163,
memory=userptr, bytesused=460800, offset/userptr=0x344b000,
length=460800

This patch changes the order when fill_user_buffer() is called,
to follow the documentation.

Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 633fc1ab1d7a..63981f28075e 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1771,10 +1771,6 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	if (pindex)
 		*pindex = vb->index;
 
-	/* Fill buffer information for the userspace */
-	if (pb)
-		call_void_bufop(q, fill_user_buffer, vb, pb);
-
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
@@ -1784,6 +1780,10 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
+	/* Fill buffer information for the userspace */
+	if (pb)
+		call_void_bufop(q, fill_user_buffer, vb, pb);
+
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 			vb->index, vb->state);
 
-- 
2.8.1

