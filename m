Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:53595 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZFDEUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 00:20:16 -0400
Subject: Re: [PATCH]V4L:some v4l drivers have error for
 video_register_device
From: "figo.zhang" <figo.zhang@kolorific.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	kraxel@bytesex.org, Hans Verkuil <hverkuil@xs4all.nl>,
	alan@lxorguk.ukuu.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	akpm@linux-foundation.org
In-Reply-To: <1243394739.3384.16.camel@myhost>
References: <1243394739.3384.16.camel@myhost>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 12:20:07 +0800
Message-Id: <1244089207.3445.31.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function video_register_device() will call the video_register_device_index().
In this function, firtly it will do some argments check , if failed,it will return a 
negative number such as -EINVAL, and then do cdev_alloc() and device_register(), if
success return zero. so video_register_device_index() canot return a a positive number.

for example, see the drivers/media/video/stk-webcam.c (line 1325):

err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
	if (err)
		STK_ERROR("v4l registration failed\n");
	else
		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
			" /dev/video%d\n", dev->vdev.num);

in my opinion, it will be cleaner to do something like this:

err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
	if (err != 0)
		STK_ERROR("v4l registration failed\n");
	else
		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
			" /dev/video%d\n", dev->vdev.num);



Figo.zhang


On Wed, 2009-05-27 at 11:25 +0800, Figo.zhang wrote:
> For video_register_device(), it return zero means register success.It would be return zero
> or a negative number (on failure),it would not return a positive number.so it have better to
> use this to check err:
> 	int err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> 	if (err != 0) {
> 		/*err code*/
> 	}
> 
>  
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
>  Documentation/video4linux/v4l2-framework.txt |    2 +-
>  drivers/media/radio/radio-maestro.c          |    2 +-
>  drivers/media/radio/radio-si470x.c           |    2 +-
>  drivers/media/video/cafe_ccic.c              |    2 +-
>  drivers/media/video/cx231xx/cx231xx-video.c  |    2 +-
>  drivers/media/video/em28xx/em28xx-video.c    |    2 +-
>  drivers/media/video/et61x251/et61x251_core.c |    2 +-
>  drivers/media/video/hdpvr/hdpvr-video.c      |    2 +-
>  drivers/media/video/ivtv/ivtv-streams.c      |    2 +-
>  drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
>  drivers/media/video/stk-webcam.c             |    2 +-
>  drivers/media/video/w9968cf.c                |    2 +-
>  drivers/media/video/zc0301/zc0301_core.c     |    2 +-
>  drivers/media/video/zr364xx.c                |    2 +-
>  sound/i2c/other/tea575x-tuner.c              |    2 +-
>  15 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 854808b..250232a 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -447,7 +447,7 @@ Next you register the video device: this will create the character device
>  for you.
>  
>  	err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> -	if (err) {
> +	if (err != 0) {
>  		video_device_release(vdev); /* or kfree(my_vdev); */
>  		return err;
>  	}
> diff --git a/drivers/media/radio/radio-maestro.c b/drivers/media/radio/radio-maestro.c
> index 64d737c..b5e93c2 100644
> --- a/drivers/media/radio/radio-maestro.c
> +++ b/drivers/media/radio/radio-maestro.c
> @@ -379,7 +379,7 @@ static int __devinit maestro_probe(struct pci_dev *pdev,
>  	video_set_drvdata(&dev->vdev, dev);
>  
>  	retval = video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr);
> -	if (retval) {
> +	if (retval != 0) {
>  		v4l2_err(v4l2_dev, "can't register video device!\n");
>  		goto errfr1;
>  	}
> diff --git a/drivers/media/radio/radio-si470x.c b/drivers/media/radio/radio-si470x.c
> index bd945d0..edb520a 100644
> --- a/drivers/media/radio/radio-si470x.c
> +++ b/drivers/media/radio/radio-si470x.c
> @@ -1740,7 +1740,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
>  
>  	/* register video device */
>  	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
> -	if (retval) {
> +	if (retval != 0) {
>  		printk(KERN_WARNING DRIVER_NAME
>  				": Could not register video device\n");
>  		goto err_all;
> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> index c4d181d..fd93698 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -1974,7 +1974,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  /*	cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
>  	cam->vdev.v4l2_dev = &cam->v4l2_dev;
>  	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
> -	if (ret)
> +	if (ret != 0)
>  		goto out_smbus;
>  	video_set_drvdata(&cam->vdev, cam);
>  
> diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
> index a23ae73..14e5008 100644
> --- a/drivers/media/video/cx231xx/cx231xx-video.c
> +++ b/drivers/media/video/cx231xx/cx231xx-video.c
> @@ -2382,7 +2382,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
>  	/* register v4l2 video video_device */
>  	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
>  				    video_nr[dev->devno]);
> -	if (ret) {
> +	if (ret != 0) {
>  		cx231xx_errdev("unable to register video device (error=%i).\n",
>  			       ret);
>  		return ret;
> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index 882796e..dcc3aca 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -2013,7 +2013,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  	/* register v4l2 video video_device */
>  	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
>  				       video_nr[dev->devno]);
> -	if (ret) {
> +	if (ret != 0) {
>  		em28xx_errdev("unable to register video device (error=%i).\n",
>  			      ret);
>  		return ret;
> diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
> index d1c1e45..8a767e1 100644
> --- a/drivers/media/video/et61x251/et61x251_core.c
> +++ b/drivers/media/video/et61x251/et61x251_core.c
> @@ -2591,7 +2591,7 @@ et61x251_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
>  
>  	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
>  				    video_nr[dev_nr]);
> -	if (err) {
> +	if (err != 0) {
>  		DBG(1, "V4L2 device registration failed");
>  		if (err == -ENFILE && video_nr[dev_nr] == -1)
>  			DBG(1, "Free /dev/videoX node not found");
> diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
> index 3e6ffee..14c8488 100644
> --- a/drivers/media/video/hdpvr/hdpvr-video.c
> +++ b/drivers/media/video/hdpvr/hdpvr-video.c
> @@ -1237,7 +1237,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
>  	dev->video_dev->parent = parent;
>  	video_set_drvdata(dev->video_dev, dev);
>  
> -	if (video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum)) {
> +	if (video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum) != 0) {
>  		v4l2_err(&dev->v4l2_dev, "video_device registration failed\n");
>  		goto error;
>  	}
> diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
> index 15da017..1aca6b3 100644
> --- a/drivers/media/video/ivtv/ivtv-streams.c
> +++ b/drivers/media/video/ivtv/ivtv-streams.c
> @@ -261,7 +261,7 @@ static int ivtv_reg_dev(struct ivtv *itv, int type)
>  	video_set_drvdata(s->vdev, s);
>  
>  	/* Register device. First try the desired minor, then any free one. */
> -	if (video_register_device(s->vdev, vfl_type, num)) {
> +	if (video_register_device(s->vdev, vfl_type, num) != 0) {
>  		IVTV_ERR("Couldn't register v4l2 device for %s kernel number %d\n",
>  				s->name, num);
>  		video_device_release(s->vdev);
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
> index 23edfdc..55242c4 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -3334,7 +3334,7 @@ sn9c102_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
>  
>  	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
>  				    video_nr[dev_nr]);
> -	if (err) {
> +	if (err != 0) {
>  		DBG(1, "V4L2 device registration failed");
>  		if (err == -ENFILE && video_nr[dev_nr] == -1)
>  			DBG(1, "Free /dev/videoX node not found");
> diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
> index 1a6d39c..1a7aca0 100644
> --- a/drivers/media/video/stk-webcam.c
> +++ b/drivers/media/video/stk-webcam.c
> @@ -1323,7 +1323,7 @@ static int stk_register_video_device(struct stk_camera *dev)
>  	dev->vdev.debug = debug;
>  	dev->vdev.parent = &dev->interface->dev;
>  	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> -	if (err)
> +	if (err != 0)
>  		STK_ERROR("v4l registration failed\n");
>  	else
>  		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
> index f59b2bd..5f56e90 100644
> --- a/drivers/media/video/w9968cf.c
> +++ b/drivers/media/video/w9968cf.c
> @@ -3500,7 +3500,7 @@ w9968cf_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
>  
>  	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
>  				    video_nr[dev_nr]);
> -	if (err) {
> +	if (err != 0) {
>  		DBG(1, "V4L device registration failed")
>  		if (err == -ENFILE && video_nr[dev_nr] == -1)
>  			DBG(2, "Couldn't find a free /dev/videoX node")
> diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
> index 9697104..05296fc 100644
> --- a/drivers/media/video/zc0301/zc0301_core.c
> +++ b/drivers/media/video/zc0301/zc0301_core.c
> @@ -1991,7 +1991,7 @@ zc0301_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
>  
>  	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
>  				    video_nr[dev_nr]);
> -	if (err) {
> +	if (err != 0) {
>  		DBG(1, "V4L2 device registration failed");
>  		if (err == -ENFILE && video_nr[dev_nr] == -1)
>  			DBG(1, "Free /dev/videoX node not found");
> diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
> index ac169c9..83d0aea 100644
> --- a/drivers/media/video/zr364xx.c
> +++ b/drivers/media/video/zr364xx.c
> @@ -857,7 +857,7 @@ static int zr364xx_probe(struct usb_interface *intf,
>  	mutex_init(&cam->lock);
>  
>  	err = video_register_device(cam->vdev, VFL_TYPE_GRABBER, -1);
> -	if (err) {
> +	if (err != 0) {
>  		dev_err(&udev->dev, "video_register_device failed\n");
>  		video_device_release(cam->vdev);
>  		kfree(cam->buffer);
> diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
> index d31c373..27bc7be 100644
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -324,7 +324,7 @@ void snd_tea575x_init(struct snd_tea575x *tea)
>  
>  	retval = video_register_device(tea575x_radio_inst,
>  				       VFL_TYPE_RADIO, radio_nr);
> -	if (retval) {
> +	if (retval != 0) {
>  		printk(KERN_ERR "tea575x-tuner: can't register video device!\n");
>  		kfree(tea575x_radio_inst);
>  		return;
> 

