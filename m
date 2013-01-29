Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4491 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3A2Qdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 19/20] cx231xx-417: share ioctls with cx231xx-video.
Date: Tue, 29 Jan 2013 17:33:12 +0100
Message-Id: <2a8284ff60ff73c06de16b20d8a1e9159161364e.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Share tuner, frequency, debug and input ioctls with cx231xx-video.
These are all shared resources, so no need to implement them again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   |  113 +++++++----------------------
 drivers/media/usb/cx231xx/cx231xx-video.c |   52 ++++++-------
 drivers/media/usb/cx231xx/cx231xx.h       |   15 ++++
 3 files changed, 67 insertions(+), 113 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2c05c8f..567d7ab 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
+#include <media/tuner.h>
 #include <linux/usb.h>
 
 #include "cx231xx.h"
@@ -1551,68 +1552,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 	return 0;
 }
 
-static const char * const iname[] = {
-	[CX231XX_VMUX_COMPOSITE1] = "Composite1",
-	[CX231XX_VMUX_SVIDEO]     = "S-Video",
-	[CX231XX_VMUX_TELEVISION] = "Television",
-	[CX231XX_VMUX_CABLE]      = "Cable TV",
-	[CX231XX_VMUX_DVB]        = "DVB",
-	[CX231XX_VMUX_DEBUG]      = "for debug only",
-};
-
-static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
-{
-	struct cx231xx_fh  *fh  = file->private_data;
-	struct cx231xx *dev = fh->dev;
-	struct cx231xx_input *input;
-	int n;
-	dprintk(3, "enter vidioc_enum_input()i->index=%d\n", i->index);
-
-	if (i->index >= 4)
-		return -EINVAL;
-
-	input = &cx231xx_boards[dev->model].input[i->index];
-
-	if (input->type == 0)
-		return -EINVAL;
-
-	/* FIXME
-	 * strcpy(i->name, input->name); */
-
-	n = i->index;
-	strcpy(i->name, iname[INPUT(n)->type]);
-
-	if (input->type == CX231XX_VMUX_TELEVISION ||
-	    input->type == CX231XX_VMUX_CABLE)
-		i->type = V4L2_INPUT_TYPE_TUNER;
-	else
-		i->type  = V4L2_INPUT_TYPE_CAMERA;
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return  0;
-}
-
-static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
-{
-	struct cx231xx_fh  *fh  = file->private_data;
-	struct cx231xx *dev = fh->dev;
-
-	dprintk(3, "enter vidioc_s_input() i=%d\n", i);
-
-	video_mux(dev, i);
-
-	if (i >= 4)
-		return -EINVAL;
-	dev->input = i;
-	dprintk(3, "exit vidioc_s_input()\n");
-	return 0;
-}
-
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctl)
 {
@@ -1831,22 +1770,12 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 
 static int mpeg_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
-	struct cx231xx *h, *dev = NULL;
-	/*struct list_head *list;*/
+	struct video_device *vdev = video_devdata(file);
+	struct cx231xx *dev = video_drvdata(file);
 	struct cx231xx_fh *fh;
-	/*u32 value = 0;*/
 
 	dprintk(2, "%s()\n", __func__);
 
-	list_for_each_entry(h, &cx231xx_devlist, devlist) {
-		if (h->v4l_device->minor == minor)
-			dev = h;
-	}
-
-	if (dev == NULL)
-		return -ENODEV;
-
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
 
@@ -1858,7 +1787,8 @@ static int mpeg_open(struct file *file)
 	}
 
 	file->private_data = fh;
