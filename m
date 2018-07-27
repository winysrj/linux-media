Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34537 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbeG0Jmg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 05:42:36 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20180727082148epoutp013b9ef7c41cee33cc944ca8e87eae913c~FLBMFhIft2073820738epoutp013
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 08:21:48 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vineet.j@samsung.com, hemanshu.s@samsung.com, sst2005@gmail.com
Subject: [PATCH] videobuf2/vb2_buffer_done: Changing the position of
 spinlock to protect only the required code
Date: Fri, 27 Jul 2018 13:51:36 +0530
Message-Id: <20180727082146epcas5p10374c04f0767dbbe409c8171c49d7c9a~FLBKL7utW2249922499epcas5p1c@epcas5p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20180727082146epcas5p10374c04f0767dbbe409c8171c49d7c9a@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1.Currently, in the func vb2_buffer_done, spinlock protects
following code
vb->state = VB2_BUF_STATE_QUEUED;
list_add_tail(&vb->done_entry, &q->done_list);
spin_unlock_irqrestore(&q->done_lock, flags);
vb->state = state;
atomic_dec(&q->owned_by_drv_count);
2.The spinlock is mainly needed to protect list related ops and
vb->state = STATE_ERROR or STATE_DONE as in other funcs
vb2_discard_done
__vb2_get_done_vb
vb2_core_poll.
3. Therefore, spinlock is mainly needed for
   list_add, list_del, list_first_entry ops
   and state = STATE_DONE and STATE_ERROR to protect
   done_list queue.
3. Hence, state = STATE_QUEUED doesn't need spinlock protection.
4. Also atomic_dec dones't require the same as its already atomic.

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f32ec73..968b403 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -923,17 +923,17 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
 	}
 
-	spin_lock_irqsave(&q->done_lock, flags);
 	if (state == VB2_BUF_STATE_QUEUED ||
 	    state == VB2_BUF_STATE_REQUEUEING) {
 		vb->state = VB2_BUF_STATE_QUEUED;
 	} else {
 		/* Add the buffer to the done buffers list */
+		spin_lock_irqsave(&q->done_lock, flags);
 		list_add_tail(&vb->done_entry, &q->done_list);
 		vb->state = state;
+		spin_unlock_irqrestore(&q->done_lock, flags);
 	}
 	atomic_dec(&q->owned_by_drv_count);
-	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	trace_vb2_buf_done(q, vb);
 
-- 
2.7.4
