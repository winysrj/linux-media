Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58214 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2EDScY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3I00AUCGSVRTA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:31:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I00CZXGTT58@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:18 +0100 (BST)
Date: Fri, 04 May 2012 20:32:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 04/12] V4L: Add camera wide dynamic range control
In-reply-to: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336156337-10935-5-git-send-email-s.nawrocki@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_WIDE_DYNAMIC_RANGE camera class control for the
camera wide dynamic range (WDR, HDR) feature. This control
can be used to enable/disable wide dynamic range. It might
get converted to a menu control in future if more options
are needed.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   15 +++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    2 ++
 3 files changed, 19 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e3f9277..0256a02 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3018,6 +3018,21 @@ sky. It corresponds approximately to 9000...10000 K color temperature.
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-wide-dynamic-range">
+	    <entry spanname="id"><constant>V4L2_CID_WIDE_DYNAMIC_RANGE</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Enables or disables the camera's wide dynamic
+range feature. This feature allows to obtain clear images in situations where
+intensity of the illumination varies significantly throughout the scene, i.e.
+there are simultaneously very dark and very bright areas. It is most commonly
+realized in cameras by combining two subsequent frames with different exposure
+times. <footnote id="ctypeconv"><para> This control may be changed to a menu
+control in future, if more options are required.</para></footnote></entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 02fa9b0..8b47c05 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -614,6 +614,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -705,6 +706,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 1460419..8964ebc 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1709,6 +1709,8 @@ enum v4l2_auto_n_preset_white_balance {
 	V4L2_WHITE_BALANCE_SHADE		= 9,
 };
 
+#define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

