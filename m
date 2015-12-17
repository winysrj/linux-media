Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbbLQIlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:18 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 37/48] DocBook: media: Document the subdev selection API
Date: Thu, 17 Dec 2015 10:40:15 +0200
Message-Id: <1450341626-6695-38-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the subdev crop API is considered obsolete, the selection API
that replaces it deserves a full documentation instead of referring to
the crop API documentation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../media/v4l/vidioc-subdev-g-selection.xml        | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index c62a7360719b..9b59b49db0c3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -69,6 +69,43 @@
     more information on how each selection target affects the image
     processing pipeline inside the subdevice.</para>
 
+    <para>To retrieve a current selection rectangle applications set the
+    <structfield>pad</structfield> field of a &v4l2-subdev-selection; to the
+    desired pad number as reported by the media API, the
+    <structfield>which</structfield> field to
+    <constant>V4L2_SUBDEV_FORMAT_ACTIVE</constant> and the
+    <structfield>target</structfield> to the target selection rectangle. They
+    then call the <constant>VIDIOC_SUBDEV_G_SELECTION</constant> ioctl with a
+    pointer to this structure. The driver fills the members of the
+    <structfield>r</structfield> field or returns &EINVAL; if the input
+    arguments are invalid, or if selection is not supported on the given pad.
+    </para>
+
+    <para>To change a current selection rectangle applications set the
+    <structfield>pad</structfield>, <structfield>which</structfield> and
+    <structfield>target</structfield> fields and all members of the
+    <structfield>r</structfield> field. They then call the
+    <constant>VIDIOC_SUBDEV_S_SELECTION</constant> ioctl with a pointer to this
+    structure. The driver verifies the requested selection rectangle, adjusts it
+    based on the hardware capabilities and configures the device. Upon return
+    the &v4l2-subdev-selection; contains the current selection rectangle as
+    would be returned by a <constant>VIDIOC_SUBDEV_G_SELECTION</constant> call.
+    </para>
+
+    <para>Applications can query the device capabilities by setting the
+    <structfield>which</structfield> to
+    <constant>V4L2_SUBDEV_FORMAT_TRY</constant>. When set, 'try' selection
+    rectangles are not applied to the device by the driver, but are mangled
+    exactly as active selection rectangles and stored in the sub-device file
+    handle. Two applications querying the same sub-device would thus not
+    interfere with each other.</para>
+
+    <para>Drivers must not return an error solely because the requested
+    selection rectangle doesn't match the device capabilities. They must instead
+    modify the rectangle to match what the hardware can provide. The modified
+    selection rectangle should be as close as possible to the original request.
+    </para>
+
     <refsect2>
       <title>Types of selection targets</title>
 
-- 
2.4.10

