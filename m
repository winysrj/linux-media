Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1HRLBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 07:01:06 -0400
Subject: Re: [PATCH] adp1653: make ->power() method optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110818105355.GC8872@valkosipuli.localdomain>
References: <aa45d92c4ec78b36b28eb721ef58f3a5512900a3.1313657559.git.andriy.shevchenko@linux.intel.com>
	 <20110818092158.GA8872@valkosipuli.localdomain>
	 <1313663450.25065.4.camel@smile>
	 <20110818105355.GC8872@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Aug 2011 14:00:37 +0300
Message-ID: <1313665237.25065.6.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-08-18 at 13:53 +0300, Sakari Ailus wrote: 
> On Thu, Aug 18, 2011 at 01:30:50PM +0300, Andy Shevchenko wrote:
> > On Thu, 2011-08-18 at 12:21 +0300, Sakari Ailus wrote: 
> > > On Thu, Aug 18, 2011 at 11:53:03AM +0300, Andy Shevchenko wrote:
> > > > The ->power() could be absent or not used on some platforms. This patch makes
> > > > its presence optional.
> > > 
> > > Hi Andy,
> > > 
> > > Thanks for the patch!
> > > 
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > >  drivers/media/video/adp1653.c |    3 +++
> > > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> > > > index 0fd9579..65f6f3f 100644
> > > > --- a/drivers/media/video/adp1653.c
> > > > +++ b/drivers/media/video/adp1653.c
> > > > @@ -309,6 +309,9 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
> > > >  {
> > > >  	int ret;
> > > >  
> > > > +	if (flash->platform_data->power == NULL)
> > > > +		return 0;
> > > > +
> > > >  	ret = flash->platform_data->power(&flash->subdev, on);
> > > >  	if (ret < 0)
> > > >  		return ret;
> > 
> > > How about doing this in adp1653_set_power() instead of
> > > __adp1653_set_power()? At least I don't see any ill effects from this.
> > > There's no need to keep track of the power state (flash->power_count) if
> > > there isn't one. :-)
> > It was my first assumption. However, the __adp1653_set_power() is used
> > directly from suspend/resume methods.
> 
> It is but it won't get called: power_count will be always zero when the
> power() callback doesn't exist.

Ah, now I got the full picture. Yes, if we leave adp1653_set_power()
immediately, then power_count stays 0.

I will send patch v2 soon.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
