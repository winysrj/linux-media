Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392AbcGEBbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 33/41] Documentation: dev-overlay.rst: Fix conversion issues
Date: Mon,  4 Jul 2016 22:31:08 -0300
Message-Id: <1af3728151afe3fcffe52a0ffb03fc91b9cdc8ec.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were several conversion issues on this file, causing it
to be badly formatted. Fix them, in order to match the
design used on DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-overlay.rst | 45 +++++++++++-------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index 97b41ecb9e78..e481d677aa3f 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -6,8 +6,8 @@
 Video Overlay Interface
 ***********************
 
+**Also known as Framebuffer Overlay or Previewing.**
 
-**Also known as Framebuffer Overlay or Previewing**
 Video overlay devices have the ability to genlock (TV-)video into the
 (VGA-)video signal of a graphics card, or to store captured images
 directly in video memory of a graphics card, typically with clipping.
@@ -183,17 +183,15 @@ struct v4l2_window
     applications can set this field to point to an array of clipping
     rectangles.
 
-Like the window coordinates
-w
-, clipping rectangles are defined relative to the top, left corner of
-the frame buffer. However clipping rectangles must not extend the frame
-buffer width and height, and they must not overlap. If possible
-applications should merge adjacent rectangles. Whether this must create
-x-y or y-x bands, or the order of rectangles, is not defined. When clip
-lists are not supported the driver ignores this field. Its contents
-after calling
-!ri!:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
-are undefined.
+    Like the window coordinates w, clipping rectangles are defined
+    relative to the top, left corner of the frame buffer. However
+    clipping rectangles must not extend the frame buffer width and
+    height, and they must not overlap. If possible applications
+    should merge adjacent rectangles. Whether this must create
+    x-y or y-x bands, or the order of rectangles, is not defined. When
+    clip lists are not supported the driver ignores this field. Its
+    contents after calling :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+    are undefined.
 
 ``__u32 clipcount``
     When the application set the ``clips`` field, this field must
@@ -237,30 +235,24 @@ exceeded are undefined. [3]_
     :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`,
     :ref:`framebuffer-flags`).
 
-Note this field was added in Linux 2.6.23, extending the structure.
-However the
-!ri!:ref:`VIDIOC_G/S/TRY_FMT <VIDIOC_G_FMT>`
-ioctls, which take a pointer to a
-!ri!:ref:`v4l2_format <v4l2-format>`
-parent structure with padding bytes at the end, are not affected.
+    **Note**: this field was added in Linux 2.6.23, extending the structure.
+    However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
+    ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
+    parent structure with padding bytes at the end, are not affected.
 
 
 .. _v4l2-clip:
 
-struct v4l2_clip
+struct v4l2_clip [4]_
 ----------------
 
-The X Window system defines "regions" which are vectors of struct BoxRec
-{ short x1, y1, x2, y2; } with width = x2 - x1 and height = y2 - y1, so
-one cannot pass X11 clip lists directly.
-
 ``struct v4l2_rect c``
     Coordinates of the clipping rectangle, relative to the top, left
     corner of the frame buffer. Only window pixels *outside* all
     clipping rectangles are displayed.
 
 ``struct v4l2_clip * next``
-    Pointer to the next clipping rectangle, NULL when this is the last
+    Pointer to the next clipping rectangle, ``NULL`` when this is the last
     rectangle. Drivers ignore this field, it cannot be used to pass a
     linked list of clipping rectangles.
 
@@ -317,3 +309,8 @@ To start or stop the frame buffer overlay applications call the
    because the application and graphics system are not aware these
    regions need to be refreshed. The driver should clip out more pixels
    or not write the image at all.
+
+.. [4]
+   The X Window system defines "regions" which are vectors of ``struct
+   BoxRec { short x1, y1, x2, y2; }`` with ``width = x2 - x1`` and
+   ``height = y2 - y1``, so one cannot pass X11 clip lists directly.
-- 
2.7.4

