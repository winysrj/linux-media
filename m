Return-path: <mchehab@localhost>
Received: from moutng.kundenserver.de ([212.227.17.10]:63415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1GLIDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 04:03:40 -0400
Date: Tue, 12 Jul 2011 10:03:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jun Nie <niej0001@gmail.com>
cc: Pawel Osciak <pawel@osciak.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] videobuf2-dma-contig: return NULL if alloc fails
In-Reply-To: <CAGA24MJe9xBwm1J-cVH4Qi3b=7Ze+1PXEWzFh7dS8eHrBZoHWw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1107121003070.18477@axis700.grange>
References: <BANLkTimHtpaScRYe2kuFNW9Ja9x343aOTQ@mail.gmail.com>
 <CAGA24MJe9xBwm1J-cVH4Qi3b=7Ze+1PXEWzFh7dS8eHrBZoHWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Tue, 12 Jul 2011, Jun Nie wrote:

> 2011/6/23 Jun Nie <niej0001@gmail.com>:
> > return NULL if alloc fails to avoid taking error code as
> > buffer pointer
> >
> > Signed-off-by: Jun Nie <njun@marvell.com>

It shouldn't be needed with this:

https://patchwork.kernel.org/patch/654861/

Thanks
Guennadi

> > ---
> >  drivers/media/video/videobuf2-dma-contig.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-dma-contig.c
> > b/drivers/media/video/videobuf2-dma-contig.c
> > index a790a5f..8e8c7aa 100644
> > --- a/drivers/media/video/videobuf2-dma-contig.c
> > +++ b/drivers/media/video/videobuf2-dma-contig.c
> > @@ -40,7 +40,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
> > unsigned long size)
> >
> >        buf = kzalloc(sizeof *buf, GFP_KERNEL);
> >        if (!buf)
> > -               return ERR_PTR(-ENOMEM);
> > +               return NULL;
> >
> >        buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
> >                                        GFP_KERNEL);
> > @@ -48,7 +48,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
> > unsigned long size)
> >                dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
> >                        size);
> >                kfree(buf);
> > -               return ERR_PTR(-ENOMEM);
> > +               return NULL;
> >        }
> >
> >        buf->conf = conf;
> > --
> > 1.7.0.4
> >
> 
> How do you think about this fix?
> Thanks!
> 
> Jun
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
