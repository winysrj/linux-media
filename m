Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50741
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933600AbdHYPMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 11:12:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3 6/7] media: videodev2: add a flag for MC-centric devices
Date: Fri, 25 Aug 2017 12:11:56 -0300
Message-Id: <9a74d8dd04ae59abc341cb8fbaf71206c86c0e13.1503673702.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As both vdev-centric and MC-centric devices may implement the
same APIs, we need a flag to allow userspace to distinguish
between them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst            | 7 +++++++
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 5 +++++
 include/uapi/linux/videodev2.h                   | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index b5140dbba49a..3257a0527ac9 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -48,6 +48,13 @@ sub-devices' configuration can be controlled via the
 :ref:`sub-device API <subdev>`, whith creates one device node
 per sub-device.
 
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
