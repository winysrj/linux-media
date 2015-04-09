Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52945 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbDIHa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 03:30:57 -0400
Date: Thu, 9 Apr 2015 09:30:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [git:media_tree/master] [media] Add device tree support to
 adp1653 flash driver
Message-ID: <20150409073054.GA20325@amd>
References: <E1Yg11T-00074E-Hx@www.linuxtv.org>
 <55261B75.1070400@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55261B75.1070400@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Hi Pawel,

Me?

> This driver doesn't compile:
> 
> On 04/08/2015 10:46 PM, Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following patch were queued at the 
> > http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> > 

> > --- a/drivers/media/i2c/adp1653.c
> > +++ b/drivers/media/i2c/adp1653.c
> > @@ -306,9 +309,17 @@ adp1653_init_device(struct adp1653_flash *flash)
> >  static int
> >  __adp1653_set_power(struct adp1653_flash *flash, int on)
> >  {
> > -	int ret;
> > +	int ret = 0;
> > +
> > +	if (flash->platform_data->power) {
> > +		ret = flash->platform_data->power(&flash->subdev, on);
> > +	} else {
> > +		gpio_set_value(flash->platform_data->power_gpio, on);
> 
> The power_gpio field is not found in struct adp1653_platform_data.

Yes, int power_gpio should be added into that struct.

> Can you fix this?
> 
> I'm also getting this warning:

Well, old version of patch was merged while new versions were getting
discussed / developed in another mail thread.

I guess best course of action is to drop this from Mauro's tree, as
conflicting patch exists in Sakari's tree...?

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
