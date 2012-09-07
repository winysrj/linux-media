Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2200 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab2IGN3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 25/28] Set vfl_dir for all display or m2m drivers.
Date: Fri,  7 Sep 2012 15:29:25 +0200
Message-Id: <4b07ee5a399746f4264f852f430dbbcae8a13b32.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-streams.c         |    3 +++
 drivers/media/pci/zoran/zoran_card.c          |    4 ++++
 drivers/media/platform/coda.c                 |    1 +
 drivers/media/platform/davinci/vpbe_display.c |    1 +
 drivers/media/platform/davinci/vpif_display.c |    1 +
 drivers/media/platform/m2m-deinterlace.c      |    1 +
 drivers/media/platform/mem2mem_testdev.c      |    1 +
 drivers/media/platform/mx2_emmaprp.c          |    1 +
 drivers/media/platform/omap/omap_vout.c       |    1 +
 drivers/media/platform/omap3isp/ispvideo.c    |    1 +
 drivers/media/platform/s5p-fimc/fimc-m2m.c    |    1 +
 drivers/media/platform/s5p-g2d/g2d.c          |    1 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |    1 +
 drivers/media/platform/s5p-tv/mixer_video.c   |    1 +
 drivers/media/platform/sh_vou.c               |    1 +
 drivers/media/usb/uvc/uvc_driver.c            |    2 ++
 17 files changed, 23 insertions(+)

diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index f08ec17..1d0e04a 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -223,6 +223,9 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 
 	s->vdev->num = num;
 	s->vdev->v4l2_dev = &itv->v4l2_dev;
+	if (ivtv_stream_info[type].buf_type == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    ivtv_stream_info[type].buf_type == V4L2_BUF_TYPE_VBI_OUTPUT)
+		s->vdev->vfl_dir = VFL_DIR_TX;
 	s->vdev->fops = ivtv_stream_info[type].fops;
 	s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
 	s->vdev->release = video_device_release;
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index c3602d6..fffc54b 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1055,6 +1055,10 @@ zr36057_init (struct zoran *zr)
 	memcpy(zr->video_dev, &zoran_template, sizeof(zoran_template));
 	zr->video_dev->parent = &zr->pci_dev->dev;
 	strcpy(zr->video_dev->name, ZR_DEVNAME(zr));
+	/* It's not a mem2mem device, but you can both capture and output from
+	   one and the same device. This should really be split up into two
+	   device nodes, but that's a job for another day. */
+	zr->video_dev->vfl_dir = VFL_DIR_M2M;
 	err = video_register_device(zr->video_dev, VFL_TYPE_GRABBER, video_nr[zr->id]);
 	if (err < 0)
 		goto exit_free;
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6908514..c483a6c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1641,6 +1641,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	dev->vfd.release	= video_device_release_empty,
 	dev->vfd.lock	= &dev->dev_mutex;
 	dev->vfd.v4l2_dev	= &dev->v4l2_dev;
+	dev->vfd.vfl_dir	= VFL_DIR_M2M;
 	snprintf(dev->vfd.name, sizeof(dev->vfd.name), "%s", CODA_NAME);
 	video_set_drvdata(&dev->vfd, dev);
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index c7e5fd9..ed30c71 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1634,6 +1634,7 @@ static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	vbd->minor	= -1;
 	vbd->v4l2_dev   = &disp_dev->vpbe_dev->v4l2_dev;
 	vbd->lock	= &vpbe_display_layer->opslock;
