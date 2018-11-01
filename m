Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:28983 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbeKBIhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 04:37:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 00/30] v4l: add support for multiplexed streams
Date: Fri,  2 Nov 2018 00:31:14 +0100
Message-Id: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This series adds support for multiplexed streams within a media device
link. The use-case addressed in this series covers CSI-2 Virtual
Channels on the Renesas R-Car Gen3 platforms. The v4l2 changes have been
a joint effort between Sakari and Laurent and floating around for some
time [1].

I have added driver support for the devices used on the Renesas Gen3
platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
changes I can control which of the analog inputs of the ADV7482 the
video source is captured from and on which CSI-2 virtual channel the
video is transmitted on to the R-Car CSI-2 receiver.

The series adds two new subdev IOCTLs [GS]_ROUTING which allows
user-space to get and set routes inside a subdevice. I have added RFC
support for these to v4l-utils [2] which can be used to test this
series, example:

    Check the internal routing of the adv748x csi-2 transmitter:
    v4l2-ctl -d /dev/v4l-subdev24 --get-routing
    0/0 -> 1/0 [ENABLED]
    0/0 -> 1/1 []
    0/0 -> 1/2 []
    0/0 -> 1/3 []


    Select that video should be outputed on VC 2 and check the result:
    $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'

    $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
    0/0 -> 1/0 []
    0/0 -> 1/1 []
    0/0 -> 1/2 [ENABLED]
    0/0 -> 1/3 []

This series is tested on R-Car M3-N and for your testing needs this
series is available at

    git://git.ragnatech.se/linux v4l2/mux

* Changes since v1
- Rebased on latest media-tree.
- Incorporated changes to patch 'v4l: subdev: compat: Implement handling 
  for VIDIOC_SUBDEV_[GS]_ROUTING' by Sakari.
- Added review tags.

Thanks.

1. git://linuxtv.org/sailus/media_tree.git vc
2. git://git.ragnatech.se/v4l-utils routing

Laurent Pinchart (4):
  media: entity: Add has_route entity operation
  media: entity: Add media_has_route() function
  media: entity: Use routing information during graph traversal
  v4l: subdev: Add [GS]_ROUTING subdev ioctls and operations

Niklas Söderlund (7):
  adv748x: csi2: add translation from pixelcode to CSI-2 datatype
  adv748x: csi2: only allow formats on sink pads
  adv748x: csi2: describe the multiplexed stream
  adv748x: csi2: add internal routing configuration
  adv748x: afe: add routing support
  rcar-csi2: use frame description information to configure CSI-2 bus
  rcar-csi2: expose the subdevice internal routing

Sakari Ailus (19):
  media: entity: Use pad as a starting point for graph walk
  media: entity: Use pads instead of entities in the media graph walk
    stack
  media: entity: Walk the graph based on pads
  v4l: mc: Start walk from a specific pad in use count calculation
  media: entity: Move the pipeline from entity to pads
  media: entity: Use pad as the starting point for a pipeline
  media: entity: Swap pads if route is checked from source to sink
  media: entity: Skip link validation for pads to which there is no
    route to
  media: entity: Add an iterator helper for connected pads
  media: entity: Add only connected pads to the pipeline
  media: entity: Add debug information in graph walk route check
  media: entity: Look for indirect routes
  v4l: subdev: compat: Implement handling for VIDIOC_SUBDEV_[GS]_ROUTING
  v4l: subdev: Take routing information into account in link validation
  v4l: subdev: Improve link format validation debug messages
  v4l: mc: Add an S_ROUTING helper function for power state changes
  v4l: Add bus type to frame descriptors
  v4l: Add CSI-2 bus configuration to frame descriptors
  v4l: Add stream to frame descriptor

 Documentation/media/kapi/mc-core.rst          |  15 +-
 drivers/media/i2c/adv748x/adv748x-afe.c       |  65 ++++
 drivers/media/i2c/adv748x/adv748x-csi2.c      | 124 +++++++-
 drivers/media/i2c/adv748x/adv748x.h           |   1 +
 drivers/media/media-entity.c                  | 252 ++++++++++------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |   6 +-
 .../media/platform/exynos4-is/fimc-capture.c  |   8 +-
 .../platform/exynos4-is/fimc-isp-video.c      |   8 +-
 drivers/media/platform/exynos4-is/fimc-isp.c  |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |  10 +-
 drivers/media/platform/exynos4-is/media-dev.c |  20 +-
 drivers/media/platform/omap3isp/isp.c         |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  25 +-
 drivers/media/platform/omap3isp/ispvideo.h    |   2 +-
 .../media/platform/qcom/camss/camss-video.c   |   6 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c   | 188 +++++++++---
 drivers/media/platform/rcar-vin/rcar-dma.c    |   8 +-
 .../media/platform/s3c-camif/camif-capture.c  |   6 +-
 drivers/media/platform/vimc/vimc-capture.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_video.c      |  18 +-
 drivers/media/platform/xilinx/xilinx-dma.c    |  20 +-
 drivers/media/platform/xilinx/xilinx-dma.h    |   2 +-
 drivers/media/usb/au0828/au0828-core.c        |   4 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  77 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c          |  20 +-
 drivers/media/v4l2-core/v4l2-mc.c             |  76 +++--
 drivers/media/v4l2-core/v4l2-subdev.c         | 285 ++++++++++++++++--
 .../staging/media/davinci_vpfe/vpfe_video.c   |  47 +--
 drivers/staging/media/imx/imx-media-utils.c   |   8 +-
 drivers/staging/media/omap4iss/iss.c          |   2 +-
 drivers/staging/media/omap4iss/iss_video.c    |  38 +--
 drivers/staging/media/omap4iss/iss_video.h    |   2 +-
 include/media/media-entity.h                  | 122 +++++---
 include/media/v4l2-mc.h                       |  22 ++
 include/media/v4l2-subdev.h                   |  34 +++
 include/uapi/linux/v4l2-subdev.h              |  40 +++
 36 files changed, 1241 insertions(+), 330 deletions(-)

-- 
2.19.1
