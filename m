Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:24076 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1163200AbeCBB6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:58:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 00/32] rcar-vin: Add Gen3 with media controller
Date: Fri,  2 Mar 2018 02:57:19 +0100
Message-Id: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds Gen3 VIN support to rcar-vin driver for Renesas r8a7795,
r8a7796 and r8a77970. It is based on the media-tree and depends on
Fabrizio Castro patches as they touches the order of the compatible
strings in the documentation to reduce merge conflicts. The dependencies
are included in this series.

The driver is tested on Renesas H3 (r8a7795, ES2.0),
M3-W (r8a7796) together with the rcar-csi2 driver (posted separately and
not yet upstream) and the Salvator-X onboard ADV7482. It is also tested
on the V3M (r8a77970) on the Eagle board together with its expansion
board with a ADV7482 and out of tree patches for GMSL capture using the
max9286 and rdacm20 drivers.

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

* Changes since v10
- Corrected spelling in comments and commit messages.
- Reworked 'rcar-vin: read subdevice format for crop only when needed' 
  to only get the source format once per operation.
- Moved some patches around to make it easier to review, moved:
    - rcar-vin: set a default field to fallback on
    - rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
    - rcar-vin: update bytesperline and sizeimage calculation
    - rcar-vin: break out format alignment and checking
    - rcar-vin: update pixelformat check for M1
  Before:
    - rcar-vin: read subdevice format for crop only when needed
- Rename variable 'code' to 'mbus_code' in struct rvin_dev.
- Add comment describing no locking is needed in 
  rvin_set_channel_routing().
- Check return value of pm_runtime_get_sync() in 
  rvin_set_channel_routing().
- Rework 'rcar-vin: add check for colorspace' to not try to check the 
  format, instead force a default format. This should be revisited once 
  either v4l2-compliance or v4l2 framework changes are worked out to 
  allow for MC centric drivers to validate user supplied colorspace.
- Add error checking for pm_runtime_get_sync() and 
  v4l2_pipeline_pm_use().
- Change mutex_lock() to mutex_lock_interruptible() in rvin_mc_open().
- Rewrote documentation for struct rvin_group_route.
- Rename rvin_mc_parse_v4l2() to rvin_mc_parse_of_endpoint().
- Reword error messages in rvin_mc_parse_of_endpoint().
- Removed unneeded loop in rvin_mc_parse_of_endpoint().
- Remove check !is_media_entity_v4l2_subdev() in 
  rvin_group_entity_to_csi_id().
- Add documentation for the algorithm used to figure out if a link can 
  be enabled or not in rvin_group_link_notify().
- Break out format validation to rvin_mc_validate_format().
- Include two DT documentation patches from Fabrizio Castro which 
  previously where mentioned as the only dependency for this series.
- Added reviewed tags from Laurent, Thanks!

* Changes since v9
- Fixed mistakes in the device tree description pointed out by  Laurent.
    - GenX -> GenX platforms
    - portX -> port X
    - Explicitly state the on Gen3 platforms port 0 can only describe
      one endpoint and that only VIN instances connected to external
      pins should have a port 0 node.
    - s/which is/connected to/ in he endpoint description for Gen3
      platforms.
- Update some poorly written commit messages.
- Moved the digital subdevice attach and detach code to two separate
  functions to increase readability.
- Rename the struct rvin_info member chip to model to better describe
  its purpose.
- Change the video name from "rcar_vin e6ef0000.video" to "VINx output"
  where x is the VIN id.
- Dropped patch 'rcar-vin: do not allow changing scaling and composing
  while streaming' as it removed Gen2 functionality which is valid as
  pointed out by Laurent.
- Rename rvin_get_sd_format() to rvin_get_source_format() and change its
  parameter from struct v4l2_pix_format* to struct v4l2_mbus_framefmt*.
