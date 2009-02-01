Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49955 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753189AbZBAWhy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 17:37:54 -0500
Date: Sun, 1 Feb 2009 23:37:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] sh_mobile_ceu: SOCAM flags are prepared at itself.
In-Reply-To: <Pine.LNX.4.64.0902012017230.17985@axis700.grange>
Message-ID: <Pine.LNX.4.64.0902012335150.17985@axis700.grange>
References: <uvdrxm9sd.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902012017230.17985@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 1 Feb 2009, Guennadi Liakhovetski wrote:

> On Fri, 30 Jan 2009, Kuninori Morimoto wrote:
> 
> > 
> > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > ---
> >  drivers/media/video/sh_mobile_ceu_camera.c |   27 +++++++++++++++++++++++++--
> >  include/media/sh_mobile_ceu.h              |    5 +++--
> >  2 files changed, 28 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> > index 9cde91a..07b7b4c 100644
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -101,6 +101,29 @@ struct sh_mobile_ceu_dev {
> >  	const struct soc_camera_data_format *camera_fmt;
> >  };
> >  
> > +static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
> > +{
> > +	unsigned long flags;
> > +
> > +	flags = SOCAM_SLAVE |
> 
> Guys, are you both sure this should be SLAVE, not MASTER? Have you tested 
> it? Both tw9910 and ov772x register themselves as MASTER and from the 
> datasheet the interface seems to be a typical master parallel to me... I 
> think with this patch you would neither be able to use your driver with 
> tw9910 nor with ov772x...

Ok, sorry, you, probably, did test it and it worked, but just because the 
SLAVE / MASTER flag is not tested in soc_camera_bus_param_compatible(), 
which I should fix with the next pull, but this does look wrong. Please, 
fix.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
