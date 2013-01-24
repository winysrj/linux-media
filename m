Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63411 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3AXMfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 07:35:42 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH400F8DQZCPTU0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 21:35:41 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH4006Z9QYLQC80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 21:35:41 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, verkuil@xs4all.nl, m.szyprowski@samsung.com,
	pawel@osciak.com, Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/3 v2] vb2: Add support for non monotonic timestamps
Date: Thu, 24 Jan 2013 13:35:06 +0100
Message-id: <1359030907-9883-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all drivers use monotonic timestamps. This patch adds a way to set the
timestamp type per every queue.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    8 ++++++--
 include/media/videobuf2-core.h           |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 85e3c22..b816689 100644
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
@@ -2032,9 +2032,13 @@ int vb2_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->type)		  ||
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue))
+	    WARN_ON(!q->ops->buf_queue)   ||
+	    WARN_ON(q->timestamp_type & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
 		return -EINVAL;
 
+	/* Warn that the driver should choose an appropriate timestamp type */
+	WARN_ON(q->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
+
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
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

