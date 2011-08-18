Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1HRNcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 09:32:48 -0400
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110818115131.GD8872@valkosipuli.localdomain>
References: <20110818092158.GA8872@valkosipuli.localdomain>
	 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
	 <1313667122.25065.8.camel@smile>
	 <20110818115131.GD8872@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Aug 2011 16:32:21 +0300
Message-ID: <1313674341.25065.17.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-08-18 at 14:51 +0300, Sakari Ailus wrote: 
> On Thu, Aug 18, 2011 at 02:32:02PM +0300, Andy Shevchenko wrote:
> > On Thu, 2011-08-18 at 14:22 +0300, Andy Shevchenko wrote: 
> > > The ->power() could be absent or not used on some platforms. This patch makes
> > > its presence optional.
> > > 
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > >  drivers/media/video/adp1653.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> > > index 0fd9579..f830313 100644
> > > --- a/drivers/media/video/adp1653.c
> > > +++ b/drivers/media/video/adp1653.c
> > > @@ -329,6 +329,11 @@ adp1653_set_power(struct v4l2_subdev *subdev, int on)
> > >  	struct adp1653_flash *flash = to_adp1653_flash(subdev);
> > >  	int ret = 0;
> > >  
> > > +	/* There is no need to switch power in case of absence ->power()
> > > +	 * method. */
> > > +	if (flash->platform_data->power == NULL)
> > > +		return 0;
> > > +
> > >  	mutex_lock(&flash->power_lock);
> > >  
> > >  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> > 
> > He-h, I guess you are not going to apply this one.
> > The patch breaks init logic of the device. If we have no ->power(), we
> > still need to bring the device to the known state. I have no good idea
> > how to do this.
> 
> I don't think it breaks anything actually. Albeit in practice one is still
> likely to put the adp1653 reset line to the board since that lowers its power
> consumption significantly.
Yeah, even in practice we might see various ways of a chip connection.

> Instead of being in power-up state after opening the flash subdev, it will
> reach this state already when the system is powered up. At subdev open all
> the relevant registers are written to anyway, so I don't see an issue here.
You mean at first writing to the V4L2 value, do you? Because ->open()
uses set_power() which will be skipped in case of no ->power method
defined.

> I think either this one, or one should check in probe() that the power()
> callback is non-NULL.
> The board code is going away in the near future so this callback will
> disappear eventually anyway.
So, it's up to you to include or not my last patch.

> The gpio code in the board file should likely
> be moved to the driver itself.
The line could be different, the hw could be used in environment w/o
gpio, but with (for example) external gate, and so on. I think current
generic driver is pretty okay. 

And what to do with limits? Pass them as the module parameters?

> That assumes that there will be a gpio which
> can be used to enable and disable the device and I'm not fully certain this
> is generic enough. Hopefully it is, but I don't know where else the adp1653
> would be used than on the N900.
Don't narrow a chip application to the one device.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
