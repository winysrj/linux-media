Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46237 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752927AbaCAQPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 1/9] Update headers from upstream kernel, including timestamp source patches
Date: Sat,  1 Mar 2014 18:18:02 +0200
Message-Id: <1393690690-5004-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/v4l2-controls.h |  105 ++++++++++++++++-
 include/linux/videodev2.h     |  250 +++++++++++++++++++----------------------
 2 files changed, 214 insertions(+), 141 deletions(-)

diff --git a/include/linux/v4l2-controls.h b/include/linux/v4l2-controls.h
index f56c945..2cbe605 100644
--- a/include/linux/v4l2-controls.h
+++ b/include/linux/v4l2-controls.h
@@ -53,12 +53,13 @@
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA		0x009a0000	/* Camera class controls */
-#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator controls */
 #define V4L2_CTRL_CLASS_FLASH		0x009c0000	/* Camera flash controls */
 #define V4L2_CTRL_CLASS_JPEG		0x009d0000	/* JPEG-compression controls */
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE	0x009e0000	/* Image source controls */
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
+#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 
 /* User-class control IDs */
 
@@ -88,10 +89,6 @@
 #define V4L2_CID_HFLIP			(V4L2_CID_BASE+20)
 #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
 
-/* Deprecated; use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
-#define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
-#define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
-
 #define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24)
 enum v4l2_power_line_frequency {
 	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
@@ -144,8 +141,36 @@ enum v4l2_colorfx {
 /* last CID + 1 */
 #define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
 
+/* USER-class private control IDs */
+
+/* The base for the meye driver controls. See linux/meye.h for the list
+ * of controls. We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
+
+/* The base for the bttv driver controls.
+ * We reserve 32 controls for this driver. */
+#define V4L2_CID_USER_BTTV_BASE			(V4L2_CID_USER_BASE + 0x1010)
+
+
+/* The base for the s2255 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1030)
+
+/* The base for the si476x driver controls. See include/media/si476x.h for the list
+ * of controls. Total of 16 controls is reserved for this driver */
+#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1040)
+
+/* The base for the TI VPE driver controls. Total of 16 controls is reserved for
+ * this driver */
+#define V4L2_CID_USER_TI_VPE_BASE		(V4L2_CID_USER_BASE + 0x1050)
+
+/* The base for the saa7134 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_SAA7134_BASE		(V4L2_CID_USER_BASE + 0x1060)
 
 /* MPEG-class control IDs */
+/* The MPEG controls are applicable to all codec controls
+ * and the 'MPEG' part of the define is historical */
 
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
 #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
@@ -350,6 +375,7 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_DEC_PTS			(V4L2_CID_MPEG_BASE+223)
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
 #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
+#define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
@@ -506,6 +532,38 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+/*  Control IDs for VP8 streams
+ *  Although VP8 is not part of MPEG we add these controls to the MPEG class
+ *  as that class is already handling other video compression standards
+ */
+#define V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS		(V4L2_CID_MPEG_BASE+500)
+enum v4l2_vp8_num_partitions {
+	V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION	= 0,
+	V4L2_CID_MPEG_VIDEO_VPX_2_PARTITIONS	= 1,
+	V4L2_CID_MPEG_VIDEO_VPX_4_PARTITIONS	= 2,
+	V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS	= 3,
+};
+#define V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4		(V4L2_CID_MPEG_BASE+501)
+#define V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES		(V4L2_CID_MPEG_BASE+502)
+enum v4l2_vp8_num_ref_frames {
+	V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME	= 0,
+	V4L2_CID_MPEG_VIDEO_VPX_2_REF_FRAME	= 1,
+	V4L2_CID_MPEG_VIDEO_VPX_3_REF_FRAME	= 2,
+};
+#define V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL		(V4L2_CID_MPEG_BASE+503)
+#define V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS	(V4L2_CID_MPEG_BASE+504)
+#define V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD	(V4L2_CID_MPEG_BASE+505)
+#define V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL	(V4L2_CID_MPEG_BASE+506)
+enum v4l2_vp8_golden_frame_sel {
+	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV		= 0,
+	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_VPX_MIN_QP			(V4L2_CID_MPEG_BASE+507)
+#define V4L2_CID_MPEG_VIDEO_VPX_MAX_QP			(V4L2_CID_MPEG_BASE+508)
+#define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP		(V4L2_CID_MPEG_BASE+509)
+#define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
+#define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -642,6 +700,7 @@ enum v4l2_exposure_metering {
 	V4L2_EXPOSURE_METERING_AVERAGE		= 0,
 	V4L2_EXPOSURE_METERING_CENTER_WEIGHTED	= 1,
 	V4L2_EXPOSURE_METERING_SPOT		= 2,
+	V4L2_EXPOSURE_METERING_MATRIX		= 3,
 };
 
 #define V4L2_CID_SCENE_MODE			(V4L2_CID_CAMERA_CLASS_BASE+26)
