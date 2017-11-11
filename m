Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47582 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbdKKAjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:02 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 00/25] rcar-vin: Add Gen3 with media controller
Date: Sat, 11 Nov 2017 01:38:10 +0100
Message-Id: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds Gen3 VIN support to rcar-vin driver for Renesas r8a7795
and r8a7796. It is based on the media-tree.

The driver is tested on both Renesas H3 (r8a7795, ES2.0) and
M3-W (r8a7796) together with the rcar-csi2 driver (posted separately and
not yet upstream) and the Salvator-X onboard ADV7482.

It is possible to capture both CVBS and HDMI video streams,
v4l2-compliance passes with no errors and media-ctl can be used to
change the routing and formats for the different entities in the media
graph.

Gen2 compatibility is verified on Koelsch and no problems where found, 
video can be captured just like before and v4l2-compliance passes 
without errors or warnings just like before this series.

I have started on a very basic test suite for the VIN driver at:

  https://git.ragnatech.se/vin-tests

And as before the state of the driver and information about how to test 
it can be found on the elinux wiki:

  http://elinux.org/R-Car/Tests:rcar-vin

* Changes since v6
- Rebase ontop of latest media-tree which brings in the use of the 
  fwnode async helpers for Gen2.
- Updated DT binding documentation, thanks Laurent for very helpful 
  input!
- Removed help text which where copied in from v4l2_ctrl_handler_init() 
  documentation when moving that code block, this was a residue from the 
  soc_camera conversion and should have been removed at that time.
- Removed bad check of tvnorms which disables IOCTLs if it's not set, 
  this was a residue from soc_camera conversion and have use in the 
  current driver.
- Moved all subdevice initialization from complete to bound handler 
  while improving the unbind handler. With this move all operations of 
  the ctrl_handler from the subdevice is handled in either bound or 
  unbind removing races pointed out by Laurent.
- Renamed rvin_v4l2_probe() -> rvin_v4l2_register() and 
  rvin_v4l2_remove() -> rvin_v4l2_unregister().
- Fold rvin_mbus_supported() into its only caller.
- Sort compatible string entries in ascending order.
- Improved documentation for struct rvin_group_chsel.
- Clarify comment in rvin_group_csi_pad_to_chan().
- Make use of of_device_get_match_data() as suggested by Geert.
- Fixed spelling mistakes.
- Added review tags from Hans.

* Changes since v5
- Extract and make use of common format checking for both Gen2 and Gen3.
- Assign pad at declaration time in rvin_get_sd_format()
- Always call pm_runtime_{get_sync,put}() and v4l2_pipeline_pm_use()
  when opening/closing a video device, remove the check of
  v4l2_fh_is_singular_file().
- Make rvin_set_chsel() return void instead of int since it always
  return 0.
- Simplify the VIN group allocator functions.
- Make the group notifier callbacks and setup more robust.
- Moved the video device registration back to probe time.
- Add H3 ES2.0 support.
- Fix handling of single field formats (top, bottom, alternate) as this
  was obviously wrong before but hidden by the Gen2 scaler support.
- Added review tags from Kieran.

* Changes since v4 (Not posted to ML)
- Updated to the new fwnode functions.
- Moved the registration of the video devices to the async notification
  callback.

* Changes since v3
- Only add neighboring subdevices to the async notifier. Instead of
  parsing the whole OF graph depend on incremental async subnotifier to
  discover the whole pipeline. This is needed to support arbitrarily
  long graphs and support the new ADV7482 prototype driver which Kieran
  is working on.
- Fix warning from lockdep, reported by Kieran.
- Fix commit messages from feedback from Sergei, thanks.
- Fix chip info an OF device ids sorting order, thanks Geert.
- Use subdev->of_node instead of subdev->dev->of_node, thanks Kieran.

* Changes since v2
- Do not try to control the subdevices in the media graph from the rcar-vin
  driver. Have user-space configure to format in the pipeline instead.
- Add link validation before starting the stream.
- Rework on how the subdevices are and the video node behave by defining
  specific V4L2 operations for the MC mode of operation, this simplified 
  the driver quit a bit, thanks Laurent!
- Add a new 'renesas,id' DT property which is needed to to be able to 
  keep the VIN to CSI-2 routing table inside the driver. Previously this 
  information was taken from the CSI-2 DT node which is obviously the 
  wrong way to do things. Thanks Laurent for pointing this out.
- Fixed a memory leek in the group allocator function.
- Return -EMLINK instead of -EBUSY if a MC link is not possible given 
  the current routing setup.
- Add comments to clarify that the 4 channels from the CSI-2 node is not 
  directly related to CSI-2 virtual channels, the CSI-2 node can output 
  any VC on any of its output channels.

* Changes since v1
- Remove unneeded casts as pointed out by Geert.
- Fix spelling and DT documentation as pointed out by Geert and Sergei, 
  thanks!
- Refresh patch 2/32 with an updated version, thanks Sakari for pointing 
  this out.
- Add Sakaris Ack to patch 1/32.
- Rebase on top of v4.9-rc1 instead of v4.9-rc3 to ease integration 
  testing together with renesas-drivers tree.


Niklas Söderlund (25):
  rcar-vin: add Gen3 devicetree bindings documentation
  rcar-vin: register the video device at probe time
  rcar-vin: move chip information to own struct
  rcar-vin: move max width and height information to chip information
  rcar-vin: change name of video device
  rcar-vin: move functions regarding scaling
  rcar-vin: all Gen2 boards can scale simplify logic
  rcar-vin: do not reset crop and compose when setting format
  rcar-vin: do not allow changing scaling and composing while streaming
  rcar-vin: read subdevice format for crop only when needed
  rcar-vin: fix handling of single field frames (top, bottom and
    alternate fields)
  rcar-vin: move media bus configuration to struct rvin_info
  rcar-vin: enable Gen3 hardware configuration
  rcar-vin: add function to manipulate Gen3 CHSEL value
  rcar-vin: add flag to switch to media controller mode
  rcar-vin: break out format alignment and checking
  rcar-vin: use different v4l2 operations in media controller mode
  rcar-vin: prepare for media controller mode initialization
  rcar-vin: add group allocator functions
  rcar-vin: add chsel information to rvin_info
  rcar-vin: parse Gen3 OF and setup media graph
  rcar-vin: add link notify for Gen3
  rcar-vin: extend {start,stop}_streaming to work with media controller
  rcar-vin: enable support for r8a7795
  rcar-vin: enable support for r8a7796

 .../devicetree/bindings/media/rcar_vin.txt         |  117 ++-
 drivers/media/platform/rcar-vin/Kconfig            |    2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 1109 +++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-dma.c         |  985 +++++++++--------
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  446 ++++----
 drivers/media/platform/rcar-vin/rcar-vin.h         |  125 ++-
 6 files changed, 2090 insertions(+), 694 deletions(-)

-- 
2.15.0
