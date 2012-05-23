Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47798 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab2EWLbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 07:31:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] as3645a: Remove set_power() from platform data
Date: Wed, 23 May 2012 13:31:26 +0200
Message-ID: <9767260.z6C75JdBQb@avalon>
In-Reply-To: <20120523111951.GU3373@valkosipuli.retiisi.org.uk>
References: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi> <5818890.hvZb7JEbAH@avalon> <20120523111951.GU3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 23 May 2012 14:19:51 Sakari Ailus wrote:
> On Wed, May 23, 2012 at 01:00:08PM +0200, Laurent Pinchart wrote:
> > On Wednesday 16 May 2012 06:12:49 Sakari Ailus wrote:
> > > The chip is typically powered constantly and no board uses the
> > > set_power() callback. Remove it.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/video/as3645a.c |   39
> > >  +++++++++----------------------------
> > >  include/media/as3645a.h       |    1 -
> > >  2 files changed, 9 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/as3645a.c
> > > b/drivers/media/video/as3645a.c
> > > index c4b0357..7454660 100644
> > > --- a/drivers/media/video/as3645a.c
> > > +++ b/drivers/media/video/as3645a.c
> > > @@ -512,31 +512,6 @@ static int as3645a_setup(struct as3645a *flash)
> > > 
> > >  	return ret & ~AS_FAULT_INFO_LED_AMOUNT ? -EIO : 0;
> > >  
> > >  }
> > > 
> > > -static int __as3645a_set_power(struct as3645a *flash, int on)
> > > -{
> > > -	int ret;
> > > -
> > > -	if (!on)
> > > -		as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> > > -
> > > -	if (flash->pdata->set_power) {
> > > -		ret = flash->pdata->set_power(&flash->subdev, on);
> > > -		if (ret < 0)
> > > -			return ret;
> > > -	}
> > > -
> > > -	if (!on)
> > > -		return 0;
> > > -
> > > -	ret = as3645a_setup(flash);
> > > -	if (ret < 0) {
> > > -		if (flash->pdata->set_power)
> > > -			flash->pdata->set_power(&flash->subdev, 0);
> > > -	}
> > > -
> > > -	return ret;
> > > -}
> > > -
> > > 
> > >  static int as3645a_set_power(struct v4l2_subdev *sd, int on)
> > >  {
> > >  
> > >  	struct as3645a *flash = to_as3645a(sd);
> > > 
> > > @@ -545,9 +520,13 @@ static int as3645a_set_power(struct v4l2_subdev
> > > *sd,
> > > int on) mutex_lock(&flash->power_lock);
> > > 
> > >  	if (flash->power_count == !on) {
> > > 
> > > -		ret = __as3645a_set_power(flash, !!on);
> > > -		if (ret < 0)
> > > -			goto done;
> > > +		if (!on) {
> > > +			as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> > > +		} else {
> > > +			ret = as3645a_setup(flash);
> > > +			if (ret < 0)
> > > +				goto done;
> > > +		}
> > > 
> > >  	}
> > 
> > If the chip is powered on constantly, why do we need a .s_power() subdev
> > operation at all ?
> 
> I don't know why was it there in the first place. Probably to make it easier
> to use the driver on boards that required e.g. a regulator for the chip.
> 
> But typically they're connected to battery directly. The idle power
> consumption is just some tens of µA.

What about on the N9 ?

-- 
Regards,

Laurent Pinchart

