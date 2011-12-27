Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1L0Tnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 14:43:52 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so11868452eek.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:43:52 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 1/4] V4L: Add JPEG compression control class
Date: Tue, 27 Dec 2011 20:43:28 +0100
Message-Id: <1325015011-11904-2-git-send-email-snjw23@gmail.com>
In-Reply-To: <1325015011-11904-1-git-send-email-snjw23@gmail.com>
References: <4EBECD11.8090709@gmail.com>
 <1325015011-11904-1-git-send-email-snjw23@gmail.com>
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
described in the Media API DocBook.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---

It could be relevant to also define at this stage controls for JPEG
compression process distinction, i.e.:

* the compression process type

enum v4l2_jpeg_compression_type {
       V4L2_JPEG_COMPRESSION_BASELINE_DCT      = 0,
       V4L2_JPEG_COMPRESSION_EXTENDED_DCT      = 1,
       V4L2_JPEG_COMPRESSION_LOSSLESS          = 2,
       V4L2_JPEG_COMPRESSION_HIERARCHICAL      = 3,
};

* data scan mode for entropy coding

enum v4l2_jpeg_coding_type {
       V4L2_JPEG_CODING_SCAN_SEQUENTIAL       = 0,
       V4L2_JPEG_CODING_SCAN_PROGRESSIVE      = 1,
};

* entropy coding method

enum v4l2_jpeg_coding_scan_type {
       V4L2_JPEG_ENTROPY_CODING_HUFFMAN       = 0,
       V4L2_JPEG_ENTROPY_CODING_ARITHMETIC    = 1,
};

However yet there wouldn't be drivers using those controls, or at most
such controls would have only informational purpose (i.e. no more than
one menu entry). For example, arithmetic coding is rarely used due to
patent claims. And the standard enforces baseline sequential DCT-based
process as a minimum, which most of hardware seem to implement. It all
may change when we see first JPEG 2000 hardware codec, however JPEG 2K
might warrant a separate control class.

Comments ?
---
 drivers/media/video/v4l2-ctrls.c |   24 ++++++++++++++++++++++++
 include/linux/videodev2.h        |   26 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 0f415da..b801d8c 100644
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
@@ -606,6 +619,14 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
 
+	/* JPEG encoder controls */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
+	case V4L2_CID_JPEG_CLASS:		return "JPEG Compression Controls";
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:	return "Chroma Subsampling";
+	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
+	case V4L2_CID_JPEG_ACTIVE_MARKERS:	return "Active Markers";
+
 	default:
 		return NULL;
 	}
@@ -692,6 +713,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
@@ -703,6 +725,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_CLASS:
 	case V4L2_CID_FM_TX_CLASS:
 	case V4L2_CID_FLASH_CLASS:
+	case V4L2_CID_JPEG_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -716,6 +739,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*max = 0xFFFFFF;
 		break;
 	case V4L2_CID_FLASH_FAULT:
+	case V4L2_CID_JPEG_ACTIVE_MARKERS:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3d62631..64f02a5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1080,6 +1080,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
+#define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1688,6 +1689,31 @@ enum v4l2_flash_strobe_source {
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
+#define	V4L2_CID_JPEG_ACTIVE_MARKERS		(V4L2_CID_JPEG_CLASS_BASE + 4)
+#define	V4L2_JPEG_ACTIVE_MARKER_APP0		(1 << 0)
+#define	V4L2_JPEG_ACTIVE_MARKER_APP1		(1 << 1)
+#define	V4L2_JPEG_ACTIVE_MARKER_COM		(1 << 16)
+#define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
+#define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
+#define	V4L2_JPEG_ACTIVE_MARKER_DAC		(1 << 19)
+#define	V4L2_JPEG_ACTIVE_MARKER_DNL		(1 << 20)
+
 /*
  *	T U N I N G
  */
-- 
1.7.4.1

