Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:46864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753205AbdDJNED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 09:04:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 0/7] V4L2 fwnode support
Date: Mon, 10 Apr 2017 16:02:49 +0300
Message-Id: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

This patchset adds support for fwnode to V4L2. Besides OF, also ACPI based
systems can be supported this way. By using V4L2 fwnode, the individual
drivers do not need to be aware of the underlying firmware implementation.
The patchset also removes specific V4L2 OF support and converts the
affected drivers to use V4L2 fwnode.

The patchset depends on another patchset here:

<URL:http://www.spinics.net/lists/linux-acpi/msg72973.html> 

A git tree with the dependencies can be found here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge>

v1 of the set can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg111073.html> 

and v2 here:

<URL:http://www.spinics.net/lists/linux-media/msg114110.html>

changes since v2:

- Use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL().

- Alphabetically order the topics under V4L2 core kAPI documentation.

- Prefer "fwnode" variable name for struct fwnode_handle pointers instead
  of "fwn". Similarly, use "vep" for struct v4l2_fwnode_endpoint instead
  of "vfwn".

- Convert existing users of OF matching to fwnode matching.

- Remove OF matching support as well as compatibility between OF and
  fwnode matching.

- Use of_node_cmp() to determine whether two nodes match in case both of
  them are OF nodes. There is thus no functional difference between
  existing OF matching in v1.

- Continue to use struct device_node.full_name on fwnodes that are known
  to be OF nodes instead of omitting such debug information. Drivers that
  can actually use fwnode need a new interface to provide this in fwnode
  framework. This is out of scope of the patchset.

- Remove linux/of.h header inclusion in
  drivers/media/v4l2-core/v4l2-flash-led-class.c.

- Improved line wrapping primarily in
  drivers/media/v4l2-core/v4l2-fwnode.c.

- Rewrap KernelDoc documentation for V4L2 fwnode API up to 80 characters
  per line (new patch).

- Fix KernelDoc documentation, there were a few locations where the
  argument had been changed but the documentation was not updated
  accordingly. 

- Fix punctuation and wording in V4L2 fwnode documentation.

- Drop patch "v4l: media/drv-intf/soc_mediabus.h: include dependent header
  file". It is no longer needed.

- Fix obtaining port parent in v4l2_fwnode_parse_link() on ACPI.

- Include newly OF-supported atmel-isi to V4L2 OF -> fwnode conversion.

- Add that the v4l2-fwnode.c has origins in v4l2-of.c to the commit
  message and the file header.

changes since v1:

- Use existing dev_fwnode() instead of device_fwnode_handle() added by the
  ACPI graph patchset,

- Fix too long line of ^'s in ReST documentation and

- Drop the patch rearranging the header files. It'd better go in
  separately, if at all.

Sakari Ailus (7):
  v4l: fwnode: Support generic fwnode for parsing standardised
    properties
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
 drivers/media/i2c/Kconfig                      |   9 +
 drivers/media/i2c/adv7604.c                    |   7 +-
 drivers/media/i2c/mt9v032.c                    |   7 +-
 drivers/media/i2c/ov2659.c                     |   8 +-
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
 drivers/media/platform/atmel/Kconfig           |   1 +
 drivers/media/platform/atmel/atmel-isc.c       |  13 +-
 drivers/media/platform/exynos4-is/Kconfig      |   2 +
 drivers/media/platform/exynos4-is/media-dev.c  |  13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c  |   6 +-
 drivers/media/platform/omap3isp/isp.c          |  49 ++--
 drivers/media/platform/pxa_camera.c            |  11 +-
 drivers/media/platform/rcar-vin/Kconfig        |   1 +
 drivers/media/platform/rcar-vin/rcar-core.c    |  23 +-
 drivers/media/platform/soc_camera/Kconfig      |   1 +
 drivers/media/platform/soc_camera/atmel-isi.c  |   7 +-
 drivers/media/platform/soc_camera/soc_camera.c |   7 +-
 drivers/media/platform/ti-vpe/cal.c            |  15 +-
 drivers/media/platform/xilinx/Kconfig          |   1 +
 drivers/media/platform/xilinx/xilinx-vipp.c    |  63 +++--
 drivers/media/v4l2-core/Kconfig                |   3 +
 drivers/media/v4l2-core/Makefile               |   4 +-
 drivers/media/v4l2-core/v4l2-async.c           |  21 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c |  12 +-
 drivers/media/v4l2-core/v4l2-fwnode.c          | 342 +++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-of.c              | 327 -----------------------
 include/media/v4l2-async.h                     |   8 +-
 include/media/v4l2-flash-led-class.h           |   4 +-
 include/media/v4l2-fwnode.h                    | 104 ++++++++
 include/media/v4l2-of.h                        | 128 ---------
 include/media/v4l2-subdev.h                    |   3 +
 46 files changed, 690 insertions(+), 638 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
 delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-fwnode.h
 delete mode 100644 include/media/v4l2-of.h

-- 
2.7.4
