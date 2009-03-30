Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2767 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762402AbZC3WNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 18:13:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [review] dsbr100 radio: convert to to v4l2_device
Date: Tue, 31 Mar 2009 00:13:00 +0200
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
References: <1238432987.4027.12.camel@tux.localhost>
In-Reply-To: <1238432987.4027.12.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903310013.00369.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 19:09:47 Alexey Klimov wrote:
> Hello, Hans and Douglas, and others
> 
> This is review version for dsbr100 radio.
> Hans, if you can a bit of free time to look and make comments it will be
> very good.
> 
> I'm still confused about messages like v4l2_err and about unplugging
> procedure.

For a simple device like this unregistering the v4l2_device in the disconnect
is OK. Although the best method would be to call v4l2_device_disconnect()
in the disconnect function and postpone the v4l2_device_unregister() until the
usb_dsbr100_video_device_release function.

What is really missing in the v4l2 core is a release function that is called
when the last video device node is closed. The video_release function is only
called when that particular video device is released, but for drivers that
open multiple device nodes you still have to put in administration to wait
until really the last user of any device node disappears.

I might add a feature like that to the v4l2 core in the future. It shouldn't
be too hard.

Anyway, that's not relevant for a simple USB radio device :-)

Re: the v4l2_err functions: v4l2_device_register sets up a standard unique
driver prefix that can be used for logging. Since the 'name' can be
overwritten by the driver you have more flexibility than the standard
dev_info functions. I also have some ideas on how to improve there functions.

