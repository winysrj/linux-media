Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([69.41.245.13]:37198 "HELO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757911AbZKJTeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 14:34:31 -0500
Received: from [66.15.212.169] (port=18788 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1N7wNV-0006Bq-Pb
	for linux-media@vger.kernel.org; Tue, 10 Nov 2009 13:27:48 -0600
Subject: [PATCH 4/5] s2250: subdev conversion
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 11:21:40 -0800
Message-Id: <1257880900.21307.1108.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

Convert the s2250 i2c driver to use v4l2 subdev interface.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 5fe2031944d4 -r a44341b7bf67 linux/drivers/staging/go7007/s2250-board.c
--- a/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:54:51 2009 -0800
+++ b/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:56:51 2009 -0800
@@ -23,6 +23,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-i2c-drv.h>
+#include <media/v4l2-subdev.h>
 #include "go7007-priv.h"
 
 MODULE_DESCRIPTION("Sensoray 2250/2251 i2c v4l2 subdev driver");
@@ -115,6 +116,7 @@
 };
 
 struct s2250 {
+	struct v4l2_subdev sd;
 	v4l2_std_id std;
 	int input;
 	int brightness;
@@ -126,6 +128,11 @@
 	struct i2c_client *audio;
 };
 
+static inline struct s2250 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s2250, sd);
+}
+
 /* from go7007-usb.c which is Copyright (C) 2005-2006 Micronas USA Inc.*/
 static int go7007_usb_vendor_request(struct go7007 *go, u16 request,
 	u16 value, u16 index, void *transfer_buffer, int length, int in)
@@ -309,253 +316,262 @@
 }
 
 
