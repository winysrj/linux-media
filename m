Return-path: <linux-media-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:59882 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbeDQSQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 14:16:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Matias Bjorling <mb@lightnvm.io>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc: iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-block@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 00/20] Allow compile-testing NO_DMA (drivers)
Date: Tue, 17 Apr 2018 19:49:00 +0200
Message-Id: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

        Hi all,

As of v4.17-rc1, patch series "[PATCH v2 0/5] Allow compile-testing
NO_DMA (core)" (https://lkml.org/lkml/2018/3/16/435) has been included
upstream, and drivers using the DMA API can be compile-tested on
platforms selecting NO_DMA.

This follow-up patch series removes dependencies on HAS_DMA for symbols
that already have platform dependencies implying HAS_DMA, which increases
compile-coverage.

Please apply to your tree if appropriate.

Changes compared to v2:
  - Add Acked-by,
  - Rebased to v4.17-rc1, dropping applied patch for scsi/hisi_sas,
  - Handle new VIDEO_RENESAS_CEU symbol,
  - Drop obsolete note about FSL_FMAN.

Changes compared to v1:
  - Add Reviewed-by, Acked-by,
  - Drop dependency of SND_SOC_LPASS_IPQ806X on HAS_DMA,
  - Drop dependency of VIDEOBUF{,2}_DMA_{CONTIG,SG} on HAS_DMA,
  - Drop new dependencies of VIDEO_IPU3_CIO2, DVB_C8SECTPFE, and
    MTD_NAND_MARVELL on HAS_DMA,
  - Split in per-subsystem patches,
  - Split-off the core part in a separate series.

This series is against v4.17-rc1. It can also be found at
https://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git/log/?h=no-dma-compile-testing-v3

It has been compile-tested with allmodconfig and allyesconfig for
m68k/sun3, and has received attention from the kbuild test robot.

Thanks for applying!

Geert Uytterhoeven (20):
  ASoC: Remove depends on HAS_DMA in case of platform dependency
  ata: Remove depends on HAS_DMA in case of platform dependency
  crypto: Remove depends on HAS_DMA in case of platform dependency
  fbdev: Remove depends on HAS_DMA in case of platform dependency
  firewire: Remove depends on HAS_DMA in case of platform dependency
  fpga: Remove depends on HAS_DMA in case of platform dependency
  i2c: Remove depends on HAS_DMA in case of platform dependency
  iio: adc: Remove depends on HAS_DMA in case of platform dependency
  iommu: Remove depends on HAS_DMA in case of platform dependency
  lightnvm: Remove depends on HAS_DMA in case of platform dependency
  mailbox: Remove depends on HAS_DMA in case of platform dependency
  media: Remove depends on HAS_DMA in case of platform dependency
  mmc: Remove depends on HAS_DMA in case of platform dependency
  mtd: Remove depends on HAS_DMA in case of platform dependency
  net: Remove depends on HAS_DMA in case of platform dependency
  remoteproc: Remove depends on HAS_DMA in case of platform dependency
  serial: Remove depends on HAS_DMA in case of platform dependency
  spi: Remove depends on HAS_DMA in case of platform dependency
  staging: vc04_services: Remove depends on HAS_DMA in case of platform
    dependency
  usb: Remove depends on HAS_DMA in case of platform dependency

 drivers/ata/Kconfig                             |  2 --
 drivers/crypto/Kconfig                          | 14 +++------
 drivers/firewire/Kconfig                        |  1 -
 drivers/fpga/Kconfig                            |  1 -
 drivers/i2c/busses/Kconfig                      |  3 --
 drivers/iio/adc/Kconfig                         |  2 --
 drivers/iommu/Kconfig                           |  5 ++-
 drivers/lightnvm/Kconfig                        |  2 +-
 drivers/mailbox/Kconfig                         |  2 --
 drivers/media/common/videobuf2/Kconfig          |  2 --
 drivers/media/pci/dt3155/Kconfig                |  1 -
 drivers/media/pci/intel/ipu3/Kconfig            |  1 -
 drivers/media/pci/solo6x10/Kconfig              |  1 -
 drivers/media/pci/sta2x11/Kconfig               |  1 -
 drivers/media/pci/tw5864/Kconfig                |  1 -
 drivers/media/pci/tw686x/Kconfig                |  1 -
 drivers/media/platform/Kconfig                  | 42 +++++++++----------------
 drivers/media/platform/am437x/Kconfig           |  2 +-
 drivers/media/platform/atmel/Kconfig            |  4 +--
 drivers/media/platform/davinci/Kconfig          |  6 ----
 drivers/media/platform/marvell-ccic/Kconfig     |  3 +-
 drivers/media/platform/rcar-vin/Kconfig         |  2 +-
 drivers/media/platform/soc_camera/Kconfig       |  3 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig    |  2 +-
 drivers/media/v4l2-core/Kconfig                 |  2 --
 drivers/mmc/host/Kconfig                        | 10 ++----
 drivers/mtd/nand/raw/Kconfig                    |  8 ++---
 drivers/mtd/spi-nor/Kconfig                     |  2 +-
 drivers/net/ethernet/amd/Kconfig                |  2 +-
 drivers/net/ethernet/apm/xgene-v2/Kconfig       |  1 -
 drivers/net/ethernet/apm/xgene/Kconfig          |  1 -
 drivers/net/ethernet/arc/Kconfig                |  6 ++--
 drivers/net/ethernet/broadcom/Kconfig           |  2 --
 drivers/net/ethernet/calxeda/Kconfig            |  2 +-
 drivers/net/ethernet/hisilicon/Kconfig          |  2 +-
 drivers/net/ethernet/marvell/Kconfig            |  8 ++---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig     |  2 +-
 drivers/net/ethernet/renesas/Kconfig            |  2 --
 drivers/net/wireless/broadcom/brcm80211/Kconfig |  1 -
 drivers/net/wireless/quantenna/qtnfmac/Kconfig  |  2 +-
 drivers/remoteproc/Kconfig                      |  1 -
 drivers/spi/Kconfig                             | 12 ++-----
 drivers/staging/media/davinci_vpfe/Kconfig      |  1 -
 drivers/staging/media/omap4iss/Kconfig          |  1 -
 drivers/staging/vc04_services/Kconfig           |  1 -
 drivers/tty/serial/Kconfig                      |  4 ---
 drivers/usb/gadget/udc/Kconfig                  |  4 +--
 drivers/usb/mtu3/Kconfig                        |  2 +-
 drivers/video/fbdev/Kconfig                     |  3 +-
 sound/soc/bcm/Kconfig                           |  3 +-
 sound/soc/kirkwood/Kconfig                      |  1 -
 sound/soc/pxa/Kconfig                           |  1 -
 sound/soc/qcom/Kconfig                          |  7 ++---
 53 files changed, 56 insertions(+), 142 deletions(-)

-- 
2.7.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
