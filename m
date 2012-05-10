Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14084 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2EJKbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S00EXWYIOOS40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DAPYJP3L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:02 +0100 (BST)
Date: Thu, 10 May 2012 12:30:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/23] V4L: Add camera image stabilization control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-6-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
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
index 02bf5a6..5679089 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3107,6 +3107,16 @@ control in the future, if more options are required.</para></footnote></entry>
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
index 6d7109e..9b2cd71 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -622,6 +622,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
+	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -714,6 +715,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+	case V4L2_CID_IMAGE_STABILIZATION:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a84e93c..8f73ef6 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1717,6 +1717,7 @@ enum v4l2_auto_n_preset_white_balance {
 };
 
 #define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
+#define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)
 
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
-- 
1.7.10

