Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2I1Nag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 09:30:36 -0400
Date: Fri, 28 Sep 2012 15:30:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] mt9v022: support required register settings in snapshot
 mode
In-Reply-To: <20120928151004.7741efce@wker>
Message-ID: <Pine.LNX.4.64.1209281515480.5428@axis700.grange>
References: <1348786362-28586-1-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1209281428490.5428@axis700.grange> <20120928151004.7741efce@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Sep 2012, Anatolij Gustschin wrote:

> Hi Guennadi,
> 
> On Fri, 28 Sep 2012 14:33:34 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> ...
> > > @@ -235,12 +238,32 @@ static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
> > >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > >  	struct mt9v022 *mt9v022 = to_mt9v022(client);
> > >  
> > > -	if (enable)
> > > +	if (enable) {
> > >  		/* Switch to master "normal" mode */
> > >  		mt9v022->chip_control &= ~0x10;
> > > -	else
> > > +		if (is_mt9v022_rev3(mt9v022->chip_version) ||
> > > +		    is_mt9v024(mt9v022->chip_version)) {
> > > +			/*
> > > +			 * Unset snapshot mode specific settings: clear bit 9
> > > +			 * and bit 2 in reg. 0x20 when in normal mode.
> > > +			 */
> > > +			if (reg_clear(client, MT9V022_REG32, 0x204))
> > > +				return -EIO;
> > > +		}
> > > +	} else {
> > >  		/* Switch to snapshot mode */
> > >  		mt9v022->chip_control |= 0x10;
> > > +		if (is_mt9v022_rev3(mt9v022->chip_version) ||
> > > +		    is_mt9v024(mt9v022->chip_version)) {
> > > +			/*
> > > +			 * Required settings for snapshot mode: set bit 9
> > > +			 * (RST enable) and bit 2 (CR enable) in reg. 0x20
> > > +			 * See TechNote TN0960 or TN-09-225.
> > > +			 */
> > > +			if (reg_set(client, MT9V022_REG32, 0x204))
> > > +				return -EIO;
> > > +		}
> > > +	}
> > 
> > Do I understand it right, that now on mt9v022 rev.3 and mt9v024 you 
> > unconditionally added using REG32 for leaving the snapshot mode on 
> > streamon and entering it on streamoff. This should be ok in principle, 
> > since that's also what we're trying to do, using the CHIP_CONTROL 
> > register. But in your comment you say, that on some _systems_ you can only 
> > _operate_ in snapshot mode. I.e. the snapshot mode enabled during running 
> > streaming, right? Then how does this patch help you with that?
> 
> Yes. But i.e. the driver calling the sub-device stream control function
> on streamon knows that the normal mode is not supported and therefore it
> calls this function with argument enable == 0, effectively setting the
> snapshot mode.

Right, I thought you could be doing that... Well, on the one hand I should 
be happy, that the problem is solved without driver modifications, OTOH 
this isn't pretty... In fact this shouldn't work at all. After a 
stream-off the buffer queue should be stopped too. However, to properly 
implement this you'd have to add a new V4L2 control to switch into 
snapshot mode.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
