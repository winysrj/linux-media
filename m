Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1606 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaBYJs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 12/14] vb2: properly clean up PREPARED and QUEUED buffers
Date: Tue, 25 Feb 2014 10:48:25 +0100
Message-Id: <1393321707-9749-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In queue_cancel we need to call the finish memop for any pending
buffers in the PREPARED or QUEUED state.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f156475..93b7969 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1937,6 +1937,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
  */
 static void __vb2_queue_cancel(struct vb2_queue *q)
 {
+	unsigned int plane;
 	unsigned int i;
 
 	/*
@@ -1949,10 +1950,23 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	q->start_streaming_called = 0;
 	q->queued_count = 0;
 
+	for (i = 0; i < q->num_buffers; ++i) {
+		struct vb2_buffer *vb = q->bufs[i];
+
+		if (vb->state == VB2_BUF_STATE_PREPARED || vb->state == VB2_BUF_STATE_QUEUED)
+			for (plane = 0; plane < vb->num_planes; ++plane)
+				call_memop(vb, finish, vb->planes[plane].mem_priv);
+	}
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
-		for (i = 0; i < q->num_buffers; ++i)
-			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+		for (i = 0; i < q->num_buffers; ++i) {
+			struct vb2_buffer *vb = q->bufs[i];
+
+			if (vb->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			else if (vb->state == VB2_BUF_STATE_PREPARED)
+				for (plane = 0; plane < vb->num_planes; ++plane)
+					call_memop(vb, finish, vb->planes[plane].mem_priv);
+		}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
-- 
1.9.0

