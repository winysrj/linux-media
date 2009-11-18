Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52685 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbZKRAiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Remove unneeded video_device::minor assignments
Date: Wed, 18 Nov 2009 01:38:50 +0100
Message-Id: <1258504731-8430-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the video_device registration is tested using
video_is_registered(), drivers don't need to initialize the
video_device::minor field to -1 anymore.

Remove those unneeded assignments.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2277,7 +2277,6 @@ static const struct video_device cx231xx
 	.fops         = &cx231xx_v4l_fops,
 	.release      = video_device_release,
 	.ioctl_ops    = &video_ioctl_ops,
-	.minor        = -1,
 	.tvnorms      = V4L2_STD_ALL,
 	.current_norm = V4L2_STD_PAL,
 };
@@ -2312,7 +2311,6 @@ static struct video_device cx231xx_radio
 	.name      = "cx231xx-radio",
 	.fops      = &radio_fops,
 	.ioctl_ops = &radio_ioctl_ops,
-	.minor     = -1,
 };
 
 /******************************** usb interface ******************************/
@@ -2328,7 +2326,6 @@ static struct video_device *cx231xx_vdev
 		return NULL;
 
 	*vfd = *template;
-	vfd->minor = -1;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -353,7 +353,6 @@ static struct video_device *cx23885_vdev
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor = -1;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
@@ -1636,7 +1635,6 @@ static struct video_device cx23885_vbi_t
 static struct video_device cx23885_video_template = {
 	.name                 = "cx23885-video",
 	.fops                 = &video_fops,
-	.minor                = -1,
 	.ioctl_ops 	      = &video_ioctl_ops,
 	.tvnorms              = CX23885_NORMS,
 	.current_norm         = V4L2_STD_NTSC_M,
@@ -1669,7 +1667,6 @@ static struct video_device cx23885_radio
 	.name                 = "cx23885-radio",
 	.fops                 = &radio_fops,
 	.ioctl_ops 	      = &radio_ioctl_ops,
-	.minor                = -1,
 };
 #endif
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2462,8 +2462,6 @@ static const struct video_device em28xx_
 	.release                    = video_device_release,
 	.ioctl_ops 		    = &video_ioctl_ops,
 
-	.minor                      = -1,
-
 	.tvnorms                    = V4L2_STD_ALL,
 	.current_norm               = V4L2_STD_PAL,
 };
@@ -2498,7 +2496,6 @@ static struct video_device em28xx_radio_
 	.name                 = "em28xx-radio",
 	.fops                 = &radio_fops,
 	.ioctl_ops 	      = &radio_ioctl_ops,
-	.minor                = -1,
 };
 
 /******************************** usb interface ******************************/
@@ -2516,7 +2513,6 @@ static struct video_device *em28xx_vdev_
 		return NULL;
 
 	*vfd		= *template;
-	vfd->minor	= -1;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvision/usbvision-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
@@ -1328,7 +1328,6 @@ static struct video_device usbvision_vid
 	.ioctl_ops 	= &usbvision_ioctl_ops,
 	.name           = "usbvision-video",
 	.release	= video_device_release,
-	.minor		= -1,
 	.tvnorms              = USBVISION_NORMS,
 	.current_norm         = V4L2_STD_PAL
 };
@@ -1362,7 +1361,6 @@ static struct video_device usbvision_rad
 	.fops		= &usbvision_radio_fops,
 	.name           = "usbvision-radio",
 	.release	= video_device_release,
-	.minor		= -1,
 	.ioctl_ops 	= &usbvision_radio_ioctl_ops,
 
 	.tvnorms              = USBVISION_NORMS,
@@ -1382,7 +1380,6 @@ static struct video_device usbvision_vbi
 	.fops		= &usbvision_vbi_fops,
 	.release	= video_device_release,
 	.name           = "usbvision-vbi",
-	.minor		= -1,
 };
 
 
@@ -1404,7 +1401,6 @@ static struct video_device *usbvision_vd
 		return NULL;
 	}
 	*vdev = *vdev_template;
