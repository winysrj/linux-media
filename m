Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36812 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932798AbeGIWja (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:30 -0400
Received: by mail-pf0-f195.google.com with SMTP id u16-v6so14646135pfh.3
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2018 15:39:30 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 00/17] media: imx: Switch to subdev notifiers
Date: Mon,  9 Jul 2018 15:39:00 -0700
Message-Id: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset converts the imx-media driver and its dependent
subdevs to use subdev notifiers.

There are a couple shortcomings in v4l2-core that prevented
subdev notifiers from working correctly in imx-media:

1. v4l2_async_notifier_fwnode_parse_endpoint() treats a fwnode
   endpoint that is not connected to a remote device as an error.
   But in the case of the video-mux subdev, this is not an error,
   it is OK if some of the mux inputs have no connection. Also,
   Documentation/devicetree/bindings/media/video-interfaces.txt explicitly
   states that the 'remote-endpoint' property is optional. So the first
   patch is a small modification to ignore empty endpoints in
   v4l2_async_notifier_fwnode_parse_endpoint() and allow
   __v4l2_async_notifier_parse_fwnode_endpoints() to continue to
   parse the remaining port endpoints of the device.

2. In the imx-media graph, multiple subdevs will encounter the same
   upstream subdev (such as the imx6-mipi-csi2 receiver), and so
   v4l2_async_notifier_parse_fwnode_endpoints() will add imx6-mipi-csi2
   multiple times. This is treated as an error by
   v4l2_async_notifier_register() later.

   To get around this problem, add an v4l2_async_notifier_add_subdev()
   which first verifies the provided asd does not already exist in the
   given notifier asd list or in other registered notifiers. If the asd
   exists, the function returns -EEXIST and it's up to the caller to
   decide if that is an error (in imx-media case it is never an error).

   Patches 2-5 deal with adding that support.

3. Patch 6 adds v4l2_async_register_fwnode_subdev(), which is a
   convenience function for parsing a subdev's fwnode port endpoints
   for connected remote subdevs, registering a subdev notifier, and
   then registering the sub-device itself.

4. Patches 7-14 update the subdev drivers to register a subdev notifier
   with endpoint parsing, and the changes to imx-media to support that.

5. Finally, the last 3 patches endeavor to completely remove support for
   the notifier->subdevs[] array in platform drivers and v4l2 core. All
   platform drivers are modified to make use of
   v4l2_async_notifier_add_subdev() and its related convenience functions
   to add asd's to the notifier @asd_list, and any allocation or reference
   to the notifier->subdevs[] array removed. After that large patch,
   notifier->subdevs[] array is stripped from v4l2-async and v4l2-subdev
   docs are updated to reflect the new method of adding asd's to notifiers.


Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Patches 07-14 (video-mux and the imx patches) are
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

Patches 01-14 are
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
on i.MX6 with Toshiba TC358743 connected via MIPI CSI-2.

History:

v6:
- Export v4l2_async_notifier_init(), which must be called by all
  drivers before the first call to v4l2_async_notifier_add_subdev().
  Suggested by Sakari Ailus.
- Removed @num_subdevs from struct v4l2_async_notifier, and the macro
  V4L2_MAX_SUBDEVS. Sugested by Sakari.
- Fixed a double device node put in vpif_capture.c. Reported by Sakari.
- Fixed wrong printk format qualifiers in xilinx-vipp.c. Reported by
  Dan Carpenter.

v5:
- see point 5 above.

v4:
- small non-functional code cleanup in video-mux.c.
- strip TODO for comparing custom asd's for equivalence.
- add three more convenience functions: v4l2_async_notifier_add_fwnode_subdev,
  v4l2_async_notifier_add_i2c_subdev, v4l2_async_notifier_add_devname_subdev.
- strip support in v4l2_async_register_fwnode_subdev for sub-devices
  that register from port nodes.

v3:
- code optimization in asd_equal(), and remove unneeded braces,
  suggested by Sakari Ailus.
