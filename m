Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab2HXOdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 10:33:01 -0400
Date: Fri, 24 Aug 2012 16:32:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 2/3] mt9v022: fix the V4L2_CID_EXPOSURE control
In-Reply-To: <20120824161756.5cedec79@wker>
Message-ID: <Pine.LNX.4.64.1208241632130.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-3-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1208241320330.20710@axis700.grange> <20120824161756.5cedec79@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012, Anatolij Gustschin wrote:

> Hi Guennadi,
> 
> On Fri, 24 Aug 2012 13:22:18 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> ...
> > > --- a/drivers/media/i2c/soc_camera/mt9v022.c
> > > +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> > > @@ -274,9 +274,9 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> > >  		if (ret & 1) /* Autoexposure */
> > >  			ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
> > >  					rect.height + mt9v022->y_skip_top + 43);
> > > -		else
> > > -			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
> > > -					rect.height + mt9v022->y_skip_top + 43);
> > > +		else /* Set to the manually controlled value */
> > > +			ret = v4l2_ctrl_s_ctrl(mt9v022->exposure,
> > > +					       mt9v022->exposure->val);
> > 
> > But why do we have to write it here at all then? Autoexposure can be off 
> > only if the user has set exposure manually, using V4L2_CID_EXPOSURE_AUTO. 
> > In this case MT9V022_TOTAL_SHUTTER_WIDTH already contains the correct 
> > value. Why do we have to set it again? Maybe just adding a comment, 
> > explaining the above, would suffice?
> 
> Actually we do not have to write it here, yes. Should I remove the shutter
> register setting here entirely? And add a comment explaining, why?

Remove it from the "else" clause, yes, please. And a comment would be 
good!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
