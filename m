Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53608
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752356AbdHZLxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:53:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v4 6/7] media: videodev2: add a flag for MC-centric devices
Date: Sat, 26 Aug 2017 08:53:24 -0300
Message-Id: <638ed268ca84c5e8ea810a2c27e397ab7e90585b.1503747774.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As both vdev-centric and MC-centric devices may implement the
same APIs, we need a flag to allow userspace to distinguish
between them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst            | 7 +++++++
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 5 +++++
 Documentation/media/videodev2.h.rst.exceptions   | 1 +
 include/uapi/linux/videodev2.h                   | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 64b1de047b1b..d0930fc170f0 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -46,6 +46,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
 can be controlled via the :ref:`sub-device API <subdev>`, which creates one
 device node per sub-device.
 
+.. attention::
+
+   Devices that require **mc-centric** hardware peripheral control should
+   report a ``V4L2_MC_CENTRIC`` :c:type:`v4l2_capability` flag
+   (see :ref:`VIDIOC_QUERYCAP`).
+
+
 In summary, for **MC-centric** hardware peripheral control:
 
 - The **V4L2 device** node is responsible for controlling the streaming
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 12e0d9a63cd8..2b08723375bc 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -252,6 +252,11 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
+    * - ``V4L2_MC_CENTRIC``
+      - 0x20000000
+      - Indicates that the device require **mc-centric** hardware
+        control, and thus can't be used by **v4l2-centric** applications.
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
index 45cf7359822c..7b490fe97980 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -460,6 +460,8 @@ struct v4l2_capability {
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
+#define V4L2_CAP_MC_CENTRIC             0x20000000  /* Device require mc-centric hardware control */
+
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
 /*
-- 
2.13.3
