Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55760 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbeKVWW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 17:22:59 -0500
To: stable@vger.kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.4] Revert "media: videobuf2-core: don't call memop
 'finish' when queueing"
Message-ID: <69b591d1-6a0c-92f0-4d02-491d62a3055e@xs4all.nl>
Date: Thu, 22 Nov 2018 12:43:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 46431d9c28f6859f8e568ac7db92137f1da31100.

This commit fixes a bug in upstream commit a136f59c0a1f ("vb2: Move
buffer cache synchronisation to prepare from queue") which isn't
present in 4.4.

So as a result you get an UNBALANCED message in the kernel log if
this patch is applied:

vb2:   counters for queue ffffffc0f3687478, buffer 3: UNBALANCED!
vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 805 buf_finish: 805
vb2:     buf_queue: 806 buf_done: 806
vb2:     alloc: 0 put: 0 prepare: 806 finish: 805 mmap: 0
vb2:     get_userptr: 0 put_userptr: 0
vb2:     attach_dmabuf: 1 detach_dmabuf: 1 map_dmabuf: 805 unmap_dmabuf: 805
vb2:     get_dmabuf: 0 num_users: 1609 vaddr: 0 cookie: 805

Reverting this patch solves this regression.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Probably two reasons why this slipped through:

1) The patch was missing a Fixes: tag
2) I was probably CC-ed about this when it was about to be added to 4.9
   but didn't realize that that was wrong.
---
 drivers/media/v4l2-core/videobuf2-core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1c37d5a..8ce9c63 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -870,12 +870,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);

-	if (state != VB2_BUF_STATE_QUEUED &&
-	    state != VB2_BUF_STATE_REQUEUEING) {
-		/* sync buffers */
-		for (plane = 0; plane < vb->num_planes; ++plane)
-			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-	}
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, finish, vb->planes[plane].mem_priv);

 	spin_lock_irqsave(&q->done_lock, flags);
 	if (state == VB2_BUF_STATE_QUEUED ||
-- 
2.10.2
