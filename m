Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47324 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751744AbdG1LFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 07:05:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/2] v4l: document VIDIOC_SUBDEV_QUERYCAP
Date: Fri, 28 Jul 2017 13:05:29 +0200
Message-Id: <20170728110529.4057-3-hverkuil@xs4all.nl>
In-Reply-To: <20170728110529.4057-1-hverkuil@xs4all.nl>
References: <20170728110529.4057-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add documentation for the new VIDIOC_SUBDEV_QUERYCAP ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/user-func.rst         |   1 +
 .../media/uapi/v4l/vidioc-subdev-querycap.rst      | 121 +++++++++++++++++++++
 2 files changed, 122 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst

diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
index 3e0413b83a33..eda5a01b5228 100644
--- a/Documentation/media/uapi/v4l/user-func.rst
+++ b/Documentation/media/uapi/v4l/user-func.rst
@@ -71,6 +71,7 @@ Function Reference
     vidioc-subdev-g-fmt
     vidioc-subdev-g-frame-interval
     vidioc-subdev-g-selection
+    vidioc-subdev-querycap
     vidioc-subscribe-event
     func-mmap
     func-munmap
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst b/Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst
new file mode 100644
index 000000000000..6143d201b11e
--- /dev/null
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst
@@ -0,0 +1,121 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDIOC_SUBDEV_QUERYCAP:
+
+****************************
+ioctl VIDIOC_SUBDEV_QUERYCAP
+****************************
+
+Name
+====
+
+VIDIOC_SUBDEV_QUERYCAP - Query sub-device capabilities
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_QUERYCAP, struct v4l2_subdev_capability *argp )
+    :name: VIDIOC_SUBDEV_QUERYCAP
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <func-open>`.
+
+``argp``
+
+
+Description
+===========
+
+All V4L2 sub-devices support the
+``VIDIOC_SUBDEV_QUERYCAP`` ioctl. It is used to identify
+kernel devices compatible with this specification and to obtain
+information about driver and hardware capabilities. The ioctl takes a
+pointer to a struct :c:type:`v4l2_subdev_capability` which is filled by the
+driver. When the driver is not compatible with this specification the ioctl
+returns ``ENOTTY`` error code.
+
+.. tabularcolumns:: |p{1.5cm}|p{2.5cm}|p{13cm}|
+
+.. c:type:: v4l2_subdev_capability
+
+.. flat-table:: struct v4l2_subdev_capability
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 4 20
+
+    * - __u32
+      - ``version``
+      - Version number of the driver.
+
+	The version reported is provided by the
+	V4L2 subsystem following the kernel numbering scheme. However, it
+	may not always return the same version as the kernel if, for
+	example, a stable or distribution-modified kernel uses the V4L2
+	stack from a newer kernel.
+
+	The version number is formatted using the ``KERNEL_VERSION()``
+	macro:
+    * - :cspan:`2`
+
+	``#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))``
+
+	``__u32 version = KERNEL_VERSION(0, 8, 1);``
+
+	``printf ("Version: %u.%u.%u\\n",``
+
+	``(version >> 16) & 0xFF, (version >> 8) & 0xFF, version & 0xFF);``
+    * - __u32
+      - ``device_caps``
+      - Sub-device capabilities of the opened device, see
+	:ref:`subdevice-capabilities`.
+    * - char
+      - ``name``\ [32]
+      - NUL-terminated name of the sub-device.
+    * - __u32
+      - ``entity_id``
+      - The media controller entity ID of the sub-device. This is only valid if
+        the ``V4L2_SUBDEV_CAP_ENTITY`` capability is set, it is 0 otherwise.
+    * - __u32
+      - ``media_node_major``
+      - The major number of the media controller device node corresponding sub-device.
+        This is only valid if the ``V4L2_SUBDEV_CAP_ENTITY`` capability is set, it is
+	0 otherwise.
+    * - __u32
+      - ``media_node_minor``
+      - The minor number of the media controller device node corresponding sub-device.
+        This is only valid if the ``V4L2_SUBDEV_CAP_ENTITY`` capability is set, it is
+	0 otherwise.
+    * - __u32
+      - ``reserved``\ [19]
+      - Reserved for future extensions. Applications and drivers must set
+	the array to zero.
+
+.. tabularcolumns:: |p{6cm}|p{2.2cm}|p{8.8cm}|
+
+.. _subdevice-capabilities:
+
+.. cssclass:: longtable
+
+.. flat-table:: Sub-Device Capabilities Flags
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * - ``V4L2_SUBDEV_CAP_ENTITY``
+      - 0x00000001
+      - The sub-device is a media controller entity and the ``entity_id``,
+        ``media_node_major`` and ``media_node_minor`` fields of
+        struct :c:type:`v4l2_subdev_capability` are valid. These fields
+	are 0 if this capability is not set.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.13.1