-//	vdev->minor   = -1;
 	vdev->v4l2_dev = &usbvision->v4l2_dev;
 	snprintf(vdev->name, sizeof(vdev->name), "%s", name);
 	video_set_drvdata(vdev, usbvision);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -1657,7 +1657,6 @@ static int uvc_register_video(struct uvc
 	 * get another one.
 	 */
 	vdev->parent = &dev->intf->dev;
-	vdev->minor = -1;
 	vdev->fops = &uvc_fops;
 	vdev->release = uvc_release;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
@@ -184,7 +184,6 @@ struct video_device *cx25821_vdev_init(s
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor = -1;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name, type,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/au0828/au0828-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/au0828/au0828-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/au0828/au0828-video.c
@@ -1577,7 +1577,6 @@ static const struct video_device au0828_
 	.fops                       = &au0828_v4l_fops,
 	.release                    = video_device_release,
 	.ioctl_ops 		    = &video_ioctl_ops,
-	.minor                      = -1,
 	.tvnorms                    = V4L2_STD_NTSC_M,
 	.current_norm               = V4L2_STD_NTSC_M,
 };
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -3426,7 +3426,6 @@ static const struct v4l2_ioctl_ops bttv_
 
 static struct video_device bttv_video_template = {
 	.fops         = &bttv_fops,
-	.minor        = -1,
 	.ioctl_ops    = &bttv_ioctl_ops,
 	.tvnorms      = BTTV_NORMS,
 	.current_norm = V4L2_STD_PAL,
@@ -3670,7 +3669,6 @@ static const struct v4l2_ioctl_ops radio
 
 static struct video_device radio_template = {
 	.fops      = &radio_fops,
-	.minor     = -1,
 	.ioctl_ops = &radio_ioctl_ops,
 };
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/omap24xxcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
@@ -1660,7 +1660,6 @@ static int omap24xxcam_device_register(s
 
 	strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
 	vfd->fops		 = &omap24xxcam_fops;
-	vfd->minor		 = -1;
 	vfd->ioctl_ops		 = &omap24xxcam_ioctl_fops;
 
 	omap24xxcam_hwinit(cam);
@@ -1671,7 +1670,6 @@ static int omap24xxcam_device_register(s
 
 	if (video_register_device(vfd, VFL_TYPE_GRABBER, video_nr) < 0) {
 		dev_err(cam->dev, "could not register V4L device\n");
-		vfd->minor = -1;
 		rval = -EBUSY;
 		goto err;
 	}
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stk-webcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stk-webcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stk-webcam.c
@@ -1308,7 +1308,6 @@ static void stk_v4l_dev_release(struct v
 
 static struct video_device stk_v4l_data = {
 	.name = "stkwebcam",
-	.minor = -1,
 	.tvnorms = V4L2_STD_UNKNOWN,
 	.current_norm = V4L2_STD_UNKNOWN,
 	.fops = &v4l_stk_fops,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stv680.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stv680.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stv680.c
@@ -1410,7 +1410,6 @@ static struct video_device stv680_templa
 	.name =		"STV0680 USB camera",
 	.fops =         &stv680_fops,
 	.release =	video_device_release,
-	.minor = 	-1,
 };
 
 static int stv680_probe (struct usb_interface *intf, const struct usb_device_id *id)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/arv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/arv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/arv.c
@@ -772,7 +772,6 @@ static struct video_device ar_template =
 	.name		= "Colour AR VGA",
 	.fops		= &ar_fops,
 	.release	= ar_release,
-	.minor		= -1,
 };
 
 #define ALIGN4(x)	((((int)(x)) & 0x3) == 0)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/ov511.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
@@ -4678,7 +4678,6 @@ static struct video_device vdev_template
 	.name =		"OV511 USB Camera",
 	.fops =		&ov511_fops,
 	.release =	video_device_release,
-	.minor =	-1,
 };
 
 /****************************************************************************
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa5246a.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa5246a.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa5246a.c
@@ -1042,7 +1042,6 @@ static struct video_device saa_template 
 	.name	  = "saa5246a",
 	.fops	  = &saa_fops,
 	.release  = video_device_release,
-	.minor    = -1,
 };
 
 static int saa5246a_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/zr364xx.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/zr364xx.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/zr364xx.c
@@ -1455,7 +1455,6 @@ static struct video_device zr364xx_templ
 	.fops = &zr364xx_fops,
 	.ioctl_ops = &zr364xx_ioctl_ops,
 	.release = video_device_release,
-	.minor = -1,
 };
 
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cafe_ccic.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cafe_ccic.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cafe_ccic.c
@@ -1724,7 +1724,6 @@ static const struct v4l2_ioctl_ops cafe_
 
 static struct video_device cafe_v4l_template = {
 	.name = "cafe",
-	.minor = -1, /* Get one dynamically */
 	.tvnorms = V4L2_STD_NTSC_M,
 	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cpia2/cpia2_v4l.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cpia2/cpia2_v4l.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1926,7 +1926,6 @@ static const struct v4l2_file_operations
 static struct video_device cpia2_template = {
 	/* I could not find any place for the old .initialize initializer?? */
 	.name=		"CPiA2 Camera",
-	.minor=		-1,
 	.fops=		&fops_template,
 	.release=	video_device_release,
 };
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-417.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
@@ -1728,7 +1728,6 @@ static struct video_device cx23885_mpeg_
 	.name          = "cx23885",
 	.fops          = &mpeg_fops,
 	.ioctl_ops     = &mpeg_ioctl_ops,
-	.minor         = -1,
 	.tvnorms       = CX23885_NORMS,
 	.current_norm  = V4L2_STD_NTSC_M,
 };
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -1229,7 +1229,6 @@ static struct video_device cx8802_mpeg_t
 	.name                 = "cx8802",
 	.fops                 = &mpeg_fops,
 	.ioctl_ops 	      = &mpeg_ioctl_ops,
-	.minor                = -1,
 	.tvnorms              = CX88_NORMS,
 	.current_norm         = V4L2_STD_NTSC_M,
 };
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
@@ -1990,7 +1990,6 @@ static struct video_device cx8800_vbi_te
 static struct video_device cx8800_video_template = {
 	.name                 = "cx8800-video",
 	.fops                 = &video_fops,
-	.minor                = -1,
 	.ioctl_ops 	      = &video_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
 	.current_norm         = V4L2_STD_NTSC_M,
@@ -2026,7 +2025,6 @@ static const struct v4l2_ioctl_ops radio
 static struct video_device cx8800_radio_template = {
 	.name                 = "cx8800-radio",
 	.fops                 = &radio_fops,
-	.minor                = -1,
 	.ioctl_ops 	      = &radio_ioctl_ops,
 };
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/meye.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/meye.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/meye.c
@@ -1686,7 +1686,6 @@ static struct video_device meye_template
 	.fops		= &meye_fops,
 	.ioctl_ops 	= &meye_ioctl_ops,
 	.release	= video_device_release,
-	.minor		= -1,
 };
 
 #ifdef CONFIG_PM
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/s2255drv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
@@ -1817,7 +1817,6 @@ static struct video_device template = {
 	.name = "s2255v",
 	.fops = &s2255_fops_v4l,
 	.ioctl_ops = &s2255_ioctl_ops,
-	.minor = -1,
 	.release = video_device_release,
 	.tvnorms = S2255_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stradis.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stradis.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stradis.c
@@ -1926,7 +1926,6 @@ static const struct v4l2_file_operations
 static struct video_device saa_template = {
 	.name = "SAA7146A",
 	.fops = &saa_fops,
-	.minor = -1,
 	.release = video_device_release_empty,
 };
 
@@ -1977,7 +1976,6 @@ static int __devinit configure_saa7146(s
 
 	saa->id = pdev->device;
 	saa->irq = pdev->irq;
-	saa->video_dev.minor = -1;
 	saa->saa7146_adr = pci_resource_start(pdev, 0);
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &saa->revision);
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/vicam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvideo/vicam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/vicam.c
@@ -1106,7 +1106,6 @@ static const struct v4l2_file_operations
 static struct video_device vicam_template = {
 	.name 		= "ViCam-based USB Camera",
 	.fops 		= &vicam_fops,
-	.minor 		= -1,
 	.release 	= video_device_release_empty,
 };
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/vino.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/vino.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/vino.c
@@ -4073,7 +4073,6 @@ static struct video_device vdev_template
 	.fops		= &vino_fops,
 	.ioctl_ops 	= &vino_ioctl_ops,
 	.tvnorms 	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
-	.minor		= -1,
 };
 
 static void vino_module_cleanup(int stage)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
@@ -1299,7 +1299,6 @@ static struct video_device vivi_template
 	.name		= "vivi",
 	.fops           = &vivi_fops,
 	.ioctl_ops 	= &vivi_ioctl_ops,
-	.minor		= -1,
 	.release	= video_device_release,
 
 	.tvnorms              = V4L2_STD_525_60,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gspca.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/gspca/gspca.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gspca.c
@@ -2007,7 +2007,6 @@ static struct video_device gspca_templat
 	.fops = &dev_fops,
 	.ioctl_ops = &dev_ioctl_ops,
 	.release = gspca_release,
-	.minor = -1,
 };
 
 /*
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/pwc/pwc-if.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/pwc/pwc-if.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/pwc/pwc-if.c
@@ -173,7 +173,6 @@ static struct video_device pwc_template 
 	.name =		"Philips Webcam",	/* Filled in later */
 	.release =	video_device_release,
 	.fops =         &pwc_fops,
