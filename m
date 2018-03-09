Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:38034 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932645AbeCIRuS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:50:18 -0500
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
Subject: [PATCH v8 11/13] [media] v4l: introduce the fences capability
Date: Fri,  9 Mar 2018 14:49:18 -0300
Message-Id: <20180309174920.22373-12-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Drivers capable of using fences (vb2 drivers) should report the
V4L2_CAP_FENCES to userspace, so add this flag to the uapi.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 3 +++
 include/uapi/linux/videodev2.h                   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 66fb1b3d6e6e..414016065309 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -254,6 +254,9 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
+    * - ``V4L2_CAP_FENCES``
+      - 0x20000000
+      - The device support explicit synchronization.
     * - ``V4L2_CAP_DEVICE_CAPS``
       - 0x80000000
       - The driver fills the ``device_caps`` field. This capability can
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2d424aebdd1e..db58204e346e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -460,6 +460,7 @@ struct v4l2_capability {
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
+#define V4L2_CAP_FENCES                 0x20000000  /* Supports explicit synchronization */
 
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
-- 
2.14.3
