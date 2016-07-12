Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbcGLPBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:01:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: fix a missing reference for V4L2_BUF_FLAG_LAST
Date: Tue, 12 Jul 2016 12:01:38 -0300
Message-Id: <e70fb059a4d3eb5c3fabf1b1ef5f33ecb84e9194.1468335677.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix it by adding a header to the flat-table to match to
the list of define symbols.

As a side-effect, it also removes some exceptions from
videodev2.h.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/buffer.rst        | 38 +++++++++++++-------------
 Documentation/media/videodev2.h.rst.exceptions | 21 --------------
 2 files changed, 19 insertions(+), 40 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 16cdd8e2c4d7..5deb4a46f992 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -512,7 +512,7 @@ Buffer Flags
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`V4L2-BUF-FLAG-MAPPED`:
 
        -  ``V4L2_BUF_FLAG_MAPPED``
 
@@ -526,7 +526,7 @@ Buffer Flags
 	  :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called. Set by the
 	  driver.
 
-    -  .. row 2
+    -  .. _`V4L2-BUF-FLAG-QUEUED`:
 
        -  ``V4L2_BUF_FLAG_QUEUED``
 
@@ -541,7 +541,7 @@ Buffer Flags
 	  the ``VIDIOC_QBUF``\ ioctl it is always set and after
 	  ``VIDIOC_DQBUF`` always cleared.
 
-    -  .. row 3
+    -  .. _`V4L2-BUF-FLAG-DONE`:
 
        -  ``V4L2_BUF_FLAG_DONE``
 
@@ -557,7 +557,7 @@ Buffer Flags
 	  buffer is in "dequeued" state, in the application domain so to
 	  say.
 
-    -  .. row 4
+    -  .. _`V4L2-BUF-FLAG-ERROR`:
 
        -  ``V4L2_BUF_FLAG_ERROR``
 
@@ -569,7 +569,7 @@ Buffer Flags
 	  normally. Drivers set this flag when the ``VIDIOC_DQBUF`` ioctl is
 	  called.
 
-    -  .. row 5
+    -  .. _`V4L2-BUF-FLAG-KEYFRAME`:
 
        -  ``V4L2_BUF_FLAG_KEYFRAME``
 
@@ -582,7 +582,7 @@ Buffer Flags
 	  Applications can set this bit when ``type`` refers to an output
 	  stream.
 
-    -  .. row 6
+    -  .. _`V4L2-BUF-FLAG-PFRAME`:
 
        -  ``V4L2_BUF_FLAG_PFRAME``
 
@@ -593,7 +593,7 @@ Buffer Flags
 	  Applications can set this bit when ``type`` refers to an output
 	  stream.
 
-    -  .. row 7
+    -  .. _`V4L2-BUF-FLAG-BFRAME`:
 
        -  ``V4L2_BUF_FLAG_BFRAME``
 
@@ -605,7 +605,7 @@ Buffer Flags
 	  frames to specify its content. Applications can set this bit when
 	  ``type`` refers to an output stream.
 
-    -  .. row 8
+    -  .. _`V4L2-BUF-FLAG-TIMECODE`:
 
        -  ``V4L2_BUF_FLAG_TIMECODE``
 
@@ -616,7 +616,7 @@ Buffer Flags
 	  this bit and the corresponding ``timecode`` structure when
 	  ``type`` refers to an output stream.
 
-    -  .. row 9
+    -  .. _`V4L2-BUF-FLAG-PREPARED`:
 
        -  ``V4L2_BUF_FLAG_PREPARED``
 
@@ -629,7 +629,7 @@ Buffer Flags
 	  :ref:`VIDIOC_QBUF` or
 	  :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called.
 
-    -  .. row 10
+    -  .. _`V4L2-BUF-FLAG-NO-CACHE-INVALIDATE`:
 
        -  ``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE``
 
@@ -641,7 +641,7 @@ Buffer Flags
 	  will, probably, be passed on to a DMA-capable hardware unit for
 	  further processing or output.
 
-    -  .. row 11
+    -  .. _`V4L2-BUF-FLAG-NO-CACHE-CLEAN`:
 
        -  ``V4L2_BUF_FLAG_NO_CACHE_CLEAN``
 
@@ -652,7 +652,7 @@ Buffer Flags
 	  this buffer has not been created by the CPU but by some
 	  DMA-capable unit, in which case caches have not been used.
 
-    -  .. row 12
+    -  .. _`V4L2-BUF-FLAG-LAST`:
 
        -  ``V4L2_BUF_FLAG_LAST``
 
