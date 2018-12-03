Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59036 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbeLCNw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:57 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 4/9] buffer.rst: document the new buffer tag feature.
Date: Mon,  3 Dec 2018 14:51:38 +0100
Message-Id: <20181203135143.45487-5-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Document V4L2_BUF_FLAG_TAG.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst       | 32 ++++++++++++++-----
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 +++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 2e266d32470a..3c09a94c5a10 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -220,17 +220,25 @@ struct v4l2_buffer
 	use ``V4L2_BUF_FLAG_TIMESTAMP_COPY`` the application has to fill
 	in the timestamp which will be copied by the driver to the capture
 	stream.
-    * - struct :c:type:`v4l2_timecode`
+    * - union
+    * -
+      - struct :c:type:`v4l2_timecode`
       - ``timecode``
-      -
-      - When ``type`` is ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` and the
-	``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
+      - When the ``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
 	structure contains a frame timecode. In
 	:c:type:`V4L2_FIELD_ALTERNATE <v4l2_field>` mode the top and
 	bottom field contain the same timecode. Timecodes are intended to
 	help video editing and are typically recorded on video tapes, but
 	also embedded in compressed formats like MPEG. This field is
 	independent of the ``timestamp`` and ``sequence`` fields.
+    * -
+      - __u32
+      - ``tag``
+      - When the ``V4L2_BUF_FLAG_TAG`` flag is set in ``flags``, this
+	field contains a user-specified tag value.
+
+	It is used by stateless codecs where this tag can be used to
+	refer to buffers that contain reference frames.
     * - __u32
       - ``sequence``
       -
@@ -567,6 +575,14 @@ Buffer Flags
 	when the ``VIDIOC_DQBUF`` ioctl is called. Applications can set
 	this bit and the corresponding ``timecode`` structure when
 	``type`` refers to an output stream.
+    * .. _`V4L2-BUF-FLAG-TAG`:
+
+      - ``V4L2_BUF_FLAG_TAG``
+      - 0x00000200
+      - The ``tag`` field is valid. Applications can set
+	this bit and the corresponding ``tag`` field. If tags are
+	supported then the ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability
+	is also set.
     * .. _`V4L2-BUF-FLAG-PREPARED`:
 
       - ``V4L2_BUF_FLAG_PREPARED``
@@ -704,10 +720,10 @@ enum v4l2_memory
 Timecodes
 =========
 
-The struct :c:type:`v4l2_timecode` structure is designed to hold a
-:ref:`smpte12m` or similar timecode. (struct
-struct :c:type:`timeval` timestamps are stored in struct
-:c:type:`v4l2_buffer` field ``timestamp``.)
+The :c:type:`v4l2_buffer_timecode` structure is designed to hold a
+:ref:`smpte12m` or similar timecode.
+(struct :c:type:`timeval` timestamps are stored in the struct
+:c:type:`v4l2_buffer` ``timestamp`` field.)
 
 
 .. c:type:: v4l2_timecode
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index e62a15782790..38a7d0aee483 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -118,6 +118,7 @@ aborting or finishing any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
 .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
+.. _V4L2-BUF-CAP-SUPPORTS-TAGS:
 
 .. cssclass:: longtable
 
@@ -143,6 +144,9 @@ aborting or finishing any DMA in progress, an implicit
       - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
         mapped or exported via DMABUF. These orphaned buffers will be freed
         when they are unmapped or when the exported DMABUF fds are closed.
+    * - ``V4L2_BUF_CAP_SUPPORTS_TAGS``
+      - 0x00000020
+      - This buffer type supports ``V4L2_BUF_FLAG_TAG``.
 
 Return Value
 ============
-- 
2.19.1
