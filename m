Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway04.websitewelcome.com ([64.5.52.7]:54369 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757913AbZKJTel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 14:34:41 -0500
Received: from [66.15.212.169] (port=18817 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1N7wNh-0006Hi-7v
	for linux-media@vger.kernel.org; Tue, 10 Nov 2009 13:27:57 -0600
Subject: [PATCH 5/5] go7007: subdev conversion
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 11:21:44 -0800
Message-Id: <1257880904.21307.1109.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

Convert the go7007 driver to v4l2 subdev interface, using v4l2 i2c
subdev functions instead of i2c functions directly.  The v4l2 ioctl ops
functions call subdev ops instead of i2c commands.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r a44341b7bf67 -r 76b500418fae linux/drivers/staging/go7007/go7007-driver.c
--- a/linux/drivers/staging/go7007/go7007-driver.c	Tue Nov 10 10:56:51 2009 -0800
+++ b/linux/drivers/staging/go7007/go7007-driver.c	Tue Nov 10 11:20:10 2009 -0800
@@ -193,7 +193,8 @@
 static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
 			   int id, int addr)
 {
-	struct i2c_board_info info;
+	struct go7007 *go = i2c_get_adapdata(adapter);
+	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
 	char *modname;
 
 	switch (id) {
@@ -225,14 +226,10 @@
 		modname = NULL;
 		break;
 	}
-	if (modname != NULL)
-		request_module(modname);
 
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	info.addr = addr;
-	strlcpy(info.type, type, I2C_NAME_SIZE);
-	if (!i2c_new_device(adapter, &info))
+	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, modname, type, addr, NULL))
 		return 0;
+
 	if (modname != NULL)
 		printk(KERN_INFO
 			"go7007: probing for module %s failed\n", modname);
@@ -262,6 +259,11 @@
 	if (ret < 0)
 		return -1;
 
+	/* v4l2 init must happen before i2c subdevs */
+	ret = go7007_v4l2_init(go);
+	if (ret < 0)
+		return ret;
+
 	if (!go->i2c_adapter_online &&
 			go->board_info->flags & GO7007_BOARD_USE_ONBOARD_I2C) {
 		if (go7007_i2c_init(go) < 0)
@@ -282,7 +284,7 @@
 		go->audio_enabled = 1;
 		go7007_snd_init(go);
 	}
-	return go7007_v4l2_init(go);
+	return 0;
 }
 EXPORT_SYMBOL(go7007_register_encoder);
 
diff -r a44341b7bf67 -r 76b500418fae linux/drivers/staging/go7007/go7007-v4l2.c
--- a/linux/drivers/staging/go7007/go7007-v4l2.c	Tue Nov 10 10:56:51 2009 -0800
+++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Tue Nov 10 11:20:10 2009 -0800
@@ -29,6 +29,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
@@ -46,6 +47,9 @@
 #define	V4L2_MPEG_VIDEO_ENCODING_MPEG_4   3
 #endif
 
+#define call_all(dev, o, f, args...) \
+	v4l2_device_call_until_err(dev, 0, o, f, ##args)
+
 static void deactivate_buffer(struct go7007_buffer *gobuf)
 {
 	int i;
@@ -247,19 +251,23 @@
 		go->modet_map[i] = 0;
 
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING) {
-		struct video_decoder_resolution res;
+		struct v4l2_format res;
 
-		res.width = width;
+		if (fmt != NULL) {
+			res = *fmt;
+		} else {
+			res.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			res.fmt.pix.width = width;
+		}
+
 		if (height > sensor_height / 2) {
-			res.height = height / 2;
+			res.fmt.pix.height = height / 2;
 			go->encoder_v_halve = 0;
 		} else {
-			res.height = height;
+			res.fmt.pix.height = height;
 			go->encoder_v_halve = 1;
 		}
-		if (go->i2c_adapter_online)
-			i2c_clients_command(&go->i2c_adapter,
-					DECODER_SET_RESOLUTION, &res);
+		call_all(&go->v4l2_dev, video, s_fmt, &res);
 	} else {
 		if (width <= sensor_width / 4) {
 			go->encoder_h_halve = 1;
@@ -385,7 +393,7 @@
 }
 #endif
 
-static int mpeg_queryctrl(struct v4l2_queryctrl *ctrl)
+static int mpeg_query_ctrl(struct v4l2_queryctrl *ctrl)
 {
 	static const u32 mpeg_ctrls[] = {
 		V4L2_CID_MPEG_CLASS,
@@ -973,51 +981,35 @@
 			   struct v4l2_queryctrl *query)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	int id = query->id;
 
-	if (!go->i2c_adapter_online)
-		return -EIO;
+	if (0 == call_all(&go->v4l2_dev, core, queryctrl, query))
+		return 0;
 
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, query);
-
-	return (!query->name[0]) ? mpeg_queryctrl(query) : 0;
+	query->id = id;
+	return mpeg_query_ctrl(query);
 }
 
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
-	struct v4l2_queryctrl query;
 
-	if (!go->i2c_adapter_online)
-		return -EIO;
+	if (0 == call_all(&go->v4l2_dev, core, g_ctrl, ctrl))
+		return 0;
 
-	memset(&query, 0, sizeof(query));
-	query.id = ctrl->id;
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, &query);
-	if (query.name[0] == 0)
-		return mpeg_g_ctrl(ctrl, go);
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_G_CTRL, ctrl);
-
-	return 0;
+	return mpeg_g_ctrl(ctrl, go);
 }
 
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
-	struct v4l2_queryctrl query;
 
