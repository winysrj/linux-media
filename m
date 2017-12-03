Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53674 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdLCK5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:34 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/9] R-Car DU: Support CRC calculation
Date: Sun,  3 Dec 2017 12:57:26 +0200
Message-Id: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds support for CRC calculation to the rcar-du-drm driver.

CRC calculation is supported starting at the Renesas R-Car Gen3 SoCs, as
earlier versions don't have the necessary hardware. On Gen3 SoCs, the CRC is
computed by the DISCOM module part of the VSP-D and VSP-DL.

The DISCOM is interfaced to the VSP through the UIF glue and appears as a VSP
entity with a sink pad and a source pad.

The series starts with two fixes. Patch 1/9 fixes a display stall when
requesting more than two planes from the VGA output. It is a temporary fix to
avoid complete stalls during unit testing, and a better fix will follow but
will take longer to develop. Patch 2/9 then fixes debug messages that confused
me when I was debugging the rest of this patch series.

The series then continues with cleanup and refactoring. Patches 3/9 and 4/9
prepare for DISCOM and UIF support by extending generic code to make it usable
for the UIF. Patch 5/9 documents a structure that will receive new fields.

Patch 6/9 then extends the API exposed by the VSP driver to the DU driver to
support CRC computation configuration and reporting. The patch unfortunately
needs to touch both the VSP and DU drivers. The whole series will need to be
merged through a single tree, I will check when it will be time to submit a
pull request which option would generate the least conflicts.

Patch 7/9 adds support for the DISCOM and UIF in the VSP driver, patch 8/9
integrates it in the DRM pipeline, and patch 9/9 finally implements the CRC
API in the DU driver to expose CRC computation to userspace.

The hardware supports computing the CRC at any arbitrary point in the
pipeline on a configurable window of the frame. This patch series supports CRC
computation on input planes or pipeline output, but on the full frame only.
Support for CRC window configuration can be added later if needed but will
require extending the userspace API, as the DRM/KMS CRC API doesn't support
this feature.

Note that exposing the DISCOM and UIF though the V4L2 API isn't supported as
the module is only found in VSP-D and VSP-DL instances that are not exposed
through V4L2. It is possible to expose those instances through V4L2 with a
small modification to the driver for testing purpose. If the need arises to
test DISCOM and UIF with such an out-of-tree patch, support for CRC reporting
through a V4L2 control can be added later without affecting how CRC is exposed
through the DRM/KMS API.

The patches are based on top of a merge of the Linux media master branch and
the pending DU patches. For convenience they are available at

	git://linuxtv.org/pinchartl/media.git vsp1-discom-v1-20171203

The code has been tested through the kms-test-crc.py script part of the DU
test suite available at

	git://git.ideasonboard.com/renesas/kms-tests.git discom


Laurent Pinchart (9):
  v4l: vsp1: Fix display stalls when requesting too many inputs
  v4l: vsp1: Print the correct blending unit name in debug messages
  v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
  v4l: vsp1: Reset the crop and compose rectangles in the set_fmt helper
  v4l: vsp1: Document the vsp1_du_atomic_config structure
  v4l: vsp1: Extend the DU API to support CRC computation
  v4l: vsp1: Add support for the DISCOM entity
  v4l: vsp1: Integrate DISCOM in display pipeline
  drm: rcar-du: Add support for CRC computation

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 148 +++++++++++++++-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |  19 +++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  13 +-
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   4 +
 drivers/media/platform/vsp1/vsp1_clu.c    |  65 ++-----
 drivers/media/platform/vsp1/vsp1_drm.c    | 138 +++++++++++++--
 drivers/media/platform/vsp1/vsp1_drm.h    |  14 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |  20 +++
 drivers/media/platform/vsp1/vsp1_entity.c |  97 +++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |   7 +
 drivers/media/platform/vsp1/vsp1_histo.c  |  59 +------
 drivers/media/platform/vsp1/vsp1_lif.c    |  65 ++-----
 drivers/media/platform/vsp1/vsp1_lut.c    |  65 ++-----
 drivers/media/platform/vsp1/vsp1_regs.h   |  41 +++++
 drivers/media/platform/vsp1/vsp1_uif.c    | 275 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_uif.h    |  36 ++++
 include/media/vsp1.h                      |  39 ++++-
 18 files changed, 870 insertions(+), 237 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h

-- 
Regards,

Laurent Pinchart
