Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40602 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751637AbdIVGeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 02:34:02 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6D810600FA
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 09:34:01 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dvHXF-0005ck-2N
        for linux-media@vger.kernel.org; Fri, 22 Sep 2017 09:34:01 +0300
Date: Fri, 22 Sep 2017 09:34:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] atomisp cleanups and improvements
Message-ID: <20170922063400.vkvrhff5ci7g6qfp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of atomisp cleanups and improvements.

Please pull.


The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to 18a914f44b00ffeb1b4456bfbf3ae46b16c53e2c:

  staging: atomisp: use clock framework for camera clocks (2017-09-21 15:53:06 +0300)

----------------------------------------------------------------
Allen Pais (1):
      atomisp:use ARRAY_SIZE() instead of open coding.

Andy Shevchenko (7):
      staging: atomisp: Remove dead code for MID (#1)
      staging: atomisp: Don't override D3 delay settings here
      staging: atomisp: Remove dead code for MID (#2)
      staging: atomisp: Remove dead code for MID (#3)
      staging: atomisp: Move to upstream IOSF MBI API
      staging: atomisp: Remove dead code for MID (#4)
      staging: atomisp: Remove unneeded intel-mid.h inclusion

Arvind Yadav (1):
      Staging: atomisp: constify driver_attribute

Branislav Radocaj (1):
      Staging: atomisp: fix alloc_cast.cocci warnings

Hans Verkuil (1):
      atomisp: fix small Kconfig issues

Himanshu Jha (1):
      atomisp2: Remove null check before kfree

Nicolas Iooss (1):
      staging/atomisp: fix header guards

Pierre-Louis Bossart (1):
      staging: atomisp: use clock framework for camera clocks

Sakari Ailus (1):
      staging: media: atomisp: Use tabs in Kconfig

Srishti Sharma (2):
      Staging: media: atomisp: Merge assignment with return
      Staging: media: atomisp: Use kcalloc instead of kzalloc

Thomas Meyer (1):
      staging/atomisp: Use ARRAY_SIZE macro

 drivers/staging/media/atomisp/Kconfig              |  11 +-
 drivers/staging/media/atomisp/i2c/Kconfig          |  70 ++---
 drivers/staging/media/atomisp/i2c/imx/drv201.c     |   1 -
 drivers/staging/media/atomisp/i2c/imx/dw9714.c     |   1 -
 drivers/staging/media/atomisp/i2c/imx/imx.c        |   1 -
 drivers/staging/media/atomisp/i2c/imx/otp_imx.c    |   1 -
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |   8 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c  |  11 +-
 .../atomisp/include/asm/intel_mid_pcihelpers.h     |  37 ---
 drivers/staging/media/atomisp/pci/Kconfig          |  17 +-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  21 +-
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |   2 +-
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |   3 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |   1 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |   1 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  37 ++-
 .../hrt/input_formatter_subsystem_defs.h           |   2 +-
 .../hrt/input_formatter_subsystem_defs.h           |   2 +-
 .../hrt/input_formatter_subsystem_defs.h           |   2 +-
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |   3 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   6 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |  12 +-
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |   6 +-
 drivers/staging/media/atomisp/platform/Makefile    |   1 -
 .../staging/media/atomisp/platform/clock/Makefile  |   6 -
 .../platform/clock/platform_vlv2_plat_clk.c        |  40 ---
 .../platform/clock/platform_vlv2_plat_clk.h        |  27 --
 .../media/atomisp/platform/clock/vlv2_plat_clock.c | 247 -----------------
 .../media/atomisp/platform/intel-mid/Makefile      |   1 -
 .../platform/intel-mid/atomisp_gmin_platform.c     |  63 ++++-
 .../platform/intel-mid/intel_mid_pcihelpers.c      | 297 ---------------------
 31 files changed, 149 insertions(+), 789 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/Makefile
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
 delete mode 100644 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
