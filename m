Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1GQQxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 12:53:51 -0400
Date: Sun, 17 Jul 2011 18:53:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] mt9m111: move lastpage to struct mt9m111 for multi
 instances
In-Reply-To: <201107141727.24309.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107171853100.13485@axis700.grange>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
 <1310485146-27759-3-git-send-email-m.grzeschik@pengutronix.de>
 <201107141727.24309.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 Jul 2011, Laurent Pinchart wrote:

> Hi Michael,
> 
> On Tuesday 12 July 2011 17:39:04 Michael Grzeschik wrote:
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/media/video/mt9m111.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index e08b46c..8ad99a9 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> > @@ -170,6 +170,7 @@ struct mt9m111 {
> >  	enum mt9m111_context context;
> >  	struct v4l2_rect rect;
> >  	const struct mt9m111_datafmt *fmt;
> > +	int lastpage;
> >  	unsigned int gain;
> >  	unsigned char autoexposure;
> >  	unsigned char datawidth;
> > @@ -192,17 +193,17 @@ static int reg_page_map_set(struct i2c_client
> > *client, const u16 reg) {
> >  	int ret = 0;
> >  	u16 page;
> > -	static int lastpage = -1;	/* PageMap cache value */
> 
> You're loosing lastpage initialization to -1.

Seconded. A fixed version of this patch will ve welcome for 3.2.

Thanks
Guennadi

> 
> > +	struct mt9m111 *mt9m111 = to_mt9m111(client);
> > 
> >  	page = (reg >> 8);
> > -	if (page == lastpage)
> > +	if (page == mt9m111->lastpage)
> >  		return 0;
> >  	if (page > 2)
> >  		return -EINVAL;
> > 
> >  	ret = i2c_smbus_write_word_data(client, MT9M111_PAGE_MAP, swab16(page));
> >  	if (!ret)
> > -		lastpage = page;
> > +		mt9m111->lastpage = page;
> >  	return ret;
> >  }
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