> I tested it with my radio device and it works(unplugging works also
> without oopses).
> Douglas, if you can find some free time to test patch it will be very
> good too :)
> 
> --
> diff -r f86c84534cb4 linux/drivers/media/radio/dsbr100.c
> --- a/linux/drivers/media/radio/dsbr100.c	Sun Mar 29 22:54:35 2009 -0300
> +++ b/linux/drivers/media/radio/dsbr100.c	Mon Mar 30 21:00:51 2009 +0400
> @@ -32,6 +32,9 @@
>   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>  
>   History:
> +
> + Version 0.45:
> +	Converted to v4l2_device.
>  
>   Version 0.44:
>  	Add suspend/resume functions, fix unplug of device,
> @@ -88,7 +91,7 @@
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/videodev2.h>
> -#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <linux/usb.h>
>  #include "compat.h"
> @@ -98,39 +101,8 @@
>   */
>  #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
>  
> -#define DRIVER_VERSION "v0.44"
> -#define RADIO_VERSION KERNEL_VERSION(0, 4, 4)
> -
> -static struct v4l2_queryctrl radio_qctrl[] = {
> -	{
> -		.id            = V4L2_CID_AUDIO_MUTE,
> -		.name          = "Mute",
> -		.minimum       = 0,
> -		.maximum       = 1,
> -		.default_value = 1,
> -		.type          = V4L2_CTRL_TYPE_BOOLEAN,
> -	},
> -/* HINT: the disabled controls are only here to satify kradio and such apps */
> -	{       .id             = V4L2_CID_AUDIO_VOLUME,
> -		.flags          = V4L2_CTRL_FLAG_DISABLED,
> -	},
> -	{
> -		.id             = V4L2_CID_AUDIO_BALANCE,
> -		.flags          = V4L2_CTRL_FLAG_DISABLED,
> -	},
> -	{
> -		.id             = V4L2_CID_AUDIO_BASS,
> -		.flags          = V4L2_CTRL_FLAG_DISABLED,
> -	},
> -	{
> -		.id             = V4L2_CID_AUDIO_TREBLE,
> -		.flags          = V4L2_CTRL_FLAG_DISABLED,
> -	},
> -	{
> -		.id             = V4L2_CID_AUDIO_LOUDNESS,
> -		.flags          = V4L2_CTRL_FLAG_DISABLED,
> -	},
> -};
> +#define DRIVER_VERSION "v0.45"
> +#define RADIO_VERSION KERNEL_VERSION(0, 4, 5)
>  
>  #define DRIVER_AUTHOR "Markus Demleitner <msdemlei@tucana.harvard.edu>"
>  #define DRIVER_DESC "D-Link DSB-R100 USB FM radio driver"
> @@ -168,6 +140,8 @@
>  struct dsbr100_device {
>  	struct usb_device *usbdev;
>  	struct video_device videodev;
> +	struct v4l2_device v4l2_dev;
> +
>  	u8 *transfer_buffer;
>  	struct mutex lock;	/* buffer locking */
>  	int curfreq;
> @@ -387,6 +361,7 @@
>  	mutex_unlock(&radio->lock);
>  
>  	video_unregister_device(&radio->videodev);
> +	v4l2_device_unregister(&radio->v4l2_dev);
>  }
>  
>  
> @@ -482,14 +457,11 @@
>  static int vidioc_queryctrl(struct file *file, void *priv,
>  				struct v4l2_queryctrl *qc)
>  {
> -	int i;
> +	switch (qc->id) {
> +	case V4L2_CID_AUDIO_MUTE:
> +		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> +	}
>  
> -	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
> -		if (qc->id && qc->id == radio_qctrl[i].id) {
> -			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
> -			return 0;
> -		}
> -	}
>  	return -EINVAL;
>  }
>  
> @@ -686,22 +658,15 @@
>  	.vidioc_s_input     = vidioc_s_input,
>  };
>  
> -/* V4L2 interface */
> -static struct video_device dsbr100_videodev_data = {
> -	.name		= "D-Link DSB-R 100",
> -	.fops		= &usb_dsbr100_fops,
> -	.ioctl_ops 	= &usb_dsbr100_ioctl_ops,
> -	.release	= usb_dsbr100_video_device_release,
> -};
> -
>  /* check if the device is present and register with v4l and usb if it is */
>  static int usb_dsbr100_probe(struct usb_interface *intf,
>  				const struct usb_device_id *id)
>  {
>  	struct dsbr100_device *radio;
> +	struct v4l2_device *v4l2_dev;
>  	int retval;
>  
> -	radio = kmalloc(sizeof(struct dsbr100_device), GFP_KERNEL);
> +	radio = kzalloc(sizeof(struct dsbr100_device), GFP_KERNEL);
>  
>  	if (!radio)
>  		return -ENOMEM;
> @@ -713,17 +678,35 @@
>  		return -ENOMEM;
>  	}
>  
> +	v4l2_dev = &radio->v4l2_dev;
> +	strlcpy(v4l2_dev->name, "dsbr100", sizeof(v4l2_dev->name));

Try to leave this out and let v4l2_device_register fill it in based on the
parent device. It should generate a decent name. If you create it yourself,
then make sure it is a unique name.

> +
> +	retval = v4l2_device_register(&intf->dev, v4l2_dev);
> +	if (retval < 0) {
> +		v4l2_err(v4l2_dev, "couldn't register v4l2_device\n");
> +		kfree(radio->transfer_buffer);
> +		kfree(radio);
> +		return retval;
> +	}
> +
> +	strlcpy(radio->videodev.name, v4l2_dev->name, sizeof(radio->videodev.name));
> +	radio->videodev.v4l2_dev = v4l2_dev;
> +	radio->videodev.fops = &usb_dsbr100_fops;
> +	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
> +	radio->videodev.release = usb_dsbr100_video_device_release;
> +
>  	mutex_init(&radio->lock);
> -	radio->videodev = dsbr100_videodev_data;
>  
>  	radio->removed = 0;
>  	radio->users = 0;
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->curfreq = FREQ_MIN * FREQ_MUL;
>  	video_set_drvdata(&radio->videodev, radio);
> +
>  	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
>  	if (retval < 0) {
>  		dev_err(&intf->dev, "couldn't register video device\n");
> +		v4l2_device_unregister(v4l2_dev);
>  		kfree(radio->transfer_buffer);
>  		kfree(radio);
>  		return -EIO;

Looks good otherwise.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
