Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61384 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2H1Iy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 04:54:26 -0400
Received: by wgbdr13 with SMTP id dr13so4430135wgb.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 01:54:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346142249.2534.26.camel@pizza.hi.pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
	<1345825078-3688-4-git-send-email-p.zabel@pengutronix.de>
	<CACKLOr0znE9WOBqk-nfm_y58mDAiW+noFbyugDD7n0Vo0Drp9g@mail.gmail.com>
	<1346142249.2534.26.camel@pizza.hi.pengutronix.de>
Date: Tue, 28 Aug 2012 10:54:23 +0200
Message-ID: <CACKLOr1yiT4hJcX4EryFR6gLEEW-W5c0Mc=GGyVCm6+_-8tqbQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] coda: fix IRAM/AXI handling for i.MX53
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 August 2012 10:24, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Javier,
>
> thank you for the comments,
>
> Am Montag, den 27.08.2012, 10:59 +0200 schrieb javier Martin:
>> Hi Philipp,
>> thank you for your patch. Please, find some comments below.
>>
>> On 24 August 2012 18:17, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> [...]
>> > @@ -1854,6 +1886,25 @@ static int __devinit coda_probe(struct platform_device *pdev)
>> >                 return -ENOMEM;
>> >         }
>> >
>> > +       if (dev->devtype->product == CODA_DX6) {
>> > +               dev->iram_paddr = 0xffff4c00;
>> > +       } else {
>> > +               struct device_node *np = pdev->dev.of_node;
>> > +
>> > +               dev->iram_pool = of_get_named_gen_pool(np, "iram", 0);
>>
>> "of_get_named_gen_pool" doesn't exist in linux_media 'for_v3.7'.
>> Moreover, nobody registers an IRAM through the function 'iram_init' in
>> mainline [1] so this will never work.
>> You will have to wait until this functionality gets merge before
>> sending this patch.
>>
>> > +               if (!iram_pool) {
>>
>> I think you meant 'dev->iram_pool' here, otherwise this will not
>> compile properly:
>>
>>  CC      drivers/media/video/coda.o
>> drivers/media/video/coda.c: In function 'coda_probe':
>> drivers/media/video/coda.c:1893: error: implicit declaration of
>> function 'of_get_named_gen_pool'
>> drivers/media/video/coda.c:1893: warning: assignment makes pointer
>> from integer without a cast
>> drivers/media/video/coda.c:1894: error: 'iram_pool' undeclared (first
>> use in this function)
>> drivers/media/video/coda.c:1894: error: (Each undeclared identifier is
>> reported only once
>> drivers/media/video/coda.c:1894: error: for each function it appears in.)
>
> I was a bit overzealous squashing my patches. For the next round, I'm
> using the iram_alloc/iram_free functions that are present in
> arch/plat-mxc/include/mach/iram.h (and thus gain a temporary dependency
> on ARCH_MXC until there is a mechansim to get to the IRAM gen_pool).
> A follow-up patch then would convert the driver to the genalloc API
> again.

I agree.

> On a related note, is the 45 KiB VRAM at 0xffff4c00 on i.MX27 reserved
> exclusively for the CODA? I suppose rather than hard-coding the address
> in the driver, we could use the iram_alloc API on i.MX27, too?

When I first saw your patch I thought I would be great to do the same
with the i.MX27. Let me share with you some conflicts we have found
between the codadx6 datasheet and the reference code from Freescale:

Regarding whether codadx6 needs to know IRAM size or not:
Code from Freescale: vpu_reg.h: BIT_SEARCH_RAM_SIZE 0x144 (if we try
to read it we get nonsense values)
Datasheet codadx6: p 109: Protected for internal use.


Regarding actual IRAM used size:
i.MX27 datasheet from Freescale: VRAM 0xFFFF4C00 to 0xFFFFFFFF. 45 kiB
(46080 bytes).
Datasheet codadx6: p 17: 33 KB of internal memory are used (33792 bytes)
Datasheet codadx6: p 68: Size of the memory needed is 52 lines =
52*720 =  37440 bytes

Keeping the above in mind, it seems the IRAM size inside the i.MX27 is
bigger than what the codadx6 really uses, so the IRAM could be shared.
However, the datasheet of the codadx6 indicates that static RAM is
used for performance reasons, so sharing it with another block is not
a good idea.

To sum up, after I test/ack the following version of your patches I'll
add proper support for the IRAM inside the i.MX27, reserving the whole
IRAM for the codadx6.
Do you agree?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
