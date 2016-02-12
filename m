Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52567 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcBLCAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:33 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 0/9] FCP support for Renesas video cores
Date: Fri, 12 Feb 2016 04:00:41 +0200
Message-Id: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This RFC patch series implements support for the Frame Compression Processor
(FCP) modules found in the Renesas R-Car Gen3 SoCs.

The FCP is a companion module for various video processing modules in the Gen3
family SoCs. It provides data compression and decompression, data caching and
conversion of AXI transaction in order to reduce the memory bandwidth. In
simpler terms it handles data memory accesses on behalf of a video processing
module.

In the simplest case the FCP is completely transparent to the video processing
module for which it handles memory accesses, with one caveat: the FCP
functional clock and power domain must be enabled whenever it has to handle a
memory access.

The approach taken in this series is to describe the FCPs in DT as device
nodes with registers, clocks and power domains. They are referenced from the
associated video processing module DT node. On the driver side, a new rcar-fcp
driver handles registration of FCP instances as they are probed, and offers an
API to video processing module drivers to lookup FCP instances and enable and
disable them.

The FCP driver currently doesn't access the FCP registers, is for the FCPV
(FCP for VSP) instances no FCP parameter needs to be configured. Other FCP
variants (FCP for FDP and possiblye FCP for Codec) will require software
configuration which will be implemented later.

This patch series enables FCPV support for the r8a7795 SoC. In order to
provide enough context for review I've included patches that add FCP support
in the VSP driver, as well as DT patches to enable VSP and DU. Only patches
1/9, 3/9 and 6/9 are relevant for the FCP. Patches 5/9 and 7/9 show how the
FCP API is used in the VSP driver. Patches 2/9, 4/9, 8/9 and 9/9 are only
needed to test FCP + VSP operation on r8a7795 and are otherwise out of scope
for this RFC (reviews would of course still be appreciated).

The series applies on top of two previously posted patch series for the vsp1
and rcar-du-drm drivers. For review and testing convenience I've pushed the
result to

	git://linuxtv.org/pinchartl/media.git drm/du/vsp1-kms/boards

Laurent Pinchart (9):
  clk: shmobile: r8a7795: Add FCP clocks
  clk: shmobile: r8a7795: Add LVDS module clock
  v4l: Add Renesas R-Car FCP driver
  v4l: vsp1: VSPD instances have no LUT on Gen3
  v4l: vsp1: Add FCP support
  ARM64: renesas: r8a7795: Add FCPV nodes
  ARM64: renesas: r8a7795: Add VSP instances
  ARM64: renesas: r8a7795: Add DU device to DT
  ARM64: renesas: salvator-x: Enable DU

 .../devicetree/bindings/media/renesas,fcp.txt      |  24 +++
 .../devicetree/bindings/media/renesas,vsp1.txt     |   5 +
 MAINTAINERS                                        |  10 +
 arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts |  44 ++++
 arch/arm64/boot/dts/renesas/r8a7795.dtsi           | 237 +++++++++++++++++++++
 drivers/clk/shmobile/r8a7795-cpg-mssr.c            |  16 ++
 drivers/media/platform/Kconfig                     |  14 ++
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/rcar-fcp.c                  | 176 +++++++++++++++
 drivers/media/platform/vsp1/vsp1.h                 |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  26 ++-
 include/media/rcar-fcp.h                           |  34 +++
 12 files changed, 587 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt
 create mode 100644 drivers/media/platform/rcar-fcp.c
 create mode 100644 include/media/rcar-fcp.h

-- 
Regards,

Laurent Pinchart

