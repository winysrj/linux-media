Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42454 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751345AbdFFMNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 08:13:39 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0587E600CE
        for <linux-media@vger.kernel.org>; Tue,  6 Jun 2017 15:13:33 +0300 (EEST)
Date: Tue, 6 Jun 2017 15:13:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v3 FOR v4.13] V4L2 fwnode support
Message-ID: <20170606121331.GV1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request introduces the V4L2 fwnode framework which has equivalent
functionality to V4L2 OF framework. The V4L2 OF framework users are
converted to use the V4L2 fwnode framework and the redundant V4L2 OF
framework is removed.

since v2:

- Rebase (no conflicts) and convert the recently merged stm32-dcmi driver to
  V4L2 fwnode.

since v1:

- Merge patch to the series ("v4l: flash led class: Use fwnode_handle
  instead of device_node in init"):

  <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg113193.html>

Please pull.


The following changes since commit 1656df35d689ac6a93d7503725d9e62ce50c7f38:

  [media] em28xx: fix spelling mistake: "missdetected" -> "misdetected" (2017-06-06 08:13:41 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-acpi

for you to fetch changes up to e7e234464d82dc2d3f60a9cb4ccf45c8f965dd51:

  v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework (2017-06-06 15:08:34 +0300)

----------------------------------------------------------------
Sakari Ailus (7):
      v4l: fwnode: Support generic fwnode for parsing standardised properties
      v4l: async: Add fwnode match support
      v4l: flash led class: Use fwnode_handle instead of device_node in init
      v4l: Switch from V4L2 OF not V4L2 fwnode API
      docs-rst: media: Sort topic list alphabetically
      docs-rst: media: Switch documentation to V4L2 fwnode API
      v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework

 Documentation/media/kapi/v4l2-core.rst         |  20 +-
 Documentation/media/kapi/v4l2-fwnode.rst       |   3 +
 Documentation/media/kapi/v4l2-of.rst           |   3 -
 drivers/leds/leds-aat1290.c                    |   5 +-
 drivers/leds/leds-max77693.c                   |   5 +-
 drivers/media/i2c/Kconfig                      |  11 +
 drivers/media/i2c/adv7604.c                    |   7 +-
 drivers/media/i2c/mt9v032.c                    |   7 +-
 drivers/media/i2c/ov2659.c                     |   8 +-
 drivers/media/i2c/ov5645.c                     |   7 +-
 drivers/media/i2c/ov5647.c                     |   7 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |   7 +-
 drivers/media/i2c/s5k5baf.c                    |   6 +-
 drivers/media/i2c/smiapp/Kconfig               |   1 +
 drivers/media/i2c/smiapp/smiapp-core.c         |  29 ++-
 drivers/media/i2c/tc358743.c                   |  11 +-
 drivers/media/i2c/tvp514x.c                    |   6 +-
 drivers/media/i2c/tvp5150.c                    |   7 +-
 drivers/media/i2c/tvp7002.c                    |   6 +-
 drivers/media/platform/Kconfig                 |   4 +
 drivers/media/platform/am437x/Kconfig          |   1 +
 drivers/media/platform/am437x/am437x-vpfe.c    |  15 +-
 drivers/media/platform/atmel/Kconfig           |   2 +
 drivers/media/platform/atmel/atmel-isc.c       |  13 +-
 drivers/media/platform/atmel/atmel-isi.c       |  11 +-
 drivers/media/platform/exynos4-is/Kconfig      |   2 +
 drivers/media/platform/exynos4-is/media-dev.c  |  13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c  |   6 +-
 drivers/media/platform/omap3isp/isp.c          |  49 ++--
 drivers/media/platform/pxa_camera.c            |  11 +-
 drivers/media/platform/rcar-vin/Kconfig        |   1 +
 drivers/media/platform/rcar-vin/rcar-core.c    |  19 +-
 drivers/media/platform/soc_camera/soc_camera.c |   7 +-
 drivers/media/platform/stm32/stm32-dcmi.c      |  13 +-
 drivers/media/platform/ti-vpe/cal.c            |  15 +-
 drivers/media/platform/xilinx/Kconfig          |   1 +
 drivers/media/platform/xilinx/xilinx-vipp.c    |  63 +++--
 drivers/media/v4l2-core/Kconfig                |   3 +
 drivers/media/v4l2-core/Makefile               |   4 +-
 drivers/media/v4l2-core/v4l2-async.c           |  21 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c |  12 +-
 drivers/media/v4l2-core/v4l2-fwnode.c          | 345 +++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-of.c              | 327 -----------------------
 include/media/v4l2-async.h                     |   8 +-
 include/media/v4l2-flash-led-class.h           |   6 +-
 include/media/{v4l2-of.h => v4l2-fwnode.h}     |  96 +++----
 include/media/v4l2-subdev.h                    |   5 +-
 47 files changed, 643 insertions(+), 586 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
 delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
 rename include/media/{v4l2-of.h => v4l2-fwnode.h} (50%)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
