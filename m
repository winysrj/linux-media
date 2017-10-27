Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56830 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932190AbdJ0RVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 13:21:38 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id EE37F600DF
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 20:21:35 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e88K6-0003J6-VC
        for linux-media@vger.kernel.org; Fri, 27 Oct 2017 20:21:34 +0300
Date: Fri, 27 Oct 2017 20:21:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] The atomisp cleanups, timer API changes
Message-ID: <20171027172134.ws4cuhrqkm7r7a33@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the atomisp cleanups that were dependent the fixes. Included is
Andy's patches to remove unused code (no hardware, makes fixing
atomisp/sensor interfaces difficult). Also Kee Cook's timer fixes are in.

Please pull.


The following changes since commit bbae615636155fa43a9b0fe0ea31c678984be864:

  media: staging: atomisp2: cleanup null check on memory allocation (2017-10-27 17:33:39 +0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to 78ca4f81e5dfed3f01e5ed3d1c3d208fc032c42b:

  staging: atomisp: Add videobuf2 switch to TODO (2017-10-27 20:16:08 +0300)

----------------------------------------------------------------
Aishwarya Pant (1):
      staging: atomisp: cleanup out of memory messages

Andy Shevchenko (13):
      staging: atomisp: Remove IMX sensor support
      staging: atomisp: Remove AP1302 sensor support
      staging: atomisp: Use module_i2c_driver() macro
      staging: atomisp: Switch i2c drivers to use ->probe_new()
      staging: atomisp: Do not set GPIO twice
      staging: atomisp: Remove unneeded gpio.h inclusion
      staging: atomisp: Remove ->gpio_ctrl() callback
      staging: atomisp: Remove ->power_ctrl() callback
      staging: atomisp: Remove duplicate declaration in header
      staging: atomisp: Remove unused members of camera_sensor_platform_data
      staging: atomisp: Remove Gmin dead code #1
      staging: atomisp: Remove Gmin dead code #2
      staging: atomisp: Remove FSF snail address

Kees Cook (2):
      staging: atomisp: Convert timers to use timer_setup()
      staging: atomisp: i2c: Convert timers to use timer_setup()

Sakari Ailus (1):
      staging: atomisp: Add videobuf2 switch to TODO

Srishti Sharma (1):
      Staging: media: atomisp: pci: Eliminate use of typedefs for struct

 drivers/staging/media/atomisp/TODO                 |    2 +
 drivers/staging/media/atomisp/i2c/Kconfig          |   22 +-
 drivers/staging/media/atomisp/i2c/Makefile         |    3 -
 drivers/staging/media/atomisp/i2c/ap1302.h         |  198 --
 drivers/staging/media/atomisp/i2c/atomisp-ap1302.c | 1255 --------
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |   53 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   54 +-
 .../media/atomisp/i2c/atomisp-libmsrlisthelper.c   |    4 -
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |   47 +-
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |   51 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |   43 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |   54 +-
 drivers/staging/media/atomisp/i2c/gc0310.h         |   11 -
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
 drivers/staging/media/atomisp/i2c/mt9m114.h        |    9 -
 drivers/staging/media/atomisp/i2c/ov2680.h         |   14 -
 drivers/staging/media/atomisp/i2c/ov2722.h         |   11 -
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |    2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h  |    4 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |   44 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |   11 -
 drivers/staging/media/atomisp/i2c/ov8858.c         |   65 +-
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
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   17 +-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |   10 +-
 .../media/atomisp/pci/atomisp2/atomisp_common.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    6 +-
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
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    8 +-
 .../media/atomisp/pci/atomisp2/atomisp_fops.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_helper.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |   13 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tables.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.h       |    4 -
 .../atomisp/pci/atomisp2/atomisp_trace_event.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   28 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.h      |    4 -
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    6 +-
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |    4 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    4 -
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |   14 +-
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |   10 +-
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |    9 +-
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |    8 +-
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
 .../platform/intel-mid/atomisp_gmin_platform.c     |   73 +-
 111 files changed, 93 insertions(+), 17406 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/i2c/ap1302.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-ap1302.c
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
Sakari Ailus
e-mail: sakari.ailus@iki.fi
