Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49420
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754537AbdHYJkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:40:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/3] media: videodev2: add a flag for vdev-centric devices
Date: Fri, 25 Aug 2017 06:40:06 -0300
Message-Id: <8d504be517755ee9449a007b5f2de52738c2df63.1503653839.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

As both vdev-centric and mc-centric devices may implement the
same APIs, we need a flag to allow userspace to distinguish
between them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst            | 6 ++++++
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 4 ++++
 include/uapi/linux/videodev2.h                   | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index a72d142897c0..eb3f0ec57edb 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -33,6 +33,12 @@ For **vdev-centric** control, the device and their corresponding hardware
 pipelines are controlled via the **V4L2 device** node. They may optionally
 expose via the :ref:`media controller API <media_controller>`.
 
+.. note::
+
+   **vdev-centric** devices should report V4L2_VDEV_CENTERED
+   :c:type:`v4l2_capability` flag (see :ref:`VIDIOC_QUERYCAP`).
+
+
 For **MC-centric** control, before using the V4L2 device, it is required to
 set the hardware pipelines via the
 :ref:`media controller API <media_controller>`. For those devices, the
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 12e0d9a63cd8..4856821b7608 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -252,6 +252,10 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
+    * - ``V4L2_VDEV_CENTERED``
+      - 0x20000000
+      - This is controlled via V4L2 device nodes (radio, video, vbi,
+        sdr
     * - ``V4L2_CAP_DEVICE_CAPS``
       - 0x80000000
       - The driver fills the ``device_caps`` field. This capability can
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45cf7359822c..d89090d99042 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -460,6 +460,8 @@ struct v4l2_capability {
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
+#define V4L2_CAP_VDEV_CENTERED          0x20000000  /* V4L2 Device is controlled via V4L2 device devnode */
+
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
 /*
-- 
2.13.3