-static int s2250_command(struct i2c_client *client,
-			 unsigned int cmd, void *arg)
+/* ------------------------------------------------------------------------- */
+
+static int s2250_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+				 u32 config)
 {
-	struct s2250 *dec = i2c_get_clientdata(client);
+	struct s2250 *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int vidsys;
 
-	switch (cmd) {
-	case VIDIOC_S_INPUT:
-	{
-		int vidsys;
-		int *input = arg;
+	vidsys = (state->std == V4L2_STD_NTSC) ? 0x01 : 0x00;
+	if (input == 0) {
+		/* composite */
+		write_reg_fp(client, 0x20, 0x020 | vidsys);
+		write_reg_fp(client, 0x21, 0x662);
+		write_reg_fp(client, 0x140, 0x060);
+	} else if (input == 1) {
+		/* S-Video */
+		write_reg_fp(client, 0x20, 0x040 | vidsys);
+		write_reg_fp(client, 0x21, 0x666);
+		write_reg_fp(client, 0x140, 0x060);
+	} else {
+		return -EINVAL;
+	}
+	state->input = input;
+	return 0;
+}
 
-		vidsys = (dec->std == V4L2_STD_NTSC) ? 0x01 : 0x00;
-		if (*input == 0) {
-			/* composite */
-			write_reg_fp(client, 0x20, 0x020 | vidsys);
-			write_reg_fp(client, 0x21, 0x662);
-			write_reg_fp(client, 0x140, 0x060);
-		} else {
-			/* S-Video */
-			write_reg_fp(client, 0x20, 0x040 | vidsys);
-			write_reg_fp(client, 0x21, 0x666);
-			write_reg_fp(client, 0x140, 0x060);
-		}
-		dec->input = *input;
+static int s2250_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct s2250 *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 vidsource;
+
+	vidsource = (state->input == 1) ? 0x040 : 0x020;
+	switch (norm) {
+	case V4L2_STD_NTSC:
+		write_regs_fp(client, vid_regs_fp);
+		write_reg_fp(client, 0x20, vidsource | 1);
 		break;
+	case V4L2_STD_PAL:
+		write_regs_fp(client, vid_regs_fp);
+		write_regs_fp(client, vid_regs_fp_pal);
+		write_reg_fp(client, 0x20, vidsource);
+		break;
+	default:
+		return -EINVAL;
 	}
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *std = arg;
-		u16 vidsource;
+	state->std = norm;
+	return 0;
+}
 
-		vidsource = (dec->input == 1) ? 0x040 : 0x020;
-		dec->std = *std;
-		switch (dec->std) {
-		case V4L2_STD_NTSC:
-			write_regs_fp(client, vid_regs_fp);
-			write_reg_fp(client, 0x20, vidsource | 1);
-			break;
-		case V4L2_STD_PAL:
-			write_regs_fp(client, vid_regs_fp);
-			write_regs_fp(client, vid_regs_fp_pal);
-			write_reg_fp(client, 0x20, vidsource);
-			break;
-		default:
-			return -EINVAL;
-		}
-		break;
-	}
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *ctrl = arg;
-		static const u32 user_ctrls[] = {
-			V4L2_CID_BRIGHTNESS,
-			V4L2_CID_CONTRAST,
-			V4L2_CID_SATURATION,
-			V4L2_CID_HUE,
-			0
-		};
-		static const u32 *ctrl_classes[] = {
-			user_ctrls,
-			NULL
-		};
-
-		ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
-		case V4L2_CID_CONTRAST:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
-		case V4L2_CID_SATURATION:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
-		case V4L2_CID_HUE:
-			v4l2_ctrl_query_fill(ctrl, -50, 50, 1, 0);
-			break;
-		default:
-			ctrl->name[0] = '\0';
-			return -EINVAL;
-		}
-		break;
-	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-		int value1;
-		u16 oldvalue;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			if (ctrl->value > 100)
-				dec->brightness = 100;
-			else if (ctrl->value < 0)
-				dec->brightness = 0;
-			else
-				dec->brightness = ctrl->value;
-			value1 = (dec->brightness - 50) * 255 / 100;
-			read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
-			write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
-				     value1 | (oldvalue & ~0xff));
-			read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
-			write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
-				     value1 | (oldvalue & ~0xff));
-			write_reg_fp(client, 0x140, 0x60);
-			break;
-		case V4L2_CID_CONTRAST:
-			if (ctrl->value > 100)
-				dec->contrast = 100;
-			else if (ctrl->value < 0)
-				dec->contrast = 0;
-			else
-				dec->contrast = ctrl->value;
-			value1 = dec->contrast * 0x40 / 100;
-			if (value1 > 0x3f)
-				value1 = 0x3f; /* max */
-			read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
-			write_reg_fp(client, VPX322_ADDR_CONTRAST0,
-				     value1 | (oldvalue & ~0x3f));
-			read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
-			write_reg_fp(client, VPX322_ADDR_CONTRAST1,
-				     value1 | (oldvalue & ~0x3f));
-			write_reg_fp(client, 0x140, 0x60);
-			break;
-		case V4L2_CID_SATURATION:
-			if (ctrl->value > 127)
-				dec->saturation = 127;
-			else if (ctrl->value < 0)
-				dec->saturation = 0;
-			else
-				dec->saturation = ctrl->value;
-
-			value1 = dec->saturation * 4140 / 100;
-			if (value1 > 4094)
-				value1 = 4094;
-			write_reg_fp(client, VPX322_ADDR_SAT, value1);
-			break;
-		case V4L2_CID_HUE:
-			if (ctrl->value > 50)
-				dec->hue = 50;
-			else if (ctrl->value < -50)
-				dec->hue = -50;
-			else
-				dec->hue = ctrl->value;
-			/* clamp the hue range */
-			value1 = dec->hue * 280 / 50;
-			write_reg_fp(client, VPX322_ADDR_HUE, value1);
-			break;
-		}
-		break;
-	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->value = dec->brightness;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->value = dec->contrast;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->value = dec->saturation;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->value = dec->hue;
-			break;
-		}
-		break;
-	}
-	case VIDIOC_S_FMT:
-	{
-		struct v4l2_format *fmt = arg;
-		if (fmt->fmt.pix.height < 640) {
-			write_reg_fp(client, 0x12b, dec->reg12b_val | 0x400);
-			write_reg_fp(client, 0x140, 0x060);
-		} else {
-			write_reg_fp(client, 0x12b, dec->reg12b_val & ~0x400);
-			write_reg_fp(client, 0x140, 0x060);
-		}
-		return 0;
-	}
-	case VIDIOC_G_AUDIO:
-	{
-		struct v4l2_audio *audio = arg;
-
-		memset(audio, 0, sizeof(*audio));
-		audio->index = dec->audio_input;
-		/* fall through */
-	}
-	case VIDIOC_ENUMAUDIO:
-	{
-		struct v4l2_audio *audio = arg;
-
-		switch (audio->index) {
-		case 0:
-			strcpy(audio->name, "Line In");
-			break;
-		case 1:
-			strcpy(audio->name, "Mic");
-			break;
-		case 2:
-			strcpy(audio->name, "Mic Boost");
-			break;
-		default:
-			audio->name[0] = '\0';
-			return 0;
-		}
-		audio->capability = V4L2_AUDCAP_STEREO;
-		audio->mode = 0;
-		return 0;
-	}
-	case VIDIOC_S_AUDIO:
-	{
-		struct v4l2_audio *audio = arg;
-
-		switch (audio->index) {
-		case 0:
-			write_reg(dec->audio, 0x08, 0x02); /* Line In */
-			break;
-		case 1:
-			write_reg(dec->audio, 0x08, 0x04); /* Mic */
-			break;
-		case 2:
-			write_reg(dec->audio, 0x08, 0x05); /* Mic Boost */
-			break;
-		default:
-			return -EINVAL;
-		}
-		dec->audio_input = audio->index;
-		return 0;
-	}
-
+static int s2250_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *query)
+{
+	switch (query->id) {
+	case V4L2_CID_BRIGHTNESS:
+		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
+	case V4L2_CID_CONTRAST:
+		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
+	case V4L2_CID_SATURATION:
+		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
+	case V4L2_CID_HUE:
+		return v4l2_ctrl_query_fill(query, -50, 50, 1, 0);
 	default:
-		printk(KERN_INFO "s2250: unknown command 0x%x\n", cmd);
-		break;
+		return -EINVAL;
 	}
 	return 0;
 }
 
