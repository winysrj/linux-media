Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4257 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab1KXNjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/12] ivtv: extend ivtv.h with structs and ioctls from dvb/audio.h and video.h.
Date: Thu, 24 Nov 2011 14:39:05 +0100
Message-Id: <3eb9714f99dc3fec58efde1515c7ab865168ca3a.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
References: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This removes the ivtv dependency on those dvb headers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/ivtv.h |   86 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 062d20f..dacb712 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -58,7 +58,8 @@ struct ivtv_dma_frame {
 	__u32 src_height;
 };
 
-#define IVTV_IOC_DMA_FRAME  _IOW ('V', BASE_VIDIOC_PRIVATE+0, struct ivtv_dma_frame)
+#define IVTV_IOC_DMA_FRAME		_IOW ('V', BASE_VIDIOC_PRIVATE+0, struct ivtv_dma_frame)
+#define IVTV_IOC_PASSTHROUGH_MODE	_IOW ('V', BASE_VIDIOC_PRIVATE+1, int)
 
 /* Deprecated defines: applications should use the defines from videodev2.h */
 #define IVTV_SLICED_TYPE_TELETEXT_B     V4L2_MPEG_VBI_IVTV_TELETEXT_B
@@ -66,4 +67,87 @@ struct ivtv_dma_frame {
 #define IVTV_SLICED_TYPE_WSS_625        V4L2_MPEG_VBI_IVTV_WSS_625
 #define IVTV_SLICED_TYPE_VPS            V4L2_MPEG_VBI_IVTV_VPS
 
+
+/* The code below used to be part of the DVBv5 API as was defined in the
+   linux/dvb/audio.h and video.h headers.
+
+   That API was only used by av7110 and ivtv and the decision was made to
+   deprecate that decoder API and replace it with a proper V4L2 API in the
+   case of ivtv.
+
+   For the time being the part of those headers that ivtv uses is copied in
+   this header and renamed with an IVTV_ prefix. At some point in the future
+   this API will probably be removed.
+
+   The replacement V4L2 API appeared in kernel 3.3. How to convert applications
+   from the old DVBv5 API to the new V4L2 API is described below. */
+
+/* Should the audio be muted when doing playback at non-standard speeds?
+   Replaced by the V4L2_DEC_CMD_START_MUTE_AUDIO flag. */
+#define IVTV_AUDIO_SET_MUTE             _IO('o', 6)
+
+/* Channel selection during playback.
+   Replaced by the V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK and
+   V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK controls. */
+#define IVTV_AUDIO_STEREO		(0)
+#define IVTV_AUDIO_MONO_LEFT		(1)
+#define IVTV_AUDIO_MONO_RIGHT		(2)
+#define IVTV_AUDIO_MONO			(3)
+#define IVTV_AUDIO_STEREO_SWAPPED	(4)
+
+#define IVTV_AUDIO_CHANNEL_SELECT       _IO('o', 9)
+#define IVTV_AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
+
+/* Video playback. Replaced by the VIDIOC_(TRY_)DECODER_CMD ioctls. */
+#define IVTV_VIDEO_STOP                 _IO('o', 21)
+#define IVTV_VIDEO_PLAY                 _IO('o', 22)
+#define IVTV_VIDEO_FREEZE               _IO('o', 23)
+#define IVTV_VIDEO_CONTINUE             _IO('o', 24)
+#define IVTV_VIDEO_COMMAND		_IOWR('o', 59, struct v4l2_decoder_cmd)
+#define IVTV_VIDEO_TRY_COMMAND		_IOWR('o', 60, struct v4l2_decoder_cmd)
+
+/* Select passthrough mode. Replaced by the ivtv-private
+   IVTV_IOC_PASSTHROUGH_MODE ioctl. */
+#define IVTV_VIDEO_SOURCE_DEMUX		(0)
+#define IVTV_VIDEO_SOURCE_MEMORY	(1)
+#define IVTV_VIDEO_SELECT_SOURCE        _IO('o', 25)
+
+/* Event handling. Replaced by the V4L2 event API (VIDIOC_DQEVENT et al.)
+ *
+ * This ioctl call returns an event of type video_event if available. If an
+ * event is not available, the behavior depends on whether the device is in
+ * blocking or non-blocking mode. In the latter case, the call fails immediately
+ * with errno set to EWOULDBLOCK. In the former case, the call blocks until an
+ * event becomes available. The standard Linux poll() and/or select() system
+ * calls can be used with the device file descriptor to watch for new events.
+ * For select(), the file descriptor should be included in the exceptfds
+ * argument, and for poll(), POLLPRI should be specified as the wake-up
+ * condition. Read-only permissions are sufficient for this ioctl call.
+ */
+
+/* FIELD_UNKNOWN can be used if the hardware does not know whether
+   the Vsync is for an odd, even or progressive (i.e. non-interlaced)
+   field. */
+#define IVTV_VIDEO_VSYNC_FIELD_UNKNOWN		(0)
+#define IVTV_VIDEO_VSYNC_FIELD_ODD		(1)
+#define IVTV_VIDEO_VSYNC_FIELD_EVEN		(2)
+#define IVTV_VIDEO_VSYNC_FIELD_PROGRESSIVE	(3)
+
+struct ivtv_video_event {
+	__s32 type;
+#define IVTV_VIDEO_EVENT_DECODER_STOPPED	(3)
+#define IVTV_VIDEO_EVENT_VSYNC			(4)
+	__kernel_time_t timestamp;
+	union {
+		unsigned char vsync_field;	/* unknown/odd/even/progressive */
+	} u;
+};
+#define IVTV_VIDEO_GET_EVENT		_IOR('o', 28, struct ivtv_video_event)
+
+/* Returns the PTS and frame count of the frame that's being decoded or
+   displayed. Replaced by the V4L2_CID_MPEG_STREAM_DEC_PTS and
+   V4L2_CID_MPEG_VIDEO_DEC_FRAME read-only controls. */
+#define IVTV_VIDEO_GET_PTS		_IOR('o', 57, __u64)
+#define IVTV_VIDEO_GET_FRAME_COUNT	_IOR('o', 58, __u64)
+
 #endif /* _LINUX_IVTV_H */
-- 
1.7.7.3

