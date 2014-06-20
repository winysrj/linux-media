Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3872 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaFTHCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 03:02:00 -0400
Message-ID: <53A3DC49.8020002@xs4all.nl>
Date: Fri, 20 Jun 2014 09:01:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ramakrishnan Muthukrishnan <ram@fastmail.in>,
	linux-media@vger.kernel.org
CC: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: Re: [REVIEW PATCH 2/4] media: remove the setting of the flag V4L2_FL_USE_FH_PRIO.
References: <1403198580-3126-1-git-send-email-ram@fastmail.in> <1403198580-3126-3-git-send-email-ram@fastmail.in>
In-Reply-To: <1403198580-3126-3-git-send-email-ram@fastmail.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2014 07:22 PM, Ramakrishnan Muthukrishnan wrote:
> From: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
> 
> Since all the drivers that use `struct v4l2_fh' use the core
> priority checking, the setting of the flag in the drivers can
> be removed.
> 
> Signed-off-by: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/common/saa7146/saa7146_fops.c        | 1 -
>  drivers/media/parport/bw-qcam.c                    | 1 -
>  drivers/media/parport/c-qcam.c                     | 1 -
>  drivers/media/parport/pms.c                        | 1 -
>  drivers/media/parport/w9966.c                      | 1 -
>  drivers/media/pci/bt8xx/bttv-driver.c              | 1 -
>  drivers/media/pci/cx18/cx18-streams.c              | 1 -
>  drivers/media/pci/cx25821/cx25821-video.c          | 1 -
>  drivers/media/pci/cx88/cx88-core.c                 | 1 -
>  drivers/media/pci/ivtv/ivtv-streams.c              | 1 -
>  drivers/media/pci/meye/meye.c                      | 1 -
>  drivers/media/pci/saa7134/saa7134-core.c           | 1 -
>  drivers/media/pci/saa7134/saa7134-empress.c        | 1 -
>  drivers/media/pci/sta2x11/sta2x11_vip.c            | 1 -
>  drivers/media/platform/arv.c                       | 1 -
>  drivers/media/platform/blackfin/bfin_capture.c     | 1 -
>  drivers/media/platform/davinci/vpbe_display.c      | 1 -
>  drivers/media/platform/davinci/vpfe_capture.c      | 1 -
>  drivers/media/platform/davinci/vpif_capture.c      | 1 -
>  drivers/media/platform/davinci/vpif_display.c      | 1 -
>  drivers/media/platform/s3c-camif/camif-capture.c   | 1 -
>  drivers/media/platform/s5p-tv/mixer_video.c        | 2 --
>  drivers/media/platform/vivi.c                      | 1 -
>  drivers/media/radio/dsbr100.c                      | 1 -
>  drivers/media/radio/radio-cadet.c                  | 1 -
>  drivers/media/radio/radio-isa.c                    | 1 -
>  drivers/media/radio/radio-keene.c                  | 1 -
>  drivers/media/radio/radio-ma901.c                  | 1 -
>  drivers/media/radio/radio-miropcm20.c              | 1 -
>  drivers/media/radio/radio-mr800.c                  | 1 -
>  drivers/media/radio/radio-raremono.c               | 1 -
>  drivers/media/radio/radio-sf16fmi.c                | 1 -
>  drivers/media/radio/radio-si476x.c                 | 1 -
>  drivers/media/radio/radio-tea5764.c                | 1 -
>  drivers/media/radio/radio-tea5777.c                | 1 -
>  drivers/media/radio/radio-timb.c                   | 1 -
>  drivers/media/radio/si470x/radio-si470x-usb.c      | 1 -
>  drivers/media/radio/si4713/radio-platform-si4713.c | 1 -
>  drivers/media/radio/si4713/radio-usb-si4713.c      | 1 -
>  drivers/media/radio/tea575x.c                      | 1 -
>  drivers/media/usb/au0828/au0828-video.c            | 2 --
>  drivers/media/usb/cpia2/cpia2_v4l.c                | 1 -
>  drivers/media/usb/cx231xx/cx231xx-417.c            | 1 -
>  drivers/media/usb/cx231xx/cx231xx-video.c          | 1 -
>  drivers/media/usb/em28xx/em28xx-video.c            | 1 -
>  drivers/media/usb/gspca/gspca.c                    | 1 -
>  drivers/media/usb/hdpvr/hdpvr-video.c              | 1 -
>  drivers/media/usb/pwc/pwc-if.c                     | 1 -
>  drivers/media/usb/s2255/s2255drv.c                 | 1 -
>  drivers/media/usb/stk1160/stk1160-v4l.c            | 1 -
>  drivers/media/usb/stkwebcam/stk-webcam.c           | 1 -
>  drivers/media/usb/tlg2300/pd-radio.c               | 1 -
>  drivers/media/usb/tm6000/tm6000-video.c            | 1 -
>  drivers/media/usb/usbtv/usbtv-video.c              | 1 -
>  drivers/media/usb/uvc/uvc_driver.c                 | 1 -
>  drivers/media/usb/zr364xx/zr364xx.c                | 1 -
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    | 1 -
>  drivers/staging/media/go7007/go7007-v4l2.c         | 1 -
>  drivers/staging/media/msi3101/sdr-msi3101.c        | 1 -
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   | 1 -
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 1 -
>  drivers/staging/media/solo6x10/solo6x10-v4l2.c     | 1 -
>  62 files changed, 64 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
> index eda01bc..f2cc521 100644
> --- a/drivers/media/common/saa7146/saa7146_fops.c
> +++ b/drivers/media/common/saa7146/saa7146_fops.c
> @@ -613,7 +613,6 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
>  	vfd->lock = &dev->v4l2_lock;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
>  	vfd->tvnorms = 0;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
>  		vfd->tvnorms |= dev->ext_vv_data->stds[i].id;
>  	strlcpy(vfd->name, name, sizeof(vfd->name));
> diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
> index 416507a..3c5dac4 100644
> --- a/drivers/media/parport/bw-qcam.c
> +++ b/drivers/media/parport/bw-qcam.c
> @@ -990,7 +990,6 @@ static struct qcam *qcam_init(struct parport *port)
>  	qcam->vdev.fops = &qcam_fops;
>  	qcam->vdev.lock = &qcam->lock;
>  	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
>  	qcam->vdev.release = video_device_release_empty;
>  	video_set_drvdata(&qcam->vdev, qcam);
>  
> diff --git a/drivers/media/parport/c-qcam.c b/drivers/media/parport/c-qcam.c
> index ec51e1f..b9010bd 100644
> --- a/drivers/media/parport/c-qcam.c
> +++ b/drivers/media/parport/c-qcam.c
> @@ -761,7 +761,6 @@ static struct qcam *qcam_init(struct parport *port)
>  	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
>  	qcam->vdev.release = video_device_release_empty;
>  	qcam->vdev.ctrl_handler = &qcam->hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
>  	video_set_drvdata(&qcam->vdev, qcam);
>  
>  	mutex_init(&qcam->lock);
> diff --git a/drivers/media/parport/pms.c b/drivers/media/parport/pms.c
> index 66c957a..9bc105b 100644
> --- a/drivers/media/parport/pms.c
> +++ b/drivers/media/parport/pms.c
> @@ -1091,7 +1091,6 @@ static int pms_probe(struct device *pdev, unsigned int card)
>  	dev->vdev.release = video_device_release_empty;
>  	dev->vdev.lock = &dev->lock;
>  	dev->vdev.tvnorms = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>  	video_set_drvdata(&dev->vdev, dev);
>  	dev->std = V4L2_STD_NTSC_M;
>  	dev->height = 240;
> diff --git a/drivers/media/parport/w9966.c b/drivers/media/parport/w9966.c
> index db2a600..f7502f3 100644
> --- a/drivers/media/parport/w9966.c
> +++ b/drivers/media/parport/w9966.c
> @@ -883,7 +883,6 @@ static int w9966_init(struct w9966 *cam, struct parport *port)
>  	cam->vdev.ioctl_ops = &w9966_ioctl_ops;
>  	cam->vdev.release = video_device_release_empty;
>  	cam->vdev.ctrl_handler = &cam->hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
>  	video_set_drvdata(&cam->vdev, cam);
>  
>  	mutex_init(&cam->lock);
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index da780f4..970e542 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3886,7 +3886,6 @@ static struct video_device *vdev_init(struct bttv *btv,
>  	vfd->v4l2_dev = &btv->c.v4l2_dev;
>  	vfd->release = video_device_release;
>  	vfd->debug   = bttv_debug;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	video_set_drvdata(vfd, btv);
>  	snprintf(vfd->name, sizeof(vfd->name), "BT%d%s %s (%s)",
>  		 btv->id, (btv->id==848 && btv->revision==0x12) ? "A" : "",
> diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
> index 843c62b..f3541b5 100644
> --- a/drivers/media/pci/cx18/cx18-streams.c
> +++ b/drivers/media/pci/cx18/cx18-streams.c
> @@ -375,7 +375,6 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
>  	s->video_dev->release = video_device_release;
>  	s->video_dev->tvnorms = V4L2_STD_ALL;
>  	s->video_dev->lock = &cx->serialize_lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &s->video_dev->flags);
>  	cx18_set_funcs(s->video_dev);
>  	return 0;
>  }
> diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
> index d270819..8d2f1ab 100644
> --- a/drivers/media/pci/cx25821/cx25821-video.c
> +++ b/drivers/media/pci/cx25821/cx25821-video.c
> @@ -1109,7 +1109,6 @@ int cx25821_video_register(struct cx25821_dev *dev)
>  		else
>  			vdev->vfl_dir = VFL_DIR_TX;
>  		vdev->lock = &dev->lock;
> -		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
>  		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
>  		video_set_drvdata(vdev, chan);
>  
> diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
> index e061c88..7163023 100644
> --- a/drivers/media/pci/cx88/cx88-core.c
> +++ b/drivers/media/pci/cx88/cx88-core.c
> @@ -1045,7 +1045,6 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
>  	vfd->release = video_device_release;
>  	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
>  		 core->name, type, core->board.name);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	return vfd;
>  }
>  
> diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
> index 70dad58..f0a1cc4 100644
> --- a/drivers/media/pci/ivtv/ivtv-streams.c
> +++ b/drivers/media/pci/ivtv/ivtv-streams.c
> @@ -251,7 +251,6 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
>  		v4l2_disable_ioctl(s->vdev, VIDIOC_G_TUNER);
>  		v4l2_disable_ioctl(s->vdev, VIDIOC_S_STD);
>  	}
> -	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev->flags);
>  	ivtv_set_funcs(s->vdev);
>  	return 0;
>  }
> diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
> index 54d5c82..1a77f8d 100644
> --- a/drivers/media/pci/meye/meye.c
> +++ b/drivers/media/pci/meye/meye.c
> @@ -1749,7 +1749,6 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
>  
>  	v4l2_ctrl_handler_setup(&meye.hdl);
>  	meye.vdev->ctrl_handler = &meye.hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &meye.vdev->flags);
>  
>  	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
>  				  video_nr) < 0) {
> diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
> index be19a05..9ff03a6 100644
> --- a/drivers/media/pci/saa7134/saa7134-core.c
> +++ b/drivers/media/pci/saa7134/saa7134-core.c
> @@ -811,7 +811,6 @@ static struct video_device *vdev_init(struct saa7134_dev *dev,
>  	vfd->release = video_device_release;
>  	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
>  		 dev->name, type, saa7134_boards[dev->board].name);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	video_set_drvdata(vfd, dev);
>  	return vfd;
>  }
> diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
> index e65c760..5526ed5 100644
> --- a/drivers/media/pci/saa7134/saa7134-empress.c
> +++ b/drivers/media/pci/saa7134/saa7134-empress.c
> @@ -270,7 +270,6 @@ static int empress_init(struct saa7134_dev *dev)
>  	snprintf(dev->empress_dev->name, sizeof(dev->empress_dev->name),
>  		 "%s empress (%s)", dev->name,
>  		 saa7134_boards[dev->board].name);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->empress_dev->flags);
>  	v4l2_ctrl_handler_init(hdl, 21);
>  	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter);
>  	if (dev->empress_sd)
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index d2abd3b..f2d8c70 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -1093,7 +1093,6 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
>  	vip->video_dev = &video_dev_template;
>  	vip->video_dev->v4l2_dev = &vip->v4l2_dev;
>  	vip->video_dev->queue = &vip->vb_vidq;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vip->video_dev->flags);
>  	video_set_drvdata(vip->video_dev, vip);
>  
>  	ret = video_register_device(vip->video_dev, VFL_TYPE_GRABBER, -1);
> diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
> index e9410e4..03c5098 100644
> --- a/drivers/media/platform/arv.c
> +++ b/drivers/media/platform/arv.c
> @@ -773,7 +773,6 @@ static int __init ar_init(void)
>  	ar->vdev.fops = &ar_fops;
>  	ar->vdev.ioctl_ops = &ar_ioctl_ops;
>  	ar->vdev.release = video_device_release_empty;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &ar->vdev.flags);
>  	video_set_drvdata(&ar->vdev, ar);
>  
>  	if (vga) {
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 16e4b1c..6ef9866 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -966,7 +966,6 @@ static int bcap_probe(struct platform_device *pdev)
>  	vfd->ioctl_ops          = &bcap_ioctl_ops;
>  	vfd->tvnorms            = 0;
>  	vfd->v4l2_dev           = &bcap_dev->v4l2_dev;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	strncpy(vfd->name, CAPTURE_DRV_NAME, sizeof(vfd->name));
>  	bcap_dev->video_dev     = vfd;
>  
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index bf5eff9..73496d9 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1709,7 +1709,6 @@ static int register_device(struct vpbe_layer *vpbe_display_layer,
>  	vpbe_display_layer->disp_dev = disp_dev;
>  	/* set the driver data in platform device */
>  	platform_set_drvdata(pdev, disp_dev);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vpbe_display_layer->video_dev.flags);
>  	video_set_drvdata(&vpbe_display_layer->video_dev,
>  			  vpbe_display_layer);
>  
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index a51bda2..ea7661a 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1916,7 +1916,6 @@ static int vpfe_probe(struct platform_device *pdev)
>  	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
>  		"video_dev=%x\n", (int)&vpfe_dev->video_dev);
>  	vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vpfe_dev->video_dev->flags);
>  	ret = video_register_device(vpfe_dev->video_dev,
>  				    VFL_TYPE_GRABBER, -1);
>  
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index ee0a5fc..2f90f0d 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1397,7 +1397,6 @@ static int vpif_probe_complete(void)
>  		vdev->vfl_dir = VFL_DIR_RX;
>  		vdev->queue = q;
>  		vdev->lock = &common->lock;
> -		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
>  		video_set_drvdata(ch->video_dev, ch);
>  		err = video_register_device(vdev,
>  					    VFL_TYPE_GRABBER, (j ? 1 : 0));
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 5bb085b..877b46e 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1223,7 +1223,6 @@ static int vpif_probe_complete(void)
>  		vdev->vfl_dir = VFL_DIR_TX;
>  		vdev->queue = q;
>  		vdev->lock = &common->lock;
> -		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
>  		video_set_drvdata(ch->video_dev, ch);
>  		err = video_register_device(vdev, VFL_TYPE_GRABBER,
>  					    (j ? 3 : 2));
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index deba425..8ea5209 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1172,7 +1172,6 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
>  		goto err_vd_rel;
>  
>  	video_set_drvdata(vfd, vp);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  
>  	v4l2_ctrl_handler_init(&vp->ctrl_handler, 1);
>  	ctrl = v4l2_ctrl_new_std(&vp->ctrl_handler, &s3c_camif_video_ctrl_ops,
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> index 8a8dbc8..b4d2696 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -1109,8 +1109,6 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
>  		.ioctl_ops = &mxr_ioctl_ops,
>  	};
>  	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
> -	/* let framework control PRIORITY */
> -	set_bit(V4L2_FL_USE_FH_PRIO, &layer->vfd.flags);
>  
>  	video_set_drvdata(&layer->vfd, layer);
>  	layer->vfd.lock = &layer->mutex;
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index d00bf3d..b7fbcdf 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -1459,7 +1459,6 @@ static int __init vivi_create_instance(int inst)
>  	vfd->debug = debug;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
>  	vfd->queue = q;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  
>  	/*
>  	 * Provide a mutex to v4l2 core. It will be used to protect
> diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
> index 142c2ee..2262b81 100644
> --- a/drivers/media/radio/dsbr100.c
> +++ b/drivers/media/radio/dsbr100.c
> @@ -390,7 +390,6 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
>  	radio->videodev.release = video_device_release_empty;
>  	radio->videodev.lock = &radio->v4l2_lock;
>  	radio->videodev.ctrl_handler = &radio->hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
>  
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->curfreq = FREQ_MIN * FREQ_MUL;
> diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
> index d719e59..82affae 100644
> --- a/drivers/media/radio/radio-cadet.c
> +++ b/drivers/media/radio/radio-cadet.c
> @@ -650,7 +650,6 @@ static int __init cadet_init(void)
>  	dev->vdev.ioctl_ops = &cadet_ioctl_ops;
>  	dev->vdev.release = video_device_release_empty;
>  	dev->vdev.lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>  	video_set_drvdata(&dev->vdev, dev);
>  
>  	res = video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr);
> diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
> index 6ff3508..c309ee4 100644
> --- a/drivers/media/radio/radio-isa.c
> +++ b/drivers/media/radio/radio-isa.c
> @@ -253,7 +253,6 @@ static int radio_isa_common_probe(struct radio_isa_card *isa,
>  	isa->vdev.fops = &radio_isa_fops;
>  	isa->vdev.ioctl_ops = &radio_isa_ioctl_ops;
>  	isa->vdev.release = video_device_release_empty;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &isa->vdev.flags);
>  	video_set_drvdata(&isa->vdev, isa);
>  	isa->freq = FREQ_LOW;
>  	isa->stereo = drv->has_stereo;
> diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
> index 3d12782..67ac72e 100644
> --- a/drivers/media/radio/radio-keene.c
> +++ b/drivers/media/radio/radio-keene.c
> @@ -380,7 +380,6 @@ static int usb_keene_probe(struct usb_interface *intf,
>  	usb_set_intfdata(intf, &radio->v4l2_dev);
>  
>  	video_set_drvdata(&radio->vdev, radio);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	/* at least 11ms is needed in order to settle hardware */
>  	msleep(20);
> diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
> index a85b064..b3000ef 100644
> --- a/drivers/media/radio/radio-ma901.c
> +++ b/drivers/media/radio/radio-ma901.c
> @@ -411,7 +411,6 @@ static int usb_ma901radio_probe(struct usb_interface *intf,
>  	radio->vdev.ioctl_ops = &usb_ma901radio_ioctl_ops;
>  	radio->vdev.release = video_device_release_empty;
>  	radio->vdev.lock = &radio->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->intf = intf;
> diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
> index a7e93d7..3d12edf 100644
> --- a/drivers/media/radio/radio-miropcm20.c
> +++ b/drivers/media/radio/radio-miropcm20.c
> @@ -210,7 +210,6 @@ static int __init pcm20_init(void)
>  	dev->vdev.ioctl_ops = &pcm20_ioctl_ops;
>  	dev->vdev.release = video_device_release_empty;
>  	dev->vdev.lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>  	video_set_drvdata(&dev->vdev, dev);
>  	snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO,
>  			dev->audmode == V4L2_TUNER_MODE_MONO, -1);
> diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
> index a360227..21ab785 100644
> --- a/drivers/media/radio/radio-mr800.c
> +++ b/drivers/media/radio/radio-mr800.c
> @@ -558,7 +558,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
>  	radio->vdev.ioctl_ops = &usb_amradio_ioctl_ops;
>  	radio->vdev.release = video_device_release_empty;
>  	radio->vdev.lock = &radio->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->intf = intf;
> diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/radio-raremono.c
> index 7b3bdbb..bfb3a6d 100644
> --- a/drivers/media/radio/radio-raremono.c
> +++ b/drivers/media/radio/radio-raremono.c
> @@ -361,7 +361,6 @@ static int usb_raremono_probe(struct usb_interface *intf,
>  	usb_set_intfdata(intf, &radio->v4l2_dev);
>  
>  	video_set_drvdata(&radio->vdev, radio);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	raremono_cmd_main(radio, BAND_FM, 95160);
>  
> diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
> index 6f4318f..d7ce8fe 100644
> --- a/drivers/media/radio/radio-sf16fmi.c
> +++ b/drivers/media/radio/radio-sf16fmi.c
> @@ -344,7 +344,6 @@ static int __init fmi_init(void)
>  	fmi->vdev.fops = &fmi_fops;
>  	fmi->vdev.ioctl_ops = &fmi_ioctl_ops;
>  	fmi->vdev.release = video_device_release_empty;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &fmi->vdev.flags);
>  	video_set_drvdata(&fmi->vdev, fmi);
>  
>  	mutex_init(&fmi->lock);
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> index 2fd9009..633022b 100644
> --- a/drivers/media/radio/radio-si476x.c
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -1470,7 +1470,6 @@ static int si476x_radio_probe(struct platform_device *pdev)
>  	video_set_drvdata(&radio->videodev, radio);
>  	platform_set_drvdata(pdev, radio);
>  
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
>  
>  	radio->v4l2dev.ctrl_handler = &radio->ctrl_handler;
>  	v4l2_ctrl_handler_init(&radio->ctrl_handler,
> diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
> index 3ed1f56..9250496 100644
> --- a/drivers/media/radio/radio-tea5764.c
> +++ b/drivers/media/radio/radio-tea5764.c
> @@ -478,7 +478,6 @@ static int tea5764_i2c_probe(struct i2c_client *client,
>  	video_set_drvdata(&radio->vdev, radio);
>  	radio->vdev.lock = &radio->mutex;
>  	radio->vdev.v4l2_dev = v4l2_dev;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	/* initialize and power off the chip */
>  	tea5764_i2c_read(radio);
> diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
> index e245597..83fe7ab 100644
> --- a/drivers/media/radio/radio-tea5777.c
> +++ b/drivers/media/radio/radio-tea5777.c
> @@ -570,7 +570,6 @@ int radio_tea5777_init(struct radio_tea5777 *tea, struct module *owner)
>  	tea->fops = tea575x_fops;
>  	tea->fops.owner = owner;
>  	tea->vd.fops = &tea->fops;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
>  
>  	tea->vd.ctrl_handler = &tea->ctrl_handler;
>  	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
> diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
> index 0817964..b9285e6 100644
> --- a/drivers/media/radio/radio-timb.c
> +++ b/drivers/media/radio/radio-timb.c
> @@ -126,7 +126,6 @@ static int timbradio_probe(struct platform_device *pdev)
>  	tr->video_dev.release = video_device_release_empty;
>  	tr->video_dev.minor = -1;
>  	tr->video_dev.lock = &tr->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &tr->video_dev.flags);
>  
>  	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
>  	err = v4l2_device_register(NULL, &tr->v4l2_dev);
> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
> index 07ef405..494fac0 100644
> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
> @@ -680,7 +680,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
>  	radio->videodev.lock = &radio->lock;
>  	radio->videodev.v4l2_dev = &radio->v4l2_dev;
>  	radio->videodev.release = video_device_release_empty;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
>  	video_set_drvdata(&radio->videodev, radio);
>  
>  	/* get device and chip versions */
> diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
> index ba4cfc9..a47502a 100644
> --- a/drivers/media/radio/si4713/radio-platform-si4713.c
> +++ b/drivers/media/radio/si4713/radio-platform-si4713.c
> @@ -196,7 +196,6 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>  	rsdev->radio_dev = radio_si4713_vdev_template;
>  	rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
>  	rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &rsdev->radio_dev.flags);
>  	/* Serialize all access to the si4713 */
>  	rsdev->radio_dev.lock = &rsdev->lock;
>  	video_set_drvdata(&rsdev->radio_dev, rsdev);
> diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
> index 86502b2..a77319d 100644
> --- a/drivers/media/radio/si4713/radio-usb-si4713.c
> +++ b/drivers/media/radio/si4713/radio-usb-si4713.c
> @@ -492,7 +492,6 @@ static int usb_si4713_probe(struct usb_interface *intf,
>  	radio->vdev.vfl_dir = VFL_DIR_TX;
>  
>  	video_set_drvdata(&radio->vdev, radio);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
>  
>  	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
>  	if (retval < 0) {
> diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
> index 7c14060..f1a0867 100644
> --- a/drivers/media/radio/tea575x.c
> +++ b/drivers/media/radio/tea575x.c
> @@ -523,7 +523,6 @@ int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
>  	tea->fops = tea575x_fops;
>  	tea->fops.owner = owner;
>  	tea->vd.fops = &tea->fops;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
>  	/* disable hw_freq_seek if we can't use it */
>  	if (tea->cannot_read_data)
>  		v4l2_disable_ioctl(&tea->vd, VIDIOC_S_HW_FREQ_SEEK);
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 9038194..14718b4 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -2008,14 +2008,12 @@ int au0828_analog_register(struct au0828_dev *dev,
>  	*dev->vdev = au0828_video_template;
>  	dev->vdev->v4l2_dev = &dev->v4l2_dev;
>  	dev->vdev->lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev->flags);
>  	strcpy(dev->vdev->name, "au0828a video");
>  
>  	/* Setup the VBI device */
>  	*dev->vbi_dev = au0828_video_template;
>  	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
>  	dev->vbi_dev->lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vbi_dev->flags);
>  	strcpy(dev->vbi_dev->name, "au0828a vbi");
>  
>  	/* Register the v4l2 device */
> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
> index d5d42b6..9caea83 100644
> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
> @@ -1169,7 +1169,6 @@ int cpia2_register_camera(struct camera_data *cam)
>  	cam->vdev.lock = &cam->v4l2_lock;
>  	cam->vdev.ctrl_handler = hdl;
>  	cam->vdev.v4l2_dev = &cam->v4l2_dev;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
>  
>  	reset_camera_struct_v4l(cam);
>  
> diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
> index 30a0c69..f0400e2 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-417.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-417.c
> @@ -1923,7 +1923,6 @@ static struct video_device *cx231xx_video_dev_alloc(
>  	vfd->v4l2_dev = &dev->v4l2_dev;
>  	vfd->lock = &dev->lock;
>  	vfd->release = video_device_release;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	vfd->ctrl_handler = &dev->mpeg_ctrl_handler.hdl;
>  	video_set_drvdata(vfd, dev);
>  	if (dev->tuner_type == TUNER_ABSENT) {
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 1f87513..cf5bea8 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -2066,7 +2066,6 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
>  	vfd->release = video_device_release;
>  	vfd->debug = video_debug;
>  	vfd->lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  
>  	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
>  
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index f6b49c9..3f8b5aa 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -2208,7 +2208,6 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
>  	vfd->v4l2_dev	= &dev->v4l2->v4l2_dev;
>  	vfd->debug	= video_debug;
>  	vfd->lock	= &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	if (dev->board.is_webcam)
>  		vfd->tvnorms = 0;
>  
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index f3a7ace..dbf200e 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -2058,7 +2058,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
>  	gspca_dev->vdev = gspca_template;
>  	gspca_dev->vdev.v4l2_dev = &gspca_dev->v4l2_dev;
>  	video_set_drvdata(&gspca_dev->vdev, gspca_dev);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &gspca_dev->vdev.flags);
>  	gspca_dev->module = module;
>  	gspca_dev->present = 1;
>  
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 0500c417..dca4b65 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -1240,7 +1240,6 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
>  	strcpy(dev->video_dev->name, "Hauppauge HD PVR");
>  	dev->video_dev->v4l2_dev = &dev->v4l2_dev;
>  	video_set_drvdata(dev->video_dev, dev);
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->video_dev->flags);
>  
>  	res = video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum);
>  	if (res < 0) {
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index a73b0bc..15b754d 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -1013,7 +1013,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>  	strcpy(pdev->vdev.name, name);
>  	pdev->vdev.queue = &pdev->vb_queue;
>  	pdev->vdev.queue->lock = &pdev->vb_queue_lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &pdev->vdev.flags);
>  	video_set_drvdata(&pdev->vdev, pdev);
>  
>  	pdev->release = le16_to_cpu(udev->descriptor.bcdDevice);
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index a44466b..2c90186 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -1676,7 +1676,6 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
>  		vc->vdev.ctrl_handler = &vc->hdl;
>  		vc->vdev.lock = &dev->lock;
>  		vc->vdev.v4l2_dev = &dev->v4l2_dev;
> -		set_bit(V4L2_FL_USE_FH_PRIO, &vc->vdev.flags);
>  		video_set_drvdata(&vc->vdev, vc);
>  		if (video_nr == -1)
>  			ret = video_register_device(&vc->vdev,
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index 5461341..2330543 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -671,7 +671,6 @@ int stk1160_video_register(struct stk1160 *dev)
>  
>  	/* This will be used to set video_device parent */
>  	dev->vdev.v4l2_dev = &dev->v4l2_dev;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>  
>  	/* NTSC is default */
>  	dev->norm = V4L2_STD_NTSC_M;
> diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> index be77482..d76860b 100644
> --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> @@ -1266,7 +1266,6 @@ static int stk_register_video_device(struct stk_camera *dev)
>  	dev->vdev.lock = &dev->lock;
>  	dev->vdev.debug = debug;
>  	dev->vdev.v4l2_dev = &dev->v4l2_dev;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>  	video_set_drvdata(&dev->vdev, dev);
>  	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
>  	if (err)
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index ea6070b..b391194 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -327,7 +327,6 @@ int poseidon_fm_init(struct poseidon *p)
>  	}
>  	vfd->v4l2_dev = &p->v4l2_dev;
>  	vfd->ctrl_handler = hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  	video_set_drvdata(vfd, p);
>  	return video_register_device(vfd, VFL_TYPE_RADIO, -1);
>  }
> diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
> index e6b3d5d..9bde064 100644
> --- a/drivers/media/usb/tm6000/tm6000-video.c
> +++ b/drivers/media/usb/tm6000/tm6000-video.c
> @@ -1626,7 +1626,6 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
>  	vfd->release = video_device_release;
>  	vfd->debug = tm6000_debug;
>  	vfd->lock = &dev->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
>  
>  	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
>  
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 2967e80..030c585 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -701,7 +701,6 @@ int usbtv_video_init(struct usbtv *usbtv)
>  	usbtv->vdev.tvnorms = USBTV_TV_STD;
>  	usbtv->vdev.queue = &usbtv->vb2q;
>  	usbtv->vdev.lock = &usbtv->v4l2_lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &usbtv->vdev.flags);
>  	video_set_drvdata(&usbtv->vdev, usbtv);
>  	ret = video_register_device(&usbtv->vdev, VFL_TYPE_GRABBER, -1);
>  	if (ret < 0) {
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index ad47c5c..f8135f4 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1746,7 +1746,6 @@ static int uvc_register_video(struct uvc_device *dev,
>  	vdev->fops = &uvc_fops;
>  	vdev->release = uvc_release;
>  	vdev->prio = &stream->chain->prio;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
>  	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		vdev->vfl_dir = VFL_DIR_TX;
>  	strlcpy(vdev->name, dev->name, sizeof vdev->name);
> diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
> index 74d56df..3b80579 100644
> --- a/drivers/media/usb/zr364xx/zr364xx.c
> +++ b/drivers/media/usb/zr364xx/zr364xx.c
> @@ -1456,7 +1456,6 @@ static int zr364xx_probe(struct usb_interface *intf,
>  	cam->vdev.lock = &cam->lock;
>  	cam->vdev.v4l2_dev = &cam->v4l2_dev;
>  	cam->vdev.ctrl_handler = &cam->ctrl_handler;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
>  	video_set_drvdata(&cam->vdev, cam);
>  	if (debug)
>  		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index d95c427..6f9171c 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1606,7 +1606,6 @@ int vpfe_video_init(struct vpfe_video_device *video, const char *name)
>  	if (ret < 0)
>  		return ret;
>  
> -	set_bit(V4L2_FL_USE_FH_PRIO, &video->video_dev.flags);
>  	video_set_drvdata(&video->video_dev, video);
>  
>  	return 0;
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index da7b549..ecb5336 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -1001,7 +1001,6 @@ int go7007_v4l2_init(struct go7007 *go)
>  	*vdev = go7007_template;
>  	vdev->lock = &go->serialize_lock;
>  	vdev->queue = &go->vidq;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
>  	video_set_drvdata(vdev, go);
>  	vdev->v4l2_dev = &go->v4l2_dev;
>  	if (!v4l2_device_has_op(&go->v4l2_dev, video, querystd))
> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
> index 08d0d09..53aca38 100644
> --- a/drivers/staging/media/msi3101/sdr-msi3101.c
> +++ b/drivers/staging/media/msi3101/sdr-msi3101.c
> @@ -1418,7 +1418,6 @@ static int msi3101_probe(struct usb_interface *intf,
>  	s->vdev = msi3101_template;
>  	s->vdev.queue = &s->vb_queue;
>  	s->vdev.queue->lock = &s->vb_queue_lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
>  	video_set_drvdata(&s->vdev, s);
>  
>  	/* Register the v4l2_device structure */
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index 093df6b..f9acdb6 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -1448,7 +1448,6 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
>  	s->vdev = rtl2832_sdr_template;
>  	s->vdev.queue = &s->vb_queue;
>  	s->vdev.queue->lock = &s->vb_queue_lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
>  	video_set_drvdata(&s->vdev, s);
>  
>  	/* Register the v4l2_device structure */
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> index b8ff113..bb2604e 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> @@ -1326,7 +1326,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
>  	solo_enc->vfd->ctrl_handler = hdl;
>  	solo_enc->vfd->queue = &solo_enc->vidq;
>  	solo_enc->vfd->lock = &solo_enc->lock;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
>  	video_set_drvdata(solo_enc->vfd, solo_enc);
>  	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
>  	if (ret < 0)
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> index 5d0100e..ba2526c 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> @@ -666,7 +666,6 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
>  		goto fail;
>  	}
>  	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
> -	set_bit(V4L2_FL_USE_FH_PRIO, &solo_dev->vfd->flags);
>  
>  	video_set_drvdata(solo_dev->vfd, solo_dev);
>  
> 

