Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36702 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbdIABvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:33 -0400
Received: by mail-qk0-f196.google.com with SMTP id l65so981910qkc.3
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:33 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 14/14] [media] v4l: Document explicit synchronization behaviour
Date: Thu, 31 Aug 2017 22:50:41 -0300
Message-Id: <20170901015041.7757-15-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add section to VIDIOC_QBUF about it

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-qbuf.rst | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 1f3612637200..6bd960d3972b 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -117,6 +117,36 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
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
+finished with buffer, that is the buffer is ready.
+
+The in-fences and out-fences are communicated at the ``VIDIOC_QBUF`` ioctl
+using the ``V4L2_BUF_FLAG_IN_FENCE`` and ``V4L2_BUF_FLAG_OUT_FENCE`` buffer
+flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
+`fence_fd` should be set to the fence file descriptor number and the
+``V4L2_BUF_FLAG_IN_FENCE`` should be set as well.
+
+To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
+be set and the `fence_fd` field will be returned with the out-fence file
+descriptor related to the next buffer to be queued internally to the V4L2
+driver. That means the out-fence may not be associated with the buffer in the
+current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
+queues the buffers to the drivers can't be guaranteed. To become aware of the
+buffer with which the out-fence will be attached the ``V4L2_EVENT_BUF_QUEUED``
+should be used. It will trigger an event for every buffer queued to the V4L2
+driver.
+
+Note that the `fence_fd` field is both an input and output argument here with
+different meaning on each direction. As input argument it carries an in-fence
+and as output argument it carries an out-fence.
 
 Return Value
 ============
-- 
2.13.5
