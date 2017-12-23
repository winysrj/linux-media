Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750713AbdLWLEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 06:04:40 -0500
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <ysxie@foxmail.com>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>, <boris.brezillon@free-electrons.com>,
        <richard@nod.at>, <marek.vasut@gmail.com>,
        <cyrille.pitchen@wedev4u.fr>, <linux-mtd@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <wim@iguana.be>,
        <linux@roeck-us.net>, <linux-watchdog@vger.kernel.org>,
        <b.zolnierkie@samsung.com>, <linux-fbdev@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <marc.zyngier@arm.com>, <arnd@arndb.de>,
        <andriy.shevchenko@linux.intel.com>,
        <industrypack-devel@lists.sourceforge.net>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <a.zummo@towertech.it>, <alexandre.belloni@free-electrons.com>,
        <linux-rtc@vger.kernel.org>, <daniel.vetter@intel.com>,
        <jani.nikula@linux.intel.com>, <seanpaul@chromium.org>,
        <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <tj@kernel.org>,
        <linux-ide@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <dvhart@infradead.org>, <andy@infradead.org>,
        <platform-driver-x86@vger.kernel.org>,
        <jakub.kicinski@netronome.com>, <davem@davemloft.net>,
        <nios2-dev@lists.rocketboards.org>, <netdev@vger.kernel.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <jslaby@suse.com>,
        Yisheng Xie <xieyisheng1@huawei.com>
Subject: [PATCH v3 00/27] kill devm_ioremap_nocache
Date: Sat, 23 Dec 2017 18:55:25 +0800
Message-ID: <1514026525-32538-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

When I tried to use devm_ioremap function and review related code, I found
devm_ioremap and devm_ioremap_nocache is almost the same with each other,
except one use ioremap while the other use ioremap_nocache. While ioremap's
default function is ioremap_nocache, so devm_ioremap_nocache also have the
same function with devm_ioremap, which can just be killed to reduce the size
of devres.o(from 20304 bytes to 18992 bytes in my compile environment).

I have posted two versions, which use macro instead of function for
devm_ioremap_nocache[1] or devm_ioremap[2]. And Greg suggest me to kill
devm_ioremap_nocache for no need to keep a macro around for the duplicate
thing. So here comes v3 and please help to review.

Thanks so much!
Yisheng Xie

[1] https://lkml.org/lkml/2017/11/20/135
[2] https://lkml.org/lkml/2017/11/25/21

