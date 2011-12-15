Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1991 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab1LOOP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 6/8] ivtv: implement new decoder controls.
Date: Thu, 15 Dec 2011 15:15:35 +0100
Message-Id: <716972634f1eb8e978e923bb03b9e36528be3b88.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-controls.c |   62 +++++++++++++++++++++++++++
 drivers/media/video/ivtv/ivtv-controls.h |    2 +
 drivers/media/video/ivtv/ivtv-driver.c   |   35 +++++++++++++++-
 drivers/media/video/ivtv/ivtv-driver.h   |   12 +++++-
 drivers/media/video/ivtv/ivtv-ioctl.c    |   67 +++++------------------------
 drivers/media/video/ivtv/ivtv-streams.c  |    5 ++-
 6 files changed, 124 insertions(+), 59 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-controls.c b/drivers/media/video/ivtv/ivtv-controls.c
index b31ee1b..e290118 100644
--- a/drivers/media/video/ivtv/ivtv-controls.c
+++ b/drivers/media/video/ivtv/ivtv-controls.c
@@ -21,6 +21,7 @@
 #include "ivtv-driver.h"
 #include "ivtv-ioctl.h"
 #include "ivtv-controls.h"
+#include "ivtv-mailbox.h"
 
 static int ivtv_s_stream_vbi_fmt(struct cx2341x_handler *cxhdl, u32 fmt)
 {
@@ -99,3 +100,64 @@ struct cx2341x_handler_ops ivtv_cxhdl_ops = {
 	.s_video_encoding = ivtv_s_video_encoding,
 	.s_stream_vbi_fmt = ivtv_s_stream_vbi_fmt,
 };
+
+int ivtv_g_pts_frame(struct ivtv *itv, s64 *pts, s64 *frame)
+{
+	u32 data[CX2341X_MBOX_MAX_DATA];
+
+	if (test_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags)) {
+		*pts = (s64)((u64)itv->last_dec_timing[2] << 32) |
+			(u64)itv->last_dec_timing[1];
+		*frame = itv->last_dec_timing[0];
+		return 0;
+	}
+	*pts = 0;
+	*frame = 0;
+	if (atomic_read(&itv->decoding)) {
+		if (ivtv_api(itv, CX2341X_DEC_GET_TIMING_INFO, 5, data)) {
+			IVTV_DEBUG_WARN("GET_TIMING: couldn't read clock\n");
+			return -EIO;
+		}
+		memcpy(itv->last_dec_timing, data, sizeof(itv->last_dec_timing));
+		set_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags);
+		*pts = (s64)((u64) data[2] << 32) | (u64) data[1];
+		*frame = data[0];
+		/*timing->scr = (u64) (((u64) data[4] << 32) | (u64) (data[3]));*/
+	}
+	return 0;
+}
+
+static int ivtv_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ivtv *itv = container_of(ctrl->handler, struct ivtv, hdl_out);
+
+	switch (ctrl->id) {
+	/* V4L2_CID_MPEG_VIDEO_DEC_PTS and V4L2_CID_MPEG_VIDEO_DEC_FRAME
+	   control cluster */
+	case V4L2_CID_MPEG_VIDEO_DEC_PTS:
+		return ivtv_g_pts_frame(itv, &itv->ctrl_pts->val64,
+					     &itv->ctrl_frame->val64);
+	}
+	return 0;
+}
+
+static int ivtv_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ivtv *itv = container_of(ctrl->handler, struct ivtv, hdl_out);
+
+	switch (ctrl->id) {
+	/* V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK and MULTILINGUAL_PLAYBACK
+	   control cluster */
+	case V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK:
+		itv->audio_stereo_mode = itv->ctrl_audio_playback->val - 1;
+		itv->audio_bilingual_mode = itv->ctrl_audio_multilingual_playback->val - 1;
+		ivtv_vapi(itv, CX2341X_DEC_SET_AUDIO_MODE, 2, itv->audio_bilingual_mode, itv->audio_stereo_mode);
+		break;
+	}
+	return 0;
+}
+
+const struct v4l2_ctrl_ops ivtv_hdl_out_ops = {
+	.s_ctrl = ivtv_s_ctrl,
+	.g_volatile_ctrl = ivtv_g_volatile_ctrl,
+};
diff --git a/drivers/media/video/ivtv/ivtv-controls.h b/drivers/media/video/ivtv/ivtv-controls.h
index d12893d..3999e63 100644
--- a/drivers/media/video/ivtv/ivtv-controls.h
+++ b/drivers/media/video/ivtv/ivtv-controls.h
@@ -22,5 +22,7 @@
 #define IVTV_CONTROLS_H
 
 extern struct cx2341x_handler_ops ivtv_cxhdl_ops;
+extern const struct v4l2_ctrl_ops ivtv_hdl_out_ops;
+int ivtv_g_pts_frame(struct ivtv *itv, s64 *pts, s64 *frame);
 
 #endif
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 7ee7594..ec5a25a 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -747,8 +747,6 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
 
 	itv->cur_dma_stream = -1;
 	itv->cur_pio_stream = -1;
