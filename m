Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51523 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZCLIkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 04:40:24 -0400
Date: Thu, 12 Mar 2009 09:40:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pcm990 baseboard: add camera bus width switch
	setting
Message-ID: <20090312084022.GG425@pengutronix.de>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de> <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de> <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903120911350.4896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903120911350.4896@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 09:31:55AM +0100, Guennadi Liakhovetski wrote:
> On Wed, 11 Mar 2009, Sascha Hauer wrote:
> 
> > Some Phytec cameras have a I2C GPIO expander which allows it to
> > switch between different sensor bus widths. This was previously
> > handled in the camera driver. Since handling of this switch
> > varies on several boards the cameras are used on, the board
> > support seems a better place to handle the switch
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  arch/arm/mach-pxa/pcm990-baseboard.c |   50 +++++++++++++++++++++++++++------
> >  1 files changed, 41 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
> > index 34841c7..e9feb89 100644
> > --- a/arch/arm/mach-pxa/pcm990-baseboard.c
> > +++ b/arch/arm/mach-pxa/pcm990-baseboard.c
> > @@ -381,14 +381,46 @@ static struct pca953x_platform_data pca9536_data = {
> >  	.gpio_base	= NR_BUILTIN_GPIO + 1,
> >  };
> >  
> > -static struct soc_camera_link iclink[] = {
> > -	{
> > -		.bus_id	= 0, /* Must match with the camera ID above */
> > -		.gpio	= NR_BUILTIN_GPIO + 1,
> > -	}, {
> > -		.bus_id	= 0, /* Must match with the camera ID above */
> > -		.gpio	= -ENXIO,
> > +static int gpio_bus_switch;
> > +
> > +static int pcm990_camera_set_bus_param(struct device *dev,
> 
> The prototype will change to use "struct soc_camera_link *"

OK

> 
> > +		unsigned long flags)
> > +{
> > +	if (gpio_bus_switch <= 0)
> > +		return 0;
> > +
> > +	if (flags & SOCAM_DATAWIDTH_8)
> > +		gpio_set_value(NR_BUILTIN_GPIO + 1, 1);
> > +	else
> > +		gpio_set_value(NR_BUILTIN_GPIO + 1, 0);
> 
> You wanted to use gpio_bus_switch for these.

s/wanted to/should/?

OK

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static unsigned long pcm990_camera_query_bus_param(struct device *dev)
> > +{
> > +	int ret;
> > +
> > +	if (!gpio_bus_switch) {
> > +		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
> > +		if (!ret) {
> > +			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
> > +			gpio_direction_output(gpio_bus_switch, 0);
> > +		} else
> > +			gpio_bus_switch = -1;
> 
> This is a purely internal variable, so, I won't insist if you disagree, 
> but, I think, a scheme "non-negative for a valid value or a negative error 
> code" looks better, cf.
> 
> If you want to initialize a structure with an invalid GPIO number, use
> some negative number (perhaps "-EINVAL"); that will never be valid.
> 
> (Documentation/gpio.txt). "-1" looks like you're going to perform 
> calculations with it.

OK

> 
> >  	}
> > +
> > +	if (gpio_bus_switch > 0)
> > +		return SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_10;
> > +	else
> > +		return SOCAM_DATAWIDTH_10;
> > +}
> > +
> > +static struct soc_camera_link iclink = {
> > +	.bus_id	= 0, /* Must match with the camera ID above */
> > +	.query_bus_param = pcm990_camera_query_bus_param,
> > +	.set_bus_param = pcm990_camera_set_bus_param,
> > +	.gpio	= NR_BUILTIN_GPIO + 1,
> 
> There's one patch missing in your patch series:
> 
> [PATCH 5/5] Remove the "gpio" member from the struct soc_camera_link

OK. I saw this member is unnecessary now and forgot it a minute later...

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
