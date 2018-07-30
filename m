Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2075 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbeG3Jie (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 05:38:34 -0400
Date: Mon, 30 Jul 2018 11:04:44 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] mt9v111: Fix compiler warning by initialising a
 variable
Message-ID: <20180730080444.7l3kptqbj7cmfiug@paasikivi.fi.intel.com>
References: <20180730072627.32014-1-sakari.ailus@linux.intel.com>
 <20180730075125.GE7615@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730075125.GE7615@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2018 at 09:51:25AM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Mon, Jul 30, 2018 at 10:26:27AM +0300, Sakari Ailus wrote:
> > While this isn't a bug, initialise the variable to quash the warning.
> >
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/i2c/mt9v111.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
> > index da8f6ab91307..58d5f2224bff 100644
> > --- a/drivers/media/i2c/mt9v111.c
> > +++ b/drivers/media/i2c/mt9v111.c
> > @@ -884,7 +884,7 @@ static int mt9v111_set_format(struct v4l2_subdev *subdev,
> >  	struct v4l2_mbus_framefmt new_fmt;
> >  	struct v4l2_mbus_framefmt *__fmt;
> >  	unsigned int best_fit = ~0L;
> > -	unsigned int idx;
> > +	unsigned int idx = 0;
> >  	unsigned int i;
> >
> 
> Thanks for this, but there is already a patch sent on Friday by Jasmin
> addressing the warning
> 
> https://patchwork.kernel.org/patch/10547983/

Ah, ok. I'll mark this as rejected then.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
