Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54330 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab2ANTfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:35:24 -0500
Received: by mail-ey0-f174.google.com with SMTP id l12so562456eaa.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 11:35:23 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC v3 1/3] V4L: Add JPEG compression control class
Date: Sat, 14 Jan 2012 20:35:03 +0100
Message-Id: <1326569705-20261-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1326569705-20261-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <20120114192414.05ad2e83@tele>
 <1326569705-20261-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_JPEG_CLASS control class is intended to expose various
adjustable parameters of JPEG encoders and decoders. Following controls
are defined:

 - V4L2_CID_JPEG_CHROMA_SUBSAMPLING,
 - V4L2_CID_JPEG_RESTART_INTERVAL,
 - V4L2_CID_JPEG_COMPRESSION_QUALITY,
 - V4L2_CID_JPEG_ACTIVE_MARKER.

This covers only a part of relevant standard specifications. More
controls should be added in future if required.

The purpose of V4L2_CID_JPEG_CLASS class is also to replace some
functionality covered by VIDIOC_S/G_JPEGCOMP ioctls, i.e. the JPEG
markers presence and compression quality control. The applications
and drivers should switch from the ioctl to control based API, as
described in the subsequent patches for the Media API DocBook.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/video/v4l2-ctrls.c |   24 ++++++++++++++++++++++++
 include/linux/videodev2.h        |   24 ++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index da1f4c2..1fd6435 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -353,6 +353,16 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		NULL,
 	};

+	static const char * const jpeg_chroma_subsampling[] = {
+		"4:4:4",
+		"4:2:2",
+		"4:2:0",
+		"4:1:1",
+		"4:1:0",
+		"Gray",
+		NULL,
+	};
+
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
 		return mpeg_audio_sampling_freq;
@@ -414,6 +424,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg_mpeg4_level;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		return mpeg4_profile;
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+		return jpeg_chroma_subsampling;
+
 	default:
 		return NULL;
 	}
@@ -607,6 +620,14 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to strobe";

+	/* JPEG encoder controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
+	case V4L2_CID_JPEG_CLASS:		return "JPEG Compression Controls";
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:	return "Chroma Subsampling";
+	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
+	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
+
 	default:
 		return NULL;
 	}
@@ -693,6 +714,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
@@ -704,6 +726,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_CLASS:
 	case V4L2_CID_FM_TX_CLASS:
 	case V4L2_CID_FLASH_CLASS:
+	case V4L2_CID_JPEG_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -717,6 +740,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*max = 0xFFFFFF;
 		break;
 	case V4L2_CID_FLASH_FAULT:
+	case V4L2_CID_JPEG_ACTIVE_MARKER:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 012a296..5bd3725 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1123,6 +1123,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
+#define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */

 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1732,6 +1733,29 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)

+/*  JPEG-class control IDs defined by V4L2 */
+#define V4L2_CID_JPEG_CLASS_BASE		(V4L2_CTRL_CLASS_JPEG | 0x900)
+#define V4L2_CID_JPEG_CLASS			(V4L2_CTRL_CLASS_JPEG | 1)
+
+#define	V4L2_CID_JPEG_CHROMA_SUBSAMPLING	(V4L2_CID_JPEG_CLASS_BASE + 1)
+enum v4l2_jpeg_chroma_subsampling {
+	V4L2_JPEG_CHROMA_SUBSAMPLING_444	= 0,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_422	= 1,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_420	= 2,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_411	= 3,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_410	= 4,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY	= 5,
+};
+#define	V4L2_CID_JPEG_RESTART_INTERVAL		(V4L2_CID_JPEG_CLASS_BASE + 2)
+#define	V4L2_CID_JPEG_COMPRESSION_QUALITY	(V4L2_CID_JPEG_CLASS_BASE + 3)
+
+#define	V4L2_CID_JPEG_ACTIVE_MARKER		(V4L2_CID_JPEG_CLASS_BASE + 4)
+#define	V4L2_JPEG_ACTIVE_MARKER_APP0		(1 << 0)
+#define	V4L2_JPEG_ACTIVE_MARKER_APP1		(1 << 1)
+#define	V4L2_JPEG_ACTIVE_MARKER_COM		(1 << 16)
+#define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
+#define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
+
 /*
  *	T U N I N G
  */
--
1.7.4.1

