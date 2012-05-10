Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2839 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab2EJHF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 03:05:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/5] v4l2-dev: add flag to have the core lock all file operations.
Date: Thu, 10 May 2012 09:05:14 +0200
Message-Id: <67416de571ea793e612f65501fa7499deb31283d.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
References: <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This used to be the default if the lock pointer was set, but now that lock is by
default only used for ioctl serialization. Those drivers that already used
core locking have this flag set explicitly, except for some drivers where
it was obvious that there was no need to serialize any file operations other
than ioctl.

The drivers that didn't need this flag were:

drivers/media/radio/dsbr100.c
drivers/media/radio/radio-isa.c
drivers/media/radio/radio-keene.c
drivers/media/radio/radio-miropcm20.c
drivers/media/radio/radio-mr800.c
drivers/media/radio/radio-tea5764.c
drivers/media/radio/radio-timb.c
drivers/media/video/vivi.c
sound/i2c/other/tea575x-tuner.c

The other drivers that use core locking and where it was not immediately
obvious that this flag wasn't needed were changed so that the flag is set
together with a comment that that driver needs work to avoid having to
set that flag. This will often involve taking the core lock in the fops
themselves.

Eventually this flag should go and it should not be used in new drivers.

There are a few reasons why we want to avoid core locking of non-ioctl
fops: in the case of mmap this can lead to a deadlock in rare situations
since when mmap is called the mmap_sem is held and it is possible for
other parts of the code to take that lock as well (copy_from_user()/copy_to_user()
perform a down_read(&mm->mmap_sem) when a page fault occurs).

It is very unlikely that that happens since the core lock serializes all
fops, but the kernel warns about it if lock validation is turned on.

For poll it is also undesirable to take the core lock as that can introduce
increased latency. The same is true for read/write.

While it was possible to make flags or something to turn on/off taking the
core lock for each file operation, in practice it is much simpler to just
not take it at all except for ioctl and leave it to the driver to take the
lock. There are only a handful fops compared to the zillion ioctls we have.

I also wanted to make it obvious which drivers still take the lock for all
fops, so that's why I chose to have drivers set it explicitly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c             |    4 +++
 drivers/media/radio/wl128x/fmdrv_v4l2.c         |    4 +++
 drivers/media/video/blackfin/bfin_capture.c     |    4 +++
 drivers/media/video/cpia2/cpia2_v4l.c           |    4 +++
 drivers/media/video/cx231xx/cx231xx-video.c     |    4 +++
 drivers/media/video/davinci/vpbe_display.c      |    4 +++
 drivers/media/video/davinci/vpif_capture.c      |    4 +++
 drivers/media/video/davinci/vpif_display.c      |    4 +++
 drivers/media/video/em28xx/em28xx-video.c       |    4 +++
 drivers/media/video/fsl-viu.c                   |    4 +++
 drivers/media/video/ivtv/ivtv-streams.c         |    4 +++
 drivers/media/video/mem2mem_testdev.c           |    4 +++
 drivers/media/video/mx2_emmaprp.c               |    4 +++
 drivers/media/video/s2255drv.c                  |    4 +++
 drivers/media/video/s5p-fimc/fimc-capture.c     |    4 +++
 drivers/media/video/s5p-fimc/fimc-core.c        |    4 +++
 drivers/media/video/s5p-g2d/g2d.c               |    4 +++
 drivers/media/video/s5p-jpeg/jpeg-core.c        |    8 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc.c           |    6 +++++
 drivers/media/video/s5p-tv/mixer_video.c        |    4 +++
 drivers/media/video/sh_vou.c                    |    4 +++
 drivers/media/video/soc_camera.c                |    4 +++
 drivers/media/video/tm6000/tm6000-video.c       |    4 +++
 drivers/media/video/usbvision/usbvision-video.c |    4 +++
 drivers/media/video/v4l2-dev.c                  |   32 ++++++++++++++---------
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |    4 +++
 include/media/v4l2-dev.h                        |    3 +++
 27 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 71f8e01..8d7df1a 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -511,6 +511,10 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	vfd->fops = &video_fops;
 	vfd->ioctl_ops = &dev->ext_vv_data->ops;
 	vfd->release = video_device_release;
