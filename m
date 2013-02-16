Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4397 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3BPJ3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:29:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 18/18] videodev2.h: remove obsolete DV_PRESET API.
Date: Sat, 16 Feb 2013 10:28:21 +0100
Message-Id: <59486e087c821d973ce8a59256916a9224b6c2b0.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This API is now obsolete and can be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h |   54 ----------------------------------------
 1 file changed, 54 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 234d1d8..d1513c3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -980,52 +980,6 @@ struct v4l2_standard {
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
@@ -1239,7 +1193,6 @@ struct v4l2_input {
 #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
 
 /* capabilities flags */
-#define V4L2_IN_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
 #define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
@@ -1263,7 +1216,6 @@ struct v4l2_output {
 #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY	3
 
 /* capabilities flags */
-#define V4L2_OUT_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
 #define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
@@ -1980,12 +1932,6 @@ struct v4l2_create_buffers {
 
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
-- 
1.7.10.4

