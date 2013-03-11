Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4285 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 29/42] go7007: tuner/std related fixes.
Date: Mon, 11 Mar 2013 12:46:07 +0100
Message-Id: <f6aa8715b715bb3368563f1056e56456706595be.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- The Adlink is initially detected as a sensor board, so the driver config
  is set up as if it was a sensor. Later the driver discovers that it really
  is a video capture card and that means that the driver configuration has
  to be updated for a PAL/NTSC capture card.

- Setup the correct initial std based on the TV tuner type.

- Remember the exact std the user selected, don't map it to STD_PAL or NTSC.

- Use v4l2_disable_ioctl to disable ioctls based on the board config and
  drop a lot of checking code in each of those ioctls since that is no longer
  needed.

- enum_input should use tvnorms to fill its std field.

- configure the input, std and initial tuner frequency at driver initialization.

- fix std handling in the s2250 driver.

- the code handling scaling for devices without a scaler was broken. This is
  now fixed.

- correctly set readbuffers and capability in g/s_parm.

- remove the bogus test for capturemode in s_parm.

- correctly implement enum_framesizes/intervals.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   35 ++--
 drivers/staging/media/go7007/go7007-priv.h   |    3 +
 drivers/staging/media/go7007/go7007-usb.c    |    3 +
 drivers/staging/media/go7007/go7007-v4l2.c   |  255 ++++++++++++--------------
 drivers/staging/media/go7007/s2250-board.c   |   13 +-
 5 files changed, 154 insertions(+), 155 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index d689989..eac91bc 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -650,19 +650,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	init_waitqueue_head(&go->interrupt_waitq);
 	go->in_use = 0;
 	go->input = 0;
-	if (board->sensor_flags & GO7007_SENSOR_TV) {
-		go->standard = GO7007_STD_NTSC;
-		go->width = 720;
-		go->height = 480;
-		go->sensor_framerate = 30000;
-	} else {
-		go->standard = GO7007_STD_OTHER;
-		go->width = board->sensor_width;
-		go->height = board->sensor_height;
-		go->sensor_framerate = board->sensor_framerate;
-	}
-	go->encoder_v_offset = board->sensor_v_offset;
-	go->encoder_h_offset = board->sensor_h_offset;
+	go7007_update_board(go);
 	go->encoder_h_halve = 0;
 	go->encoder_v_halve = 0;
 	go->encoder_subsample = 0;
@@ -692,4 +680,25 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 }
 EXPORT_SYMBOL(go7007_alloc);
 
+void go7007_update_board(struct go7007 *go)
+{
+	struct go7007_board_info *board = go->board_info;
+
+	if (board->sensor_flags & GO7007_SENSOR_TV) {
+		go->standard = GO7007_STD_NTSC;
+		go->std = V4L2_STD_NTSC_M;
+		go->width = 720;
+		go->height = 480;
+		go->sensor_framerate = 30000;
+	} else {
+		go->standard = GO7007_STD_OTHER;
+		go->width = board->sensor_width;
+		go->height = board->sensor_height;
+		go->sensor_framerate = board->sensor_framerate;
+	}
+	go->encoder_v_offset = board->sensor_v_offset;
+	go->encoder_h_offset = board->sensor_h_offset;
+}
+EXPORT_SYMBOL(go7007_update_board);
+
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 2321fd7..bf874dd 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -200,6 +200,7 @@ struct go7007 {
 	int input;
 	int aud_input;
 	enum { GO7007_STD_NTSC, GO7007_STD_PAL, GO7007_STD_OTHER } standard;
+	v4l2_std_id std;
 	int sensor_framerate;
 	int width;
 	int height;
@@ -291,6 +292,8 @@ int go7007_start_encoder(struct go7007 *go);
 void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length);
 struct go7007 *go7007_alloc(struct go7007_board_info *board,
 					struct device *dev);
+void go7007_update_board(struct go7007 *go);
+
 /* go7007-fw.c */
 int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen);
 
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 2d349f4..14d1cda 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1193,6 +1193,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 					"Adlink PCI-MPG24, channel #%d",
 					channel);
 			}
+			go7007_update_board(go);
 		}
 	}
 
@@ -1209,12 +1210,14 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		case 1:
 			go->board_id = GO7007_BOARDID_PX_TV402U_EU;
 			go->tuner_type = TUNER_SONY_BTF_PG472Z;
+			go->std = V4L2_STD_PAL;
 			strncpy(go->name, "Plextor PX-TV402U-EU",
 					sizeof(go->name));
 			break;
 		case 2:
 			go->board_id = GO7007_BOARDID_PX_TV402U_JP;
 			go->tuner_type = TUNER_SONY_BTF_PK467Z;
