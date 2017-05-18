Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58338 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933664AbdERLfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 07:35:02 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1982B6009C
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 14:34:52 +0300 (EEST)
Date: Thu, 18 May 2017 14:34:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] V4L2 fwnode support
Message-ID: <20170518113420.GU3227@valkosipuli.retiisi.org.uk>
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

Please pull.

The following changes since commit f2c61f98e0b5f8b53b8fb860e5dcdd661bde7d0b:

  [media] tc358743: fix register i2c_rd/wr function fix (2017-05-18 08:00:56 -0300)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git v4l2-acpi

for you to fetch changes up to e8519dce8869d48d9e935e1f6da82bc67899c9f5:

  v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework (2017-05-18 14:18:33 +0300)

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
 drivers/media/platform/Kconfig                 |   3 +
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
 include/media/v4l2-flash-led-class.h           |   4 +-
 include/media/{v4l2-of.h => v4l2-fwnode.h}     |  96 +++----
 include/media/v4l2-subdev.h                    |   5 +-
 46 files changed, 634 insertions(+), 579 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
 delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
 rename include/media/{v4l2-of.h => v4l2-fwnode.h} (50%)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