- Clarified commit message and add a few move comments to 'rcar-vin: fix
  handling of single field frames (top, bottom and alternate fields'.
- Update documentation for struct rvin_dev fields mbus_cfg and code.
- Fix argument in VNCSI_IFMD_CSI_CHSEL macro.
- Renamed rvin_set_chsel() to rvin_set_channel_routing().
- Restore the VNMC register after changing CHSEL setting.
- Broke patch 'rcar-vin: break out format alignment and checking' into
  three parts to ease review.
- Add new patch to introduce a default field.
- Only include media/v4l2-mc.h in the .c files that needs it and not in
  rcar-vin.h.
- Rename rvin_group_allocate() rvin_group_get()
- Rename rvin_group_delete() rvin_group_put()
- Updated error message "VIN number %d already occupied\n" to "Duplicate
  renesas,id property value %u\n".
- Removed dev_dbg messages which only where useful during development.
- Dropped patch '[PATCH v9 10/28] rcar-vin: do not reset crop and
  compose when setting format' as it introduces a regression on Gen2.
- Inline rvin_group_read_id() and rvin_group_add_vin() into
  rvin_group_get().
- Define static variables at the top of rcar-core.c.
- Fix potential deadlock in rvin_group_get().
- Set media device model name to the VIN module name.
- Set media device model to matched complicity string.
- Do not use a 2 dimensional sparse array for chsel values in struct
  rvin_info, instead use a flat array and store VIN and CHSEL value
  inside each array item.
- Reworked DT parsing code to make use of the new
  v4l2_async_notifier_parse_fwnode_endpoints_by_port() helper removing a
  lot of iffy custom parsing code.
- Rework how CHSEL value is calculated in the link notifier callback.
  Using a bitmap of possible values instead of looping over an array
  turned out great reducing both LoC and increasing readability of the
  code which was a bit difficult before. It also reduced to memory
  needed to contain the static routing information.
- Verify the media bus pixel code when starting a stream.
- Take the media device graph lock when figuring out and starting a
  stream so not to race between simultaneous stream start from multiple
  rcar-vin instances as they might share common subdevices.
- Added review tags from Laurent.
- Dropped tags from patches that where changed more then just correcting
  spelling or other gramma errors.

* Changes since v8
- Fixed issue in rvin_group_init() where rvin_group_update_links() was
  called, but after moving the video device registration to the
  complete() callback this is now invalid.
- Fixed spelling in commit messages.
- Added review and acks from Hans, Kieran and Rob.

* Changes since v7
- Dropped '[PATCH v7 02/25] rcar-vin: register the video device at probe time'
- Add patch which renames four badly name functions. Some of the
  renaming was in v7 part of the dropped patch 02/25. Make it a own
  patch and rename all badly named functions in one patch.
- Add patch to replace part of the functionality of the dropped patch v7
  02/25. The new patch keeps the subdevice (un)registration calls in the
  async callbacks bind() and unbind() but moves the direct subdevice
  initialization which only is used on Gen2 from the Gen2 and Gen3
  shared rvin_v4l2_register().
- Add patch to enable Renesas V3M (r8a77970)
- Patch 'rcar-vin: parse Gen3 OF and setup media graph' have had code
  additions since v7 since it now registers the video devices in the
  async complete() callback instead of at probe time as an effect of
  dropping v7 02/25.
  - The complete() callback now register all video devices.
  - The unbind() callback now unregister all video devices.
  - A new member '*notifier' is added to struct rvin_group which keeps
    track of which rcar-vin instance have registered its notifier on the
    groups behalf.
  For the reason above all Reviewed-by tags have been dropped for this
  patch.
- Replaced all kernel messages which used of_node_full_name() as now
  only returns the basename and not till full path, thanks Geert.

    printk("%s", of_node_full_name(ep)); -> printk("%pOF", ep);

- Added Reviewed-by tags from Hans, big thanks!

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

Fabrizio Castro (2):
  dt-bindings: media: rcar_vin: Reverse SoC part number list
  dt-bindings: media: rcar_vin: add device tree support for r8a774[35]

Niklas Söderlund (30):
  rcar-vin: add Gen3 devicetree bindings documentation
  rcar-vin: rename poorly named initialize and cleanup functions
  rcar-vin: unregister video device on driver removal
  rcar-vin: move subdevice handling to async callbacks
  rcar-vin: move model information to own struct
  rcar-vin: move max width and height information to chip information
  rcar-vin: move functions regarding scaling
  rcar-vin: all Gen2 boards can scale simplify logic
  rcar-vin: set a default field to fallback on
  rcar-vin: fix handling of single field frames (top, bottom and
    alternate fields)
  rcar-vin: update bytesperline and sizeimage calculation
  rcar-vin: align pixelformat check
  rcar-vin: break out format alignment and checking
  rcar-vin: read subdevice format for crop only when needed
  rcar-vin: move media bus configuration to struct rvin_info
  rcar-vin: enable Gen3 hardware configuration
  rcar-vin: add function to manipulate Gen3 chsel value
  rcar-vin: add flag to switch to media controller mode
  rcar-vin: use different v4l2 operations in media controller mode
  rcar-vin: force default colorspace for media centric mode
  rcar-vin: prepare for media controller mode initialization
  rcar-vin: add group allocator functions
  rcar-vin: change name of video device
  rcar-vin: add chsel information to rvin_info
  rcar-vin: parse Gen3 OF and setup media graph
  rcar-vin: add link notify for Gen3
  rcar-vin: extend {start,stop}_streaming to work with media controller
  rcar-vin: enable support for r8a7795
  rcar-vin: enable support for r8a7796
  rcar-vin: enable support for r8a77970

 .../devicetree/bindings/media/rcar_vin.txt         | 137 ++-
 drivers/media/platform/rcar-vin/Kconfig            |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 962 +++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-dma.c         | 864 ++++++++++--------
 drivers/media/platform/rcar-vin/rcar-v4l2.c        | 524 ++++++-----
 drivers/media/platform/rcar-vin/rcar-vin.h         | 142 ++-
 6 files changed, 1972 insertions(+), 659 deletions(-)

-- 
2.16.2
