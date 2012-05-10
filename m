Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35963 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831Ab2EJKbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DEPYJS3I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/23] V4L: Add camera scene mode control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-9-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add control for the scene mode feature available in image sensor
with more advanced ISP firmware. The V4L2_CID_SCENE_MODE menu
control allows to select a set of parameters or a specific image
processing and capture control algorithm optimized for common
image capture conditions.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  117 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   21 +++++
 include/linux/videodev2.h                    |   18 ++++
 3 files changed, 156 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9571c96..c0256a0 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3184,6 +3184,123 @@ sensitivity adjustments.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-scene-mode">
+	    <entry spanname="id"><constant>V4L2_CID_SCENE_MODE</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_scene_mode</entry>
+	  </row><row><entry spanname="descr">This control allows to select
+scene programs as the camera automatic modes optimized for common shooting
+scenes. Within these modes the camera determines best exposure, aperture,
+focusing, light metering, white balance and equivalent sensitivity. The
+controls of those parameters are influenced by the scene mode control.
+An exact behavior in each mode is subject to the camera specification.
+
+<para>When the scene mode feature is not used, this control should be set to
+<constant>V4L2_SCENE_MODE_NONE</constant> to make sure the other possibly
+related controls are accessible. The following scene programs are defined:
+</para>
+</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_NONE</constant>&nbsp;</entry>
+		  <entry>The scene mode feature is disabled.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_BACKLIGHT</constant>&nbsp;</entry>
+		  <entry>Backlight. Compensates for dark shadows when light is
+		  coming from behind a subject, also by automatically turning
+		  on the flash.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_BEACH_SNOW</constant>&nbsp;</entry>
+		  <entry>Beach and snow. This mode compensates for all-white or
+bright scenes, which tend to look gray and low contrast, when camera's automatic
+exposure is based on an average scene brightness. To compensate, this mode
+automatically slightly overexposes the frames. The white balance may also be
+adjusted to compensate for the fact that reflected snow looks bluish rather
+than white.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_CANDLELIGHT</constant>&nbsp;</entry>
+		  <entry>Candle light. The camera generally raises the ISO
+sensitivity and lowers the shutter speed. This mode compensates for relatively
+close subject in the scene. The flash is disabled in order to preserve the
+ambiance of the light.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_DAWN_DUSK</constant>&nbsp;</entry>
+		  <entry>Dawn and dusk. Preserves the colors seen in low
+natural light before dusk and after down. The camera may turn off the flash,
+and automatically focus at infinity. It will usually boost saturation and
+lower the shutter speed.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_FALL_COLORS</constant>&nbsp;</entry>
+		  <entry>Fall colors. Increases saturation and adjusts white
+balance for color enhancement. Pictures of autumn leaves get saturated reds
+and yellows.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_FIREWORKS</constant>&nbsp;</entry>
+		  <entry>Fireworks. Long exposure times are used to capture
+the expanding burst of light from a firework. The camera may invoke image
+stabilization.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_LANDSCAPE</constant>&nbsp;</entry>
+		  <entry>Landscape. The camera may choose a small aperture to
+provide deep depth of field and long exposure duration to help capture detail
+in dim light conditions. The focus is fixed at infinity. Suitable for distant
+and wide scenery.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_NIGHT</constant>&nbsp;</entry>
+		  <entry>Night, also known as Night Landscape. Designed for low
+light conditions, it preserves detail in the dark areas without blowing out bright
+objects. The camera generally sets itself to a medium-to-high ISO sensitivity,
+with a relatively long exposure time, and turns flash off. As such, there will be
+increased image noise and the possibility of blurred image.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_PARTY_INDOOR</constant>&nbsp;</entry>
+		  <entry>Party and indoor. Designed to capture indoor scenes
+that are lit by indoor background lighting as well as the flash. The camera
+usually increases ISO sensitivity, and adjusts exposure for the low light
+conditions.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_PORTRAIT</constant>&nbsp;</entry>
+		  <entry>Portrait. The camera adjusts the aperture so that the
+depth of field is reduced, which helps to isolate the subject against a smooth
+background. Most cameras recognize the presence of faces in the scene and focus
+on them. The color hue is adjusted to enhance skin tones. The intensity of the
+flash is often reduced.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_SPORTS</constant>&nbsp;</entry>
+		  <entry>Sports. Significantly increases ISO and uses a fast
+shutter speed to freeze motion of rapidly-moving subjects. Increased image
+noise may be seen in this mode.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_SUNSET</constant>&nbsp;</entry>
+		  <entry>Sunset. Preserves deep hues seen in sunsets and
+sunrises. It bumps up the saturation.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_SCENE_MODE_TEXT</constant>&nbsp;</entry>
+		  <entry>Text. It applies extra contrast and sharpness, it is
+typically a black-and-white mode optimized for readability. Automatic focus
+may be switched to close-up mode and this setting may also involve some
+lens-distortion correction.</entry>
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
index 33a4b8a..4758e61 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -273,6 +273,23 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Auto",
 		NULL
 	};
+	static const char * const scene_mode[] = {
+		"None",
+		"Backlight",
+		"Beach/Snow",
+		"Candle Light",
+		"Dusk/Dawn",
+		"Fall Colors",
+		"Fireworks",
+		"Landscape",
+		"Night",
+		"Party/Indoor",
+		"Portrait",
+		"Sports",
+		"Sunset",
+		"Text",
+		NULL
+	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
 		"50 Microseconds",
@@ -448,6 +465,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return auto_n_preset_white_balance;
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 		return camera_iso_sensitivity_auto;
+	case V4L2_CID_SCENE_MODE:
+		return scene_mode;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -641,6 +660,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 	case V4L2_CID_EXPOSURE_METERING:	return "Exposure, Metering Mode";
+	case V4L2_CID_SCENE_MODE:		return "Scene Mode";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -782,6 +802,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 	case V4L2_CID_EXPOSURE_METERING:
+	case V4L2_CID_SCENE_MODE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 215b7df..6f1c5de 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1733,6 +1733,24 @@ enum v4l2_exposure_metering {
 	V4L2_EXPOSURE_METERING_SPOT		= 2,
 };
 
+#define V4L2_CID_SCENE_MODE			(V4L2_CID_CAMERA_CLASS_BASE+26)
+enum v4l2_scene_mode {
+	V4L2_SCENE_MODE_NONE			= 0,
+	V4L2_SCENE_MODE_BACKLIGHT		= 1,
+	V4L2_SCENE_MODE_BEACH_SNOW		= 2,
+	V4L2_SCENE_MODE_CANDLE_LIGHT		= 3,
+	V4L2_SCENE_MODE_DAWN_DUSK		= 4,
+	V4L2_SCENE_MODE_FALL_COLORS		= 5,
+	V4L2_SCENE_MODE_FIREWORKS		= 6,
+	V4L2_SCENE_MODE_LANDSCAPE		= 7,
+	V4L2_SCENE_MODE_NIGHT			= 8,
+	V4L2_SCENE_MODE_PARTY_INDOOR		= 9,
+	V4L2_SCENE_MODE_PORTRAIT		= 10,
+	V4L2_SCENE_MODE_SPORTS			= 11,
+	V4L2_SCENE_MODE_SUNSET			= 12,
+	V4L2_SCENE_MODE_TEXT			= 13,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

