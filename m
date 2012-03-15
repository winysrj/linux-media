Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031805Ab2COQyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:45 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009K6QZ5MD@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X0016IQZ3YS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:39 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:16 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 02/23] V4L: Add White Balance Preset camera class control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_WHITE_BALANCE_PRESET control to allow selecting predefined
white balance configurations where supported by a camera. The following
menu items are included:

 - V4L2_WHITE_BALANCE_NONE,
 - V4L2_WHITE_BALANCE_INCANDESCENT,
 - V4L2_WHITE_BALANCE_FLUORESCENT,
 - V4L2_WHITE_BALANCE_DAYLIGHT,
 - V4L2_WHITE_BALANCE_CLOUDY,
 - V4L2_WHITE_BALANCE_SHADE,

This is a manual white balance control, in addition to V4L2_CID_RED_BALANCE,
V4L2_CID_BLUE_BALANCE and V4L2_CID_WHITE_BALANCE_TEMPERATURE.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   63 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   14 ++++++
 include/linux/videodev2.h                    |   10 ++++
 3 files changed, 87 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 16742c0..f8e1161 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3081,6 +3081,69 @@ camera sensor on or off, or specify its strength. Such band-stop filters can
 be used, for example, to filter out the fluorescent light component.</entry>
 	  </row>
 	  <row><entry></entry></row>
+
+	  <row id="v4l2-white-balance-preset">
+	    <entry spanname="id"><constant>V4L2_CID_WHITE_BALANCE_PRESET</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_white_balance_preset</entry>
+	  </row><row><entry spanname="descr">Sets a predefined white balance
+configuration. The presets determine color temperature of the light on a basis
+of which the camera performs white balance adjustments, in order to obtain most
+accurate color representation. This control has no effect when automatic white
+balance adjustments are enabled, i.e. <constant>V4L2_CID_AUTO_WHITE_BALANCE
+</constant> control is set to <constant>TRUE</constant> (1). The following white
+balance presets are listed in order of incresing color temperature.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_NONE</constant>&nbsp;</entry>
+		  <entry>None of the presets is active, i.e. the white balance
+preset feature is disabled. It is useful when driver exposes other manual white
+balance controls, like <constant>V4L2_CID_RED_BALANCE</constant> and <constant>
+V4L2_CID_BLUE_BALANCE</constant>, that may render a configured preset invalid.
+</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_INCANDESCENT</constant>&nbsp;</entry>
+		  <entry>White balance settings for incandescent (tungsten) lighting.
+It generally cools down the colors and corresponds approximately to 2500...3500 K
+color temperature range.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_FLUORESCENT</constant>&nbsp;</entry>
+		  <entry>With this setting the camera will compensate for fluorescent
+lighting. It corresponds approximately to 4000...5000 K color temperature.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_DAYLIGHT</constant>&nbsp;</entry>
+		  <entry>White balance settings for daylight (with clear sky).
+This corresponds approximately to 5000...6500 K color temperature.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_FLASH</constant>&nbsp;</entry>
+		  <entry>With this setting the camera will compensate for the flash
+light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
+color temperature.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_CLOUDY</constant>&nbsp;</entry>
+		  <entry>White balance settings for moderately overcast sky.
+This option corresponds approximately to 6500...8000 K color temperature range
+an will make colors appear warmer than with the <constant>
+V4L2_WHITE_BALANCE_PRESET_DAYLIGHT</constant> preset.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_WHITE_BALANCE_PRESET_SHADE</constant>&nbsp;</entry>
+		  <entry>White balance settings for shade or heavily overcast
+sky. It corresponds approximately to 9000...10000 K color temperature.
+</entry>
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
index 65aa63c..6dbbe03 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -256,6 +256,15 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Vivid",
 		NULL
 	};
+	static const char * const white_balance_preset[] = {
+		"None",
+		"Incandescent",
+		"Fluorescent",
+		"Daylight",
+		"Cloudy",
+		"Shade",
+		NULL,
+	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
 		"50 useconds",
@@ -429,6 +438,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_auto_focus_distance;
 	case V4L2_CID_COLORFX:
 		return colorfx;
+	case V4L2_CID_WHITE_BALANCE_PRESET:
+		return white_balance_preset;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -621,6 +632,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";
 	case V4L2_CID_AUTO_FOCUS_FACE_PRIORITY:	return "Auto Focus, Face Priority";
 
+	case V4L2_CID_WHITE_BALANCE_PRESET:	return "White Balance, Preset";
+
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
@@ -754,6 +767,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_AUTO_FOCUS_AREA:
 	case V4L2_CID_AUTO_FOCUS_DISTANCE:
 	case V4L2_CID_COLORFX:
+	case V4L2_CID_WHITE_BALANCE_PRESET:
 	case V4L2_CID_TUNE_PREEMPHASIS:
 	case V4L2_CID_FLASH_LED_MODE:
 	case V4L2_CID_FLASH_STROBE_SOURCE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 615d939..250ac9e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1718,6 +1718,16 @@ enum v4l2_auto_focus_area {
 
 #define V4L2_CID_AUTO_FOCUS_FACE_PRIORITY	(V4L2_CID_CAMERA_CLASS_BASE+24)
 
+#define V4L2_CID_WHITE_BALANCE_PRESET		(V4L2_CID_CAMERA_CLASS_BASE+30)
+enum v4l2_white_balance_preset {
+	V4L2_WHITE_BALANCE_PRESET_NONE		= 0,
+	V4L2_WHITE_BALANCE_PRESET_INCANDESCENT	= 1,
+	V4L2_WHITE_BALANCE_PRESET_FLUORESCENT	= 2,
+	V4L2_WHITE_BALANCE_PRESET_DAYLIGHT	= 3,
+	V4L2_WHITE_BALANCE_PRESET_CLOUDY	= 4,
+	V4L2_WHITE_BALANCE_PRESET_SHADE		= 5,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.9.2

