Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43671 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbeDCHGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 03:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <20180402142656.26815-15-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr> <20180402142656.26815-15-robert.jarzmik@free.fr>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 3 Apr 2018 09:06:46 +0200
Message-ID: <CAK8P3a2hYWO2eweg3zpR7iJoqtH4uxJLAxJAno7L96G7nA2HxQ@mail.gmail.com>
Subject: Re: [PATCH 14/15] ARM: pxa: change SSP devices allocation
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
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
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

>
> +static struct pxa_ssp_info pxa_ssp_infos[] = {
> +       { .dma_chan_rx_name = "ssp1_rx", .dma_chan_tx_name = "ssp1_tx", },
> +       { .dma_chan_rx_name = "ssp1_rx", .dma_chan_tx_name = "ssp1_tx", },
> +       { .dma_chan_rx_name = "ssp2_rx", .dma_chan_tx_name = "ssp2_tx", },
> +       { .dma_chan_rx_name = "ssp2_rx", .dma_chan_tx_name = "ssp2_tx", },
> +       { .dma_chan_rx_name = "ssp3_rx", .dma_chan_tx_name = "ssp3_tx", },
> +       { .dma_chan_rx_name = "ssp3_rx", .dma_chan_tx_name = "ssp3_tx", },
> +       { .dma_chan_rx_name = "ssp4_rx", .dma_chan_tx_name = "ssp4_tx", },
> +       { .dma_chan_rx_name = "ssp4_rx", .dma_chan_tx_name = "ssp4_tx", },
> +};

This part looks odd to me, you're adding an extra level of indirection to
do two stages of lookups in some form of platform data.

Why can't you just always use "rx" and "tx" as the names here?

(also, I don't see why each line is duplicated, but I'm sure there's
an easy answer for that).

       Arnd
