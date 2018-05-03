Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34864 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbeECNg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:27 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 00/11] R-Car DU Interlaced support through VSP1
Date: Thu,  3 May 2018 14:36:11 +0100
Message-Id: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Gen3 R-Car DU devices make use of the VSP to handle frame processing.

In this series we implement support for handling interlaced pipelines by using
the auto-fld feature of the VSP hardware.

The implementation is preceded by some cleanup work and refactoring, through
patches 1 to 6. These are trivial and could be collected earlier and
independently if this series requires further revisions.

Patch 7 makes a key distinctive change to remove all existing support for
headerless display lists throughout the VSP1 driver, and ensures that all
pipelines use the same code path. This simplifies the code and reduces
opportunity for untested code paths to exist.

Patches 8, 9 and 10 implement the relevant support in the VSP1 driver, before
patch 11 finally enables the feature through the drm R-Car DU driver.

This series is based upon my previous TLB optimise and body rework (v9), and is
available from the following URL:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git
  tags/vsp1/du/interlaced/v4

ChangeLog:

v4:
 - Move configure_partition() call changes into tlb-optimise-v9

v3:
 - Rebased on top of TLB Optimise rework v8
 - Added the DL parameter back into the configure_partition() calls.
   - This change could be moved into the TLB-Optimise series.
 - Document interlaced field in struct vsp1_du_atomic_config

v2:
 - media: vsp1: use kernel __packed for structures
    became:
   media: vsp1: Remove packed attributes from aligned structures

 - media: vsp1: Add support for extended display list headers
   - No longer declares structs __packed

 - media: vsp1: Provide support for extended command pools
   - Fix spelling typo in commit message
   - constify, and staticify the instantiation of vsp1_extended_commands
   - s/autfld_cmds/autofld_cmds/
   - staticify cmd pool functions (Thanks kbuild-bot)

 - media: vsp1: Support Interlaced display pipelines
   - fix erroneous BIT value which enabled interlaced
   - fix field handling at frame_end interrupt

Kieran Bingham (11):
  media: vsp1: drm: Fix minor grammar error
  media: vsp1: Remove packed attributes from aligned structures
  media: vsp1: Rename dl_child to dl_next
  media: vsp1: Remove unused display list structure field
  media: vsp1: Clean up DLM objects on error
  media: vsp1: Provide VSP1 feature helper macro
  media: vsp1: Use header display lists for all WPF outputs linked to the DU
  media: vsp1: Add support for extended display list headers
  media: vsp1: Provide support for extended command pools
  media: vsp1: Support Interlaced display pipelines
  drm: rcar-du: Support interlaced video output through vsp1

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  |   1 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |   3 +-
 drivers/media/platform/vsp1/vsp1.h      |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c   | 407 +++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h   |  32 +-
 drivers/media/platform/vsp1/vsp1_drm.c  |  13 +-
 drivers/media/platform/vsp1/vsp1_drv.c  |  23 +-
 drivers/media/platform/vsp1/vsp1_regs.h |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  |  71 +++-
 drivers/media/platform/vsp1/vsp1_rwpf.h |   1 +-
 drivers/media/platform/vsp1/vsp1_wpf.c  |   6 +-
 include/media/vsp1.h                    |   2 +-
 12 files changed, 456 insertions(+), 112 deletions(-)

base-commit: de53826416ea9c22ee985d1f0291aab7d7ea94ce
-- 
git-series 0.9.1
