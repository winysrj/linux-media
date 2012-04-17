Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2DQKKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:09 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M005QQC8MZN@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M0018LC8OLM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:00 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/15] V4L: Add camera wide dynamic range control
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_WIDE_DYNAMIC_RANGE camera class control allows to control
the camera wide dynamic range (WDR, HDR) feature. It can be used to
enable/disable WDR. For the WDR technique selection separate menu control
should be added.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   14 ++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    2 ++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0ee3e9c..55882de 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3081,6 +3081,20 @@ sky. It corresponds approximately to 9000...10000 K color temperature.
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_WIDE_DYNAMIC_RANGE</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Enables or disables the camera's
+wide dynamic range feature.  This feature allows to obtain clear images
+in situations where intensity of the illumination varies significantly
+throughout the scene, i.e. there are simultaneously very dark and very
+bright areas. It is most commonly realized in cameras by combining
+two subsequent frames of different exposure times.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index b6cd147..93bbf65 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -619,6 +619,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 
 	case V4L2_CID_WHITE_BALANCE_PRESET:	return "White Balance, Preset";
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -710,6 +711,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 537663a..a4ac032 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1741,6 +1741,8 @@ enum v4l2_white_balance_preset {
 	V4L2_WHITE_BALANCE_PRESET_SHADE		= 7,
 };
 
+#define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

