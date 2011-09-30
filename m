Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1I3JTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 05:19:17 -0400
Date: Fri, 30 Sep 2011 11:19:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Takashi.Namiki@renesas.com, phil.edworthy@renesas.com
Subject: Re: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
In-Reply-To: <Pine.LNX.4.64.1109200931210.11274@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109301116130.1888@axis700.grange>
References: <uock8ky42.wl%morimoto.kuninori@renesas.com> <4E76149D.5050102@redhat.com>
 <Pine.LNX.4.64.1109181808410.9975@axis700.grange> <87aaa0njj0.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1109200931210.11274@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morimoto-san

There was a question at the bottom of this email, which you might have 
overseen:-) Could you give me an idea, which patche(es) exactly you meant?

Thanks
Guennadi

On Tue, 20 Sep 2011, Guennadi Liakhovetski wrote:

> Morimoto-san
> 
> Thanks for your reply.
> 
> On Mon, 19 Sep 2011, Kuninori Morimoto wrote:
> 
> > Hi Guennadi, all
> > 
> > > > > mt9t112 camera needs 100 milliseconds for initializing
> > > > > Special thanks to Phil
> > > > > 
> > > > > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > > > > Reported-by: Phil Edworthy <Phil.Edworthy@renesas.com>
> > > > > ---
> > > > >  drivers/media/video/mt9t112.c |    2 +-
> > > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> > > > > index 7438f8d..e581d8a 100644
> > > > > --- a/drivers/media/video/mt9t112.c
> > > > > +++ b/drivers/media/video/mt9t112.c
> > > > > @@ -885,7 +885,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
> > > > >  		/* Invert PCLK (Data sampled on falling edge of pixclk) */
> > > > >  		mt9t112_reg_write(ret, client, 0x3C20, param);
> > > > >  
> > > > > -		mdelay(5);
> > > > > +		mdelay(100);
> > > > >  
> > > > >  		priv->flags |= INIT_DONE;
> > > > >  	}
> > > > 
> > > > Hi Guennadi,
> > > > 
> > > > What's the status of this patch?
> > > > 
> > > > It applies ok for me, and I couldn't find any reference at the
> > > > ML why it was not applied yet.
> > > 
> > > Hm, yeah... Looks like also this patch:
> > > 
> > > > Subject: [PATCH 3/3] soc-camera: mt9t112: The flag which control camera-init is removed
> > > > 
> > > > mt9t112 should always be initialized when camera start.
> > > > Because current driver doesn't run this operation,
> > > > it will be un-stable if user side player run open/close several times.
> > > > Special thanks to Namiki-san
> > > > 
> > > > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > > > Reported-by: Takashi Namiki <Takashi.Namiki@renesas.com>
> > > 
> > > has not been applied nor discussed on the list... For patches that old I 
> > > would tend to say: if the author / submitter didn't re-submit, then, 
> > > probably, patches aren't relevant anymore... Although it is quite 
> > > possible, that I failed to process them back then. Morimoto-san, do you 
> > > have any information on these patches? Have these problems been solved 
> > > somehow, so that the patches have become obsolete, or are the problems, 
> > > that they address, still there?
> > 
> > This patch is needed for mt9t112 camera initialize.
> > I thought that it was already applied.
> 
> Which patch do you mean? Patch 2/3, or 3/3, or both are needed?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