-	.minor =        -1,
 };
 
 /***************************************************************************/
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-empress.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
@@ -481,7 +481,6 @@ static const struct v4l2_ioctl_ops ts_io
 static struct video_device saa7134_empress_template = {
 	.name          = "saa7134-empress",
 	.fops          = &ts_fops,
-	.minor	       = -1,
 	.ioctl_ops     = &ts_ioctl_ops,
 
 	.tvnorms			= SAA7134_NORMS,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
@@ -2502,7 +2502,6 @@ struct video_device saa7134_video_templa
 	.name				= "saa7134-video",
 	.fops				= &video_fops,
 	.ioctl_ops 			= &video_ioctl_ops,
-	.minor				= -1,
 	.tvnorms			= SAA7134_NORMS,
 	.current_norm			= V4L2_STD_PAL,
 };
@@ -2511,7 +2510,6 @@ struct video_device saa7134_radio_templa
 	.name			= "saa7134-radio",
 	.fops			= &radio_fops,
 	.ioctl_ops 		= &radio_ioctl_ops,
-	.minor			= -1,
 };
 
 int saa7134_video_init1(struct saa7134_dev *dev)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/zoran/zoran_driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/zoran/zoran_driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/zoran/zoran_driver.c
@@ -3395,6 +3395,5 @@ struct video_device zoran_template __dev
 	.ioctl_ops = &zoran_ioctl_ops,
 	.release = &zoran_vdev_release,
 	.tvnorms = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