+			go->std = V4L2_STD_NTSC_M_JP;
 			num_i2c_devs -= 2;
 			strncpy(go->name, "Plextor PX-TV402U-JP",
 					sizeof(go->name));
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index d3eef8d..2fa5ffc 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -160,30 +160,35 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 	return 0;
 }
 
-static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
+static void get_resolution(struct go7007 *go, int *width, int *height)
 {
-	int sensor_height = 0, sensor_width = 0;
-	int width, height, i;
-
-	if (fmt != NULL && fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG &&
-			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG &&
-			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG4)
-		return -EINVAL;
-
 	switch (go->standard) {
 	case GO7007_STD_NTSC:
-		sensor_width = 720;
-		sensor_height = 480;
+		*width = 720;
+		*height = 480;
 		break;
 	case GO7007_STD_PAL:
-		sensor_width = 720;
-		sensor_height = 576;
+		*width = 720;
+		*height = 576;
 		break;
 	case GO7007_STD_OTHER:
-		sensor_width = go->board_info->sensor_width;
-		sensor_height = go->board_info->sensor_height;
+	default:
+		*width = go->board_info->sensor_width;
+		*height = go->board_info->sensor_height;
 		break;
 	}
+}
+
+static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
+{
+	int sensor_height = 0, sensor_width = 0;
+	int width, height, i;
+
+	if (fmt != NULL && fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG &&
+			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG)
+		return -EINVAL;
+
+	get_resolution(go, &sensor_width, &sensor_height);
 
 	if (fmt == NULL) {
 		width = sensor_width;
@@ -203,13 +208,12 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 		else
 			height = fmt->fmt.pix.height & ~0x0f;
 	} else {
-		int requested_size = fmt->fmt.pix.width * fmt->fmt.pix.height;
-		int sensor_size = sensor_width * sensor_height;
+		width = fmt->fmt.pix.width;
 
-		if (64 * requested_size < 9 * sensor_size) {
+		if (width <= sensor_width / 4) {
 			width = sensor_width / 4;
 			height = sensor_height / 4;
-		} else if (64 * requested_size < 36 * sensor_size) {
+		} else if (width <= sensor_width / 2) {
 			width = sensor_width / 2;
 			height = sensor_height / 2;
 		} else {
@@ -231,7 +235,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 		fmt->fmt.pix.field = V4L2_FIELD_NONE;
 		fmt->fmt.pix.bytesperline = 0;
 		fmt->fmt.pix.sizeimage = GO7007_BUF_SIZE;
-		fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* ?? */
+		fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	}
 
 	if (try)
@@ -250,19 +254,11 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 		struct v4l2_mbus_framefmt mbus_fmt;
 
 		mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
-		if (fmt != NULL)
-			mbus_fmt.width = fmt->fmt.pix.width;
-		else
-			mbus_fmt.width = width;
-
-		if (height > sensor_height / 2) {
-			mbus_fmt.height = height / 2;
-			go->encoder_v_halve = 0;
-		} else {
-			mbus_fmt.height = height;
-			go->encoder_v_halve = 1;
-		}
-		mbus_fmt.height *= 2;
+		mbus_fmt.width = fmt ? fmt->fmt.pix.width : width;
+		mbus_fmt.height = height;
+		go->encoder_h_halve = 0;
+		go->encoder_v_halve = 0;
+		go->encoder_subsample = 0;
 		call_all(&go->v4l2_dev, video, s_mbus_fmt, &mbus_fmt);
 	} else {
 		if (width <= sensor_width / 4) {
@@ -869,7 +865,8 @@ static int vidioc_g_parm(struct file *filp, void *priv,
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	parm->parm.capture.capability |= V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.readbuffers = 2;
+	parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 	parm->parm.capture.timeperframe = timeperframe;
 
 	return 0;
@@ -883,8 +880,6 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (parm->parm.capture.capturemode != 0)
-		return -EINVAL;
 
 	n = go->sensor_framerate *
 		parm->parm.capture.timeperframe.numerator;
@@ -894,7 +889,7 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 	else
 		go->fps_scale = 1;
 
-	return 0;
+	return vidioc_g_parm(filp, priv, parm);
 }
 
 /* VIDIOC_ENUMSTD on go7007 were used for enumerating the supported fps and
@@ -911,19 +906,19 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	int width, height;
 
-	/* Return -EINVAL, if it is a TV board */
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
-	    (go->board_info->sensor_flags & GO7007_SENSOR_TV))
+	if (fsize->index > 2)
 		return -EINVAL;
 
-	if (fsize->index > 0)
+	if (fsize->pixel_format != V4L2_PIX_FMT_MJPEG &&
+	    fsize->pixel_format != V4L2_PIX_FMT_MPEG)
 		return -EINVAL;
 
+	get_resolution(go, &width, &height);
 	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-	fsize->discrete.width = go->board_info->sensor_width;
-	fsize->discrete.height = go->board_info->sensor_height;
-
+	fsize->discrete.width = (width >> fsize->index) & ~0xf;
+	fsize->discrete.height = (height >> fsize->index) & ~0xf;
 	return 0;
 }
 
@@ -931,19 +926,28 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	int width, height;
+	int i;
 
-	/* Return -EINVAL, if it is a TV board */
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
-	    (go->board_info->sensor_flags & GO7007_SENSOR_TV))
+	if (fival->index > 4)
 		return -EINVAL;
 
-	if (fival->index > 0)
+	if (fival->pixel_format != V4L2_PIX_FMT_MJPEG &&
+	    fival->pixel_format != V4L2_PIX_FMT_MPEG)
 		return -EINVAL;
 
+	if (!(go->board_info->sensor_flags & GO7007_SENSOR_SCALING)) {
+		get_resolution(go, &width, &height);
+		for (i = 0; i <= 2; i++)
+			if (fival->width == ((width >> i) & ~0xf) &&
+			    fival->height == ((height >> i) & ~0xf))
+				break;
+		if (i > 2)
+			return -EINVAL;
+	}
 	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	fival->discrete.numerator = 1001;
-	fival->discrete.denominator = go->board_info->sensor_framerate;
-
+	fival->discrete.numerator = 1001 * (fival->index + 1);
+	fival->discrete.denominator = go->sensor_framerate;
 	return 0;
 }
 
