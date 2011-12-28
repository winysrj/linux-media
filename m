Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:24442 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1L1GXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 01:23:52 -0500
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWW008RLHRJL5K0@mailout3.samsung.com> for
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
Subject: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
Date: Wed, 28 Dec 2011 15:23:46 +0900
Message-id: <1325053428-2626-3-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It adds the new CID for setting Scenemode. This CID is provided as
menu type using the following items:
enum v4l2_scenemode {
	V4L2_SCENEMODE_NONE = 0,
	V4L2_SCENEMODE_NORMAL = 1,
	V4L2_SCENEMODE_PORTRAIT = 2,
	V4L2_SCENEMODE_LANDSCAPE = 3,
	V4L2_SCENEMODE_SPORTS = 4,
	V4L2_SCENEMODE_PARTY_INDOOR = 5,
	V4L2_SCENEMODE_BEACH_SNOW = 6,
	V4L2_SCENEMODE_SUNSET = 7,
	V4L2_SCENEMODE_DAWN_DUSK = 8,
	V4L2_SCENEMODE_FALL = 9,
	V4L2_SCENEMODE_NIGHT = 10,
	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
	V4L2_SCENEMODE_FIRE = 12,
	V4L2_SCENEMODE_TEXT = 13,
	V4L2_SCENEMODE_CANDLE = 14,
};

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   88 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   21 ++++++
 include/linux/videodev2.h                    |   19 ++++++
 3 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 350c138..afe1845 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2879,6 +2879,94 @@ it one step further. This is a write-only control.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-scenemode">
+	    <entry spanname="id"><constant>V4L2_CID_SCENEMODE</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_scenemode</entry>
+	  </row><row><entry spanname="descr">This control sets
+	  the camera's scenemode, and it is provided by the type of
+	  the enum values. The "None" mode means the status
+	  when scenemode algorithm is not activated, like after booting time.
+	  On the other hand, the "Normal" mode means the scenemode algorithm
+	  is activated on the normal mode.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_NONE</constant>&nbsp;</entry>
+		  <entry>Scenemode None.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_NORMAL</constant>&nbsp;</entry>
+		  <entry>Scenemode Normal.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_PORTRAIT</constant>&nbsp;</entry>
+		  <entry>Scenemode Portrait.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_LANDSCAPE</constant>&nbsp;</entry>
+		  <entry>Scenemode Landscape.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_SPORTS</constant>&nbsp;</entry>
+		  <entry>Scenemode Sports.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_PARTY_INDOOR</constant>&nbsp;</entry>
+		  <entry>Scenemode Party Indoor.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_BEACH_SNOW</constant>&nbsp;</entry>
+		  <entry>Scenemode Beach Snow.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_SUNSET</constant>&nbsp;</entry>
+		  <entry>Scenemode Beach Snow.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_DAWN_DUSK</constant>&nbsp;</entry>
+		  <entry>Scenemode Dawn Dusk.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_FALL</constant>&nbsp;</entry>
+		  <entry>Scenemode Fall.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_NIGHT</constant>&nbsp;</entry>
+		  <entry>Scenemode Night.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_AGAINST_LIGHT</constant>&nbsp;</entry>
+		  <entry>Scenemode Against Light.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_FIRE</constant>&nbsp;</entry>
+		  <entry>Scenemode Fire.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_TEXT</constant>&nbsp;</entry>
+		  <entry>Scenemode Text.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENEMODE_CANDLE</constant>&nbsp;</entry>
+		  <entry>Scenemode Candle.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row><row><entry spanname="descr">Prevent video from being acquired
+by the camera. When this control is set to <constant>TRUE</constant> (1), no
+image can be captured by the camera. Common means to enforce privacy are
+mechanical obturation of the sensor and firmware image processing, but the
+device is not restricted to these methods. Devices that implement the privacy
+control must support read access and may support write access.</entry>
+	  </row>
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index f51b576..fef58c2 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -242,6 +242,23 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Shade",
 		NULL,
 	};
+	static const char * const scenemode[] = {
+		"None",
+		"Normal",
+		"Landscape",
+		"Sports",
+		"Party Indoor",
+		"Beach Snow",
+		"Sunset",
+		"Dawn Dusk",
+		"Fall",
+		"Night",
+		"Against Light",
+		"Fire",
+		"Text",
+		"Candle",
+		NULL,
+	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
 		"50 useconds",
@@ -400,6 +417,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return colorfx;
 	case V4L2_CID_PRESET_WHITE_BALANCE:
 		return preset_white_balance;
+	case V4L2_CID_SCENEMODE:
+		return scenemode;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -578,6 +597,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
+	case V4L2_CID_SCENEMODE:		return "Scenemode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -692,6 +712,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_PRESET_WHITE_BALANCE:
+	case V4L2_CID_SCENEMODE:
 	case V4L2_CID_TUNE_PREEMPHASIS:
 	case V4L2_CID_FLASH_LED_MODE:
 	case V4L2_CID_FLASH_STROBE_SOURCE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a842de0..bc14feb 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1627,6 +1627,25 @@ enum v4l2_preset_white_balance {
 	V4L2_WHITE_BALANCE_SHADE = 4,
 };
 
+#define V4L2_CID_SCENEMODE			(V4L2_CID_CAMERA_CLASS_BASE+20)
+enum v4l2_scenemode {
+	V4L2_SCENEMODE_NONE = 0,
+	V4L2_SCENEMODE_NORMAL = 1,
+	V4L2_SCENEMODE_PORTRAIT = 2,
+	V4L2_SCENEMODE_LANDSCAPE = 3,
+	V4L2_SCENEMODE_SPORTS = 4,
+	V4L2_SCENEMODE_PARTY_INDOOR = 5,
+	V4L2_SCENEMODE_BEACH_SNOW = 6,
+	V4L2_SCENEMODE_SUNSET = 7,
+	V4L2_SCENEMODE_DAWN_DUSK = 8,
+	V4L2_SCENEMODE_FALL = 9,
+	V4L2_SCENEMODE_NIGHT = 10,
+	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
+	V4L2_SCENEMODE_FIRE = 12,
+	V4L2_SCENEMODE_TEXT = 13,
+	V4L2_SCENEMODE_CANDLE = 14,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.4.1

