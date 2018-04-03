Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:51021 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeDCPIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 11:08:44 -0400
Received: by mail-it0-f43.google.com with SMTP id r19-v6so23788792itc.0
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 08:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180402142656.26815-1-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 3 Apr 2018 17:08:42 +0200
Message-ID: <CAPDyKFot9dAST2jQL5s8E4U=bCHxkio=uwpqPd6S0N4FWJRB-w@mail.gmail.com>
Subject: Re: [PATCH 00/15] ARM: pxa: switch to DMA slave maps
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        driverdevel <devel@driverdev.osuosl.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 April 2018 at 16:26, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Hi,
>
> This serie is aimed at removing the dmaengine slave compat use, and transfer
> knowledge of the DMA requestors into architecture code.
>
> This was discussed/advised by Arnd a couple of years back, it's almost time.
>
> The serie is divided in 3 phasees :
>  - phase 1 : patch 1/15 and patch 2/15
>    => this is the preparation work
>  - phase 2 : patches 3/15 .. 10/15
>    => this is the switch of all the drivers
>    => this one will require either an Ack of the maintainers or be taken by them
>       once phase 1 is merged
>  - phase 3 : patches 11/15
>    => this is the last part, cleanup and removal of export of the DMA filter
>       function
>
> As this looks like a patch bomb, each maintainer expressing for his tree either
> an Ack or "I want to take through my tree" will be spared in the next iterations
> of this serie.

Perhaps an option is to send this hole series as PR for 3.17 rc1, that
would removed some churns and make this faster/easier? Well, if you
receive the needed acks of course.

For the mmc change:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

>
> Several of these changes have been tested on actual hardware, including :
>  - pxamci
>  - pxa_camera
>  - smc*
>  - ASoC and SSP
>
> Happy review.
>
> Robert Jarzmik (15):
>   dmaengine: pxa: use a dma slave map
>   ARM: pxa: add dma slave map
>   mmc: pxamci: remove the dmaengine compat need
>   media: pxa_camera: remove the dmaengine compat need
>   mtd: nand: pxa3xx: remove the dmaengine compat need
>   net: smc911x: remove the dmaengine compat need
>   net: smc91x: remove the dmaengine compat need
>   ASoC: pxa: remove the dmaengine compat need
>   net: irda: pxaficp_ir: remove the dmaengine compat need
>   ata: pata_pxa: remove the dmaengine compat need
>   dmaengine: pxa: document pxad_param
>   dmaengine: pxa: make the filter function internal
>   ARM: pxa: remove the DMA IO resources
>   ARM: pxa: change SSP devices allocation
>   ARM: pxa: change SSP DMA channels allocation
>
>  arch/arm/mach-pxa/devices.c               | 269 ++++++++++++++----------------
>  arch/arm/mach-pxa/devices.h               |  14 +-
>  arch/arm/mach-pxa/include/mach/audio.h    |  12 ++
>  arch/arm/mach-pxa/pxa25x.c                |   4 +-
>  arch/arm/mach-pxa/pxa27x.c                |   4 +-
>  arch/arm/mach-pxa/pxa3xx.c                |   5 +-
>  arch/arm/plat-pxa/ssp.c                   |  50 +-----
>  drivers/ata/pata_pxa.c                    |  10 +-
>  drivers/dma/pxa_dma.c                     |  13 +-
>  drivers/media/platform/pxa_camera.c       |  22 +--
>  drivers/mmc/host/pxamci.c                 |  29 +---
>  drivers/mtd/nand/pxa3xx_nand.c            |  10 +-
>  drivers/net/ethernet/smsc/smc911x.c       |  16 +-
>  drivers/net/ethernet/smsc/smc91x.c        |  12 +-
>  drivers/net/ethernet/smsc/smc91x.h        |   1 -
>  drivers/staging/irda/drivers/pxaficp_ir.c |  14 +-
>  include/linux/dma/pxa-dma.h               |  20 +--
>  include/linux/platform_data/mmp_dma.h     |   4 +
>  include/linux/pxa2xx_ssp.h                |   4 +-
>  sound/arm/pxa2xx-ac97.c                   |  14 +-
>  sound/arm/pxa2xx-pcm-lib.c                |   6 +-
>  sound/soc/pxa/pxa-ssp.c                   |   5 +-
>  sound/soc/pxa/pxa2xx-ac97.c               |  32 +---
>  23 files changed, 196 insertions(+), 374 deletions(-)
>
> --
> 2.11.0
>
