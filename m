Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33561 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbeHXLzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:55:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 4/5] videodev2.h: add new capabilities for buffer types
Date: Fri, 24 Aug 2018 10:21:55 +0200
Message-Id: <20180824082156.6986-5-hverkuil@xs4all.nl>
In-Reply-To: <20180824082156.6986-1-hverkuil@xs4all.nl>
References: <20180824082156.6986-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

VIDIOC_REQBUFS and VIDIOC_CREATE_BUFFERS will return capabilities
telling userspace what the given buffer type is capable of.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 .../media/uapi/v4l/vidioc-create-bufs.rst     | 10 +++++-
 .../media/uapi/v4l/vidioc-reqbufs.rst         | 36 ++++++++++++++++++-
 include/uapi/linux/videodev2.h                | 13 +++++--
 3 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index a39e18d69511..fd34d3f236c9 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -102,7 +102,15 @@ than the number requested.
       - ``format``
       - Filled in by the application, preserved by the driver.
     * - __u32
-      - ``reserved``\ [8]
+      - ``capabilities``
+      - Set by the driver. If 0, then the driver doesn't support
+        capabilities. In that case all you know is that the driver is
+	guaranteed to support ``V4L2_MEMORY_MMAP`` and *might* support
+	other :c:type:`v4l2_memory` types. It will not support any others
+	capabilities. See :ref:`here <v4l2-buf-capabilities>` for a list of the
+	capabilities.
+    * - __u32
+      - ``reserved``\ [7]
       - A place holder for future extensions. Drivers and applications
 	must set the array to zero.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 316f52c8a310..20a4bd4f2b74 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -88,10 +88,44 @@ any DMA in progress, an implicit
 	``V4L2_MEMORY_DMABUF`` or ``V4L2_MEMORY_USERPTR``. See
 	:c:type:`v4l2_memory`.
     * - __u32
-      - ``reserved``\ [2]
+      - ``capabilities``
+      - Set by the driver. If 0, then the driver doesn't support
+        capabilities. In that case all you know is that the driver is
+	guaranteed to support ``V4L2_MEMORY_MMAP`` and *might* support
+	other :c:type:`v4l2_memory` types. It will not support any others
+	capabilities.
+    * - __u32
+      - ``reserved``\ [1]
       - A place holder for future extensions. Drivers and applications
 	must set the array to zero.
 
+.. tabularcolumns:: |p{6.1cm}|p{2.2cm}|p{8.7cm}|
+
+.. _v4l2-buf-capabilities:
+.. _V4L2-BUF-CAP-SUPPORTS-MMAP:
+.. _V4L2-BUF-CAP-SUPPORTS-USERPTR:
+.. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
+.. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
+
+.. cssclass:: longtable
+
+.. flat-table:: V4L2 Buffer Capabilities Flags
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * - ``V4L2_BUF_CAP_SUPPORTS_MMAP``
+      - 0x00000001
+      - This buffer type supports the ``V4L2_MEMORY_MMAP`` streaming mode.
+    * - ``V4L2_BUF_CAP_SUPPORTS_USERPTR``
+      - 0x00000002
+      - This buffer type supports the ``V4L2_MEMORY_USERPTR`` streaming mode.
+    * - ``V4L2_BUF_CAP_SUPPORTS_DMABUF``
+      - 0x00000004
+      - This buffer type supports the ``V4L2_MEMORY_DMABUF`` streaming mode.
+    * - ``V4L2_BUF_CAP_SUPPORTS_REQUESTS``
+      - 0x00000008
+      - This buffer type supports :ref:`requests <media-request-api>`.
 
 Return Value
 ============
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 91126b7312f8..490fc9964d97 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -856,9 +856,16 @@ struct v4l2_requestbuffers {
 	__u32			count;
 	__u32			type;		/* enum v4l2_buf_type */
 	__u32			memory;		/* enum v4l2_memory */
-	__u32			reserved[2];
+	__u32			capabilities;
+	__u32			reserved[1];
 };
 
+/* capabilities for struct v4l2_requestbuffers and v4l2_create_buffers */
+#define V4L2_BUF_CAP_SUPPORTS_MMAP	(1 << 0)
+#define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
+#define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
+#define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
  * @bytesused:		number of bytes occupied by data in the plane (payload)
@@ -2312,6 +2319,7 @@ struct v4l2_dbg_chip_info {
  *		return: number of created buffers
  * @memory:	enum v4l2_memory; buffer memory type
  * @format:	frame format, for which buffers are requested
+ * @capabilities: capabilities of this buffer type.
  * @reserved:	future extensions
  */
 struct v4l2_create_buffers {
@@ -2319,7 +2327,8 @@ struct v4l2_create_buffers {
 	__u32			count;
 	__u32			memory;
 	struct v4l2_format	format;
-	__u32			reserved[8];
+	__u32			capabilities;
+	__u32			reserved[7];
 };
 
 /*
-- 
2.18.0
