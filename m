Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 27 Nov 2008 15:46:30 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
In-Reply-To: <200811271536.46779.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271546.30778.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: [PATCH 3/4] v4l2: Add missing control names
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Update v4l2_ctrl_get_name() and v4l2_ctrl_get_menu() with missing
control names and menu values.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
--

diff -r 0280330fd4a0 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Wed Nov 26 00:20:42 2008 +0100
+++ b/linux/drivers/media/video/v4l2-common.c	Thu Nov 27 15:44:18 2008 +0100
@@ -321,6 +321,19 @@
 		"Private packet, IVTV format",
 		NULL
 	};
+	static const char *camera_power_line_frequency[] = {
+		"Disabled",
+		"50 Hz",
+		"60 Hz",
+		NULL
+	};
+	static const char *camera_exposure_auto[] = {
+		"Auto Mode",
+		"Manual Mode",
+		"Shutter Priority Mode",
+		"Aperture Priority Mode",
+		NULL
+	};
 
 	switch (id) {
 		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -353,6 +366,10 @@
 			return mpeg_stream_type;
 		case V4L2_CID_MPEG_STREAM_VBI_FMT:
 			return mpeg_stream_vbi_fmt;
+		case V4L2_CID_POWER_LINE_FREQUENCY:
+			return camera_power_line_frequency;
+		case V4L2_CID_EXPOSURE_AUTO:
+			return camera_exposure_auto;
 		default:
 			return NULL;
 	}
@@ -364,17 +381,37 @@
 {
 	switch (id) {
 	/* USER controls */
-	case V4L2_CID_USER_CLASS: 	return "User Controls";
-	case V4L2_CID_AUDIO_VOLUME: 	return "Volume";
-	case V4L2_CID_AUDIO_MUTE: 	return "Mute";
-	case V4L2_CID_AUDIO_BALANCE: 	return "Balance";
-	case V4L2_CID_AUDIO_BASS: 	return "Bass";
-	case V4L2_CID_AUDIO_TREBLE: 	return "Treble";
-	case V4L2_CID_AUDIO_LOUDNESS: 	return "Loudness";
-	case V4L2_CID_BRIGHTNESS: 	return "Brightness";
-	case V4L2_CID_CONTRAST: 	return "Contrast";
-	case V4L2_CID_SATURATION: 	return "Saturation";
-	case V4L2_CID_HUE: 		return "Hue";
+	case V4L2_CID_USER_CLASS: 		return "User Controls";
+	case V4L2_CID_AUDIO_VOLUME: 		return "Volume";
+	case V4L2_CID_AUDIO_MUTE: 		return "Mute";
+	case V4L2_CID_AUDIO_BALANCE: 		return "Balance";
+	case V4L2_CID_AUDIO_BASS: 		return "Bass";
+	case V4L2_CID_AUDIO_TREBLE: 		return "Treble";
+	case V4L2_CID_AUDIO_LOUDNESS: 		return "Loudness";
+	case V4L2_CID_BRIGHTNESS: 		return "Brightness";
+	case V4L2_CID_CONTRAST: 		return "Contrast";
+	case V4L2_CID_SATURATION: 		return "Saturation";
+	case V4L2_CID_HUE: 			return "Hue";
+	case V4L2_CID_BLACK_LEVEL:		return "Black Level";
+	case V4L2_CID_AUTO_WHITE_BALANCE:	return "White Balance, Automatic";
+	case V4L2_CID_DO_WHITE_BALANCE:		return "Do White Balance";
+	case V4L2_CID_RED_BALANCE:		return "Red Balance";
+	case V4L2_CID_BLUE_BALANCE:		return "Blue Balance";
+	case V4L2_CID_GAMMA:			return "Gamma";
+	case V4L2_CID_EXPOSURE:			return "Exposure";
+	case V4L2_CID_AUTOGAIN:			return "Gain, Automatic";
+	case V4L2_CID_GAIN:			return "Gain";
+	case V4L2_CID_HFLIP:			return "Horizontal Flip";
+	case V4L2_CID_VFLIP:			return "Vertical Flip";
+	case V4L2_CID_HCENTER:			return "Horizontal Center";
+	case V4L2_CID_VCENTER:			return "Vertical Center";
+	case V4L2_CID_POWER_LINE_FREQUENCY:	return "Power Line Frequency";
+	case V4L2_CID_HUE_AUTO:			return "Hue, Automatic";
+	case V4L2_CID_WHITE_BALANCE_TEMPERATURE: return "White Balance Temperature";
+	case V4L2_CID_SHARPNESS:		return "Sharpness";
+	case V4L2_CID_BACKLIGHT_COMPENSATION:	return "Backlight Compensation";
+	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
+	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
 
 	/* MPEG controls */
 	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
@@ -411,6 +448,25 @@
 	case V4L2_CID_MPEG_STREAM_PES_ID_VIDEO: return "Stream PES Video ID";
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:	return "Stream VBI Format";
 
+	/* CAMERA controls */
+	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
+	case V4L2_CID_EXPOSURE_AUTO:		return "Auto-Exposure";
+	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
+	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:	return "Auto-Exposure Priority";
+	case V4L2_CID_PAN_RELATIVE:		return "Pan, Relative";
+	case V4L2_CID_TILT_RELATIVE:		return "Tilt, Relative";
+	case V4L2_CID_PAN_RESET:		return "Pan, Reset";
+	case V4L2_CID_TILT_RESET:		return "Tilt, Reset";
+	case V4L2_CID_PAN_ABSOLUTE:		return "Pan, Absolute";
+	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
+	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
+	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
+	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
+	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
+	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
+	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
+	case V4L2_CID_PRIVACY:			return "Privacy";
+
 	default:
 		return NULL;
 	}
@@ -429,14 +485,22 @@
 	switch (qctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 	case V4L2_CID_AUDIO_LOUDNESS:
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+	case V4L2_CID_AUTOGAIN:
+	case V4L2_CID_HFLIP:
+	case V4L2_CID_VFLIP:
+	case V4L2_CID_HUE_AUTO:
 	case V4L2_CID_MPEG_AUDIO_MUTE:
 	case V4L2_CID_MPEG_VIDEO_MUTE:
 	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
 	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
+	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
+	case V4L2_CID_PRIVACY:
 		qctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
 		min = 0;
 		max = step = 1;
 		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
@@ -452,10 +516,12 @@
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
 	case V4L2_CID_MPEG_STREAM_TYPE:
 	case V4L2_CID_MPEG_STREAM_VBI_FMT:
+	case V4L2_CID_EXPOSURE_AUTO:
 		qctrl->type = V4L2_CTRL_TYPE_MENU;
 		step = 1;
 		break;
 	case V4L2_CID_USER_CLASS:
+	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
 		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