+	/* Locking in file operations other than ioctl should be done by
+	   the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->v4l2_lock;
 	vfd->tvnorms = 0;
 	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 077d369..080b96a 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -518,6 +518,10 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	video_set_drvdata(gradio_dev, fmdev);
 
 	gradio_dev->lock = &fmdev->mutex;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &gradio_dev->flags);
 
 	/* Register with V4L2 subsystem as RADIO device */
 	if (video_register_device(gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
index 514fcf7..0aba45e 100644
--- a/drivers/media/video/blackfin/bfin_capture.c
+++ b/drivers/media/video/blackfin/bfin_capture.c
@@ -942,6 +942,10 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&bcap_dev->dma_queue);
 
 	vfd->lock = &bcap_dev->mutex;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	/* register video device */
 	ret = video_register_device(bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index bb4f1d0..55e9290 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1147,6 +1147,10 @@ int cpia2_register_camera(struct camera_data *cam)
 	cam->vdev.ctrl_handler = hdl;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &cam->vdev.flags);
 
 	reset_camera_struct_v4l(cam);
 
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 7f916f0..2a04558 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2561,6 +2561,10 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
 	vfd->lock = &dev->lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index 1f3b1c7..e106b72 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1618,6 +1618,10 @@ static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	vbd->ioctl_ops	= &vpbe_ioctl_ops;
 	vbd->minor	= -1;
 	vbd->v4l2_dev   = &disp_dev->vpbe_dev->v4l2_dev;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vbd->flags);
 	vbd->lock	= &vpbe_display_layer->opslock;
 
 	if (disp_dev->vpbe_dev->current_timings.timings_type &
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 6504e40..9604695 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2228,6 +2228,10 @@ static __init int vpif_probe(struct platform_device *pdev)
 		common = &(ch->common[VPIF_VIDEO_INDEX]);
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
+		/* Locking in file operations other than ioctl should be done
+		   by the driver, not the V4L2 core.
+		   This driver needs auditing so that this flag can be removed. */
+		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
 		ch->video_dev->lock = &common->lock;
 		/* Initialize prio member of channel object */
 		v4l2_prio_init(&ch->prio);
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 7fa34b4..e6488ee 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1778,6 +1778,10 @@ static __init int vpif_probe(struct platform_device *pdev)
 		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		/* Locking in file operations other than ioctl should be done
+		   by the driver, not the V4L2 core.
+		   This driver needs auditing so that this flag can be removed. */
+		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
 		ch->video_dev->lock = &common->lock;
 
 		/* register video device */
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index bcc4160..308a1dd 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2495,6 +2495,10 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
 		 dev->name, type_name);
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 27e3e0c..777486f 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1544,6 +1544,10 @@ static int __devinit viu_of_probe(struct platform_device *op)
 
 	/* initialize locks */
 	mutex_init(&viu_dev->lock);
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &viu_dev->vdev->flags);
 	viu_dev->vdev->lock = &viu_dev->lock;
 	spin_lock_init(&viu_dev->slock);
 
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 7ea5ca7..6738592 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -228,6 +228,10 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
 	s->vdev->lock = &itv->serialize_lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &s->vdev->flags);
 	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev->flags);
 	ivtv_set_funcs(s->vdev);
 	return 0;
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 12897e8..ee3efbd 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -958,6 +958,10 @@ static int m2mtest_probe(struct platform_device *pdev)
 	}
 
 	*vfd = m2mtest_videodev;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->dev_mutex;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 55ac173..0bd5815 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -904,6 +904,10 @@ static int emmaprp_probe(struct platform_device *pdev)
 	}
 
 	*vfd = emmaprp_videodev;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &pcdev->dev_mutex;
 
 	video_set_drvdata(vfd, pcdev);
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 37845de..ea974fa 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1948,6 +1948,10 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		/* register 4 video devices */
 		channel->vdev = template;
 		channel->vdev.lock = &dev->lock;
+		/* Locking in file operations other than ioctl should be done
+		   by the driver, not the V4L2 core.
+		   This driver needs auditing so that this flag can be removed. */
+		set_bit(V4L2_FL_LOCK_ALL_FOPS, &channel->vdev.flags);
 		channel->vdev.v4l2_dev = &dev->v4l2_dev;
 		video_set_drvdata(&channel->vdev, channel);
 		if (video_nr == -1)
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index dc18ba5..72d5150 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1516,6 +1516,10 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	video_set_drvdata(vfd, fimc);
 
 	vid_cap = &fimc->vid_cap;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7b90a89..c58dd9f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1520,6 +1520,10 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s.m2m", dev_name(&pdev->dev));
 	video_set_drvdata(vfd, fimc);
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..02605ce 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -762,6 +762,10 @@ static int g2d_probe(struct platform_device *pdev)
 		goto unreg_v4l2_dev;
 	}
 	*vfd = g2d_videodev;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->mutex;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 5a49c30..ecf7b0b 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -1386,6 +1386,10 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_encoder->release	= video_device_release;
 	jpeg->vfd_encoder->lock		= &jpeg->lock;
 	jpeg->vfd_encoder->v4l2_dev	= &jpeg->v4l2_dev;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &jpeg->vfd_encoder->flags);
 
 	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
@@ -1413,6 +1417,10 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_decoder->release	= video_device_release;
 	jpeg->vfd_decoder->lock		= &jpeg->lock;
 	jpeg->vfd_decoder->v4l2_dev	= &jpeg->v4l2_dev;
