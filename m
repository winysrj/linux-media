Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37356 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973AbcDYVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 17:36:20 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH v2 00/13] R-Car VSP improvements for v4.7 - Round 2
Date: Tue, 26 Apr 2016 00:36:25 +0300
Message-Id: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series is the second version of the second (and most probably last)
round of vsp1 driver improvements for v4.7. In particular, it enables runtime
PM support (03/13 and 04/13), adds support for the FCP (01/13, 02/13 and
05/13), prepare for HGO (histogram) support (06/13 to 09/13) and update the
API towards the DRM driver (10/13 to 13/13).

The FCP is a companion module of video processing modules in the Renesas R-Car
Gen3 SoCs. It provides data compression and decompression, data caching, and
conversion of AXI transaction in order to reduce the memory bandwidth. The FCP
driver is not meant to be used standalone but provides an API to the video
processing modules to control the FCP.

The API towards the DRM driver is updated to store all configuration
parameters in a structure in order to improve readability and make future
updates easier. This series contain two R-Car DU DRM patches that update the
DU DRM driver to the new API. They would normally be merged through Dave
Airlie's tree, but due to dependencies on VSP1 patches queued up for v4.7 Dave
agreed to get them merged through the linux-media tree (hence his Acked-by for
the two patches). They should not conflict with any patch queued up for v4.7
through Dave's tree.

Note that patch 10/13 adds some macro magic to make the API transition easier.
Depending on your taste you will find the implementation beautiful or ugly,
but in any case patch 13/13 removes the macros and inline wrapper.

The code is based on top of the latest linux-media master branch. For
convenience I've pushed the patches to the following git tree branch.
patches on top of the latest Linux media master branch to

        git://linuxtv.org/pinchartl/media.git vsp1/next

Changes since v1:

- Fixed typos
- Made rcar_fcp_enable() return a status
- Dropped the unneeded dependency on PM for the VSP driver

Cc: devicetree@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>

Laurent Pinchart (13):
  dt-bindings: Add Renesas R-Car FCP DT bindings
  v4l: Add Renesas R-Car FCP driver
  v4l: vsp1: Implement runtime PM support
  v4l: vsp1: Don't handle clocks manually
  v4l: vsp1: Add FCP support
  v4l: vsp1: Add output node value to routing table
  v4l: vsp1: Replace container_of() with dedicated macro
  v4l: vsp1: Make vsp1_entity_get_pad_compose() more generic
  v4l: vsp1: Move frame sequence number from video node to pipeline
  v4l: vsp1: Group DRM RPF parameters in a structure
  drm: rcar-du: Add alpha support for VSP planes
  drm: rcar-du: Add Z-order support for VSP planes
  v4l: vsp1: Remove deprecated DRM API

 .../devicetree/bindings/media/renesas,fcp.txt      |  31 ++++
 .../devicetree/bindings/media/renesas,vsp1.txt     |   5 +
 MAINTAINERS                                        |  10 ++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |  45 ++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h              |   2 +
 drivers/media/platform/Kconfig                     |  14 ++
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/rcar-fcp.c                  | 181 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1.h                 |   6 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |  68 ++++----
 drivers/media/platform/vsp1/vsp1_drv.c             | 120 +++++++-------
 drivers/media/platform/vsp1/vsp1_entity.c          |  86 +++++++---
 drivers/media/platform/vsp1/vsp1_entity.h          |  12 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |   7 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   4 +-
 drivers/media/platform/vsp1/vsp1_video.h           |   1 -
 include/media/rcar-fcp.h                           |  37 +++++
 include/media/vsp1.h                               |  29 ++--
 20 files changed, 494 insertions(+), 171 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt
 create mode 100644 drivers/media/platform/rcar-fcp.c
 create mode 100644 include/media/rcar-fcp.h

-- 
Regards,

Laurent Pinchart

