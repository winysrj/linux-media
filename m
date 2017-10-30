Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54122 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751532AbdJ3Nac (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 09:30:32 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id ED5DE600F3
        for <linux-media@vger.kernel.org>; Mon, 30 Oct 2017 15:30:30 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e9A98-0003uY-Fi
        for linux-media@vger.kernel.org; Mon, 30 Oct 2017 15:30:30 +0200
Date: Mon, 30 Oct 2017 15:30:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] V4L2 async and fwnode improvements; DT and ACPI
 lens and flash support
Message-ID: <20171030133030.nr4bhu7ylreanro2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset improves async and fwnode frameworks and moves a lot of the
job of parsing away from drivers to the framework. Also, DT and ACPI
receive lens and flash support plus a few drivers using them.

Some documentation and V4L2 async error handling fixes are included as
well in the beginning of the set.

Please pull.

The following changes since commit bbae615636155fa43a9b0fe0ea31c678984be864:

  media: staging: atomisp2: cleanup null check on memory allocation (2017-10-27 17:33:39 +0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fwnode-parse

for you to fetch changes up to 1768f93a54133949145c615a80eb9ae004f426be:

  arm: dts: omap3: N9/N950: Add flash references to the camera (2017-10-30 15:07:38 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: async: Move async subdev notifier operations to a separate structure

Niklas Söderlund (1):
      v4l: async: fix unbind error in v4l2_async_notifier_unregister()

Sakari Ailus (30):
      v4l: async: Remove re-probing support
      v4l: async: Don't set sd->dev NULL in v4l2_async_cleanup
      v4l: async: Fix notifier complete callback error handling
      v4l: async: Correctly serialise async sub-device unregistration
      v4l: async: Use more intuitive names for internal functions
      v4l: async: Add V4L2 async documentation to the documentation build
      v4l: fwnode: Support generic parsing of graph endpoints in a device
      omap3isp: Use generic parser for parsing fwnode endpoints
      rcar-vin: Use generic parser for parsing fwnode endpoints
      omap3isp: Fix check for our own sub-devices
      omap3isp: Print the name of the entity where no source pads could be found
      v4l: async: Introduce helpers for calling async ops callbacks
      v4l: async: Register sub-devices before calling bound callback
      v4l: async: Allow async notifier register call succeed with no subdevs
      v4l: async: Prepare for async sub-device notifiers
      v4l: async: Allow binding notifiers to sub-devices
      v4l: async: Ensure only unique fwnodes are registered to notifiers
      dt: bindings: Add a binding for flash LED devices associated to a sensor
      dt: bindings: Add lens-focus binding for image sensors
      v4l: fwnode: Move KernelDoc documentation to the header
      v4l: fwnode: Add a helper function for parsing generic references
      v4l: fwnode: Add a helper function to obtain device / integer references
      v4l: fwnode: Add convenience function for parsing common external refs
      v4l: fwnode: Add a convenience function for registering sensors
      dt: bindings: smiapp: Document lens-focus and flash-leds properties
      smiapp: Add support for flash and lens devices
      et8ek8: Add support for flash and lens devices
      ov5670: Add support for flash and lens devices
      ov13858: Add support for flash and lens devices
      arm: dts: omap3: N9/N950: Add flash references to the camera

 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   2 +
 .../devicetree/bindings/media/video-interfaces.txt |  10 +
 Documentation/media/kapi/v4l2-async.rst            |   3 +
 Documentation/media/kapi/v4l2-core.rst             |   1 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |   4 +-
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   2 +-
 drivers/media/i2c/ov13858.c                        |   2 +-
 drivers/media/i2c/ov5670.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   8 +-
 drivers/media/platform/atmel/atmel-isc.c           |  10 +-
 drivers/media/platform/atmel/atmel-isi.c           |  10 +-
 drivers/media/platform/davinci/vpif_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif_display.c      |   8 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/omap3isp/isp.c              | 133 ++--
 drivers/media/platform/omap3isp/isp.h              |   5 +-
 drivers/media/platform/pxa_camera.c                |   8 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |   8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 117 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c         |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  14 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   4 +-
 drivers/media/platform/rcar_drif.c                 |  10 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  14 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  10 +-
 drivers/media/platform/ti-vpe/cal.c                |   8 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   8 +-
 drivers/media/v4l2-core/v4l2-async.c               | 517 +++++++++++----
 drivers/media/v4l2-core/v4l2-fwnode.c              | 703 ++++++++++++++++++---
 drivers/staging/media/imx/imx-media-dev.c          |   8 +-
 include/media/v4l2-async.h                         |  91 ++-
 include/media/v4l2-fwnode.h                        | 220 ++++++-
 include/media/v4l2-subdev.h                        |   3 +
 36 files changed, 1548 insertions(+), 425 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
