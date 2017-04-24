Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1172867AbdDXOof (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 10:44:35 -0400
Date: Mon, 24 Apr 2017 17:44:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170424144402.GS7456@valkosipuli.retiisi.org.uk>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
 <20170419132339.GA31747@amd>
 <20170419110300.2dbbf784@vento.lan>
 <20170421063312.GA21434@amd>
 <20170421113934.55158d51@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421113934.55158d51@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and others,

On Fri, Apr 21, 2017 at 11:39:42AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 21 Apr 2017 08:33:12 +0200
> Pavel Machek <pavel@ucw.cz> escreveu:
> 
> > Hi!
> > 
> > > > Better solution would be for VIDEO_EM28XX_V4L2 to depend on GPIOLIB,
> > > > too, no? If not, should there be BUG_ON(priv->pwdn_gpio);
> > > > BUG_ON(priv->resetb_gpio);?  
> > > 
> > > Pavel,
> > > 
> > > The em28xx driver was added upstream several years the gpio driver. 
> > > It controls GPIO using a different logic. It makes no sense to make
> > > it dependent on GPIOLIB, except if someone converts it to use it.  
> > 
> > At least comment in the sourcecode...? Remove pwdn_gpio fields from
> > structure in !GPIOLIB case, because otherwise they are trap for the
> > programmer trying to understand what is going on?
> 
> 
> Sorry, I answered to another e-mail thread related to it. I assumed
> that it was c/c to linux-media, but it is, in fact a private e-mail.

I thought so, too! X-)

> 
> I can see two alternatives:
> 
> 1) Restore old behavior, assuming that all drivers that use OV2640 will
> have GPIOLIB enabled, with a patch like:
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index fd181c99ce11..4e834c36f7da 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -521,6 +521,7 @@ config VIDEO_OV2640
>         tristate "OmniVision OV2640 sensor support"
>         depends on VIDEO_V4L2 && I2C
>         depends on MEDIA_CAMERA_SUPPORT
> +       depends on GPIOLIB if OF
>         help
>           This is a Video4Linux2 sensor-level driver for the OmniVision
>           OV2640 camera.
> 
> However, I was told that some OF drivers don't actually define the GPIO
> pins.
> 
> So, the other option is:
> 
> 2) Make the logic smarter for OF, with this change:
> 
> 
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 4a2ae24f8722..8855c81a9e1f 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -1048,21 +1048,39 @@ static const struct v4l2_subdev_ops ov2640_subdev_ops = {
>  static int ov2640_probe_dt(struct i2c_client *client,
>  		struct ov2640_priv *priv)
>  {
> +	int ret;
> +
>  	/* Request the reset GPIO deasserted */
>  	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
>  			GPIOD_OUT_LOW);
> -	if (!priv->resetb_gpio)
> +	if (!priv->resetb_gpio) {
>  		dev_dbg(&client->dev, "resetb gpio is not assigned!\n");
> -	else if (IS_ERR(priv->resetb_gpio))
> -		return PTR_ERR(priv->resetb_gpio);
> +	} else {
> +		ret = PTR_ERR(priv->resetb_gpio);
> +
> +		if (ret && ret != -ENOSYS) {
> +			dev_dbg(&client->dev,
> +				"Error %d while getting resetb gpio\n",
> +				ret);
> +			return ret;
> +		}
> +	}

This would work. I just wish it'd look nicer. :-)

How about something like:

ret = PTR_ERR(priv->reset_gpio);
if (!priv->reset_gpio) {
	dev_dbg("reset gpio is not assigned");
} else if (ret != -ENOSYS) {
	dev_dbg("error %d while getting reset gpio, ret);
	return ret;
}

I prefer this option as it's not dependent on the system firmware type.

>  
>  	/* Request the power down GPIO asserted */
>  	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
>  			GPIOD_OUT_HIGH);
> -	if (!priv->pwdn_gpio)
> +	if (!priv->pwdn_gpio) {
>  		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
> -	else if (IS_ERR(priv->pwdn_gpio))
> -		return PTR_ERR(priv->pwdn_gpio);
> +	} else {
> +		ret = PTR_ERR(priv->pwdn_gpio);
> +
> +		if (ret && ret != -ENOSYS) {
> +			dev_dbg(&client->dev,
> +				"Error %d while getting pwdn gpio\n",
> +				ret);
> +			return ret;
> +		}
> +	}
>  
>  	return 0;
>  }
> 
> For this to work, OF caller drivers will have to depend or select GPIOLIB,
> if they need those GPIO pins.
> 
> IMHO, (2) is better, but I'd like to hear more opinions from the driver
> authors that require the usage of ov2640 I2C driver.
> 
> > 
> > Plus, something like this, because otherwise it is quite confusing?
> > 
> > Thanks,
> > 								Pavel
> > 
> > diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> > index 56de182..85620e1 100644
> > --- a/drivers/media/i2c/soc_camera/ov2640.c
> > +++ b/drivers/media/i2c/soc_camera/ov2640.c
> > @@ -1060,7 +1060,7 @@ static int ov2640_hw_reset(struct device *dev)
> >  		/* Active the resetb pin to perform a reset pulse */
> >  		gpiod_direction_output(priv->resetb_gpio, 1);
> >  		usleep_range(3000, 5000);
> > -		gpiod_direction_output(priv->resetb_gpio, 0);
> > +		gpiod_set_value(priv->resetb_gpio, 0);
> >  	}
> >  
> >  	return 0;
> > 
> 
> That should be, IMHO, on a separate patch. Why are you changing just
> one of the set commands there? Shouldn't it be, instead:
> 
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 8855c81a9e1f..4ec567569ba2 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -770,12 +770,12 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
>  
>  #ifdef CONFIG_GPIOLIB
>         if (priv->pwdn_gpio)
> -               gpiod_direction_output(priv->pwdn_gpio, !on);
> +               gpiod_set_value(priv->pwdn_gpio, !on);

As long as the direction is first set somewhere... (I haven't checked.)

>         if (on && priv->resetb_gpio) {
>                 /* Active the resetb pin to perform a reset pulse */
> -               gpiod_direction_output(priv->resetb_gpio, 1);
> +               gpiod_set_value(priv->resetb_gpio, 1);
>                 usleep_range(3000, 5000);
> -               gpiod_direction_output(priv->resetb_gpio, 0);
> +               gpiod_set_value(priv->resetb_gpio, 0);
>         }
>  #endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
