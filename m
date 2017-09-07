Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38252 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755868AbdIGSmh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:42:37 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 01/15] [media] v4l: Document explicit synchronization behaviour
Date: Thu,  7 Sep 2017 15:42:12 -0300
Message-Id: <20170907184226.27482-2-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add section to VIDIOC_QBUF about it

v2:
	- mention that fences are files (Hans)
	- rework for the new API

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-qbuf.rst | 31 ++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 1f3612637200..fae0b1431672 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -117,6 +117,37 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
+Explicit Synchronization
+------------------------
+
+Explicit Synchronization allows us to control the synchronization of
+shared buffers from userspace by passing fences to the kernel and/or
+receiving them from it. Fences passed to the kernel are named in-fences and
+the kernel should wait them to signal before using the buffer, i.e., queueing
+it to the driver. On the other side, the kernel can create out-fences for the
+buffers it queues to the drivers, out-fences signal when the driver is
+finished with buffer, that is the buffer is ready. The fence are represented
+by file and passed as file descriptor to userspace.
+
+The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
+using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer
+flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
+`fence_fd` should be set to the fence file descriptor number and the
+``V4L2_BUF_FLAG_IN_FENCE`` should be set as well. Failure to set both will
+cause ``VIDIOC_QBUF`` to return with error.
+
+To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
+be set to notify it that the next queued buffer should have a fence attached to
+it. That means the out-fence may not be associated with the buffer in the
+current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
+queues the buffers to the drivers can't be guaranteed. To become aware of the
+of the next queued buffer and the out-fence attached to it the
+``V4L2_EVENT_BUF_QUEUED`` event should be used. It will trigger an event
+for every buffer queued to the V4L2 driver.
+
+At streamoff the out-fences will either signal normally if the drivers wait
+for the operations on the buffers to finish or signal with error if the
+driver cancel the pending operations.
 
 Return Value
 ============
-- 
2.13.5
