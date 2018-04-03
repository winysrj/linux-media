Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:43260 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbeDCPTG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 11:19:06 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [PATCH 02/15] ARM: pxa: add dma slave map
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
        <20180402142656.26815-3-robert.jarzmik@free.fr>
        <CAK8P3a3pSitVqfiF2LK0cMrAKLOeCWXXJBLeVc5f_Tg=vALkUA@mail.gmail.com>
Date: Tue, 03 Apr 2018 17:18:49 +0200
In-Reply-To: <CAK8P3a3pSitVqfiF2LK0cMrAKLOeCWXXJBLeVc5f_Tg=vALkUA@mail.gmail.com>
        (Arnd Bergmann's message of "Tue, 3 Apr 2018 08:51:37 +0200")
Message-ID: <87tvss48ti.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

>> +       { "smc911x.0", "rx", PDMA_FILTER_PARAM(LOWEST, -1) },
>> +       { "smc911x.0", "tx", PDMA_FILTER_PARAM(LOWEST, -1) },
>> +       { "smc91x.0", "data", PDMA_FILTER_PARAM(LOWEST, -1) },
>
> This one is interesting, as you are dealing with an off-chip device,
> and the channel number is '-'1. How does this even work? Does it
> mean

This relies on pxa_dma, in which the "-1" for a requestor line means "no
requestor" or said in another way "always requesting". As a consequence, as soon
as the DMA descriptors are queued, the transfer begins, and it is supposed
implicitely that the FIFO output availability is at least as quick as the system
bus and the DMA size is perfectly fit for the FIFO available bytes.

This is what has been the underlying of DMA transfers of smc91x(x) on the PXA
platforms, where the smc91x(s) are directly wired on the system bus (the same
bus having DRAM, SRAM, IO-mapped devices).

>
>> +       /* PXA25x specific map */
>> +       { "pxa25x-ssp.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
>> +       { "pxa25x-ssp.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
>> +       { "pxa25x-nssp.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
>> +       { "pxa25x-nssp.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
>> +       { "pxa25x-nssp.2", "rx", PDMA_FILTER_PARAM(LOWEST, 23) },
>> +       { "pxa25x-nssp.2", "tx", PDMA_FILTER_PARAM(LOWEST, 24) },
>> +       { "pxa-pcm-audio", "nssp2_rx", PDMA_FILTER_PARAM(LOWEST, 15) },
>> +       { "pxa-pcm-audio", "nssp2_tx", PDMA_FILTER_PARAM(LOWEST, 16) },
>> +       { "pxa-pcm-audio", "nssp3_rx", PDMA_FILTER_PARAM(LOWEST, 23) },
>> +       { "pxa-pcm-audio", "nssp3_tx", PDMA_FILTER_PARAM(LOWEST, 24) },
>> +
>> +       /* PXA27x specific map */
>> +       { "pxa-pcm-audio", "ssp3_rx", PDMA_FILTER_PARAM(LOWEST, 66) },
>> +       { "pxa-pcm-audio", "ssp3_tx", PDMA_FILTER_PARAM(LOWEST, 67) },
>> +       { "pxa27x-camera.0", "CI_Y", PDMA_FILTER_PARAM(HIGHEST, 68) },
>> +       { "pxa27x-camera.0", "CI_U", PDMA_FILTER_PARAM(HIGHEST, 69) },
>> +       { "pxa27x-camera.0", "CI_V", PDMA_FILTER_PARAM(HIGHEST, 70) },
>> +
>> +       /* PXA3xx specific map */
>> +       { "pxa-pcm-audio", "ssp4_rx", PDMA_FILTER_PARAM(LOWEST, 2) },
>> +       { "pxa-pcm-audio", "ssp4_tx", PDMA_FILTER_PARAM(LOWEST, 3) },
>> +       { "pxa2xx-mci.1", "rx", PDMA_FILTER_PARAM(LOWEST, 93) },
>> +       { "pxa2xx-mci.1", "tx", PDMA_FILTER_PARAM(LOWEST, 94) },
>> +       { "pxa3xx-nand", "data", PDMA_FILTER_PARAM(LOWEST, 97) },
>> +       { "pxa2xx-mci.2", "rx", PDMA_FILTER_PARAM(LOWEST, 100) },
>> +       { "pxa2xx-mci.2", "tx", PDMA_FILTER_PARAM(LOWEST, 101) },
>> +};
>
> Since more than half the entries in here are chip specific, maybe it would be
> better to split that table into three and have a copy for each one in
> arch/arm/mach-pxa/pxa{25x.27x.3xx}.c?
Mmmh, today the split is :
 - 16 common entries
 - 10 pxa25x specific entries
 - 5 pxa27x specific entries
 - 7 pxa3xx specific entries
 => total of 38 lines

After the split we'll have :
 - 26 pxa25x specific entries
 - 21 pxa27x specific entries
 - 23 pxa3xx specific entries
 => total of 70 lines

That doubles the number of lines, not counting the declarations, and amending of
pxa2xx_set_dmac_info().

If you think it's worth it, what is the driving benefit behind ?

> Does that mean it's actually a memory-to-memory transfer with a device being
> on the external SRAM interface?
I'm taking this is the follow up to the "-1" question :0

Cheers.

-- 
Robert
