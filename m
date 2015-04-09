Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60297 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbbDIHte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 03:49:34 -0400
Date: Thu, 9 Apr 2015 10:49:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] Add device tree support to
 adp1653 flash driver
Message-ID: <20150409074929.GA20756@valkosipuli.retiisi.org.uk>
References: <E1Yg11T-00074E-Hx@www.linuxtv.org>
 <55261B75.1070400@xs4all.nl>
 <20150409073054.GA20325@amd>
 <55262B68.8040408@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55262B68.8040408@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Apr 09, 2015 at 09:34:00AM +0200, Hans Verkuil wrote:
...
> >>> --- a/drivers/media/i2c/adp1653.c
> >>> +++ b/drivers/media/i2c/adp1653.c
> >>> @@ -306,9 +309,17 @@ adp1653_init_device(struct adp1653_flash *flash)
> >>>  static int
> >>>  __adp1653_set_power(struct adp1653_flash *flash, int on)
> >>>  {
> >>> -	int ret;
> >>> +	int ret = 0;
> >>> +
> >>> +	if (flash->platform_data->power) {
> >>> +		ret = flash->platform_data->power(&flash->subdev, on);
> >>> +	} else {
> >>> +		gpio_set_value(flash->platform_data->power_gpio, on);
> >>
> >> The power_gpio field is not found in struct adp1653_platform_data.
> > 
> > Yes, int power_gpio should be added into that struct.
> > 
> >> Can you fix this?
> >>
> >> I'm also getting this warning:
> > 
> > Well, old version of patch was merged while new versions were getting
> > discussed / developed in another mail thread.
> > 
> > I guess best course of action is to drop this from Mauro's tree, as
> > conflicting patch exists in Sakari's tree...?
> 
> Sakari, do you agree? How did this patch manage to be merged? Was it not
> marked Superseded?

I don't know why that was merged. The patch is an old version of the adp1653
DT support patch, which was agreed to split into two: DT binding
documentation and the driver changes. As Pavel said, the DT documentation
patch is in my tree.

Mauro, could you revert it, please?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