-	.minor = -1
 };
 
Index: v4l-dvb-mc-uvc/linux/drivers/staging/go7007/go7007-v4l2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/go7007/go7007-v4l2.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/go7007/go7007-v4l2.c
@@ -1813,7 +1813,6 @@ static const struct v4l2_ioctl_ops video
 static struct video_device go7007_template = {
 	.name		= "go7007",
 	.fops		= &go7007_fops,
-	.minor		= -1,
 	.release	= go7007_vfl_release,
 	.ioctl_ops	= &video_ioctl_ops,
 	.tvnorms	= V4L2_STD_ALL,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/tm6000/tm6000-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
@@ -1563,7 +1563,6 @@ static struct video_device tm6000_templa
 	.name		= "tm6000",
 	.fops           = &tm6000_fops,
 	.ioctl_ops      = &video_ioctl_ops,
-	.minor		= -1,
 	.release	= video_device_release,
 	.tvnorms        = TM6000_STD,
 	.current_norm   = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-audups11.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
@@ -411,7 +411,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template11 = {
 	.name = "cx25821-audioupstream",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video0.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
@@ -428,7 +428,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template0 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video1.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
@@ -428,7 +428,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template1 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video2.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
@@ -430,7 +430,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template2 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video3.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
@@ -429,7 +429,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template3 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video4.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
@@ -428,7 +428,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template4 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video5.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
@@ -428,7 +428,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template5 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video6.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
@@ -428,7 +428,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template6 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video7.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
@@ -427,7 +427,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template7 = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-videoioctl.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
@@ -474,7 +474,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_videoioctl_template = {
 	.name = "cx25821-videoioctl",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups10.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
@@ -412,7 +412,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template10 = {
 	.name = "cx25821-upstream10",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups9.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
@@ -410,7 +410,6 @@ static const struct v4l2_ioctl_ops video
 struct video_device cx25821_video_template9 = {
 	.name = "cx25821-upstream9",
 	.fops = &video_fops,
-	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpfe_capture.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/davinci/vpfe_capture.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpfe_capture.c
@@ -1929,7 +1929,6 @@ static __init int vpfe_probe(struct plat
 	vfd->release		= video_device_release;
 	vfd->fops		= &vpfe_fops;
 	vfd->ioctl_ops		= &vpfe_ioctl_ops;
-	vfd->minor		= -1;
 	vfd->tvnorms		= 0;
 	vfd->current_norm	= V4L2_STD_PAL;
 	vfd->v4l2_dev 		= &vpfe_dev->v4l2_dev;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpif_display.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/davinci/vpif_display.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpif_display.c
@@ -1347,7 +1347,6 @@ static const struct v4l2_file_operations
 static struct video_device vpif_video_template = {
 	.name		= "vpif",
 	.fops		= &vpif_fops,
-	.minor		= -1,
 	.ioctl_ops	= &vpif_ioctl_ops,
 	.tvnorms	= DM646X_V4L2_STD,
 	.current_norm	= V4L2_STD_625_50,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/soc_camera.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/soc_camera.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/soc_camera.c
@@ -1269,7 +1269,6 @@ static int video_dev_create(struct soc_c
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
-	vdev->minor		= -1;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 
 	icd->vdev = vdev;
@@ -1292,8 +1291,7 @@ static int soc_camera_video_start(struct
 	    !icd->ops->set_bus_param)
 		return -EINVAL;
 
-	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER,
-				    icd->vdev->minor);
+	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		dev_err(&icd->dev, "video_register_device failed: %d\n", ret);
 		return ret;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/zc0301/zc0301_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/zc0301/zc0301_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/zc0301/zc0301_core.c
@@ -1992,7 +1992,6 @@ zc0301_usb_probe(struct usb_interface* i
 
 	strcpy(cam->v4ldev->name, "ZC0301[P] PC Camera");
 	cam->v4ldev->fops = &zc0301_fops;
-	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
 	cam->v4ldev->parent = &udev->dev;
 	video_set_drvdata(cam->v4ldev, cam);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/et61x251/et61x251_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/et61x251/et61x251_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/et61x251/et61x251_core.c
@@ -2591,7 +2591,6 @@ et61x251_usb_probe(struct usb_interface*
 
 	strcpy(cam->v4ldev->name, "ET61X[12]51 PC Camera");
 	cam->v4ldev->fops = &et61x251_fops;
-	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
 	cam->v4ldev->parent = &udev->dev;
 	video_set_drvdata(cam->v4ldev, cam);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/sn9c102/sn9c102_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/sn9c102/sn9c102_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/sn9c102/sn9c102_core.c
@@ -3335,7 +3335,6 @@ sn9c102_usb_probe(struct usb_interface* 
 
 	strcpy(cam->v4ldev->name, "SN9C1xx PC Camera");
 	cam->v4ldev->fops = &sn9c102_fops;
-	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
 	cam->v4ldev->parent = &udev->dev;
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/w9968cf.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
@@ -3501,7 +3501,6 @@ w9968cf_usb_probe(struct usb_interface* 
 
 	strcpy(cam->v4ldev->name, symbolic(camlist, mod_id));
 	cam->v4ldev->fops = &w9968cf_fops;
-	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
 	video_set_drvdata(cam->v4ldev, cam);
 	cam->v4ldev->v4l2_dev = &cam->v4l2_dev;
