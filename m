Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51227 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752623AbdDJT1S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 11/15] vidioc-queryctrl.rst: document V4L2_CTRL_FLAG_MODIFY_LAYOUT
Date: Mon, 10 Apr 2017 21:26:47 +0200
Message-Id: <20170410192651.18486-12-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this new control flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 13 +++++++++++++
 Documentation/media/videodev2.h.rst.exceptions    |  1 +
 2 files changed, 14 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 82769de801b1..1ffdc3f3c614 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -507,6 +507,19 @@ See also the examples in :ref:`control`.
 	represents an action on the hardware. For example: clearing an
 	error flag or triggering the flash. All the controls of the type
 	``V4L2_CTRL_TYPE_BUTTON`` have this flag set.
+    * .. _FLAG_MODIFY_LAYOUT:
+
+      - ``V4L2_CTRL_FLAG_MODIFY_LAYOUT``
+      - 0x0400
+      - Changing this control value may modify the layout of the
+        buffer (for video devices) or the media bus format (for sub-devices).
+
+	A typical example would be the ``V4L2_CID_ROTATE`` control.
+
+	Note that typically controls with this flag will also set the
+	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
+	streaming is in progress since most drivers do not support changing
+	the format in that case.
 
 
 Return Value
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index c9c611b18ba1..a5cb0a8686ac 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -341,6 +341,7 @@ replace define V4L2_CTRL_FLAG_WRITE_ONLY control-flags
 replace define V4L2_CTRL_FLAG_VOLATILE control-flags
 replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
 replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
+replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
 
 replace define V4L2_CTRL_FLAG_NEXT_CTRL control
 replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
-- 
2.11.0
