Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:25646 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755043AbeEXHH2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 03:07:28 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v2 00/13] ARM: pxa: switch to DMA slave maps
Date: Thu, 24 May 2018 09:06:50 +0200
Message-Id: <20180524070703.11901-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v1 cover letter is quoted in [1].

For maintainers the table below should help you focus on the patches targetted at you, and ignore the other noise.

The differences since v1 is by maintainers / topic / patch :
- Arnd and Daniel / PXA topic / 0002
  devices.c split into pxa25x.c, pxa27x.c and pxa3xx.c
- Boris and Daniel / MTD topic / 0005
  Review and ack of this one
- Arnd and netdev / NET topic / 0006 and 0007
  Arnd comment taken, review and ack of these one
- Mark and alsa-devel / ASoC topic / 0008
  Mark, I couldn't keep your former Ack because :
    - I changed one line so that the cpu device provides the DMA
    - I added pxa2xx-i2s which was forgotten
  Therefore I need a new ack
- Arnd and Daniel / SSP topic / 0013
  Review and ack of this one

Happy review.

--
Robert

Robert Jarzmik (13):
  dmaengine: pxa: use a dma slave map
  ARM: pxa: add dma slave map
  mmc: pxamci: remove the dmaengine compat need
  media: pxa_camera: remove the dmaengine compat need
  mtd: rawnand: marvell: remove the dmaengine compat need
  net: smc911x: remove the dmaengine compat need
  net: smc91x: remove the dmaengine compat need
  ASoC: pxa: remove the dmaengine compat need
  ata: pata_pxa: remove the dmaengine compat need
  dmaengine: pxa: document pxad_param
  dmaengine: pxa: make the filter function internal
  ARM: pxa: remove the DMA IO resources
  ARM: pxa: change SSP DMA channels allocation

 arch/arm/mach-pxa/devices.c           | 148 +---------------------------------
 arch/arm/mach-pxa/devices.h           |   6 +-
 arch/arm/mach-pxa/pxa25x.c            |  41 +++++++++-
 arch/arm/mach-pxa/pxa27x.c            |  42 +++++++++-
 arch/arm/mach-pxa/pxa3xx.c            |  44 +++++++++-
 arch/arm/plat-pxa/ssp.c               |  47 -----------
 drivers/ata/pata_pxa.c                |  10 +--
 drivers/dma/pxa_dma.c                 |  13 ++-
 drivers/media/platform/pxa_camera.c   |  22 +----
 drivers/mmc/host/pxamci.c             |  29 +------
 drivers/mtd/nand/raw/marvell_nand.c   |  17 +---
 drivers/net/ethernet/smsc/smc911x.c   |  16 +---
 drivers/net/ethernet/smsc/smc91x.c    |  12 +--
 drivers/net/ethernet/smsc/smc91x.h    |   1 -
 include/linux/dma/pxa-dma.h           |  20 +++--
 include/linux/platform_data/mmp_dma.h |   4 +
 include/linux/pxa2xx_ssp.h            |   2 -
 sound/arm/pxa2xx-ac97.c               |  14 +---
 sound/arm/pxa2xx-pcm-lib.c            |   6 +-
 sound/soc/pxa/pxa-ssp.c               |   5 +-
 sound/soc/pxa/pxa2xx-ac97.c           |  32 ++------
 sound/soc/pxa/pxa2xx-i2s.c            |   6 +-
 22 files changed, 180 insertions(+), 357 deletions(-)

-- 
2.11.0

---
[1] Former v1 cover letter
This serie is aimed at removing the dmaengine slave compat use, and transfer
knowledge of the DMA requestors into architecture code.

This was discussed/advised by Arnd a couple of years back, it's almost time.

The serie is divided in 3 phasees :
 - phase 1 : patch 1/15 and patch 2/15
   => this is the preparation work
 - phase 2 : patches 3/15 .. 10/15
   => this is the switch of all the drivers
   => this one will require either an Ack of the maintainers or be taken by them
      once phase 1 is merged
 - phase 3 : patches 11/15
   => this is the last part, cleanup and removal of export of the DMA filter
      function

As this looks like a patch bomb, each maintainer expressing for his tree either
an Ack or "I want to take through my tree" will be spared in the next iterations
of this serie.

Several of these changes have been tested on actual hardware, including :
 - pxamci
 - pxa_camera
 - smc*
 - ASoC and SSP
