Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55847 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1HRN4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 09:56:01 -0400
Date: Thu, 18 Aug 2011 16:55:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
Message-ID: <20110818135556.GE8872@valkosipuli.localdomain>
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
> 
> > Instead of being in power-up state after opening the flash subdev, it will
> > reach this state already when the system is powered up. At subdev open all
> > the relevant registers are written to anyway, so I don't see an issue here.
> You mean at first writing to the V4L2 value, do you? Because ->open()
> uses set_power() which will be skipped in case of no ->power method
> defined.

Oh. I missed that adp1653_init_device() is being called in
__adp1653_set_power(). That's quite important. It still needs to be called,
at least once between probe() and first open().

I'm beginning to think we should require power() callback and fail in
probe() if it doesn't exist, or directly make it a gpio.

My plan is to get the N900 board code with the rest of the subdev drivers to
mainline at some point but that will likely take quite a bit of calendar
time, unfortunately. The adp1653 driver and the flash interface was just a
first part of it.

> > I think either this one, or one should check in probe() that the power()
> > callback is non-NULL.
> > The board code is going away in the near future so this callback will
> > disappear eventually anyway.
> So, it's up to you to include or not my last patch.
> 
> > The gpio code in the board file should likely
> > be moved to the driver itself.
> The line could be different, the hw could be used in environment w/o
> gpio, but with (for example) external gate, and so on. I think current
> generic driver is pretty okay. 
> 
> And what to do with limits? Pass them as the module parameters?

Limits still do belong to platform data. They are board dependent. Bad
limits may cause the all-important smoke to escape from the board. :-)

> > That assumes that there will be a gpio which
> > can be used to enable and disable the device and I'm not fully certain this
> > is generic enough. Hopefully it is, but I don't know where else the adp1653
> > would be used than on the N900.
> Don't narrow a chip application to the one device.

It's not useful to generalise this until it is useful for something. I
assume the chip will be connected to a gpio in practice. If there are
exceptions then we need to think again what to do.

Board code which contains functions is a problem in general since it cannot
be meaningfully converted to the device tree which can only contain static
data. This is an issue for complex systems such as digital cameras in
general, I hope a means to have board code will be left even after the
device tree conversion.

Regrads,

-- 
Sakari Ailus
sakari.ailus@iki.fi