- add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
- fix an error-out path in v4l2_async_register_fwnode_subdev() that
  forgot to put device.

v2:
- don't pass an empty endpoint to the parse_endpoint callback, 
  v4l2_async_notifier_fwnode_parse_endpoint() now just ignores them
  and returns success.
- Fix a couple compile warnings and errors seen in i386 and sh archs.


Steve Longerbeam (17):
  media: v4l2-fwnode: ignore endpoints that have no remote port parent
  media: v4l2: async: Allow searching for asd of any type
  media: v4l2: async: Add v4l2_async_notifier_add_subdev
  media: v4l2: async: Add convenience functions to allocate and add
    asd's
  media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
  media: v4l2-fwnode: Add a convenience function for registering subdevs
    with notifiers
  media: platform: video-mux: Register a subdev notifier
  media: imx: csi: Register a subdev notifier
  media: imx: mipi csi-2: Register a subdev notifier
  media: staging/imx: of: Remove recursive graph walk
  media: staging/imx: Loop through all registered subdevs for media
    links
  media: staging/imx: Rename root notifier
  media: staging/imx: Switch to v4l2_async_notifier_add_*_subdev
  media: staging/imx: TODO: Remove one assumption about OF graph parsing
  media: platform: Switch to v4l2_async_notifier_add_subdev
  media: v4l2: async: Remove notifier subdevs array
  [media] v4l2-subdev.rst: Update doc regarding subdev descriptors

 Documentation/media/kapi/v4l2-subdev.rst          |  30 ++-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c          |  14 +-
 drivers/media/platform/Kconfig                    |   1 +
 drivers/media/platform/am437x/am437x-vpfe.c       |  82 +++----
 drivers/media/platform/atmel/atmel-isc.c          |  15 +-
 drivers/media/platform/atmel/atmel-isi.c          |  17 +-
 drivers/media/platform/cadence/cdns-csi2rx.c      |  28 ++-
 drivers/media/platform/davinci/vpif_capture.c     |  71 +++---
 drivers/media/platform/davinci/vpif_display.c     |  25 +-
 drivers/media/platform/exynos4-is/media-dev.c     |  32 ++-
 drivers/media/platform/exynos4-is/media-dev.h     |   1 -
 drivers/media/platform/omap3isp/isp.c             |   1 +
 drivers/media/platform/pxa_camera.c               |  25 +-
 drivers/media/platform/qcom/camss-8x16/camss.c    |  86 ++++---
 drivers/media/platform/qcom/camss-8x16/camss.h    |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c       |   6 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c       |  22 +-
 drivers/media/platform/rcar_drif.c                |  18 +-
 drivers/media/platform/renesas-ceu.c              |  53 +++--
 drivers/media/platform/soc_camera/soc_camera.c    |  35 ++-
 drivers/media/platform/stm32/stm32-dcmi.c         |  24 +-
 drivers/media/platform/ti-vpe/cal.c               |  48 +++-
 drivers/media/platform/video-mux.c                |  36 ++-
 drivers/media/platform/xilinx/xilinx-vipp.c       | 173 +++++++-------
 drivers/media/platform/xilinx/xilinx-vipp.h       |   4 -
 drivers/media/v4l2-core/v4l2-async.c              | 264 ++++++++++++++++------
 drivers/media/v4l2-core/v4l2-fwnode.c             | 198 ++++++++--------
 drivers/staging/media/imx/TODO                    |  29 +--
 drivers/staging/media/imx/imx-media-csi.c         |  57 ++++-
 drivers/staging/media/imx/imx-media-dev.c         | 145 ++++--------
 drivers/staging/media/imx/imx-media-internal-sd.c |   5 +-
 drivers/staging/media/imx/imx-media-of.c          | 106 +--------
 drivers/staging/media/imx/imx-media.h             |   6 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c        |  31 ++-
 include/media/v4l2-async.h                        | 101 ++++++++-
 include/media/v4l2-fwnode.h                       |  52 ++++-
 36 files changed, 1041 insertions(+), 802 deletions(-)

-- 
2.7.4
