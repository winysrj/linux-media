Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40757 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbeDCNnC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 09:43:02 -0400
Subject: Re: [PATCH v13 00/33] rcar-vin: Add Gen3 with media controller
To: Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
 <66498032-7cd9-c744-0555-52f9a03437a9@xs4all.nl>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <a16533c5-9c3a-2413-9919-c39fcfa96f82@ideasonboard.com>
Date: Tue, 3 Apr 2018 14:42:56 +0100
MIME-Version: 1.0
In-Reply-To: <66498032-7cd9-c744-0555-52f9a03437a9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/04/18 13:30, Hans Verkuil wrote:
> On 26/03/18 23:44, Niklas Söderlund wrote:
>> Hi,
>>
>> This series adds Gen3 VIN support to rcar-vin driver for Renesas r8a7795,
>> r8a7796 and r8a77970. It is based on the media-tree and depends on
>> Fabrizio Castro patches as they touches the order of the compatible
>> strings in the documentation to reduce merge conflicts. The dependencies
>> are included in this series.
> 
> Laurent, Kieran,
> 
> Unless there are any objections I want to make a pull request for this
> series once 4.17-rc1 has been merged back into our master tree. It all
> looks good to me, and it will be nice to get this in (finally!).
> 
> I don't want to postpone the pull request for small improvements, they
> can be applied later. But if there are more serious concerns, then let
> us know.

Certainly sounds good, and no objections from me.
Looking forward to getting this series in.

Thanks

Kieran


