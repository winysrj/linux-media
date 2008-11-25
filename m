Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPHnS7E002308
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 12:49:28 -0500
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPHnF9U025694
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 12:49:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Tue, 25 Nov 2008 18:49:10 +0100
References: <200811242309.37489.hverkuil@xs4all.nl>
	<200811250810.01767.hverkuil@xs4all.nl>
	<5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
In-Reply-To: <5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251849.10196.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 3/3)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


# HG changeset patch
# User Hans Verkuil <hverkuil@xs4all.nl>
# Date 1227561257 -3600
# Node ID d5c3c3f0b53c549b53d9596c9a7e827ec7521c57
# Parent 3a957c63323e35f5862259814b728d4c08584963
cx25840: convert to v4l2_subdev.

From: Hans Verkuil <hverkuil@xs4all.nl>

Priority: normal

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

--- a/linux/drivers/media/video/cx25840/cx25840-audio.c	Mon Nov 24 
22:12:55 2008 +0100
+++ b/linux/drivers/media/video/cx25840/cx25840-audio.c	Mon Nov 24 
22:14:17 2008 +0100
@@ -26,7 +26,7 @@
 
 static int set_audclk_freq(struct i2c_client *client, u32 freq)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 
 	if (freq != 32000 && freq != 44100 && freq != 48000)
 		return -EINVAL;
