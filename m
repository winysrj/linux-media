Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51079 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731624AbeKMTkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:40:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 4/9] buffer.rst: document the new buffer tag feature.
Date: Tue, 13 Nov 2018 10:42:33 +0100
Message-Id: <20181113094238.48253-5-hverkuil@xs4all.nl>
In-Reply-To: <20181113094238.48253-1-hverkuil@xs4all.nl>
References: <20181113094238.48253-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document V4L2_BUF_FLAG_TAG and struct v4l2_buffer_tag.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/media/uapi/v4l/buffer.rst       | 61 ++++++++++++++++---
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 2e266d32470a..8160631bb9d9 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -220,17 +220,29 @@ struct v4l2_buffer
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
+      - struct :c:type:`v4l2_buffer_tag`
+      - ``tag``
+      - When the ``V4L2_BUF_FLAG_TAG`` flag is set in ``flags``, this
+	structure contains a user-specified 64-bit tag value. It can be
+	set with the helper functions :c:func:`v4l2_buffer_set_tag()` or
+	:c:func:`v4l2_buffer_set_tag_ptr()`, and it can be retrieved with
+	the helper functions :c:func:`v4l2_buffer_get_tag()` or
+        :c:func:`v4l2_buffer_get_tag_ptr()`.
+
+	It is used by stateless codecs where this tag can be used to
+	refer to buffers that contain reference frames.
     * - __u32
       - ``sequence``
       -
@@ -567,6 +579,14 @@ Buffer Flags
 	when the ``VIDIOC_DQBUF`` ioctl is called. Applications can set
 	this bit and the corresponding ``timecode`` structure when
 	``type`` refers to an output stream.
+    * .. _`V4L2-BUF-FLAG-TAG`:
+
+      - ``V4L2_BUF_FLAG_TAG``
+      - 0x00000200
+      - The ``tag`` field is valid. Applications can set
+	this bit and the corresponding ``tag`` structure. If tags are
+	supported then the ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability
+	is also set.
     * .. _`V4L2-BUF-FLAG-PREPARED`:
 
       - ``V4L2_BUF_FLAG_PREPARED``
@@ -704,10 +724,10 @@ enum v4l2_memory
 Timecodes
 =========
 
-The struct :c:type:`v4l2_timecode` structure is designed to hold a
-:ref:`smpte12m` or similar timecode. (struct
-struct :c:type:`timeval` timestamps are stored in struct
-:c:type:`v4l2_buffer` field ``timestamp``.)
+The :c:type:`v4l2_buffer_tag` structure is designed to hold a
+:ref:`smpte12m` or similar timecode.
+(struct :c:type:`timeval` timestamps are stored in the struct
+:c:type:`v4l2_buffer` ``timestamp`` field.)
 
 
 .. c:type:: v4l2_timecode
@@ -807,3 +827,28 @@ Timecode Flags
     * - ``V4L2_TC_USERBITS_8BITCHARS``
       - 0x0008
       - 8-bit ISO characters.
+
+Tags
+====
+
+The :c:type:`v4l2_buffer_tag` structure is designed to hold a
+64 bit tag.
+
+.. c:type:: v4l2_buffer_tag
+
+struct v4l2_buffer_tag
+----------------------
+
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``low``
+      - Low 32 bits of the 64 bit tag value.
+    * - __u32
+      - ``high``
+      - High 32 bits of the 64 bit tag value.
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index d4bbbb0c60e8..5090a62f324c 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -112,6 +112,7 @@ any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-USERPTR:
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
+.. _V4L2-BUF-CAP-SUPPORTS-TAGS:
 
 .. cssclass:: longtable
 
@@ -132,6 +133,9 @@ any DMA in progress, an implicit
     * - ``V4L2_BUF_CAP_SUPPORTS_REQUESTS``
       - 0x00000008
       - This buffer type supports :ref:`requests <media-request-api>`.
+    * - ``V4L2_BUF_CAP_SUPPORTS_TAGS``
+      - 0x00000010
+      - This buffer type supports ``V4L2_BUF_FLAG_TAG``.
 
 Return Value
 ============
-- 
2.19.1