+static int s2250_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct s2250 *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int value1;
+	u16 oldvalue;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (ctrl->value > 100)
+			state->brightness = 100;
+		else if (ctrl->value < 0)
+			state->brightness = 0;
+		else
+			state->brightness = ctrl->value;
+		value1 = (state->brightness - 50) * 255 / 100;
+		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
+		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
+			     value1 | (oldvalue & ~0xff));
+		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
+		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
+			     value1 | (oldvalue & ~0xff));
+		write_reg_fp(client, 0x140, 0x60);
+		break;
+	case V4L2_CID_CONTRAST:
+		if (ctrl->value > 100)
+			state->contrast = 100;
+		else if (ctrl->value < 0)
+			state->contrast = 0;
+		else
+			state->contrast = ctrl->value;
+		value1 = state->contrast * 0x40 / 100;
+		if (value1 > 0x3f)
+			value1 = 0x3f; /* max */
+		read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
+		write_reg_fp(client, VPX322_ADDR_CONTRAST0,
+			     value1 | (oldvalue & ~0x3f));
+		read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
+		write_reg_fp(client, VPX322_ADDR_CONTRAST1,
+			     value1 | (oldvalue & ~0x3f));
+		write_reg_fp(client, 0x140, 0x60);
+		break;
+	case V4L2_CID_SATURATION:
+		if (ctrl->value > 100)
+			state->saturation = 100;
+		else if (ctrl->value < 0)
+			state->saturation = 0;
+		else
+			state->saturation = ctrl->value;
+		value1 = state->saturation * 4140 / 100;
+		if (value1 > 4094)
+			value1 = 4094;
+		write_reg_fp(client, VPX322_ADDR_SAT, value1);
+		break;
+	case V4L2_CID_HUE:
+		if (ctrl->value > 50)
+			state->hue = 50;
+		else if (ctrl->value < -50)
+			state->hue = -50;
+		else
+			state->hue = ctrl->value;
+		/* clamp the hue range */
+		value1 = state->hue * 280 / 50;
+		write_reg_fp(client, VPX322_ADDR_HUE, value1);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int s2250_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct s2250 *state = to_state(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = state->brightness;
+		break;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = state->contrast;
+		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = state->saturation;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = state->hue;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int s2250_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
+{
+	struct s2250 *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (fmt->fmt.pix.height < 640) {
+		write_reg_fp(client, 0x12b, state->reg12b_val | 0x400);
+		write_reg_fp(client, 0x140, 0x060);
+	} else {
+		write_reg_fp(client, 0x12b, state->reg12b_val & ~0x400);
+		write_reg_fp(client, 0x140, 0x060);
+	}
+	return 0;
+}
+
+static int s2250_s_audio_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+				 u32 config)
+{
+	struct s2250 *state = to_state(sd);
+
+	switch (input) {
+	case 0:
+		write_reg(state->audio, 0x08, 0x02); /* Line In */
+		break;
+	case 1:
+		write_reg(state->audio, 0x08, 0x04); /* Mic */
+		break;
+	case 2:
+		write_reg(state->audio, 0x08, 0x05); /* Mic Boost */
+		break;
+	default:
+		return -EINVAL;
+	}
+	state->audio_input = input;
+	return 0;
+}
+
+
+static int s2250_log_status(struct v4l2_subdev *sd)
+{
+	struct s2250 *state = to_state(sd);
+
+	v4l2_info(sd, "Standard: %s\n", state->std == V4L2_STD_NTSC ? "NTSC" :
+					state->std == V4L2_STD_PAL ? "PAL" :
+					state->std == V4L2_STD_SECAM ? "SECAM" :
+					"unknown");
+	v4l2_info(sd, "Input: %s\n", state->input == 0 ? "Composite" :
+					state->input == 1 ? "S-video" :
+					"error");
+	v4l2_info(sd, "Brightness: %d\n", state->brightness);
+	v4l2_info(sd, "Contrast: %d\n", state->contrast);
+	v4l2_info(sd, "Saturation: %d\n", state->saturation);
+	v4l2_info(sd, "Hue: %d\n", state->hue);	return 0;
+	v4l2_info(sd, "Audio input: %s\n", state->audio_input == 0 ? "Line In" :
+					state->audio_input == 1 ? "Mic" :
+					state->audio_input == 2 ? "Mic Boost" :
+					"error");
+	return 0;
+}
+
+/* --------------------------------------------------------------------------*/
+
+static const struct v4l2_subdev_core_ops s2250_core_ops = {
+	.log_status = s2250_log_status,
+	.g_ctrl = s2250_g_ctrl,
+	.s_ctrl = s2250_s_ctrl,
+	.queryctrl = s2250_queryctrl,
+	.s_std = s2250_s_std,
+};
+
+static const struct v4l2_subdev_audio_ops s2250_audio_ops = {
+	.s_routing = s2250_s_audio_routing,
+};
+
+static const struct v4l2_subdev_video_ops s2250_video_ops = {
+	.s_routing = s2250_s_video_routing,
+	.s_fmt = s2250_s_fmt,
+};
+
+static const struct v4l2_subdev_ops s2250_ops = {
+	.core = &s2250_core_ops,
+	.audio = &s2250_audio_ops,
+	.video = &s2250_video_ops,
+};
+
+/* --------------------------------------------------------------------------*/
+
 static int s2250_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
 {
 	struct i2c_client *audio;
 	struct i2c_adapter *adapter = client->adapter;
-	struct s2250 *dec;
+	struct s2250 *state;
+	struct v4l2_subdev *sd;
 	u8 *data;
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct go7007_usb *usb = go->hpi_context;
@@ -564,30 +580,31 @@
 	if (audio == NULL)
 		return -ENOMEM;
 
-	dec = kmalloc(sizeof(struct s2250), GFP_KERNEL);
-	if (dec == NULL) {
+	state = kmalloc(sizeof(struct s2250), GFP_KERNEL);
+	if (state == NULL) {
 		i2c_unregister_device(audio);
 		return -ENOMEM;
 	}
 
-	dec->std = V4L2_STD_NTSC;
-	dec->brightness = 50;
-	dec->contrast = 50;
-	dec->saturation = 50;
-	dec->hue = 0;
-	dec->audio = audio;
-	i2c_set_clientdata(client, dec);
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &s2250_ops);
 
-	printk(KERN_INFO
-	       "s2250: initializing video decoder on %s\n",
-	       adapter->name);
+	v4l2_info(sd, "initializing %s at address 0x%x on %s\n",
+	       "Sensoray 2250/2251", client->addr, client->adapter->name);
+
+	state->std = V4L2_STD_NTSC;
+	state->brightness = 50;
+	state->contrast = 50;
+	state->saturation = 50;
+	state->hue = 0;
+	state->audio = audio;
 
 	/* initialize the audio */
 	if (write_regs(audio, aud_regs) < 0) {
 		printk(KERN_ERR
 		       "s2250: error initializing audio\n");
 		i2c_unregister_device(audio);
-		kfree(dec);
+		kfree(state);
 		return 0;
 	}
 
@@ -595,14 +612,14 @@
 		printk(KERN_ERR
 		       "s2250: error initializing decoder\n");
 		i2c_unregister_device(audio);
-		kfree(dec);
+		kfree(state);
 		return 0;
 	}
 	if (write_regs_fp(client, vid_regs_fp) < 0) {
 		printk(KERN_ERR
 		       "s2250: error initializing decoder\n");
 		i2c_unregister_device(audio);
-		kfree(dec);
+		kfree(state);
 		return 0;
 	}
 	/* set default channel */
@@ -612,7 +629,7 @@
 	write_reg_fp(client, 0x140, 0x060);
 
 	/* set default audio input */
-	dec->audio_input = 0;
+	state->audio_input = 0;
 	write_reg(client, 0x08, 0x02); /* Line In */
 
 	if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
@@ -637,17 +654,16 @@
 		mutex_unlock(&usb->i2c_lock);
 	}
 
-	printk("s2250: initialized successfully\n");
+	v4l2_info(sd, "initialized successfully\n");
 	return 0;
 }
 
 static int s2250_remove(struct i2c_client *client)
 {
-	struct s2250 *dec = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
-	i2c_set_clientdata(client, NULL);
-	i2c_unregister_device(dec->audio);
-	kfree(dec);
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
 	return 0;
 }
 
@@ -663,7 +679,6 @@
 	.name = "s2250",
 	.probe = s2250_probe,
 	.remove = s2250_remove,
-	.command = s2250_command,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	.id_table = s2250_id,
 #endif

