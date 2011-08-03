Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1HCQiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2011 12:38:03 -0400
Date: Wed, 3 Aug 2011 18:37:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Eric Miao <eric.y.miao@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 29/59] ARM: PXA: use gpio_set_value_cansleep() on pcm990
In-Reply-To: <CAMPhdO8V=y+se-vuozXW2_w6Y2cP2L7FVpiG7zXWS_WBcQvgqQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1108031835540.28502@axis700.grange>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
 <1311937019-29914-30-git-send-email-g.liakhovetski@gmx.de>
 <CAMPhdO8V=y+se-vuozXW2_w6Y2cP2L7FVpiG7zXWS_WBcQvgqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eric

On Wed, 3 Aug 2011, Eric Miao wrote:

> I'm not a big fan of this _cansleep() version of the API, is there any
> specific reason for doing so? Does the original code break anything?

Sure:

> > explicitly to avoid runtime warnings.

i.e., without this patch the

	WARN_ON(chip->can_sleep);

in drivers/gpio/gpiolib.c::__gpio_set_value() triggers.

Thanks
Guennadi

> 
> On Friday, July 29, 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> wrote:
> > Camera-switching GPIOs are provided by a i2c GPIO extender, switching
> > them can send the caller to sleep. Use the GPIO API *_cansleep methods
> > explicitly to avoid runtime warnings.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > ---
> >  arch/arm/mach-pxa/pcm990-baseboard.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c
> b/arch/arm/mach-pxa/pcm990-baseboard.c
> > index 6d5b7e0..8ad2597 100644
> > --- a/arch/arm/mach-pxa/pcm990-baseboard.c
> > +++ b/arch/arm/mach-pxa/pcm990-baseboard.c
> > @@ -395,9 +395,9 @@ static int pcm990_camera_set_bus_param(struct
> soc_camera_link *link,
> >        }
> >
> >        if (flags & SOCAM_DATAWIDTH_8)
> > -               gpio_set_value(gpio_bus_switch, 1);
> > +               gpio_set_value_cansleep(gpio_bus_switch, 1);
> >        else
> > -               gpio_set_value(gpio_bus_switch, 0);
> > +               gpio_set_value_cansleep(gpio_bus_switch, 0);
> >
> >        return 0;
> >  }
> > --
> > 1.7.2.5
> >
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
