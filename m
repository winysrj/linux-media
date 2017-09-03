Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49376 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753061AbdICRuC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 13:50:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v7 00/18] Unified fwnode endpoint parser, async sub-device notifier support, N9 flash DTS
Date: Sun,  3 Sep 2017 20:49:40 +0300
Message-Id: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

We have a large influx of new, unmerged, drivers that are now parsing
fwnode endpoints and each one of them is doing this a little bit
differently. The needs are still exactly the same for the graph data
structure is device independent. This is still a non-trivial task and the
majority of the driver implementations are buggy, just buggy in different
ways.

Facilitate parsing endpoints by adding a convenience function for parsing
the endpoints, and make the omap3isp and rcar-vin drivers use them as an
example.

To show where we're getting with this, I've added support for async
sub-device notifier support that is notifiers that can be registered by
sub-device drivers as well as V4L2 fwnode improvements to make use of them
and the DTS changes for the Nokia N9. Some of these patches I've posted
previously in this set here:

<URL:http://www.spinics.net/lists/linux-media/msg118764.html>

Since that, the complete callback of the master notifier registering the
V4L2 device is only called once all sub-notifiers have been completed as
well. This way the device node creation can be postponed until all devices
have been successfully initialised.

With this, the as3645a driver successfully registers a sub-device to the
media device created by the omap3isp driver. The kernel also has the
information it's related to the sensor driven by the smiapp driver but we
don't have a way to expose that information yet.

since v6:

- Drop the last patch that added variant for parsing endpoints given
  specific port and endpoints numbers.

- Separate driver changes from the fwnode endpoint parser patch into two
  patches. rcar-vin driver is now using the name function.

- Use -ENOTCONN to tell the parser that and endpoint (or a reference) is
  to be ignored.

- parse_endpoint and parse_single callback functions are now optional and
  documented as such.

- Added Laurent's patch adding notifier operations struct which I rebase
  on the fwnode parser patchset. I wrote another patch to call the
  notifier operations through macros.

- Add DT bindings for flash and lens devices.

- V4L2 fwnode parser for references (such as flash and lens).

- Added smiapp driver support for async sub-devices (lens and flash).

- Added a few fixes for omap3isp.

since v5:

- Use v4l2_async_ prefix for static functions as well (4th patch)

- Use memcpy() to copy array rather than a loop

- Document that the v4l2_async_subdev pointer in driver specific struct
  must be the first member

- Improve documentation of the added functions (4th and 5th
  patches)

	- Arguments

	- More thorough explation of the purpose, usage and object
	  lifetime

- Added acks

since v4:

- Prepend the set with three documentation fixes.

- The driver's async struct must begin with struct v4l2_async_subdev. Fix this
  for omap3isp and document it.

- Improve documentation for new functions.

- Don't use devm_ family of functions for allocating memory. Introduce
  v4l2_async_notifier_release() to release memory resources.

- Rework both v4l2_async_notifier_fwnode_parse_endpoints() and
  v4l2_async_notifier_fwnode_parse_endpoint() and the local functions they
  call. This should make the code cleaner. Despite the name, for linking
  and typical usage reasons the functions remain in v4l2-fwnode.c.

- Convert rcar-vin to use v4l2_async_notifier_fwnode_parse_endpoint().

- Use kvmalloc() for allocating the notifier's subdevs array.

- max_subdevs argument for notifier_realloc is now the total maximum
  number of subdevs, not the number of available subdevs.

- Use fwnode_device_is_available() to make sure the device actually
  exists.

- Move the note telling v4l2_async_notifier_fwnode_parse_endpoints()
  should not be used by new drivers to the last patch adding
  v4l2_async_notifier_fwnode_parse_endpoint().

since v3:

- Rebase on current mediatree master.

since v2:

- Rebase on CCP2 support patches.

- Prepend a patch cleaning up omap3isp driver a little.

since v1:

- The first patch has been merged (it was a bugfix).

- In anticipation that the parsing can take place over several iterations,
  take the existing number of async sub-devices into account when
  re-allocating an array of async sub-devices.

- Rework the first patch to better anticipate parsing single endpoint at a
  time by a driver.

- Add a second patch that adds a function for parsing endpoints one at a
  time based on port and endpoint numbers.

Laurent Pinchart (1):
  v4l: async: Move async subdev notifier operations to a separate
    structure

Sakari Ailus (17):
  v4l: fwnode: Move KernelDoc documentation to the header
  v4l: async: Add V4L2 async documentation to the documentation build
  docs-rst: v4l: Include Qualcomm CAMSS in documentation build
  v4l: fwnode: Support generic parsing of graph endpoints in a device
  omap3isp: Use generic parser for parsing fwnode endpoints
  rcar-vin: Use generic parser for parsing fwnode endpoints
  omap3isp: Fix check for our own sub-devices
  omap3isp: Print the name of the entity where no source pads could be
    found
  v4l: async: Introduce macros for calling async ops callbacks
  v4l: async: Register sub-devices before calling bound callback
  v4l: async: Allow binding notifiers to sub-devices
  dt: bindings: Add a binding for flash devices associated to a sensor
  dt: bindings: Add lens-focus binding for image sensors
  v4l2-fwnode: Add convenience function for parsing generic references
  v4l2-fwnode: Add convenience function for parsing common external refs
  smiapp: Add support for flash and lens devices
  arm: dts: omap3: N9/N950: Add flash references to the camera

 .../devicetree/bindings/media/video-interfaces.txt |  10 +
 Documentation/media/kapi/v4l2-async.rst            |   3 +
 Documentation/media/kapi/v4l2-core.rst             |   1 +
 Documentation/media/v4l-drivers/index.rst          |   1 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |   4 +-
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/media/i2c/smiapp/smiapp-core.c             |  29 +-
 drivers/media/i2c/smiapp/smiapp.h                  |   4 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   8 +-
 drivers/media/platform/atmel/atmel-isc.c           |  10 +-
 drivers/media/platform/atmel/atmel-isi.c           |  10 +-
 drivers/media/platform/davinci/vpif_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif_display.c      |   8 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/omap3isp/isp.c              | 127 +++-----
 drivers/media/platform/omap3isp/isp.h              |   5 +-
 drivers/media/platform/pxa_camera.c                |   8 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |   8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 122 +++-----
 drivers/media/platform/rcar-vin/rcar-dma.c         |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  14 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   4 +-
 drivers/media/platform/rcar_drif.c                 |  10 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  14 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  10 +-
 drivers/media/platform/ti-vpe/cal.c                |   8 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   8 +-
 drivers/media/v4l2-core/v4l2-async.c               | 184 +++++++++---
 drivers/media/v4l2-core/v4l2-fwnode.c              | 319 ++++++++++++++++-----
 drivers/staging/media/imx/imx-media-dev.c          |   8 +-
 include/media/v4l2-async.h                         |  78 ++++-
 include/media/v4l2-fwnode.h                        | 165 ++++++++++-
 33 files changed, 862 insertions(+), 346 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst

-- 
2.11.0
