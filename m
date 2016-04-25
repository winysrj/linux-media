Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52885 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbcDYMwh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 08:52:37 -0400
Date: Mon, 25 Apr 2016 09:52:32 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH] [media] tvp686x: Don't go past array
Message-ID: <20160425095232.12eea9c4@recife.lan>
In-Reply-To: <571E10B7.4060607@xs4all.nl>
References: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
	<571E0159.9050406@xs4all.nl>
	<20160425094000.1dc6db29@recife.lan>
	<571E10B7.4060607@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Apr 2016 14:42:31 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:


> > So, I would go to the following enclosed patch.  
> 
> Looks good to me. Acked below. Amazing how many bugs one can make in one
> simple patch...

Applied, thanks!

Yeah, simple patches are harder than complex ones ;)

> 
> > 
> > Ezequiel,
> > 
> > Btw, I'm not seeing support for fps != 25 (or 30 fps) on this driver.
> > As the device seems to support setting the fps, you should be adding
> > support on it for VIDIOC_S_PARM and VIDIOC_G_PARM.
> > 
> > On both ioctls, the driver should return the actual framerate used.
> > So, you'll need to add a code that would convert from the 15 possible
> > framerate converter register settings to v4l2_fract.
> >   
> >>  
> >>> +			i = 14;		/* 25 fps */
> >>> +		else
> >>> +			i = std_625_50[fps];
> >>> +	} else {
> >>> +		if (unlikely(i > ARRAY_SIZE(std_525_60)))
> >>> +			i = 0;		/* 30 fps */
> >>> +		else
> >>> +			i = std_525_60[fps];
> >>> +	}
> >>>  
> >>>  	return map[i];
> >>>  }
> >>>     
> >>
> >> Regards,
> >>
> >> 	Hans  
> > 
> > Thanks,
> > Mauro
> > 
> > -
> > 
> > [media] tw686x: Don't go past array
> > 
> > Depending on the compiler version, currently it produces the
> > following warnings:
> > 	tw686x-video.c: In function 'tw686x_video_init':
> > 	tw686x-video.c:65:543: warning: array subscript is above array bounds [-Warray-bounds]
> > 
> > This is actually bogus with the current code, as it currently
> > hardcodes the framerate to 30 frames/sec, however a potential
> > use after the array size could happen when the driver adds support
> > for setting the framerate. So, fix it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> > 
> > diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> > index 118e9fac9f28..9468fda69f3d 100644
> > --- a/drivers/media/pci/tw686x/tw686x-video.c
> > +++ b/drivers/media/pci/tw686x/tw686x-video.c
> > @@ -61,8 +61,17 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
> >  		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
> >  	};
> >  
> > -	unsigned int i =
> > -		(std & V4L2_STD_625_50) ? std_625_50[fps] : std_525_60[fps];
> > +	unsigned int i;
> > +
> > +	if (std & V4L2_STD_525_60) {
> > +		if (fps > ARRAY_SIZE(std_525_60))
> > +			fps = 30;
> > +		i = std_525_60[fps];
> > +	} else {
> > +		if (fps > ARRAY_SIZE(std_625_50))
> > +			fps = 25;
> > +		i = std_625_50[fps];
> > +	}
> >  
> >  	return map[i];
> >  }
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
> 


-- 
Thanks,
Mauro
