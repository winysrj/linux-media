Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:21126 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1L1GXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 01:23:52 -0500
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWW0012ZHQX9RM0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Dec 2011 15:23:50 +0900 (KST)
Received: from riverful-ubuntu.165.213.246.161 ([165.213.219.119])
 by mmp1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LWW007D6HRPXC40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Dec 2011 15:23:50 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com,
	"HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
Date: Wed, 28 Dec 2011 15:23:47 +0900
Message-id: <1325053428-2626-4-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It adds the new CID for setting White Balance Preset. This CID is provided as
button type. This can commands only if the camera turn on/off this function.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   12 ++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 ++
 include/linux/videodev2.h                    |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index afe1845..bed6c66 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2958,6 +2958,18 @@ it one step further. This is a write-only control.</entry>
 	  <row><entry></entry></row>
 
 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_WDR</constant></entry>
+	    <entry>button</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Wide Dynamic Range. It makes
+	    the image be more clear by adjusting the image's intensity
+	    of the illumination. This function can be provided according to
+	    the capability of the hardware(sensor or AP's multimedia block).
+	    </entry>
+	  </row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
 	  </row><row><entry spanname="descr">Prevent video from being acquired
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index fef58c2..66110bc 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -598,6 +598,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
 	case V4L2_CID_SCENEMODE:		return "Scenemode";
+	case V4L2_CID_WDR:			return "Wide Dynamic Range";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -687,6 +688,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
+	case V4L2_CID_WDR:
 	case V4L2_CID_FLASH_STROBE:
 	case V4L2_CID_FLASH_STROBE_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index bc14feb..f85ad6c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1646,6 +1646,8 @@ enum v4l2_scenemode {
 	V4L2_SCENEMODE_CANDLE = 14,
 };
 
+#define V4L2_CID_WDR				(V4L2_CID_CAMERA_CLASS_BASE+21)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.4.1

