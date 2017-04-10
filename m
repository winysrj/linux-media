Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52783 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754989AbdDJQtC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 12:49:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] Document new V4L2_CTRL_FLAG_MODIFY_LAYOUT flag
Message-ID: <463ae2c1-9ee2-9b50-2939-cafae0365dec@xs4all.nl>
Date: Mon, 10 Apr 2017 18:48:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC patch adds documentation for the V4L2_CTRL_FLAG_MODIFY_LAYOUT flag and
how this and the GRABBED flag should be used.

When approved I'll post a proper patch series introducing this flag.

This patch sits on top of Laurent's vsp1/next branch.

Also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=vsp1

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 64613d935edd..ae6ee73f151c 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -48,10 +48,16 @@ The set of information needed to interpret the content of a buffer (e.g. the
 pixel format, the line stride, the tiling orientation or the rotation) is
 collectively referred to in the rest of this section as the buffer layout.

+Controls that can modify the buffer layout shall set the
+``V4L2_CTRL_FLAG_MODIFY_LAYOUT`` flag.
+
 Modifying formats or controls that influence the buffer size or layout require
 the stream to be stopped. Any attempt at such a modification while the stream
 is active shall cause the ioctl setting the format or the control to return
-the ``EBUSY`` error code.
+the ``EBUSY`` error code. In that case drivers shall also set the
+``V4L2_CTRL_FLAG_GRABBED`` flag when calling
+:c:func:`VIDIOC_QUERYCTRL` or :c:func:`VIDIOC_QUERY_EXT_CTRL` for such a
+control while the stream is active.

 .. note::

@@ -67,7 +73,8 @@ the ``EBUSY`` error code.
 Controls that only influence the buffer layout can be modified at any time
 when the stream is stopped. As they don't influence the buffer size, no
 special handling is needed to synchronize those controls with buffer
-allocation.
+allocation and the ``V4L2_CTRL_FLAG_GRABBED`` flag is cleared once the
+stream is stopped.

 Formats and controls that influence the buffer size interact with buffer
 allocation. The simplest way to handle this is for drivers to always require
@@ -75,8 +82,10 @@ buffers to be reallocated in order to change those formats or controls. In
 that case, to perform such changes, userspace applications shall first stop
 the video stream with the :c:func:`VIDIOC_STREAMOFF` ioctl if it is running
 and free all buffers with the :c:func:`VIDIOC_REQBUFS` ioctl if they are
-allocated. The format or controls can then be modified, and buffers shall then
-be reallocated and the stream restarted. A typical ioctl sequence is
+allocated. After freeing all buffers the ``V4L2_CTRL_FLAG_GRABBED`` flag
+for controls is cleared. The format or controls can then be modified, and
+buffers shall then be reallocated and the stream restarted. A typical ioctl
+sequence is

  #. VIDIOC_STREAMOFF
  #. VIDIOC_REQBUFS(0)
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 82769de801b1..1ffdc3f3c614 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -507,6 +507,19 @@ See also the examples in :ref:`control`.
 	represents an action on the hardware. For example: clearing an
 	error flag or triggering the flash. All the controls of the type
 	``V4L2_CTRL_TYPE_BUTTON`` have this flag set.
+    * .. _FLAG_MODIFY_LAYOUT:
+
+      - ``V4L2_CTRL_FLAG_MODIFY_LAYOUT``
+      - 0x0400
+      - Changing this control value may modify the layout of the
+        buffer (for video devices) or the media bus format (for sub-devices).
+
+	A typical example would be the ``V4L2_CID_ROTATE`` control.
+
+	Note that typically controls with this flag will also set the
+	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
+	streaming is in progress since most drivers do not support changing
+	the format in that case.


 Return Value
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index c9c611b18ba1..a5cb0a8686ac 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -341,6 +341,7 @@ replace define V4L2_CTRL_FLAG_WRITE_ONLY control-flags
 replace define V4L2_CTRL_FLAG_VOLATILE control-flags
 replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
 replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
+replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags

 replace define V4L2_CTRL_FLAG_NEXT_CTRL control
 replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