@@ -668,7 +668,7 @@ Buffer Flags
 	  :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
 	  but return an ``EPIPE`` error code.
 
-    -  .. row 13
+    -  .. _`V4L2-BUF-FLAG-TIMESTAMP-MASK`:
 
        -  ``V4L2_BUF_FLAG_TIMESTAMP_MASK``
 
@@ -678,7 +678,7 @@ Buffer Flags
 	  out bits not belonging to timestamp type by performing a logical
 	  and operation with buffer flags and timestamp mask.
 
-    -  .. row 14
+    -  .. _`V4L2-BUF-FLAG-TIMESTAMP-UNKNOWN`:
 
        -  ``V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN``
 
@@ -692,7 +692,7 @@ Buffer Flags
 	  :c:func:`clock_gettime(2)` using clock IDs ``CLOCK_MONOTONIC``
 	  and ``CLOCK_REALTIME``, respectively.
 
-    -  .. row 15
+    -  .. _`V4L2-BUF-FLAG-TIMESTAMP-MONOTONIC`:
 
        -  ``V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC``
 
@@ -702,7 +702,7 @@ Buffer Flags
 	  clock. To access the same clock outside V4L2, use
 	  :c:func:`clock_gettime(2)`.
 
-    -  .. row 16
+    -  .. _`V4L2-BUF-FLAG-TIMESTAMP-COPY`:
 
        -  ``V4L2_BUF_FLAG_TIMESTAMP_COPY``
 
@@ -711,7 +711,7 @@ Buffer Flags
        -  The CAPTURE buffer timestamp has been taken from the corresponding
 	  OUTPUT buffer. This flag applies only to mem2mem devices.
 
-    -  .. row 17
+    -  .. _`V4L2-BUF-FLAG-TSTAMP-SRC-MASK`:
 
        -  ``V4L2_BUF_FLAG_TSTAMP_SRC_MASK``
 
@@ -725,7 +725,7 @@ Buffer Flags
 	  ``type`` refers to an output stream and
 	  ``V4L2_BUF_FLAG_TIMESTAMP_COPY`` is set.
 
-    -  .. row 18
+    -  .. _`V4L2-BUF-FLAG-TSTAMP-SRC-EOF`:
 
        -  ``V4L2_BUF_FLAG_TSTAMP_SRC_EOF``
 
@@ -738,7 +738,7 @@ Buffer Flags
 	  time after the last pixel has been received or transmitten,
 	  depending on the system and other activity in it.
 
-    -  .. row 19
+    -  .. _`V4L2-BUF-FLAG-TSTAMP-SRC-SOE`:
 
        -  ``V4L2_BUF_FLAG_TSTAMP_SRC_SOE``
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index c15660f5c588..57e4ef5a5a30 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -184,27 +184,6 @@ replace define V4L2_JPEG_MARKER_DRI jpeg-markers
 replace define V4L2_JPEG_MARKER_COM jpeg-markers
 replace define V4L2_JPEG_MARKER_APP jpeg-markers
 
-#V4L2 buffer flags
-replace define V4L2_BUF_FLAG_MAPPED buffer-flags
-replace define V4L2_BUF_FLAG_QUEUED buffer-flags
-replace define V4L2_BUF_FLAG_DONE buffer-flags
-replace define V4L2_BUF_FLAG_ERROR buffer-flags
-replace define V4L2_BUF_FLAG_KEYFRAME buffer-flags
-replace define V4L2_BUF_FLAG_PFRAME buffer-flags
-replace define V4L2_BUF_FLAG_BFRAME buffer-flags
-replace define V4L2_BUF_FLAG_TIMECODE buffer-flags
-replace define V4L2_BUF_FLAG_PREPARED buffer-flags
-replace define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE buffer-flags
-replace define V4L2_BUF_FLAG_NO_CACHE_CLEAN buffer-flags
-replace define V4L2_BUF_FLAG_TIMESTAMP_MASK buffer-flags
-replace define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN buffer-flags
-replace define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC buffer-flags
-replace define V4L2_BUF_FLAG_TIMESTAMP_COPY buffer-flags
-replace define V4L2_BUF_FLAG_TSTAMP_SRC_MASK buffer-flags
-replace define V4L2_BUF_FLAG_TSTAMP_SRC_EOF buffer-flags
-replace define V4L2_BUF_FLAG_TSTAMP_SRC_SOE buffer-flags
-replace define V4L2_BUF_FLAG_LAST buffer-flags-FIXME
-
 # V4L2 framebuffer caps and flags
 
 replace define V4L2_FBUF_CAP_EXTERNOVERLAY framebuffer-cap
-- 
2.7.4