-	fh->dev      = dev;
+	v4l2_fh_init(&fh->fh, vdev);
+	fh->dev = dev;
 
 
 	videobuf_queue_vmalloc_init(&fh->vidq, &cx231xx_qops,
@@ -1880,6 +1810,7 @@ static int mpeg_open(struct file *file)
 	cx231xx_initialize_codec(dev);
 
 	mutex_unlock(&dev->lock);
+	v4l2_fh_add(&fh->fh);
 	cx231xx_start_TS1(dev);
 
 	return 0;
@@ -1892,11 +1823,6 @@ static int mpeg_release(struct file *file)
 
 	dprintk(3, "mpeg_release()! dev=0x%p\n", dev);
 
-	if (!dev) {
-		dprintk(3, "abort!!!\n");
-		return 0;
-	}
-
 	mutex_lock(&dev->lock);
 
 	cx231xx_stop_TS1(dev);
@@ -1930,7 +1856,8 @@ static int mpeg_release(struct file *file)
 		videobuf_read_stop(&fh->vidq);
 
 	videobuf_mmap_free(&fh->vidq);
-	file->private_data = NULL;
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 	mutex_unlock(&dev->lock);
 	return 0;
@@ -1986,9 +1913,13 @@ static struct v4l2_file_operations mpeg_fops = {
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_g_std		 = vidioc_g_std,
-	.vidioc_enum_input	 = vidioc_enum_input,
-	.vidioc_g_input		 = vidioc_g_input,
-	.vidioc_s_input		 = vidioc_s_input,
+	.vidioc_g_tuner          = cx231xx_g_tuner,
+	.vidioc_s_tuner          = cx231xx_s_tuner,
+	.vidioc_g_frequency      = cx231xx_g_frequency,
+	.vidioc_s_frequency      = cx231xx_s_frequency,
+	.vidioc_enum_input	 = cx231xx_enum_input,
+	.vidioc_g_input		 = cx231xx_g_input,
+	.vidioc_s_input		 = cx231xx_s_input,
 	.vidioc_s_ctrl		 = vidioc_s_ctrl,
 	.vidioc_querycap	 = cx231xx_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
@@ -2007,10 +1938,10 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_querymenu	 = vidioc_querymenu,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-/*	.vidioc_g_chip_ident	 = cx231xx_g_chip_ident,*/
+	.vidioc_g_chip_ident	 = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-/*	.vidioc_g_register	 = cx231xx_g_register,*/
-/*	.vidioc_s_register	 = cx231xx_s_register,*/
+	.vidioc_g_register	 = cx231xx_g_register,
+	.vidioc_s_register	 = cx231xx_s_register,
 #endif
 };
 
@@ -2055,6 +1986,14 @@ static struct video_device *cx231xx_video_dev_alloc(
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->lock = &dev->lock;
 	vfd->release = video_device_release;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	video_set_drvdata(vfd, dev);
+	if (dev->tuner_type == TUNER_ABSENT) {
+		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
+	}
 
 	return vfd;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index d097009..2530b02 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1036,7 +1036,7 @@ static const char *iname[] = {
 	[CX231XX_VMUX_DEBUG]      = "for debug only",
 };
 
-static int vidioc_enum_input(struct file *file, void *priv,
+int cx231xx_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *i)
 {
 	struct cx231xx_fh *fh = priv;
@@ -1076,7 +1076,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+int cx231xx_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -1086,7 +1086,7 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+int cx231xx_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -1115,7 +1115,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
+int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -1139,7 +1139,7 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
+int cx231xx_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -1157,7 +1157,7 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int vidioc_g_frequency(struct file *file, void *priv,
+int cx231xx_g_frequency(struct file *file, void *priv,
 			      struct v4l2_frequency *f)
 {
 	struct cx231xx_fh *fh = priv;
@@ -1171,7 +1171,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
+int cx231xx_s_frequency(struct file *file, void *priv,
 			      struct v4l2_frequency *f)
 {
 	struct cx231xx_fh *fh = priv;
@@ -1227,7 +1227,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return rc;
 }
 
-static int vidioc_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip)
+int cx231xx_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip)
 {
 	chip->ident = V4L2_IDENT_NONE;
 	chip->revision = 0;
@@ -1254,7 +1254,7 @@ static int vidioc_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip
   if type == i2caddr, then <chip> is the 7-bit I2C address
 */
 
-static int vidioc_g_register(struct file *file, void *priv,
+int cx231xx_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
 {
 	struct cx231xx_fh *fh = priv;
@@ -1401,7 +1401,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 	return ret;
 }
 
-static int vidioc_s_register(struct file *file, void *priv,
+int cx231xx_s_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
 {
 	struct cx231xx_fh *fh = priv;
@@ -1809,7 +1809,7 @@ static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx *dev = ((struct cx231xx_fh *)priv)->dev;
 
-	if (0 != t->index)
+	if (t->index)
 		return -EINVAL;
 
 	call_all(dev, tuner, s_tuner, t);
@@ -2199,19 +2199,19 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf                  = vidioc_dqbuf,
 	.vidioc_s_std                  = vidioc_s_std,
 	.vidioc_g_std                  = vidioc_g_std,
-	.vidioc_enum_input             = vidioc_enum_input,
-	.vidioc_g_input                = vidioc_g_input,
-	.vidioc_s_input                = vidioc_s_input,
+	.vidioc_enum_input             = cx231xx_enum_input,
+	.vidioc_g_input                = cx231xx_g_input,
+	.vidioc_s_input                = cx231xx_s_input,
 	.vidioc_streamon               = vidioc_streamon,
 	.vidioc_streamoff              = vidioc_streamoff,
-	.vidioc_g_tuner                = vidioc_g_tuner,
-	.vidioc_s_tuner                = vidioc_s_tuner,
-	.vidioc_g_frequency            = vidioc_g_frequency,
-	.vidioc_s_frequency            = vidioc_s_frequency,
-	.vidioc_g_chip_ident           = vidioc_g_chip_ident,
+	.vidioc_g_tuner                = cx231xx_g_tuner,
+	.vidioc_s_tuner                = cx231xx_s_tuner,
+	.vidioc_g_frequency            = cx231xx_g_frequency,
+	.vidioc_s_frequency            = cx231xx_s_frequency,
+	.vidioc_g_chip_ident           = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register             = vidioc_g_register,
-	.vidioc_s_register             = vidioc_s_register,
+	.vidioc_g_register             = cx231xx_g_register,
+	.vidioc_s_register             = cx231xx_s_register,
 #endif
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -2238,12 +2238,12 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap    = cx231xx_querycap,
 	.vidioc_g_tuner     = radio_g_tuner,
 	.vidioc_s_tuner     = radio_s_tuner,
-	.vidioc_g_frequency = vidioc_g_frequency,
-	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_g_chip_ident = vidioc_g_chip_ident,
+	.vidioc_g_frequency = cx231xx_g_frequency,
+	.vidioc_s_frequency = cx231xx_s_frequency,
+	.vidioc_g_chip_ident = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register  = vidioc_g_register,
-	.vidioc_s_register  = vidioc_s_register,
+	.vidioc_g_register  = cx231xx_g_register,
+	.vidioc_s_register  = cx231xx_s_register,
 #endif
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index efc0d1c..6130e4f 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -936,6 +936,21 @@ void cx231xx_init_extension(struct cx231xx *dev);
 void cx231xx_close_extension(struct cx231xx *dev);
 int cx231xx_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap);
+int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
+int cx231xx_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
+int cx231xx_g_frequency(struct file *file, void *priv,
+			      struct v4l2_frequency *f);
+int cx231xx_s_frequency(struct file *file, void *priv,
+			      struct v4l2_frequency *f);
+int cx231xx_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *i);
+int cx231xx_g_input(struct file *file, void *priv, unsigned int *i);
+int cx231xx_s_input(struct file *file, void *priv, unsigned int i);
+int cx231xx_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip);
+int cx231xx_g_register(struct file *file, void *priv,
+			     struct v4l2_dbg_register *reg);
+int cx231xx_s_register(struct file *file, void *priv,
+			     struct v4l2_dbg_register *reg);
 
 /* Provided by cx231xx-cards.c */
 extern void cx231xx_pre_card_setup(struct cx231xx *dev);
-- 
1.7.10.4

