Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54951 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750903AbdFSNt1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 09:49:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection behavior
Date: Mon, 19 Jun 2017 15:49:10 +0200
Message-Id: <20170619134910.10138-3-hverkuil@xs4all.nl>
In-Reply-To: <20170619134910.10138-1-hverkuil@xs4all.nl>
References: <20170619134910.10138-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Unfortunately the use of 'type' was inconsistent for multiplanar
buffer types. Starting with 4.14 both the normal and _MPLANE variants
are allowed, thus making it possible to write sensible code.

Yes, we messed up :-(

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    | 23 ++++++++++++----------
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     | 22 ++++++++++++---------
 .../media/uapi/v4l/vidioc-g-selection.rst          | 22 +++++++++++----------
 3 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index f21a69b554e1..446984a7ed21 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -39,17 +39,10 @@ structure. Drivers fill the rest of the structure. The results are
 constant except when switching the video standard. Remember this switch
 can occur implicit when switching the video input or output.
 
-Do not use the multiplanar buffer types. Use
-``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
-``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
-``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
-``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
-
 This ioctl must be implemented for video capture or output devices that
 support cropping and/or scaling and/or have non-square pixels, and for
 overlay devices.
 
-
 .. c:type:: v4l2_cropcap
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
@@ -62,9 +55,9 @@ overlay devices.
     * - __u32
       - ``type``
       - Type of the data stream, set by the application. Only these types
-	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
-	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
-	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
+	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
+	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
+	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
     * - struct :ref:`v4l2_rect <v4l2-rect-crop>`
       - ``bounds``
       - Defines the window within capturing or output is possible, this
@@ -90,6 +83,16 @@ overlay devices.
 	``pixelaspect`` to 1/1. Other common values are 54/59 for PAL and
 	SECAM, 11/10 for NTSC sampled according to [:ref:`itu601`].
 
+.. note::
+   Unfortunately in the case of multiplanar buffer types
+   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
+   this API was messed up with regards to how the :c:type:`v4l2_cropcap` ``type`` field
+   should be filled in. Some drivers only accepted the ``_MPLANE`` buffer type while
+   other drivers only accepted a non-multiplanar buffer type (i.e. without the
+   ``_MPLANE`` at the end).
+
+   Starting with kernel 4.14 both variations are allowed.
+
 
 
 .. _v4l2-rect-crop:
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 56a36340f565..0db06acbb6ff 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -45,12 +45,6 @@ and struct :c:type:`v4l2_rect` substructure named ``c`` of a
 v4l2_crop structure and call the :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctl with a pointer
 to this structure.
 
-Do not use the multiplanar buffer types. Use
-``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
-``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
-``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
-``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
-
 The driver first adjusts the requested dimensions against hardware
 limits, i. e. the bounds given by the capture/output window, and it
 rounds to the closest possible values of horizontal and vertical offset,
@@ -87,14 +81,24 @@ When cropping is not supported then no parameters are changed and
     * - __u32
       - ``type``
       - Type of the data stream, set by the application. Only these types
-	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
-	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
-	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
+	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
+	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
+	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
     * - struct :c:type:`v4l2_rect`
       - ``c``
       - Cropping rectangle. The same co-ordinate system as for struct
 	:c:type:`v4l2_cropcap` ``bounds`` is used.
 
+.. note::
+   Unfortunately in the case of multiplanar buffer types
+   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
+   this API was messed up with regards to how the :c:type:`v4l2_crop` ``type`` field
+   should be filled in. Some drivers only accepted the ``_MPLANE`` buffer type while
+   other drivers only accepted a non-multiplanar buffer type (i.e. without the
+   ``_MPLANE`` at the end).
+
+   Starting with kernel 4.14 both variations are allowed.
+
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index deb1f6fb473b..0516ebd3ccd3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -42,11 +42,7 @@ The ioctls are used to query and configure selection rectangles.
 
 To query the cropping (composing) rectangle set struct
 :c:type:`v4l2_selection` ``type`` field to the
-respective buffer type. Do not use the multiplanar buffer types. Use
-``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
-``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
-``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
-``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
+respective buffer type. The next step is setting the
 value of struct :c:type:`v4l2_selection` ``target``
 field to ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer
 to table :ref:`v4l2-selections-common` or :ref:`selection-api` for
@@ -64,11 +60,7 @@ pixels.
 
 To change the cropping (composing) rectangle set the struct
 :c:type:`v4l2_selection` ``type`` field to the
-respective buffer type. Do not use multiplanar buffers. Use
-``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
-``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. Use
-``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
-``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
+respective buffer type. The next step is setting the
 value of struct :c:type:`v4l2_selection` ``target`` to
 ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer to table
 :ref:`v4l2-selections-common` or :ref:`selection-api` for additional
@@ -169,6 +161,16 @@ Selection targets and flags are documented in
       - Reserved fields for future use. Drivers and applications must zero
 	this array.
 
+.. note::
+   Unfortunately in the case of multiplanar buffer types
+   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
+   this API was messed up with regards to how the :c:type:`v4l2_selection` ``type`` field
+   should be filled in. Some drivers only accepted the ``_MPLANE`` buffer type while
+   other drivers only accepted a non-multiplanar buffer type (i.e. without the
+   ``_MPLANE`` at the end).
+
+   Starting with kernel 4.14 both variations are allowed.
+
 
 Return Value
 ============
-- 
2.11.0
