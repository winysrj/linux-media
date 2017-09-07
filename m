Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35295 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755950AbdIGSnE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:43:04 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 09/15] [media] v4l: add support to BUF_QUEUED event
Date: Thu,  7 Sep 2017 15:42:20 -0300
Message-Id: <20170907184226.27482-10-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Implement the needed pieces to let userspace subscribe for
V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
DQEVENT ioctl.

v3:	- Do not call v4l2 event API from vb2 (Mauro)

v2:	- Use VIDEO_MAX_FRAME to allocate room for events at
	v4l2_event_subscribe() (Hans)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
 drivers/media/v4l2-core/videobuf2-core.c |  2 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 14 ++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index dd1db678718c..17d4b9e3eec6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3438,8 +3438,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
-	if (sub->type == V4L2_EVENT_CTRL)
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
 		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
+	case V4L2_EVENT_BUF_QUEUED:
+		return v4l2_event_subscribe(fh, sub, VIDEO_MAX_FRAME, NULL);
+	}
 	return -EINVAL;
 }
 EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b19c1bc4b083..bbbae0eed567 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1231,6 +1231,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	trace_vb2_buf_queue(q, vb);
 
 	call_void_vb_qop(vb, buf_queue, vb);
+
+	call_void_bufop(q, buffer_queued, vb);
 }
 
 static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 8c322cd1b346..bbfcd054e6f6 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -138,6 +138,19 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 	}
 };
 
+static void __buffer_queued(struct vb2_buffer *vb)
+{
+	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
+	struct v4l2_fh *fh = vdev->queue->owner;
+	struct v4l2_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.type = V4L2_EVENT_BUF_QUEUED;
+	event.u.buf_queued.index = vb->index;
+
+	v4l2_event_queue_fh(fh, &event);
+}
+
 static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 {
 	static bool check_once;
@@ -455,6 +468,7 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.fill_user_buffer	= __fill_v4l2_buffer,
 	.fill_vb2_buffer	= __fill_vb2_buffer,
 	.copy_timestamp		= __copy_timestamp,
+	.buffer_queued		= __buffer_queued,
 };
 
 /**
-- 
2.13.5
