Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:38024 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754926AbeDCGvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 02:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20180402142656.26815-3-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr> <20180402142656.26815-3-robert.jarzmik@free.fr>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 3 Apr 2018 08:51:37 +0200
Message-ID: <CAK8P3a3pSitVqfiF2LK0cMrAKLOeCWXXJBLeVc5f_Tg=vALkUA@mail.gmail.com>
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

On Mon, Apr 2, 2018 at 4:26 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> +
> +static const struct dma_slave_map pxa_slave_map[] = {
> +       /* PXA25x, PXA27x and PXA3xx common entries */
> +       { "pxa-pcm-audio", "ac97_mic_mono", PDMA_FILTER_PARAM(LOWEST, 8) },
> +       { "pxa-pcm-audio", "ac97_aux_mono_in", PDMA_FILTER_PARAM(LOWEST, 9) },
> +       { "pxa-pcm-audio", "ac97_aux_mono_out", PDMA_FILTER_PARAM(LOWEST, 10) },
> +       { "pxa-pcm-audio", "ac97_stereo_in", PDMA_FILTER_PARAM(LOWEST, 11) },
> +       { "pxa-pcm-audio", "ac97_stereo_out", PDMA_FILTER_PARAM(LOWEST, 12) },
> +       { "pxa-pcm-audio", "ssp1_rx", PDMA_FILTER_PARAM(LOWEST, 13) },
> +       { "pxa-pcm-audio", "ssp1_tx", PDMA_FILTER_PARAM(LOWEST, 14) },
> +       { "pxa-pcm-audio", "ssp2_rx", PDMA_FILTER_PARAM(LOWEST, 15) },
> +       { "pxa-pcm-audio", "ssp2_tx", PDMA_FILTER_PARAM(LOWEST, 16) },
> +       { "pxa2xx-ir", "rx", PDMA_FILTER_PARAM(LOWEST, 17) },
> +       { "pxa2xx-ir", "tx", PDMA_FILTER_PARAM(LOWEST, 18) },
> +       { "pxa2xx-mci.0", "rx", PDMA_FILTER_PARAM(LOWEST, 21) },
> +       { "pxa2xx-mci.0", "tx", PDMA_FILTER_PARAM(LOWEST, 22) },


> +       { "smc911x.0", "rx", PDMA_FILTER_PARAM(LOWEST, -1) },
> +       { "smc911x.0", "tx", PDMA_FILTER_PARAM(LOWEST, -1) },
> +       { "smc91x.0", "data", PDMA_FILTER_PARAM(LOWEST, -1) },

This one is interesting, as you are dealing with an off-chip device,
and the channel number is '-'1. How does this even work? Does it
mean

> +       /* PXA25x specific map */
> +       { "pxa25x-ssp.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
> +       { "pxa25x-ssp.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
> +       { "pxa25x-nssp.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
> +       { "pxa25x-nssp.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
> +       { "pxa25x-nssp.2", "rx", PDMA_FILTER_PARAM(LOWEST, 23) },
> +       { "pxa25x-nssp.2", "tx", PDMA_FILTER_PARAM(LOWEST, 24) },
> +       { "pxa-pcm-audio", "nssp2_rx", PDMA_FILTER_PARAM(LOWEST, 15) },
> +       { "pxa-pcm-audio", "nssp2_tx", PDMA_FILTER_PARAM(LOWEST, 16) },
> +       { "pxa-pcm-audio", "nssp3_rx", PDMA_FILTER_PARAM(LOWEST, 23) },
> +       { "pxa-pcm-audio", "nssp3_tx", PDMA_FILTER_PARAM(LOWEST, 24) },
> +
> +       /* PXA27x specific map */
> +       { "pxa-pcm-audio", "ssp3_rx", PDMA_FILTER_PARAM(LOWEST, 66) },
> +       { "pxa-pcm-audio", "ssp3_tx", PDMA_FILTER_PARAM(LOWEST, 67) },
> +       { "pxa27x-camera.0", "CI_Y", PDMA_FILTER_PARAM(HIGHEST, 68) },
> +       { "pxa27x-camera.0", "CI_U", PDMA_FILTER_PARAM(HIGHEST, 69) },
> +       { "pxa27x-camera.0", "CI_V", PDMA_FILTER_PARAM(HIGHEST, 70) },
> +
> +       /* PXA3xx specific map */
> +       { "pxa-pcm-audio", "ssp4_rx", PDMA_FILTER_PARAM(LOWEST, 2) },
> +       { "pxa-pcm-audio", "ssp4_tx", PDMA_FILTER_PARAM(LOWEST, 3) },
> +       { "pxa2xx-mci.1", "rx", PDMA_FILTER_PARAM(LOWEST, 93) },
> +       { "pxa2xx-mci.1", "tx", PDMA_FILTER_PARAM(LOWEST, 94) },
> +       { "pxa3xx-nand", "data", PDMA_FILTER_PARAM(LOWEST, 97) },
> +       { "pxa2xx-mci.2", "rx", PDMA_FILTER_PARAM(LOWEST, 100) },
> +       { "pxa2xx-mci.2", "tx", PDMA_FILTER_PARAM(LOWEST, 101) },
> +};

Since more than half the entries in here are chip specific, maybe it would be
better to split that table into three and have a copy for each one in
arch/arm/mach-pxa/pxa{25x.27x.3xx}.c? Does that mean it's actually
a memory-to-memory transfer with a device being on the external
SRAM interface?

       Arnd
