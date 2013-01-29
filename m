Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:53037 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3A2KbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 05:31:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] meye: convert to the control framework
Date: Tue, 29 Jan 2013 11:30:38 +0100
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291130.38206.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch has been pending for a long time. I finally got around to posting
it. I've rebased it to for_v3.9.

It compiles fine, but since AFAIK nobody has the hardware I cannot test it.

Regards,

	Hans


Convert the meye driver to the control framework. Some private controls
have been replaced with standardized controls (SHARPNESS and JPEGQUAL).

The AGC control looks like it can be replaced by the AUTOGAIN control, but
it isn't a boolean so I do not know how to interpret it.

The FRAMERATE control looks like it can be replaced by S_PARM, but again,
without knowing how to interpret it I decided to leave it alone.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/meye/meye.c      |  278 ++++++++++++------------------------
 drivers/media/pci/meye/meye.h      |    2 +
 include/uapi/linux/meye.h          |    8 +-
 include/uapi/linux/v4l2-controls.h |    5 +
 4 files changed, 99 insertions(+), 194 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 3b39dea..7859c43 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -35,6 +35,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/delay.h>
@@ -865,7 +867,7 @@ static int meye_open(struct file *file)
 		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
 	kfifo_reset(&meye.grabq);
 	kfifo_reset(&meye.doneq);
-	return 0;
+	return v4l2_fh_open(file);
 }
 
 static int meye_release(struct file *file)
@@ -873,7 +875,7 @@ static int meye_release(struct file *file)
 	mchip_hic_stop();
 	mchip_dma_free();
 	clear_bit(0, &meye.in_use);
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static int meyeioc_g_params(struct meye_params *p)
@@ -1032,8 +1034,9 @@ static int vidioc_querycap(struct file *file, void *fh,
 	cap->version = (MEYE_DRIVER_MAJORVERSION << 8) +
 		       MEYE_DRIVER_MINORVERSION;
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
@@ -1063,191 +1066,50 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *fh,
-				struct v4l2_queryctrl *c)
-{
-	switch (c->id) {
-
-	case V4L2_CID_BRIGHTNESS:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Brightness");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_HUE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Hue");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Contrast");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_SATURATION:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Saturation");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_AGC:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Agc");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 48;
-		c->flags = 0;
-		break;
-	case V4L2_CID_MEYE_SHARPNESS:
-	case V4L2_CID_SHARPNESS:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Sharpness");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-
-		/* Continue to report legacy private SHARPNESS ctrl but
-		 * say it is disabled in preference to ctrl in the spec
-		 */
-		c->flags = (c->id == V4L2_CID_SHARPNESS) ? 0 :
-						V4L2_CTRL_FLAG_DISABLED;
-		break;
-	case V4L2_CID_PICTURE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Picture");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 0;
-		c->flags = 0;
-		break;
-	case V4L2_CID_JPEGQUAL:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "JPEG quality");
-		c->minimum = 0;
-		c->maximum = 10;
-		c->step = 1;
-		c->default_value = 8;
-		c->flags = 0;
-		break;
-	case V4L2_CID_FRAMERATE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Framerate");
-		c->minimum = 0;
-		c->maximum = 31;
-		c->step = 1;
-		c->default_value = 0;
-		c->flags = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+static int meye_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	mutex_lock(&meye.lock);
-	switch (c->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, c->value);
-		meye.brightness = c->value << 10;
+			SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, ctrl->val);
+		meye.brightness = ctrl->val << 10;
 		break;
 	case V4L2_CID_HUE:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAHUE, c->value);
-		meye.hue = c->value << 10;
+			SONY_PIC_COMMAND_SETCAMERAHUE, ctrl->val);
+		meye.hue = ctrl->val << 10;
 		break;
 	case V4L2_CID_CONTRAST:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERACONTRAST, c->value);
-		meye.contrast = c->value << 10;
+			SONY_PIC_COMMAND_SETCAMERACONTRAST, ctrl->val);
+		meye.contrast = ctrl->val << 10;
 		break;
 	case V4L2_CID_SATURATION:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERACOLOR, c->value);
-		meye.colour = c->value << 10;
+			SONY_PIC_COMMAND_SETCAMERACOLOR, ctrl->val);
+		meye.colour = ctrl->val << 10;
 		break;
-	case V4L2_CID_AGC:
+	case V4L2_CID_MEYE_AGC:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAAGC, c->value);
-		meye.params.agc = c->value;
+			SONY_PIC_COMMAND_SETCAMERAAGC, ctrl->val);
+		meye.params.agc = ctrl->val;
 		break;
 	case V4L2_CID_SHARPNESS:
