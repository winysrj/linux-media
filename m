Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755255AbdEHPEh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 17/18] docs-rst: Document precise V4L2_BUF_FLAG_NO_CACHE_SYNC flag behaviour
Date: Mon,  8 May 2017 18:03:29 +0300
Message-Id: <1494255810-12672-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document when should the user specify V4L2_BUF_FLAG_NO_CACHE_SYNC flag.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/buffer.rst | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 9eb42bd..e1f93dd 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -570,6 +570,27 @@ Buffer Flags
 	then read by another one, in which case the flag should be set in both
 	:ref:`VIDIOC_QBUF` and :ref:`VIDIOC_DQBUF` ioctls. This flag has no
 	effect on some devices / architectures.
+
+	More specifically, this flag causes cache synchronisation to
+	be skipped for OUTPUT buffers when the buffer is queued. The
+	flag can be used if the buffer has been previously written to
+	by hardware but has not been written to by the CPU.
+
+	Additionally, if this flag is specified for a CAPTURE buffer
+	when it is queued, cache synchronisation is skipped. This
+	signals that the application can guarantee that it has not
+	written to the buffer memory since it was last dequeued from
+	the device.
+
+	Specifying this flag for a CAPTURE buffer when
+	dequeueing a buffer will skip cache maintenance for the buffer
+	memory. An application may not access the buffer memory in
+	that case but it may well be passed onwards to another device
+	in the system.
+
+	Specifying this flag has no effect when dequeuing an OUTPUT
+	buffer.
+
     * .. _`V4L2-BUF-FLAG-LAST`:
 
       - ``V4L2_BUF_FLAG_LAST``
-- 
2.7.4