-	itv->audio_stereo_mode = AUDIO_STEREO;
-	itv->audio_bilingual_mode = AUDIO_MONO_LEFT;
 
 	/* Ctrls */
 	itv->speed = 1000;
@@ -1203,6 +1201,32 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 	itv->tuner_std = itv->std;
 
 	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
+		v4l2_ctrl_handler_init(&itv->hdl_out, 50);
+		itv->ctrl_pts = v4l2_ctrl_new_std(&itv->hdl_out, &ivtv_hdl_out_ops,
+				V4L2_CID_MPEG_VIDEO_DEC_PTS, 0, 0, 1, 0);
+		itv->ctrl_frame = v4l2_ctrl_new_std(&itv->hdl_out, &ivtv_hdl_out_ops,
+				V4L2_CID_MPEG_VIDEO_DEC_FRAME, 0, 0x7fffffff, 1, 0);
+		/* Note: V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO is not supported,
+		   mask that menu item. */
+		itv->ctrl_audio_playback =
+			v4l2_ctrl_new_std_menu(&itv->hdl_out, &ivtv_hdl_out_ops,
+				V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK,
+				V4L2_MPEG_AUDIO_DEC_PLAYBACK_SWAPPED_STEREO,
+				1 << V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO,
+				V4L2_MPEG_AUDIO_DEC_PLAYBACK_STEREO);
+		itv->ctrl_audio_multilingual_playback =
+			v4l2_ctrl_new_std_menu(&itv->hdl_out, &ivtv_hdl_out_ops,
+				V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK,
+				V4L2_MPEG_AUDIO_DEC_PLAYBACK_SWAPPED_STEREO,
+				1 << V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO,
+				V4L2_MPEG_AUDIO_DEC_PLAYBACK_LEFT);
+		v4l2_ctrl_add_handler(&itv->hdl_out, &itv->cxhdl.hdl);
+		if (itv->hdl_out.error) {
+			retval = itv->hdl_out.error;
+			goto free_i2c;
+		}
+		v4l2_ctrl_cluster(2, &itv->ctrl_pts);
+		v4l2_ctrl_cluster(2, &itv->ctrl_audio_playback);
 		ivtv_call_all(itv, video, s_std_output, itv->std);
 		/* Turn off the output signal. The mpeg decoder is not yet
 		   active so without this you would get a green image until the
@@ -1239,6 +1263,9 @@ free_streams:
 free_irq:
 	free_irq(itv->pdev->irq, (void *)itv);
 free_i2c:
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)
+		v4l2_ctrl_handler_free(&itv->hdl_out);
+	v4l2_ctrl_handler_free(&itv->cxhdl.hdl);
 	exit_ivtv_i2c(itv);
 free_io:
 	ivtv_iounmap(itv);
@@ -1394,6 +1421,10 @@ static void ivtv_remove(struct pci_dev *pdev)
 	ivtv_streams_cleanup(itv, 1);
 	ivtv_udma_free(itv);
 
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)
+		v4l2_ctrl_handler_free(&itv->hdl_out);
+	v4l2_ctrl_handler_free(&itv->cxhdl.hdl);
+
 	exit_ivtv_i2c(itv);
 
 	free_irq(itv->pdev->irq, (void *)itv);
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 8f9cc17..ef5ed32 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -631,6 +631,17 @@ struct ivtv {
 
 	struct v4l2_device v4l2_dev;
 	struct cx2341x_handler cxhdl;
+	struct {
+		/* PTS/Frame count control cluster */
+		struct v4l2_ctrl *ctrl_pts;
+		struct v4l2_ctrl *ctrl_frame;
+	};
+	struct {
+		/* Audio Playback control cluster */
+		struct v4l2_ctrl *ctrl_audio_playback;
+		struct v4l2_ctrl *ctrl_audio_multilingual_playback;
+	};
+	struct v4l2_ctrl_handler hdl_out;
 	struct v4l2_ctrl_handler hdl_gpio;
 	struct v4l2_subdev sd_gpio;	/* GPIO sub-device */
 	u16 instance;
@@ -650,7 +661,6 @@ struct ivtv {
 	u8 audio_stereo_mode;           /* decoder setting how to handle stereo MPEG audio */
 	u8 audio_bilingual_mode;        /* decoder setting how to handle bilingual MPEG audio */
 
-
 	/* Locking */
 	spinlock_t lock;                /* lock access to this struct */
 	struct mutex serialize_lock;    /* mutex used to serialize open/close/start/stop/ioctl operations */
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index c84e325..736ba8e 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1503,13 +1503,6 @@ static int ivtv_log_status(struct file *file, void *fh)
 			"YUV Frames",
 			"Passthrough",
 		};
