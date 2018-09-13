Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49988 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbeINBg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 21:36:26 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 48C08634C84
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 23:25:21 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g0YAz-0000QT-45
        for linux-media@vger.kernel.org; Thu, 13 Sep 2018 23:25:21 +0300
Date: Thu, 13 Sep 2018 23:25:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Big V4L2 fwnode patchset
Message-ID: <20180913202520.5hfiduswljlhmbhg@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set contains the big V4L2 fwnode framework rework, including mine and
Steve's patches. What is now possible includes tonnes of bugs fixed,
default V4L2 fwnode endpoint configuration as well as less manual DT
parsing in the i.MX driver.

This is also the first time I'm signing the tag for a pull request. I
wonder if verification works out...

Please pull.


The following changes since commit cc1e6315e83db0e517dd9279050b88adc83a7eba:

  media: replace strcpy() by strscpy() (2018-09-11 13:32:17 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/v4l2-fwnode-next-v3.1

for you to fetch changes up to 35b7344fc09c98c809da5b84c13d36f1e58ef095:

  smiapp: Query the V4L2 endpoint for a specific bus type (2018-09-13 13:01:46 +0300)

----------------------------------------------------------------
fwnode patches for 4.20

----------------------------------------------------------------
Sakari Ailus (23):
      v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
      v4l: fwnode: Use fwnode_graph_for_each_endpoint
      v4l: fwnode: The CSI-2 clock is continuous if it's not non-continuous
      dt-bindings: media: Specify bus type for MIPI D-PHY, others, explicitly
      v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656 busses
      v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
      v4l: fwnode: Let the caller provide V4L2 fwnode endpoint
      v4l: fwnode: Detect bus type correctly
      v4l: fwnode: Make use of newly specified bus types
      v4l: fwnode: Read lane inversion information despite lane numbering
      v4l: fwnode: Only assign configuration if there is no error
      v4l: fwnode: Support driver-defined lane mapping defaults
      v4l: fwnode: Support default CSI-2 lane mapping for drivers
      v4l: fwnode: Parse the graph endpoint as last
      v4l: fwnode: Use default parallel flags
      v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero
      v4l: fwnode: Only zero the struct if bus type is set to V4L2_MBUS_UNKNOWN
      v4l: fwnode: Use media bus type for bus parser selection
      v4l: fwnode: Print bus type
      v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
      v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
      v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
      smiapp: Query the V4L2 endpoint for a specific bus type

Steve Longerbeam (17):
      media: v4l2-fwnode: ignore endpoints that have no remote port parent
      media: v4l2: async: Allow searching for asd of any type
      media: v4l2: async: Add v4l2_async_notifier_add_subdev
      media: v4l2: async: Add convenience functions to allocate and add asd's
      media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
      media: v4l2-fwnode: Add a convenience function for registering subdevs with notifiers
      media: platform: video-mux: Register a subdev notifier
      media: imx: csi: Register a subdev notifier
      media: imx: mipi csi-2: Register a subdev notifier
      media: staging/imx: of: Remove recursive graph walk
      media: staging/imx: Loop through all registered subdevs for media links
      media: staging/imx: Rename root notifier
      media: staging/imx: Switch to v4l2_async_notifier_add_*_subdev
      media: staging/imx: TODO: Remove one assumption about OF graph parsing
      media: platform: Switch to v4l2_async_notifier_add_subdev
      media: v4l2: async: Remove notifier subdevs array
      v4l2-subdev.rst: Update doc regarding subdev descriptors

 .../devicetree/bindings/media/video-interfaces.txt |   4 +-
 Documentation/media/kapi/v4l2-subdev.rst           |  30 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |   6 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/mt9v032.c                        |   2 +-
 drivers/media/i2c/ov2659.c                         |  14 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/i2c/ov5645.c                         |   2 +-
 drivers/media/i2c/ov5647.c                         |   2 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
 drivers/media/i2c/s5k5baf.c                        |   6 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  34 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   2 +-
 drivers/media/i2c/tc358743.c                       |  28 +-
 drivers/media/i2c/tda1997x.c                       |   2 +-
 drivers/media/i2c/tvp514x.c                        |   2 +-
 drivers/media/i2c/tvp5150.c                        |   2 +-
 drivers/media/i2c/tvp7002.c                        |   2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  16 +-
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/am437x/am437x-vpfe.c        |  84 +--
 drivers/media/platform/atmel/atmel-isc.c           |  18 +-
 drivers/media/platform/atmel/atmel-isi.c           |  19 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |  32 +-
 drivers/media/platform/cadence/cdns-csi2tx.c       |   4 +-
 drivers/media/platform/davinci/vpif_capture.c      |  73 ++-
 drivers/media/platform/davinci/vpif_display.c      |  20 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  34 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   1 -
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   4 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
 drivers/media/platform/omap3isp/isp.c              |   3 +-
 drivers/media/platform/pxa_camera.c                |  29 +-
 drivers/media/platform/qcom/camss/camss.c          |  88 ++-
 drivers/media/platform/qcom/camss/camss.h          |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   6 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |  26 +-
 drivers/media/platform/rcar_drif.c                 |  18 +-
 drivers/media/platform/renesas-ceu.c               |  56 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  35 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  28 +-
 drivers/media/platform/ti-vpe/cal.c                |  50 +-
 drivers/media/platform/video-mux.c                 |  36 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        | 173 +++--
 drivers/media/platform/xilinx/xilinx-vipp.h        |   4 -
 drivers/media/v4l2-core/v4l2-async.c               | 264 ++++++--
 drivers/media/v4l2-core/v4l2-fwnode.c              | 701 ++++++++++++++-------
 drivers/staging/media/imx/TODO                     |  29 +-
 drivers/staging/media/imx/imx-media-csi.c          |  67 +-
 drivers/staging/media/imx/imx-media-dev.c          | 145 ++---
 drivers/staging/media/imx/imx-media-internal-sd.c  |   5 +-
 drivers/staging/media/imx/imx-media-of.c           | 106 +---
 drivers/staging/media/imx/imx-media.h              |   6 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  31 +-
 drivers/staging/media/imx074/imx074.c              |   2 +-
 include/media/v4l2-async.h                         | 101 ++-
 include/media/v4l2-fwnode.h                        | 112 +++-
 include/media/v4l2-mediabus.h                      |   8 +-
 64 files changed, 1578 insertions(+), 1023 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
