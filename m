Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44348 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbeEURBy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:01:54 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 06/16] vb2: add is_unordered callback for drivers
Date: Mon, 21 May 2018 13:59:36 -0300
Message-Id: <20180521165946.11778-7-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Explicit synchronization benefits a lot from ordered queues, they fit
better in a pipeline with DRM for example so create a opt-in way for
drivers notify videobuf2 that the queue is unordered.

Drivers don't need implement it if the queue is ordered.

v5: rename it to vb2_ops_is_unordered() (Hans Verkuil)

v4: go back to a bitfield property for the unordered property.

v3: - make it bool (Hans)
    - create vb2_ops_set_unordered() helper

v2: - improve comments for is_unordered flag (Hans Verkuil)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c |  6 ++++++
 include/media/videobuf2-core.h                  | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 61e7b6407586..a9a0a9d1decb 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -691,6 +691,12 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
 }
 EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
 
+bool vb2_ops_is_unordered(struct vb2_queue *q)
+{
+	return true;
+}
+EXPORT_SYMBOL_GPL(vb2_ops_is_unordered);
+
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 137f72702101..71538ae2c255 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -376,6 +376,10 @@ struct vb2_buffer {
  *			callback by calling vb2_buffer_done() with either
  *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
+ * @is_unordered:	tell if the queue is unordered, i.e. buffers can be
+ *			dequeued in a different order from how they were queued.
+ *			The default is assumed to be ordered and this function
+ *			only needs to be implemented for unordered queues.
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
@@ -399,6 +403,7 @@ struct vb2_ops {
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	void (*stop_streaming)(struct vb2_queue *q);
+	bool (*is_unordered)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
@@ -421,6 +426,16 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
  */
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
+/**
+ * vb2_ops_is_unordered - helper function to check if queue is unordered
+ *
+ * @vq: pointer to &struct vb2_queue
+ *
+ * This helper just returns true to notify that the driver can't deal with
+ * ordered queues.
+ */
+bool vb2_ops_is_unordered(struct vb2_queue *q);
+
 /**
  * struct vb2_buf_ops - driver-specific callbacks.
  *
@@ -590,6 +605,7 @@ struct vb2_queue {
 	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
 	u32				cnt_stop_streaming;
+	u32				cnt_is_unordered;
 #endif
 };
 
-- 
2.16.3
