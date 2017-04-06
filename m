Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49121 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757108AbdDFNNe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 09:13:34 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 0/9] V4L2 fwnode support
Date: Thu,  6 Apr 2017 16:12:02 +0300
Message-Id: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending, got one list address wrong. Apologies for the noise...)

Hello everyone, 

This patchset adds support for fwnode to V4L2. Besides OF, also ACPI based
systems can be supported this way. By using V4L2 fwnode, the individual 
drivers do not need to be aware of the underlying firmware implementation.
The patchset also removes specific V4L2 OF support and converts the 
affected drivers to use V4L2 fwnode.

The patchset depends on another patchset here:

<URL:http://www.spinics.net/lists/linux-acpi/msg72973.html>

v1 of the set can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg111073.html>

changes since v1:

- Use existing dev_fwnode() instead of device_fwnode_handle() added by the
  ACPI graph patchset,

- Fix too long line of ^'s in ReST documentation and

- Drop the patch rearranging the header files. It'd better go in
  separately, if at all.

Sakari Ailus (8):
  v4l: flash led class: Use fwnode_handle instead of device_node in init
  v4l: fwnode: Support generic fwnode for parsing standardised
    properties
  v4l: async: Add fwnode match support
  v4l: async: Provide interoperability between OF and fwnode matching
  v4l: Switch from V4L2 OF not V4L2 fwnode API
  v4l: media/drv-intf/soc_mediabus.h: include dependent header file
  docs-rst: media: Switch documentation to V4L2 fwnode API
  v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework

 Documentation/media/kapi/v4l2-core.rst         |   2 +-
 Documentation/media/kapi/v4l2-fwnode.rst       |   3 +
 Documentation/media/kapi/v4l2-of.rst           |   3 -
 drivers/leds/leds-aat1290.c                    |   5 +-
 drivers/leds/leds-max77693.c                   |   5 +-
 drivers/media/i2c/Kconfig                      |   9 +
 drivers/media/i2c/adv7604.c                    |   7 +-
 drivers/media/i2c/mt9v032.c                    |   7 +-
 drivers/media/i2c/ov2659.c                     |   8 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |   7 +-
 drivers/media/i2c/s5k5baf.c                    |   6 +-
 drivers/media/i2c/smiapp/Kconfig               |   1 +
 drivers/media/i2c/smiapp/smiapp-core.c         |  29 +-
 drivers/media/i2c/tc358743.c                   |  11 +-
 drivers/media/i2c/tvp514x.c                    |   6 +-
 drivers/media/i2c/tvp5150.c                    |   7 +-
 drivers/media/i2c/tvp7002.c                    |   6 +-
 drivers/media/platform/Kconfig                 |   3 +
 drivers/media/platform/am437x/Kconfig          |   1 +
 drivers/media/platform/am437x/am437x-vpfe.c    |   8 +-
 drivers/media/platform/atmel/Kconfig           |   1 +
 drivers/media/platform/atmel/atmel-isc.c       |   8 +-
 drivers/media/platform/exynos4-is/Kconfig      |   2 +
 drivers/media/platform/exynos4-is/media-dev.c  |   6 +-
 drivers/media/platform/exynos4-is/mipi-csis.c  |   6 +-
 drivers/media/platform/omap3isp/isp.c          |  71 ++---
 drivers/media/platform/pxa_camera.c            |   7 +-
 drivers/media/platform/rcar-vin/Kconfig        |   1 +
 drivers/media/platform/rcar-vin/rcar-core.c    |   6 +-
 drivers/media/platform/soc_camera/Kconfig      |   1 +
 drivers/media/platform/soc_camera/atmel-isi.c  |   7 +-
 drivers/media/platform/soc_camera/soc_camera.c |   3 +-
 drivers/media/platform/ti-vpe/cal.c            |  11 +-
 drivers/media/platform/xilinx/Kconfig          |   1 +
 drivers/media/platform/xilinx/xilinx-vipp.c    |  59 +++--
 drivers/media/v4l2-core/Kconfig                |   3 +
 drivers/media/v4l2-core/Makefile               |   4 +-
 drivers/media/v4l2-core/v4l2-async.c           |  36 ++-
 drivers/media/v4l2-core/v4l2-flash-led-class.c |  11 +-
 drivers/media/v4l2-core/v4l2-fwnode.c          | 353 +++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-of.c              | 327 -----------------------
 include/media/drv-intf/soc_mediabus.h          |   2 +
 include/media/v4l2-async.h                     |   7 +-
 include/media/v4l2-flash-led-class.h           |   4 +-
 include/media/v4l2-fwnode.h                    | 104 ++++++++
 include/media/v4l2-of.h                        | 128 ---------
 include/media/v4l2-subdev.h                    |   3 +
 47 files changed, 698 insertions(+), 608 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
 delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-fwnode.h
 delete mode 100644 include/media/v4l2-of.h

-- 
2.7.4
