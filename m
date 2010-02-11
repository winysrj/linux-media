Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:64548 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0BKGyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 01:54:01 -0500
Received: by pzk2 with SMTP id 2so198285pzk.21
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 22:54:00 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, zyziii@telegent.com,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 1/2] remove the country code for analog tv and radio
Date: Thu, 11 Feb 2010 14:53:51 +0800
Message-Id: <1265871232-2144-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video :
	use the V4L2_STD macros to select the proper audio setting.

radio :
	add preemphasis ctr.
	test it by the command:
	v4l2-ctl -d /dev/radio0 --set-ctrl=pre_emphasis_settings=1

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/tlg2300/pd-common.h |    4 +-
 drivers/media/video/tlg2300/pd-main.c   |   36 ----------
 drivers/media/video/tlg2300/pd-radio.c  |  107 +++++++++++++++++++++++++------
 drivers/media/video/tlg2300/pd-video.c  |   59 +++++++++++------
 4 files changed, 128 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
index 619fd00..ae9cb6c 100644
--- a/drivers/media/video/tlg2300/pd-common.h
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -118,6 +118,7 @@ struct radio_data {
 	__u32		fm_freq;
 	int		users;
 	unsigned int	is_radio_streaming;
+	int		pre_emphasis;
 	struct video_device *fm_dev;
 };
 
