Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4954 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab0E2OpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 10:45:11 -0400
Message-Id: <c3b46f4543308bb31149c9cac3d46e0159be218b.1275143672.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1275143672.git.hverkuil@xs4all.nl>
References: <cover.1275143672.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 29 May 2010 16:47:02 +0200
Subject: [PATCH 15/15] [RFCv4] ivtv: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ivtv/ivtv-controls.c |  275 ++++--------------------------
 drivers/media/video/ivtv/ivtv-controls.h |    6 +-
 drivers/media/video/ivtv/ivtv-driver.c   |   18 ++-
 drivers/media/video/ivtv/ivtv-driver.h   |    5 +-
 drivers/media/video/ivtv/ivtv-fileops.c  |   23 +--
 drivers/media/video/ivtv/ivtv-firmware.c |    6 +-
 drivers/media/video/ivtv/ivtv-ioctl.c    |   31 ++--
 drivers/media/video/ivtv/ivtv-streams.c  |   20 ++-
 8 files changed, 86 insertions(+), 298 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-controls.c b/drivers/media/video/ivtv/ivtv-controls.c
index 4a9c8ce..57f74c2 100644
--- a/drivers/media/video/ivtv/ivtv-controls.c
+++ b/drivers/media/video/ivtv/ivtv-controls.c
@@ -17,162 +17,14 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <linux/kernel.h>
 
 #include "ivtv-driver.h"
-#include "ivtv-cards.h"
 #include "ivtv-ioctl.h"
-#include "ivtv-routing.h"
-#include "ivtv-i2c.h"
-#include "ivtv-mailbox.h"
 #include "ivtv-controls.h"
 
