Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60924 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756200AbdJJLpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:45:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v8 6/7] media: videodev2: add a flag for MC-centric devices
Date: Tue, 10 Oct 2017 08:45:22 -0300
Message-Id: <79d2937e0de7dea977f2b2c27e34d81d90b54199.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As both vdev-centric and MC-centric devices may implement the
same APIs, we need a flag to allow userspace to distinguish
between them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/open.rst            | 7 +++++++
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 5 +++++
 Documentation/media/videodev2.h.rst.exceptions   | 1 +
 include/uapi/linux/videodev2.h                   | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index c9e6bc9280a6..58ab75959584 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -62,6 +62,13 @@ typically involves configuring the links using the **Media controller**
 interface and the media bus formats on pads (at both ends of the links)
 using the **V4L2 sub-device** interface.
 
+.. attention::
+
+   Devices that require **MC-centric** media hardware control should
+   report a ``V4L2_MC_CENTRIC`` :c:type:`v4l2_capability` flag
+   (see :ref:`VIDIOC_QUERYCAP`).
+
+
 .. _v4l2_device_naming:
 
 V4L2 Device Node Naming
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 66fb1b3d6e6e..944bc5ba484f 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -254,6 +254,11 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
+    * - ``V4L2_MC_CENTRIC``
+      - 0x20000000
+      - Indicates that the device require **MC-centric** hardware
+        control, and thus can't be used by **vdevnode-centric** applications.
+        See :ref:`v4l2_hardware_control` for more details.
     * - ``V4L2_CAP_DEVICE_CAPS``
       - 0x80000000
       - The driver fills the ``device_caps`` field. This capability can
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index a5cb0a8686ac..b51a575f9f75 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -157,6 +157,7 @@ replace define V4L2_CAP_META_CAPTURE device-capabilities
 replace define V4L2_CAP_READWRITE device-capabilities
 replace define V4L2_CAP_ASYNCIO device-capabilities
 replace define V4L2_CAP_STREAMING device-capabilities
+replace define V4L2_CAP_MC_CENTRIC device-capabilities
 replace define V4L2_CAP_DEVICE_CAPS device-capabilities
 replace define V4L2_CAP_TOUCH device-capabilities
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0acc06..4ff1224719a7 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -460,6 +460,8 @@ struct v4l2_capability {
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
+#define V4L2_CAP_MC_CENTRIC             0x20000000  /* Device require MC-centric hardware control */
+
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
 /*
-- 
2.13.6
