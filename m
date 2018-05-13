Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:34136 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751438AbeEMTUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 15:20:48 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v15 0/2] rcar-csi2: add Renesas R-Car MIPI CSI-2
Date: Sun, 13 May 2018 21:19:15 +0200
Message-Id: <20180513191917.20681-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the latest incarnation of R-Car MIPI CSI-2 receiver driver. It's
based on top of the media-tree and are tested on Renesas Salvator-X and 
Salvator-XS together with adv7482 and the now in tree rcar-vin driver :-)

I hope this is the last incarnation of this patch-set, I do think it is
ready for upstream consumption :-)

* Changes since v14.
- Data sheet update changed init sequence for PHY forcing a restructure
  of the driver. The restructure was so big I felt compel to drop all
  review tags :-(
- The change was that the Renesas H3 procedure was aligned with other
  SoC in the Gen3 family procedure. I had kept the rework as separate
  patches and was planing to post once original driver with H3 and M3-W
  support where merged. As review tags are dropped I chosen to squash
  those patches into 2/2.
- Add support for Gen3 M3-N.
- Add support for Gen3 V3M.
- Set PHTC_TESTCLR when stopping the PHY.
- Revert back to the v12 and earlier phypll calculation as it turns out
  it was correct after all.
- Added compatible string for R8A77965 and R8A77970.
- s/Port 0/port@0/
- s/Port 1/port@1/
- s/Endpoint 0/endpoint@0/

* Changes since v13
- Change return rcar_csi2_formats + i to return &rcar_csi2_formats[i].
- Add define for PHCLM_STOPSTATECKL.
- Update spelling in comments.
- Update calculation in rcar_csi2_calc_phypll() according to
  https://linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html. The one
  before v14 did not take into account that 2 bits per sample is
  transmitted.
- Use Geert's suggestion of (1 << priv->lanes) - 1 instead of switch
  statement to set correct number of lanes to enable.
- Change hex constants in hsfreqrange_m3w_h3es1[] to lower case to match
  style of rest of file.
- Switch to %u instead of 0x%x when printing bus type.
- Switch to %u instead of %d for priv->lanes which is unsigned.
- Add MEDIA_BUS_FMT_YUYV8_1X16 to the list of supported formats in
  rcar_csi2_formats[].
- Fixed bps for MEDIA_BUS_FMT_YUYV10_2X10 to 20 and not 16.
- Set INTSTATE after PL-11 is confirmed to match flow chart in
  datasheet.
- Change priv->notifier.subdevs == NULL to !priv->notifier.subdevs.
- Add Maxime's and laurent's tags.

* Changes since v12
- Fixed spelling mistakes in commit messages and documentation patch,
  thanks Laurent.
- Mark endpoints in port 1 as optional as it is allowed to not connect a
  VIN to the CSI-2 and instead have it only use its parallel input
  source (for those VIN that have one).
- Added Ack from Sakari, thanks!
- Media bus codes are u32 not unsigned int.
- Ignore error check for v4l2_subdev_call(sd, video, s_stream, 0)
- Do not set subdev host data as it's not used,
  v4l2_set_subdev_hostdata().
- Fixed spelling errors in commit message.
- Add SPDX header
- Rename badly named variable tmp to vcdt_part.
- Cache subdevice in bound callback instead of looking it up in the
  media graph. By doing this rcar_csi2_sd_info() can be removed.
- Print unsigned using %u not %d.
- Call pm_runtime_enable() before calling v4l2_async_register_subdev().
- Dropped of_match_ptr() as OF is required.

* Changes since v11
- Added missing call to v4l2_async_notifier_unregister().
- Fixed missing reg popery in bindings documentation.
- Add Rob's ack to 01/02.
- Dropped 'media:' prefix from patch subjects as it seems they are added
  first when a patch is picked up by the maintainer.
- Fixed typo in comment enpoint -> endpoint, thanks Hans.
- Added Hans Reviewed-by to driver.

* Changes since v10
- Renamed Documentation/devicetree/bindings/media/rcar-csi2.txt to
  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
- Add extra newline in rcar_csi2_code_to_fmt()
- Use locally stored format information instead of reading it from the
  remote subdevice, Sakari pointed out that the pipeline is validated
  before .s_stream() is called so this is safe.
- Do not check return from media_entity_to_v4l2_subdev() in
  rcar_csi2_start(), Sakari pointed out it can't fail. Also move logic
  to find the remote subdevice is moved to the only user of it,
  rcar_csi2_calc_phypll().
- Move pm_runtime_get_sync() and pm_runtime_put() to
  rcar_csi2_s_stream() and remove rcar_csi2_s_power().
- Add validation of pixel code to rcar_csi2_set_pad_format().
- Remove static rcar_csi2_notify_unbind() as it only printed a debug
  message.

* Changes since v9
- Add reset property to device tree example
- Use BIT(x) instead of (1 << x)
- Use u16 in struct phypll_hsfreqrange to pack struct better.
- Use unsigned int type for loop variable in rcar_csi2_code_to_fmt
- Move fields inside struct struct rcar_csi2_info and struct rcar_csi2
  to pack struct's tighter.
- Use %u instead of %d when printing __u32.
- Don't check return of platform_get_resource(), let
  devm_ioremap_resource() handle it.
- Store quirk workaround for r8a7795 ES1.0 in the data field of struct
  soc_device_attribute.

Changes since v8:
- Updated bindings documentation, thanks Rob!
- Make use of the now in media-tree sub-notifier V4L2 API
- Add delay when resetting the IP to allow for a proper reset
- Fix bug in s_stream error path where the usage count was off if an
  error was hit.
- Add support for H3 ES2.0

Changes since v7:
- Rebase on top of the latest incremental async patches.
- Fix comments on DT documentation.
- Use v4l2_ctrl_g_ctrl_int64() instead of v4l2_g_ext_ctrls().
- Handle try formats in .set_fmt() and .get_fmt().
- Don't call v4l2_device_register_subdev_nodes() as this is not needed
  with the complete() callbacks synchronized.
- Fix line over 80 chars.
- Fix varies spelling mistakes.

Changes since v6:
- Rebased on top of Sakaris fwnode patches.
- Changed of RCAR_CSI2_PAD_MAX to NR_OF_RCAR_CSI2_PAD.
- Remove assumption about unknown media bus type, thanks Sakari for
  pointing this out.
- Created table for supported format information instead of scattering
  this information around the driver, thanks Sakari!
- Small newline fixes and reduce some indentation levels

Changes since v5:
- Make use of the incremental async subnotifer and helper to map DT
  endpoint to media pad number. This moves functionality which
  previously in the Gen3 patches for R-Car VIN driver to this R-Car
  CSI-2 driver. This is done in preparation to support the ADV7482
  driver in development by Kieran which will register more then one
  subdevice and the CSI-2 driver needs to cope wit this. Further more it
  prepares the driver for another use-case where more then one subdevice
  is present upstream for the CSI-2.
- Small cleanups.
- Add explicit include for linux/io.h, thanks Kieran.

Changes since v4:
- Match SoC part numbers and drop trailing space in documentation,
  thanks Geert for pointing this out.
- Clarify that the driver is a CSI-2 receiver by supervised
  s/interface/receiver/, thanks Laurent.
- Add entries in Kconfig and Makefile alphabetically instead of append.
- Rename struct rcar_csi2 member swap to lane_swap.
- Remove macros to wrap calls to dev_{dbg,info,warn,err}.
- Add wrappers for ioread32 and iowrite32.
- Remove unused interrupt handler, but keep checking in probe that there
  are a interrupt define in DT.
- Rework how to wait for LP-11 state, thanks Laurent for the great idea!
- Remove unneeded delay in rcar_csi2_reset()
- Remove check for duplicated lane id:s from DT parsing. Broken out to a
  separate patch adding this check directly to v4l2_of_parse_endpoint().
- Fixed rcar_csi2_start() to ask it's source subdevice for information
  about pixel rate and frame format. With this change having
  {set,get}_fmt operations became redundant, it was only used for
  figuring out this out so dropped them.
- Tabulated frequency settings map.
- Dropped V4L2_SUBDEV_FL_HAS_DEVNODE it should never have been set.
- Switched from MEDIA_ENT_F_ATV_DECODER to
  MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER as entity function. I can't
  find a more suitable function, and what the hardware do is to fetch
  video from an external chip and passes it on to a another SoC internal
  IP it's sort of a formatter.
- Break out DT documentation and code in two patches.

Changes since v3:
- Update DT binding documentation with input from Geert Uytterhoeven,
  thanks

Changes since v2:
- Added media control pads as this is needed by the new rcar-vin driver.
- Update DT bindings after review comments and to add r8a7796 support.
- Add get_fmt handler.
- Fix media bus format error s/YUYV8/UYVY8/

Changes since v1:
- Drop dependency on a pad aware s_stream operation.
- Use the DT bindings format "renesas,<soctype>-<device>", thanks Geert
  for pointing this out.

Niklas Söderlund (2):
  rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
  rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver

 .../bindings/media/renesas,rcar-csi2.txt      |  101 ++
 MAINTAINERS                                   |    1 +
 drivers/media/platform/rcar-vin/Kconfig       |   12 +
 drivers/media/platform/rcar-vin/Makefile      |    1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c   | 1101 +++++++++++++++++
 5 files changed, 1216 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
2.17.0