-/* Must be sorted from low to high control ID! */
-static const u32 user_ctrls[] = {
-	V4L2_CID_USER_CLASS,
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-	V4L2_CID_AUDIO_BALANCE,
-	V4L2_CID_AUDIO_BASS,
-	V4L2_CID_AUDIO_TREBLE,
-	V4L2_CID_AUDIO_MUTE,
-	V4L2_CID_AUDIO_LOUDNESS,
-	0
-};
-
-static const u32 *ctrl_classes[] = {
-	user_ctrls,
-	cx2341x_mpeg_ctrls,
-	NULL
-};
-
-
-int ivtv_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *qctrl)
-{
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
-	const char *name;
-
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (qctrl->id == 0)
-		return -EINVAL;
-
-	switch (qctrl->id) {
-	/* Standard V4L2 controls */
-	case V4L2_CID_USER_CLASS:
-		return v4l2_ctrl_query_fill(qctrl, 0, 0, 0, 0);
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		if (v4l2_subdev_call(itv->sd_video, core, queryctrl, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		if (v4l2_subdev_call(itv->sd_audio, core, queryctrl, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-
-	default:
-		if (cx2341x_ctrl_query(&itv->params, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-	}
-	strncpy(qctrl->name, name, sizeof(qctrl->name) - 1);
-	qctrl->name[sizeof(qctrl->name) - 1] = 0;
-	return 0;
-}
-
-int ivtv_querymenu(struct file *file, void *fh, struct v4l2_querymenu *qmenu)
-{
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
-	struct v4l2_queryctrl qctrl;
-
-	qctrl.id = qmenu->id;
-	ivtv_queryctrl(file, fh, &qctrl);
-	return v4l2_ctrl_query_menu(qmenu, &qctrl,
-			cx2341x_ctrl_get_menu(&itv->params, qmenu->id));
-}
-
-static int ivtv_try_ctrl(struct file *file, void *fh,
-					struct v4l2_ext_control *vctrl)
-{
-	struct v4l2_queryctrl qctrl;
-	const char **menu_items = NULL;
-	int err;
-
-	qctrl.id = vctrl->id;
-	err = ivtv_queryctrl(file, fh, &qctrl);
-	if (err)
-		return err;
-	if (qctrl.type == V4L2_CTRL_TYPE_MENU)
-		menu_items = v4l2_ctrl_get_menu(qctrl.id);
-	return v4l2_ctrl_check(vctrl, &qctrl, menu_items);
-}
-
-static int ivtv_s_ctrl(struct ivtv *itv, struct v4l2_control *vctrl)
-{
-	switch (vctrl->id) {
-		/* Standard V4L2 controls */
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		return v4l2_subdev_call(itv->sd_video, core, s_ctrl, vctrl);
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		return v4l2_subdev_call(itv->sd_audio, core, s_ctrl, vctrl);
-
-	default:
-		IVTV_DEBUG_IOCTL("invalid control 0x%x\n", vctrl->id);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int ivtv_g_ctrl(struct ivtv *itv, struct v4l2_control *vctrl)
+static int ivtv_s_stream_vbi_fmt(struct cx2341x_handler *cxhdl, u32 fmt)
 {
-	switch (vctrl->id) {
-		/* Standard V4L2 controls */
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		return v4l2_subdev_call(itv->sd_video, core, g_ctrl, vctrl);
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		return v4l2_subdev_call(itv->sd_audio, core, g_ctrl, vctrl);
-	default:
-		IVTV_DEBUG_IOCTL("invalid control 0x%x\n", vctrl->id);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int ivtv_setup_vbi_fmt(struct ivtv *itv, enum v4l2_mpeg_stream_vbi_fmt fmt)
-{
-	if (!(itv->v4l2_cap & V4L2_CAP_SLICED_VBI_CAPTURE))
-		return -EINVAL;
-	if (atomic_read(&itv->capturing) > 0)
-		return -EBUSY;
+	struct ivtv *itv = container_of(cxhdl, struct ivtv, cxhdl);
 
 	/* First try to allocate sliced VBI buffers if needed. */
 	if (fmt && itv->vbi.sliced_mpeg_data[0] == NULL) {
@@ -207,106 +59,43 @@ static int ivtv_setup_vbi_fmt(struct ivtv *itv, enum v4l2_mpeg_stream_vbi_fmt fm
 	return 0;
 }
 
-int ivtv_g_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int ivtv_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 {
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
-	struct v4l2_control ctrl;
-
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			ctrl.id = c->controls[i].id;
-			ctrl.value = c->controls[i].value;
-			err = ivtv_g_ctrl(itv, &ctrl);
-			c->controls[i].value = ctrl.value;
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG)
-		return cx2341x_ext_ctrls(&itv->params, 0, c, VIDIOC_G_EXT_CTRLS);
-	return -EINVAL;
+	struct ivtv *itv = container_of(cxhdl, struct ivtv, cxhdl);
+	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
+	struct v4l2_format fmt;
+
+	/* fix videodecoder resolution */
+	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.fmt.pix.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	fmt.fmt.pix.height = cxhdl->height;
+	v4l2_subdev_call(itv->sd_video, video, s_fmt, &fmt);
+	return 0;
 }
 
-int ivtv_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int ivtv_s_audio_sampling_freq(struct cx2341x_handler *cxhdl, u32 idx)
 {
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
-	struct v4l2_control ctrl;
-
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			ctrl.id = c->controls[i].id;
-			ctrl.value = c->controls[i].value;
-			err = ivtv_s_ctrl(itv, &ctrl);
-			c->controls[i].value = ctrl.value;
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		static u32 freqs[3] = { 44100, 48000, 32000 };
-		struct cx2341x_mpeg_params p = itv->params;
-		int err = cx2341x_ext_ctrls(&p, atomic_read(&itv->capturing), c, VIDIOC_S_EXT_CTRLS);
-		unsigned idx;
-
-		if (err)
-			return err;
+	static const u32 freqs[3] = { 44100, 48000, 32000 };
+	struct ivtv *itv = container_of(cxhdl, struct ivtv, cxhdl);
 
-		if (p.video_encoding != itv->params.video_encoding) {
-			int is_mpeg1 = p.video_encoding ==
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-			struct v4l2_format fmt;
-
-			/* fix videodecoder resolution */
-			fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-			fmt.fmt.pix.width = itv->params.width / (is_mpeg1 ? 2 : 1);
-			fmt.fmt.pix.height = itv->params.height;
-			v4l2_subdev_call(itv->sd_video, video, s_fmt, &fmt);
-		}
-		err = cx2341x_update(itv, ivtv_api_func, &itv->params, &p);
-		if (!err && itv->params.stream_vbi_fmt != p.stream_vbi_fmt)
-			err = ivtv_setup_vbi_fmt(itv, p.stream_vbi_fmt);
-		itv->params = p;
-		itv->dualwatch_stereo_mode = p.audio_properties & 0x0300;
-		idx = p.audio_properties & 0x03;
-		/* The audio clock of the digitizer must match the codec sample
-		   rate otherwise you get some very strange effects. */
-		if (idx < ARRAY_SIZE(freqs))
-			ivtv_call_all(itv, audio, s_clock_freq, freqs[idx]);
-		return err;
-	}
-	return -EINVAL;
+	/* The audio clock of the digitizer must match the codec sample
+	   rate otherwise you get some very strange effects. */
+	if (idx < ARRAY_SIZE(freqs))
+		ivtv_call_all(itv, audio, s_clock_freq, freqs[idx]);
+	return 0;
 }
 
-int ivtv_try_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int ivtv_s_audio_mode(struct cx2341x_handler *cxhdl, u32 val)
 {
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
+	struct ivtv *itv = container_of(cxhdl, struct ivtv, cxhdl);
 
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			err = ivtv_try_ctrl(file, fh, &c->controls[i]);
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG)
-		return cx2341x_ext_ctrls(&itv->params, atomic_read(&itv->capturing), c, VIDIOC_TRY_EXT_CTRLS);
-	return -EINVAL;
+	itv->dualwatch_stereo_mode = val;
+	return 0;
 }
+
+struct cx2341x_handler_ops ivtv_cxhdl_ops = {
+	.s_audio_mode = ivtv_s_audio_mode,
+	.s_audio_sampling_freq = ivtv_s_audio_sampling_freq,
+	.s_video_encoding = ivtv_s_video_encoding,
+	.s_stream_vbi_fmt = ivtv_s_stream_vbi_fmt,
+};
diff --git a/drivers/media/video/ivtv/ivtv-controls.h b/drivers/media/video/ivtv/ivtv-controls.h
index 1c7721e..d12893d 100644
--- a/drivers/media/video/ivtv/ivtv-controls.h
+++ b/drivers/media/video/ivtv/ivtv-controls.h
@@ -21,10 +21,6 @@
 #ifndef IVTV_CONTROLS_H
 #define IVTV_CONTROLS_H
 
-int ivtv_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *a);
-int ivtv_g_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *a);
-int ivtv_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *a);
-int ivtv_try_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *a);
-int ivtv_querymenu(struct file *file, void *fh, struct v4l2_querymenu *a);
+extern struct cx2341x_handler_ops ivtv_cxhdl_ops;
 
 #endif
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 1232d92..54f25f3 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -53,6 +53,7 @@
 #include "ivtv-cards.h"
 #include "ivtv-vbi.h"
 #include "ivtv-routing.h"
+#include "ivtv-controls.h"
 #include "ivtv-gpio.h"
 
 #include <media/tveeprom.h>
@@ -718,9 +719,8 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
 	itv->open_id = 1;
 
 	/* Initial settings */
-	cx2341x_fill_defaults(&itv->params);
-	itv->params.port = CX2341X_PORT_MEMORY;
-	itv->params.capabilities = CX2341X_CAP_HAS_SLICED_VBI;
+	itv->cxhdl.port = CX2341X_PORT_MEMORY;
+	itv->cxhdl.capabilities = CX2341X_CAP_HAS_SLICED_VBI;
 	init_waitqueue_head(&itv->eos_waitq);
 	init_waitqueue_head(&itv->event_waitq);
 	init_waitqueue_head(&itv->vsync_waitq);
@@ -990,6 +990,13 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 		retval = -ENOMEM;
 		goto err;
 	}
+	retval = cx2341x_handler_init(&itv->cxhdl, 50);
+	if (retval)
+		goto err;
+	itv->v4l2_dev.ctrl_handler = &itv->cxhdl.hdl;
+	itv->cxhdl.ops = &ivtv_cxhdl_ops;
+	itv->cxhdl.priv = itv;
+	itv->cxhdl.func = ivtv_api_func;
 
 	IVTV_DEBUG_INFO("base addr: 0x%08x\n", itv->base_addr);
 
@@ -1111,7 +1118,7 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 	itv->yuv_info.v4l2_src_w = itv->yuv_info.osd_full_w;
 	itv->yuv_info.v4l2_src_h = itv->yuv_info.osd_full_h;
 
-	itv->params.video_gop_size = itv->is_60hz ? 15 : 12;
+	cx2341x_handler_set_50hz(&itv->cxhdl, itv->is_50hz);
 
 	itv->stream_buf_size[IVTV_ENC_STREAM_TYPE_MPG] = 0x08000;
 	itv->stream_buf_size[IVTV_ENC_STREAM_TYPE_PCM] = 0x01200;
@@ -1306,6 +1313,8 @@ int ivtv_init_on_first_open(struct ivtv *itv)
 	/* For cards with video out, this call needs interrupts enabled */
 	ivtv_s_std(NULL, &fh, &itv->tuner_std);
 
+	/* Setup initial controls */
+	cx2341x_handler_setup(&itv->cxhdl);
 	return 0;
 }
 
@@ -1370,7 +1379,6 @@ static void ivtv_remove(struct pci_dev *pdev)
 	printk(KERN_INFO "ivtv: Removed %s\n", itv->card_name);
 
 	v4l2_device_unregister(&itv->v4l2_dev);
-	v4l2_ctrl_handler_free(&itv->hdl_gpio);
 	kfree(itv);
 }
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index ba6c2fc..2fdbac6 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -61,6 +61,7 @@
 #include <linux/dvb/audio.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/tuner.h>
@@ -628,8 +629,9 @@ struct ivtv {
 	struct ivtv_options options; 	/* user options */
 
 	struct v4l2_device v4l2_dev;
-	struct v4l2_subdev sd_gpio;	/* GPIO sub-device */
+	struct cx2341x_handler cxhdl;
 	struct v4l2_ctrl_handler hdl_gpio;
+	struct v4l2_subdev sd_gpio;	/* GPIO sub-device */
 	u16 instance;
 
 	/* High-level state info */
@@ -646,7 +648,6 @@ struct ivtv {
 	v4l2_std_id std_out;            /* current TV output standard */
 	u8 audio_stereo_mode;           /* decoder setting how to handle stereo MPEG audio */
 	u8 audio_bilingual_mode;        /* decoder setting how to handle bilingual MPEG audio */
-	struct cx2341x_mpeg_params params;              /* current encoder parameters */
 
 
 	/* Locking */
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index abf4109..553b0de 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -149,12 +149,10 @@ void ivtv_release_stream(struct ivtv_stream *s)
 static void ivtv_dualwatch(struct ivtv *itv)
 {
 	struct v4l2_tuner vt;
-	u32 new_bitmap;
 	u32 new_stereo_mode;
-	const u32 stereo_mask = 0x0300;
-	const u32 dual = 0x0200;
+	const u32 dual = 0x02;
 
-	new_stereo_mode = itv->params.audio_properties & stereo_mask;
+	new_stereo_mode = v4l2_ctrl_g_ctrl(itv->cxhdl.audio_mode);
 	memset(&vt, 0, sizeof(vt));
 	ivtv_call_all(itv, tuner, g_tuner, &vt);
 	if (vt.audmode == V4L2_TUNER_MODE_LANG1_LANG2 && (vt.rxsubchans & V4L2_TUNER_SUB_LANG2))
@@ -163,16 +161,10 @@ static void ivtv_dualwatch(struct ivtv *itv)
 	if (new_stereo_mode == itv->dualwatch_stereo_mode)
 		return;
 
-	new_bitmap = new_stereo_mode | (itv->params.audio_properties & ~stereo_mask);
-
-	IVTV_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x. new audio_bitmask=0x%ux\n",
-			   itv->dualwatch_stereo_mode, new_stereo_mode, new_bitmap);
-
-	if (ivtv_vapi(itv, CX2341X_ENC_SET_AUDIO_PROPERTIES, 1, new_bitmap) == 0) {
-		itv->dualwatch_stereo_mode = new_stereo_mode;
-		return;
-	}
-	IVTV_DEBUG_INFO("dualwatch: changing stereo flag failed\n");
+	IVTV_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x.\n",
+			   itv->dualwatch_stereo_mode, new_stereo_mode);
+	if (v4l2_ctrl_s_ctrl(itv->cxhdl.audio_mode, new_stereo_mode))
+		IVTV_DEBUG_INFO("dualwatch: changing stereo flag failed\n");
 }
 
 static void ivtv_update_pgm_info(struct ivtv *itv)
@@ -883,7 +875,8 @@ int ivtv_v4l2_close(struct file *filp)
 		if (atomic_read(&itv->capturing) > 0) {
 			/* Undo video mute */
 			ivtv_vapi(itv, CX2341X_ENC_MUTE_VIDEO, 1,
-				itv->params.video_mute | (itv->params.video_mute_yuv << 8));
+				v4l2_ctrl_g_ctrl(itv->cxhdl.video_mute) |
+				(v4l2_ctrl_g_ctrl(itv->cxhdl.video_mute_yuv) << 8));
 		}
 		/* Done! Unmute and continue. */
 		ivtv_unmute(itv);
diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
index a71e8ba..11ca89a 100644
--- a/drivers/media/video/ivtv/ivtv-firmware.c
+++ b/drivers/media/video/ivtv/ivtv-firmware.c
@@ -245,9 +245,9 @@ void ivtv_init_mpeg_decoder(struct ivtv *itv)
 	volatile u8 __iomem *mem_offset;
 
 	data[0] = 0;
-	data[1] = itv->params.width;	/* YUV source width */
-	data[2] = itv->params.height;
-	data[3] = itv->params.audio_properties;	/* Audio settings to use,
+	data[1] = itv->cxhdl.width;	/* YUV source width */
+	data[2] = itv->cxhdl.height;
+	data[3] = itv->cxhdl.audio_properties;	/* Audio settings to use,
 							   bitmap. see docs. */
 	if (ivtv_api(itv, CX2341X_DEC_SET_DECODER_SOURCE, 4, data)) {
 		IVTV_ERR("ivtv_init_mpeg_decoder failed to set decoder source\n");
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index fa9f0d9..a24cfac 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -162,7 +162,7 @@ int ivtv_set_speed(struct ivtv *itv, int speed)
 	data[0] |= (speed > 1000 || speed < -1500) ? 0x40000000 : 0;
 	data[1] = (speed < 0);
 	data[2] = speed < 0 ? 3 : 7;
-	data[3] = itv->params.video_b_frames;
+	data[3] = v4l2_ctrl_g_ctrl(itv->cxhdl.video_b_frames);
 	data[4] = (speed == 1500 || speed == 500) ? itv->speed_mute_audio : 0;
 	data[5] = 0;
 	data[6] = 0;
@@ -339,8 +339,8 @@ static int ivtv_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	struct ivtv *itv = id->itv;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
-	pixfmt->width = itv->params.width;
-	pixfmt->height = itv->params.height;
+	pixfmt->width = itv->cxhdl.width;
+	pixfmt->height = itv->cxhdl.height;
 	pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pixfmt->field = V4L2_FIELD_INTERLACED;
 	pixfmt->priv = 0;
@@ -568,7 +568,6 @@ static int ivtv_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 {
 	struct ivtv_open_id *id = fh;
 	struct ivtv *itv = id->itv;
-	struct cx2341x_mpeg_params *p = &itv->params;
 	int ret = ivtv_try_fmt_vid_cap(file, fh, fmt);
 	int w = fmt->fmt.pix.width;
 	int h = fmt->fmt.pix.height;
@@ -576,15 +575,15 @@ static int ivtv_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	if (ret)
 		return ret;
 
-	if (p->width == w && p->height == h)
+	if (itv->cxhdl.width == w && itv->cxhdl.height == h)
 		return 0;
 
 	if (atomic_read(&itv->capturing) > 0)
 		return -EBUSY;
 
-	p->width = w;
-	p->height = h;
-	if (p->video_encoding == V4L2_MPEG_VIDEO_ENCODING_MPEG_1)
+	itv->cxhdl.width = w;
+	itv->cxhdl.height = h;
+	if (v4l2_ctrl_g_ctrl(itv->cxhdl.video_encoding) == V4L2_MPEG_VIDEO_ENCODING_MPEG_1)
 		fmt->fmt.pix.width /= 2;
 	v4l2_subdev_call(itv->sd_video, video, s_fmt, fmt);
 	return ivtv_g_fmt_vid_cap(file, fh, fmt);
@@ -1110,9 +1109,10 @@ int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
 
 	itv->std = *std;
 	itv->is_60hz = (*std & V4L2_STD_525_60) ? 1 : 0;
-	itv->params.is_50hz = itv->is_50hz = !itv->is_60hz;
-	itv->params.width = 720;
-	itv->params.height = itv->is_50hz ? 576 : 480;
+	itv->is_50hz = !itv->is_60hz;
+	cx2341x_handler_set_50hz(&itv->cxhdl, itv->is_50hz);
+	itv->cxhdl.width = 720;
+	itv->cxhdl.height = itv->is_50hz ? 576 : 480;
 	itv->vbi.count = itv->is_50hz ? 18 : 12;
 	itv->vbi.start[0] = itv->is_50hz ? 6 : 10;
 	itv->vbi.start[1] = itv->is_50hz ? 318 : 273;
@@ -1153,7 +1153,7 @@ int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
 		ivtv_vapi(itv, CX2341X_DEC_SET_STANDARD, 1, itv->is_out_50hz);
 		itv->main_rect.left = itv->main_rect.top = 0;
 		itv->main_rect.width = 720;
-		itv->main_rect.height = itv->params.height;
+		itv->main_rect.height = itv->cxhdl.height;
 		ivtv_vapi(itv, CX2341X_OSD_SET_FRAMEBUFFER_WINDOW, 4,
 			720, itv->main_rect.height, 0, 0);
 		yi->main_rect = itv->main_rect;
@@ -1550,7 +1550,7 @@ static int ivtv_log_status(struct file *file, void *fh)
 	}
 	IVTV_INFO("Tuner:  %s\n",
 		test_bit(IVTV_F_I_RADIO_USER, &itv->i_flags) ? "Radio" : "TV");
-	cx2341x_log_status(&itv->params, itv->v4l2_dev.name);
+	v4l2_ctrl_handler_log_status(&itv->cxhdl.hdl, itv->v4l2_dev.name);
 	IVTV_INFO("Status flags:    0x%08lx\n", itv->i_flags);
 	for (i = 0; i < IVTV_MAX_STREAMS; i++) {
 		struct ivtv_stream *s = &itv->streams[i];
@@ -1938,11 +1938,6 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_s_register 		    = ivtv_s_register,
 #endif
 	.vidioc_default 		    = ivtv_default,
-	.vidioc_queryctrl 		    = ivtv_queryctrl,
-	.vidioc_querymenu 		    = ivtv_querymenu,
-	.vidioc_g_ext_ctrls 		    = ivtv_g_ext_ctrls,
-	.vidioc_s_ext_ctrls 		    = ivtv_s_ext_ctrls,
-	.vidioc_try_ext_ctrls    	    = ivtv_try_ext_ctrls,
 	.vidioc_subscribe_event 	    = ivtv_subscribe_event,
 	.vidioc_unsubscribe_event 	    = v4l2_event_unsubscribe,
 };
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index de4288c..52a9585 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -209,6 +209,7 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 
 	s->vdev->num = num;
 	s->vdev->v4l2_dev = &itv->v4l2_dev;
+	s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
 	s->vdev->fops = ivtv_stream_info[type].fops;
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
@@ -450,7 +451,6 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 {
 	u32 data[CX2341X_MBOX_MAX_DATA];
 	struct ivtv *itv = s->itv;
-	struct cx2341x_mpeg_params *p = &itv->params;
 	int captype = 0, subtype = 0;
 	int enable_passthrough = 0;
 
@@ -471,7 +471,7 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 		}
 		itv->mpg_data_received = itv->vbi_data_inserted = 0;
 		itv->dualwatch_jiffies = jiffies;
-		itv->dualwatch_stereo_mode = p->audio_properties & 0x0300;
+		itv->dualwatch_stereo_mode = v4l2_ctrl_g_ctrl(itv->cxhdl.audio_mode);
 		itv->search_pack_header = 0;
 		break;
 
@@ -559,12 +559,12 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 				itv->pgm_info_offset, itv->pgm_info_num);
 
 		/* Setup API for Stream */
-		cx2341x_update(itv, ivtv_api_func, NULL, p);
+		cx2341x_handler_setup(&itv->cxhdl);
 
 		/* mute if capturing radio */
 		if (test_bit(IVTV_F_I_RADIO_USER, &itv->i_flags))
 			ivtv_vapi(itv, CX2341X_ENC_MUTE_VIDEO, 1,
-				1 | (p->video_mute_yuv << 8));
+				1 | (v4l2_ctrl_g_ctrl(itv->cxhdl.video_mute_yuv) << 8));
 	}
 
 	/* Vsync Setup */
