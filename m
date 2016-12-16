Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50175 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757087AbcLPBX6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 20:23:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC v2 03/11] vb2: Move cache synchronisation from buffer done to dqbuf handler
Date: Fri, 16 Dec 2016 03:24:17 +0200
Message-Id: <20161216012425.11179-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The cache synchronisation may be a time consuming operation and thus not
best performed in an interrupt which is a typical context for
vb2_buffer_done() calls. This may consume up to tens of ms on some
machines, depending on the buffer size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v1:

- Don't rename the 'i' loop counter to 'plane'
---
 drivers/media/v4l2-core/videobuf2-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8ba48703b189..15a83f338072 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -889,7 +889,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
-	unsigned int plane;
 
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
@@ -910,10 +909,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-
 	spin_lock_irqsave(&q->done_lock, flags);
 	if (state == VB2_BUF_STATE_QUEUED ||
 	    state == VB2_BUF_STATE_REQUEUEING) {
@@ -1571,6 +1566,10 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
+	/* sync buffers */
+	for (i = 0; i < vb->num_planes; ++i)
+		call_void_memop(vb, finish, vb->planes[i].mem_priv);
+
 	/* unmap DMABUF buffer */
 	if (q->memory == VB2_MEMORY_DMABUF)
 		for (i = 0; i < vb->num_planes; ++i) {
-- 
Regards,

Laurent Pinchart

