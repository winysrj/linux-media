Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2239 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab0CaTDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 15:03:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dean A." <dean@sensoray.com>
Subject: Re: [PATCH] s2255drv: v4l2 device added
Date: Wed, 31 Mar 2010 21:03:21 +0200
Cc: linux-media@vger.kernel.org
References: <tkrat.6506e871933e5a00@sensoray.com>
In-Reply-To: <tkrat.6506e871933e5a00@sensoray.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003312103.21952.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 31 March 2010 18:34:39 Dean A. wrote:
> # HG changeset patch
> # User Dean Anderson <dean@sensoray.com>
> # Date 1270053044 25200
> # Node ID 0690e4e1d81e785af1a5f06a13573dcf2cc5cb0c
> # Parent  c72bdc8732abc0cf7bc376babfd06b2d999bdcf4
> s2255drv: adding v4l2_device structure. video_register_device cleanup
> 
> From: Dean Anderson <dean@sensoray.com>
> 
> adding v4l2_device structure.
> if one video_register_device call fails, allows use of other devices
> or channels.

That's not correct. There is only one v4l2_device per USB device. And the
first argument should be &dev->interface->dev, not &dev->udev->dev.

When you register the video device node you shouldn't set vdev[i]->parent
anymore, instead point vdev[i]->v4l2_dev to the v4l2_device struct.

Regards,

	Hans

> 
> Priority: normal
> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>
> 
> diff -r c72bdc8732ab -r 0690e4e1d81e linux/drivers/media/video/s2255drv.c
> --- a/linux/drivers/media/video/s2255drv.c	Wed Mar 31 07:38:11 2010 -0700
> +++ b/linux/drivers/media/video/s2255drv.c	Wed Mar 31 09:30:44 2010 -0700
> @@ -51,6 +51,7 @@
>  #include <linux/smp_lock.h>
>  #include <media/videobuf-vmalloc.h>
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <linux/vmalloc.h>
>  #include <linux/usb.h>
> @@ -77,7 +78,6 @@
>  #define S2255_DEF_BUFS          16
>  #define S2255_SETMODE_TIMEOUT   500
>  #define S2255_VIDSTATUS_TIMEOUT 350
> -#define MAX_CHANNELS		4
>  #define S2255_MARKER_FRAME	cpu_to_le32(0x2255DA4AL)
>  #define S2255_MARKER_RESPONSE	cpu_to_le32(0x2255ACACL)
>  #define S2255_RESPONSE_SETMODE  cpu_to_le32(0x01)
> @@ -225,6 +225,8 @@
>  
>  struct s2255_dev {
>  	struct video_device	vdev[MAX_CHANNELS];
> +	struct v4l2_device 	v4l2_dev[MAX_CHANNELS];
> +	int                     channels; /* number of channels registered */
>  	int			frames;
>  	struct mutex		lock;
>  	struct mutex		open_lock;
> @@ -1753,7 +1755,8 @@
>  	int state;
>  	dprintk(1, "s2255: open called (dev=%s)\n",
>  		video_device_node_name(vdev));
> -	for (i = 0; i < MAX_CHANNELS; i++)
> +
> +	for (i = 0; i < dev->channels; i++)
>  		if (&dev->vdev[i] == vdev) {
>  			cur_channel = i;
>  			break;
> @@ -1994,7 +1997,11 @@
>  	int ret;
>  	int i;
>  	int cur_nr = video_nr;
> -
> +	for (i = 0; i < MAX_CHANNELS; i++) {
> +		ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev[i]);
> +		if (ret)
> +			goto unreg_v4l2;
> +	}
>  	/* initialize all video 4 linux */
>  	/* register 4 video devices */
>  	for (i = 0; i < MAX_CHANNELS; i++) {
> @@ -2014,16 +2021,29 @@
>  						    VFL_TYPE_GRABBER,
>  						    cur_nr + i);
>  		video_set_drvdata(&dev->vdev[i], dev);
> -
> -		if (ret != 0) {
> +		if (ret) {
>  			dev_err(&dev->udev->dev,
>  				"failed to register video device!\n");
> -			return ret;
> +			break;
>  		}
> +		dev->channels++;
> +		v4l2_info(&dev->v4l2_dev[i], "V4L2 device registered as %s\n",
> +			  video_device_node_name(&dev->vdev[i]));
> +
>  	}
> +
>  	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
>  	       S2255_MAJOR_VERSION,
>  	       S2255_MINOR_VERSION);
> +	/* if no channels registered, return error and probe will fail*/
> +	if (dev->channels == 0)
> +		return ret;
> +	if (dev->channels != MAX_CHANNELS)
> +		printk(KERN_WARNING "s2255: Not all channels available.\n");
> +	return 0;
> +unreg_v4l2:
> +	for (i-- ; i > 0; i--)
> +		v4l2_device_unregister(&dev->v4l2_dev[i]);
>  	return ret;
>  }
>  
> @@ -2705,13 +2725,9 @@
>  	/* loads v4l specific */
>  	retval = s2255_probe_v4l(dev);
>  	if (retval)
> -		goto errorV4L;
> +		goto errorBOARDINIT;
>  	dev_info(&interface->dev, "Sensoray 2255 detected\n");
>  	return 0;
> -errorV4L:
> -	for (i = 0; i < MAX_CHANNELS; i++)
> -		if (video_is_registered(&dev->vdev[i]))
> -			video_unregister_device(&dev->vdev[i]);
>  errorBOARDINIT:
>  	s2255_board_shutdown(dev);
>  errorFWMARKER:
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