@@ -580,6 +580,8 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 
 		clear_bit(IVTV_F_I_EOS, &itv->i_flags);
 
+		cx2341x_handler_set_busy(&itv->cxhdl, 1);
+
 		/* Initialize Digitizer for Capture */
 		/* Avoid tinny audio problem - ensure audio clocks are going */
 		v4l2_subdev_call(itv->sd_audio, audio, s_stream, 1);
@@ -616,7 +618,6 @@ static int ivtv_setup_v4l2_decode_stream(struct ivtv_stream *s)
 {
 	u32 data[CX2341X_MBOX_MAX_DATA];
 	struct ivtv *itv = s->itv;
-	struct cx2341x_mpeg_params *p = &itv->params;
 	int datatype;
 
 	if (s->vdev == NULL)
@@ -655,7 +656,7 @@ static int ivtv_setup_v4l2_decode_stream(struct ivtv_stream *s)
 		break;
 	}
 	if (ivtv_vapi(itv, CX2341X_DEC_SET_DECODER_SOURCE, 4, datatype,
-			p->width, p->height, p->audio_properties)) {
+			itv->cxhdl.width, itv->cxhdl.height, itv->cxhdl.audio_properties)) {
 		IVTV_DEBUG_WARN("Couldn't initialize decoder source\n");
 	}
 	return 0;
