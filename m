Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27346 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdI0SZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:12 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 00/13] staging: atomisp: clean up bomb
Date: Wed, 27 Sep 2017 21:24:55 +0300
Message-Id: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver has been submitted with a limitation to few platforms and
sensors which it does support. Even though two sensor drivers have no
users neither on ACPI-enabled platforms, nor in current Linux kernel
code. Patches 1 and 2 removes those drivers for now.

It seems new contributors follow cargo cult programming done by the
original driver developers. It's neither good for code, nor for
reviewing process. To avoid such issues in the future here are few clean
up patches, i.e. patches 3, 4, 6. 13.

On top of this here are clean ups with regard to GPIO use. One may
consider this as an intermediate clean up. This part toughly related to
removal of unused sensor drivers in patches 1 and 2.

Patch series has been partially compile tested. It would be nice to see
someone with hardware to confirm it doesn't break anything.

Andy Shevchenko (13):
  staging: atomisp: Remove IMX sensor support
  staging: atomisp: Remove AP1302 sensor support
  staging: atomisp: Use module_i2c_driver() macro
  staging: atomisp: Switch i2c drivers to use ->probe_new()
  staging: atomisp: Do not set GPIO twice
  staging: atomisp: Remove unneeded gpio.h inclusion
  staging: atomisp: Remove ->gpio_ctrl() callback
  staging: atomisp: Remove ->power_ctrl() callback
  staging: atomisp: Remove unused members of camera_sensor_platform_data
  staging: atomisp: Remove Gmin dead code #1
  staging: atomisp: Remove Gmin dead code #2
  staging: atomisp: Remove duplicate declaration in header
  staging: atomisp: Remove FSF snail address

 drivers/staging/media/atomisp/i2c/Kconfig          |   22 +-
 drivers/staging/media/atomisp/i2c/Makefile         |    3 -
 drivers/staging/media/atomisp/i2c/ap1302.c         | 1255 --------
 drivers/staging/media/atomisp/i2c/ap1302.h         |  198 --
 drivers/staging/media/atomisp/i2c/gc0310.c         |   49 +-
 drivers/staging/media/atomisp/i2c/gc0310.h         |   11 -
 drivers/staging/media/atomisp/i2c/gc2235.c         |   50 +-
 drivers/staging/media/atomisp/i2c/gc2235.h         |    7 -
 drivers/staging/media/atomisp/i2c/imx/Kconfig      |    9 -
 drivers/staging/media/atomisp/i2c/imx/Makefile     |   13 -
 drivers/staging/media/atomisp/i2c/imx/ad5816g.c    |  216 --
 drivers/staging/media/atomisp/i2c/imx/ad5816g.h    |   49 -
 drivers/staging/media/atomisp/i2c/imx/common.h     |   65 -
 drivers/staging/media/atomisp/i2c/imx/drv201.c     |  208 --
 drivers/staging/media/atomisp/i2c/imx/drv201.h     |   38 -
 drivers/staging/media/atomisp/i2c/imx/dw9714.c     |  222 --
 drivers/staging/media/atomisp/i2c/imx/dw9714.h     |   63 -
 drivers/staging/media/atomisp/i2c/imx/dw9718.c     |  233 --
 drivers/staging/media/atomisp/i2c/imx/dw9718.h     |   64 -
 drivers/staging/media/atomisp/i2c/imx/dw9719.c     |  198 --
 drivers/staging/media/atomisp/i2c/imx/dw9719.h     |   58 -
 drivers/staging/media/atomisp/i2c/imx/imx.c        | 2479 --------------
 drivers/staging/media/atomisp/i2c/imx/imx.h        |  737 -----
 drivers/staging/media/atomisp/i2c/imx/imx132.h     |  566 ----
 drivers/staging/media/atomisp/i2c/imx/imx134.h     | 2464 --------------
 drivers/staging/media/atomisp/i2c/imx/imx135.h     | 3374 --------------------
 drivers/staging/media/atomisp/i2c/imx/imx175.h     | 1959 ------------
 drivers/staging/media/atomisp/i2c/imx/imx208.h     |  550 ----
 drivers/staging/media/atomisp/i2c/imx/imx219.h     |  227 --
 drivers/staging/media/atomisp/i2c/imx/imx227.h     |  726 -----
 drivers/staging/media/atomisp/i2c/imx/otp.c        |   39 -
 .../media/atomisp/i2c/imx/otp_brcc064_e2prom.c     |   80 -
 drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c |   89 -
 drivers/staging/media/atomisp/i2c/imx/otp_imx.c    |  190 --
 drivers/staging/media/atomisp/i2c/imx/vcm.c        |   45 -
 .../staging/media/atomisp/i2c/libmsrlisthelper.c   |    4 -
 drivers/staging/media/atomisp/i2c/lm3554.c         |   35 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c        |   47 +-
 drivers/staging/media/atomisp/i2c/mt9m114.h        |    9 -
 drivers/staging/media/atomisp/i2c/ov2680.c         |   39 +-
 drivers/staging/media/atomisp/i2c/ov2680.h         |   14 -
 drivers/staging/media/atomisp/i2c/ov2722.c         |   50 +-
 drivers/staging/media/atomisp/i2c/ov2722.h         |   11 -
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |    2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h  |    4 -
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c  |   40 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |   11 -
 drivers/staging/media/atomisp/i2c/ov8858.c         |   59 +-
 drivers/staging/media/atomisp/i2c/ov8858.h         |    5 -
 drivers/staging/media/atomisp/i2c/ov8858_btns.h    |    5 -
 .../staging/media/atomisp/include/linux/atomisp.h  |    4 -
 .../atomisp/include/linux/atomisp_gmin_platform.h  |    3 -
 .../media/atomisp/include/linux/atomisp_platform.h |   25 +-
 .../media/atomisp/include/linux/libmsrlisthelper.h |    4 -
 .../staging/media/atomisp/include/media/lm3554.h   |    5 -
 .../staging/media/atomisp/include/media/lm3642.h   |  153 -
 .../media/atomisp/pci/atomisp2/atomisp-regs.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.h       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_common.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_css20.h    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.c  |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.h  |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.c      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.h      |    4 -
 .../atomisp/pci/atomisp2/atomisp_dfs_tables.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_file.c      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_file.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_helper.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tables.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.h       |    4 -
 .../atomisp/pci/atomisp2/atomisp_trace_event.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   13 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.h      |    4 -
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    4 -
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |    4 -
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |    4 -
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |    4 -
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |    4 -
 .../atomisp2/hrt/hive_isp_css_custom_host_hrt.h    |    4 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |    4 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |    4 -
 .../media/atomisp/pci/atomisp2/include/hmm/hmm.h   |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo.h      |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h  |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_common.h  |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_pool.h    |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_vm.h      |    4 -
 .../atomisp/pci/atomisp2/include/mmu/isp_mmu.h     |    4 -
 .../atomisp/pci/atomisp2/include/mmu/sh_mmu.h      |    4 -
 .../pci/atomisp2/include/mmu/sh_mmu_mrfld.h        |    4 -
 .../media/atomisp/pci/atomisp2/mmu/isp_mmu.c       |    4 -
 .../media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c  |    4 -
 .../platform/intel-mid/atomisp_gmin_platform.c     |   48 +-
 108 files changed, 56 insertions(+), 17290 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/i2c/ap1302.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ap1302.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/Makefile
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/ad5816g.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/ad5816g.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/common.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/drv201.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/drv201.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9714.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9714.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9718.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9718.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9719.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9719.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx132.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx134.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx135.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx175.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx208.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx219.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx227.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_imx.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/vcm.c
 delete mode 100644 drivers/staging/media/atomisp/include/media/lm3642.h

-- 
2.14.1
