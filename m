Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34066 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1DNH1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 03:27:39 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJM003VLSQ0JW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Apr 2011 08:27:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJM005H6SPZ9Y@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Apr 2011 08:27:36 +0100 (BST)
Date: Thu, 14 Apr 2011 09:27:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: fix incorrect v4l2_buffer->flags handling
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jonghun Han <jonghun.han@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1302766048-25305-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Videobuf2 core assumes that driver doesn't set any buffer flags.
This is correct for buffer state flags that videobuf2 manages,
but the other flags like V4L2_BUF_FLAG_{KEY,P,B}FRAME,
V4L2_BUF_FLAG_TIMECODE and V4L2_BUF_FLAG_INPUT should be passed from or to
the driver.

Reported-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6698c77..3ceacea 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -37,6 +37,9 @@ module_param(debug, int, 0644);
 #define call_qop(q, op, args...)					\
 	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
 
+#define V4L2_BUFFER_STATE_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
+				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR)
+
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
@@ -284,7 +287,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret = 0;
 
-	/* Copy back data such as timestamp, input, etc. */
+	/* Copy back data such as timestamp, flags, input, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
 	b->input = vb->v4l2_buf.input;
 	b->reserved = vb->v4l2_buf.reserved;
@@ -313,7 +316,10 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 			b->m.userptr = vb->v4l2_planes[0].m.userptr;
 	}
 
-	b->flags = 0;
+	/*
+	 * Clear any buffer state related flags.
+	 */
+	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_QUEUED:
@@ -715,6 +721,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b,
 
 	vb->v4l2_buf.field = b->field;
 	vb->v4l2_buf.timestamp = b->timestamp;
+	vb->v4l2_buf.input = b->input;
+	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_STATE_FLAGS;
 
 	return 0;
 }
-- 
1.7.1.569.g6f426