@@ -951,74 +955,42 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	switch (go->standard) {
-	case GO7007_STD_NTSC:
-		*std = V4L2_STD_NTSC;
-		break;
-	case GO7007_STD_PAL:
-		*std = V4L2_STD_PAL;
-		break;
-	default:
-		return -EINVAL;
+	*std = go->std;
+	return 0;
+}
+
+static int go7007_s_std(struct go7007 *go)
+{
+	if (go->std & V4L2_STD_525_60) {
+		go->standard = GO7007_STD_NTSC;
+		go->sensor_framerate = 30000;
+	} else {
+		go->standard = GO7007_STD_PAL;
+		go->sensor_framerate = 25025;
 	}
 
+	call_all(&go->v4l2_dev, core, s_std, go->std);
+	set_capture_size(go, NULL, 0);
 	return 0;
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (go->streaming)
 		return -EBUSY;
 
-	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV) && *std != 0)
-		return -EINVAL;
-
-	if (*std == 0)
-		return -EINVAL;
-
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
-			go->input == go->board_info->num_inputs - 1) {
-		if (!go->i2c_adapter_online)
-			return -EIO;
-		if (call_all(&go->v4l2_dev, core, s_std, *std) < 0)
-			return -EINVAL;
-	}
+	go->std = *std;
 
-	if (*std & V4L2_STD_NTSC) {
-		go->standard = GO7007_STD_NTSC;
-		go->sensor_framerate = 30000;
-	} else if (*std & V4L2_STD_PAL) {
-		go->standard = GO7007_STD_PAL;
-		go->sensor_framerate = 25025;
-	} else if (*std & V4L2_STD_SECAM) {
-		go->standard = GO7007_STD_PAL;
-		go->sensor_framerate = 25025;
-	} else
-		return -EINVAL;
-
-	call_all(&go->v4l2_dev, core, s_std, *std);
-	set_capture_size(go, NULL, 0);
-
-	return 0;
+	return go7007_s_std(go);
 }
 
 static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
