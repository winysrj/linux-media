Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:57075 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbeKTT0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 14:26:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videodev2.h: add
 V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF/CREATE_BUFS
Message-ID: <68a6a7d3-cf0b-f631-f113-e388ebb7f5a4@xs4all.nl>
Date: Tue, 20 Nov 2018 09:58:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new buffer capability flags to indicate if the VIDIOC_PREPARE_BUF or
VIDIOC_CREATE_BUFS ioctls are supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: the flag bits will change since there are two other patches that add
flags, so the numbering will change.
---
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index d4bbbb0c60e8..abf925484aff 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -112,6 +112,8 @@ any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-USERPTR:
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
+.. _V4L2-BUF-CAP-SUPPORTS-PREPARE-BUF:
+.. _V4L2-BUF-CAP-SUPPORTS-CREATE-BUFS:

 .. cssclass:: longtable

@@ -132,6 +134,12 @@ any DMA in progress, an implicit
     * - ``V4L2_BUF_CAP_SUPPORTS_REQUESTS``
       - 0x00000008
       - This buffer type supports :ref:`requests <media-request-api>`.
+    * - ``V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF``
+      - 0x00000010
+      - This buffer type supports :ref:`VIDIOC_PREPARE_BUF`.
+    * - ``V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS``
+      - 0x00000020
+      - This buffer type supports :ref:`VIDIOC_CREATE_BUFS`.

 Return Value
 ============
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index a17033ab2c22..27c0fafca0bf 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -871,6 +871,16 @@ static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *fil
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
@@ -879,7 +889,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);

-	fill_buf_caps(vdev->queue, &p->capabilities);
+	fill_buf_caps_vdev(vdev, &p->capabilities);
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
@@ -901,7 +911,7 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			p->format.type);

 	p->index = vdev->queue->num_buffers;
-	fill_buf_caps(vdev->queue, &p->capabilities);
+	fill_buf_caps_vdev(vdev, &p->capabilities);
 	/*
 	 * If count == 0, then just check if memory and type are valid.
 	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..6648f8ba2277 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -879,6 +879,8 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_PREPARE_BUF	(1 << 4)
+#define V4L2_BUF_CAP_SUPPORTS_CREATE_BUFS	(1 << 5)

 /**
  * struct v4l2_plane - plane info for multi-planar buffers
