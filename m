Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1491 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2GBOPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 10:15:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] radio-cadet: upgrade to latest frameworks.
Date: Mon,  2 Jul 2012 16:15:10 +0200
Message-Id: <6de66fd499efc6ca83dc0a311df1d97d80fff9ae.1341237775.git.hans.verkuil@cisco.com>
In-Reply-To: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com>
References: <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- add control framework
- use core locking
- use V4L2_TUNER_CAP_LOW
- remove volume support: there is no hardware volume control

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-cadet.c |  243 +++++++++++++------------------------
 1 file changed, 83 insertions(+), 160 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 16a089f..93536b7 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -41,6 +41,9 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 MODULE_AUTHOR("Fred Gleason, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the ADS Cadet AM/FM/RDS radio card.");
@@ -61,8 +64,8 @@ module_param(radio_nr, int, 0);
 struct cadet {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	int io;
-	int users;
 	int curtuner;
 	int tunestat;
 	int sigstrength;
@@ -94,11 +97,9 @@ static int cadet_getstereo(struct cadet *dev)
 	if (dev->curtuner != 0)	/* Only FM has stereo capability! */
 		return V4L2_TUNER_SUB_MONO;
 
-	mutex_lock(&dev->lock);
 	outb(7, dev->io);          /* Select tuner control */
 	if ((inb(dev->io + 1) & 0x40) == 0)
 		ret = V4L2_TUNER_SUB_STEREO;
-	mutex_unlock(&dev->lock);
 	return ret;
 }
 
@@ -111,8 +112,6 @@ static unsigned cadet_gettune(struct cadet *dev)
 	 * Prepare for read
 	 */
 
-	mutex_lock(&dev->lock);
-
 	outb(7, dev->io);       /* Select tuner control */
 	curvol = inb(dev->io + 1); /* Save current volume/mute setting */
 	outb(0x00, dev->io + 1);  /* Ensure WRITE-ENABLE is LOW */
@@ -134,8 +133,6 @@ static unsigned cadet_gettune(struct cadet *dev)
 	 * Restore volume/mute setting
 	 */
 	outb(curvol, dev->io + 1);
-	mutex_unlock(&dev->lock);
-
 	return fifo;
 }
 
@@ -161,7 +158,7 @@ static unsigned cadet_getfreq(struct cadet *dev)
 			fifo = fifo >> 1;
 		}
 		freq -= 10700000;           /* IF frequency is 10.7 MHz */
-		freq = (freq * 16) / 1000000;   /* Make it 1/16 MHz */
+		freq = (freq * 16) / 1000;   /* Make it 1/16 kHz */
 	}
 	if (dev->curtuner == 1)    /* AM */
 		freq = ((fifo & 0x7fff) - 2010) * 16;
@@ -174,8 +171,6 @@ static void cadet_settune(struct cadet *dev, unsigned fifo)
 	int i;
 	unsigned test;
 
-	mutex_lock(&dev->lock);
-
 	outb(7, dev->io);                /* Select tuner control */
 	/*
 	 * Write the shift register
@@ -194,7 +189,6 @@ static void cadet_settune(struct cadet *dev, unsigned fifo)
 		test = 0x1c | ((fifo >> 23) & 0x02);
 		outb(test, dev->io + 1);
 	}
-	mutex_unlock(&dev->lock);
 }
 
 static void cadet_setfreq(struct cadet *dev, unsigned freq)
@@ -209,7 +203,7 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	fifo = 0;
 	if (dev->curtuner == 0) {    /* FM */
 		test = 102400;
