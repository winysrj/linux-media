Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56408 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab0CLJv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 04:51:28 -0500
Date: Fri, 12 Mar 2010 10:41:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] V4L/DVB: mx1-camera: compile fix
Message-ID: <20100312094148.GA15123@pengutronix.de>
References: <20100304194241.GG19843@pengutronix.de> <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de> <Pine.LNX.4.64.1003121016480.4385@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1003121016480.4385@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Mar 12, 2010 at 10:22:31AM +0100, Guennadi Liakhovetski wrote:
> On Fri, 5 Mar 2010, Uwe Kleine-König wrote:
> > This is a regression of
> > 
> > 	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/media/video/mx1_camera.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> > index 2ba14fb..29c2833 100644
> > --- a/drivers/media/video/mx1_camera.c
> > +++ b/drivers/media/video/mx1_camera.c
> > @@ -45,11 +45,13 @@
> >  #include <mach/hardware.h>
> >  #include <mach/mx1_camera.h>
> >  
> > +#define __DMAREG(offset)	(MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR) + offset)
> > +
> 
> Well, I think, Sascha is right, we have to fix 
> arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h, because that's what actually 
> got broken. The line
> 
> #define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)
> 
> in it is no longer valid, right? So, we have to either remove it, or fix 
> it, if we think, that other drivers might start using it.
I thought a minimal fix would be a good idea.  I have no problem with a
clean one though.

>                                                           And even if we 
> decide to remove it from the header and implement here, wouldn't it be 
> better to choose a name, not beginning with "__"? Something like 
> MX1_DMA_REG, perhaps?
Then the register definitions should go into the header, too.  I will
prepare a patch later today.
>                       Or maybe even we shall remap those registers?
Well, they are remapped, don't they?  Otherwise IO_ADDRESS wouldn't
work.

Best regards
Uwe
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
