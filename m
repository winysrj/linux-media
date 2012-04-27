Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976Ab2D0OXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500AQJ6NK4Q30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3500LMB6N8JR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:32 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:26 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 09/14] V4L: Add camera 3A lock control
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-10-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
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
 Documentation/DocBook/media/v4l/controls.xml |   40 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    5 ++++
 3 files changed, 47 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index bf481d4..51509f4 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3253,6 +3253,46 @@ lens-distortion correction.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_3A_LOCK</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">This control locks or unlocks the automatic
+exposure, white balance and focus. The automatic adjustments can be paused
+independently by setting the coresponding lock bit to 1. The camera then retains
+the corresponding 3A settings, until the lock bit is cleared. The value of this
+control may be changed by other, exposure, white balance or focus controls. The
+following control bits are defined :
+</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_3A_LOCK_EXPOSURE</constant></entry>
+		  <entry>Automatic exposure adjustments lock.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_3A_LOCK_WHITE_BALANCE</constant></entry>
+		  <entry>Automatic white balance adjustments lock.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_3A_LOCK_FOCUS</constant></entry>
+		  <entry>Automatic focus adjustments lock.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry spanname="descr">
+When a particular algorithm is not enabled, drivers should ignore requests
+to lock it and should return no error. An example might be an application
+setting bit <constant>V4L2_3A_LOCK_WHITE_BALANCE</constant> when the
+<constant>V4L2_CID_AUTO_WHITE_BALANCE</constant> control is set to
+<constant>FALSE</constant>.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8b48893..d45f00c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -671,6 +671,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
 	case V4L2_CID_SCENE_MODE:		return "Scene Mode";
+	case V4L2_CID_3A_LOCK:			return "3A Lock";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -843,6 +844,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_FLASH_FAULT:
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
+	case V4L2_CID_3A_LOCK:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 2c82fd9..7c30d54 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1752,6 +1752,11 @@ enum v4l2_scene_mode {
 	V4L2_SCENE_MODE_TEXT			= 13,
 };
 
+#define V4L2_CID_3A_LOCK			(V4L2_CID_CAMERA_CLASS_BASE+27)
+#define V4L2_3A_LOCK_EXPOSURE			(1 << 0)
+#define V4L2_3A_LOCK_WHITE_BALANCE		(1 << 1)
+#define V4L2_3A_LOCK_FOCUS			(1 << 2)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