+	vbd->vfl_dir	= VFL_DIR_TX;
 
 	if (disp_dev->vpbe_dev->current_timings.timings_type &
 			VPBE_ENC_STD) {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 4a24848..ff6e432 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1745,6 +1745,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		*vfd = vpif_video_template;
 		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
 		vfd->release = video_device_release;
+		vfd->vfl_dir = VFL_DIR_TX;
 		snprintf(vfd->name, sizeof(vfd->name),
 			 "VPIF_Display_DRIVER_V%s",
 			 VPIF_DISPLAY_VERSION);
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index a38c152..a534a9c 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -982,6 +982,7 @@ static struct video_device deinterlace_videodev = {
 	.ioctl_ops	= &deinterlace_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_M2M,
 };
 
 static struct v4l2_m2m_ops m2m_ops = {
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0b496f3..5b597b5 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -1000,6 +1000,7 @@ static const struct v4l2_file_operations m2mtest_fops = {
 
 static struct video_device m2mtest_videodev = {
 	.name		= MEM2MEM_NAME,
+	.vfl_dir	= VFL_DIR_M2M,
 	.fops		= &m2mtest_fops,
 	.ioctl_ops	= &m2mtest_ioctl_ops,
 	.minor		= -1,
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index dab380a..63f0554 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -879,6 +879,7 @@ static struct video_device emmaprp_videodev = {
 	.ioctl_ops	= &emmaprp_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_M2M,
 };
 
 static struct v4l2_m2m_ops m2m_ops = {
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 36c3be8..196e516 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1951,6 +1951,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 
 	vfd->fops = &omap_vout_fops;
 	vfd->v4l2_dev = &vout->vid_dev->v4l2_dev;
+	vfd->vfl_dir = VFL_DIR_TX;
 	mutex_init(&vout->lock);
 
 	vfd->minor = -1;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a25aa1d..afa837c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1343,6 +1343,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		direction = "input";
 		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		video->video.vfl_dir = VFL_DIR_TX;
 		break;
 
 	default:
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index b1681bd..6b1ef8a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -806,6 +806,7 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	vfd->minor = -1;
 	vfd->release = video_device_release;
 	vfd->lock = &fimc->lock;
+	vfd->vfl_dir = VFL_DIR_M2M;
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index c490f21..c638046 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -682,6 +682,7 @@ static struct video_device g2d_videodev = {
 	.ioctl_ops	= &g2d_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_M2M,
 };
 
 static struct v4l2_m2m_ops g2d_m2m_ops = {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 72c3e52..96a9b4f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1394,6 +1394,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_encoder->release	= video_device_release;
 	jpeg->vfd_encoder->lock		= &jpeg->lock;
 	jpeg->vfd_encoder->v4l2_dev	= &jpeg->v4l2_dev;
+	jpeg->vfd_encoder->vfl_dir	= VFL_DIR_M2M;
 
 	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e3e616d..0476be4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1048,6 +1048,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
+	vfd->vfl_dir	= VFL_DIR_M2M;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
 	dev->vfd_dec	= vfd;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index a9c6be3..bd42ea3 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -1081,6 +1081,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 		.minor = -1,
 		.release = mxr_vfd_release,
 		.fops = &mxr_fops,
+		.vfl_dir = VFL_DIR_TX,
 		.ioctl_ops = &mxr_ioctl_ops,
 	};
 	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 00cd52c..ba3de3e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1320,6 +1320,7 @@ static const struct video_device sh_vou_video_template = {
 	.ioctl_ops	= &sh_vou_ioctl_ops,
 	.tvnorms	= V4L2_STD_525_60, /* PAL only supported in 8-bit non-bt656 mode */
 	.current_norm	= V4L2_STD_NTSC_M,
+	.vfl_dir	= VFL_DIR_TX,
 };
 
 static int __devinit sh_vou_probe(struct platform_device *pdev)
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 45d7aa1..fd8e4d2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1734,6 +1734,8 @@ static int uvc_register_video(struct uvc_device *dev,
 	vdev->v4l2_dev = &dev->vdev;
 	vdev->fops = &uvc_fops;
 	vdev->release = uvc_release;
+	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		vdev->vfl_dir = VFL_DIR_TX;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
 
 	/* Set the driver data before calling video_register_device, otherwise
-- 
1.7.10.4

