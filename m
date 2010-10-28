Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:14163 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab0J1Gqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 02:46:38 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com, mkaricheri@gmail.com
Cc: hans.verkuil@tandberg.com, linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFCv2/PATCH 1/5] vpif_cap/disp: Add debug functionality
Date: Thu, 28 Oct 2010 08:46:19 +0200
Message-Id: <1288248383-12557-2-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
References: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

The following functions are added to the drivers:
    - vpif_g_chip_ident
    - vpif_dbg_g_register
    - vpif_dbg_s_register
    - vpif_log_status

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpif_capture.c |   83 +++++++++++++++++++++++++++
 drivers/media/video/davinci/vpif_display.c |   86 ++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 6ac6acd..3b5c98b 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
 
 #include "vpif_capture.h"
 #include "vpif.h"
@@ -1807,6 +1808,82 @@ static int vpif_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
+/*
+ * vpif_g_chip_ident() - Identify the chip
+ * @file: file ptr
+ * @priv: file handle
+ * @chip: chip identity
+ *
+ * Returns zero or -EINVAL if read operations fails.
+ */
+static int vpif_g_chip_ident(struct file *file, void *priv,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR) {
+		vpif_dbg(2, debug, "match_type is invalid.\n");
+		return -EINVAL;
+	}
+
+	return v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 0, core,
+			g_chip_ident, chip);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+/*
+ * vpif_dbg_g_register() - Read register
+ * @file: file ptr
+ * @priv: file handle
+ * @reg: register to be read
+ *
+ * Debugging only
+ * Returns zero or -EINVAL if read operations fails.
+ */
+static int vpif_dbg_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg){
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], core,
+			g_register, reg);
+}
+
+/*
+ * vpif_dbg_s_register() - Write to register
+ * @file: file ptr
+ * @priv: file handle
+ * @reg: register to be modified
+ *
+ * Debugging only
+ * Returns zero or -EINVAL if write operations fails.
+ */
+static int vpif_dbg_s_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg){
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+
+	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], core,
+			s_register, reg);
+}
+#endif
+
+/*
+ * vpif_log_status() - Status information
+ * @file: file ptr
+ * @priv: file handle
+ *
+ * Returns zero.
+ */
+static int vpif_log_status(struct file *filep, void *priv)
+{
+	/* status for sub devices */
+	v4l2_device_call_all(&vpif_obj.v4l2_dev, 0, core, log_status);
+
+	return 0;
+}
+
 /* vpif capture ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_querycap        	= vpif_querycap,
@@ -1829,6 +1906,12 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_streamon        	= vpif_streamon,
 	.vidioc_streamoff       	= vpif_streamoff,
 	.vidioc_cropcap         	= vpif_cropcap,
+	.vidioc_g_chip_ident		= vpif_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register		= vpif_dbg_g_register,
+	.vidioc_s_register		= vpif_dbg_s_register,
+#endif
+	.vidioc_log_status		= vpif_log_status,
 };
 
 /* vpif file operations */
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 685f6a6..57b206c 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -38,6 +38,7 @@
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
 
 #include <mach/dm646x.h>
 
@@ -1315,6 +1316,85 @@ static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
 	return v4l2_prio_change(&ch->prio, &fh->prio, p);
 }
 
+
+/*
+ * vpif_g_chip_ident() - Identify the chip
+ * @file: file ptr
+ * @priv: file handle
+ * @chip: chip identity
+ *
+ * Returns zero or -EINVAL if read operations fails.
+ */
+static int vpif_g_chip_ident(struct file *file, void *priv,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+			chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR) {
+		vpif_dbg(2, debug, "match_type is invalid.\n");
+		return -EINVAL;
+	}
+
+	return v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 0, core,
+			g_chip_ident, chip);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+/*
+ * vpif_dbg_g_register() - Read register
+ * @file: file ptr
+ * @priv: file handle
+ * @reg: register to be read
+ *
+ * Debugging only
+ * Returns zero or -EINVAL if read operations fails.
+ */
+static int vpif_dbg_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg){
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct video_obj *vid_ch = &ch->video;
+
+	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+			g_register, reg);
+}
+
+/*
+ * vpif_dbg_s_register() - Write to register
+ * @file: file ptr
+ * @priv: file handle
+ * @reg: register to be modified
+ *
+ * Debugging only
+ * Returns zero or -EINVAL if write operations fails.
+ */
+static int vpif_dbg_s_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg){
+	struct vpif_fh *fh = priv;
+	struct channel_obj *ch = fh->channel;
+	struct video_obj *vid_ch = &ch->video;
+
+	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+			s_register, reg);
+}
+#endif
+
+/*
+ * vpif_log_status() - Status information
+ * @file: file ptr
+ * @priv: file handle
+ *
+ * Returns zero.
+ */
+static int vpif_log_status(struct file *filep, void *priv)
+{
+	/* status for sub devices */
+	v4l2_device_call_all(&vpif_obj.v4l2_dev, 0, core, log_status);
+
+	return 0;
+}
+
 /* vpif display ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_querycap        	= vpif_querycap,
@@ -1336,6 +1416,12 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
 	.vidioc_cropcap         	= vpif_cropcap,
+	.vidioc_g_chip_ident		= vpif_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register		= vpif_dbg_g_register,
+	.vidioc_s_register		= vpif_dbg_s_register,
+#endif
+	.vidioc_log_status		= vpif_log_status,
 };
 
 static const struct v4l2_file_operations vpif_fops = {
-- 
1.7.1

