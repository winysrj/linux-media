Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:53767 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbdAZPZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 10:25:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv5 0/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 support
Date: Thu, 26 Jan 2017 16:25:31 +0100
Message-Id: <20170126152533.28434-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the latest incarnation of R-Car MIPI CSI-2 receiver driver. It's 
based on top of v4.10-rc1 and are tested on Renesas Salvator-X together 
with the out of tree patches for rcar-vin to add support for Gen3 VIN 
and a prototype driver for ADV7482. If anyone is interested to test 
video grabbing using these out of tree patches please see [1].

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

 .../devicetree/bindings/media/rcar-csi2.txt        | 116 ++++
 drivers/media/platform/rcar-vin/Kconfig            |  11 +
 drivers/media/platform/rcar-vin/Makefile           |   1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 616 +++++++++++++++++++++
 4 files changed, 744 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
2.11.0

