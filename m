Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56255 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933979AbdC3Pif (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 11:38:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] docs-rst: clarify field vs frame height in the subdev API
Date: Thu, 30 Mar 2017 17:38:20 +0200
Message-Id: <20170330153820.14853-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_SUBDEV_G/S_FMT take the field size if V4L2_FIELD_ALTERNATE field
order is set, but the VIDIOC_SUBDEV_G/S_SELECTION rectangles still refer
to frame size, regardless of the field order setting.
VIDIOC_SUBDEV_ENUM_FRAME_SIZES always returns frame sizes as opposed to
field sizes.

This was not immediately clear to me when reading the documentation, so
this patch adds some clarifications in the relevant places.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/media/uapi/v4l/dev-subdev.rst              | 16 ++++++++++++----
 Documentation/media/uapi/v4l/subdev-formats.rst          |  3 ++-
 .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst     |  4 ++++
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst         |  2 ++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index cd28701802086..2f0a41f3796f0 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -82,7 +82,8 @@ Pad-level Formats
 .. note::
 
     For the purpose of this section, the term *format* means the
-    combination of media bus data format, frame width and frame height.
+    combination of media bus data format, frame width and frame height,
+    unless otherwise noted.
 
 Image formats are typically negotiated on video capture and output
 devices using the format and
@@ -120,7 +121,9 @@ can expose pad-level image format configuration to applications. When
 they do, applications can use the
 :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
-negotiate formats on a per-pad basis.
+negotiate formats on a per-pad basis. Note that when those ioctls are
+called with or return the field order set to ``V4L2_FIELD_ALTERNATE``,
+the format contains the field height, which is half the frame height.
 
 Applications are responsible for configuring coherent parameters on the
 whole pipeline and making sure that connected pads have compatible
@@ -379,7 +382,10 @@ is supported by the hardware.
    pad for further processing.
 
 2. Sink pad actual crop selection. The sink pad crop defines the crop
-   performed to the sink pad format.
+   performed to the sink pad format. The crop rectangle always refers to
+   the frame size, even if the sink pad format has field order set to
+   ``V4L2_FIELD_ALTERNATE`` and the actual processed images are only
+   field sized.
 
 3. Sink pad actual compose selection. The size of the sink pad compose
    rectangle defines the scaling ratio compared to the size of the sink
@@ -393,7 +399,9 @@ is supported by the hardware.
 5. Source pad format. The source pad format defines the output pixel
    format of the subdev, as well as the other parameters with the
    exception of the image width and height. Width and height are defined
-   by the size of the source pad actual crop selection.
+   by the size of the source pad actual crop selection. If the source pad
+   format has field order set to ``V4L2_FIELD_ALTERNATE``, the source pad
+   field height is half the source pad crop selection height.
 
 Accessing any of the above rectangles not supported by the subdev will
 return ``EINVAL``. Any rectangle referring to a previous unsupported
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index d6152c907b8ba..f7195e5ee6e78 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -19,7 +19,8 @@ Media Bus Formats
       - Image width, in pixels.
     * - __u32
       - ``height``
-      - Image height, in pixels.
+      - Image height, in pixels. This is the field height for
+        ``V4L2_FIELD_ALTERNATE`` field order, or the frame height otherwise.
     * - __u32
       - ``code``
       - Format code, from enum
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 746c24ed97a05..a78ae138f8a87 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -55,6 +55,10 @@ maximum values. Applications must use the
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctl to try the
 sub-device for an exact supported frame size.
 
+Note that if ``V4L2_FIELD_ALTERNATE`` field order is chosen in the
+:ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls, those take
+the field size, which is only half the height of the frame size.
+
 Available frame sizes may depend on the current 'try' formats at other
 pads of the sub-device, as well as on the current active links and the
 current values of V4L2 controls. See
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 071d9c033db6b..253e0ccb78224 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -45,6 +45,8 @@ function of the crop API, and more, are supported by the selections API.
 See :ref:`subdev` for more information on how each selection target
 affects the image processing pipeline inside the subdevice.
 
+Note that selection rectangles always refer to frame sizes, not field sizes.
+
 
 Types of selection targets
 --------------------------
-- 
2.11.0