> Regards,
> 
> 	Hans
> 
>>
>> The driver is tested on Renesas H3 (r8a7795, ES2.0),
>> M3-W (r8a7796) together with the rcar-csi2 driver (posted separately and
>> not yet upstream) and the Salvator-X onboard ADV7482. It is also tested
>> on the V3M (r8a77970) on the Eagle board together with its expansion
>> board with a ADV7482 and out of tree patches for GMSL capture using the
>> max9286 and rdacm20 drivers.
>>
>> It is possible to capture both CVBS and HDMI video streams,
>> v4l2-compliance passes with no errors and media-ctl can be used to
>> change the routing and formats for the different entities in the media
>> graph.
>>
>> Gen2 compatibility is verified on Koelsch and no problems where found,
>> video can be captured just like before and v4l2-compliance passes
>> without errors or warnings just like before this series.
>>
>> For convenience the series can be fetched from:
>>
>>   git://git.ragnatech.se/linux rcar/vin/mc-v13
>>
>> I have started on a very basic test suite for the VIN driver at:
>>
>>   https://git.ragnatech.se/vin-tests
>>
>> And as before the state of the driver and information about how to test
>> it can be found on the elinux wiki:
>>
>>   http://elinux.org/R-Car/Tests:rcar-vin
>>
>> * Changes from v12
>> - Rebase to latest media-tree/master changed a 'return ret' to a 'goto
>>   out' in rvin_start_streaming() to take recent changes to the VIN 
>>   driver into account.
>> - Moved field != V4L2_FIELD_ANY in 'rcar-vin: set a default field to  
>>   fallback on' check from a later commit 'rcar-vin: simplify how formats 
>>   are set and reset' in the series. This is to avoid ignoring the field 
>>   returned from the sensor if FIELD_ANY was requested by the user. This 
>>   was only a problem between this change and a few patches later, but 
>>   better to fix it now. Reported by Hans, thanks for spotting this.
>> - Fix spelling.
>> - Add review tags from Hans.
>>
>> * Changes since v11
>> - Rewrote commit message for '[PATCH v11 22/32] rcar-vin: force default
>>   colorspace for media centric mode'. Also set fixed values for
>>   xfer_func, quantization and ycbcr_enc.
>> - Reorderd filed order in struct rvin_group_route.
>> - Renamed chan to channel in struct rvin_group_route.
>> - Rework 'rcar-vin: read subdevice format for crop only when
>>   needed' into 'rcar-vin: simplify how formats are set and reset'.
>> - Keep caching the source dimensions and drop all changes to
>>   rvin_g_selection() and rvin_s_selection().
>> - Inline rvin_get_vin_format_from_source() into rvin_reset_format()
>>   which now is the only user left.
>> - Add patch to cache the video standard instead of reading it at stream
>>   on.
>> - Fix error labels in rvin_mc_open().
>> - Fixed spelling in commit messages and comment, thanks Laurent!
>> - Added reviewed tags from Laurent, Thanks!
>>
>> * Changes since v10
>> - Corrected spelling in comments and commit messages.
>> - Reworked 'rcar-vin: read subdevice format for crop only when needed'
>>   to only get the source format once per operation.
>> - Moved some patches around to make it easier to review, moved:
>>     - rcar-vin: set a default field to fallback on
>>     - rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
>>     - rcar-vin: update bytesperline and sizeimage calculation
>>     - rcar-vin: break out format alignment and checking
>>     - rcar-vin: update pixelformat check for M1
>>   Before:
>>     - rcar-vin: read subdevice format for crop only when needed
>> - Rename variable 'code' to 'mbus_code' in struct rvin_dev.
>> - Add comment describing no locking is needed in
>>   rvin_set_channel_routing().
>> - Check return value of pm_runtime_get_sync() in
>>   rvin_set_channel_routing().
>> - Rework 'rcar-vin: add check for colorspace' to not try to check the
>>   format, instead force a default format. This should be revisited once
>>   either v4l2-compliance or v4l2 framework changes are worked out to
>>   allow for MC centric drivers to validate user supplied colorspace.
>> - Add error checking for pm_runtime_get_sync() and
>>   v4l2_pipeline_pm_use().
>> - Change mutex_lock() to mutex_lock_interruptible() in rvin_mc_open().
>> - Rewrote documentation for struct rvin_group_route.
>> - Rename rvin_mc_parse_v4l2() to rvin_mc_parse_of_endpoint().
>> - Reword error messages in rvin_mc_parse_of_endpoint().
>> - Removed unneeded loop in rvin_mc_parse_of_endpoint().
>> - Remove check !is_media_entity_v4l2_subdev() in
>>   rvin_group_entity_to_csi_id().
>> - Add documentation for the algorithm used to figure out if a link can
>>   be enabled or not in rvin_group_link_notify().
>> - Break out format validation to rvin_mc_validate_format().
>> - Include two DT documentation patches from Fabrizio Castro which
>>   previously where mentioned as the only dependency for this series.
>> - Added reviewed tags from Laurent, Thanks!
>>
>> * Changes since v9
>> - Fixed mistakes in the device tree description pointed out by  Laurent.
>>     - GenX -> GenX platforms
>>     - portX -> port X
>>     - Explicitly state the on Gen3 platforms port 0 can only describe
>>       one endpoint and that only VIN instances connected to external
>>       pins should have a port 0 node.
>>     - s/which is/connected to/ in he endpoint description for Gen3
>>       platforms.
>> - Update some poorly written commit messages.
>> - Moved the digital subdevice attach and detach code to two separate
>>   functions to increase readability.
>> - Rename the struct rvin_info member chip to model to better describe
>>   its purpose.
>> - Change the video name from "rcar_vin e6ef0000.video" to "VINx output"
>>   where x is the VIN id.
>> - Dropped patch 'rcar-vin: do not allow changing scaling and composing
>>   while streaming' as it removed Gen2 functionality which is valid as
>>   pointed out by Laurent.
>> - Rename rvin_get_sd_format() to rvin_get_source_format() and change its
>>   parameter from struct v4l2_pix_format* to struct v4l2_mbus_framefmt*.
>> - Clarified commit message and add a few move comments to 'rcar-vin: fix
>>   handling of single field frames (top, bottom and alternate fields'.
>> - Update documentation for struct rvin_dev fields mbus_cfg and code.
>> - Fix argument in VNCSI_IFMD_CSI_CHSEL macro.
>> - Renamed rvin_set_chsel() to rvin_set_channel_routing().
>> - Restore the VNMC register after changing CHSEL setting.
>> - Broke patch 'rcar-vin: break out format alignment and checking' into
>>   three parts to ease review.
>> - Add new patch to introduce a default field.
>> - Only include media/v4l2-mc.h in the .c files that needs it and not in
>>   rcar-vin.h.
>> - Rename rvin_group_allocate() rvin_group_get()
>> - Rename rvin_group_delete() rvin_group_put()
>> - Updated error message "VIN number %d already occupied\n" to "Duplicate
>>   renesas,id property value %u\n".
>> - Removed dev_dbg messages which only where useful during development.
>> - Dropped patch '[PATCH v9 10/28] rcar-vin: do not reset crop and
>>   compose when setting format' as it introduces a regression on Gen2.
>> - Inline rvin_group_read_id() and rvin_group_add_vin() into
>>   rvin_group_get().
>> - Define static variables at the top of rcar-core.c.
>> - Fix potential deadlock in rvin_group_get().
>> - Set media device model name to the VIN module name.
>> - Set media device model to matched complicity string.
>> - Do not use a 2 dimensional sparse array for chsel values in struct
>>   rvin_info, instead use a flat array and store VIN and CHSEL value
>>   inside each array item.
>> - Reworked DT parsing code to make use of the new
>>   v4l2_async_notifier_parse_fwnode_endpoints_by_port() helper removing a
>>   lot of iffy custom parsing code.
>> - Rework how CHSEL value is calculated in the link notifier callback.
>>   Using a bitmap of possible values instead of looping over an array
>>   turned out great reducing both LoC and increasing readability of the
>>   code which was a bit difficult before. It also reduced to memory
>>   needed to contain the static routing information.
>> - Verify the media bus pixel code when starting a stream.
>> - Take the media device graph lock when figuring out and starting a
>>   stream so not to race between simultaneous stream start from multiple
>>   rcar-vin instances as they might share common subdevices.
>> - Added review tags from Laurent.
>> - Dropped tags from patches that where changed more then just correcting
>>   spelling or other gramma errors.
>>
>> * Changes since v8
>> - Fixed issue in rvin_group_init() where rvin_group_update_links() was
>>   called, but after moving the video device registration to the
>>   complete() callback this is now invalid.
>> - Fixed spelling in commit messages.
>> - Added review and acks from Hans, Kieran and Rob.
>>
>> * Changes since v7
>> - Dropped '[PATCH v7 02/25] rcar-vin: register the video device at probe time'
>> - Add patch which renames four badly name functions. Some of the
>>   renaming was in v7 part of the dropped patch 02/25. Make it a own
>>   patch and rename all badly named functions in one patch.
>> - Add patch to replace part of the functionality of the dropped patch v7
>>   02/25. The new patch keeps the subdevice (un)registration calls in the
>>   async callbacks bind() and unbind() but moves the direct subdevice
>>   initialization which only is used on Gen2 from the Gen2 and Gen3
>>   shared rvin_v4l2_register().
>> - Add patch to enable Renesas V3M (r8a77970)
>> - Patch 'rcar-vin: parse Gen3 OF and setup media graph' have had code
>>   additions since v7 since it now registers the video devices in the
>>   async complete() callback instead of at probe time as an effect of
>>   dropping v7 02/25.
>>   - The complete() callback now register all video devices.
>>   - The unbind() callback now unregister all video devices.
>>   - A new member '*notifier' is added to struct rvin_group which keeps
>>     track of which rcar-vin instance have registered its notifier on the
>>     groups behalf.
>>   For the reason above all Reviewed-by tags have been dropped for this
>>   patch.
>> - Replaced all kernel messages which used of_node_full_name() as now
>>   only returns the basename and not till full path, thanks Geert.
>>
>>     printk("%s", of_node_full_name(ep)); -> printk("%pOF", ep);
>>
>> - Added Reviewed-by tags from Hans, big thanks!
>>
>> * Changes since v6
>> - Rebase ontop of latest media-tree which brings in the use of the
>>   fwnode async helpers for Gen2.
>> - Updated DT binding documentation, thanks Laurent for very helpful
>>   input!
>> - Removed help text which where copied in from v4l2_ctrl_handler_init()
>>   documentation when moving that code block, this was a residue from the
>>   soc_camera conversion and should have been removed at that time.
>> - Removed bad check of tvnorms which disables IOCTLs if it's not set,
>>   this was a residue from soc_camera conversion and have use in the
>>   current driver.
>> - Moved all subdevice initialization from complete to bound handler
>>   while improving the unbind handler. With this move all operations of
>>   the ctrl_handler from the subdevice is handled in either bound or
>>   unbind removing races pointed out by Laurent.
>> - Renamed rvin_v4l2_probe() -> rvin_v4l2_register() and
>>   rvin_v4l2_remove() -> rvin_v4l2_unregister().
>> - Fold rvin_mbus_supported() into its only caller.
>> - Sort compatible string entries in ascending order.
>> - Improved documentation for struct rvin_group_chsel.
>> - Clarify comment in rvin_group_csi_pad_to_chan().
>> - Make use of of_device_get_match_data() as suggested by Geert.
>> - Fixed spelling mistakes.
>> - Added review tags from Hans.
>>
>> * Changes since v5
>> - Extract and make use of common format checking for both Gen2 and Gen3.
>> - Assign pad at declaration time in rvin_get_sd_format()
>> - Always call pm_runtime_{get_sync,put}() and v4l2_pipeline_pm_use()
>>   when opening/closing a video device, remove the check of
>>   v4l2_fh_is_singular_file().
>> - Make rvin_set_chsel() return void instead of int since it always
>>   return 0.
>> - Simplify the VIN group allocator functions.
>> - Make the group notifier callbacks and setup more robust.
>> - Moved the video device registration back to probe time.
>> - Add H3 ES2.0 support.
>> - Fix handling of single field formats (top, bottom, alternate) as this
>>   was obviously wrong before but hidden by the Gen2 scaler support.
>> - Added review tags from Kieran.
>>
>> * Changes since v4 (Not posted to ML)
>> - Updated to the new fwnode functions.
>> - Moved the registration of the video devices to the async notification
>>   callback.
>>
>> * Changes since v3
>> - Only add neighboring subdevices to the async notifier. Instead of
>>   parsing the whole OF graph depend on incremental async subnotifier to
>>   discover the whole pipeline. This is needed to support arbitrarily
>>   long graphs and support the new ADV7482 prototype driver which Kieran
>>   is working on.
>> - Fix warning from lockdep, reported by Kieran.
>> - Fix commit messages from feedback from Sergei, thanks.
>> - Fix chip info an OF device ids sorting order, thanks Geert.
>> - Use subdev->of_node instead of subdev->dev->of_node, thanks Kieran.
>>
>> * Changes since v2
>> - Do not try to control the subdevices in the media graph from the rcar-vin
>>   driver. Have user-space configure to format in the pipeline instead.
>> - Add link validation before starting the stream.
>> - Rework on how the subdevices are and the video node behave by defining
>>   specific V4L2 operations for the MC mode of operation, this simplified
>>   the driver quit a bit, thanks Laurent!
>> - Add a new 'renesas,id' DT property which is needed to to be able to
>>   keep the VIN to CSI-2 routing table inside the driver. Previously this
>>   information was taken from the CSI-2 DT node which is obviously the
>>   wrong way to do things. Thanks Laurent for pointing this out.
>> - Fixed a memory leek in the group allocator function.
>> - Return -EMLINK instead of -EBUSY if a MC link is not possible given
>>   the current routing setup.
>> - Add comments to clarify that the 4 channels from the CSI-2 node is not
>>   directly related to CSI-2 virtual channels, the CSI-2 node can output
>>   any VC on any of its output channels.
>>
>> * Changes since v1
>> - Remove unneeded casts as pointed out by Geert.
>> - Fix spelling and DT documentation as pointed out by Geert and Sergei,
>>   thanks!
>> - Refresh patch 2/32 with an updated version, thanks Sakari for pointing
>>   this out.
>> - Add Sakaris Ack to patch 1/32.
>> - Rebase on top of v4.9-rc1 instead of v4.9-rc3 to ease integration
>>   testing together with renesas-drivers tree.
>>
>> Fabrizio Castro (2):
>>   dt-bindings: media: rcar_vin: Reverse SoC part number list
>>   dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
>>
>> Niklas Söderlund (31):
>>   rcar-vin: add Gen3 devicetree bindings documentation
>>   rcar-vin: rename poorly named initialize and cleanup functions
>>   rcar-vin: unregister video device on driver removal
>>   rcar-vin: move subdevice handling to async callbacks
>>   rcar-vin: move model information to own struct
>>   rcar-vin: move max width and height information to chip information
>>   rcar-vin: move functions regarding scaling
>>   rcar-vin: all Gen2 boards can scale simplify logic
>>   rcar-vin: set a default field to fallback on
>>   rcar-vin: fix handling of single field frames (top, bottom and
>>     alternate fields)
>>   rcar-vin: update bytesperline and sizeimage calculation
>>   rcar-vin: align pixelformat check
>>   rcar-vin: break out format alignment and checking
>>   rcar-vin: simplify how formats are set and reset
>>   rcar-vin: cache video standard
>>   rcar-vin: move media bus configuration to struct rvin_dev
>>   rcar-vin: enable Gen3 hardware configuration
>>   rcar-vin: add function to manipulate Gen3 chsel value
>>   rcar-vin: add flag to switch to media controller mode
>>   rcar-vin: use different v4l2 operations in media controller mode
>>   rcar-vin: force default colorspace for media centric mode
>>   rcar-vin: prepare for media controller mode initialization
>>   rcar-vin: add group allocator functions
>>   rcar-vin: change name of video device
>>   rcar-vin: add chsel information to rvin_info
>>   rcar-vin: parse Gen3 OF and setup media graph
>>   rcar-vin: add link notify for Gen3
>>   rcar-vin: extend {start,stop}_streaming to work with media controller
>>   rcar-vin: enable support for r8a7795
>>   rcar-vin: enable support for r8a7796
>>   rcar-vin: enable support for r8a77970
>>
>>  .../devicetree/bindings/media/rcar_vin.txt         | 137 ++-
>>  drivers/media/platform/rcar-vin/Kconfig            |   2 +-
>>  drivers/media/platform/rcar-vin/rcar-core.c        | 962 +++++++++++++++++++--
>>  drivers/media/platform/rcar-vin/rcar-dma.c         | 785 ++++++++++-------
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c        | 488 ++++++-----
>>  drivers/media/platform/rcar-vin/rcar-vin.h         | 146 +++-
>>  6 files changed, 1913 insertions(+), 607 deletions(-)
>>
> 
