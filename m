Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56829 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972Ab2D0OXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500GG56ME0E30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M35004U06N93L@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:34 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 05/14] V4L: Add camera image stabilization control
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-6-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_IMAGE_STABILIZATION control allows to control the
camera's image stabilization feature. It can be used to enable/disable
image stabilization. It can be extended with new menu items if the image
stabilization technique selection is needed.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   23 +++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    9 +++++++++
 include/linux/videodev2.h                    |    5 +++++
 3 files changed, 37 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 487b7b5..ac27444 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3046,6 +3046,29 @@ times.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-image-stabilization-type">
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_STABILIZATION</constant></entry>
+	    <entry>enum&nbsp;v4l2_image_stabilization_type</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Enables or disables image stabilization.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_IMAGE_STABILIZATION_DISABLED</constant></entry>
+		  <entry>Image stabilization is disabled.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_IMAGE_STABILIZATION_ENABLED</constant></entry>
+		  <entry>Image stabilization is enabled.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index ad2f035..305a203 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -261,6 +261,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Enabled",
 		NULL
 	};
+	static const char * const camera_image_stabilization[] = {
+		"Disabled",
+		"Enabled",
+		NULL
+	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
 		"50 Microseconds",
@@ -434,6 +439,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return auto_n_preset_white_balance;
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 		return camera_wide_dynamic_range;
+	case V4L2_CID_IMAGE_STABILIZATION:
+		return camera_image_stabilization;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -622,6 +629,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
+	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -760,6 +768,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+	case V4L2_CID_IMAGE_STABILIZATION:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3ca9b10..62d1d66 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1714,6 +1714,11 @@ enum v4l2_wide_dynamic_range_type {
 	V4L2_WIDE_DYNAMIC_RANGE_DISABLED	= 0,
 	V4L2_WIDE_DYNAMIC_RANGE_ENABLED		= 1,
 };
+#define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)
+enum v4l2_image_stabilization_type {
+	V4L2_IMAGE_STABILIZATION_DISABLED	= 0,
+	V4L2_IMAGE_STABILIZATION_ENABLED	= 1,
+};
 
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
-- 
1.7.10