-		static const char * const audio_modes[5] = {
-			"Stereo",
-			"Left",
-			"Right",
-			"Mono",
-			"Swapped"
-		};
 		static const char * const alpha_mode[4] = {
 			"None",
 			"Global",
@@ -1538,9 +1531,6 @@ static int ivtv_log_status(struct file *file, void *fh)
 		ivtv_get_output(itv, itv->active_output, &vidout);
 		ivtv_get_audio_output(itv, 0, &audout);
 		IVTV_INFO("Video Output: %s\n", vidout.name);
-		IVTV_INFO("Audio Output: %s (Stereo/Bilingual: %s/%s)\n", audout.name,
-			audio_modes[itv->audio_stereo_mode],
-			audio_modes[itv->audio_bilingual_mode]);
 		if (mode < 0 || mode > OUT_PASSTHROUGH)
 			mode = OUT_NONE;
 		IVTV_INFO("Output Mode:  %s\n", output_modes[mode]);
@@ -1553,7 +1543,10 @@ static int ivtv_log_status(struct file *file, void *fh)
 	}
 	IVTV_INFO("Tuner:  %s\n",
 		test_bit(IVTV_F_I_RADIO_USER, &itv->i_flags) ? "Radio" : "TV");
-	v4l2_ctrl_handler_log_status(&itv->cxhdl.hdl, itv->v4l2_dev.name);
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)
+		v4l2_ctrl_handler_log_status(&itv->hdl_out, itv->v4l2_dev.name);
+	else
+		v4l2_ctrl_handler_log_status(&itv->cxhdl.hdl, itv->v4l2_dev.name);
 	IVTV_INFO("Status flags:    0x%08lx\n", itv->i_flags);
 	for (i = 0; i < IVTV_MAX_STREAMS; i++) {
 		struct ivtv_stream *s = &itv->streams[i];
@@ -1626,8 +1619,8 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	}
 
 	case VIDEO_GET_PTS: {
-		u32 data[CX2341X_MBOX_MAX_DATA];
-		u64 *pts = arg;
+		s64 *pts = arg;
+		s64 frame;
 
 		IVTV_DEBUG_IOCTL("VIDEO_GET_PTS\n");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
@@ -1636,29 +1629,12 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		}
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
-
-		if (test_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags)) {
-			*pts = (u64) ((u64)itv->last_dec_timing[2] << 32) |
-					(u64)itv->last_dec_timing[1];
-			break;
-		}
-		*pts = 0;
-		if (atomic_read(&itv->decoding)) {
-			if (ivtv_api(itv, CX2341X_DEC_GET_TIMING_INFO, 5, data)) {
-				IVTV_DEBUG_WARN("GET_TIMING: couldn't read clock\n");
-				return -EIO;
-			}
-			memcpy(itv->last_dec_timing, data, sizeof(itv->last_dec_timing));
-			set_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags);
-			*pts = (u64) ((u64) data[2] << 32) | (u64) data[1];
-			/*timing->scr = (u64) (((u64) data[4] << 32) | (u64) (data[3]));*/
-		}
-		break;
+		return ivtv_g_pts_frame(itv, pts, &frame);
 	}
 
 	case VIDEO_GET_FRAME_COUNT: {
-		u32 data[CX2341X_MBOX_MAX_DATA];
-		u64 *frame = arg;
+		s64 *frame = arg;
+		s64 pts;
 
 		IVTV_DEBUG_IOCTL("VIDEO_GET_FRAME_COUNT\n");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
@@ -1667,22 +1643,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		}
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
-
-		if (test_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags)) {
-			*frame = itv->last_dec_timing[0];
-			break;
-		}
-		*frame = 0;
-		if (atomic_read(&itv->decoding)) {
-			if (ivtv_api(itv, CX2341X_DEC_GET_TIMING_INFO, 5, data)) {
-				IVTV_DEBUG_WARN("GET_TIMING: couldn't read clock\n");
-				return -EIO;
-			}
-			memcpy(itv->last_dec_timing, data, sizeof(itv->last_dec_timing));
-			set_bit(IVTV_F_I_VALID_DEC_TIMINGS, &itv->i_flags);
-			*frame = data[0];
-		}
-		break;
+		return ivtv_g_pts_frame(itv, &pts, frame);
 	}
 
 	case VIDEO_PLAY: {
@@ -1797,17 +1758,13 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		IVTV_DEBUG_IOCTL("AUDIO_CHANNEL_SELECT\n");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		itv->audio_stereo_mode = iarg;
-		ivtv_vapi(itv, CX2341X_DEC_SET_AUDIO_MODE, 2, itv->audio_bilingual_mode, itv->audio_stereo_mode);
-		return 0;
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg);
 
 	case AUDIO_BILINGUAL_CHANNEL_SELECT:
 		IVTV_DEBUG_IOCTL("AUDIO_BILINGUAL_CHANNEL_SELECT\n");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
-		itv->audio_bilingual_mode = iarg;
-		ivtv_vapi(itv, CX2341X_DEC_SET_AUDIO_MODE, 2, itv->audio_bilingual_mode, itv->audio_stereo_mode);
-		return 0;
+		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg);
 
 	default:
 		return -EINVAL;
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 75226b7..7b9cbb3 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -210,7 +210,10 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 
 	s->vdev->num = num;
 	s->vdev->v4l2_dev = &itv->v4l2_dev;
-	s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)
+		s->vdev->ctrl_handler = &itv->hdl_out;
+	else
+		s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
 	s->vdev->fops = ivtv_stream_info[type].fops;
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
-- 
1.7.7.3

