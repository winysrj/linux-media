Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47289 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbcDVJHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 05:07:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] videodev2.h: remove 'experimental' annotations.
Date: Fri, 22 Apr 2016 11:06:58 +0200
Message-Id: <1461316019-2497-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461316019-2497-1-git-send-email-hverkuil@xs4all.nl>
References: <1461316019-2497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Most of what is marked as 'experimental' has been around for years. Time
to drop that annotation.

The only remaining 'experimental' bits of the API are the debug ioctls
and structs: these should remain experimental since the only application
that should use this is v4l2-dbg.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e895975..8f95191 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -138,10 +138,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
 	V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
 	V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
-#if 1
-	/* Experimental */
 	V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
-#endif
 	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
 	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
@@ -657,8 +654,7 @@ struct v4l2_fmtdesc {
 #define V4L2_FMT_FLAG_COMPRESSED 0x0001
 #define V4L2_FMT_FLAG_EMULATED   0x0002
 
-#if 1
-	/* Experimental Frame Size and frame rate enumeration */
+	/* Frame Size and frame rate enumeration */
 /*
  *	F R A M E   S I Z E   E N U M E R A T I O N
  */
@@ -724,7 +720,6 @@ struct v4l2_frmivalenum {
 
 	__u32	reserved[2];			/* Reserved space for future use */
 };
-#endif
 
 /*
  *	T I M E C O D E
@@ -1728,8 +1723,6 @@ struct v4l2_audioout {
 
 /*
  *	M P E G   S E R V I C E S
- *
- *	NOTE: EXPERIMENTAL API
  */
 #if 1
 #define V4L2_ENC_IDX_FRAME_I    (0)
@@ -2259,46 +2252,35 @@ struct v4l2_create_buffers {
 #define VIDIOC_ENCODER_CMD      _IOWR('V', 77, struct v4l2_encoder_cmd)
 #define VIDIOC_TRY_ENCODER_CMD  _IOWR('V', 78, struct v4l2_encoder_cmd)
 
-/* Experimental, meant for debugging, testing and internal use.
-   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
-   You must be root to use these ioctls. Never use these in applications! */
+/*
+ * Experimental, meant for debugging, testing and internal use.
+ * Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
+ * You must be root to use these ioctls. Never use these in applications!
+ */
 #define	VIDIOC_DBG_S_REGISTER 	 _IOW('V', 79, struct v4l2_dbg_register)
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR('V', 80, struct v4l2_dbg_register)
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
-
 #define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
 #define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)
 #define	VIDIOC_DQEVENT		 _IOR('V', 89, struct v4l2_event)
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
-
-/* Experimental, the below two ioctls may change over the next couple of kernel
-   versions */
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
-
-/* Experimental selection API */
 #define VIDIOC_G_SELECTION	_IOWR('V', 94, struct v4l2_selection)
 #define VIDIOC_S_SELECTION	_IOWR('V', 95, struct v4l2_selection)
-
-/* Experimental, these two ioctls may change over the next couple of kernel
-   versions. */
 #define VIDIOC_DECODER_CMD	_IOWR('V', 96, struct v4l2_decoder_cmd)
 #define VIDIOC_TRY_DECODER_CMD	_IOWR('V', 97, struct v4l2_decoder_cmd)
-
-/* Experimental, these three ioctls may change over the next couple of kernel
-   versions. */
 #define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 98, struct v4l2_enum_dv_timings)
 #define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
 #define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
-
-/* Experimental, this ioctl may change over the next couple of kernel
-   versions. */
 #define VIDIOC_ENUM_FREQ_BANDS	_IOWR('V', 101, struct v4l2_frequency_band)
 
-/* Experimental, meant for debugging, testing and internal use.
-   Never use these in applications! */
+/*
+ * Experimental, meant for debugging, testing and internal use.
+ * Never use this in applications!
+ */
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
 
 #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
-- 
2.8.0.rc3