-		freq = (freq * 1000) / 16;       /* Make it kHz */
+		freq = freq / 16;       /* Make it kHz */
 		freq += 10700;               /* IF is 10700 kHz */
 		for (i = 0; i < 14; i++) {
 			fifo = fifo << 1;
@@ -229,10 +223,8 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	 * Save current volume/mute setting
 	 */
 
-	mutex_lock(&dev->lock);
 	outb(7, dev->io);                /* Select tuner control */
 	curvol = inb(dev->io + 1);
-	mutex_unlock(&dev->lock);
 
 	/*
 	 * Tune the card
@@ -240,10 +232,8 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	for (j = 3; j > -1; j--) {
 		cadet_settune(dev, fifo | (j << 16));
 
-		mutex_lock(&dev->lock);
 		outb(7, dev->io);         /* Select tuner control */
 		outb(curvol, dev->io + 1);
-		mutex_unlock(&dev->lock);
 
 		msleep(100);
 
@@ -257,32 +247,6 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 }
 
 
-static int cadet_getvol(struct cadet *dev)
-{
-	int ret = 0;
-
-	mutex_lock(&dev->lock);
-
-	outb(7, dev->io);                /* Select tuner control */
-	if ((inb(dev->io + 1) & 0x20) != 0)
-		ret = 0xffff;
-
-	mutex_unlock(&dev->lock);
-	return ret;
-}
-
-
-static void cadet_setvol(struct cadet *dev, int vol)
-{
-	mutex_lock(&dev->lock);
-	outb(7, dev->io);                /* Select tuner control */
-	if (vol > 0)
-		outb(0x20, dev->io + 1);
-	else
-		outb(0x00, dev->io + 1);
-	mutex_unlock(&dev->lock);
-}
-
 static void cadet_handler(unsigned long data)
 {
 	struct cadet *dev = (void *)data;
@@ -337,18 +301,19 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 		add_timer(&dev->readtimer);
 	}
 	if (dev->rdsin == dev->rdsout) {
-		mutex_unlock(&dev->lock);
-		if (file->f_flags & O_NONBLOCK)
-			return -EWOULDBLOCK;
+		if (file->f_flags & O_NONBLOCK) {
+			i = -EWOULDBLOCK;
+			goto unlock;
+		}
 		interruptible_sleep_on(&dev->read_queue);
-		mutex_lock(&dev->lock);
 	}
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
-	mutex_unlock(&dev->lock);
 
 	if (copy_to_user(data, readbuf, i))
-		return -EFAULT;
+		i = -EFAULT;
+unlock:
+	mutex_unlock(&dev->lock);
 	return i;
 }
 
@@ -359,8 +324,9 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "ADS Cadet", sizeof(v->driver));
 	strlcpy(v->card, "ADS Cadet", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
 			  V4L2_CAP_READWRITE | V4L2_CAP_RDS_CAPTURE;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -374,20 +340,11 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	case 0:
 		strlcpy(v->name, "FM", sizeof(v->name));
 		v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
-			V4L2_TUNER_CAP_RDS_BLOCK_IO;
-		v->rangelow = 1400;     /* 87.5 MHz */
-		v->rangehigh = 1728;    /* 108.0 MHz */
+			V4L2_TUNER_CAP_RDS_BLOCK_IO | V4L2_TUNER_CAP_LOW;
+		v->rangelow = 1400000;     /* 87.5 MHz */
+		v->rangehigh = 1728000;    /* 108.0 MHz */
 		v->rxsubchans = cadet_getstereo(dev);
-		switch (v->rxsubchans) {
-		case V4L2_TUNER_SUB_MONO:
-			v->audmode = V4L2_TUNER_MODE_MONO;
-			break;
-		case V4L2_TUNER_SUB_STEREO:
-			v->audmode = V4L2_TUNER_MODE_STEREO;
-			break;
-		default:
-			break;
-		}
+		v->audmode = V4L2_TUNER_MODE_STEREO;
 		v->rxsubchans |= V4L2_TUNER_SUB_RDS;
 		break;
 	case 1:
@@ -408,11 +365,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct cadet *dev = video_drvdata(file);
-
 	if (v->index != 0 && v->index != 1)
 		return -EINVAL;
-	dev->curtuner = v->index;
 	return 0;
 }
 
@@ -421,7 +375,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct cadet *dev = video_drvdata(file);
 
-	f->tuner = dev->curtuner;
+	if (f->tuner > 1)
+		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = cadet_getfreq(dev);
 	return 0;
@@ -435,101 +390,52 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	if (f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	if (dev->curtuner == 0 && (f->frequency < 1400 || f->frequency > 1728))
-		return -EINVAL;
-	if (dev->curtuner == 1 && (f->frequency < 8320 || f->frequency > 26400))
+	if (f->tuner == 0) {
+		if (f->frequency < 1400000)
+			f->frequency = 1400000;
+		else if (f->frequency > 1728000)
+			f->frequency = 1728000;
+	} else if (f->tuner == 1) {
+		if (f->frequency < 8320)
+			f->frequency = 8320;
+		else if (f->frequency > 26400)
+			f->frequency = 26400;
+	} else
 		return -EINVAL;
 	cadet_setfreq(dev, f->frequency);
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
+static int cadet_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 0xff, 1, 0xff);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct cadet *dev = video_drvdata(file);
+	struct cadet *dev = container_of(ctrl->handler, struct cadet, ctrl_handler);
 
 	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE: /* TODO: Handle this correctly */
