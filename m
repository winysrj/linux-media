Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([67.18.52.6]:55528 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753518AbZIRVKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 17:10:01 -0400
Received: from [66.15.212.169] (port=30669 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi74-0002fM-L3
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:18 -0500
Subject: [PATCH 4/9] go7007: Merge struct gofh and go declarations
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:22 -0700
Message-Id: <1253298202.4314.568.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The declarations for struct go7007_file *gofh and struct go7007 *go can
be merged when gofh isn't used by the function.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r e9801d1d9c6c -r c130a089bdfc linux/drivers/staging/go7007/go7007-v4l2.c
--- a/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:26:12 2009 -0700
+++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:28:27 2009 -0700
@@ -593,8 +593,7 @@
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	strlcpy(cap->driver, "go7007", sizeof(cap->driver));
 	strlcpy(cap->card, go->name, sizeof(cap->card));
@@ -641,8 +640,7 @@
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *fmt)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->fmt.pix.width = go->width;
@@ -660,8 +658,7 @@
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *fmt)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	return set_capture_size(go, fmt, 1);
 }
@@ -669,8 +666,7 @@
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *fmt)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (go->streaming)
 		return -EBUSY;
@@ -976,8 +972,7 @@
 static int vidioc_queryctrl(struct file *file, void *priv,
 			   struct v4l2_queryctrl *query)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (!go->i2c_adapter_online)
 		return -EIO;
@@ -990,8 +985,7 @@
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 	struct v4l2_queryctrl query;
 
 	if (!go->i2c_adapter_online)
@@ -1010,8 +1004,7 @@
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 	struct v4l2_queryctrl query;
 
 	if (!go->i2c_adapter_online)
@@ -1030,8 +1023,7 @@
 static int vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 	struct v4l2_fract timeperframe = {
 		.numerator = 1001 *  go->fps_scale,
 		.denominator = go->sensor_framerate,
@@ -1049,8 +1041,7 @@
 static int vidioc_s_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 	unsigned int n, d;
 
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1082,8 +1073,7 @@
 static int vidioc_enum_framesizes(struct file *filp, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	/* Return -EINVAL, if it is a TV board */
 	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
@@ -1103,8 +1093,7 @@
 static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	/* Return -EINVAL, if it is a TV board */
 	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) ||
@@ -1123,8 +1112,7 @@
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (go->streaming)
 		return -EBUSY;
@@ -1188,8 +1176,7 @@
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (inp->index >= go->board_info->num_inputs)
 		return -EINVAL;
@@ -1218,8 +1205,7 @@
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *input)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	*input = go->input;
 
@@ -1228,8 +1214,7 @@
 
 static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (input >= go->board_info->num_inputs)
 		return -EINVAL;
@@ -1250,8 +1235,7 @@
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
 		return -EINVAL;
@@ -1269,8 +1253,7 @@
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
 		return -EINVAL;
@@ -1296,8 +1279,7 @@
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
 		return -EINVAL;
@@ -1312,8 +1294,7 @@
 static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER))
 		return -EINVAL;
@@ -1328,8 +1309,7 @@
 static int vidioc_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cropcap)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1373,8 +1353,7 @@
 
 static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;


