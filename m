Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:54996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1DKQ7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 12:59:40 -0400
Date: Mon, 11 Apr 2011 18:58:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage
 in soc_camera.c
In-Reply-To: <BANLkTikQSaUKtNZCexhKeNEPM+id+J_2gw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104111829500.20798@axis700.grange>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
 <BANLkTin9gFK+StWvs6D7MeJixQ7E2AB=rA@mail.gmail.com>
 <Pine.LNX.4.64.1104111518140.20489@axis700.grange>
 <BANLkTikQSaUKtNZCexhKeNEPM+id+J_2gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 11 Apr 2011, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> On Mon, Apr 11, 2011 at 8:23 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> >
> > On Mon, 11 Apr 2011, Aguirre, Sergio wrote:
> >
> > > Hi Guennadi,
> > >
> > > On Mon, Apr 11, 2011 at 3:58 AM, Guennadi Liakhovetski <
> > > g.liakhovetski@gmx.de> wrote:
> > >
> > > > A recent patch has given individual soc-camera host drivers a possibility
> > > > to calculate .sizeimage and .bytesperline pixel format fields internally,
> > > > however, some drivers relied on the core calculating these values for
> > > > them, following a default algorithm. This patch restores the default
> > > > calculation for such drivers.
> > > >
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > > diff --git a/drivers/media/video/soc_camera.c
> > > > b/drivers/media/video/soc_camera.c
> > > > index 4628448..0918c48 100644
> > > > --- a/drivers/media/video/soc_camera.c
> > > > +++ b/drivers/media/video/soc_camera.c
> > > > @@ -376,6 +376,9 @@ static int soc_camera_set_fmt(struct soc_camera_device
> > > > *icd,
> > > >        dev_dbg(&icd->dev, "S_FMT(%c%c%c%c, %ux%u)\n",
> > > >                pixfmtstr(pix->pixelformat), pix->width, pix->height);
> > > >
> > > > +       pix->bytesperline = 0;
> > > > +       pix->sizeimage = 0;
> > > > +
> > > >        /* We always call try_fmt() before set_fmt() or set_crop() */
> > > >        ret = ici->ops->try_fmt(icd, f);
> > > >        if (ret < 0)
> > > > @@ -391,6 +394,17 @@ static int soc_camera_set_fmt(struct soc_camera_device
> > > > *icd,
> > > >                return -EINVAL;
> > > >        }
> > > >
> > > > +       if (!pix->sizeimage) {
> > > > +               if (!pix->bytesperline) {
> > > > +                       ret = soc_mbus_bytes_per_line(pix->width,
> > > > +
> > > > icd->current_fmt->host_fmt);
> > > > +                       if (ret > 0)
> > > > +                               pix->bytesperline = ret;
> > > > +               }
> > > > +               if (pix->bytesperline)
> > > > +                       pix->sizeimage = pix->bytesperline * pix->height;
> > > > +       }
> > > > +
> > > >
> > >
> > > Shouldn't all this be better done in try_fmt?
> >
> > Not _better_. We might choose to additionally do it for try_fmt too. But
> >
> > 1. we didn't do it before, applications don't seem to care.
> > 2. you cannot store / reuse those .sizeimage & .bytesperline values - this
> > is just a "try"
> > 3. it would be a bit difficult to realise - we need a struct
> > soc_mbus_pixelfmt to call soc_mbus_bytes_per_line(), which we don't have,
> > so, we'd need to obtain it using soc_camera_xlate_by_fourcc().
> >
> > This all would work, but in any case it would be an enhancement, but not a
> > regression fix.
> 
> Ok. And how about the attached patch? Would that work?

Please, post patches inline.

Yes, I think, ot would work too, only the call to 
soc_camera_xlate_by_fourcc() in the S_FMT case is superfluous, after 
ici->ops->set_fmt() we already have it in icd->current_fmt->host_fmt. 
Otherwise - yes, we could do it this way too. Janusz, could you test, 
please?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
