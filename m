Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2530 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab1KXNj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/12] ivtv: use the new ivtv-specific ioctls from ivtv.h.
Date: Thu, 24 Nov 2011 14:39:06 +0100
Message-Id: <9cac793dc31e18eabcac62dcea484faf132da589.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
References: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ivtv driver now no longer uses dvb/audio.h and dvb/video.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-driver.h |    2 -
 drivers/media/video/ivtv/ivtv-ioctl.c  |  127 +++++++++++++++++---------------
 2 files changed, 67 insertions(+), 62 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index ef5ed32..0d2f31c 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -57,8 +57,6 @@
 #include <asm/system.h>
 #include <asm/byteorder.h>
 
-#include <linux/dvb/video.h>
-#include <linux/dvb/audio.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 736ba8e..fb66173 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -36,7 +36,6 @@
 #include <media/tveeprom.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-event.h>
-#include <linux/dvb/audio.h>
 
 u16 ivtv_service2vbi(int type)
 {
@@ -1618,11 +1617,17 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		return ivtv_yuv_prep_frame(itv, args);
 	}
 
-	case VIDEO_GET_PTS: {
+	case IVTV_IOC_PASSTHROUGH_MODE:
+		IVTV_DEBUG_IOCTL("IVTV_IOC_PASSTHROUGH_MODE\n");
+		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+			return -EINVAL;
+		return ivtv_passthrough_mode(itv, *(int *)arg != 0);
+
+	case IVTV_VIDEO_GET_PTS: {
 		s64 *pts = arg;
 		s64 frame;
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_PTS\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_GET_PTS\n");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
 			*pts = s->dma_pts;
 			break;
@@ -1632,11 +1637,11 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		return ivtv_g_pts_frame(itv, pts, &frame);
 	}
 
-	case VIDEO_GET_FRAME_COUNT: {
+	case IVTV_VIDEO_GET_FRAME_COUNT: {
 		s64 *frame = arg;
 		s64 pts;
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_FRAME_COUNT\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_GET_FRAME_COUNT\n");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
 			*frame = 0;
 			break;
@@ -1646,62 +1651,62 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		return ivtv_g_pts_frame(itv, &pts, frame);
 	}
 
-	case VIDEO_PLAY: {
+	case IVTV_VIDEO_PLAY: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_PLAY\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_PLAY\n");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_START;
 		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
-	case VIDEO_STOP: {
+	case IVTV_VIDEO_STOP: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_STOP\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_STOP\n");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_STOP;
 		dc.flags = V4L2_DEC_CMD_STOP_TO_BLACK | V4L2_DEC_CMD_STOP_IMMEDIATELY;
 		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
-	case VIDEO_FREEZE: {
+	case IVTV_VIDEO_FREEZE: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_FREEZE\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_FREEZE\n");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_PAUSE;
 		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
-	case VIDEO_CONTINUE: {
+	case IVTV_VIDEO_CONTINUE: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_CONTINUE\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_CONTINUE\n");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_RESUME;
 		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
-	case VIDEO_COMMAND:
-	case VIDEO_TRY_COMMAND: {
+	case IVTV_VIDEO_COMMAND:
+	case IVTV_VIDEO_TRY_COMMAND: {
 		/* Note: struct v4l2_decoder_cmd has the same layout as
 		   struct video_command */
 		struct v4l2_decoder_cmd *dc = arg;
-		int try = (cmd == VIDEO_TRY_COMMAND);
+		int try = (cmd == IVTV_VIDEO_TRY_COMMAND);
 
 		if (try)
-			IVTV_DEBUG_IOCTL("VIDEO_TRY_COMMAND %d\n", dc->cmd);
+			IVTV_DEBUG_IOCTL("IVTV_VIDEO_TRY_COMMAND %d\n", dc->cmd);
 		else
-			IVTV_DEBUG_IOCTL("VIDEO_COMMAND %d\n", dc->cmd);
+			IVTV_DEBUG_IOCTL("IVTV_VIDEO_COMMAND %d\n", dc->cmd);
 		return ivtv_video_command(itv, id, dc, try);
 	}
 
-	case VIDEO_GET_EVENT: {
-		struct video_event *ev = arg;
+	case IVTV_VIDEO_GET_EVENT: {
+		struct ivtv_video_event *ev = arg;
 		DEFINE_WAIT(wait);
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_EVENT\n");
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_GET_EVENT\n");
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
 		memset(ev, 0, sizeof(*ev));
@@ -1709,15 +1714,15 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 
 		while (1) {
 			if (test_and_clear_bit(IVTV_F_I_EV_DEC_STOPPED, &itv->i_flags))
-				ev->type = VIDEO_EVENT_DECODER_STOPPED;
+				ev->type = IVTV_VIDEO_EVENT_DECODER_STOPPED;
 			else if (test_and_clear_bit(IVTV_F_I_EV_VSYNC, &itv->i_flags)) {
-				ev->type = VIDEO_EVENT_VSYNC;
+				ev->type = IVTV_VIDEO_EVENT_VSYNC;
 				ev->u.vsync_field = test_bit(IVTV_F_I_EV_VSYNC_FIELD, &itv->i_flags) ?
-					VIDEO_VSYNC_FIELD_ODD : VIDEO_VSYNC_FIELD_EVEN;
+					IVTV_VIDEO_VSYNC_FIELD_ODD : IVTV_VIDEO_VSYNC_FIELD_EVEN;
 				if (itv->output_mode == OUT_UDMA_YUV &&
 					(itv->yuv_info.lace_mode & IVTV_YUV_MODE_MASK) ==
 								IVTV_YUV_MODE_PROGRESSIVE) {
-					ev->u.vsync_field = VIDEO_VSYNC_FIELD_PROGRESSIVE;
+					ev->u.vsync_field = IVTV_VIDEO_VSYNC_FIELD_PROGRESSIVE;
 				}
 			}
 			if (ev->type)
@@ -1743,28 +1748,28 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		break;
 	}
 
-	case VIDEO_SELECT_SOURCE:
-		IVTV_DEBUG_IOCTL("VIDEO_SELECT_SOURCE\n");
+	case IVTV_VIDEO_SELECT_SOURCE:
+		IVTV_DEBUG_IOCTL("IVTV_VIDEO_SELECT_SOURCE\n");
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
-		return ivtv_passthrough_mode(itv, iarg == VIDEO_SOURCE_DEMUX);
+		return ivtv_passthrough_mode(itv, iarg == IVTV_VIDEO_SOURCE_DEMUX);
 
-	case AUDIO_SET_MUTE:
-		IVTV_DEBUG_IOCTL("AUDIO_SET_MUTE\n");
+	case IVTV_AUDIO_SET_MUTE:
+		IVTV_DEBUG_IOCTL("IVTV_AUDIO_SET_MUTE\n");
 		itv->speed_mute_audio = iarg;
 		return 0;
 
-	case AUDIO_CHANNEL_SELECT:
-		IVTV_DEBUG_IOCTL("AUDIO_CHANNEL_SELECT\n");
-		if (iarg > AUDIO_STEREO_SWAPPED)
+	case IVTV_AUDIO_CHANNEL_SELECT:
+		IVTV_DEBUG_IOCTL("IVTV_AUDIO_CHANNEL_SELECT\n");
+		if (iarg > IVTV_AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg);
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg + 1);
 
-	case AUDIO_BILINGUAL_CHANNEL_SELECT:
-		IVTV_DEBUG_IOCTL("AUDIO_BILINGUAL_CHANNEL_SELECT\n");
-		if (iarg > AUDIO_STEREO_SWAPPED)
+	case IVTV_AUDIO_BILINGUAL_CHANNEL_SELECT:
+		IVTV_DEBUG_IOCTL("IVTV_AUDIO_BILINGUAL_CHANNEL_SELECT\n");
+		if (iarg > IVTV_AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg);
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg + 1);
 
 	default:
 		return -EINVAL;
@@ -1779,15 +1784,16 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 
 	if (!valid_prio) {
 		switch (cmd) {
-		case VIDEO_PLAY:
-		case VIDEO_STOP:
-		case VIDEO_FREEZE:
-		case VIDEO_CONTINUE:
-		case VIDEO_COMMAND:
-		case VIDEO_SELECT_SOURCE:
-		case AUDIO_SET_MUTE:
-		case AUDIO_CHANNEL_SELECT:
-		case AUDIO_BILINGUAL_CHANNEL_SELECT:
+		case IVTV_IOC_PASSTHROUGH_MODE:
+		case IVTV_VIDEO_PLAY:
+		case IVTV_VIDEO_STOP:
+		case IVTV_VIDEO_FREEZE:
+		case IVTV_VIDEO_CONTINUE:
+		case IVTV_VIDEO_COMMAND:
+		case IVTV_VIDEO_SELECT_SOURCE:
+		case IVTV_AUDIO_SET_MUTE:
+		case IVTV_AUDIO_CHANNEL_SELECT:
+		case IVTV_AUDIO_BILINGUAL_CHANNEL_SELECT:
 			return -EBUSY;
 		}
 	}
@@ -1804,19 +1810,20 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	}
 
 	case IVTV_IOC_DMA_FRAME:
-	case VIDEO_GET_PTS:
-	case VIDEO_GET_FRAME_COUNT:
-	case VIDEO_GET_EVENT:
-	case VIDEO_PLAY:
-	case VIDEO_STOP:
-	case VIDEO_FREEZE:
-	case VIDEO_CONTINUE:
-	case VIDEO_COMMAND:
-	case VIDEO_TRY_COMMAND:
-	case VIDEO_SELECT_SOURCE:
-	case AUDIO_SET_MUTE:
-	case AUDIO_CHANNEL_SELECT:
-	case AUDIO_BILINGUAL_CHANNEL_SELECT:
+	case IVTV_IOC_PASSTHROUGH_MODE:
+	case IVTV_VIDEO_GET_PTS:
+	case IVTV_VIDEO_GET_FRAME_COUNT:
+	case IVTV_VIDEO_GET_EVENT:
+	case IVTV_VIDEO_PLAY:
+	case IVTV_VIDEO_STOP:
+	case IVTV_VIDEO_FREEZE:
+	case IVTV_VIDEO_CONTINUE:
+	case IVTV_VIDEO_COMMAND:
+	case IVTV_VIDEO_TRY_COMMAND:
+	case IVTV_VIDEO_SELECT_SOURCE:
+	case IVTV_AUDIO_SET_MUTE:
+	case IVTV_AUDIO_CHANNEL_SELECT:
+	case IVTV_AUDIO_BILINGUAL_CHANNEL_SELECT:
 		return ivtv_decoder_ioctls(file, cmd, (void *)arg);
 
 	default:
-- 
1.7.7.3

