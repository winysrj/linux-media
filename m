Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49414 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbcKBN3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 00/32] rcar-vin: Add Gen3 with media controller support
Date: Wed,  2 Nov 2016 14:22:57 +0100
Message-Id: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This series enable Gen3 VIN support in rcar-vin driver for Renesas 
r8a7795 and r8a7796. It is based on top of v4.9-rc3.

Parts of this series was previously part of an different series from me 
which enabled Gen3 support in a different way (using s_input instead of 
a media controller) but after feedback during ELCE the Gen3 enablement 
is now almost completely rewritten.

 Patch 1-2: pick-up media entity features from Laurent which the driver 
 depends on.

 Patch 3-5: fix small issues in the driver.

 Patch 6-13: changes the driver from attaching to a video source 
 subdevice at probe time to when the video device node (/dev/videoX) are 
 opened. It also allows for the subdevice which is attached is not the 
 same as last time it was opened, but only at the time the first user 
 opens, i.e. when v4l2_fh_is_singular_file() is true.

 Patch 14-15: prepare the internal data structures for Gen3.

 Patch 16-17: small refactoring preparing for Gen3 additions.

 Patch 18-19: add logic to work with the Gen3 hardware registers

 Patch 20-24: add media control support, link setup and link notify 
 handlers.

 Patch 25-29: add logic to the driver to work together with the media 
 controller.

 Patch 30-32: document the new Gen3 DT bindings, add r8a7795 and r8a7796 
 definitions and device info structures.

The driver is tested on both Renesas H3 (r8a7795) and M3-W (r8a7796) 
together with the new rcar-csi2 driver (posted separately) and a 
prototype driver of the ADV7482 (not ready for upstream but publicly 
available). It is possible to capture both CVBS and HDMI video streams, 
v4l2-compliance passes with no errors (there is one warning due the 
ADV7482 driver) and media-ctl can be used to change the routing from the 
different CSI-2 sources to the different VIN consumers.

Gen2 compatibility is verified on Koelsch and no problems where found, 
video can be captured just like before and v4l2-compliance passes 
without errors or warnings.

Laurent Pinchart (2):
  media: entity: Add has_route entity operation
  media: entity: Add media_entity_has_route() function

Niklas Söderlund (30):
  media: rcar-vin: reset bytesperline and sizeimage when resetting
    format
  media: rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
  media: rcar-vin: fix how pads are handled for v4l2 subdeivce
    operations
  media: rcar-vin: fix standard in input enumeration
  media: rcar-vin: add wrapper to get rvin_graph_entity
  media: rcar-vin: move subdev source and sink pad index to
    rvin_graph_entity
  media: rcar-vin: move pad number discovery to async complete handler
  media: rcar-vin: use pad information when verifying media bus format
  media: rcar-vin: refactor pad lookup code
  media: rcar-vin: split rvin_s_fmt_vid_cap()
  media: rcar-vin: register the video device early
  media: rcar-vin: move chip information to own struct
  media: rcar-vin: move max width and height information to chip
    information
  media: rcar-vin: change name of video device
  media: rcar-vin: clarify error message from the digital notifier
  media: rcar-vin: enable Gen3 hardware configuration
  media: rcar-vin: add functions to manipulate Gen3 CHSEL value
  media: rcar-vin: expose a sink pad if we are on Gen3
  media: rcar-vin: add group allocator functions
  media: rcar-vin: add chsel information to rvin_info
  media: rcar-vin: parse Gen3 OF and setup media graph
  media: rcar-vin: add link notify for Gen3
  media: rcar-vin: enable CSI2 group subdevices in lookup helpers
  media: rcar-vin: add helpers for bridge
  media: rcar-vin: start/stop the CSI2 bridge stream
  media: rcar-vin: propagate format to bridge
  media: rcar-vin: attach to CSI2 group when the video device is opened
  media: rcar-vin: add Gen3 devicetree bindings documentation
  media: rcar-vin: enable support for r8a7795
  media: rcar-vin: enable support for r8a7796

 .../devicetree/bindings/media/rcar_vin.txt         |  117 +-
 drivers/media/media-entity.c                       |   29 +
 drivers/media/platform/rcar-vin/Kconfig            |    2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 1134 +++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-dma.c         |  240 ++++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  394 ++++---
 drivers/media/platform/rcar-vin/rcar-vin.h         |  112 +-
 include/media/media-entity.h                       |    8 +
 8 files changed, 1790 insertions(+), 246 deletions(-)

-- 
2.10.2

