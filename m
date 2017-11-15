Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:56284 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933264AbdKORLK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:10 -0500
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
Subject: [RFC v5 01/11] [media] v4l: add V4L2_CAP_ORDERED to the uapi
Date: Wed, 15 Nov 2017 15:10:47 -0200
Message-Id: <20171115171057.17340-2-gustavo@padovan.org>
In-Reply-To: <20171115171057.17340-1-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

When using explicit synchronization userspace needs to know if
the queue can deliver everything back in the same order, so we added
a new capability that drivers can use to report that they are capable
of keeping ordering.

In videobuf2 core when using fences we also make sure to keep the ordering
of buffers, so if the driver guarantees it too the whole pipeline inside
V4L2 will be ordered and the V4L2_CAP_ORDERED should be used.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 3 +++
 include/uapi/linux/videodev2.h                   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 66fb1b3d6e6e..ed3daa814da9 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -254,6 +254,9 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
+    * - ``V4L2_CAP_ORDERED``
+      - 0x20000000
+      - The device queue is ordered.
     * - ``V4L2_CAP_DEVICE_CAPS``
       - 0x80000000
       - The driver fills the ``device_caps`` field. This capability can
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0acc06..cd6fc1387f47 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -459,6 +459,7 @@ struct v4l2_capability {
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
+#define V4L2_CAP_ORDERED                0x20000000  /* Is the device queue ordered */
 
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
-- 
2.13.6
