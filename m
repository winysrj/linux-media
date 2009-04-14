Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41233 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751166AbZDNJTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 05:19:54 -0400
Date: Tue, 14 Apr 2009 11:20:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch setting
In-Reply-To: <20090414091005.GA14383@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0904141115070.1587@axis700.grange>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.0903121405150.4896@axis700.grange> <20090312141819.GN425@pengutronix.de>
 <Pine.LNX.4.64.0904092339320.4841@axis700.grange>
 <Pine.LNX.4.64.0904141053230.1587@axis700.grange> <20090414091005.GA14383@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 14 Apr 2009, Sascha Hauer wrote:

> On Tue, Apr 14, 2009 at 10:57:32AM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 9 Apr 2009, Guennadi Liakhovetski wrote:

[snip]

> > > > +static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (!gpio_bus_switch) {
> > > > +		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
> > > 
> > > There's no gpio_free() now... So, for example, you cannot unload the 
> > > extender driver any more, unloading i2c adapter driver (i2c-pxa) produces 
> > > ugly stuff like
> > > 
> > > pca953x 0-0041: gpiochip_remove() failed, -16
> > > 
> > > So, we either have to request and free the GPIO in each query / set, or we 
> > > need an explicit .free_bus() call in soc_camera_link. None of the two 
> > > really pleases me, but maybe the latter is slightly less ugly, what do you 
> > > think?
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > > +		if (!ret) {
> > > > +			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
> > > > +			gpio_direction_output(gpio_bus_switch, 0);
> > > > +		} else
> > > > +			gpio_bus_switch = -EINVAL;
> > > >  	}
> > 
> > If you first do not load pca953x and try to start capture, thus calling 
> > pcm990_camera_query_bus_param(), gpio_request() will fail and you get 
> > gpio_bus_switch < 0. Then if you load pca953x it doesn't help any more - 
> > by testing for "if (!gpio_bus_switch)" you do not retry after the first 
> > error.
> 
> So how do we proceed? Add init/exit functions for the bus?

If you don't object, I'll just add a .free_bus method to soc_camera_link, 
and switch pcm990 to only use two values: a negative value for a 
non-allocated gpio - either before the first attempt or after an error, 
thus re-trying every time if gpio is negative, in case a driver has been 
loaded in the meantime.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
