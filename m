Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZCLJrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:47:07 -0400
Date: Thu, 12 Mar 2009 10:47:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pcm990 baseboard: add camera bus width switch
	setting
Message-ID: <20090312094703.GK425@pengutronix.de>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de> <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de> <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903120935570.4896@axis700.grange> <20090312091221.GJ425@pengutronix.de> <Pine.LNX.4.64.0903121024010.4896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903121024010.4896@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 10:25:35AM +0100, Guennadi Liakhovetski wrote:
> On Thu, 12 Mar 2009, Sascha Hauer wrote:
> 
> > On Thu, Mar 12, 2009 at 09:40:46AM +0100, Guennadi Liakhovetski wrote:
> > > One more thing I noticed while looking at your patch 3/4:
> > > 
> > > > +static int pcm990_camera_set_bus_param(struct device *dev,
> > > > +		unsigned long flags)
> > > > +{
> > > > +	if (gpio_bus_switch <= 0)
> > > > +		return 0;
> > > > +
> > > > +	if (flags & SOCAM_DATAWIDTH_8)
> > > > +		gpio_set_value(NR_BUILTIN_GPIO + 1, 1);
> > > > +	else
> > > > +		gpio_set_value(NR_BUILTIN_GPIO + 1, 0);
> > > 
> > > Originally the logic here was "only if flags == SOCAM_DATAWIDTH_8, switch 
> > > to 8 bits, otherwise do 10 bits. I.e., if flags == SOCAM_DATAWIDTH_8 | 
> > > SOCAM_DATAWIDTH_10, it would still do the default (and wider) 10 bits. Do 
> > > you have any reason to change that logic?
> > 
> > I was not aware that I changed any logic. I thought I would get here
> > with only one of the SOCAM_DATAWIDTH_* set. Isn't it a bug when we get
> > here with more than one width flags set?
> > 
> > The mt9v022 driver has this in set_bus_param:
> > 
> > >
> > >	/* Only one width bit may be set */
> > >	if (!is_power_of_2(width_flag))
> > >		return -EINVAL;
> > >
> > 
> > And I think it makes sense.
> 
> Ok, then, could you, please add the same test to mt9m001? And, as I 
> mentioned in a comment to 3/4, please, return an error if switching is 
> requested but unsupported.

Ok, will do.

It may be that we need a different approach to the bus width setting in
the longer term. For example the mt9m001 can support any thinkable bus
width of 1 to inf. bits. This depends on the hardware designer who wired
up the connection and not the physical count of data lines the chip has.
I have no idea how to implement this though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
