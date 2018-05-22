Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48413 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751174AbeEVIOy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/5] videobuf2-core: don't call memop 'finish' when queueing
Date: Tue, 22 May 2018 10:14:47 +0200
Message-Id: <20180522081451.94794-2-hverkuil@xs4all.nl>
In-Reply-To: <20180522081451.94794-1-hverkuil@xs4all.nl>
References: <20180522081451.94794-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When a buffer is queued or requeued in vb2_buffer_done, then don't
call the finish memop. In this case the buffer is only returned to vb2,
not to userspace.

Calling 'finish' here will cause an unbalance when the queue is
canceled, since the core will call the same memop again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb33a54d..f32ec7342ef0 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -916,9 +916,12 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+	if (state != VB2_BUF_STATE_QUEUED &&
+	    state != VB2_BUF_STATE_REQUEUEING) {
+		/* sync buffers */
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+	}
 
 	spin_lock_irqsave(&q->done_lock, flags);
 	if (state == VB2_BUF_STATE_QUEUED ||
-- 
2.17.0
