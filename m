Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4243 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1LOOPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 3/8] ivtv: implement new decoder command ioctls.
Date: Thu, 15 Dec 2011 15:15:32 +0100
Message-Id: <ff1329317ab4b4dde66c8abfa1d730a5d94c1009.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-driver.c  |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c   |  106 +++++++++++++++++++-----------
 drivers/media/video/ivtv/ivtv-streams.c |    4 +-
 4 files changed, 71 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 41108a9..7ee7594 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1378,7 +1378,7 @@ static void ivtv_remove(struct pci_dev *pdev)
 			else
 				type = IVTV_DEC_STREAM_TYPE_MPG;
 			ivtv_stop_v4l2_decode_stream(&itv->streams[type],
-				VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY, 0);
+				V4L2_DEC_CMD_STOP_TO_BLACK | V4L2_DEC_CMD_STOP_IMMEDIATELY, 0);
 		}
 		ivtv_halt_firmware(itv);
 	}
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 38f0522..66228ee 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -899,7 +899,7 @@ int ivtv_v4l2_close(struct file *filp)
 	} else if (s->type >= IVTV_DEC_STREAM_TYPE_MPG) {
 		struct ivtv_stream *s_vout = &itv->streams[IVTV_DEC_STREAM_TYPE_VOUT];
 
-		ivtv_stop_decoding(id, VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY, 0);
+		ivtv_stop_decoding(id, V4L2_DEC_CMD_STOP_TO_BLACK | V4L2_DEC_CMD_STOP_IMMEDIATELY, 0);
 
 		/* If all output streams are closed, and if the user doesn't have
 		   IVTV_DEC_STREAM_TYPE_VOUT open, then disable CC on TV-out. */
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index ecafa69..c84e325 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -244,34 +244,40 @@ static int ivtv_validate_speed(int cur_speed, int new_speed)
 }
 
 static int ivtv_video_command(struct ivtv *itv, struct ivtv_open_id *id,
-		struct video_command *vc, int try)
+		struct v4l2_decoder_cmd *dc, int try)
 {
 	struct ivtv_stream *s = &itv->streams[IVTV_DEC_STREAM_TYPE_MPG];
 
 	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 		return -EINVAL;
 
-	switch (vc->cmd) {
-	case VIDEO_CMD_PLAY: {
-		vc->flags = 0;
-		vc->play.speed = ivtv_validate_speed(itv->speed, vc->play.speed);
-		if (vc->play.speed < 0)
-			vc->play.format = VIDEO_PLAY_FMT_GOP;
+	switch (dc->cmd) {
+	case V4L2_DEC_CMD_START: {
+		dc->flags &= V4L2_DEC_CMD_START_MUTE_AUDIO;
+		dc->start.speed = ivtv_validate_speed(itv->speed, dc->start.speed);
+		if (dc->start.speed < 0)
+			dc->start.format = V4L2_DEC_START_FMT_GOP;
+		else
+			dc->start.format = V4L2_DEC_START_FMT_NONE;
+		if (dc->start.speed != 500 && dc->start.speed != 1500)
+			dc->flags = dc->start.speed == 1000 ? 0 :
+					V4L2_DEC_CMD_START_MUTE_AUDIO;
 		if (try) break;
 
+		itv->speed_mute_audio = dc->flags & V4L2_DEC_CMD_START_MUTE_AUDIO;
 		if (ivtv_set_output_mode(itv, OUT_MPG) != OUT_MPG)
 			return -EBUSY;
 		if (test_and_clear_bit(IVTV_F_I_DEC_PAUSED, &itv->i_flags)) {
 			/* forces ivtv_set_speed to be called */
 			itv->speed = 0;
 		}
-		return ivtv_start_decoding(id, vc->play.speed);
+		return ivtv_start_decoding(id, dc->start.speed);
 	}
 
-	case VIDEO_CMD_STOP:
-		vc->flags &= VIDEO_CMD_STOP_IMMEDIATELY|VIDEO_CMD_STOP_TO_BLACK;
-		if (vc->flags & VIDEO_CMD_STOP_IMMEDIATELY)
-			vc->stop.pts = 0;
+	case V4L2_DEC_CMD_STOP:
+		dc->flags &= V4L2_DEC_CMD_STOP_IMMEDIATELY | V4L2_DEC_CMD_STOP_TO_BLACK;
+		if (dc->flags & V4L2_DEC_CMD_STOP_IMMEDIATELY)
+			dc->stop.pts = 0;
 		if (try) break;
 		if (atomic_read(&itv->decoding) == 0)
 			return 0;
@@ -279,22 +285,22 @@ static int ivtv_video_command(struct ivtv *itv, struct ivtv_open_id *id,
 			return -EBUSY;
 
 		itv->output_mode = OUT_NONE;
-		return ivtv_stop_v4l2_decode_stream(s, vc->flags, vc->stop.pts);
+		return ivtv_stop_v4l2_decode_stream(s, dc->flags, dc->stop.pts);
 
-	case VIDEO_CMD_FREEZE:
-		vc->flags &= VIDEO_CMD_FREEZE_TO_BLACK;
+	case V4L2_DEC_CMD_PAUSE:
+		dc->flags &= V4L2_DEC_CMD_PAUSE_TO_BLACK;
 		if (try) break;
 		if (itv->output_mode != OUT_MPG)
 			return -EBUSY;
 		if (atomic_read(&itv->decoding) > 0) {
 			ivtv_vapi(itv, CX2341X_DEC_PAUSE_PLAYBACK, 1,
-				(vc->flags & VIDEO_CMD_FREEZE_TO_BLACK) ? 1 : 0);
+				(dc->flags & V4L2_DEC_CMD_PAUSE_TO_BLACK) ? 1 : 0);
 			set_bit(IVTV_F_I_DEC_PAUSED, &itv->i_flags);
 		}
 		break;
 
-	case VIDEO_CMD_CONTINUE:
-		vc->flags = 0;
+	case V4L2_DEC_CMD_RESUME:
+		dc->flags = 0;
 		if (try) break;
 		if (itv->output_mode != OUT_MPG)
 			return -EBUSY;
@@ -1568,6 +1574,24 @@ static int ivtv_log_status(struct file *file, void *fh)
 	return 0;
 }
 
+static int ivtv_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *dec)
+{
+	struct ivtv_open_id *id = fh2id(file->private_data);
+	struct ivtv *itv = id->itv;
+
+	IVTV_DEBUG_IOCTL("VIDIOC_DECODER_CMD %d\n", dec->cmd);
+	return ivtv_video_command(itv, id, dec, false);
+}
+
+static int ivtv_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *dec)
+{
+	struct ivtv_open_id *id = fh2id(file->private_data);
+	struct ivtv *itv = id->itv;
+
+	IVTV_DEBUG_IOCTL("VIDIOC_TRY_DECODER_CMD %d\n", dec->cmd);
+	return ivtv_video_command(itv, id, dec, true);
+}
+
 static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 {
 	struct ivtv_open_id *id = fh2id(filp->private_data);
@@ -1662,52 +1686,54 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	}
 
 	case VIDEO_PLAY: {
-		struct video_command vc;
+		struct v4l2_decoder_cmd dc;
 
 		IVTV_DEBUG_IOCTL("VIDEO_PLAY\n");
-		memset(&vc, 0, sizeof(vc));
-		vc.cmd = VIDEO_CMD_PLAY;
-		return ivtv_video_command(itv, id, &vc, 0);
+		memset(&dc, 0, sizeof(dc));
+		dc.cmd = V4L2_DEC_CMD_START;
+		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
 	case VIDEO_STOP: {
-		struct video_command vc;
+		struct v4l2_decoder_cmd dc;
 
 		IVTV_DEBUG_IOCTL("VIDEO_STOP\n");
-		memset(&vc, 0, sizeof(vc));
-		vc.cmd = VIDEO_CMD_STOP;
-		vc.flags = VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY;
-		return ivtv_video_command(itv, id, &vc, 0);
+		memset(&dc, 0, sizeof(dc));
+		dc.cmd = V4L2_DEC_CMD_STOP;
+		dc.flags = V4L2_DEC_CMD_STOP_TO_BLACK | V4L2_DEC_CMD_STOP_IMMEDIATELY;
+		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
 	case VIDEO_FREEZE: {
-		struct video_command vc;
+		struct v4l2_decoder_cmd dc;
 
 		IVTV_DEBUG_IOCTL("VIDEO_FREEZE\n");
-		memset(&vc, 0, sizeof(vc));
-		vc.cmd = VIDEO_CMD_FREEZE;
-		return ivtv_video_command(itv, id, &vc, 0);
+		memset(&dc, 0, sizeof(dc));
+		dc.cmd = V4L2_DEC_CMD_PAUSE;
+		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
 	case VIDEO_CONTINUE: {
-		struct video_command vc;
+		struct v4l2_decoder_cmd dc;
 
 		IVTV_DEBUG_IOCTL("VIDEO_CONTINUE\n");
-		memset(&vc, 0, sizeof(vc));
-		vc.cmd = VIDEO_CMD_CONTINUE;
-		return ivtv_video_command(itv, id, &vc, 0);
+		memset(&dc, 0, sizeof(dc));
+		dc.cmd = V4L2_DEC_CMD_RESUME;
+		return ivtv_video_command(itv, id, &dc, 0);
 	}
 
 	case VIDEO_COMMAND:
 	case VIDEO_TRY_COMMAND: {
-		struct video_command *vc = arg;
+		/* Note: struct v4l2_decoder_cmd has the same layout as
+		   struct video_command */
+		struct v4l2_decoder_cmd *dc = arg;
 		int try = (cmd == VIDEO_TRY_COMMAND);
 
 		if (try)
-			IVTV_DEBUG_IOCTL("VIDEO_TRY_COMMAND %d\n", vc->cmd);
+			IVTV_DEBUG_IOCTL("VIDEO_TRY_COMMAND %d\n", dc->cmd);
 		else
-			IVTV_DEBUG_IOCTL("VIDEO_COMMAND %d\n", vc->cmd);
-		return ivtv_video_command(itv, id, vc, try);
+			IVTV_DEBUG_IOCTL("VIDEO_COMMAND %d\n", dc->cmd);
+		return ivtv_video_command(itv, id, dc, try);
 	}
 
 	case VIDEO_GET_EVENT: {
@@ -1901,6 +1927,8 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_enum_fmt_vid_cap 	    = ivtv_enum_fmt_vid_cap,
 	.vidioc_encoder_cmd  		    = ivtv_encoder_cmd,
 	.vidioc_try_encoder_cmd 	    = ivtv_try_encoder_cmd,
+	.vidioc_decoder_cmd		    = ivtv_decoder_cmd,
+	.vidioc_try_decoder_cmd		    = ivtv_try_decoder_cmd,
 	.vidioc_enum_fmt_vid_out 	    = ivtv_enum_fmt_vid_out,
 	.vidioc_g_fmt_vid_cap 		    = ivtv_g_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap		    = ivtv_g_fmt_vbi_cap,
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index e7794dc..75226b7 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -891,7 +891,7 @@ int ivtv_stop_v4l2_decode_stream(struct ivtv_stream *s, int flags, u64 pts)
 	IVTV_DEBUG_INFO("Stop Decode at %llu, flags: %x\n", (unsigned long long)pts, flags);
 
 	/* Stop Decoder */
-	if (!(flags & VIDEO_CMD_STOP_IMMEDIATELY) || pts) {
+	if (!(flags & V4L2_DEC_CMD_STOP_IMMEDIATELY) || pts) {
 		u32 tmp = 0;
 
 		/* Wait until the decoder is no longer running */
@@ -911,7 +911,7 @@ int ivtv_stop_v4l2_decode_stream(struct ivtv_stream *s, int flags, u64 pts)
 				break;
 		}
 	}
-	ivtv_vapi(itv, CX2341X_DEC_STOP_PLAYBACK, 3, flags & VIDEO_CMD_STOP_TO_BLACK, 0, 0);
+	ivtv_vapi(itv, CX2341X_DEC_STOP_PLAYBACK, 3, flags & V4L2_DEC_CMD_STOP_TO_BLACK, 0, 0);
 
 	/* turn off notification of dual/stereo mode change */
 	ivtv_vapi(itv, CX2341X_DEC_SET_EVENT_NOTIFICATION, 4, 0, 0, IVTV_IRQ_DEC_AUD_MODE_CHG, -1);
-- 
1.7.7.3