-	if (!go->i2c_adapter_online)
-		return -EIO;
+	if (0 == call_all(&go->v4l2_dev, core, s_ctrl, ctrl))
+		return 0;
 
-	memset(&query, 0, sizeof(query));
-	query.id = ctrl->id;
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, &query);
-	if (query.name[0] == 0)
-		return mpeg_s_ctrl(ctrl, go);
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_S_CTRL, ctrl);
-
-	return 0;
+	return mpeg_s_ctrl(ctrl, go);
 }
 
 static int vidioc_g_parm(struct file *filp, void *priv,
@@ -1135,8 +1127,7 @@
 	if (go->streaming)
 		return -EBUSY;
 
-	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV) &&
-			*std != 0)
+	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV) && *std != 0)
 		return -EINVAL;
 
 	if (*std == 0)
@@ -1146,9 +1137,7 @@
 			go->input == go->board_info->num_inputs - 1) {
 		if (!go->i2c_adapter_online)
 			return -EIO;
-		i2c_clients_command(&go->i2c_adapter,
-					VIDIOC_S_STD, std);
-		if (!*std) /* hack to indicate EINVAL from tuner */
+		if (call_all(&go->v4l2_dev, core, s_std, *std) < 0)
 			return -EINVAL;
 	}
 
@@ -1164,9 +1153,7 @@
 	} else
 		return -EINVAL;
 
-	if (go->i2c_adapter_online)
-		i2c_clients_command(&go->i2c_adapter,
-					VIDIOC_S_STD, std);
+	call_all(&go->v4l2_dev, core, s_std, *std);
 	set_capture_size(go, NULL, 0);
 
 	return 0;
@@ -1180,7 +1167,7 @@
 			go->input == go->board_info->num_inputs - 1) {
 		if (!go->i2c_adapter_online)
 			return -EIO;
-		i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYSTD, std);
+		return call_all(&go->v4l2_dev, video, querystd, std);
 	} else if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
 		*std = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
 	else
@@ -1238,14 +1225,8 @@
 		return -EBUSY;
 
 	go->input = input;
-	if (go->i2c_adapter_online) {
-		i2c_clients_command(&go->i2c_adapter, VIDIOC_S_INPUT,
-			&go->board_info->inputs[input].video_input);
-		i2c_clients_command(&go->i2c_adapter, VIDIOC_S_AUDIO,
-			&go->board_info->inputs[input].audio_input);
-	}
 
-	return 0;
+	return call_all(&go->v4l2_dev, video, s_routing, input, 0, 0);
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
@@ -1260,10 +1241,7 @@
 	if (!go->i2c_adapter_online)
 		return -EIO;
 
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_G_TUNER, t);
-
-	t->index = 0;
-	return 0;
+	return call_all(&go->v4l2_dev, tuner, g_tuner, t);
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
@@ -1287,9 +1265,7 @@
 		break;
 	}
 
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_S_TUNER, t);
-
-	return 0;
+	return call_all(&go->v4l2_dev, tuner, s_tuner, t);
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
@@ -1303,8 +1279,8 @@
 		return -EIO;
 
 	f->type = V4L2_TUNER_ANALOG_TV;
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_G_FREQUENCY, f);
-	return 0;
+
+	return call_all(&go->v4l2_dev, tuner, g_frequency, f);
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
@@ -1317,9 +1293,7 @@
 	if (!go->i2c_adapter_online)
 		return -EIO;
 
-	i2c_clients_command(&go->i2c_adapter, VIDIOC_S_FREQUENCY, f);
-
-	return 0;
+	return call_all(&go->v4l2_dev, tuner, s_frequency, f);
 }
 
 static int vidioc_cropcap(struct file *file, void *priv,

