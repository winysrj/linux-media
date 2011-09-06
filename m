Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58990 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1IFNJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 09:09:56 -0400
Date: Tue, 6 Sep 2011 16:09:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
Message-ID: <20110906130949.GJ1393@valkosipuli.localdomain>
References: <20110818092158.GA8872@valkosipuli.localdomain>
 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
 <1313667122.25065.8.camel@smile>
 <20110818115131.GD8872@valkosipuli.localdomain>
 <1313674341.25065.17.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313674341.25065.17.camel@smile>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Thu, Aug 18, 2011 at 04:32:21PM +0300, Andy Shevchenko wrote:
> On Thu, 2011-08-18 at 14:51 +0300, Sakari Ailus wrote: 
> > On Thu, Aug 18, 2011 at 02:32:02PM +0300, Andy Shevchenko wrote:
> > > On Thu, 2011-08-18 at 14:22 +0300, Andy Shevchenko wrote: 
> > > > The ->power() could be absent or not used on some platforms. This patch makes
> > > > its presence optional.
> > > > 
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > >  drivers/media/video/adp1653.c |    5 +++++
> > > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> > > > index 0fd9579..f830313 100644
> > > > --- a/drivers/media/video/adp1653.c
> > > > +++ b/drivers/media/video/adp1653.c
> > > > @@ -329,6 +329,11 @@ adp1653_set_power(struct v4l2_subdev *subdev, int on)
> > > >  	struct adp1653_flash *flash = to_adp1653_flash(subdev);
> > > >  	int ret = 0;
> > > >  
> > > > +	/* There is no need to switch power in case of absence ->power()
> > > > +	 * method. */
> > > > +	if (flash->platform_data->power == NULL)
> > > > +		return 0;
> > > > +
> > > >  	mutex_lock(&flash->power_lock);
> > > >  
> > > >  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> > > 
> > > He-h, I guess you are not going to apply this one.
> > > The patch breaks init logic of the device. If we have no ->power(), we
> > > still need to bring the device to the known state. I have no good idea
> > > how to do this.
> > 
> > I don't think it breaks anything actually. Albeit in practice one is still
> > likely to put the adp1653 reset line to the board since that lowers its power
> > consumption significantly.
> Yeah, even in practice we might see various ways of a chip connection.

That's true. But I think the bottom line is that these should be modelled in
a generic way; the last resort is a board specific GPIO or regulator driver.

This is the way ARM platform is moving in Linux and the sooner we adapt to
that, the better. Otherwise we'll be in trouble. Of course we need to
actively make our concerns known for others.

Speaking of which, I don't think Intel (what comes to embedded CPUs) is
necessarily in a very different position than the ARM vendors; ARM is
exhibiting such symptoms not only because the vendors are very inventive
with the hardware but also simply because these systems are embedded
systems. Typically only few if any devices can be probed, for example, and
there are various means for interacting with things like flash controllers.
The same regulators and GPIOs are present there as well and the hardware
description must be somehow available to the drivers.

> > Instead of being in power-up state after opening the flash subdev, it will
> > reach this state already when the system is powered up. At subdev open all
> > the relevant registers are written to anyway, so I don't see an issue here.
> You mean at first writing to the V4L2 value, do you? Because ->open()
> uses set_power() which will be skipped in case of no ->power method
> defined.
> 
> > I think either this one, or one should check in probe() that the power()
> > callback is non-NULL.
> > The board code is going away in the near future so this callback will
> > disappear eventually anyway.
> So, it's up to you to include or not my last patch.

My opinion is that instead of checking the power callback, the platform data
needs to contain the GPIO number instead. The driver can then use the GPIO
framework to toggle it.

> 
> > The gpio code in the board file should likely
> > be moved to the driver itself.
> The line could be different, the hw could be used in environment w/o
> gpio, but with (for example) external gate, and so on. I think current
> generic driver is pretty okay. 
> 
> And what to do with limits? Pass them as the module parameters?
> 
> > That assumes that there will be a gpio which
> > can be used to enable and disable the device and I'm not fully certain this
> > is generic enough. Hopefully it is, but I don't know where else the adp1653
> > would be used than on the N900.
> Don't narrow a chip application to the one device.

We don't, but we also don't generalise something that has no use (yet).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
