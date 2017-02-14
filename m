Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:2324 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752726AbdBNMV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 07:21:58 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH v3 1/2] v4l: Add camera voice coil lens control class, current control
Date: Tue, 14 Feb 2017 14:20:22 +0200
Message-Id: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a V4L2 control class for voice coil lens driver devices. These are
simple devices that are used to move a camera lens from its resting
position.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 28 ++++++++++++++++++++++
 include/uapi/linux/v4l2-controls.h                 |  8 +++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..a75451a 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3022,6 +3022,34 @@ Image Process Control IDs
     driver specific and are documented in :ref:`v4l-drivers`.
 
 
+.. _voice-coil-lens-controls:
+
+Voice Coil Lens Control Reference
+=================================
+
+The Voice Coil class controls are used to control voice coil lens
+devices. These are very simple devices that consist of a voice coil, a
+spring and a lens. The current applied on the voice coil is used to
+move the lens away from the resting position which typically is (close
+to) infinity. The higher the current applied, the closer the lens is
+typically focused.
+
+.. _voice-coil-lens-control-is:
+
+Voice Coil Lens Control IDs
+---------------------------
+
+``V4L2_CID_VOICE_COIL_CLASS (class)``
+    The VOICE_COIL class descriptor.
+
+``V4L2_CID_VOICE_COIL_CURRENT (integer)``
+    Current applied on a voice coil. The more current is applied, the
+    more is the position of the lens moved from its resting position.
+    Do note that there may be a ringing effect; the lens will
+    oscillate after changing the current applied unless the device
+    implements ringing compensation.
+
+
 .. _dv-controls:
 
 Digital Video Control Reference
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e0..9ef152b 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -62,6 +62,7 @@
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
 #define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
+#define V4L2_CTRL_CLASS_VOICE_COIL	0x00a40000	/* Voice coil lens driver controls */
 
 /* User-class control IDs */
 
@@ -894,6 +895,13 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
 
+/* Voice coil lens driver controls */
+
+#define V4L2_CID_VOICE_COIL_CLASS_BASE		(V4L2_CTRL_CLASS_VOICE_COIL | 0x900)
+#define V4L2_CID_VOICE_COIL_CLASS		(V4L2_CTRL_CLASS_VOICE_COIL | 1)
+
+#define V4L2_CID_VOICE_COIL_CURRENT		(V4L2_CID_VOICE_COIL_CLASS_BASE + 1)
+
 
 /*  DV-class control IDs defined by V4L2 */
 #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
-- 
2.7.4
