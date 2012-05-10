Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35963 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab2EJKbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DEQYJS3I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/23] V4L: Add camera 3A lock control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-10-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_3A_LOCK bitmask control allows applications to pause
or resume the automatic exposure, focus and wite balance adjustments.
It can be used, for example, to lock the 3A adjustments right before
a still image is captured, for pre-focus, etc.
The applications can control each of the algorithms independently,
through a corresponding control bit, if driver allows that.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   39 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    5 ++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index c0256a0..ccb1df9 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3301,6 +3301,45 @@ lens-distortion correction.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_3A_LOCK</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">This control locks or unlocks the automatic
+focus, exposure and white balance. The automatic adjustments can be paused
+independently by setting the corresponding lock bit to 1. The camera then retains
+the settings until the lock bit is cleared. The following lock bits are defined:
+</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_LOCK_EXPOSURE</constant></entry>
+		  <entry>Automatic exposure adjustments lock.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_LOCK_WHITE_BALANCE</constant></entry>
+		  <entry>Automatic white balance adjustments lock.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_LOCK_FOCUS</constant></entry>
+		  <entry>Automatic focus lock.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry spanname="descr">
+When a given algorithm is not enabled, drivers should ignore requests
+to lock it and should return no error. An example might be an application
+setting bit <constant>V4L2_LOCK_WHITE_BALANCE</constant> when the
+<constant>V4L2_CID_AUTO_WHITE_BALANCE</constant> control is set to
+<constant>FALSE</constant>. The value of this control may be changed
+by exposure, white balance or focus controls.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 4758e61..877ce60 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -661,6 +661,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 	case V4L2_CID_SCENE_MODE:		return "Scene Mode";
+	case V4L2_CID_3A_LOCK:			return "3A Lock";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -833,6 +834,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_FLASH_FAULT:
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
+	case V4L2_CID_3A_LOCK:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 6f1c5de..dae57ed 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1751,6 +1751,11 @@ enum v4l2_scene_mode {
 	V4L2_SCENE_MODE_TEXT			= 13,
 };
 
+#define V4L2_CID_3A_LOCK			(V4L2_CID_CAMERA_CLASS_BASE+27)
+#define V4L2_LOCK_EXPOSURE			(1 << 0)
+#define V4L2_LOCK_WHITE_BALANCE			(1 << 1)
+#define V4L2_LOCK_FOCUS				(1 << 2)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

