Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38747 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751144Ab2KOWGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [PATCH 4/4] v4l: Tell user space we're using monotonic timestamps
Date: Fri, 16 Nov 2012 00:06:47 +0200
Message-Id: <1353017207-370-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set buffer timestamp flags for videobuf, videobuf2 and drivers that use
neither.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/pci/meye/meye.c                 |    4 ++--
 drivers/media/pci/zoran/zoran_driver.c        |    2 +-
 drivers/media/platform/omap3isp/ispqueue.c    |    1 +
 drivers/media/platform/vino.c                 |    3 +++
 drivers/media/usb/cpia2/cpia2_v4l.c           |    5 ++++-
 drivers/media/usb/sn9c102/sn9c102_core.c      |    2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c      |    1 +
 drivers/media/usb/usbvision/usbvision-video.c |    5 +++--
 drivers/media/v4l2-core/videobuf-core.c       |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c      |   10 ++++++----
 10 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 288adea..ac7ab6e 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1426,7 +1426,7 @@ static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		return -EINVAL;
 
 	buf->bytesused = meye.grab_buffer[index].size;
-	buf->flags = V4L2_BUF_FLAG_MAPPED;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
 	if (meye.grab_buffer[index].state == MEYE_BUF_USING)
 		buf->flags |= V4L2_BUF_FLAG_QUEUED;
@@ -1499,7 +1499,7 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 
 	buf->index = reqnr;
 	buf->bytesused = meye.grab_buffer[reqnr].size;
-	buf->flags = V4L2_BUF_FLAG_MAPPED;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	buf->field = V4L2_FIELD_NONE;
 	buf->timestamp = meye.grab_buffer[reqnr].timestamp;
 	buf->sequence = meye.grab_buffer[reqnr].sequence;
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 53f12c7..33521a4 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1334,7 +1334,7 @@ static int zoran_v4l2_buffer_status(struct zoran_fh *fh,
 	struct zoran *zr = fh->zr;
 	unsigned long flags;
 
-	buf->flags = V4L2_BUF_FLAG_MAPPED;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 15bf3ea..6599963 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -674,6 +674,7 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
 		buf->vbuf.index = i;
 		buf->vbuf.length = size;
 		buf->vbuf.type = queue->type;
+		buf->vbuf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		buf->vbuf.field = V4L2_FIELD_NONE;
 		buf->vbuf.memory = memory;
 
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index 28350e7..eb5d6f9 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -3410,6 +3410,9 @@ static void vino_v4l2_get_buffer_status(struct vino_channel_settings *vcs,
 	if (fb->map_count > 0)
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
+	b->flags &= ~V4L2_BUF_FLAG_TIMESTAMP_MASK;
+	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
 	b->index = fb->id;
 	b->memory = (vcs->fb_queue.type == VINO_MEMORY_MMAP) ?
 		V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index aeb9d22..d5d42b6 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -825,6 +825,8 @@ static int cpia2_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	else
 		buf->flags = 0;
 
+	buf->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
 	switch (cam->buffers[buf->index].status) {
 	case FRAME_EMPTY:
 	case FRAME_ERROR:
@@ -943,7 +945,8 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 
 	buf->index = frame;
 	buf->bytesused = cam->buffers[buf->index].length;
-	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE
+		| V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	buf->field = V4L2_FIELD_NONE;
 	buf->timestamp = cam->buffers[buf->index].timestamp;
 	buf->sequence = cam->buffers[buf->index].seq;
diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
index 843fadc..2e0e2ff 100644
--- a/drivers/media/usb/sn9c102/sn9c102_core.c
+++ b/drivers/media/usb/sn9c102/sn9c102_core.c
@@ -173,7 +173,7 @@ sn9c102_request_buffers(struct sn9c102_device* cam, u32 count,
 		cam->frame[i].buf.sequence = 0;
 		cam->frame[i].buf.field = V4L2_FIELD_NONE;
 		cam->frame[i].buf.memory = V4L2_MEMORY_MMAP;
-		cam->frame[i].buf.flags = 0;
+		cam->frame[i].buf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	}
 
 	return cam->nbuffers;
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c22a4d0..459ebc6 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -470,6 +470,7 @@ static int stk_setup_siobuf(struct stk_camera *dev, int index)
 	buf->dev = dev;
 	buf->v4lbuf.index = index;
 	buf->v4lbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf->v4lbuf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	buf->v4lbuf.field = V4L2_FIELD_NONE;
 	buf->v4lbuf.memory = V4L2_MEMORY_MMAP;
 	buf->v4lbuf.m.offset = 2*index*buf->v4lbuf.length;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 5c36a57..c6bc8ce 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -761,7 +761,7 @@ static int vidioc_querybuf(struct file *file,
 	if (vb->index >= usbvision->num_frames)
 		return -EINVAL;
 	/* Updating the corresponding frame state */
-	vb->flags = 0;
+	vb->flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	frame = &usbvision->frame[vb->index];
 	if (frame->grabstate >= frame_state_ready)
 		vb->flags |= V4L2_BUF_FLAG_QUEUED;
@@ -843,7 +843,8 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *vb)
 	vb->memory = V4L2_MEMORY_MMAP;
 	vb->flags = V4L2_BUF_FLAG_MAPPED |
 		V4L2_BUF_FLAG_QUEUED |
-		V4L2_BUF_FLAG_DONE;
+		V4L2_BUF_FLAG_DONE |
+		V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vb->index = f->index;
 	vb->sequence = f->sequence;
 	vb->timestamp = f->timestamp;
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index bf7a326..e98db7e 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -337,7 +337,7 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 		break;
 	}
 
-	b->flags    = 0;
+	b->flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	if (vb->map)
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 432df11..19a5866 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -40,9 +40,10 @@ module_param(debug, int, 0644);
 #define call_qop(q, op, args...)					\
 	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
 
-#define V4L2_BUFFER_STATE_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
+#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
 				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
-				 V4L2_BUF_FLAG_PREPARED)
+				 V4L2_BUF_FLAG_PREPARED | \
+				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
@@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	/*
 	 * Clear any buffer state related flags.
 	 */
-	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
+	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
+	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_QUEUED:
@@ -863,7 +865,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
 	vb->v4l2_buf.field = b->field;
 	vb->v4l2_buf.timestamp = b->timestamp;
-	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_STATE_FLAGS;
+	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
 }
 
 /**
-- 
1.7.2.5

