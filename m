Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62270 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab2EDScW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:22 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3I00I6BGR09Q@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:30:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I006JOGTU1P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:18 +0100 (BST)
Date: Fri, 04 May 2012 20:32:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 05/12] V4L: Add camera image stabilization control
In-reply-to: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336156337-10935-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_IMAGE_STABILIZATION control for the camera image
stabilization feature. This control can be used to enable/disable
image stabilization. It might get converted to a menu control
in future if more options are needed.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   10 ++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    1 +
 3 files changed, 13 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0256a02..7468267 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3033,6 +3033,16 @@ control in future, if more options are required.</para></footnote></entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-image-stabilization">
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_STABILIZATION</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Enables or disables image stabilization.
+	      <footnoteref linkend="ctypeconv"/></entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8b47c05..406916a 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -615,6 +615,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
+	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -707,6 +708,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+	case V4L2_CID_IMAGE_STABILIZATION:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 8964ebc..9b5fe8a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1710,6 +1710,7 @@ enum v4l2_auto_n_preset_white_balance {
 };
 
 #define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
+#define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)
 
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
-- 
1.7.10

