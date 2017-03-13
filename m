Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34855 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753284AbdCMTVD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:21:03 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 07/10] [media] v4l: add support to BUF_QUEUED event
Date: Mon, 13 Mar 2017 16:20:32 -0300
Message-Id: <20170313192035.29859-8-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Implement the needed pieces to let userspace subscribe for
V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
DQEVENT ioctl.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
 drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b9e08e3..1be554b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3413,8 +3413,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
-	if (sub->type == V4L2_EVENT_CTRL)
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
 		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
+	case V4L2_EVENT_BUF_QUEUED:
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	}
 	return -EINVAL;
 }
 EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index e0e7109..d9cb777 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 
 #include <media/videobuf2-core.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-mc.h>
 
 #include <trace/events/vb2.h>
@@ -1221,6 +1222,18 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 	return ret;
 }
 
+static void vb2_buffer_queued_event(struct vb2_buffer *vb)
+{
+	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
+	struct v4l2_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.type = V4L2_EVENT_BUF_QUEUED;
+	event.u.buf_queued.index = vb->index;
+
+	v4l2_event_queue(vdev, &event);
+}
+
 /**
  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
  */
@@ -1239,6 +1252,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
 
 	call_void_vb_qop(vb, buf_queue, vb);
+
+	vb2_buffer_queued_event(vb);
 }
 
 static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
-- 
2.9.3
