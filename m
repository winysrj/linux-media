Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41723 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbeCMSFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:36 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 00/11] R-Car DU Interlaced support through VSP1
Date: Tue, 13 Mar 2018 19:05:16 +0100
Message-Id: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
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

This series is based upon my previous TLB optimise and body rework (v7), and is
available from the following URL:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git
  tags/vsp1/du/interlaced/v2

ChangeLog:

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
 drivers/media/platform/vsp1/vsp1_dl.c   | 406 +++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h   |  32 +-
 drivers/media/platform/vsp1/vsp1_drm.c  |  13 +-
 drivers/media/platform/vsp1/vsp1_drv.c  |  23 +-
 drivers/media/platform/vsp1/vsp1_regs.h |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  |  72 +++-
 drivers/media/platform/vsp1/vsp1_rwpf.h |   1 +-
 drivers/media/platform/vsp1/vsp1_wpf.c  |   6 +-
 include/media/vsp1.h                    |   1 +-
 12 files changed, 455 insertions(+), 112 deletions(-)

base-commit: 397eb3811ec096d0ceefa1dbea2d0ae68feb0587
-- 
git-series 0.9.1
