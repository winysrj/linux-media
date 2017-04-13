Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11521 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdDMH6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 04/14] v4l: Unify cache management hint buffer flags
Date: Thu, 13 Apr 2017 10:57:09 +0300
Message-Id: <1492070239-21532-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_BUF_FLAG_NO_CACHE_INVALIDATE and V4L2_BUF_FLAG_NO_CACHE_CLEAN
buffer flags are currently not used by the kernel. Replace the definitions
by a single V4L2_BUF_FLAG_NO_CACHE_SYNC flag to be used by further
patches.

Different cache architectures should not be visible to the user space
which can make no meaningful use of the differences anyway. In case a
device can make use of non-coherent memory accesses, the necessary cache
operations depend on the CPU architecture and the buffer type, not the
requests of the user. The cache operation itself may be skipped on the
user's request which was the purpose of the two flags.

On ARM the invalidate and clean are separate operations whereas on
x86(-64) the two are a single operation (flush). Whether the hardware uses
the buffer for reading (V4L2_BUF_TYPE_*_OUTPUT*) or writing
(V4L2_BUF_TYPE_*CAPTURE*) already defines the required cache operation
(clean and invalidate, respectively). No user input is required.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/buffer.rst            | 24 ++++++++--------------
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |  5 ++---
 include/trace/events/v4l2.h                        |  3 +--
 include/uapi/linux/videodev2.h                     |  7 +++++--
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index ac58966..601c3e9 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -437,23 +437,17 @@ Buffer Flags
 	:ref:`VIDIOC_PREPARE_BUF <VIDIOC_QBUF>`,
 	:ref:`VIDIOC_QBUF` or
 	:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called.
-    * .. _`V4L2-BUF-FLAG-NO-CACHE-INVALIDATE`:
+    * .. _`V4L2-BUF-FLAG-NO-CACHE-SYNC`:
 
-      - ``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE``
+      - ``V4L2_BUF_FLAG_NO_CACHE_SYNC``
       - 0x00000800
-      - Caches do not have to be invalidated for this buffer. Typically
-	applications shall use this flag if the data captured in the
-	buffer is not going to be touched by the CPU, instead the buffer
-	will, probably, be passed on to a DMA-capable hardware unit for
-	further processing or output.
-    * .. _`V4L2-BUF-FLAG-NO-CACHE-CLEAN`:
-
-      - ``V4L2_BUF_FLAG_NO_CACHE_CLEAN``
-      - 0x00001000
-      - Caches do not have to be cleaned for this buffer. Typically
-	applications shall use this flag for output buffers if the data in
-	this buffer has not been created by the CPU but by some
-	DMA-capable unit, in which case caches have not been used.
+      - Do not perform CPU cache synchronisation operations when the buffer is
+	queued or dequeued. The user is responsible for the correct use of
+	this flag. It should be only used when the buffer is not accessed
+	using the CPU, e.g. the buffer is written to by a hardware block and
+	then read by another one, in which case the flag should be set in both
+	:ref:`VIDIOC_QBUF` and :ref:`VIDIOC_DQBUF` ioctls. The flag has no
+	effect on some devices / architectures.
     * .. _`V4L2-BUF-FLAG-LAST`:
 
       - ``V4L2_BUF_FLAG_LAST``
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index bdcfd9f..80aeb7e 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -36,9 +36,8 @@ pass ownership of the buffer to the driver before actually enqueuing it,
 using the :ref:`VIDIOC_QBUF` ioctl, and to prepare it for future I/O. Such
 preparations may include cache invalidation or cleaning. Performing them
 in advance saves time during the actual I/O. In case such cache
-operations are not required, the application can use one of
-``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE`` and
-``V4L2_BUF_FLAG_NO_CACHE_CLEAN`` flags to skip the respective step.
+operations are not required, the application can use the
+``V4L2_BUF_FLAG_NO_CACHE_SYNC`` flag to skip the cache synchronization step.
 
 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index ee7754c..fb9ad7b 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -80,8 +80,7 @@ SHOW_FIELD
 		{ V4L2_BUF_FLAG_ERROR,		     "ERROR" },		      \
 		{ V4L2_BUF_FLAG_TIMECODE,	     "TIMECODE" },	      \
 		{ V4L2_BUF_FLAG_PREPARED,	     "PREPARED" },	      \
-		{ V4L2_BUF_FLAG_NO_CACHE_INVALIDATE, "NO_CACHE_INVALIDATE" }, \
-		{ V4L2_BUF_FLAG_NO_CACHE_CLEAN,	     "NO_CACHE_CLEAN" },      \
+		{ V4L2_BUF_FLAG_NO_CACHE_SYNC,	     "NO_CACHE_SYNC" },	      \
 		{ V4L2_BUF_FLAG_TIMESTAMP_MASK,	     "TIMESTAMP_MASK" },      \
 		{ V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN,   "TIMESTAMP_UNKNOWN" },   \
 		{ V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC, "TIMESTAMP_MONOTONIC" }, \
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 16edbd9..cfe145f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -934,8 +934,11 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
-/* Cache handling flags */
-#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x00000800
+/* Cache sync hint */
+#define V4L2_BUF_FLAG_NO_CACHE_SYNC		0x00000800
+/* DEPRECATED. THIS WILL BE REMOVED IN THE FUTURE! */
+#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	V4L2_BUF_FLAG_NO_CACHE_SYNC
+/* DEPRECATED. THIS WILL BE REMOVED IN THE FUTURE! */
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x00001000
 /* Timestamp type */
 #define V4L2_BUF_FLAG_TIMESTAMP_MASK		0x0000e000
-- 
2.7.4
