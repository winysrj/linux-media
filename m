Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60368 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758201AbZDHJhR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 05:37:17 -0400
Date: Wed, 8 Apr 2009 11:37:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
In-Reply-To: <87iqlgkykd.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0904080950560.4722@axis700.grange>
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange> <87iqlgkykd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Tue, 7 Apr 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > This is more or less the final version of the first step of the 
> > v4l2-subdev conversion, hence, all affected driver authors / platform 
> > maintainers are encouraged to review and test. I have eliminated 
> 
> OK, here goes a preliminary review for the bits I maintain. I'll test fully this
> weekend.

Great, thanks.

> As a side note, I tried to apply your patch on top of linux-next-20090406. I was
> a bit tedious. Would you tell me which tree you're based against, or even better
> some git url ?

Look under

http://gross-embedded.homelinux.org/~lyakh/v4l-20090408/

that's based on linux-next of 30.03.2009 (commit ID in 0000-base on 
linux-next history branch).

> <snip>
> > diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
> > index 97c93a7..5c8aabf 100644
> > --- a/arch/arm/mach-pxa/mioa701.c
> > +++ b/arch/arm/mach-pxa/mioa701.c
> > @@ -724,19 +724,19 @@ struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
> >  	.mclk_10khz = 5000,
> >  };
> >  
> > -static struct soc_camera_link iclink = {
> > -	.bus_id	= 0, /* Must match id in pxa27x_device_camera in device.c */
> > -};
> > -
> >  /* Board I2C devices. */
> I would rather have :
> /*
>  * Board I2C devices
>  */
> The remaining /* blurpblurg */ forms are a leftover in device comments.
> 
> <snip>
> > @@ -754,20 +754,21 @@ static struct platform_device var = {			\
> >  		.platform_data = pdata,			\
> >  		.parent	= tparent,			\
> >  	},						\
> > -};
> > +}
> No cookie for you for removing that semi-colon.

I believe this is correct. It is good to have

#define macro(x) do_something(x)

and then use

	macro(x1);
	macro(x2);

rather than

#define macro(x) do_something(x);

	macro(x1)
	macro(x2)

And you do have semicolons everywhere where you use MIO_PARENT_DEV and 
MIO_SIMPLE_DEV, so, probably, that change doesn't belong to this patch, 
but it is correct.

> >  #define MIO_SIMPLE_DEV(var, strname, pdata)	\
> >  	MIO_PARENT_DEV(var, strname, NULL, pdata)
> >  
> > -MIO_SIMPLE_DEV(mioa701_gpio_keys, "gpio-keys",	    &mioa701_gpio_keys_data)
> > +MIO_SIMPLE_DEV(mioa701_gpio_keys, "gpio-keys",	    &mioa701_gpio_keys_data);
> >  MIO_PARENT_DEV(mioa701_backlight, "pwm-backlight",  &pxa27x_device_pwm0.dev,
> >  		&mioa701_backlight_data);
> > -MIO_SIMPLE_DEV(mioa701_led,	  "leds-gpio",	    &gpio_led_info)
> > -MIO_SIMPLE_DEV(pxa2xx_pcm,	  "pxa2xx-pcm",	    NULL)
> > -MIO_SIMPLE_DEV(pxa2xx_ac97,	  "pxa2xx-ac97",    NULL)
> > -MIO_PARENT_DEV(mio_wm9713_codec,  "wm9713-codec",   &pxa2xx_ac97.dev, NULL)
> > -MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL)
> > -MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL)
> > +MIO_SIMPLE_DEV(mioa701_led,	  "leds-gpio",	    &gpio_led_info);
> > +MIO_SIMPLE_DEV(pxa2xx_pcm,	  "pxa2xx-pcm",	    NULL);
> > +MIO_SIMPLE_DEV(pxa2xx_ac97,	  "pxa2xx-ac97",    NULL);
> > +MIO_PARENT_DEV(mio_wm9713_codec,  "wm9713-codec",   &pxa2xx_ac97.dev, NULL);
> > +MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL);
> > +MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL);
> >  MIO_SIMPLE_DEV(gpio_vbus,	  "gpio-vbus",      &gpio_vbus_data);
> Please, don't change the indentation. You will face :
>  (a) conficts with patches in this merge window
>  (b) that's not the object of your patch anyway
>  (c) I like that indentation in that very specific case
> 
> > +MIO_SIMPLE_DEV(mioa701_camera,	  "soc-camera-pdrv",&&iclink[0]);
>                                                             ^
>                                                   isn't &iclink enough ?

Oops, yeah, sure.

> >  static struct platform_device *devices[] __initdata = {
> >  	&mioa701_gpio_keys,
> > @@ -781,6 +782,7 @@ static struct platform_device *devices[] __initdata = {
> >  	&strataflash,
> >  	&gpio_vbus,
> >  	&mioa701_board,
> > +	&mioa701_camera,
> Please invert mioa701_board and mioa701_camera. The board should always be last
> for suspend/resume purpose (yes, that would have deserved a comment, I hear you
> :))

ok

> >  };
> >  
> >  static void mioa701_machine_exit(void);
> > @@ -825,7 +827,6 @@ static void __init mioa701_machine_init(void)
> >  
> >  	pxa_set_i2c_info(&i2c_pdata);
> >  	pxa_set_camera_info(&mioa701_pxacamera_platform_data);
> > -	i2c_register_board_info(0, ARRAY_AND_SIZE(mioa701_i2c_devices));
> I'm wondering which version of mioa701.c had that line ... strange ...

commit 8e7ccddf0fd22617a3edc28ab2ce2fac0fb94823
Author: Robert Jarzmik <robert.jarzmik@free.fr>
Date:   Sat Nov 15 16:09:54 2008 +0100

    [ARM] pxa/MioA701: add camera support for Mio A701 board.

> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index cdd1ddb..425aec2 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> <snip>
> > @@ -938,40 +955,42 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
> >  
> >  	dev_info(&icd->dev, "Detected a MT9M11x chip ID %x\n", data);
> >  
> > -	ret = soc_camera_video_start(icd);
> > -	if (ret)
> > -		goto eisis;
> > -
> >  	mt9m111->autoexposure = 1;
> >  	mt9m111->autowhitebalance = 1;
> >  
> >  	mt9m111->swap_rgb_even_odd = 1;
> >  	mt9m111->swap_rgb_red_blue = 1;
> >  
> > -	return 0;
> > -eisis:
> >  ei2c:
> > +	soc_camera_video_stop(icd);
> > +
> >  	return ret;
> >  }
> >  
> >  static void mt9m111_video_remove(struct soc_camera_device *icd)
> >  {
> > -	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> > +	struct i2c_client *client = to_i2c_client(icd->control);
> >  
> > -	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9m111->client->addr,
> > -		mt9m111->icd.dev.parent, mt9m111->icd.vdev);
> > -	soc_camera_video_stop(&mt9m111->icd);
> > +	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
> > +		icd->dev.parent, icd->vdev);
> > +	icd->ops = NULL;
> I don't understand the icd->ops = NULL here. It's not symmetrical with
> mt9m111_video_probe. Shouldn't that be in mt9m111_remove ?

*_video_remove is called from *_remove now, so, doesn't matter really.

> More generally, I saw all the heavy work on mt9m111 driver conversion. I
> wondered if there shouldn't be a wrapper function to convert an icd structure
> into an mt9m111 structre. If I had done that straight away, you wouldn't have
> had that much work ...

Well, it was about the same for all device drivers, so... But at least 
your reg_{read,write,set,clear} macros did help in a later patch:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
