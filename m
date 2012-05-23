Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33765 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754552Ab2EWLT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 07:19:56 -0400
Date: Wed, 23 May 2012 14:19:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] as3645a: Remove set_power() from platform data
Message-ID: <20120523111951.GU3373@valkosipuli.retiisi.org.uk>
References: <1337137969-30575-1-git-send-email-sakari.ailus@iki.fi>
 <5818890.hvZb7JEbAH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5818890.hvZb7JEbAH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, May 23, 2012 at 01:00:08PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Wednesday 16 May 2012 06:12:49 Sakari Ailus wrote:
> > The chip is typically powered constantly and no board uses the set_power()
> > callback. Remove it.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/as3645a.c |   39 +++++++++----------------------------
> >  include/media/as3645a.h       |    1 -
> >  2 files changed, 9 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> > index c4b0357..7454660 100644
> > --- a/drivers/media/video/as3645a.c
> > +++ b/drivers/media/video/as3645a.c
> > @@ -512,31 +512,6 @@ static int as3645a_setup(struct as3645a *flash)
> >  	return ret & ~AS_FAULT_INFO_LED_AMOUNT ? -EIO : 0;
> >  }
> > 
> > -static int __as3645a_set_power(struct as3645a *flash, int on)
> > -{
> > -	int ret;
> > -
> > -	if (!on)
> > -		as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> > -
> > -	if (flash->pdata->set_power) {
> > -		ret = flash->pdata->set_power(&flash->subdev, on);
> > -		if (ret < 0)
> > -			return ret;
> > -	}
> > -
> > -	if (!on)
> > -		return 0;
> > -
> > -	ret = as3645a_setup(flash);
> > -	if (ret < 0) {
> > -		if (flash->pdata->set_power)
> > -			flash->pdata->set_power(&flash->subdev, 0);
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> >  static int as3645a_set_power(struct v4l2_subdev *sd, int on)
> >  {
> >  	struct as3645a *flash = to_as3645a(sd);
> > @@ -545,9 +520,13 @@ static int as3645a_set_power(struct v4l2_subdev *sd,
> > int on) mutex_lock(&flash->power_lock);
> > 
> >  	if (flash->power_count == !on) {
> > -		ret = __as3645a_set_power(flash, !!on);
> > -		if (ret < 0)
> > -			goto done;
> > +		if (!on) {
> > +			as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> > +		} else {
> > +			ret = as3645a_setup(flash);
> > +			if (ret < 0)
> > +				goto done;
> > +		}
> >  	}
> > 
> 
> If the chip is powered on constantly, why do we need a .s_power() subdev 
> operation at all ?

I don't know why was it there in the first place. Probably to make it easier
to use the driver on boards that required e.g. a regulator for the chip.

But typically they're connected to battery directly. The idle power
consumption is just some tens of µA.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