Yisheng Xie (27):
  ASOC: replace devm_ioremap_nocache with devm_ioremap
  spi: replace devm_ioremap_nocache with devm_ioremap
  staging: replace devm_ioremap_nocache with devm_ioremap
  ipack: replace devm_ioremap_nocache with devm_ioremap
  media: replace devm_ioremap_nocache with devm_ioremap
  gpio: replace devm_ioremap_nocache with devm_ioremap
  mmc: replace devm_ioremap_nocache with devm_ioremap
  PCI: replace devm_ioremap_nocache with devm_ioremap
  platform/x86: replace devm_ioremap_nocache with devm_ioremap
  tty: replace devm_ioremap_nocache with devm_ioremap
  video: replace devm_ioremap_nocache with devm_ioremap
  rtc: replace devm_ioremap_nocache with devm_ioremap
  char: replace devm_ioremap_nocache with devm_ioremap
  mtd: nand: replace devm_ioremap_nocache with devm_ioremap
  dmaengine: replace devm_ioremap_nocache with devm_ioremap
  ata: replace devm_ioremap_nocache with devm_ioremap
  irqchip: replace devm_ioremap_nocache with devm_ioremap
  pinctrl: replace devm_ioremap_nocache with devm_ioremap
  drm: replace devm_ioremap_nocache with devm_ioremap
  regulator: replace devm_ioremap_nocache with devm_ioremap
  watchdog: replace devm_ioremap_nocache with devm_ioremap
  tools/testing/nvdimm: replace devm_ioremap_nocache with devm_ioremap
  MIPS: pci: replace devm_ioremap_nocache with devm_ioremap
  can: replace devm_ioremap_nocache with devm_ioremap
  wireless: replace devm_ioremap_nocache with devm_ioremap
  ethernet: replace devm_ioremap_nocache with devm_ioremap
  devres: kill devm_ioremap_nocache

 Documentation/driver-model/devres.txt           |  1 -
 arch/mips/pci/pci-ar2315.c                      |  3 +--
 drivers/ata/pata_arasan_cf.c                    |  3 +--
 drivers/ata/pata_octeon_cf.c                    |  9 ++++----
 drivers/ata/pata_rb532_cf.c                     |  2 +-
 drivers/char/hw_random/bcm63xx-rng.c            |  3 +--
 drivers/char/hw_random/octeon-rng.c             | 10 ++++-----
 drivers/dma/altera-msgdma.c                     |  3 +--
 drivers/dma/sprd-dma.c                          |  4 ++--
 drivers/gpio/gpio-ath79.c                       |  3 +--
 drivers/gpio/gpio-em.c                          |  6 ++---
 drivers/gpio/gpio-htc-egpio.c                   |  4 ++--
 drivers/gpio/gpio-xgene.c                       |  3 +--
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c |  2 +-
 drivers/gpu/drm/msm/msm_drv.c                   |  2 +-
 drivers/gpu/drm/sti/sti_dvo.c                   |  3 +--
 drivers/gpu/drm/sti/sti_hda.c                   |  4 ++--
 drivers/gpu/drm/sti/sti_hdmi.c                  |  2 +-
 drivers/gpu/drm/sti/sti_tvout.c                 |  2 +-
 drivers/gpu/drm/sti/sti_vtg.c                   |  2 +-
 drivers/ipack/devices/ipoctal.c                 | 13 +++++------
 drivers/irqchip/irq-renesas-intc-irqpin.c       |  4 ++--
 drivers/media/platform/tegra-cec/tegra_cec.c    |  4 ++--
 drivers/mmc/host/sdhci-acpi.c                   |  3 +--
 drivers/mtd/nand/fsl_upm.c                      |  4 ++--
 drivers/net/can/sja1000/sja1000_platform.c      |  4 ++--
 drivers/net/ethernet/altera/altera_tse_main.c   |  3 +--
 drivers/net/ethernet/ethoc.c                    |  8 +++----
 drivers/net/ethernet/lantiq_etop.c              |  4 ++--
 drivers/net/ethernet/ti/netcp_core.c            |  2 +-
 drivers/net/wireless/ath/ath9k/ahb.c            |  2 +-
 drivers/pci/dwc/pci-dra7xx.c                    |  2 +-
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c           |  2 +-
 drivers/pinctrl/bcm/pinctrl-nsp-mux.c           |  4 ++--
 drivers/pinctrl/freescale/pinctrl-imx1-core.c   |  2 +-
 drivers/pinctrl/pinctrl-amd.c                   |  4 ++--
 drivers/platform/x86/intel_pmc_core.c           |  5 ++---
 drivers/regulator/ti-abb-regulator.c            |  6 ++---
 drivers/rtc/rtc-sh.c                            |  4 ++--
 drivers/spi/spi-jcore.c                         |  3 +--
 drivers/staging/fsl-mc/bus/mc-io.c              |  8 +++----
 drivers/tty/mips_ejtag_fdc.c                    |  4 ++--
 drivers/tty/serial/8250/8250_omap.c             |  3 +--
 drivers/tty/serial/lantiq.c                     |  3 +--
 drivers/tty/serial/meson_uart.c                 |  3 +--
 drivers/tty/serial/owl-uart.c                   |  2 +-
 drivers/tty/serial/pic32_uart.c                 |  4 ++--
 drivers/video/fbdev/mbx/mbxfb.c                 |  9 ++++----
 drivers/video/fbdev/mmp/hw/mmp_ctrl.c           |  2 +-
 drivers/video/fbdev/pxa168fb.c                  |  4 ++--
 drivers/watchdog/bcm63xx_wdt.c                  |  4 ++--
 drivers/watchdog/rc32434_wdt.c                  |  4 ++--
 include/linux/io.h                              |  2 --
 lib/devres.c                                    | 29 -------------------------
 scripts/coccinelle/free/devm_free.cocci         |  2 --
 sound/soc/au1x/ac97c.c                          |  4 ++--
 sound/soc/au1x/i2sc.c                           |  4 ++--
 sound/soc/intel/atom/sst/sst_acpi.c             | 20 ++++++++---------
 sound/soc/intel/boards/mfld_machine.c           |  4 ++--
 sound/soc/sh/fsi.c                              |  4 ++--
 tools/testing/nvdimm/Kbuild                     |  2 +-
 tools/testing/nvdimm/test/iomap.c               |  2 +-
 62 files changed, 109 insertions(+), 168 deletions(-)

-- 
1.8.3.1
