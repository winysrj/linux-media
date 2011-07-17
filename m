Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1GQQwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 12:52:49 -0400
Date: Sun, 17 Jul 2011 18:52:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] mt9m111: set inital return values to zero
In-Reply-To: <201107141725.21401.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107171844150.13485@axis700.grange>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
 <201107141725.21401.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 Jul 2011, Laurent Pinchart wrote:

> Hi Michael,
> 
> There's no need to set initial return values to zero if they're assigned to in 
> all code paths.
> 
> [snip]
> 
> > *client) static int mt9m111_enable(struct i2c_client *client)
> >  {
> >  	struct mt9m111 *mt9m111 = to_mt9m111(client);
> > -	int ret;
> > +	int ret = 0;
> > 
> >  	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
> >  	if (!ret)
> 
> This is a clear example, ret will never be used uninitialized. Initializing it 
> to 0 would be a waste of resources (although in this case it will probably be 
> optimized out by the compiler).

Seconded. When I wrote:

> > +static int mt9m111_reg_mask(struct i2c_client *client, const u16 reg,
> > +			    const u16 data, const u16 mask)
> > +{
> > +	int ret;
> > +
> > +	ret = mt9m111_reg_read(client, reg);
> > +	return mt9m111_reg_write(client, reg, (ret & ~mask) | data);
> 
> Ok, I feel ashamed, that I have accepted this driver in this form... It is 
> full of such buggy error handling instances, and this adds just one 
> more... So, I would very appreciate if you could clean them up - before 
> this patch, and handle this error properly too, otherwise I might do this 
> myself some time... And, just noticed - "static int lastpage" from 
> reg_page_map_set() must be moved into struct mt9m111, if this driver shall 
> be able to handle more than one sensor simultaneously, at least in 
> principle...

I didn't mean to init all return codes to 0. I meant, before using a 
result of a reg_read(), you have to check it for error. I.e.,

+	ret = mt9m111_reg_read(client, reg);
+	if (ret >= 0)
+		ret = mt9m111_reg_write(client, reg, (ret & ~mask) | data);
+	return ret;

In principle, after the updated version of your patch "mt9m111: rewrite 
set_pixfmt" all errors, returned by reg_read(), reg_write() and reg_mask() 
are checked, even if some of them I would do a bit differently. E.g., I 
would propagate the error code instead of replacing it with -EIO, etc. But 
in principle all error cases are handled, so, we can live with that for 
now. I'm dropping this patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
