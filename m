Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38878 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbaLANLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:11:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] media: drivers shouldn't touch debug field in video_device
Date: Mon,  1 Dec 2014 14:10:43 +0100
Message-Id: <1417439445-34862-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
References: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The debug field in struct video_device is for internal use only and
drivers should mix that with their own debug module options.

It is handled by the V4L2 core and users can set it using
/sys/class/video4linux/<devX>/debug.

It has been deprecated for some time now, so it is time to remove it
completely from the drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c           |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c         |  3 ---
 drivers/media/platform/marvell-ccic/mcam-core.c |  1 -
 drivers/media/usb/cx231xx/cx231xx-video.c       |  1 -
 drivers/media/usb/em28xx/em28xx-video.c         |  1 -
 drivers/media/usb/stk1160/stk1160-v4l.c         |  5 -----
 drivers/media/usb/stkwebcam/stk-webcam.c        |  1 -
 drivers/media/usb/tlg2300/pd-common.h           |  1 -
 drivers/media/usb/tlg2300/pd-radio.c            |  3 ---
 drivers/media/usb/tlg2300/pd-video.c            | 10 ----------
 drivers/media/usb/tm6000/tm6000-video.c         |  3 +--
 drivers/media/usb/zr364xx/zr364xx.c             |  2 --
 12 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 665e46d..6eed8f7 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3884,7 +3884,6 @@ static struct video_device *vdev_init(struct bttv *btv,
 	*vfd = *template;
 	vfd->v4l2_dev = &btv->c.v4l2_dev;
 	vfd->release = video_device_release;
-	vfd->debug   = bttv_debug;
 	video_set_drvdata(vfd, btv);
 	snprintf(vfd->name, sizeof(vfd->name), "BT%d%s %s (%s)",
 		 btv->id, (btv->id==848 && btv->revision==0x12) ? "A" : "",
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 4160ca4..a785db9 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1236,6 +1236,3 @@ static void __exit blackbird_fini(void)
 
 module_init(blackbird_init);
 module_exit(blackbird_fini);
-
-module_param_named(video_debug,cx8802_mpeg_template.debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages [video]");
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index ce00cba..d4abca5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1932,7 +1932,6 @@ int mccic_register(struct mcam_camera *cam)
 
 	mutex_lock(&cam->s_mutex);
 	cam->vdev = mcam_v4l_template;
-	cam->vdev.debug = 0;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	video_set_drvdata(&cam->vdev, cam);
 	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 53ca12c..ecea76f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2062,7 +2062,6 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	*vfd = *template;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
-	vfd->debug = video_debug;
 	vfd->lock = &dev->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 03d5ece..08d5b4d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2189,7 +2189,6 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 
 	*vfd		= *template;
 	vfd->v4l2_dev	= &dev->v4l2->v4l2_dev;
-	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
 	if (dev->board.is_webcam)
 		vfd->tvnorms = 0;
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a476291..65a326c 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -38,10 +38,6 @@
 #include "stk1160.h"
 #include "stk1160-reg.h"
 
-static unsigned int vidioc_debug;
-module_param(vidioc_debug, int, 0644);
-MODULE_PARM_DESC(vidioc_debug, "enable debug messages [vidioc]");
-
 static bool keep_buffers;
 module_param(keep_buffers, bool, 0644);
 MODULE_PARM_DESC(keep_buffers, "don't release buffers upon stop streaming");
@@ -659,7 +655,6 @@ int stk1160_video_register(struct stk1160 *dev)
 
 	/* Initialize video_device with a template structure */
 	dev->vdev = v4l_template;
-	dev->vdev.debug = vidioc_debug;
 	dev->vdev.queue = &dev->vb_vidq;
 
 	/*
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 3588dc3..e08fa58 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1262,7 +1262,6 @@ static int stk_register_video_device(struct stk_camera *dev)
 
 	dev->vdev = stk_v4l_data;
 	dev->vdev.lock = &dev->lock;
-	dev->vdev.debug = debug;
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index 9e23ad32..04c5aac 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -250,7 +250,6 @@ void free_all_urb_generic(struct urb **urb_array, int num);
 /* misc */
 void poseidon_delete(struct kref *kref);
 extern int debug_mode;
-void set_debug_mode(struct video_device *vfd, int debug_mode);
 
 #ifdef CONFIG_PM
 #define in_hibernation(pd) (pd->msg.event == PM_EVENT_FREEZE)
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index b391194..c0567b5 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -98,12 +98,9 @@ static int poseidon_fm_open(struct file *filp)
 
 	usb_autopm_get_interface(p->interface);
 	if (0 == p->state) {
-		struct video_device *vfd = &p->radio_data.fm_dev;
-
 		/* default pre-emphasis */
 		if (p->radio_data.pre_emphasis == 0)
 			p->radio_data.pre_emphasis = TLG_TUNE_ASTD_FM_EUR;
-		set_debug_mode(vfd, debug_mode);
 
 		ret = poseidon_check_mode_radio(p);
 		if (ret < 0) {
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 8cd7f02..c0c3c1c 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1299,15 +1299,6 @@ static int pm_video_resume(struct poseidon *pd)
 }
 #endif
 
-void set_debug_mode(struct video_device *vfd, int debug_mode)
-{
-	vfd->debug = 0;
-	if (debug_mode & 0x1)
-		vfd->debug = V4L2_DEBUG_IOCTL;
-	if (debug_mode & 0x2)
-		vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
-}
-
 static void init_video_context(struct running_context *context)
 {
 	context->sig_index	= 0;
@@ -1354,7 +1345,6 @@ static int pd_video_open(struct file *file)
 
 		front->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		pd->video_data.users++;
-		set_debug_mode(vfd, debug_mode);
 
 		videobuf_queue_vmalloc_init(&front->q, &pd_video_qops,
 				NULL, &front->queue_lock,
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 793577f..0f14d3c 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -941,7 +941,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 	if (NULL == fmt) {
-		dprintk(dev, V4L2_DEBUG_IOCTL_ARG, "Fourcc format (0x%08x)"
+		dprintk(dev, 2, "Fourcc format (0x%08x)"
 				" invalid.\n", f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
@@ -1622,7 +1622,6 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
 	*vfd = *template;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
-	vfd->debug = tm6000_debug;
 	vfd->lock = &dev->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 5c00627..ca85031 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1454,8 +1454,6 @@ static int zr364xx_probe(struct usb_interface *intf,
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	cam->vdev.ctrl_handler = &cam->ctrl_handler;
 	video_set_drvdata(&cam->vdev, cam);
-	if (debug)
-		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
 
 	cam->udev = udev;
 
-- 
2.1.3

