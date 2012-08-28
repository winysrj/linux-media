Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50174 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2H1IYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 04:24:15 -0400
Subject: Re: [PATCH 03/12] coda: fix IRAM/AXI handling for i.MX53
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <CACKLOr0znE9WOBqk-nfm_y58mDAiW+noFbyugDD7n0Vo0Drp9g@mail.gmail.com>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
	 <1345825078-3688-4-git-send-email-p.zabel@pengutronix.de>
	 <CACKLOr0znE9WOBqk-nfm_y58mDAiW+noFbyugDD7n0Vo0Drp9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 10:24:09 +0200
Message-ID: <1346142249.2534.26.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

thank you for the comments,

Am Montag, den 27.08.2012, 10:59 +0200 schrieb javier Martin:
> Hi Philipp,
> thank you for your patch. Please, find some comments below.
> 
> On 24 August 2012 18:17, Philipp Zabel <p.zabel@pengutronix.de> wrote:
[...]
> > @@ -1854,6 +1886,25 @@ static int __devinit coda_probe(struct platform_device *pdev)
> >                 return -ENOMEM;
> >         }
> >
> > +       if (dev->devtype->product == CODA_DX6) {
> > +               dev->iram_paddr = 0xffff4c00;
> > +       } else {
> > +               struct device_node *np = pdev->dev.of_node;
> > +
> > +               dev->iram_pool = of_get_named_gen_pool(np, "iram", 0);
> 
> "of_get_named_gen_pool" doesn't exist in linux_media 'for_v3.7'.
> Moreover, nobody registers an IRAM through the function 'iram_init' in
> mainline [1] so this will never work.
> You will have to wait until this functionality gets merge before
> sending this patch.
> 
> > +               if (!iram_pool) {
> 
> I think you meant 'dev->iram_pool' here, otherwise this will not
> compile properly:
> 
>  CC      drivers/media/video/coda.o
> drivers/media/video/coda.c: In function 'coda_probe':
> drivers/media/video/coda.c:1893: error: implicit declaration of
> function 'of_get_named_gen_pool'
> drivers/media/video/coda.c:1893: warning: assignment makes pointer
> from integer without a cast
> drivers/media/video/coda.c:1894: error: 'iram_pool' undeclared (first
> use in this function)
> drivers/media/video/coda.c:1894: error: (Each undeclared identifier is
> reported only once
> drivers/media/video/coda.c:1894: error: for each function it appears in.)

I was a bit overzealous squashing my patches. For the next round, I'm
using the iram_alloc/iram_free functions that are present in
arch/plat-mxc/include/mach/iram.h (and thus gain a temporary dependency
on ARCH_MXC until there is a mechansim to get to the IRAM gen_pool).
A follow-up patch then would convert the driver to the genalloc API
again.

On a related note, is the 45 KiB VRAM at 0xffff4c00 on i.MX27 reserved
exclusively for the CODA? I suppose rather than hard-coding the address
in the driver, we could use the iram_alloc API on i.MX27, too?

regards
Philipp

