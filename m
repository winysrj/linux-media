Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38052 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932689AbeCIRuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:50:25 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 13/13] [media] v4l: Document explicit synchronization behavior
Date: Fri,  9 Mar 2018 14:49:20 -0300
Message-Id: <20180309174920.22373-14-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add section to VIDIOC_QBUF and VIDIOC_QUERY_BUF about it

v6:	- Close some gaps in the docs (Hans)

v5:
	- Remove V4L2_CAP_ORDERED
	- Add doc about V4L2_FMT_FLAG_UNORDERED

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
 Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 55 +++++++++++++++++++++++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst | 12 ++++--
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9e448a4aa3aa..371d84966e34 100644
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
@@ -118,6 +118,59 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
+Explicit Synchronization
+------------------------
+
+Explicit Synchronization allows us to control the synchronization of
+shared buffers from userspace by passing fences to the kernel and/or
+receiving them from it. Fences passed to the kernel are named in-fences and
+the kernel should wait on them to signal before using the buffer. On the other
+side, the kernel can create out-fences for the buffers it queues to the
+drivers. Out-fences signal when the driver is finished with buffer, i.e., the
+buffer is ready. The fences are represented as a file and passed as a file
+descriptor to userspace.
+
+The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
+using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer flag and the `fence_fd` field. If
+an in-fence needs to be passed to the kernel, `fence_fd` should be set to the
+fence file descriptor number and the ``V4L2_BUF_FLAG_IN_FENCE`` should be set
+as well. Setting one but not the other will cause ``VIDIOC_QBUF`` to return
+with an error. The fence_fd field will be ignored if the
+``V4L2_BUF_FLAG_IN_FENCE`` is not set.
+
+The videobuf2-core will guarantee that all buffers queued with an in-fence will
+be queued to the drivers in the same order. Fences may signal out of order, so
+this guarantee at videobuf2 is necessary to not change ordering. So when
+waiting on a fence to signal all buffers queued after will be also block until
+that fence signal.
+
+If the in-fence signals with an error the buffer will be marked with
+``V4L2_BUF_FLAG_ERROR`` when returned to userspace at ``VIDIOC_DQBUF``.
+Even with the error the order of dequeueing the buffers are preserved.
+
+To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
+be set to ask for a fence to be attached to the buffer. The out-fence fd is
+sent to userspace as a ``VIDIOC_QBUF`` return argument on the `fence_fd` field.
+
+Note the the same `fence_fd` field is used for both sending the in-fence as
+input argument to receive the out-fence as a return argument. A buffer can
+have both in-fence ond out-fence.
+
+At streamoff the out-fences will either signal normally if the driver waits
+for the operations on the buffers to finish or signal with an error if the
+driver cancels the pending operations. Buffers with in-fences won't be queued
+to the driver if their fences signal. They will be cleaned up.
+
+The ``V4L2_FMT_FLAG_UNORDERED`` flag in ``VIDIOC_ENUM_FMT`` tells userspace
+that the  when using this format the order in which buffers are dequeued can
+be different from the order in which they were queued.
+
+Ordering is important to fences because it can optimize the pipeline with
+other drivers like a DRM/KMS display driver. For example, if a capture from the
+camera is happening in an orderly manner one can send the capture buffer
+out-fence to the DRM/KMS driver and rest sure that the buffers will be shown on
+the screen at the correct order. If an ordered queue can not be set then such
+arrangements with other drivers may not be possible.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index dd54747fabc9..9aa3358bee0b 100644
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
@@ -64,8 +64,14 @@ elements will be used instead and the ``length`` field of struct
 array elements. The driver may or may not set the remaining fields and
 flags, they are meaningless in this context.
 
-The struct :c:type:`v4l2_buffer` structure is specified in
-:ref:`buffer`.
+When using in-fences, the ``V4L2_BUF_FLAG_IN_FENCE`` will be set if the
+in-fence didn't signal at the time of the
+:ref:`VIDIOC_QUERYBUF`. The ``V4L2_BUF_FLAG_OUT_FENCE`` will be set if
+the user asked for an out-fence for the buffer and the ``fence_fd``
+field will be set to the out-fence fd. In case ``V4L2_BUF_FLAG_OUT_FENCE`` is
+not set ``fence_fd`` will be set to 0 for backward compatibility.
+
+The struct :c:type:`v4l2_buffer` structure is specified in :ref:`buffer`.
 
 
 Return Value
-- 
2.14.3