@@ -782,6 +841,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+
 /* Image source controls */
 #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
 #define V4L2_CID_IMAGE_SOURCE_CLASS		(V4L2_CTRL_CLASS_IMAGE_SOURCE | 1)
@@ -800,4 +860,39 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 
+
+/*  DV-class control IDs defined by V4L2 */
+#define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
+#define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
+
+#define	V4L2_CID_DV_TX_HOTPLUG			(V4L2_CID_DV_CLASS_BASE + 1)
+#define	V4L2_CID_DV_TX_RXSENSE			(V4L2_CID_DV_CLASS_BASE + 2)
+#define	V4L2_CID_DV_TX_EDID_PRESENT		(V4L2_CID_DV_CLASS_BASE + 3)
+#define	V4L2_CID_DV_TX_MODE			(V4L2_CID_DV_CLASS_BASE + 4)
+enum v4l2_dv_tx_mode {
+	V4L2_DV_TX_MODE_DVI_D	= 0,
+	V4L2_DV_TX_MODE_HDMI	= 1,
+};
+#define V4L2_CID_DV_TX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 5)
+enum v4l2_dv_rgb_range {
+	V4L2_DV_RGB_RANGE_AUTO	  = 0,
+	V4L2_DV_RGB_RANGE_LIMITED = 1,
+	V4L2_DV_RGB_RANGE_FULL	  = 2,
+};
+
+#define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
+#define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
+
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_TUNE_DEEMPHASIS		(V4L2_CID_FM_RX_CLASS_BASE + 1)
+enum v4l2_deemphasis {
+	V4L2_DEEMPHASIS_DISABLED	= V4L2_PREEMPHASIS_DISABLED,
+	V4L2_DEEMPHASIS_50_uS		= V4L2_PREEMPHASIS_50_uS,
+	V4L2_DEEMPHASIS_75_uS		= V4L2_PREEMPHASIS_75_uS,
+};
+
+#define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+
 #endif
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 99b0a7e..ecda04f 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -53,8 +53,8 @@
  *              Hans Verkuil <hverkuil@xs4all.nl>
  *		et al.
  */
-#ifndef _UAPI__LINUX_VIDEODEV2_H
-#define _UAPI__LINUX_VIDEODEV2_H
+#ifndef __LINUX_VIDEODEV2_H
+#define __LINUX_VIDEODEV2_H
 
 #include <sys/time.h>
 
@@ -70,25 +70,6 @@
 #define VIDEO_MAX_FRAME               32
 #define VIDEO_MAX_PLANES               8
 
-
-/* These defines are V4L1 specific and should not be used with the V4L2 API!
-   They will be removed from this header in the future. */
-
-#define VID_TYPE_CAPTURE	1	/* Can capture */
-#define VID_TYPE_TUNER		2	/* Can tune */
-#define VID_TYPE_TELETEXT	4	/* Does teletext */
-#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
-#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
-#define VID_TYPE_CLIPPING	32	/* Can clip */
-#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
-#define VID_TYPE_SCALES		128	/* Scalable */
-#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
-#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
-#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
-#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
-#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
-#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
-
 /*
  *	M I S C E L L A N E O U S
  */
