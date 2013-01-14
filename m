Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab3ANJhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 04:37:10 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGM00E39018K3J0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jan 2013 18:36:51 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGM0003F00DON80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jan 2013 18:36:50 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, s.nawrocki@samsung.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/3] vb2: Add support for non monotonic timestamps
Date: Mon, 14 Jan 2013 10:36:03 +0100
Message-id: <1358156164-11382-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all drivers use monotonic timestamps. This patch adds a way to set the
timestamp type per every queue.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    5 +++--
 include/media/videobuf2-core.h           |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 85e3c22..c02472c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -403,7 +403,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	 * Clear any buffer state related flags.
 	 */
 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
-	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	b->flags |= q->timestamp_type;
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_QUEUED:
@@ -2032,7 +2032,8 @@ int vb2_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->type)		  ||
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue))
+	    WARN_ON(!q->ops->buf_queue)   ||
+	    WARN_ON(q->timestamp_type & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&q->queued_list);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 9cfd4ee..7ce4656 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -326,6 +326,7 @@ struct vb2_queue {
 	const struct vb2_mem_ops	*mem_ops;
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
+	u32	                   	timestamp_type;
 
 /* private: internal use only */
 	enum v4l2_memory		memory;
-- 
1.7.9.5