@@ -821,6 +822,8 @@ int ivtv_stop_v4l2_encode_stream(struct ivtv_stream *s, int gop_end)
 		return 0;
 	}
 
+	cx2341x_handler_set_busy(&itv->cxhdl, 0);
+
 	/* Set the following Interrupt mask bits for capture */
 	ivtv_set_irq_mask(itv, IVTV_IRQ_MASK_CAPTURE);
 	del_timer(&itv->dma_timer);
@@ -938,7 +941,8 @@ int ivtv_passthrough_mode(struct ivtv *itv, int enable)
 
 		/* Setup capture if not already done */
 		if (atomic_read(&itv->capturing) == 0) {
-			cx2341x_update(itv, ivtv_api_func, NULL, &itv->params);
+			cx2341x_handler_setup(&itv->cxhdl);
+			cx2341x_handler_set_busy(&itv->cxhdl, 1);
 		}
 
 		/* Start Passthrough Mode */
@@ -959,6 +963,8 @@ int ivtv_passthrough_mode(struct ivtv *itv, int enable)
 	clear_bit(IVTV_F_S_PASSTHROUGH, &dec_stream->s_flags);
 	clear_bit(IVTV_F_S_STREAMING, &dec_stream->s_flags);
 	itv->output_mode = OUT_NONE;
+	if (atomic_read(&itv->capturing) == 0)
+		cx2341x_handler_set_busy(&itv->cxhdl, 0);
 
 	return 0;
 }
-- 
1.6.4.2

