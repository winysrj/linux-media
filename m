Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:55974 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbcGSOXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:10 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 00/16] rcar-vin: Enable Gen3 support
Date: Tue, 19 Jul 2016 16:20:51 +0200
Message-Id: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series enable Gen3 support for the rcar-vin driver. It is based on
top of the media_tree.

This is a rather large patch since unfortunately the subdevice and input
selection on Gen3 are much more complex than on Gen2, see individual
patches for a more detailed explanation.

- Patch 1-2 picks up media entity additions from Laurent which the driver 
  depends on.
- Patch 3 picks up a fix for incorrect media bus formats. This patch is posted 
  separately but to resolve the merge conflict it generated i included it in 
  this series.
- Patch 4-8 cleans up the driver fixing some logical, style and 
  dependency errors that was not found before the driver was added to 
  media_next.
- Patch 9 simplifies how DT is parsed and how v4l2 async binding to 
  subdevices are setup. A incorrect usage of of_node_put() is also 
  fixed.
- Patch 10 moves struct variables around to prepare for multiple input 
  sources.
- Patch 11-12 adds an abstraction layer between the code and which 
  subdevices are currently used. This also fixes the problem where a 
  subdevice could not be unbound and later rebound keeping the VIN 
  driver working.
- Patch 13 adds Gen3 Hw support.
- Patch 14 is the big patch adding subdevice groups that can be shared 
  between multiple rcar-vin instances. See commit message for much more 
  details.
- Patch 15-16 adds DT bindings for Gen3 and compatibility bindings for 
  Gen2 and Gen3.

The series is tested on Koelsch for Gen2 and it works as expected. If 
one wants to test the HDMI input the patch 'r8a7791-koelsch.dts: add 
HDMI input' from Hans Verkuil are needed to add it to DT. The driver 
passes a v4l2-compliance on Gen2 without errors or warnings. And there 
are no problems grabbing frames from the CVBS or HDMI input sources 
using qv4l2.

For Gen3 there are more drivers needed to get working video input 
running. To be able to grab frames drivers are needed for the R-Car 
CSI-2 interface and the ADV7482 device which are not yet present in the 
kernel. A driver for the CSI-2 interface and a prototype for ADV7482 are 
posted on the media malinglist.

Unfortunately the ADV7482 driver needs more support in the v4l2 
framework to be able to provide two interdependent video pipelines (CVBS 
and HDMI). Until this is resolved the driver can be compiled for either 
CVBS or HDMI operation. If one have a DT that only contain CVBS 
configuration rcar-vin v4l2-compliance pass all test expect for controls 
since they are not added to the ADV7482 driver. For HDMI DT and ADV7482 
compiled for HDMI instead of the default CVBS v4l2-compliance fails for 
controls and DV timings since some parts are missing in the ADV7482 
driver. It is however possible to capture both CVBS and HDMI video using 
qv4l2.

If one is interested to test on Gen3 without having to hunt patches look 
at the elinux wiki for a branch containing the latest status.

http://elinux.org/R-Car/Tests:rcar-vin

Changes since v1:
- Address review comments from Laurent.
- Split cleanup of driver to smaller chunks.
- Remove initial work for v4l2 framework changes to support a pad aware 
  s_stream operation.
- Picked up patch for incorrect media bus format.
- Removed Ulrich patches which now have been picked up in media_tree.

Laurent Pinchart (2):
  media: entity: Add has_route entity operation
  media: entity: Add media_entity_has_route() function

Niklas Söderlund (14):
  [media] rcar-vin: add legacy mode for wrong media bus formats
  [media] rcar-vin: return correct error from platform_get_irq
  [media] rcar-vin: do not use v4l2_device_call_until_err()
  [media] rcar-vin: cosmetic clean up in preparation for Gen3
  [media] rcar-vin: add dependency on MEDIA_CONTROLLER
  [media] rcar-vin: move chip check for pixelformat support
  [media] rcar-vin: rework how subdeivce is found and bound
  [media] rcar-vin: move media bus information to struct
    rvin_graph_entity
  [media] rcar-vin: add abstraction layer to interact with subdevices
  [media] rcar-vin: allow subdevices to be bound late
  [media] rcar-vin: add Gen3 HW registers
  [media] rcar-vin: add shared subdevice groups
  [media] rcar-vin: enable Gen3
  [media] rcar-vin: add Gen2 and Gen3 fallback compatibility strings

 .../devicetree/bindings/media/rcar_vin.txt         |  218 +++-
 drivers/media/media-entity.c                       |   29 +
 drivers/media/platform/rcar-vin/Kconfig            |    4 +-
 drivers/media/platform/rcar-vin/Makefile           |    2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |  461 +++++---
 drivers/media/platform/rcar-vin/rcar-dma.c         |  212 +++-
 drivers/media/platform/rcar-vin/rcar-group.c       | 1250 ++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-group.h       |  104 ++
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  466 ++++----
 drivers/media/platform/rcar-vin/rcar-vin.h         |   73 +-
 include/media/media-entity.h                       |    8 +
 11 files changed, 2339 insertions(+), 488 deletions(-)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.h

-- 
2.9.0

