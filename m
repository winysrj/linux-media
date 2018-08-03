Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50406 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbeHCNdc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:33:32 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 00/11] R-Car DU Interlaced support through VSP1
Date: Fri,  3 Aug 2018 12:37:19 +0100
Message-Id: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

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

This series is based upon the linux-media tree (master branch), and is
available from the following URL:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git
  tags/vsp1/du/interlaced/v6

ChangeLog:

v6:
 * media: vsp1: use kernel __packed for structures
   - Reintroduced __packed on relevant structures

 * media: vsp1: Add support for extended display list headers
   - Fix minor review comments
   - Update newly added hardware VSP1 structures with __packed attribute

 * media: vsp1: Provide support for extended command pools
   - Extraneous blank line removed

 * media: vsp1: Support Interlaced display pipelines
   - Remove feature check on extended display lists
     (validating interlaced support should be handled in the DU)
   - Add __packed to struct vsp1_extcmd_auto_fld_body

v5:
 * media: vsp1: Use header display lists for all WPF outputs linked to the DU
   - Fixed comments
   - Re-aligned header_offset calculation
 * media: vsp1: Add support for extended display list headers
   - Rename vsp1_dl_ext_header field names
   - Rename @extended -> @extension
   - Remove unnecessary VI6_DL_SWAP changes
   - Rename @cmd_opcode -> @opcode
   - Drop unused @data_size field
   - Move iteration of WPF's inside vsp1_dlm_setup
   - Rename vsp1_dl_ext_cmd_header -> vsp1_pre_ext_dl_body
   - Rename vsp1_pre_ext_dl_body->cmd to vsp1_pre_ext_dl_body->opcode
   - Rename vsp1_dl_ext_header->reserved0 to vsp1_dl_ext_header->padding
   - vsp1_pre_ext_dl_body: Rename 'data' to 'address_set'
   - vsp1_pre_ext_dl_body: Add struct documentation
   - Document ordering of 16bit accesses for flags in vsp1_dl_ext_header
 * media: vsp1: Provide support for extended command pools
   - Rename vsp1_dl_ext_cmd_header -> vsp1_pre_ext_dl_body
   - fixup vsp1_cmd_pool structure documentation
   - Rename dlm->autofld_cmds dlm->cmdpool
   - Separate out the instatiation of vsp1_extended_commands
   - Move initialisation of lock, and lists in vsp1_dl_cmd_pool_create to
     immediately after allocation
   - simplify vsp1_dlm_get_autofld_cmd
   - Rename vsp1_dl_get_autofld_cmd() to vsp1_dl_get_pre_cmd() and moved
     to "Display List Extended Command Management" section of vsp1_dl
 * media: vsp1: Support Interlaced display pipelines
   - Obtain autofld cmd in vsp1_rpf_configure_autofld()
   - Move VSP1_DL_EXT_AUTOFLD_INT to vsp1_regs.h
   - Rename VSP1_DL_EXT_AUTOFLD_INT -> VI6_DL_EXT_AUTOFLD_INT
   - move interlaced configuration parameter to pipe object
   - autofld: Set cmd->flags in one single expression.
 * drm: rcar-du: Support interlaced video output through vsp1
   - Fix commit title
   - Document change to DSMR
   - Configure through vsp1_du_setup_lif(), rather than
     vsp1_du_atomic_update()

v4.5:
 - Rebase to latest linux-media/master

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
  media: vsp1: use kernel __packed for structures
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
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |   1 +-
 drivers/media/platform/vsp1/vsp1.h      |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c   | 432 +++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h   |  28 ++-
 drivers/media/platform/vsp1/vsp1_drm.c  |   8 +-
 drivers/media/platform/vsp1/vsp1_drv.c  |  20 +-
 drivers/media/platform/vsp1/vsp1_pipe.h |   2 +-
 drivers/media/platform/vsp1/vsp1_regs.h |   5 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  |  72 +++-
 drivers/media/platform/vsp1/vsp1_wpf.c  |   6 +-
 include/media/vsp1.h                    |   2 +-
 12 files changed, 470 insertions(+), 110 deletions(-)

base-commit: 2c3449fb95c318920ca8dc645d918d408db219ac
-- 
git-series 0.9.1
