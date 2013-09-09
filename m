Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57692 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3IIRK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 13:10:28 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so3714342wid.9
        for <linux-media@vger.kernel.org>; Mon, 09 Sep 2013 10:10:27 -0700 (PDT)
Message-ID: <522E0102.4060303@googlemail.com>
Date: Mon, 09 Sep 2013 19:10:26 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] em28xx: balance subdevice power-off calls
References: <Pine.LNX.4.64.1309051459261.785@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1309051459261.785@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

thank you for looking at this. A few thoughts:

Am 05.09.2013 15:11, schrieb Guennadi Liakhovetski:
> The em28xx USB driver powers off its subdevices, by calling their .s_power()
> methods to save power, but actually never powers them on. Apparently this
> works with currently used subdevice drivers, but is wrong and might break
> with some other ones. This patch fixes this issue by adding required
> .s_power() calls to turn subdevices on.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Please, test - only compile tested due to lack of hardware
>
>  drivers/media/usb/em28xx/em28xx-cards.c |    1 +
>  drivers/media/usb/em28xx/em28xx-video.c |   17 ++++++++++-------
>  2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index dc65742..d2d3b06 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3066,6 +3066,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  	}
>  
>  	/* wake i2c devices */
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 1);
>  	em28xx_wake_i2c(dev);
I wonder if we should make the (s_power, 1) call part of em28xx_wake_i2c().
This function already does

    v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
    v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
            INPUT(dev->ctl_input)->vmux, 0, 0);
    v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);

>  
>  	/* init video dma queues */
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 9d10334..283fa26 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1589,15 +1589,18 @@ static int em28xx_v4l2_open(struct file *filp)
>  	fh->type = fh_type;
>  	filp->private_data = fh;
>  
> -	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
> -		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
> -		em28xx_resolution_set(dev);
> +	if (dev->users == 0) {
> +		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 1);
>  
> -		/* Needed, since GPIO might have disabled power of
> -		   some i2c device
> -		 */
> -		em28xx_wake_i2c(dev);
> +		if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +			em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
em28xx_set_mode() calls em28xx_gpio_set(dev,
INPUT(dev->ctl_input)->gpio) and I'm not sure if this could disable
subdevice power again...

> +			em28xx_resolution_set(dev);
>  
> +			/* Needed, since GPIO might have disabled power of
> +			   some i2c device
> +			*/
> +			em28xx_wake_i2c(dev);
Hmm... your patch didn't change this, but:
Why do we call these functions only in case of V4L2_BUF_TYPE_VIDEO_CAPTURE ?
Isn't it needed for VBI capturing, too ?
em28xx_wake_i2c() is probably also needed for radio mode...

Mauro, what do you think ?

Regards,
Frank

> +		}
>  	}
>  
>  	if (vdev->vfl_type == VFL_TYPE_RADIO) {

