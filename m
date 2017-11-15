Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43161 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933341AbdKORL4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:56 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v5 11/11] [media] v4l: Document explicit synchronization behavior
Date: Wed, 15 Nov 2017 15:10:57 -0200
Message-Id: <20171115171057.17340-12-gustavo@padovan.org>
In-Reply-To: <20171115171057.17340-1-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add section to VIDIOC_QBUF about it

v4:
	- Document ordering behavior for in-fences
	- Document V4L2_CAP_ORDERED capability
	- Remove doc about OUT_FENCE event
	- Document immediate return of out-fence in QBUF

v3:
	- make the out_fence refer to the current buffer (Hans)
	- Note what happens when the IN_FENCE is not set (Hans)

v2:
	- mention that fences are files (Hans)
	- rework for the new API

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 42 +++++++++++++++++++++++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst |  9 ++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9e448a4aa3aa..040709256ab6 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -54,7 +54,7 @@ When the buffer is intended for output (``type`` is
 or ``V4L2_BUF_TYPE_VBI_OUTPUT``) applications must also initialize the
 ``bytesused``, ``field`` and ``timestamp`` fields, see :ref:`buffer`
 for details. Applications must also set ``flags`` to 0. The
-``reserved2`` and ``reserved`` fields must be set to 0. When using the
+``reserved`` field must be set to 0. When using the
 :ref:`multi-planar API <planar-apis>`, the ``m.planes`` field must
 contain a userspace pointer to a filled-in array of struct
 :c:type:`v4l2_plane` and the ``length`` field must be set
@@ -118,6 +118,46 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
+Explicit Synchronization
+------------------------
+
+Explicit Synchronization allows us to control the synchronization of
+shared buffers from userspace by passing fences to the kernel and/or
+receiving them from it. Fences passed to the kernel are named in-fences and
+the kernel should wait on them to signal before using the buffer, i.e., queueing
+it to the driver. On the other side, the kernel can create out-fences for the
+buffers it queues to the drivers. Out-fences signal when the driver is
+finished with buffer, i.e., the buffer is ready. The fences are represented
+as a file and passed as a file descriptor to userspace.
+
+The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
+using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer flag and the `fence_fd` field. If
+an in-fence needs to be passed to the kernel, `fence_fd` should be set to the
+fence file descriptor number and the ``V4L2_BUF_FLAG_IN_FENCE`` should be set
+as well. Setting one but not the other will cause ``VIDIOC_QBUF`` to return
+with error. The fence_fd field will be ignored if the
+``V4L2_BUF_FLAG_IN_FENCE`` is not set.
+
+The videobuf2-core will guarantee that all buffers queued with in-fence will
+be queued to the drivers in the same order. Fence may signal out of order, so
+this guarantee at videobuf2 is necessary to not change ordering.
+
+To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
+be set to ask for a fence to be attached to the buffer. The out-fence fd is
+sent to userspace as a ``VIDIOC_QBUF`` return argument on the `fence_fd` field.
+
+Note the the same `fence_fd` field is used for both sending the in-fence as
+input argument to receive the out-fence as a return argument.
+
+At streamoff the out-fences will either signal normally if the driver waits
+for the operations on the buffers to finish or signal with an error if the
+driver cancels the pending operations. Buffers with in-fences won't be queued
+to the driver if their fences signal. It will be cleaned up.
+
+A capability flag, ``V4L2_CAP_ORDERED``, tells userspace that the current
+buffer queues is able to keep the ordering of buffers, i.e., the dequeing of
+buffers will happen at the same order we queue them, with no reordering by
+the driver.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index dd54747fabc9..df964c4d916b 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -44,7 +44,7 @@ and the ``index`` field. Valid index numbers range from zero to the
 number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
 :c:type:`v4l2_requestbuffers` ``count``) minus
-one. The ``reserved`` and ``reserved2`` fields must be set to 0. When
+one. The ``reserved`` field must be set to 0. When
 using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
 field must contain a userspace pointer to an array of struct
 :c:type:`v4l2_plane` and the ``length`` field has to be set
@@ -64,6 +64,13 @@ elements will be used instead and the ``length`` field of struct
 array elements. The driver may or may not set the remaining fields and
 flags, they are meaningless in this context.
 
+When using in-fences, the ``V4L2_BUF_FLAG_IN_FENCE`` will be set if the
+in-fence didn't signal at the time of the
+:ref:`VIDIOC_QUERYBUF`. The ``V4L2_BUF_FLAG_OUT_FENCE`` will be set if
+the user asked for an out-fence for the buffer, but the ``fence_fd``
+field will be set to -1. In case ``V4L2_BUF_FLAG_OUT_FENCE`` is not set
+``fence_fd`` will be set to 0 for backward compatibility.
+
 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
-- 
2.13.6
