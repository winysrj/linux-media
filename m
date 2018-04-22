Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46458 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753700AbeDVWeZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 18:34:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 0/8] R-Car DU: Support CRC calculation
Date: Mon, 23 Apr 2018 01:34:22 +0300
Message-Id: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds support for CRC calculation to the rcar-du-drm driver.

CRC calculation is supported starting at the Renesas R-Car Gen3 SoCs, as
earlier versions don't have the necessary hardware. On Gen3 SoCs, the CRC is
computed by the DISCOM module part of the VSP-D and VSP-DL.

The DISCOM is interfaced to the VSP through the UIF glue and appears as a VSP
entity with a sink pad and a source pad.

The series starts with a switch to SPDX license headers in patch 1/8, prompted
by a checkpatch.pl warning for a later patch that complained about missing
SPDX license headers. It then continues with cleanup and refactoring. Patches
2/8 and 3/8 prepare for DISCOM and UIF support by extending generic code to
make it usable for the UIF. Patch 4/8 documents a structure that will receive
new fields.

Patch 5/8 then extends the API exposed by the VSP driver to the DU driver to
support CRC computation configuration and reporting. The patch unfortunately
needs to touch both the VSP and DU drivers, so the whole series will need to
be merged through a single tree.

Patch 5/8 adds support for the DISCOM and UIF in the VSP driver, patch 7/8
integrates it in the DRM pipeline, and patch 8/8 finally implements the CRC
API in the DU driver to expose CRC computation to userspace.

The hardware supports computing the CRC at any arbitrary point in the
pipeline on a configurable window of the frame. This patch series supports CRC
computation on input planes or pipeline output, but on the full frame only.
Support for CRC window configuration can be added later if needed but will
require extending the userspace API, as the DRM/KMS CRC API doesn't support
this feature.

Compared to v1, the CRC source names for plane inputs are now constructed from
plane IDs instead of plane indices. This allows userspace to match CRC sources
with planes.

Note that exposing the DISCOM and UIF though the V4L2 API isn't supported as
the module is only found in VSP-D and VSP-DL instances that are not exposed
through V4L2. It is possible to expose those instances through V4L2 with a
small modification to the driver for testing purpose. If the need arises to
test DISCOM and UIF with such an out-of-tree patch, support for CRC reporting
through a V4L2 control can be added later without affecting how CRC is exposed
through the DRM/KMS API.

The patches are based on top of the "[PATCH v2 00/15] R-Car VSP1: Dynamically
assign blend units to display pipelines" patch series, itself based on top of
the Linux media master branch and scheduled for merge in v4.18. The new base
caused heavy conflicts, requiring this series to be merged through the V4L2
tree. Once the patches receive the necessary review I will ask Dave to ack the
merge plan.

For convenience the patches are available at

        git://linuxtv.org/pinchartl/media.git vsp1-discom-v2-20180423

The code has been tested through the kms-test-crc.py script part of the DU
test suite available at

        git://git.ideasonboard.com/renesas/kms-tests.git discom

Laurent Pinchart (8):
  v4l: vsp1: Use SPDX license headers
  v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
  v4l: vsp1: Reset the crop and compose rectangles in the set_fmt helper
  v4l: vsp1: Document the vsp1_du_atomic_config structure
  v4l: vsp1: Extend the DU API to support CRC computation
  v4l: vsp1: Add support for the DISCOM entity
  v4l: vsp1: Integrate DISCOM in display pipeline
  drm: rcar-du: Add support for CRC computation

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 156 ++++++++++++++++-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |  19 +++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  13 +-
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |  10 +-
 drivers/media/platform/vsp1/vsp1_brx.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_brx.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_clu.c    |  71 ++------
 drivers/media/platform/vsp1/vsp1_clu.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_dl.c     |   8 +-
 drivers/media/platform/vsp1/vsp1_dl.h     |   6 +-
 drivers/media/platform/vsp1/vsp1_drm.c    | 127 ++++++++++++--
 drivers/media/platform/vsp1/vsp1_drm.h    |  20 ++-
 drivers/media/platform/vsp1/vsp1_drv.c    |  26 ++-
 drivers/media/platform/vsp1/vsp1_entity.c | 103 +++++++++++-
 drivers/media/platform/vsp1/vsp1_entity.h |  13 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgo.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgt.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgt.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_histo.c  |  65 +------
 drivers/media/platform/vsp1/vsp1_histo.h  |   6 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_hsit.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  71 ++------
 drivers/media/platform/vsp1/vsp1_lif.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  71 ++------
 drivers/media/platform/vsp1/vsp1_lut.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  46 ++++-
 drivers/media/platform/vsp1/vsp1_rpf.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_sru.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_uds.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_uif.c    | 271 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_uif.h    |  32 ++++
 drivers/media/platform/vsp1/vsp1_video.c  |   6 +-
 drivers/media/platform/vsp1/vsp1_video.h  |   6 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |   6 +-
 include/media/vsp1.h                      |  39 ++++-
 44 files changed, 896 insertions(+), 417 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h

-- 
Regards,

Laurent Pinchart
