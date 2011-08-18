Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab1HRKbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 06:31:17 -0400
Subject: Re: [PATCH] adp1653: make ->power() method optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110818092158.GA8872@valkosipuli.localdomain>
References: <aa45d92c4ec78b36b28eb721ef58f3a5512900a3.1313657559.git.andriy.shevchenko@linux.intel.com>
	 <20110818092158.GA8872@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Aug 2011 13:30:50 +0300
Message-ID: <1313663450.25065.4.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-08-18 at 12:21 +0300, Sakari Ailus wrote: 
> On Thu, Aug 18, 2011 at 11:53:03AM +0300, Andy Shevchenko wrote:
> > The ->power() could be absent or not used on some platforms. This patch makes
> > its presence optional.
> 
> Hi Andy,
> 
> Thanks for the patch!
> 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/adp1653.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> > index 0fd9579..65f6f3f 100644
> > --- a/drivers/media/video/adp1653.c
> > +++ b/drivers/media/video/adp1653.c
> > @@ -309,6 +309,9 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
> >  {
> >  	int ret;
> >  
> > +	if (flash->platform_data->power == NULL)
> > +		return 0;
> > +
> >  	ret = flash->platform_data->power(&flash->subdev, on);
> >  	if (ret < 0)
> >  		return ret;

> How about doing this in adp1653_set_power() instead of
> __adp1653_set_power()? At least I don't see any ill effects from this.
> There's no need to keep track of the power state (flash->power_count) if
> there isn't one. :-)
It was my first assumption. However, the __adp1653_set_power() is used
directly from suspend/resume methods.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