-			go->input == go->board_info->num_inputs - 1) {
-		if (!go->i2c_adapter_online)
-			return -EIO;
-		return call_all(&go->v4l2_dev, video, querystd, std);
-	} else if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
-		*std = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
-	else
-		*std = 0;
-
-	return 0;
+	return call_all(&go->v4l2_dev, video, querystd, std);
 }
 
 static int vidioc_enum_input(struct file *file, void *priv,
@@ -1045,8 +1017,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		inp->audioset = 0;
 	inp->tuner = 0;
 	if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
-		inp->std = V4L2_STD_NTSC | V4L2_STD_PAL |
-						V4L2_STD_SECAM;
+		inp->std = video_devdata(file)->tvnorms;
 	else
 		inp->std = 0;
 
@@ -1096,16 +1067,9 @@ static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
+static void go7007_s_input(struct go7007 *go)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
-
-	if (input >= go->board_info->num_inputs)
-		return -EINVAL;
-	if (go->streaming)
-		return -EBUSY;
-
-	go->input = input;
+	unsigned int input = go->input;
 
 	v4l2_subdev_call(go->sd_video, video, s_routing,
 			go->board_info->inputs[input].video_input, 0,
@@ -1117,6 +1081,20 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 			go->board_info->aud_inputs[aud_input].audio_input, 0, 0);
 		go->aud_input = aud_input;
 	}
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
+{
+	struct go7007 *go = video_drvdata(file);
+
+	if (input >= go->board_info->num_inputs)
+		return -EINVAL;
+	if (go->streaming)
+		return -EBUSY;
+
+	go->input = input;
+	go7007_s_input(go);
+
 	return 0;
 }
 
@@ -1125,12 +1103,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
-		return -EINVAL;
 	if (t->index != 0)
 		return -EINVAL;
-	if (!go->i2c_adapter_online)
-		return -EIO;
 
 	strlcpy(t->name, "Tuner", sizeof(t->name));
 	return call_all(&go->v4l2_dev, tuner, g_tuner, t);
@@ -1141,12 +1115,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
-		return -EINVAL;
 	if (t->index != 0)
 		return -EINVAL;
-	if (!go->i2c_adapter_online)
-		return -EIO;
 
 	switch (go->board_id) {
 	case GO7007_BOARDID_PX_TV402U_NA:
@@ -1165,12 +1135,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
+	if (f->tuner)
 		return -EINVAL;
-	if (!go->i2c_adapter_online)
-		return -EIO;
-
-	f->type = V4L2_TUNER_ANALOG_TV;
 
 	return call_all(&go->v4l2_dev, tuner, g_frequency, f);
 }
@@ -1180,10 +1146,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
+	if (f->tuner)
 		return -EINVAL;
-	if (!go->i2c_adapter_online)
-		return -EIO;
 
 	return call_all(&go->v4l2_dev, tuner, s_frequency, f);
 }
@@ -1730,17 +1694,42 @@ int go7007_v4l2_init(struct go7007 *go)
 	set_bit(V4L2_FL_USE_FH_PRIO, &go->video_dev->flags);
 	video_set_drvdata(go->video_dev, go);
 	go->video_dev->v4l2_dev = &go->v4l2_dev;
-	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
-	if (rv < 0) {
-		video_device_release(go->video_dev);
-		go->video_dev = NULL;
-		return rv;
+	if (!v4l2_device_has_op(&go->v4l2_dev, video, querystd))
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_QUERYSTD);
+	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER)) {
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_TUNER);
+	} else {
+		struct v4l2_frequency f = {
+			.type = V4L2_TUNER_ANALOG_TV,
+			.frequency = 980,
+		};
+
+		call_all(&go->v4l2_dev, tuner, s_frequency, &f);
+	}
+	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV)) {
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_STD);
+		go->video_dev->tvnorms = 0;
 	}
+	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING)
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUM_FRAMESIZES);
 	if (go->board_info->num_aud_inputs == 0) {
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_AUDIO);
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_AUDIO);
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUMAUDIO);
 	}
+	go7007_s_input(go);
+	if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
+		go7007_s_std(go);
+	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
+	if (rv < 0) {
+		video_device_release(go->video_dev);
+		go->video_dev = NULL;
+		return rv;
+	}
 	dev_info(go->dev, "registered device %s [v4l2]\n",
 		 video_device_node_name(go->video_dev));
 
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 5899513..cb36427 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -354,18 +354,13 @@ static int s2250_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	u16 vidsource;
 
 	vidsource = (state->input == 1) ? 0x040 : 0x020;
-	switch (norm) {
-	case V4L2_STD_NTSC:
-		write_regs_fp(client, vid_regs_fp);
-		write_reg_fp(client, 0x20, vidsource | 1);
-		break;
-	case V4L2_STD_PAL:
+	if (norm & V4L2_STD_625_50) {
 		write_regs_fp(client, vid_regs_fp);
 		write_regs_fp(client, vid_regs_fp_pal);
 		write_reg_fp(client, 0x20, vidsource);
-		break;
-	default:
-		return -EINVAL;
+	} else {
+		write_regs_fp(client, vid_regs_fp);
+		write_reg_fp(client, 0x20, vidsource | 1);
 	}
 	state->std = norm;
 	return 0;
-- 
1.7.10.4

