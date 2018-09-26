Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:14717 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbeIZNuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 09:50:22 -0400
Date: Wed, 26 Sep 2018 10:38:44 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH 1/1] v4l: Remove support for crop default target in
 subdev drivers
Message-ID: <20180926073844.m7ioanhq2zzlcfcb@kekkonen.localdomain>
References: <20180924144227.31237-1-sakari.ailus@linux.intel.com>
 <20180925063329.vnes4q2rdzn4e7c7@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925063329.vnes4q2rdzn4e7c7@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

On Tue, Sep 25, 2018 at 08:33:29AM +0200, Helmut Grohne wrote:
> On Mon, Sep 24, 2018 at 04:42:27PM +0200, Sakari Ailus wrote:
> > --- a/drivers/media/i2c/mt9t112.c
> > +++ b/drivers/media/i2c/mt9t112.c
> > @@ -888,12 +888,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
> >  		sel->r.width = MAX_WIDTH;
> >  		sel->r.height = MAX_HEIGHT;
> >  		return 0;
> > -	case V4L2_SEL_TGT_CROP_DEFAULT:
> > -		sel->r.left = 0;
> > -		sel->r.top = 0;
> > -		sel->r.width = VGA_WIDTH;
> > -		sel->r.height = VGA_HEIGHT;
> > -		return 0;
> >  	case V4L2_SEL_TGT_CROP:
> >  		sel->r = priv->frame;
> >  		return 0;
> 
> Together with the change in soc_scale_crop.c, this constitutes an
> (unintentional?) behaviour change. It was formerly reporting 640x480 and
> will now be reporting 2048x1536. I cannot tell whether that is
> reasonable.

I'd say "yes". This is the only sub-device driver that puts a default other
than the bounds there. Its source is SoC camera as you see below.

> 
> > --- a/drivers/media/i2c/soc_camera/mt9t112.c
> > +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> > @@ -884,12 +884,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
> >  		sel->r.width = MAX_WIDTH;
> >  		sel->r.height = MAX_HEIGHT;
> >  		return 0;
> > -	case V4L2_SEL_TGT_CROP_DEFAULT:
> > -		sel->r.left = 0;
> > -		sel->r.top = 0;
> > -		sel->r.width = VGA_WIDTH;
> > -		sel->r.height = VGA_HEIGHT;
> > -		return 0;
> >  	case V4L2_SEL_TGT_CROP:
> >  		sel->r = priv->frame;
> >  		return 0;
> 
> This one looks duplicate. Is there a good reason to have two drivers for
> mt9t112? This is lilely out of scope for the patch. Cced Jacopo Mondi as
> he introduced the copy.
> 
> Other than your patch looks fine to me.
> 
> Helmut

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