-	case V4L2_CID_MEYE_SHARPNESS:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERASHARPNESS, c->value);
-		meye.params.sharpness = c->value;
+			SONY_PIC_COMMAND_SETCAMERASHARPNESS, ctrl->val);
+		meye.params.sharpness = ctrl->val;
 		break;
-	case V4L2_CID_PICTURE:
+	case V4L2_CID_MEYE_PICTURE:
 		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAPICTURE, c->value);
-		meye.params.picture = c->value;
+			SONY_PIC_COMMAND_SETCAMERAPICTURE, ctrl->val);
+		meye.params.picture = ctrl->val;
 		break;
-	case V4L2_CID_JPEGQUAL:
-		meye.params.quality = c->value;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		meye.params.quality = ctrl->val;
 		break;
-	case V4L2_CID_FRAMERATE:
-		meye.params.framerate = c->value;
-		break;
-	default:
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
-{
-	mutex_lock(&meye.lock);
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = meye.brightness >> 10;
-		break;
-	case V4L2_CID_HUE:
-		c->value = meye.hue >> 10;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->value = meye.contrast >> 10;
-		break;
-	case V4L2_CID_SATURATION:
-		c->value = meye.colour >> 10;
-		break;
-	case V4L2_CID_AGC:
-		c->value = meye.params.agc;
-		break;
-	case V4L2_CID_SHARPNESS:
-	case V4L2_CID_MEYE_SHARPNESS:
-		c->value = meye.params.sharpness;
-		break;
-	case V4L2_CID_PICTURE:
-		c->value = meye.params.picture;
-		break;
-	case V4L2_CID_JPEGQUAL:
-		c->value = meye.params.quality;
-		break;
-	case V4L2_CID_FRAMERATE:
-		c->value = meye.params.framerate;
+	case V4L2_CID_MEYE_FRAMERATE:
+		meye.params.framerate = ctrl->val;
 		break;
 	default:
 		mutex_unlock(&meye.lock);
@@ -1577,12 +1439,12 @@ static long vidioc_default(struct file *file, void *fh, bool valid_prio,
 
 static unsigned int meye_poll(struct file *file, poll_table *wait)
 {
-	unsigned int res = 0;
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	mutex_lock(&meye.lock);
 	poll_wait(file, &meye.proc_list, wait);
 	if (kfifo_len(&meye.doneq))
-		res = POLLIN | POLLRDNORM;
+		res |= POLLIN | POLLRDNORM;
 	mutex_unlock(&meye.lock);
 	return res;
 }
@@ -1669,9 +1531,6 @@ static const struct v4l2_ioctl_ops meye_ioctl_ops = {
 	.vidioc_enum_input	= vidioc_enum_input,
 	.vidioc_g_input		= vidioc_g_input,
 	.vidioc_s_input		= vidioc_s_input,
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
@@ -1682,6 +1541,9 @@ static const struct v4l2_ioctl_ops meye_ioctl_ops = {
 	.vidioc_dqbuf		= vidioc_dqbuf,
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
+	.vidioc_log_status	= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_default		= vidioc_default,
 };
 
@@ -1692,6 +1554,10 @@ static struct video_device meye_template = {
 	.release	= video_device_release,
 };
 
+static const struct v4l2_ctrl_ops meye_ctrl_ops = {
+	.s_ctrl = meye_s_ctrl,
+};
+
 #ifdef CONFIG_PM
 static int meye_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -1730,6 +1596,32 @@ static int meye_resume(struct pci_dev *pdev)
 
 static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 {
+	static const struct v4l2_ctrl_config ctrl_agc = {
+		.id = V4L2_CID_MEYE_AGC,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.ops = &meye_ctrl_ops,
+		.name = "AGC",
+		.max = 63,
+		.step = 1,
+		.def = 48,
+		.flags = V4L2_CTRL_FLAG_SLIDER,
+	};
+	static const struct v4l2_ctrl_config ctrl_picture = {
+		.id = V4L2_CID_MEYE_PICTURE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.ops = &meye_ctrl_ops,
+		.name = "Picture",
+		.max = 63,
+		.step = 1,
+	};
+	static const struct v4l2_ctrl_config ctrl_framerate = {
+		.id = V4L2_CID_MEYE_FRAMERATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.ops = &meye_ctrl_ops,
+		.name = "Framerate",
+		.max = 31,
+		.step = 1,
+	};
 	struct v4l2_device *v4l2_dev = &meye.v4l2_dev;
 	int ret = -EBUSY;
 	unsigned long mchip_adr;
@@ -1833,24 +1725,31 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	mutex_init(&meye.lock);
 	init_waitqueue_head(&meye.proc_list);
-	meye.brightness = 32 << 10;
-	meye.hue = 32 << 10;
-	meye.colour = 32 << 10;
-	meye.contrast = 32 << 10;
-	meye.params.subsample = 0;
-	meye.params.quality = 8;
-	meye.params.sharpness = 32;
-	meye.params.agc = 48;
-	meye.params.picture = 0;
-	meye.params.framerate = 0;
-
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAHUE, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACOLOR, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACONTRAST, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERASHARPNESS, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE, 0);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC, 48);
+
+	v4l2_ctrl_handler_init(&meye.hdl, 3);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 63, 1, 32);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_HUE, 0, 63, 1, 32);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 63, 1, 32);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_SATURATION, 0, 63, 1, 32);
+	v4l2_ctrl_new_custom(&meye.hdl, &ctrl_agc, NULL);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_SHARPNESS, 0, 63, 1, 32);
+	v4l2_ctrl_new_custom(&meye.hdl, &ctrl_picture, NULL);
+	v4l2_ctrl_new_std(&meye.hdl, &meye_ctrl_ops,
+			  V4L2_CID_JPEG_COMPRESSION_QUALITY, 0, 10, 1, 8);
+	v4l2_ctrl_new_custom(&meye.hdl, &ctrl_framerate, NULL);
+	if (meye.hdl.error) {
+		v4l2_err(v4l2_dev, "couldn't register controls\n");
+		goto outvideoreg;
+	}
+
+	v4l2_ctrl_handler_setup(&meye.hdl);
+	meye.vdev->ctrl_handler = &meye.hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &meye.vdev->flags);
 
 	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
 				  video_nr) < 0) {
@@ -1866,6 +1765,7 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	return 0;
 
 outvideoreg:
+	v4l2_ctrl_handler_free(&meye.hdl);
 	free_irq(meye.mchip_irq, meye_irq);
 outreqirq:
 	iounmap(meye.mchip_mmregs);
diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
index 4bdeb03..6fed927 100644
--- a/drivers/media/pci/meye/meye.h
+++ b/drivers/media/pci/meye/meye.h
@@ -39,6 +39,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kfifo.h>
+#include <media/v4l2-ctrls.h>
 
 /****************************************************************************/
 /* Motion JPEG chip registers                                               */
@@ -290,6 +291,7 @@ struct meye_grab_buffer {
 /* Motion Eye device structure */
 struct meye {
 	struct v4l2_device v4l2_dev;	/* Main v4l2_device struct */
+	struct v4l2_ctrl_handler hdl;
 	struct pci_dev *mchip_dev;	/* pci device */
 	u8 mchip_irq;			/* irq */
 	u8 mchip_mode;			/* actual mchip mode: HIC_MODE... */
diff --git a/include/uapi/linux/meye.h b/include/uapi/linux/meye.h
index 0dd4995..8ff50fe 100644
--- a/include/uapi/linux/meye.h
+++ b/include/uapi/linux/meye.h
@@ -57,10 +57,8 @@ struct meye_params {
 #define MEYEIOC_STILLJCAPT	_IOR ('v', BASE_VIDIOC_PRIVATE+5, int)
 
 /* V4L2 private controls */
-#define V4L2_CID_AGC		V4L2_CID_PRIVATE_BASE
-#define V4L2_CID_MEYE_SHARPNESS	(V4L2_CID_PRIVATE_BASE + 1)
-#define V4L2_CID_PICTURE	(V4L2_CID_PRIVATE_BASE + 2)
-#define V4L2_CID_JPEGQUAL	(V4L2_CID_PRIVATE_BASE + 3)
-#define V4L2_CID_FRAMERATE	(V4L2_CID_PRIVATE_BASE + 4)
+#define V4L2_CID_MEYE_AGC		(V4L2_CID_USER_MEYE_BASE + 0)
+#define V4L2_CID_MEYE_PICTURE		(V4L2_CID_USER_MEYE_BASE + 1)
+#define V4L2_CID_MEYE_FRAMERATE		(V4L2_CID_USER_MEYE_BASE + 2)
 
 #endif
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 4dc0822..d67f9b2 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -140,6 +140,11 @@ enum v4l2_colorfx {
 /* last CID + 1 */
 #define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
 
+/* USER-class private control IDs */
+
+/* The base for the meye driver controls. See linux/meye.h for the list
+ * of controls. We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
 
 /* MPEG-class control IDs */
 
-- 
1.7.10.4

