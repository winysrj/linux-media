Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56290 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388058AbeGWOs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 00/21] V4L2 fwnode rework; support for default configuration
Date: Mon, 23 Jul 2018 16:46:45 +0300
Message-Id: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I've long thought the V4L2 fwnode framework requires some work (it's buggy
and it does not adequately serve common needs). This set should address in
particular these matters:

- Most devices support a particular media bus type but the V4L2 fwnode
  framework was not able to use such information, but instead tried to
  guess the bus type with varying levels of success while drivers
  generally ignored the results. This patchset makes that possible ---
  setting a bus type enables parsing configuration for only that bus.
  Failing that check results in returning -ENXIO to be returned.

- Support specifying default configuration. If the endpoint has no
  configuration, the defaults set by the driver (as documented in DT
  bindings) will prevail. Any available configuration will still be read
  from the endpoint as one could expect. A common use case for this is
  e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
  default 1:1 mapping is provided in absence of a valid default or
  configuration read OF.

- Debugging information is greatly improved.

- Recognition of the differences between CSI-2 D-PHY and C-PHY. All
  currently supported hardware (or at least drivers) is D-PHY only, so
  this change is still easy.

The smiapp driver is converted to use the new functionality. This patchset
does not address remaining issues such as supporting setting defaults for
e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
patchset we're much closer with that goal. I've rebased this set on top of
Steve's. Albeit the two deal with the same files, there were only a few
trivial conflicts.

Note that I've only tested parsing endpoints for the CSI-2 bus (no
parallel IF hardware). Testing in general would be beneficial: the code
flows are rather convoluted and different hardware tends to excercise
different flows while the use of the use of defaults has a similar
effect.

Comments are welcome.

I've pushed the patches (including Steve's) here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode>

Sakari Ailus (21):
  v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
  v4l: fwnode: Use fwnode_graph_for_each_endpoint
  v4l: fwnode: Detect bus type correctly
  v4l: fwnode: The CSI-2 clock is continuous if it's not non-continuous
  dt-bindings: media: Specify bus type for MIPI D-PHY, others,
    explicitly
  v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656
    busses
  v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
  v4l: fwnode: Make use of newly specified bus types
  v4l: fwnode: Read lane inversion information despite lane numbering
  v4l: fwnode: Only assign configuration if there is no error
  v4l: fwnode: Support driver-defined lane mapping defaults
  v4l: fwnode: Support default CSI-2 lane mapping for drivers
  v4l: fwnode: Parse the graph endpoint as last
  v4l: fwnode: Use default parallel flags
  v4l: fwnode: Allow setting default parameters
  v4l: fwnode: Use media bus type for bus parser selection
  v4l: fwnode: Print bus type
  v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
  v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
  v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
  smiapp: Query the V4L2 endpoint for a specific bus type

 .../devicetree/bindings/media/video-interfaces.txt |   4 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |   2 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/ov2659.c                         |  14 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/i2c/ov5645.c                         |   2 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   2 +-
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  34 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   2 +-
 drivers/media/i2c/tc358743.c                       |  28 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   2 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |   2 +-
 drivers/media/platform/cadence/cdns-csi2tx.c       |   2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   4 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
 drivers/media/platform/omap3isp/isp.c              |   2 +-
 drivers/media/platform/pxa_camera.c                |   2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   2 +-
 drivers/media/platform/ti-vpe/cal.c                |   2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              | 510 ++++++++++++++++-----
 drivers/staging/media/imx/imx-media-csi.c          |   2 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c         |   2 +-
 drivers/staging/media/imx074/imx074.c              |   2 +-
 include/media/v4l2-fwnode.h                        |  33 +-
 include/media/v4l2-mediabus.h                      |   8 +-
 30 files changed, 505 insertions(+), 180 deletions(-)

-- 
2.11.0
