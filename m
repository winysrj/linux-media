Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway10.websitewelcome.com ([67.18.1.14]:44371 "HELO
	gateway10.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751199AbZIRWXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 18:23:23 -0400
Received: from [66.15.212.169] (port=30671 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi78-0002hT-LL
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:22 -0500
Subject: [PATCH 5/9] go7007: Implement vidioc_g_std and vidioc_querystd
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:26 -0700
Message-Id: <1253298206.4314.569.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implemented the vidio_g_std and vidio_querystd ioctls.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r c130a089bdfc -r e227a099a9f2 linux/drivers/staging/go7007/go7007-v4l2.c
--- a/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:28:27 2009 -0700
+++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:37:01 2009 -0700
@@ -1110,6 +1110,24 @@
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
+
+	switch (go->standard) {
+	case GO7007_STD_NTSC:
+		*std = V4L2_STD_NTSC;
+		break;
+	case GO7007_STD_PAL:
+		*std = V4L2_STD_PAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
@@ -1154,24 +1172,22 @@
 	return 0;
 }
 
-#if 0 /* keep */
-	case VIDIOC_QUERYSTD:
-	{
-		v4l2_std_id *std = arg;
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
-		if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
-				go->input == go->board_info->num_inputs - 1) {
-			if (!go->i2c_adapter_online)
-				return -EIO;
-			i2c_clients_command(&go->i2c_adapter,
-						VIDIOC_QUERYSTD, arg);
-		} else if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
-			*std = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
-		else
-			*std = 0;
-		return 0;
-	}
-#endif
+	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
+			go->input == go->board_info->num_inputs - 1) {
+		if (!go->i2c_adapter_online)
+			return -EIO;
+		i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYSTD, std);
+	} else if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
+		*std = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
+	else
+		*std = 0;
+
+	return 0;
+}
 
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
@@ -1768,7 +1784,9 @@
 	.vidioc_querybuf          = vidioc_querybuf,
 	.vidioc_qbuf              = vidioc_qbuf,
 	.vidioc_dqbuf             = vidioc_dqbuf,
+	.vidioc_g_std             = vidioc_g_std,
 	.vidioc_s_std             = vidioc_s_std,
+	.vidioc_querystd          = vidioc_querystd,
 	.vidioc_enum_input        = vidioc_enum_input,
 	.vidioc_g_input           = vidioc_g_input,
 	.vidioc_s_input           = vidioc_s_input,