@@ -194,7 +194,7 @@ static int set_audclk_freq(struct i2c_cl
 
 void cx25840_audio_set_path(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 
 	/* assert soft reset */
 	cx25840_and_or(client, 0x810, ~0x1, 0x01);
@@ -236,7 +236,7 @@ void cx25840_audio_set_path(struct i2c_c
 
 static int get_volume(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	int vol;
 
 	if (state->unmute_volume >= 0)
@@ -253,7 +253,7 @@ static int get_volume(struct i2c_client 
 
 static void set_volume(struct i2c_client *client, int volume)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	int vol;
 
 	if (state->unmute_volume >= 0) {
@@ -341,14 +341,14 @@ static void set_balance(struct i2c_clien
 
 static int get_mute(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 
 	return state->unmute_volume >= 0;
 }
 
 static void set_mute(struct i2c_client *client, int mute)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 
 	if (mute && state->unmute_volume == -1) {
 		int vol = get_volume(client);
@@ -366,7 +366,7 @@ static void set_mute(struct i2c_client *
 
 int cx25840_audio(struct i2c_client *client, unsigned int cmd, void 
*arg)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	struct v4l2_control *ctrl = arg;
 	int retval;
 
--- a/linux/drivers/media/video/cx25840/cx25840-core.c	Mon Nov 24 
22:12:55 2008 +0100
+++ b/linux/drivers/media/video/cx25840/cx25840-core.c	Mon Nov 24 
22:14:17 2008 +0100
@@ -185,11 +185,11 @@ static void cx25836_initialize(struct i2
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 static void cx25840_work_handler(struct work_struct *work)
 {
-	struct cx25840_state *state = container_of(work, struct cx25840_state, 
fw_work);
+	struct subdev_state *state = container_of(work, struct subdev_state, 
fw_work);
 #else
 void cx25840_work_handler(void *arg)
 {
-	struct cx25840_state *state = arg;
+	struct subdev_state *state = arg;
 #endif
 	cx25840_loadfw(state->c);
 	wake_up(&state->fw_wait);
@@ -198,7 +198,7 @@ static void cx25840_initialize(struct i2
 static void cx25840_initialize(struct i2c_client *client)
 {
 	DEFINE_WAIT(wait);
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	struct workqueue_struct *q;
 
 	/* datasheet startup in numbered steps, refer to page 3-77 */
@@ -270,7 +270,7 @@ static void cx23885_initialize(struct i2
 static void cx23885_initialize(struct i2c_client *client)
 {
 	DEFINE_WAIT(wait);
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	struct workqueue_struct *q;
 
 	/* Internal Reset */
@@ -369,7 +369,7 @@ static void cx23885_initialize(struct i2
 
 void cx25840_std_setup(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	v4l2_std_id std = state->std;
 	int hblank, hactive, burst, vblank, vactive, sc;
 	int vblank656, src_decimation;
@@ -516,7 +516,7 @@ void cx25840_std_setup(struct i2c_client
 
 static void input_change(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	v4l2_std_id std = state->std;
 
 	/* Follow step 8c and 8d of section 3.16 in the cx25840 datasheet */
@@ -570,7 +570,7 @@ static int set_input(struct i2c_client *
 static int set_input(struct i2c_client *client, enum 
cx25840_video_input vid_input,
 						enum cx25840_audio_input aud_input)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	u8 is_composite = (vid_input >= CX25840_COMPOSITE1 &&
 			   vid_input <= CX25840_COMPOSITE8);
 	u8 reg;
@@ -690,7 +690,7 @@ static int set_input(struct i2c_client *
 
 static int set_v4lstd(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	u8 fmt = 0; 	/* zero is autodetect */
 	u8 pal_m = 0;
 
@@ -739,9 +739,10 @@ static int set_v4lstd(struct i2c_client 
 
 /* ----------------------------------------------------------------------- 
*/
 
-static int set_v4lctrl(struct i2c_client *client, struct v4l2_control 
*ctrl)
-{
-	struct cx25840_state *state = i2c_get_clientdata(client);
+static int subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control 
*ctrl)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
 	case CX25840_CID_ENABLE_PVR150_WORKAROUND:
@@ -805,9 +806,10 @@ static int set_v4lctrl(struct i2c_client
 	return 0;
 }
 
-static int get_v4lctrl(struct i2c_client *client, struct v4l2_control 
*ctrl)
-{
-	struct cx25840_state *state = i2c_get_clientdata(client);
+static int subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control 
*ctrl)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
 	case CX25840_CID_ENABLE_PVR150_WORKAROUND:
@@ -842,21 +844,23 @@ static int get_v4lctrl(struct i2c_client
 
 /* ----------------------------------------------------------------------- 
*/
 
-static int get_v4lfmt(struct i2c_client *client, struct v4l2_format 
*fmt)
-{
+static int subdev_g_fmt(struct v4l2_subdev *sd, struct v4l2_format 
*fmt)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
 	switch (fmt->type) {
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 		return cx25840_vbi(client, VIDIOC_G_FMT, fmt);
 	default:
 		return -EINVAL;
 	}
-
-	return 0;
-}
-
-static int set_v4lfmt(struct i2c_client *client, struct v4l2_format 
*fmt)
-{
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	return 0;
+}
+
+static int subdev_s_fmt(struct v4l2_subdev *sd, struct v4l2_format 
*fmt)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct v4l2_pix_format *pix;
 	int HSC, VSC, Vsrc, Hsrc, filter, Vlines;
 	int is_50Hz = !(state->std & V4L2_STD_525_60);
@@ -933,7 +937,7 @@ static void log_video_status(struct i2c_
 		"0xD", "0xE", "0xF"
 	};
 
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	u8 vidfmt_sel = cx25840_read(client, 0x400) & 0xf;
 	u8 gen_stat1 = cx25840_read(client, 0x40d);
 	u8 gen_stat2 = cx25840_read(client, 0x40e);
@@ -963,7 +967,7 @@ static void log_video_status(struct i2c_
 
 static void log_audio_status(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	u8 download_ctl = cx25840_read(client, 0x803);
 	u8 mod_det_stat0 = cx25840_read(client, 0x804);
 	u8 mod_det_stat1 = cx25840_read(client, 0x805);
@@ -1116,21 +1120,12 @@ static void log_audio_status(struct i2c_
 
 /* ----------------------------------------------------------------------- 
*/
 
-static int cx25840_command(struct i2c_client *client, unsigned int cmd,
-			   void *arg)
-{
-	struct cx25840_state *state = i2c_get_clientdata(client);
-	struct v4l2_tuner *vt = arg;
-	struct v4l2_routing *route = arg;
-
-	/* ignore these commands */
-	switch (cmd) {
-		case TUNER_SET_TYPE_ADDR:
-			return 0;
-	}
+static int subdev_init(struct v4l2_subdev *sd, u32 val)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	if (!state->is_initialized) {
-		v4l_dbg(1, cx25840_debug, client, "cmd %08x triggered fw load\n", 
cmd);
 		/* initialize on first use */
 		state->is_initialized = 1;
 		if (state->is_cx25836)
@@ -1140,50 +1135,69 @@ static int cx25840_command(struct i2c_cl
 		else
 			cx25840_initialize(client);
 	}
-
-	switch (cmd) {
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	/* ioctls to allow direct access to the
-	 * cx25840 registers for testing */
-	case VIDIOC_DBG_G_REGISTER:
-	case VIDIOC_DBG_S_REGISTER:
-	{
-		struct v4l2_register *reg = arg;
-
-		if (!v4l2_chip_match_i2c_client(client, reg->match_type, 
reg->match_chip))
-			return -EINVAL;
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (cmd == VIDIOC_DBG_G_REGISTER)
-			reg->val = cx25840_read(client, reg->reg & 0x0fff);
-		else
-			cx25840_write(client, reg->reg & 0x0fff, reg->val & 0xff);
-		break;
-	}
+static int subdev_g_register(struct v4l2_subdev *sd, struct 
v4l2_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client,
+				reg->match_type, reg->match_chip))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	reg->val = cx25840_read(client, reg->reg & 0x0fff);
+	return 0;
+}
+
+static int subdev_s_register(struct v4l2_subdev *sd, struct 
v4l2_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client,
+				reg->match_type, reg->match_chip))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	cx25840_write(client, reg->reg & 0x0fff, reg->val & 0xff);
+	return 0;
+}
 #endif
 
-	case VIDIOC_INT_DECODE_VBI_LINE:
-		return cx25840_vbi(client, cmd, arg);
-
-	case VIDIOC_INT_AUDIO_CLOCK_FREQ:
-		return cx25840_audio(client, cmd, arg);
-
-	case VIDIOC_STREAMON:
-		v4l_dbg(1, cx25840_debug, client, "enable output\n");
+static int subdev_decode_vbi_line(struct v4l2_subdev *sd, struct 
v4l2_decode_vbi_line *vbi)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return cx25840_vbi(client, VIDIOC_INT_DECODE_VBI_LINE, vbi);
+}
+
+static int subdev_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return cx25840_audio(client, VIDIOC_INT_AUDIO_CLOCK_FREQ, &freq);
+}
+
+static int subdev_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	v4l_dbg(1, cx25840_debug, client, "%s output\n",
+			enable ? "enable" : "disable");
+	if (enable) {
 		if (state->is_cx23885) {
 			u8 v = (cx25840_read(client, 0x421) | 0x0b);
 			cx25840_write(client, 0x421, v);
 		} else {
 			cx25840_write(client, 0x115,
-				state->is_cx25836 ? 0x0c : 0x8c);
+					state->is_cx25836 ? 0x0c : 0x8c);
 			cx25840_write(client, 0x116,
-				state->is_cx25836 ? 0x04 : 0x07);
-		}
-		break;
-
-	case VIDIOC_STREAMOFF:
-		v4l_dbg(1, cx25840_debug, client, "disable output\n");
+					state->is_cx25836 ? 0x04 : 0x07);
+		}
+	} else {
 		if (state->is_cx23885) {
 			u8 v = cx25840_read(client, 0x421) & ~(0x0b);
 			cx25840_write(client, 0x421, v);
@@ -1191,133 +1205,136 @@ static int cx25840_command(struct i2c_cl
 			cx25840_write(client, 0x115, 0x00);
 			cx25840_write(client, 0x116, 0x00);
 		}
+	}
+	return 0;
+}
+
+static int subdev_queryctrl(struct v4l2_subdev *sd, struct 
v4l2_queryctrl *qc)
+{
+	struct subdev_state *state = to_state(sd);
+
+	switch (qc->id) {
+	case V4L2_CID_BRIGHTNESS:
+	case V4L2_CID_CONTRAST:
+	case V4L2_CID_SATURATION:
+	case V4L2_CID_HUE:
+		return v4l2_ctrl_query_fill_std(qc);
+	default:
 		break;
-
-	case VIDIOC_LOG_STATUS:
-		log_video_status(client);
-		if (!state->is_cx25836)
-			log_audio_status(client);
-		break;
-
-	case VIDIOC_G_CTRL:
-		return get_v4lctrl(client, (struct v4l2_control *)arg);
-
-	case VIDIOC_S_CTRL:
-		return set_v4lctrl(client, (struct v4l2_control *)arg);
-
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *qc = arg;
-
-		switch (qc->id) {
-			case V4L2_CID_BRIGHTNESS:
-			case V4L2_CID_CONTRAST:
-			case V4L2_CID_SATURATION:
-			case V4L2_CID_HUE:
-				return v4l2_ctrl_query_fill_std(qc);
-			default:
-				break;
-		}
-		if (state->is_cx25836)
-			return -EINVAL;
-
-		switch (qc->id) {
-			case V4L2_CID_AUDIO_VOLUME:
-				return v4l2_ctrl_query_fill(qc, 0, 65535,
-					65535 / 100, state->default_volume);
-			case V4L2_CID_AUDIO_MUTE:
-			case V4L2_CID_AUDIO_BALANCE:
-			case V4L2_CID_AUDIO_BASS:
-			case V4L2_CID_AUDIO_TREBLE:
-				return v4l2_ctrl_query_fill_std(qc);
-			default:
-				return -EINVAL;
-		}
+	}
+	if (state->is_cx25836)
 		return -EINVAL;
-	}
-
-	case VIDIOC_G_STD:
-		*(v4l2_std_id *)arg = state->std;
-		break;
-
-	case VIDIOC_S_STD:
-		if (state->radio == 0 && state->std == *(v4l2_std_id *)arg)
-			return 0;
-		state->radio = 0;
-		state->std = *(v4l2_std_id *)arg;
-		return set_v4lstd(client);
-
-	case AUDC_SET_RADIO:
-		state->radio = 1;
-		break;
-
-	case VIDIOC_INT_G_VIDEO_ROUTING:
-		route->input = state->vid_input;
-		route->output = 0;
-		break;
-
-	case VIDIOC_INT_S_VIDEO_ROUTING:
-		return set_input(client, route->input, state->aud_input);
-
-	case VIDIOC_INT_G_AUDIO_ROUTING:
-		if (state->is_cx25836)
-			return -EINVAL;
-		route->input = state->aud_input;
-		route->output = 0;
-		break;
-
-	case VIDIOC_INT_S_AUDIO_ROUTING:
-		if (state->is_cx25836)
-			return -EINVAL;
-		return set_input(client, state->vid_input, route->input);
-
-	case VIDIOC_S_FREQUENCY:
-		if (!state->is_cx25836) {
-			input_change(client);
-		}
-		break;
-
-	case VIDIOC_G_TUNER:
-	{
-		u8 vpres = cx25840_read(client, 0x40e) & 0x20;
-		u8 mode;
-		int val = 0;
-
-		if (state->radio)
-			break;
-
-		vt->signal = vpres ? 0xffff : 0x0;
-		if (state->is_cx25836)
-			break;
-
-		vt->capability |=
-		    V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
-		    V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
-
-		mode = cx25840_read(client, 0x804);
-
-		/* get rxsubchans and audmode */
-		if ((mode & 0xf) == 1)
-			val |= V4L2_TUNER_SUB_STEREO;
-		else
-			val |= V4L2_TUNER_SUB_MONO;
-
-		if (mode == 2 || mode == 4)
-			val = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
-
-		if (mode & 0x10)
-			val |= V4L2_TUNER_SUB_SAP;
-
-		vt->rxsubchans = val;
-		vt->audmode = state->audmode;
-		break;
-	}
-
-	case VIDIOC_S_TUNER:
-		if (state->radio || state->is_cx25836)
-			break;
-
-		switch (vt->audmode) {
+
+	switch (qc->id) {
+	case V4L2_CID_AUDIO_VOLUME:
+		return v4l2_ctrl_query_fill(qc, 0, 65535,
+				65535 / 100, state->default_volume);
+	case V4L2_CID_AUDIO_MUTE:
+	case V4L2_CID_AUDIO_BALANCE:
+	case V4L2_CID_AUDIO_BASS:
+	case V4L2_CID_AUDIO_TREBLE:
+		return v4l2_ctrl_query_fill_std(qc);
+	default:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+static int subdev_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (state->radio == 0 && state->std == std)
+		return 0;
+	state->radio = 0;
+	state->std = std;
+	return set_v4lstd(client);
+}
+
+static int subdev_s_radio(struct v4l2_subdev *sd)
+{
+	struct subdev_state *state = to_state(sd);
+
+	state->radio = 1;
+	return 0;
+}
+
+static int subdev_s_video_routing(struct v4l2_subdev *sd, const struct 
v4l2_routing *route)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return set_input(client, route->input, state->aud_input);
+}
+
+static int subdev_s_audio_routing(struct v4l2_subdev *sd, const struct 
v4l2_routing *route)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (state->is_cx25836)
+		return -EINVAL;
+	return set_input(client, state->vid_input, route->input);
+}
+
+static int subdev_s_frequency(struct v4l2_subdev *sd, struct 
v4l2_frequency *freq)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!state->is_cx25836)
+		input_change(client);
+	return 0;
+}
+
+static int subdev_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner 
*vt)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u8 vpres = cx25840_read(client, 0x40e) & 0x20;
+	u8 mode;
+	int val = 0;
+
+	if (state->radio)
+		return 0;
+
+	vt->signal = vpres ? 0xffff : 0x0;
+	if (state->is_cx25836)
+		return 0;
+
+	vt->capability |=
+		V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
+		V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
+
+	mode = cx25840_read(client, 0x804);
+
+	/* get rxsubchans and audmode */
+	if ((mode & 0xf) == 1)
+		val |= V4L2_TUNER_SUB_STEREO;
+	else
+		val |= V4L2_TUNER_SUB_MONO;
+
+	if (mode == 2 || mode == 4)
+		val = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+
+	if (mode & 0x10)
+		val |= V4L2_TUNER_SUB_SAP;
+
+	vt->rxsubchans = val;
+	vt->audmode = state->audmode;
+	return 0;
+}
+
+static int subdev_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner 
*vt)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (state->radio || state->is_cx25836)
+		return 0;
+
+	switch (vt->audmode) {
 		case V4L2_TUNER_MODE_MONO:
 			/* mono      -> mono
 			   stereo    -> mono
@@ -1345,41 +1362,100 @@ static int cx25840_command(struct i2c_cl
 			break;
 		default:
 			return -EINVAL;
-		}
-		state->audmode = vt->audmode;
-		break;
-
-	case VIDIOC_G_FMT:
-		return get_v4lfmt(client, (struct v4l2_format *)arg);
-
-	case VIDIOC_S_FMT:
-		return set_v4lfmt(client, (struct v4l2_format *)arg);
-
-	case VIDIOC_INT_RESET:
-		if (state->is_cx25836)
-			cx25836_initialize(client);
-		else if (state->is_cx23885)
-			cx23885_initialize(client);
-		else
-			cx25840_initialize(client);
-		break;
-
-	case VIDIOC_G_CHIP_IDENT:
-		return v4l2_chip_ident_i2c_client(client, arg, state->id, 
state->rev);
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
+	}
+	state->audmode = vt->audmode;
+	return 0;
+}
+
+static int subdev_reset(struct v4l2_subdev *sd, u32 val)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (state->is_cx25836)
+		cx25836_initialize(client);
+	else if (state->is_cx23885)
+		cx23885_initialize(client);
+	else
+		cx25840_initialize(client);
+	return 0;
+}
+
+static int subdev_g_chip_ident(struct v4l2_subdev *sd, struct 
v4l2_chip_ident *chip)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, state->id, 
state->rev);
+}
+
+static int subdev_log_status(struct v4l2_subdev *sd)
+{
+	struct subdev_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	log_video_status(client);
+	if (!state->is_cx25836)
+		log_audio_status(client);
+	return 0;
+}
+
+static int subdev_command(struct i2c_client *client, unsigned cmd, void 
*arg)
+{
+	return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
 }
 
 /* ----------------------------------------------------------------------- 
*/
 
-static int cx25840_probe(struct i2c_client *client,
+static const struct v4l2_subdev_core_ops subdev_core_ops = {
+	.log_status = subdev_log_status,
+	.g_chip_ident = subdev_g_chip_ident,
+	.g_ctrl = subdev_g_ctrl,
+	.s_ctrl = subdev_s_ctrl,
+	.queryctrl = subdev_queryctrl,
+	.reset = subdev_reset,
+	.init = subdev_init,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = subdev_g_register,
+	.s_register = subdev_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_tuner_ops subdev_tuner_ops = {
+	.s_frequency = subdev_s_frequency,
+	.s_std = subdev_s_std,
+	.s_radio = subdev_s_radio,
+	.g_tuner = subdev_g_tuner,
+	.s_tuner = subdev_s_tuner,
+};
+
+static const struct v4l2_subdev_audio_ops subdev_audio_ops = {
+	.s_clock_freq = subdev_s_clock_freq,
+	.s_routing = subdev_s_audio_routing,
+};
+
+static const struct v4l2_subdev_video_ops subdev_video_ops = {
+	.s_routing = subdev_s_video_routing,
+	.g_fmt = subdev_g_fmt,
+	.s_fmt = subdev_s_fmt,
+	.decode_vbi_line = subdev_decode_vbi_line,
+	.s_stream = subdev_s_stream,
+};
+
+static const struct v4l2_subdev_ops subdev_ops = {
+	.core = &subdev_core_ops,
+	.tuner = &subdev_tuner_ops,
+	.audio = &subdev_audio_ops,
+	.video = &subdev_video_ops,
+};
+
+/* ----------------------------------------------------------------------- 
*/
+
+static int subdev_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
-	struct cx25840_state *state;
+	struct subdev_state *state;
+	struct v4l2_subdev *sd;
 	u32 id;
 	u16 device_id;
 
@@ -1410,11 +1486,12 @@ static int cx25840_probe(struct i2c_clie
 		return -ENODEV;
 	}
 
-	state = kzalloc(sizeof(struct cx25840_state), GFP_KERNEL);
-	if (state == NULL) {
+	state = kzalloc(sizeof(struct subdev_state), GFP_KERNEL);
+	if (state == NULL)
 		return -ENOMEM;
-	}
-
+
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &subdev_ops);
 	/* Note: revision '(device_id & 0x0f) == 2' was never built. The
 	   marking skips from 0x1 == 22 to 0x3 == 23. */
 	v4l_info(client, "cx25%3x-2%x found @ 0x%x (%s)\n",
@@ -1422,7 +1499,6 @@ static int cx25840_probe(struct i2c_clie
 		    (device_id & 0x0f) < 3 ? (device_id & 0x0f) + 1 : (device_id & 
0x0f),
 		    client->addr << 1, client->adapter->name);
 
-	i2c_set_clientdata(client, state);
 	state->c = client;
 	state->is_cx25836 = ((device_id & 0xff00) == 0x8300);
 	state->is_cx23885 = (device_id == 0x0000) || (device_id == 0x1313);
@@ -1447,9 +1523,12 @@ static int cx25840_probe(struct i2c_clie
 	return 0;
 }
 
-static int cx25840_remove(struct i2c_client *client)
-{
-	kfree(i2c_get_clientdata(client));
+static int subdev_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
 	return 0;
 }
 
@@ -1464,9 +1543,9 @@ static struct v4l2_i2c_driver_data v4l2_
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "cx25840",
 	.driverid = I2C_DRIVERID_CX25840,
-	.command = cx25840_command,
-	.probe = cx25840_probe,
-	.remove = cx25840_remove,
+	.command = subdev_command,
+	.probe = subdev_probe,
+	.remove = subdev_remove,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	.id_table = cx25840_id,
 #endif
--- a/linux/drivers/media/video/cx25840/cx25840-core.h	Mon Nov 24 
22:12:55 2008 +0100
+++ b/linux/drivers/media/video/cx25840/cx25840-core.h	Mon Nov 24 
22:14:17 2008 +0100
@@ -23,6 +23,7 @@
 #include "compat.h"
 
 #include <linux/videodev2.h>
+#include <media/v4l2-device.h>
 #include <linux/i2c.h>
 
 /* ENABLE_PVR150_WORKAROUND activates a workaround for a hardware bug 
that is
@@ -33,8 +34,9 @@
    providing this information. */
 #define CX25840_CID_ENABLE_PVR150_WORKAROUND (V4L2_CID_PRIVATE_BASE+0)
 
-struct cx25840_state {
+struct subdev_state {
 	struct i2c_client *c;
+	struct v4l2_subdev sd;
 	int pvr150_workaround;
 	int radio;
 	v4l2_std_id std;
@@ -53,6 +55,11 @@ struct cx25840_state {
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished 
*/
 	struct work_struct fw_work;   /* work entry for fw load */
 };
+
+static inline struct subdev_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct subdev_state, sd);
+}
 
 /* ----------------------------------------------------------------------- 
*/
 /* cx25850-core.c 							   */
--- a/linux/drivers/media/video/cx25840/cx25840-firmware.c	Mon Nov 24 
22:12:55 2008 +0100
+++ b/linux/drivers/media/video/cx25840/cx25840-firmware.c	Mon Nov 24 
22:14:17 2008 +0100
@@ -92,7 +92,7 @@ static int fw_write(struct i2c_client *c
 
 int cx25840_loadfw(struct i2c_client *client)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	const struct firmware *fw = NULL;
 	u8 buffer[FWSEND];
 	const u8 *ptr;
--- a/linux/drivers/media/video/cx25840/cx25840-vbi.c	Mon Nov 24 
22:12:55 2008 +0100
+++ b/linux/drivers/media/video/cx25840/cx25840-vbi.c	Mon Nov 24 
22:14:17 2008 +0100
@@ -85,7 +85,7 @@ static int decode_vps(u8 * dst, u8 * p)
 
 int cx25840_vbi(struct i2c_client *client, unsigned int cmd, void *arg)
 {
-	struct cx25840_state *state = i2c_get_clientdata(client);
+	struct subdev_state *state = to_state(i2c_get_clientdata(client));
 	struct v4l2_format *fmt;
 	struct v4l2_sliced_vbi_format *svbi;
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
