Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41105 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3FJNXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 09:23:37 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600E7PIE3PU80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 14:23:35 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MO600FJGIJAROA0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 14:23:34 +0100 (BST)
Message-id: <51B5D356.2030509@samsung.com>
Date: Mon, 10 Jun 2013 15:23:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.11] Samsung SoC media driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes mostly cleanups and non-critical bug fixes for The Samsung
S3C/S5P/Exynos SoC media drivers, and some prerequisite patches to add 
support for more DMA interfaces of the Exynos4x12 Imaging Subsystem.

There is also included a patch modifying the media link setup notifier, 
which was needed to handle properly video pipeline reconfiguration at 
the exynos4-is driver. 

The following changes since commit ab5060cdb8829c0503b7be2b239b52e9a25063b4:

  [media] drxk_hard: Remove most 80-cols checkpatch warnings (2013-06-08 22:11:39 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.11

for you to fetch changes up to e14d355f12f2b6f8466be083d9640cc8483900ba:

  s5p-tv: Don't ignore return value of regulator_bulk_enable() in hdmi_drv.c (2013-06-10 15:18:24 +0200)

----------------------------------------------------------------
Phil Carmody (1):
      exynos4-is: Simplify bitmask usage

Sachin Kamat (10):
      s3c-camif: Staticize local symbols
      s3c-camif: Use dev_info instead of printk
      s5c73m3: Fix whitespace related warnings
      exynos4-is: Remove redundant NULL check in fimc-lite.c
      s3c-camif: Remove redundant NULL check
      s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
      s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
      exynos-gsc: Remove redundant use of of_match_ptr macro
      s5p-mfc: Remove redundant use of of_match_ptr macro
      exynos4-is: Staticize local symbols

Sylwester Nawrocki (23):
      exynos4-is: Fix example dts in .../bindings/samsung-fimc.txt
      exynos4-is: Remove platform_device_id table at fimc-lite driver
      exynos4-is: Correct querycap ioctl handling at fimc-lite driver
      s5c73m3: Do not ignore errors from regulator_enable()
      exynos4-is: Move common functions to a separate module
      exynos4-is: Add struct exynos_video_entity
      exynos4-is: Preserve state of controls between /dev/video open/close
      exynos4-is: Media graph/video device locking rework
      exynos4-is: Do not use asynchronous runtime PM in release fop
      exynos4-is: Use common exynos_media_pipeline data structure
      exynos4-is: Remove WARN_ON() from __fimc_pipeline_close()
      exynos4-is: Fix sensor subdev -> FIMC notification setup
      exynos4-is: Add locking at fimc(-lite) subdev unregistered handler
      exynos4-is: Remove leftovers of non-dt FIMC-LITE support
      exynos4-is: Remove unused code
      exynos4-is: Refactor vidioc_s_fmt, vidioc_try_fmt handlers
      exynos4-is: Move __fimc_videoc_querycap() function to the common module
      exynos4-is: Add isp_dbg() macro
      media: Change media device link_notify behaviour
      exynos4-is: Extend link_notify handler to support fimc-is/lite pipelines
      s5p-tv: Don't ignore return value of regulator_enable() in sii9234_drv.c
      s5p-tv: Do not ignore regulator/clk API return values in sdo_drv.c
      s5p-tv: Don't ignore return value of regulator_bulk_enable() in hdmi_drv.c

Wei Yongjun (1):
      s5p-tv: fix error return code in mxr_acquire_video()

 .../devicetree/bindings/media/samsung-fimc.txt     |   26 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    9 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    4 +-
 drivers/media/media-entity.c                       |   18 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos4-is/Kconfig          |    7 +-
 drivers/media/platform/exynos4-is/Makefile         |    5 +-
 drivers/media/platform/exynos4-is/common.c         |   53 +++
 drivers/media/platform/exynos4-is/common.h         |   16 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |  387 ++++++++++----------
 drivers/media/platform/exynos4-is/fimc-core.c      |   11 -
 drivers/media/platform/exynos4-is/fimc-core.h      |   13 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c  |   84 +++--
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   12 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    8 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   20 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   18 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  138 +++----
 drivers/media/platform/exynos4-is/fimc-lite.h      |    8 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    1 +
 drivers/media/platform/exynos4-is/fimc-reg.c       |    7 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  270 +++++++++-----
 drivers/media/platform/exynos4-is/media-dev.h      |   54 ++-
 drivers/media/platform/omap3isp/isp.c              |   41 ++-
 drivers/media/platform/s3c-camif/camif-core.c      |    6 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   39 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |   22 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    3 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   22 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    4 +-
 include/media/media-device.h                       |    9 +-
 include/media/s5p_fimc.h                           |   56 +--
 37 files changed, 806 insertions(+), 583 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/common.c
 create mode 100644 drivers/media/platform/exynos4-is/common.h

Thanks,
Sylwester