-		ctrl->value = (cadet_getvol(dev) == 0);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = cadet_getvol(dev);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct cadet *dev = video_drvdata(file);
-
-	switch (ctrl->id){
-	case V4L2_CID_AUDIO_MUTE: /* TODO: Handle this correctly */
-		if (ctrl->value)
-			cadet_setvol(dev, 0);
+	case V4L2_CID_AUDIO_MUTE:
+		outb(7, dev->io);                /* Select tuner control */
+		if (ctrl->val)
+			outb(0x00, dev->io + 1);
 		else
-			cadet_setvol(dev, 0xffff);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		cadet_setvol(dev, ctrl->value);
-		break;
-	default:
-		return -EINVAL;
+			outb(0x20, dev->io + 1);
+		return 0;
 	}
-	return 0;
-}
-
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-				struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-				struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
+	return -EINVAL;
 }
 
 static int cadet_open(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
+	int err;
 
 	mutex_lock(&dev->lock);
-	dev->users++;
-	if (1 == dev->users)
+	err = v4l2_fh_open(file);
+	if (err)
+		goto fail;
+	if (v4l2_fh_is_singular_file(file))
 		init_waitqueue_head(&dev->read_queue);
+fail:
 	mutex_unlock(&dev->lock);
-	return 0;
+	return err;
 }
 
 static int cadet_release(struct file *file)
@@ -537,11 +443,11 @@ static int cadet_release(struct file *file)
 	struct cadet *dev = video_drvdata(file);
 
 	mutex_lock(&dev->lock);
-	dev->users--;
-	if (0 == dev->users) {
+	if (v4l2_fh_is_singular_file(file) && dev->rdsstat) {
 		del_timer_sync(&dev->readtimer);
 		dev->rdsstat = 0;
 	}
+	v4l2_fh_release(file);
 	mutex_unlock(&dev->lock);
 	return 0;
 }
@@ -549,11 +455,12 @@ static int cadet_release(struct file *file)
 static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct cadet *dev = video_drvdata(file);
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	poll_wait(file, &dev->read_queue, wait);
 	if (dev->rdsin != dev->rdsout)
-		return POLLIN | POLLRDNORM;
-	return 0;
+		res |= POLLIN | POLLRDNORM;
+	return res;
 }
 
 
@@ -572,13 +479,13 @@ static const struct v4l2_ioctl_ops cadet_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ctrl_ops cadet_ctrl_ops = {
+	.s_ctrl = cadet_s_ctrl,
 };
 
 #ifdef CONFIG_PNP
@@ -648,7 +555,8 @@ static int __init cadet_init(void)
 {
 	struct cadet *dev = &cadet_card;
 	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
-	int res;
+	struct v4l2_ctrl_handler *hdl;
+	int res = -ENODEV;
 
 	strlcpy(v4l2_dev->name, "cadet", sizeof(v4l2_dev->name));
 	mutex_init(&dev->lock);
@@ -680,23 +588,37 @@ static int __init cadet_init(void)
 		goto fail;
 	}
 
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 2);
+	v4l2_ctrl_new_std(hdl, &cadet_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	v4l2_dev->ctrl_handler = hdl;
+	if (hdl->error) {
+		res = hdl->error;
+		v4l2_err(v4l2_dev, "Could not register controls\n");
+		goto err_hdl;
+	}
+
 	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
 	dev->vdev.v4l2_dev = v4l2_dev;
 	dev->vdev.fops = &cadet_fops;
 	dev->vdev.ioctl_ops = &cadet_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
+	dev->vdev.lock = &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 	video_set_drvdata(&dev->vdev, dev);
 
-	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(dev->io, 2);
-		goto fail;
-	}
+	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
+		goto err_hdl;
 	v4l2_info(v4l2_dev, "ADS Cadet Radio Card at 0x%x\n", dev->io);
 	return 0;
+err_hdl:
+	v4l2_ctrl_handler_free(hdl);
+	v4l2_device_unregister(v4l2_dev);
+	release_region(dev->io, 2);
 fail:
 	pnp_unregister_driver(&cadet_pnp_driver);
-	return -ENODEV;
+	return res;
 }
 
 static void __exit cadet_exit(void)
@@ -704,6 +626,7 @@ static void __exit cadet_exit(void)
 	struct cadet *dev = &cadet_card;
 
 	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	release_region(dev->io, 2);
 	pnp_unregister_driver(&cadet_pnp_driver);
-- 
1.7.10