+	/* Locking in file operations other than ioctl should be done by the driver,
+	   not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &jpeg->vfd_decoder->flags);
 
 	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 83fe461..7600854 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -1048,6 +1048,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->ioctl_ops	= get_dec_v4l2_ioctl_ops();
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
 	dev->vfd_dec	= vfd;
@@ -1072,6 +1076,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
+	/* This should not be necessary */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
 	dev->vfd_enc	= vfd;
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..c0eadd7 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -1069,6 +1069,10 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 	set_bit(V4L2_FL_USE_FH_PRIO, &layer->vfd.flags);
 
 	video_set_drvdata(&layer->vfd, layer);
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &layer->vfd.flags);
 	layer->vfd.lock = &layer->mutex;
 	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
 
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 9644bd8..8fd1874 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -1390,6 +1390,10 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	vdev->v4l2_dev = &vou_dev->v4l2_dev;
 	vdev->release = video_device_release;
 	vdev->lock = &vou_dev->fop_lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
 
 	vou_dev->vdev = vdev;
 	video_set_drvdata(vdev, vou_dev);
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index eb25756..c27bb6d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1425,6 +1425,10 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 	vdev->ctrl_handler	= &icd->ctrl_handler;
 	vdev->lock		= &icd->video_lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
 
 	icd->vdev = vdev;
 
diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index 1ba26d5..375f26a 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -1731,6 +1731,10 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
 	vfd->release = video_device_release;
 	vfd->debug = tm6000_debug;
 	vfd->lock = &dev->lock;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 5a74f5e..9bd8f08 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1296,6 +1296,10 @@ static struct video_device *usbvision_vdev_init(struct usb_usbvision *usbvision,
 	if (NULL == vdev)
 		return NULL;
 	*vdev = *vdev_template;
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
 	vdev->lock = &usbvision->v4l2_lock;
 	vdev->v4l2_dev = &usbvision->v4l2_dev;
 	snprintf(vdev->name, sizeof(vdev->name), "%s", name);
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 4d98ee1..5b819c9 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -274,11 +274,12 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 
 	if (!vdev->fops->read)
 		return -EINVAL;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
+	    mutex_lock_interruptible(vdev->lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if (vdev->lock)
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
 	return ret;
 }
@@ -291,11 +292,12 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 
 	if (!vdev->fops->write)
 		return -EINVAL;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
+	    mutex_lock_interruptible(vdev->lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if (vdev->lock)
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
 	return ret;
 }
@@ -307,11 +309,11 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 
 	if (!vdev->fops->poll)
 		return DEFAULT_POLLMASK;
-	if (vdev->lock)
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_lock(vdev->lock);
 	if (video_is_registered(vdev))
 		ret = vdev->fops->poll(filp, poll);
-	if (vdev->lock)
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
 	return ret;
 }
@@ -399,11 +401,12 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 
 	if (!vdev->fops->mmap)
 		return ret;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
+	    mutex_lock_interruptible(vdev->lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->lock)
+	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
 	return ret;
 }
@@ -426,7 +429,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
 	if (vdev->fops->open) {
-		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
+		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
+		    mutex_lock_interruptible(vdev->lock)) {
 			ret = -ERESTARTSYS;
 			goto err;
 		}
@@ -434,7 +438,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = vdev->fops->open(filp);
 		else
 			ret = -ENODEV;
-		if (vdev->lock)
+		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_unlock(vdev->lock);
 	}
 
@@ -452,10 +456,10 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	int ret = 0;
 
 	if (vdev->fops->release) {
-		if (vdev->lock)
+		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_lock(vdev->lock);
 		vdev->fops->release(filp);
-		if (vdev->lock)
+		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_unlock(vdev->lock);
 	}
 	/* decrease the refcount unconditionally since the release()
@@ -831,6 +835,10 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	WARN_ON(video_device[vdev->minor] != NULL);
 	vdev->index = get_index(vdev);
 	mutex_unlock(&videodev_lock);
+	/* if no lock was passed, then make sure the LOCK_ALL_FOPS bit is
+	   clear and warn if it wasn't. */
+	if (vdev->lock == NULL)
+		WARN_ON(test_and_clear_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags));
 
 	determine_valid_ioctls(vdev);
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 280c84e..c365cdf 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -898,6 +898,10 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&pd->dmaq);
 	mutex_init(&pd->mux);
 	pd->vdev->lock = &pd->mux; /* for locking v4l2_file_operations */
+	/* Locking in file operations other than ioctl should be done
+	   by the driver, not the V4L2 core.
+	   This driver needs auditing so that this flag can be removed. */
+	set_bit(V4L2_FL_LOCK_ALL_FOPS, &pd->vdev->flags);
 	spin_lock_init(&pd->lock);
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 15e2fe4..9eb970b 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -39,6 +39,9 @@ struct v4l2_ctrl_handler;
 #define V4L2_FL_USES_V4L2_FH	(1)
 /* Use the prio field of v4l2_fh for core priority checking */
 #define V4L2_FL_USE_FH_PRIO	(2)
+/* If ioctl core locking is in use, then apply that also to all
+   file operations. */
+#define V4L2_FL_LOCK_ALL_FOPS	(3)
 
 /* Priority helper functions */
 
-- 
1.7.10

