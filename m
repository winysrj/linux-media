Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2IQFe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 01:34:58 -0400
Received: by pbbrr13 with SMTP id rr13so8484072pbb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 22:34:57 -0700 (PDT)
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, Chris Ball <cjb@laptop.org>,
	linux-mmc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	rtc-linux@googlegroups.com,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	linux-mtd@lists.infradead.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	linux-i2c@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
	linux-watchdog@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH 00/34] i.MX multi-platform support
Date: Mon, 17 Sep 2012 13:34:29 +0800
Message-Id: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The series enables multi-platform support for imx.  Since the required
frameworks (clk, pwm) and spare_irq have already been adopted on imx,
the series is all about cleaning up mach/* headers.  Along with the
changes, arch/arm/plat-mxc gets merged into arch/arm/mach-imx.

It's based on a bunch of branches (works from others), Rob's initial
multi-platform series, Arnd's platform-data and smp_ops (Marc's) and
imx 3.7 material (Sascha and myself).

It's available on branch below.

  git://git.linaro.org/people/shawnguo/linux-2.6.git imx/multi-platform

It's been tested on imx5 and imx6, and only compile-tested on imx2 and
imx3, so testing on imx2/3 are appreciated.

Subsystem maintainers,

I plan to send the whole series via arm-soc tree at the end of 3.7
merge window when all dependant bits hit mainline.  Please have a
look at the patches you get copied and provide ACKs if the changes
are good.  Thanks.

Shawn Guo (34):
  ARM: imx: include board headers in the same folder
  ASoC: mx27vis: retrieve gpio numbers from platform_data
  ARM: imx: move iomux drivers and headers into mach-imx
  ARM: imx: remove unnecessary inclusion from device-imx*.h
  ARM: imx: move platform device code into mach-imx
  ARM: imx: merge plat-mxc into mach-imx
  ARM: imx: include common.h rather than mach/common.h
  ARM: imx: ARM: imx: include cpuidle.h rather than mach/cpuidle.h
  ARM: imx: include iim.h rather than mach/iim.h
  ARM: imx: include iram.h rather than mach/iram.h
  ARM: imx: include ulpi.h rather than mach/ulpi.h
  media: mx1_camera: remove the driver
  ARM: imx: remove mach/dma-mx1-mx2.h
  dma: ipu: rename mach/ipu.h to include/linux/dma/ipu-dma.h
  dma: imx-sdma: remove unneeded mach/hardware.h inclusion
  ASoC: imx-ssi: remove unneeded mach/hardware.h inclusion
  usb: ehci-mxc: remove unneeded mach/hardware.h inclusion
  video: mx3fb: remove unneeded mach/hardware.h inclusion
  watchdog: imx2_wdt: remove unneeded mach/hardware.h inclusion
  i2c: imx: remove mach/hardware.h inclusion
  mtd: mxc_nand: remove mach/hardware.h inclusion
  rtc: mxc_rtc: remove mach/hardware.h inclusion
  dma: imx-dma: use devm_kzalloc and devm_request_irq
  dma: imx-dma: retrieve MEM and IRQ from resources
  dma: imx-dma: remove mach/hardware.h inclusion
  media: mx2_camera: remove dead code in mx2_camera_add_device
  media: mx2_camera: use managed functions to clean up code
  media: mx2_camera: remove mach/hardware.h inclusion
  mmc: mxcmmc: remove mach/hardware.h inclusion
  video: imxfb: remove mach/hardware.h inclusion
  ARM: imx: move debug macros to include/debug
  ARM: imx: include hardware.h rather than mach/hardware.h
  ARM: imx: remove header file mach/irqs.h
  ARM: imx: enable multi-platform build

 .../devicetree/bindings/i2c/fsl-imx-i2c.txt        |    4 +-
 arch/arm/Kconfig                                   |   15 +-
 arch/arm/Kconfig.debug                             |    8 +
 arch/arm/Makefile                                  |    1 -
 arch/arm/boot/dts/imx27.dtsi                       |    4 +-
 arch/arm/boot/dts/imx51.dtsi                       |    4 +-
 arch/arm/boot/dts/imx53.dtsi                       |    6 +-
 arch/arm/boot/dts/imx6q.dtsi                       |    6 +-
 .../mach/debug-macro.S => include/debug/imx.S}     |   33 +-
 arch/arm/{plat-mxc => mach-imx}/3ds_debugboard.c   |    2 +-
 .../include/mach => mach-imx}/3ds_debugboard.h     |    0
 arch/arm/mach-imx/Kconfig                          |   86 ++
 arch/arm/mach-imx/Makefile                         |   23 +-
 arch/arm/{plat-mxc => mach-imx}/avic.c             |    5 +-
 .../include/mach => mach-imx}/board-mx31lilly.h    |    0
 .../include/mach => mach-imx}/board-mx31lite.h     |    0
 .../include/mach => mach-imx}/board-mx31moboard.h  |    0
 .../include/mach => mach-imx}/board-pcm038.h       |    0
 arch/arm/mach-imx/clk-imx1.c                       |   15 +-
 arch/arm/mach-imx/clk-imx21.c                      |   14 +-
 arch/arm/mach-imx/clk-imx25.c                      |   26 +-
 arch/arm/mach-imx/clk-imx27.c                      |   36 +-
 arch/arm/mach-imx/clk-imx31.c                      |   21 +-
 arch/arm/mach-imx/clk-imx35.c                      |   13 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |   15 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    3 +-
 arch/arm/mach-imx/clk-pllv1.c                      |    4 +-
 .../{plat-mxc/include/mach => mach-imx}/common.h   |    0
 arch/arm/mach-imx/cpu-imx25.c                      |    5 +-
 arch/arm/mach-imx/cpu-imx27.c                      |    2 +-
 arch/arm/mach-imx/cpu-imx31.c                      |    7 +-
 arch/arm/mach-imx/cpu-imx35.c                      |    5 +-
 arch/arm/mach-imx/cpu-imx5.c                       |    3 +-
 arch/arm/{plat-mxc => mach-imx}/cpu.c              |    3 +-
 arch/arm/mach-imx/cpu_op-mx51.c                    |    3 +-
 arch/arm/{plat-mxc => mach-imx}/cpufreq.c          |    3 +-
 arch/arm/{plat-mxc => mach-imx}/cpuidle.c          |    0
 .../{plat-mxc/include/mach => mach-imx}/cpuidle.h  |    0
 arch/arm/mach-imx/devices-imx1.h                   |    3 +-
 arch/arm/mach-imx/devices-imx21.h                  |    3 +-
 arch/arm/mach-imx/devices-imx25.h                  |    3 +-
 arch/arm/mach-imx/devices-imx27.h                  |    3 +-
 arch/arm/mach-imx/devices-imx31.h                  |    3 +-
 arch/arm/mach-imx/devices-imx35.h                  |    3 +-
 arch/arm/mach-imx/devices-imx50.h                  |    3 +-
 arch/arm/mach-imx/devices-imx51.h                  |    3 +-
 arch/arm/{plat-mxc => mach-imx}/devices/Kconfig    |    3 -
 arch/arm/{plat-mxc => mach-imx}/devices/Makefile   |    3 +-
 .../mach => mach-imx/devices}/devices-common.h     |   19 +-
 arch/arm/{plat-mxc => mach-imx/devices}/devices.c  |    1 -
 .../devices/platform-ahci-imx.c                    |    5 +-
 .../{plat-mxc => mach-imx}/devices/platform-fec.c  |    5 +-
 .../devices/platform-flexcan.c                     |    4 +-
 .../devices/platform-fsl-usb2-udc.c                |    5 +-
 .../devices/platform-gpio-mxc.c                    |    2 +-
 .../devices/platform-gpio_keys.c                   |    5 +-
 .../devices/platform-imx-dma.c                     |   23 +-
 .../devices/platform-imx-fb.c                      |   16 +-
 .../devices/platform-imx-i2c.c                     |   31 +-
 .../devices/platform-imx-keypad.c                  |    4 +-
 .../devices/platform-imx-ssi.c                     |    4 +-
 .../devices/platform-imx-uart.c                    |    4 +-
 .../devices/platform-imx2-wdt.c                    |    5 +-
 .../devices/platform-imx21-hcd.c                   |    4 +-
 .../devices/platform-imx_udc.c                     |    4 +-
 .../devices/platform-imxdi_rtc.c                   |    5 +-
 .../devices/platform-ipu-core.c                    |    5 +-
 .../devices/platform-mx2-camera.c                  |   16 +-
 .../devices/platform-mxc-ehci.c                    |    5 +-
 .../devices/platform-mxc-mmc.c                     |   20 +-
 .../devices/platform-mxc_nand.c                    |   25 +-
 .../devices/platform-mxc_pwm.c                     |    4 +-
 .../devices/platform-mxc_rnga.c                    |    4 +-
 .../devices/platform-mxc_rtc.c                     |   13 +-
 .../devices/platform-mxc_w1.c                      |    4 +-
 .../devices/platform-pata_imx.c                    |    4 +-
 .../devices/platform-sdhci-esdhc-imx.c             |    5 +-
 .../devices/platform-spi_imx.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx25.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx27.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx31.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx35.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx5.c                      |    4 +-
 arch/arm/{plat-mxc => mach-imx}/epit.c             |    6 +-
 .../include/mach => mach-imx}/eukrea-baseboards.h  |    0
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |    7 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |    8 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |    7 +-
 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c     |    7 +-
 .../{plat-mxc/include/mach => mach-imx}/hardware.h |   26 +-
 arch/arm/mach-imx/hotplug.c                        |    3 +-
 arch/arm/{plat-mxc/include/mach => mach-imx}/iim.h |    0
 arch/arm/mach-imx/imx27-dt.c                       |   11 +-
 arch/arm/mach-imx/imx31-dt.c                       |    5 +-
 arch/arm/mach-imx/imx51-dt.c                       |    9 +-
 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h       |   10 -
 arch/arm/mach-imx/iomux-imx31.c                    |    5 +-
 .../include/mach => mach-imx}/iomux-mx1.h          |    2 +-
 .../include/mach => mach-imx}/iomux-mx21.h         |    4 +-
 .../include/mach => mach-imx}/iomux-mx25.h         |    2 +-
 .../include/mach => mach-imx}/iomux-mx27.h         |    4 +-
 .../include/mach => mach-imx}/iomux-mx2x.h         |    0
 .../include/mach => mach-imx}/iomux-mx3.h          |    0
 .../include/mach => mach-imx}/iomux-mx35.h         |    2 +-
 .../include/mach => mach-imx}/iomux-mx50.h         |    2 +-
 .../include/mach => mach-imx}/iomux-mx51.h         |    2 +-
 arch/arm/{plat-mxc => mach-imx}/iomux-v1.c         |    5 +-
 .../{plat-mxc/include/mach => mach-imx}/iomux-v1.h |    0
 arch/arm/{plat-mxc => mach-imx}/iomux-v3.c         |    5 +-
 .../{plat-mxc/include/mach => mach-imx}/iomux-v3.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/iram.h |    0
 arch/arm/{plat-mxc => mach-imx}/iram_alloc.c       |    3 +-
 arch/arm/{plat-mxc => mach-imx}/irq-common.c       |    0
 arch/arm/{plat-mxc => mach-imx}/irq-common.h       |    3 +
 arch/arm/mach-imx/lluart.c                         |    3 +-
 arch/arm/mach-imx/mach-apf9328.c                   |    7 +-
 arch/arm/mach-imx/mach-armadillo5x0.c              |    9 +-
 arch/arm/mach-imx/mach-bug.c                       |    7 +-
 arch/arm/mach-imx/mach-cpuimx27.c                  |   11 +-
 arch/arm/mach-imx/mach-cpuimx35.c                  |    9 +-
 arch/arm/mach-imx/mach-cpuimx51sd.c                |    9 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |   10 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |   48 +-
 arch/arm/mach-imx/mach-imx27ipcam.c                |    6 +-
 arch/arm/mach-imx/mach-imx27lite.c                 |    6 +-
 arch/arm/mach-imx/mach-imx53.c                     |   11 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    6 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    7 +-
 arch/arm/mach-imx/mach-mx1ads.c                    |    7 +-
 arch/arm/mach-imx/mach-mx21ads.c                   |    6 +-
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    8 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |   10 +-
 arch/arm/mach-imx/mach-mx27ads.c                   |    6 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   12 +-
 arch/arm/mach-imx/mach-mx31ads.c                   |    5 +-
 arch/arm/mach-imx/mach-mx31lilly.c                 |   11 +-
 arch/arm/mach-imx/mach-mx31lite.c                  |   11 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   14 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    8 +-
 arch/arm/mach-imx/mach-mx50_rdp.c                  |    7 +-
 arch/arm/mach-imx/mach-mx51_3ds.c                  |    9 +-
 arch/arm/mach-imx/mach-mx51_babbage.c              |    7 +-
 arch/arm/mach-imx/mach-mxt_td60.c                  |    6 +-
 arch/arm/mach-imx/mach-pca100.c                    |    8 +-
 arch/arm/mach-imx/mach-pcm037.c                    |    8 +-
 arch/arm/mach-imx/mach-pcm037_eet.c                |    5 +-
 arch/arm/mach-imx/mach-pcm038.c                    |   13 +-
 arch/arm/mach-imx/mach-pcm043.c                    |    9 +-
 arch/arm/mach-imx/mach-qong.c                      |    6 +-
 arch/arm/mach-imx/mach-scb9328.c                   |    7 +-
 arch/arm/mach-imx/mach-vpr200.c                    |    7 +-
 arch/arm/mach-imx/mm-imx1.c                        |    9 +-
 arch/arm/mach-imx/mm-imx21.c                       |   12 +-
 arch/arm/mach-imx/mm-imx25.c                       |   10 +-
 arch/arm/mach-imx/mm-imx27.c                       |   12 +-
 arch/arm/mach-imx/mm-imx3.c                        |    9 +-
 arch/arm/mach-imx/mm-imx5.c                        |    8 +-
 arch/arm/mach-imx/mx1-camera-fiq-ksym.c            |   18 -
 arch/arm/mach-imx/mx1-camera-fiq.S                 |   35 -
 arch/arm/{plat-mxc/include/mach => mach-imx}/mx1.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx21.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx25.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx27.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx2x.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx31.h |    0
 arch/arm/mach-imx/mx31lilly-db.c                   |    9 +-
 arch/arm/mach-imx/mx31lite-db.c                    |    9 +-
 arch/arm/mach-imx/mx31moboard-devboard.c           |    9 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c            |    9 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c           |   11 +-
 .../arm/{plat-mxc/include/mach => mach-imx}/mx35.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx3x.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx50.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx51.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx53.h |    0
 .../arm/{plat-mxc/include/mach => mach-imx}/mx6q.h |    0
 arch/arm/{plat-mxc/include/mach => mach-imx}/mxc.h |    0
 arch/arm/mach-imx/pcm970-baseboard.c               |    7 +-
 arch/arm/mach-imx/platsmp.c                        |    5 +-
 arch/arm/mach-imx/pm-imx27.c                       |    3 +-
 arch/arm/mach-imx/pm-imx3.c                        |    7 +-
 arch/arm/mach-imx/pm-imx5.c                        |    7 +-
 arch/arm/mach-imx/pm-imx6q.c                       |    5 +-
 arch/arm/{plat-mxc => mach-imx}/ssi-fiq-ksym.c     |    0
 arch/arm/{plat-mxc => mach-imx}/ssi-fiq.S          |    0
 arch/arm/{plat-mxc => mach-imx}/system.c           |    5 +-
 arch/arm/{plat-mxc => mach-imx}/time.c             |    5 +-
 arch/arm/{plat-mxc => mach-imx}/tzic.c             |    6 +-
 arch/arm/{plat-mxc => mach-imx}/ulpi.c             |    2 +-
 .../arm/{plat-mxc/include/mach => mach-imx}/ulpi.h |    0
 arch/arm/plat-mxc/Kconfig                          |   89 --
 arch/arm/plat-mxc/Makefile                         |   24 -
 arch/arm/plat-mxc/devices/platform-mx1-camera.c    |   42 -
 arch/arm/plat-mxc/include/mach/irqs.h              |   21 -
 arch/arm/plat-mxc/include/mach/timex.h             |   22 -
 arch/arm/plat-mxc/include/mach/uncompress.h        |  132 ---
 drivers/dma/imx-dma.c                              |  137 +--
 drivers/dma/imx-sdma.c                             |    1 -
 drivers/dma/ipu/ipu_idmac.c                        |    3 +-
 drivers/dma/ipu/ipu_irq.c                          |    3 +-
 drivers/i2c/busses/i2c-imx.c                       |   40 +-
 drivers/media/video/Kconfig                        |   12 -
 drivers/media/video/Makefile                       |    1 -
 drivers/media/video/mx1_camera.c                   |  889 --------------------
 drivers/media/video/mx2_camera.c                   |  240 +++---
 drivers/media/video/mx3_camera.c                   |    2 +-
 drivers/mmc/host/mxcmmc.c                          |   31 +-
 drivers/mtd/nand/mxc_nand.c                        |   86 +-
 drivers/rtc/rtc-mxc.c                              |   34 +-
 drivers/usb/host/ehci-mxc.c                        |    1 -
 drivers/video/imxfb.c                              |   38 +-
 drivers/video/mx3fb.c                              |    3 +-
 drivers/watchdog/imx2_wdt.c                        |    1 -
 .../mach/ipu.h => include/linux/dma/ipu-dma.h      |    6 +-
 include/linux/platform_data/asoc-mx27vis.h         |   11 +
 include/linux/platform_data/camera-mx1.h           |   35 -
 sound/soc/fsl/imx-pcm-fiq.c                        |    3 +-
 sound/soc/fsl/imx-ssi.c                            |    1 -
 sound/soc/fsl/mx27vis-aic32x4.c                    |   42 +-
 219 files changed, 1149 insertions(+), 2170 deletions(-)
 rename arch/arm/{plat-mxc/include/mach/debug-macro.S => include/debug/imx.S} (59%)
 rename arch/arm/{plat-mxc => mach-imx}/3ds_debugboard.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/3ds_debugboard.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/avic.c (98%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31lilly.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31lite.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-mx31moboard.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/board-pcm038.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/common.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/cpu.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/cpufreq.c (99%)
 rename arch/arm/{plat-mxc => mach-imx}/cpuidle.c (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/cpuidle.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/Kconfig (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/Makefile (96%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/devices}/devices-common.h (96%)
 rename arch/arm/{plat-mxc => mach-imx/devices}/devices.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-ahci-imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-fec.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-flexcan.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-fsl-usb2-udc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-gpio-mxc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-gpio_keys.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-dma.c (63%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-fb.c (79%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-i2c.c (77%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-keypad.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-ssi.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx-uart.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx2-wdt.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx21-hcd.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imx_udc.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-imxdi_rtc.c (94%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-ipu-core.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mx2-camera.c (83%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc-ehci.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc-mmc.c (76%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_nand.c (74%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_pwm.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_rnga.c (95%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_rtc.c (77%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-mxc_w1.c (95%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-pata_imx.c (96%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-sdhci-esdhc-imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/devices/platform-spi_imx.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/epit.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/eukrea-baseboards.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/hardware.h (94%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iim.h (100%)
 delete mode 100644 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx1.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx21.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx25.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx27.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx3.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx35.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx50.h (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-mx51.h (99%)
 rename arch/arm/{plat-mxc => mach-imx}/iomux-v1.c (98%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-v1.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/iomux-v3.c (97%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iomux-v3.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/iram.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/iram_alloc.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/irq-common.c (100%)
 rename arch/arm/{plat-mxc => mach-imx}/irq-common.h (94%)
 delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
 delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx1.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx21.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx25.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx27.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx31.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx35.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx3x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx50.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx51.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx53.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mx6q.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/mxc.h (100%)
 rename arch/arm/{plat-mxc => mach-imx}/ssi-fiq-ksym.c (100%)
 rename arch/arm/{plat-mxc => mach-imx}/ssi-fiq.S (100%)
 rename arch/arm/{plat-mxc => mach-imx}/system.c (97%)
 rename arch/arm/{plat-mxc => mach-imx}/time.c (99%)
 rename arch/arm/{plat-mxc => mach-imx}/tzic.c (98%)
 rename arch/arm/{plat-mxc => mach-imx}/ulpi.c (99%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx}/ulpi.h (100%)
 delete mode 100644 arch/arm/plat-mxc/Kconfig
 delete mode 100644 arch/arm/plat-mxc/Makefile
 delete mode 100644 arch/arm/plat-mxc/devices/platform-mx1-camera.c
 delete mode 100644 arch/arm/plat-mxc/include/mach/irqs.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/timex.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/uncompress.h
 delete mode 100644 drivers/media/video/mx1_camera.c
 rename arch/arm/plat-mxc/include/mach/ipu.h => include/linux/dma/ipu-dma.h (97%)
 create mode 100644 include/linux/platform_data/asoc-mx27vis.h
 delete mode 100644 include/linux/platform_data/camera-mx1.h

-- 
1.7.9.5

