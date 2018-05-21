Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44494 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeEURCd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:33 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 16/16] v4l: Document explicit synchronization behavior
Date: Mon, 21 May 2018 13:59:46 -0300
Message-Id: <20180521165946.11778-17-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add section to VIDIOC_QBUF and VIDIOC_QUERY_BUF about it

v9: assorted improvements.

v8: amend querybuf documentation.

v7: minor issues and English improvements (Hans Verkuil)

v6: Close some gaps in the docs (Hans)

v5: - Remove V4L2_CAP_ORDERED
    - Add doc about V4L2_FMT_FLAG_UNORDERED

v4: - Document ordering behavior for in-fences
    - Document V4L2_CAP_ORDERED capability
    - Remove doc about OUT_FENCE event
    - Document immediate return of out-fence in QBUF

v3: - make the out_fence refer to the current buffer (Hans)
    - Note what happens when the IN_FENCE is not set (Hans)

v2: - mention that fences are files (Hans)
    - rework for the new API

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 53 +++++++++++++++++++++++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst | 12 ++++--
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9e448a4aa3aa..f09e21247a6c 100644
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
@@ -118,6 +118,57 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
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
+with an error.
+
+It is guaranteed that all buffers queued with an in-fence will be queued to
+the drivers in the same order. Fences may signal out of order, so this guarantee
+is necessary to not change ordering. While waiting for a fence to signal,
+all buffers queued afterwards will also be blocked until that fence signals.
+
+If the in-fence signals with an error the buffer will be marked with
+``V4L2_BUF_FLAG_ERROR`` when returned to userspace at ``VIDIOC_DQBUF``.
+Even with the error the order of dequeueing the buffers is preserved.
+
+To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
+be set to ask for a fence to be attached to the buffer. The out-fence fd is
+sent to userspace as a ``VIDIOC_QBUF`` return argument in the `fence_fd` field.
+
+Note the same `fence_fd` field is used for both sending the in-fence as
+at input argument and to receive the out-fence as a return argument. A buffer can
+have both an in-fence and an out-fence.
+
+At streamoff the out-fences will either signal normally if the driver waits
+for the operations on the buffers to finish or signal with an error if the
+driver cancels the pending operations. Buffers with in-fences won't be queued
+to the driver if their fences signal. They will be cleaned up.
+
+The ``V4L2_FMT_FLAG_UNORDERED`` flag in ``VIDIOC_ENUM_FMT`` tells userspace
+that when using this format, the order in which buffers are dequeued can
+be different from the order in which they were queued.
+
+Ordering is important to fences because it can optimize the pipeline with
+other drivers like a DRM/KMS display driver. For example, if a capture from the
+camera is happening in an ordered manner one can send the capture buffer
+out-fence to the DRM/KMS driver and rest assured that the buffers will be shown on
+the screen in the correct order. If the queue is not ordered, then such
+arrangements with other drivers may not be possible.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index dd54747fabc9..cda73b43c334 100644
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
+:ref:`VIDIOC_QUERYBUF`. Similarly, the ``V4L2_BUF_FLAG_OUT_FENCE`` will be
+set if there's a pending out-fence for the buffer. Note that the ``fence_fd``
+field is not set, because the file descriptor only makes sense
+for the process that received the out-fence in the :ref:`VIDIOC_QBUF` response.
+
+The struct :c:type:`v4l2_buffer` structure is specified in :ref:`buffer`.
 
 
 Return Value
-- 
2.16.3