@@ -185,7 +186,6 @@ struct poseidon {
 	struct pd_dvb_adapter	dvb_data;	/* DVB	 */
 
 	u32			state;
-	int			country_code;
 	struct file		*file_for_stream; /* the active stream*/
 
 #ifdef CONFIG_PM
@@ -240,7 +240,6 @@ struct video_device *vdev_init(struct poseidon *, struct video_device *);
 int send_set_req(struct poseidon*, u8, s32, s32*);
 int send_get_req(struct poseidon*, u8, s32, void*, s32*, s32);
 s32 set_tuner_mode(struct poseidon*, unsigned char);
-enum tlg__analog_audio_standard get_audio_std(s32, s32);
 
 /* bulk urb alloc/free */
 int alloc_bulk_urbs_generic(struct urb **urb_array, int num,
@@ -252,7 +251,6 @@ void free_all_urb_generic(struct urb **urb_array, int num);
 /* misc */
 void poseidon_delete(struct kref *kref);
 void destroy_video_device(struct video_device **v_dev);
-extern int country_code;
 extern int debug_mode;
 void set_debug_mode(struct video_device *vfd, int debug_mode);
 
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 6df9380..fdcc500 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -189,41 +189,6 @@ int set_tuner_mode(struct poseidon *pd, unsigned char mode)
 	return 0;
 }
 
-enum tlg__analog_audio_standard get_audio_std(s32 mode, s32 country_code)
-{
-	s32 nicam[] = {27, 32, 33, 34, 36, 44, 45, 46, 47, 48, 64,
-			65, 86, 351, 352, 353, 354, 358, 372, 852, 972};
-	s32 btsc[] = {1, 52, 54, 55, 886};
-	s32 eiaj[] = {81};
-	s32 i;
-
-	if (mode == TLG_MODE_FM_RADIO) {
-		if (country_code == 1)
-			return TLG_TUNE_ASTD_FM_US;
-		else
-			return TLG_TUNE_ASTD_FM_EUR;
-	} else if (mode == TLG_MODE_ANALOG_TV_UNCOMP) {
-		for (i = 0; i < sizeof(nicam) / sizeof(s32); i++) {
-			if (country_code == nicam[i])
-				return TLG_TUNE_ASTD_NICAM;
-		}
-
-		for (i = 0; i < sizeof(btsc) / sizeof(s32); i++) {
-			if (country_code == btsc[i])
-				return TLG_TUNE_ASTD_BTSC;
-		}
-
-		for (i = 0; i < sizeof(eiaj) / sizeof(s32); i++) {
-			if (country_code == eiaj[i])
-				return TLG_TUNE_ASTD_EIAJ;
-		}
-
-		return TLG_TUNE_ASTD_A2;
-	} else {
-		return TLG_TUNE_ASTD_NONE;
-	}
-}
-
 void poseidon_delete(struct kref *kref)
 {
 	struct poseidon *pd = container_of(kref, struct poseidon, kref);
@@ -462,7 +427,6 @@ static int poseidon_probe(struct usb_interface *interface,
 		struct device *dev = &interface->dev;
 
 		logpm(pd);
-		pd->country_code = 86;
 		mutex_init(&pd->lock);
 
 		/* register v4l2 device */
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
index bdbb0c1..755766b 100644
--- a/drivers/media/video/tlg2300/pd-radio.c
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -22,9 +22,16 @@ static int poseidon_fm_open(struct file *filp);
 #define TUNER_FREQ_MIN_FM 76000000
 #define TUNER_FREQ_MAX_FM 108000000
 
+#define MAX_PREEMPHASIS (V4L2_PREEMPHASIS_75_uS + 1)
+static int preemphasis[MAX_PREEMPHASIS] = {
+	TLG_TUNE_ASTD_NONE,   /* V4L2_PREEMPHASIS_DISABLED */
+	TLG_TUNE_ASTD_FM_EUR, /* V4L2_PREEMPHASIS_50_uS    */
+	TLG_TUNE_ASTD_FM_US,  /* V4L2_PREEMPHASIS_75_uS    */
+};
+
 static int poseidon_check_mode_radio(struct poseidon *p)
 {
-	int ret, radiomode;
+	int ret;
 	u32 status;
 
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -38,8 +45,8 @@ static int poseidon_check_mode_radio(struct poseidon *p)
 		goto out;
 
 	ret = send_set_req(p, SGNL_SRC_SEL, TLG_SIG_SRC_ANTENNA, &status);
-	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
-	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
+	ret = send_set_req(p, TUNER_AUD_ANA_STD,
+				p->radio_data.pre_emphasis, &status);
 	ret |= send_set_req(p, TUNER_AUD_MODE,
 				TLG_TUNE_TVAUDIO_MODE_STEREO, &status);
 	ret |= send_set_req(p, AUDIO_SAMPLE_RATE_SEL,
@@ -91,7 +98,9 @@ static int poseidon_fm_open(struct file *filp)
 
 	usb_autopm_get_interface(p->interface);
 	if (0 == p->state) {
-		p->country_code = country_code;
+		/* default pre-emphasis */
+		if (p->radio_data.pre_emphasis == 0)
+			p->radio_data.pre_emphasis = TLG_TUNE_ASTD_FM_EUR;
 		set_debug_mode(vfd, debug_mode);
 
 		ret = poseidon_check_mode_radio(p);
@@ -205,13 +214,12 @@ int fm_get_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
 static int set_frequency(struct poseidon *p, __u32 frequency)
 {
 	__u32 freq ;
-	int ret, status, radiomode;
+	int ret, status;
 
 	mutex_lock(&p->lock);
 
-	radiomode = get_audio_std(TLG_MODE_FM_RADIO, p->country_code);
-	/*NTSC 8,PAL 2 */
-	ret = send_set_req(p, TUNER_AUD_ANA_STD, radiomode, &status);
+	ret = send_set_req(p, TUNER_AUD_ANA_STD,
+				p->radio_data.pre_emphasis, &status);
 
 	freq =  (frequency * 125) * 500 / 1000;/* kHZ */
 	if (freq < TUNER_FREQ_MIN_FM/1000 || freq > TUNER_FREQ_MAX_FM/1000) {
@@ -253,27 +261,86 @@ int fm_set_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
 int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
 		struct v4l2_control *arg)
 {
-    return 0;
+	return 0;
+}
+
+int tlg_fm_vidioc_g_exts_ctrl(struct file *file, void *fh,
+				struct v4l2_ext_controls *ctrls)
+{
+	struct poseidon *p = file->private_data;
+	int i;
+
+	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
+		return -EINVAL;
+
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
+
+		if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS)
+			continue;
+
+		if (i < MAX_PREEMPHASIS)
+			ctrl->value = p->radio_data.pre_emphasis;
+	}
+	return 0;
 }
 
-int tlg_fm_vidioc_exts_ctrl(struct file *file, void *fh,
-		struct v4l2_ext_controls *a)
+int tlg_fm_vidioc_s_exts_ctrl(struct file *file, void *fh,
+			struct v4l2_ext_controls *ctrls)
 {
-    return 0;
+	int i;
+
+	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
+		return -EINVAL;
+
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
+
+		if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS)
+			continue;
+
+		if (ctrl->value >= 0 && ctrl->value < MAX_PREEMPHASIS) {
+			struct poseidon *p = file->private_data;
+			int pre_emphasis = preemphasis[ctrl->value];
+			u32 status;
+
+			send_set_req(p, TUNER_AUD_ANA_STD,
+						pre_emphasis, &status);
+			p->radio_data.pre_emphasis = pre_emphasis;
+		}
+	}
+	return 0;
 }
 
 int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
-		struct v4l2_control *arg)
+		struct v4l2_control *ctrl)
 {
-    return 0;
+	return 0;
 }
 
 int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
-		struct v4l2_queryctrl *arg)
+		struct v4l2_queryctrl *ctrl)
 {
-	arg->minimum = 0;
-	arg->maximum = 65535;
-	return 0;
+	if (!(ctrl->id & V4L2_CTRL_FLAG_NEXT_CTRL))
+		return -EINVAL;
+
+	ctrl->id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+	if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS) {
+		/* return the next supported control */
+		ctrl->id = V4L2_CID_TUNE_PREEMPHASIS;
+		v4l2_ctrl_query_fill(ctrl, V4L2_PREEMPHASIS_DISABLED,
+					V4L2_PREEMPHASIS_75_uS, 1,
+					V4L2_PREEMPHASIS_50_uS);
+		ctrl->flags = V4L2_CTRL_FLAG_UPDATE;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+int tlg_fm_vidioc_querymenu(struct file *file, void *fh,
+				struct v4l2_querymenu *qmenu)
+{
+	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
@@ -311,9 +378,11 @@ static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
 	.vidioc_g_input     = vidioc_g_input,
 	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
+	.vidioc_querymenu   = tlg_fm_vidioc_querymenu,
 	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
 	.vidioc_s_ctrl      = tlg_fm_vidioc_s_ctrl,
-	.vidioc_s_ext_ctrls = tlg_fm_vidioc_exts_ctrl,
+	.vidioc_s_ext_ctrls = tlg_fm_vidioc_s_exts_ctrl,
+	.vidioc_g_ext_ctrls = tlg_fm_vidioc_g_exts_ctrl,
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_tuner     = tlg_fm_vidioc_g_tuner,
 	.vidioc_g_frequency = fm_get_freq,
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index 5f0300a..becfba6 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -15,10 +15,6 @@ static int pm_video_suspend(struct poseidon *pd);
 static int pm_video_resume(struct poseidon *pd);
 static void iso_bubble_handler(struct work_struct *w);
 
-int country_code = 86;
-module_param(country_code, int, 0644);
-MODULE_PARM_DESC(country_code, "country code (e.g China is 86)");
-
 int usb_transfer_mode;
 module_param(usb_transfer_mode, int, 0644);
 MODULE_PARM_DESC(usb_transfer_mode, "0 = Bulk, 1 = Isochronous");
@@ -93,27 +89,53 @@ static struct poseidon_control controls[] = {
 		{ V4L2_CID_BRIGHTNESS, V4L2_CTRL_TYPE_INTEGER,
 			"brightness", 0, 10000, 1, 100, 0, },
 		CUST_PARM_ID_BRIGHTNESS_CTRL
-	},
-
-	{
+	}, {
 		{ V4L2_CID_CONTRAST, V4L2_CTRL_TYPE_INTEGER,
 			"contrast", 0, 10000, 1, 100, 0, },
 		CUST_PARM_ID_CONTRAST_CTRL,
-	},
-
-	{
+	}, {
 		{ V4L2_CID_HUE, V4L2_CTRL_TYPE_INTEGER,
 			"hue", 0, 10000, 1, 100, 0, },
 		CUST_PARM_ID_HUE_CTRL,
-	},
-
-	{
+	}, {
 		{ V4L2_CID_SATURATION, V4L2_CTRL_TYPE_INTEGER,
 			"saturation", 0, 10000, 1, 100, 0, },
 		CUST_PARM_ID_SATURATION_CTRL,
 	},
 };
 
+struct video_std_to_audio_std {
+	v4l2_std_id	video_std;
+	int 		audio_std;
+};
+
+static const struct video_std_to_audio_std video_to_audio_map[] = {
+	/* country : { 27, 32, 33, 34, 36, 44, 45, 46, 47, 48, 64,
+			65, 86, 351, 352, 353, 354, 358, 372, 852, 972 } */
+	{ (V4L2_STD_PAL_I | V4L2_STD_PAL_B | V4L2_STD_PAL_D |
+		V4L2_STD_SECAM_L | V4L2_STD_SECAM_D), TLG_TUNE_ASTD_NICAM },
+
+	/* country : { 1, 52, 54, 55, 886 } */
+	{V4L2_STD_NTSC_M | V4L2_STD_PAL_N | V4L2_STD_PAL_M, TLG_TUNE_ASTD_BTSC},
+
+	/* country : { 81 } */
+	{ V4L2_STD_NTSC_M_JP, TLG_TUNE_ASTD_EIAJ },
+
+	/* other country : TLG_TUNE_ASTD_A2 */
+};
+static const unsigned int map_size = ARRAY_SIZE(video_to_audio_map);
+
+static int get_audio_std(v4l2_std_id v4l2_std)
+{
+	int i = 0;
+
+	for (; i < map_size; i++) {
+		if (v4l2_std & video_to_audio_map[i].video_std)
+			return video_to_audio_map[i].audio_std;
+	}
+	return TLG_TUNE_ASTD_A2;
+}
+
 static int vidioc_querycap(struct file *file, void *fh,
 			struct v4l2_capability *cap)
 {
@@ -1067,7 +1089,7 @@ static int pd_vidioc_s_tuner(struct poseidon *pd, int index)
 	mutex_lock(&pd->lock);
 	param = pd_audio_modes[index].tlg_audio_mode;
 	ret = send_set_req(pd, TUNER_AUD_MODE, param, &cmd_status);
-	audiomode = get_audio_std(TLG_MODE_ANALOG_TV, pd->country_code);
+	audiomode = get_audio_std(pd->video_data.context.tvnormid);
 	ret |= send_set_req(pd, TUNER_AUD_ANA_STD, audiomode,
 				&cmd_status);
 	if (!ret)
@@ -1255,9 +1277,7 @@ static int vidioc_streamoff(struct file *file, void *fh,
 	return videobuf_streamoff(&front->q);
 }
 
-/*
- * Set the firmware' default values : need altersetting and country code
- */
+/* Set the firmware's default values : need altersetting */
 static int pd_video_checkmode(struct poseidon *pd)
 {
 	s32 ret = 0, cmd_status, audiomode;
@@ -1286,8 +1306,8 @@ static int pd_video_checkmode(struct poseidon *pd)
 	ret |= send_set_req(pd, TUNE_FREQ_SELECT, TUNER_FREQ_MIN, &cmd_status);
 	ret |= send_set_req(pd, VBI_DATA_SEL, 1, &cmd_status);/* enable vbi */
 
-	/* need country code to set the audio */
-	audiomode = get_audio_std(TLG_MODE_ANALOG_TV, pd->country_code);
+	/* set the audio */
+	audiomode = get_audio_std(pd->video_data.context.tvnormid);
 	ret |= send_set_req(pd, TUNER_AUD_ANA_STD, audiomode, &cmd_status);
 	ret |= send_set_req(pd, TUNER_AUD_MODE,
 				TLG_TUNE_TVAUDIO_MODE_STEREO, &cmd_status);
@@ -1392,7 +1412,6 @@ static int pd_video_open(struct file *file)
 			goto out;
 
 		pd->cur_transfer_mode	= usb_transfer_mode;/* bulk or iso */
-		pd->country_code	= country_code;
 		init_video_context(&pd->video_data.context);
 
 		ret = pd_video_checkmode(pd);
-- 
1.6.5.2