@@ -182,6 +163,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	V4L2_MEMORY_DMABUF           = 4,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -223,8 +205,8 @@ enum v4l2_priority {
 struct v4l2_rect {
 	__s32   left;
 	__s32   top;
-	__s32   width;
-	__s32   height;
+	__u32   width;
+	__u32   height;
 };
 
 struct v4l2_fract {
@@ -329,6 +311,9 @@ struct v4l2_pix_format {
 /* Palette formats */
 #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
 
+/* Chrominance formats */
+#define V4L2_PIX_FMT_UV8     v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV 4:4 */
+
 /* Luminance+Chrominance formats */
 #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
 #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
@@ -361,6 +346,8 @@ struct v4l2_pix_format {
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
 #define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
+#define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr 4:2:2  */
+#define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
 #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
 
@@ -381,6 +368,11 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
+	/* 10bit raw bayer a-law compressed to 8 bits */
+#define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
+#define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
+#define V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('a', 'g', 'A', '8')
+#define V4L2_PIX_FMT_SRGGB10ALAW8 v4l2_fourcc('a', 'R', 'A', '8')
 	/* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
 #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
@@ -403,7 +395,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
-#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 ES     */
+#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
@@ -563,7 +555,7 @@ struct v4l2_jpegcompression {
 	__u32 jpeg_markers;     /* Which markers should go into the JPEG
 				 * output. Unless you exactly know what
 				 * you do, leave them untouched.
-				 * Inluding less markers will make the
+				 * Including less markers will make the
 				 * resulting code smaller, but there will
 				 * be fewer applications which can read it.
 				 * The presence of the APP and COM marker
@@ -575,7 +567,7 @@ struct v4l2_jpegcompression {
 #define V4L2_JPEG_MARKER_DRI (1<<5)    /* Define Restart Interval */
 #define V4L2_JPEG_MARKER_COM (1<<6)    /* Comment segment */
 #define V4L2_JPEG_MARKER_APP (1<<7)    /* App segment, driver will
-					* allways use APP0 */
+					* always use APP0 */
 };
 
 /*
@@ -598,6 +590,8 @@ struct v4l2_requestbuffers {
  *			should be passed to mmap() called on the video node)
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
+ * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
+ *			descriptor associated with this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data
  *
@@ -612,6 +606,7 @@ struct v4l2_plane {
 	union {
 		__u32		mem_offset;
 		unsigned long	userptr;
+		__s32		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -636,6 +631,8 @@ struct v4l2_plane {
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
  *		a userspace pointer pointing to this buffer
+ * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
+ *		a userspace file descriptor associated with this buffer
  * @planes:	for multiplanar buffers; userspace pointer to the array of plane
  *		info structs for this buffer
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
@@ -662,6 +659,7 @@ struct v4l2_buffer {
 		__u32           offset;
 		unsigned long   userptr;
 		struct v4l2_plane *planes;
+		__s32		fd;
 	} m;
 	__u32			length;
 	__u32			reserved2;
@@ -669,23 +667,63 @@ struct v4l2_buffer {
 };
 
 /*  Flags for 'flags' field */
-#define V4L2_BUF_FLAG_MAPPED	0x0001  /* Buffer is mapped (flag) */
-#define V4L2_BUF_FLAG_QUEUED	0x0002	/* Buffer is queued for processing */
-#define V4L2_BUF_FLAG_DONE	0x0004	/* Buffer is ready */
-#define V4L2_BUF_FLAG_KEYFRAME	0x0008	/* Image is a keyframe (I-frame) */
-#define V4L2_BUF_FLAG_PFRAME	0x0010	/* Image is a P-frame */
-#define V4L2_BUF_FLAG_BFRAME	0x0020	/* Image is a B-frame */
+/* Buffer is mapped (flag) */
+#define V4L2_BUF_FLAG_MAPPED			0x00000001
+/* Buffer is queued for processing */
+#define V4L2_BUF_FLAG_QUEUED			0x00000002
+/* Buffer is ready */
+#define V4L2_BUF_FLAG_DONE			0x00000004
+/* Image is a keyframe (I-frame) */
+#define V4L2_BUF_FLAG_KEYFRAME			0x00000008
+/* Image is a P-frame */
+#define V4L2_BUF_FLAG_PFRAME			0x00000010
+/* Image is a B-frame */
+#define V4L2_BUF_FLAG_BFRAME			0x00000020
 /* Buffer is ready, but the data contained within is corrupted. */
-#define V4L2_BUF_FLAG_ERROR	0x0040
-#define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
-#define V4L2_BUF_FLAG_PREPARED	0x0400	/* Buffer is prepared for queuing */
+#define V4L2_BUF_FLAG_ERROR			0x00000040
+/* timecode field is valid */
+#define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* Buffer is prepared for queuing */
+#define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
-#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
-#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
+#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x00000800
+#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x00001000
 /* Timestamp type */
-#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
-#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
-#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
+#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0x0000e000
+#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
+#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
+#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
+/* Timestamp sources. */
+#define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
+#define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
+#define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+
+/**
+ * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
+ *
+ * @index:	id number of the buffer
+ * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
+ *		multiplanar buffers);
+ * @plane:	index of the plane to be exported, 0 for single plane queues
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ *
+ * Contains data used for exporting a video buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
+ */
+struct v4l2_exportbuffer {
+	__u32		type; /* enum v4l2_buf_type */
+	__u32		index;
+	__u32		plane;
+	__u32		flags;
+	__s32		fd;
+	__u32		reserved[11];
+};
 
 /*
  *	O V E R L A Y   P R E V I E W
@@ -874,7 +912,7 @@ typedef __u64 v4l2_std_id;
 /*
  * "Common" PAL - This macro is there to be compatible with the old
  * V4L1 concept of "PAL": /BGDKHI.
- * Several PAL standards are mising here: /M, /N and /Nc
+ * Several PAL standards are missing here: /M, /N and /Nc
  */
 #define V4L2_STD_PAL		(V4L2_STD_PAL_BG	|\
 				 V4L2_STD_PAL_DK	|\
@@ -934,52 +972,6 @@ struct v4l2_standard {
 	__u32		     reserved[4];
 };
 
-/* The DV Preset API is deprecated in favor of the DV Timings API.
-   New drivers shouldn't use this anymore! */
-
-/*
- *	V I D E O	T I M I N G S	D V	P R E S E T
- */
-struct v4l2_dv_preset {
-	__u32	preset;
-	__u32	reserved[4];
-};
-
-/*
- *	D V	P R E S E T S	E N U M E R A T I O N
- */
-struct v4l2_dv_enum_preset {
-	__u32	index;
-	__u32	preset;
-	__u8	name[32]; /* Name of the preset timing */
-	__u32	width;
-	__u32	height;
-	__u32	reserved[4];
-};
-
-/*
- * 	D V	P R E S E T	V A L U E S
- */
-#define		V4L2_DV_INVALID		0
-#define		V4L2_DV_480P59_94	1 /* BT.1362 */
-#define		V4L2_DV_576P50		2 /* BT.1362 */
-#define		V4L2_DV_720P24		3 /* SMPTE 296M */
-#define		V4L2_DV_720P25		4 /* SMPTE 296M */
-#define		V4L2_DV_720P30		5 /* SMPTE 296M */
-#define		V4L2_DV_720P50		6 /* SMPTE 296M */
-#define		V4L2_DV_720P59_94	7 /* SMPTE 274M */
-#define		V4L2_DV_720P60		8 /* SMPTE 274M/296M */
-#define		V4L2_DV_1080I29_97	9 /* BT.1120/ SMPTE 274M */
-#define		V4L2_DV_1080I30		10 /* BT.1120/ SMPTE 274M */
-#define		V4L2_DV_1080I25		11 /* BT.1120 */
-#define		V4L2_DV_1080I50		12 /* SMPTE 296M */
-#define		V4L2_DV_1080I60		13 /* SMPTE 296M */
-#define		V4L2_DV_1080P24		14 /* SMPTE 296M */
-#define		V4L2_DV_1080P25		15 /* SMPTE 296M */
-#define		V4L2_DV_1080P30		16 /* SMPTE 296M */
-#define		V4L2_DV_1080P50		17 /* BT.1120 */
-#define		V4L2_DV_1080P60		18 /* BT.1120 */
-
 /*
  *	D V 	B T	T I M I N G S
  */
@@ -1073,8 +1065,18 @@ struct v4l2_bt_timings {
    longer and field 2 is really one half-line shorter, so each field has
    exactly the same number of half-lines. Whether half-lines can be detected
    or used depends on the hardware. */
-#define V4L2_DV_FL_HALF_LINE			(1 << 0)
-
+#define V4L2_DV_FL_HALF_LINE			(1 << 3)
+
+/* A few useful defines to calculate the total blanking and frame sizes */
+#define V4L2_DV_BT_BLANKING_WIDTH(bt) \
+	(bt->hfrontporch + bt->hsync + bt->hbackporch)
+#define V4L2_DV_BT_FRAME_WIDTH(bt) \
+	(bt->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
+#define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
+	(bt->vfrontporch + bt->vsync + bt->vbackporch + \
+	 bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch)
+#define V4L2_DV_BT_FRAME_HEIGHT(bt) \
+	(bt->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
 /** struct v4l2_dv_timings - DV timings
  * @type:	the type of the timings
@@ -1193,7 +1195,6 @@ struct v4l2_input {
 #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
 
 /* capabilities flags */
-#define V4L2_IN_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
 #define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
@@ -1217,7 +1218,6 @@ struct v4l2_output {
 #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY	3
 
 /* capabilities flags */
-#define V4L2_OUT_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
 #define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
@@ -1308,28 +1308,6 @@ struct v4l2_querymenu {
 #define V4L2_CID_PRIVATE_BASE		0x08000000
 
 
-/*  DV-class control IDs defined by V4L2 */
-#define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
-#define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
-
-#define	V4L2_CID_DV_TX_HOTPLUG			(V4L2_CID_DV_CLASS_BASE + 1)
-#define	V4L2_CID_DV_TX_RXSENSE			(V4L2_CID_DV_CLASS_BASE + 2)
-#define	V4L2_CID_DV_TX_EDID_PRESENT		(V4L2_CID_DV_CLASS_BASE + 3)
-#define	V4L2_CID_DV_TX_MODE			(V4L2_CID_DV_CLASS_BASE + 4)
-enum v4l2_dv_tx_mode {
-	V4L2_DV_TX_MODE_DVI_D	= 0,
-	V4L2_DV_TX_MODE_HDMI	= 1,
-};
-#define V4L2_CID_DV_TX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 5)
-enum v4l2_dv_rgb_range {
-	V4L2_DV_RGB_RANGE_AUTO	  = 0,
-	V4L2_DV_RGB_RANGE_LIMITED = 1,
-	V4L2_DV_RGB_RANGE_FULL	  = 2,
-};
-
-#define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
-#define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
-
 /*
  *	T U N I N G
  */
@@ -1776,6 +1754,7 @@ struct v4l2_event_vsync {
 /* Payload for V4L2_EVENT_CTRL */
 #define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
 #define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
+#define V4L2_EVENT_CTRL_CH_RANGE		(1 << 2)
 
 struct v4l2_event_ctrl {
 	__u32 changes;
@@ -1829,10 +1808,14 @@ struct v4l2_event_subscription {
 
 /* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */
 
-#define V4L2_CHIP_MATCH_HOST       0  /* Match against chip ID on host (0 for the host) */
-#define V4L2_CHIP_MATCH_I2C_DRIVER 1  /* Match against I2C driver name */
-#define V4L2_CHIP_MATCH_I2C_ADDR   2  /* Match against I2C 7-bit address */
-#define V4L2_CHIP_MATCH_AC97       3  /* Match against anciliary AC97 chip */
+#define V4L2_CHIP_MATCH_BRIDGE      0  /* Match against chip ID on the bridge (0 for the bridge) */
+#define V4L2_CHIP_MATCH_SUBDEV      4  /* Match against subdev index */
+
+/* The following four defines are no longer in use */
+#define V4L2_CHIP_MATCH_HOST V4L2_CHIP_MATCH_BRIDGE
+#define V4L2_CHIP_MATCH_I2C_DRIVER  1  /* Match against I2C driver name */
+#define V4L2_CHIP_MATCH_I2C_ADDR    2  /* Match against I2C 7-bit address */
+#define V4L2_CHIP_MATCH_AC97        3  /* Match against ancillary AC97 chip */
 
 struct v4l2_dbg_match {
 	__u32 type; /* Match type */
@@ -1849,11 +1832,15 @@ struct v4l2_dbg_register {
 	__u64 val;
 } __attribute__ ((packed));
 
-/* VIDIOC_DBG_G_CHIP_IDENT */
-struct v4l2_dbg_chip_ident {
+#define V4L2_CHIP_FL_READABLE (1 << 0)
+#define V4L2_CHIP_FL_WRITABLE (1 << 1)
+
+/* VIDIOC_DBG_G_CHIP_INFO */
+struct v4l2_dbg_chip_info {
 	struct v4l2_dbg_match match;
-	__u32 ident;       /* chip identifier as specified in <media/v4l2-chip-ident.h> */
-	__u32 revision;    /* chip revision, chip specific */
+	char name[32];
+	__u32 flags;
+	__u32 reserved[32];
 } __attribute__ ((packed));
 
 /**
@@ -1888,6 +1875,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
@@ -1932,34 +1920,20 @@ struct v4l2_create_buffers {
 #define VIDIOC_G_EXT_CTRLS	_IOWR('V', 71, struct v4l2_ext_controls)
 #define VIDIOC_S_EXT_CTRLS	_IOWR('V', 72, struct v4l2_ext_controls)
 #define VIDIOC_TRY_EXT_CTRLS	_IOWR('V', 73, struct v4l2_ext_controls)
-#if 1
 #define VIDIOC_ENUM_FRAMESIZES	_IOWR('V', 74, struct v4l2_frmsizeenum)
 #define VIDIOC_ENUM_FRAMEINTERVALS _IOWR('V', 75, struct v4l2_frmivalenum)
 #define VIDIOC_G_ENC_INDEX       _IOR('V', 76, struct v4l2_enc_idx)
 #define VIDIOC_ENCODER_CMD      _IOWR('V', 77, struct v4l2_encoder_cmd)
 #define VIDIOC_TRY_ENCODER_CMD  _IOWR('V', 78, struct v4l2_encoder_cmd)
-#endif
 
-#if 1
 /* Experimental, meant for debugging, testing and internal use.
    Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
    You must be root to use these ioctls. Never use these in applications! */
 #define	VIDIOC_DBG_S_REGISTER 	 _IOW('V', 79, struct v4l2_dbg_register)
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR('V', 80, struct v4l2_dbg_register)
 
-/* Experimental, meant for debugging, testing and internal use.
-   Never use this ioctl in applications! */
-#define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct v4l2_dbg_chip_ident)
-#endif
-
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
 
-/* These four DV Preset ioctls are deprecated in favor of the DV Timings
-   ioctls. */
-#define	VIDIOC_ENUM_DV_PRESETS	_IOWR('V', 83, struct v4l2_dv_enum_preset)
-#define	VIDIOC_S_DV_PRESET	_IOWR('V', 84, struct v4l2_dv_preset)
-#define	VIDIOC_G_DV_PRESET	_IOWR('V', 85, struct v4l2_dv_preset)
-#define	VIDIOC_QUERY_DV_PRESET	_IOR('V',  86, struct v4l2_dv_preset)
 #define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
 #define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)
 #define	VIDIOC_DQEVENT		 _IOR('V', 89, struct v4l2_event)
@@ -1990,9 +1964,13 @@ struct v4l2_create_buffers {
    versions. */
 #define VIDIOC_ENUM_FREQ_BANDS	_IOWR('V', 101, struct v4l2_frequency_band)
 
+/* Experimental, meant for debugging, testing and internal use.
+   Never use these in applications! */
+#define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
 #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
 
-#endif /* _UAPI__LINUX_VIDEODEV2_H */
+#endif /* __LINUX_VIDEODEV2_H */
-- 
1.7.10.4

