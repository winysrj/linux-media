Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730106AbeGZUh2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 16:37:28 -0400
Date: Thu, 26 Jul 2018 16:18:49 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/11] media: soc_camera_platform: convert to SPDX
 identifiers
Message-ID: <20180726161756.1096cda4@coco.lan>
In-Reply-To: <1781313.1NpYYvqXTV@avalon>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
        <87fu06d91u.wl-kuninori.morimoto.gx@renesas.com>
        <1781313.1NpYYvqXTV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 26 Jul 2018 18:10:32 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Morimoto-san,
> 
> On Thursday, 26 July 2018 05:34:42 EEST Kuninori Morimoto wrote:
> > From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > ---
> >  drivers/media/platform/soc_camera/soc_camera_platform.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)  
> 
> I have second thoughts about this one. Is it worth switching to SPDX as we're 
> in the process of removing soc-camera from the kernel ? If it is, shouldn't 
> you also address the other soc-camera source files ? I would personally prefer 
> not touching soc-camera as it won't be there for much longer.

I'd say that, if there are code there that will be converted and will stay
at the Kernel, the SPDX patchset is a good thing, as it makes easier for 
the conversion, as it would mean one less thing to be concerned with.

So, I'm inclined to apply this patch series.

> 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c
> > b/drivers/media/platform/soc_camera/soc_camera_platform.c index
> > ce00e90..6745a6e 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera_platform.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
> > @@ -1,13 +1,10 @@
> > +// SPDX-License-Identifier: GPL-2.0
> >  /*
> >   * Generic Platform Camera Driver
> >   *
> >   * Copyright (C) 2008 Magnus Damm
> >   * Based on mt9m001 driver,
> >   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > - *
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> >   */
> > 
> >  #include <linux/init.h>  
> 



Thanks,
Mauro
