Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36570 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbeGZVOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 17:14:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/11] media: soc_camera_platform: convert to SPDX identifiers
Date: Thu, 26 Jul 2018 22:56:56 +0300
Message-ID: <2222680.iWr5sPUPWG@avalon>
In-Reply-To: <20180726161756.1096cda4@coco.lan>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com> <1781313.1NpYYvqXTV@avalon> <20180726161756.1096cda4@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 26 July 2018 22:18:49 EEST Mauro Carvalho Chehab wrote:
> Em Thu, 26 Jul 2018 18:10:32 +0300 Laurent Pinchart escreveu:
> > On Thursday, 26 July 2018 05:34:42 EEST Kuninori Morimoto wrote:
> > > From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > > 
> > > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > > ---
> > > 
> > >  drivers/media/platform/soc_camera/soc_camera_platform.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > I have second thoughts about this one. Is it worth switching to SPDX as
> > we're in the process of removing soc-camera from the kernel ? If it is,
> > shouldn't you also address the other soc-camera source files ? I would
> > personally prefer not touching soc-camera as it won't be there for much
> > longer.
> 
> I'd say that, if there are code there that will be converted and will stay
> at the Kernel, the SPDX patchset is a good thing, as it makes easier for
> the conversion, as it would mean one less thing to be concerned with.
> 
> So, I'm inclined to apply this patch series.

My comment referred to this patch only, not the whole series. The rest of the 
series is totally fine, only soc_camera_platform.c doesn't seem worth touching 
to me as it's going away. As far as I know the only remaining user is 
sh_mobile_ceu_camera.c, which isn't used by any platform anymore. It's just a 
matter of dropping it (I think Jacopo has submitted a patch already), and then 
removing the drivers/media/platform/soc_camera/ directory.

I've taken the whole series in my tree and collected acks, so I'll submit a 
pull request when we will decide what to do with patch 01/11.

> > > diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c
> > > b/drivers/media/platform/soc_camera/soc_camera_platform.c index
> > > ce00e90..6745a6e 100644
> > > --- a/drivers/media/platform/soc_camera/soc_camera_platform.c
> > > +++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
> > > @@ -1,13 +1,10 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > >  /*
> > >   * Generic Platform Camera Driver
> > >   *
> > >   * Copyright (C) 2008 Magnus Damm
> > >   * Based on mt9m001 driver,
> > >   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > > - *
> > > - * This program is free software; you can redistribute it and/or modify
> > > - * it under the terms of the GNU General Public License version 2 as
> > > - * published by the Free Software Foundation.
> > >   */
> > >  
> > >  #include <linux/init.h>

-- 
Regards,

Laurent Pinchart
