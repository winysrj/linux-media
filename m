Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:36301 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdGQREx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 13:04:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 0/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 support
Date: Mon, 17 Jul 2017 19:03:54 +0200
Message-Id: <20170717170356.25568-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the latest incarnation of R-Car MIPI CSI-2 receiver driver. It's
based on top of the media-tree and are tested on Renesas Salvator-X together
with the out of tree patches for rcar-vin to add support for Gen3 VIN
and a driver for ADV7482. If anyone is interested to test
video grabbing using these out of tree patches please see [1].

It depends on the patches:

- [PATCH v4 0/3] v4l2-async: add subnotifier registration for subdevices

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
- Remove assumtion about unkown medis bus type, thanks Sakari for
  pointing this out.
- Created table for supported format information instead of scattering
  this information around the driver, thanks Sakari!
- Small newline fixes and reduce some indentation levels.

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
  thanks!

Changes since v2:
- Added media control pads as this is needed by the new rcar-vin driver.
- Update DT bindings after review comments and to add r8a7796 support.
- Add get_fmt handler.
- Fix media bus format error s/YUYV8/UYVY8/

Changes since v1:
- Drop dependency on a pad aware s_stream operation.
- Use the DT bindings format "renesas,<soctype>-<device>", thanks Geert
  for pointing this out.

1. http://elinux.org/R-Car/Tests:rcar-vin

Niklas Söderlund (2):
  media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
  media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver

 .../devicetree/bindings/media/rcar-csi2.txt        | 118 +++
 drivers/media/platform/rcar-vin/Kconfig            |  12 +
 drivers/media/platform/rcar-vin/Makefile           |   1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 822 +++++++++++++++++++++
 4 files changed, 953 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
2.13.1
