Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47735 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753642AbZKCQdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 11:33:22 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 03 Nov 2009 17:33:23 +0100
From: p.wiesner@gmx.net
Message-ID: <20091103163323.46300@gmx.net>
MIME-Version: 1.0
Subject: [PATCH] Adding multiple input support to soc-camera and tw9910
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Philipp Wiesner <p.wiesner@gmx.net>
# Date 1257265069 -3600
# Node ID a5254e7d306a8c1f50aaa7c6e97a4bae236bfd1a
# Parent  43878f8dbfb0ad732883efcc3525f868b337e9a2
Added enum_input, g_input & s_input to soc-camera and tw9910

From: Philipp Wiesner <p.wiesner@gmx.net>

soc-camera.c:
soc_camera_enum_input: capable of handling multiple inputs.
soc_camera_g_input: calls icd's g_input if present.
soc_camera_s_input: calls icd's s_input if present.
tw9910.c
tw9910_enum_input: now does what it's supposed to.
tw9910_g_input: reads current input from register INFORM
tw9910_s_input: writes requested input to register INFORM
soc_camera_ops: added g_input and s_input aliases. I'm not sure if there is a
reason the input functions are not usable with v4l2_subdev_ops. Added them to
soc_camera_ops for now because enum_input was already defined there.
soc-camera.h:
struct soc_camera_ops: Added aliases for g_input and s_input functions here.

Priority: normal

Signed-off-by: Philipp Wiesner <p.wiesner@gmx.net>

diff -r 43878f8dbfb0 -r a5254e7d306a linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c	Sun Nov 01 07:17:46 2009 -0200
+++ b/linux/drivers/media/video/soc_camera.c	Tue Nov 03 17:17:49 2009 +0100
@@ -119,11 +119,10 @@
 	struct soc_camera_device *icd = icf->icd;
 	int ret = 0;
 
-	if (inp->index != 0)
-		return -EINVAL;
-
 	if (icd->ops->enum_input)
 		ret = icd->ops->enum_input(icd, inp);
+	else if (inp->index != 0)
+		return -EINVAL;
 	else {
 		/* default is camera */
 		inp->type = V4L2_INPUT_TYPE_CAMERA;
@@ -136,17 +135,30 @@
 
 static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	int ret = 0;
 
-	return 0;
+	if (icd->ops->g_input)
+		ret = icd->ops->g_input(icd, i);
+	else
+		*i = 0;
+
+	return ret;
 }
 
 static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
 {
-	if (i > 0)
+	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = icf->icd;
+	int ret = 0;
+
+	if (icd->ops->s_input)
+		ret = icd->ops->s_input(icd, i);
+	else if (i > 0)
 		return -EINVAL;
 
-	return 0;
+	return ret;
 }
 
 static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
diff -r 43878f8dbfb0 -r a5254e7d306a linux/drivers/media/video/tw9910.c
--- a/linux/drivers/media/video/tw9910.c	Sun Nov 01 07:17:46 2009 -0200
+++ b/linux/drivers/media/video/tw9910.c	Tue Nov 03 17:17:49 2009 +0100
@@ -566,9 +566,47 @@
 static int tw9910_enum_input(struct soc_camera_device *icd,
 			     struct v4l2_input *inp)
 {
-	inp->type = V4L2_INPUT_TYPE_TUNER;
-	inp->std  = V4L2_STD_UNKNOWN;
-	strcpy(inp->name, "Video");
+	switch (inp->index) {
+	case 0:
+		strcpy(inp->name, "Video Input 1");
+		break;
+	case 1:
+		strcpy(inp->name, "Video Input 2");
+		break;
+	case 2:
+		strcpy(inp->name, "Video Input 3");
+		break;
+	case 3:
+		strcpy(inp->name, "Video Input 4");
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std  = V4L2_STD_625_50 | V4L2_STD_525_60;
+
+	return 0;
+}
+
+static int tw9910_g_input(struct soc_camera_device *icd, unsigned int *i)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+
+	*i = (i2c_smbus_read_byte_data(client, INFORM) & 0x0C) >> 2;
+
+	if (*i < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int tw9910_s_input(struct soc_camera_device *icd, unsigned int i)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+
+	if (tw9910_mask_set(client, INFORM, 0x0C, i << 2))
+		return -EINVAL;
 
 	return 0;
 }
@@ -906,6 +944,8 @@
 	.set_bus_param		= tw9910_set_bus_param,
 	.query_bus_param	= tw9910_query_bus_param,
 	.enum_input		= tw9910_enum_input,
+	.g_input		= tw9910_g_input,
+	.s_input		= tw9910_s_input,
 };
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
diff -r 43878f8dbfb0 -r a5254e7d306a linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h	Sun Nov 01 07:17:46 2009 -0200
+++ b/linux/include/media/soc_camera.h	Tue Nov 03 17:17:49 2009 +0100
@@ -197,6 +197,8 @@
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
+	int (*g_input)(struct soc_camera_device *, unsigned int *);
+	int (*s_input)(struct soc_camera_device *, unsigned int);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
 };
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
