Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:39860 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbeDCPjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 11:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <87tvss48ti.fsf@belgarion.home>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
 <20180402142656.26815-3-robert.jarzmik@free.fr> <CAK8P3a3pSitVqfiF2LK0cMrAKLOeCWXXJBLeVc5f_Tg=vALkUA@mail.gmail.com>
 <87tvss48ti.fsf@belgarion.home>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 3 Apr 2018 17:39:08 +0200
Message-ID: <CAK8P3a2FFVnPj4+VoQET3-Jz2DaYbc6UUJnX1fH5s8VumJZ7Og@mail.gmail.com>
Subject: Re: [PATCH 02/15] ARM: pxa: add dma slave map
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>, dmaengine@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 3, 2018 at 5:18 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>>> +       { "smc911x.0", "rx", PDMA_FILTER_PARAM(LOWEST, -1) },
>>> +       { "smc911x.0", "tx", PDMA_FILTER_PARAM(LOWEST, -1) },
>>> +       { "smc91x.0", "data", PDMA_FILTER_PARAM(LOWEST, -1) },
>>
>> This one is interesting, as you are dealing with an off-chip device,
>> and the channel number is '-'1. How does this even work? Does it
>> mean
>
> This relies on pxa_dma, in which the "-1" for a requestor line means "no
> requestor" or said in another way "always requesting". As a consequence, as soon
> as the DMA descriptors are queued, the transfer begins, and it is supposed
> implicitely that the FIFO output availability is at least as quick as the system
> bus and the DMA size is perfectly fit for the FIFO available bytes.
>
> This is what has been the underlying of DMA transfers of smc91x(x) on the PXA
> platforms, where the smc91x(s) are directly wired on the system bus (the same
> bus having DRAM, SRAM, IO-mapped devices).

Ok, I looked at the driver in more detail now and found the scary parts.
So it's using the async DMA interface to do synchronous DMA in
interrupt context in order to transfer the rx data faster than an readsl()
would, correct?

It still feels odd to me that there is an entry in the slave map for
a device that does not have a request line. However, it also seems
that the entire code in those two drivers that deals with DMA is specific
to PXA anyway, so maybe it can be done differently: instead of
calling dma_request_slave_channel_compat() or dma_request_chan()
with a fake request line, how about calling dma_request_channel()
with an NULL filter function and data, and have the driver handle
the empty data case the same way as the rq=-1 case today?

>>> +       /* PXA25x specific map */
>>> +       { "pxa25x-ssp.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
>>> +       { "pxa25x-ssp.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
>>> +       { "pxa25x-nssp.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
>>> +       { "pxa25x-nssp.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
>>> +       { "pxa25x-nssp.2", "rx", PDMA_FILTER_PARAM(LOWEST, 23) },
>>> +       { "pxa25x-nssp.2", "tx", PDMA_FILTER_PARAM(LOWEST, 24) },
>>> +       { "pxa-pcm-audio", "nssp2_rx", PDMA_FILTER_PARAM(LOWEST, 15) },
>>> +       { "pxa-pcm-audio", "nssp2_tx", PDMA_FILTER_PARAM(LOWEST, 16) },
>>> +       { "pxa-pcm-audio", "nssp3_rx", PDMA_FILTER_PARAM(LOWEST, 23) },
>>> +       { "pxa-pcm-audio", "nssp3_tx", PDMA_FILTER_PARAM(LOWEST, 24) },
>>> +
>>> +       /* PXA27x specific map */
>>> +       { "pxa-pcm-audio", "ssp3_rx", PDMA_FILTER_PARAM(LOWEST, 66) },
>>> +       { "pxa-pcm-audio", "ssp3_tx", PDMA_FILTER_PARAM(LOWEST, 67) },
>>> +       { "pxa27x-camera.0", "CI_Y", PDMA_FILTER_PARAM(HIGHEST, 68) },
>>> +       { "pxa27x-camera.0", "CI_U", PDMA_FILTER_PARAM(HIGHEST, 69) },
>>> +       { "pxa27x-camera.0", "CI_V", PDMA_FILTER_PARAM(HIGHEST, 70) },
>>> +
>>> +       /* PXA3xx specific map */
>>> +       { "pxa-pcm-audio", "ssp4_rx", PDMA_FILTER_PARAM(LOWEST, 2) },
>>> +       { "pxa-pcm-audio", "ssp4_tx", PDMA_FILTER_PARAM(LOWEST, 3) },
>>> +       { "pxa2xx-mci.1", "rx", PDMA_FILTER_PARAM(LOWEST, 93) },
>>> +       { "pxa2xx-mci.1", "tx", PDMA_FILTER_PARAM(LOWEST, 94) },
>>> +       { "pxa3xx-nand", "data", PDMA_FILTER_PARAM(LOWEST, 97) },
>>> +       { "pxa2xx-mci.2", "rx", PDMA_FILTER_PARAM(LOWEST, 100) },
>>> +       { "pxa2xx-mci.2", "tx", PDMA_FILTER_PARAM(LOWEST, 101) },
>>> +};
>>
>> Since more than half the entries in here are chip specific, maybe it would be
>> better to split that table into three and have a copy for each one in
>> arch/arm/mach-pxa/pxa{25x.27x.3xx}.c?
> Mmmh, today the split is :
>  - 16 common entries
>  - 10 pxa25x specific entries
>  - 5 pxa27x specific entries
>  - 7 pxa3xx specific entries
>  => total of 38 lines
>
> After the split we'll have :
>  - 26 pxa25x specific entries
>  - 21 pxa27x specific entries
>  - 23 pxa3xx specific entries
>  => total of 70 lines
>
> That doubles the number of lines, not counting the declarations, and amending of
> pxa2xx_set_dmac_info().
>
> If you think it's worth it, what is the driving benefit behind ?

It seems a bit cleaner to only register the tables for the dma lines that
are actually present on a given chip.

>> Does that mean it's actually a memory-to-memory transfer with a device being
>> on the external SRAM interface?
> I'm taking this is the follow up to the "-1" question :0

Right.

        Arnd
