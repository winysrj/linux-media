Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1IRQM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 12:12:26 -0400
Date: Sun, 18 Sep 2011 18:12:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Takashi.Namiki@renesas.com, Phil.Edworthy@renesas.com
Subject: Re: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
In-Reply-To: <4E76149D.5050102@redhat.com>
Message-ID: <Pine.LNX.4.64.1109181808410.9975@axis700.grange>
References: <uock8ky42.wl%morimoto.kuninori@renesas.com> <4E76149D.5050102@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Sep 2011, Mauro Carvalho Chehab wrote:

> Em 02-02-2010 02:54, Kuninori Morimoto escreveu:
> > mt9t112 camera needs 100 milliseconds for initializing
> > Special thanks to Phil
> > 
> > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > Reported-by: Phil Edworthy <Phil.Edworthy@renesas.com>
> > ---
> >  drivers/media/video/mt9t112.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> > index 7438f8d..e581d8a 100644
> > --- a/drivers/media/video/mt9t112.c
> > +++ b/drivers/media/video/mt9t112.c
> > @@ -885,7 +885,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
> >  		/* Invert PCLK (Data sampled on falling edge of pixclk) */
> >  		mt9t112_reg_write(ret, client, 0x3C20, param);
> >  
> > -		mdelay(5);
> > +		mdelay(100);
> >  
> >  		priv->flags |= INIT_DONE;
> >  	}
> 
> Hi Guennadi,
> 
> What's the status of this patch?
> 
> It applies ok for me, and I couldn't find any reference at the
> ML why it was not applied yet.

Hm, yeah... Looks like also this patch:

> Subject: [PATCH 3/3] soc-camera: mt9t112: The flag which control camera-init is removed
> 
> mt9t112 should always be initialized when camera start.
> Because current driver doesn't run this operation,
> it will be un-stable if user side player run open/close several times.
> Special thanks to Namiki-san
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> Reported-by: Takashi Namiki <Takashi.Namiki@renesas.com>

has not been applied nor discussed on the list... For patches that old I 
would tend to say: if the author / submitter didn't re-submit, then, 
probably, patches aren't relevant anymore... Although it is quite 
possible, that I failed to process them back then. Morimoto-san, do you 
have any information on these patches? Have these problems been solved 
somehow, so that the patches have become obsolete, or are the problems, 
that they address, still there?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
