Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41480 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZDNJiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 05:38:22 -0400
Date: Tue, 14 Apr 2009 11:38:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch
	setting
Message-ID: <20090414093820.GF14383@pengutronix.de>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de> <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de> <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903121405150.4896@axis700.grange> <20090312141819.GN425@pengutronix.de> <Pine.LNX.4.64.0904092339320.4841@axis700.grange> <Pine.LNX.4.64.0904141053230.1587@axis700.grange> <20090414091005.GA14383@pengutronix.de> <Pine.LNX.4.64.0904141115070.1587@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904141115070.1587@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 14, 2009 at 11:20:03AM +0200, Guennadi Liakhovetski wrote:
> On Tue, 14 Apr 2009, Sascha Hauer wrote:
> 
> > On Tue, Apr 14, 2009 at 10:57:32AM +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 9 Apr 2009, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > > > +static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!gpio_bus_switch) {
> > > > > +		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
> > > > 
> > > > There's no gpio_free() now... So, for example, you cannot unload the 
> > > > extender driver any more, unloading i2c adapter driver (i2c-pxa) produces 
> > > > ugly stuff like
> > > > 
> > > > pca953x 0-0041: gpiochip_remove() failed, -16
> > > > 
> > > > So, we either have to request and free the GPIO in each query / set, or we 
> > > > need an explicit .free_bus() call in soc_camera_link. None of the two 
> > > > really pleases me, but maybe the latter is slightly less ugly, what do you 
> > > > think?
> > > > 
> > > > Thanks
> > > > Guennadi
> > > > 
> > > > > +		if (!ret) {
> > > > > +			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
> > > > > +			gpio_direction_output(gpio_bus_switch, 0);
> > > > > +		} else
> > > > > +			gpio_bus_switch = -EINVAL;
> > > > >  	}
> > > 
> > > If you first do not load pca953x and try to start capture, thus calling 
> > > pcm990_camera_query_bus_param(), gpio_request() will fail and you get 
> > > gpio_bus_switch < 0. Then if you load pca953x it doesn't help any more - 
> > > by testing for "if (!gpio_bus_switch)" you do not retry after the first 
> > > error.
> > 
> > So how do we proceed? Add init/exit functions for the bus?
> 
> If you don't object, I'll just add a .free_bus method to soc_camera_link, 
> and switch pcm990 to only use two values: a negative value for a 
> non-allocated gpio - either before the first attempt or after an error, 
> thus re-trying every time if gpio is negative, in case a driver has been 
> loaded in the meantime.

For the sake of symmetry, shouldn't we have an init function aswell?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
