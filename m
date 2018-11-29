Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59757 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbeK2Uez (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 15:34:55 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] videodev2.h: add
 V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF/CREATE_BUFS
Message-ID: <aa86ac25-de04-a205-053c-82a8f939b7e6@xs4all.nl>
Date: Thu, 29 Nov 2018 10:30:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new buffer capability flags to indicate if the VIDIOC_PREPARE_BUF or
VIDIOC_CREATE_BUFS ioctls are supported.

The reason for this is that there is currently no way for an application
to detect if VIDIOC_PREPARE_BUF is implemented other than trying it, but
then the buffer is already prepared. You would like to know this before
taking an irreversible action.

Since we need V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF it makes sense to add
V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS as well because not all drivers support
this ioctl.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v1:

- rebased
- improved commit msg
- added missing include for media/v4l2-ioctl.h
---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst |  8 ++++++++
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 15 +++++++++++++--
 include/uapi/linux/videodev2.h                  | 12 +++++++-----
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index e62a15782790..092d6373380a 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -118,6 +118,8 @@ aborting or finishing any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
 .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
+.. _V4L2-BUF-CAP-SUPPORTS-PREPARE-BUF:
+.. _V4L2-BUF-CAP-SUPPORTS-CREATE-BUFS:

 .. cssclass:: longtable

@@ -143,6 +145,12 @@ aborting or finishing any DMA in progress, an implicit
       - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
         mapped or exported via DMABUF. These orphaned buffers will be freed
         when they are unmapped or when the exported DMABUF fds are closed.
+    * - ``V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF``
+      - 0x00000020
+      - This buffer type supports :ref:`VIDIOC_PREPARE_BUF`.
+    * - ``V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS``
+      - 0x00000040
+      - This buffer type supports :ref:`VIDIOC_CREATE_BUFS`.

 Return Value
 ============
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c4..5273f574fb7a 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -28,6 +28,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>

 #include <media/videobuf2-v4l2.h>
@@ -870,6 +871,16 @@ static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *fil
 	return vdev->queue->owner && vdev->queue->owner != file->private_data;
 }

+static void fill_buf_caps_vdev(struct video_device *vdev, u32 *caps)
+{
+	*caps = 0;
+	fill_buf_caps(vdev->queue, caps);
+	if (vdev->ioctl_ops->vidioc_prepare_buf)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF;
+	if (vdev->ioctl_ops->vidioc_create_bufs)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS;
+}
+
 /* vb2 ioctl helpers */

 int vb2_ioctl_reqbufs(struct file *file, void *priv,
@@ -878,7 +889,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);

-	fill_buf_caps(vdev->queue, &p->capabilities);
+	fill_buf_caps_vdev(vdev, &p->capabilities);
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
@@ -900,7 +911,7 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			p->format.type);

 	p->index = vdev->queue->num_buffers;
-	fill_buf_caps(vdev->queue, &p->capabilities);
+	fill_buf_caps_vdev(vdev, &p->capabilities);
 	/*
 	 * If count == 0, then just check if memory and type are valid.
 	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2a223835214c..8ebc66e311e0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -875,11 +875,13 @@ struct v4l2_requestbuffers {
 };

 /* capabilities for struct v4l2_requestbuffers and v4l2_create_buffers */
-#define V4L2_BUF_CAP_SUPPORTS_MMAP	(1 << 0)
-#define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
-#define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
-#define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
-#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
+#define V4L2_BUF_CAP_SUPPORTS_MMAP		(1 << 0)
+#define V4L2_BUF_CAP_SUPPORTS_USERPTR		(1 << 1)
+#define V4L2_BUF_CAP_SUPPORTS_DMABUF		(1 << 2)
+#define V4L2_BUF_CAP_SUPPORTS_REQUESTS		(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS	(1 << 4)
+#define V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF	(1 << 5)
+#define V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS	(1 << 6)

 /**
  * struct v4l2_plane - plane info for multi-planar buffers
-- 
2.19.1
