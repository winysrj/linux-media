Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54319 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbeDEJSe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 00/15] R-Car VSP1: Dynamically assign blend units to display pipelines
Date: Thu,  5 Apr 2018 12:18:25 +0300
Message-Id: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On R-Car H3 ES2.0+ and M3-N SoCs, two display pipelines are served by the same
VSP instance (named VSPDL). The VSPDL includes two blending units named BRU
and BRS, unlike the other display-related VSPD that serves a single display
channel with a single blending unit.

The VSPDL has five inputs and can freely assign them at runtime to two display
pipelines, using the BRU and BRS to blend multiple inputs. The BRU supports
blending up to five inputs, while the BRS is limited to two inputs.

Each display pipeline requires a blending unit, and the BRU and BRS are
currently assigned statically to the first and second pipeline respectively.
This artificially limits the number of inputs for the second pipeline to two.
To overcome that limitation, the BRU and BRS need to be dynamically assigned
to the display pipelines, which is what this patch series does.

Patches 01/15 to 10/15 perform small cleanups and refactoring to prepare for
the rest of the series. Patches 11/15 and 12/15 implement new internal
features for the same purpose, and patch 13/15 performs the bulk of the work
by implementing dynamic BRU and BRS assignment to pipelines.

Reassigning the BRU and BRS when two pipelines are running results in flicker
as one pipeline has to first release its blending unit. Synchronization
between the two pipelines also require locking that effectively serializes
page flips for the two pipelines, even when not interacting with each other.
This is currently believed to be unavoidable due to the hardware design, but
please feel free to prove me wrong (ideally with a patch - one can always
dream).

Patch 14/15 then adds messages useful for debugging this new feature. I have
kept it separate from 13/15 to make it easier to remove those messages once
dynamic assignment of blending units will be deemed perfectly stable, but I
won't oppose squashing it with 13/15 if that is preferred.

Patch 15/15 finally rename BRU to BRx to avoid confusion between the BRU terms
that refer to the BRU in particular, and the ones that refer to any of the BRU
or BRS. As this might be a bit controversial I've put the patch last in the
series in case it needs to be dropped.

I have decided to CC the dri-devel mailing list even though the code doesn't
touch the R-Car DU driver and will be merged through the Linux media tree as
the display is involved and the series could benefit from the expertise of the
DRM/KMS community from that point of view.

The patches are based on top of the latest Linux media master branch. For
convenience their are available from

	git://linuxtv.org/pinchartl/media.git v4l2-vsp1-bru-brs-v2-20180405

The series passes the DU test suite with the new BRx dynamic assignment
test available from

	git://git.ideasonboard.com/renesas/kms-tests.git bru-brs

The VSP test suite also runs without any noticed regression.

Since v1, patch 10/15 has been added an the v1 02/15 patch merged with
01/15. Other small changes are documented in individual changelogs.

Laurent Pinchart (15):
  v4l: vsp1: Don't start/stop media pipeline for DRM
  v4l: vsp1: Remove unused field from vsp1_drm_pipeline structure
  v4l: vsp1: Store pipeline pointer in vsp1_entity
  v4l: vsp1: Use vsp1_entity.pipe to check if entity belongs to a
    pipeline
  v4l: vsp1: Share duplicated DRM pipeline configuration code
  v4l: vsp1: Move DRM atomic commit pipeline setup to separate function
  v4l: vsp1: Setup BRU at atomic commit time
  v4l: vsp1: Replace manual DRM pipeline input setup in
    vsp1_du_setup_lif
  v4l: vsp1: Move DRM pipeline output setup code to a function
  v4l: vsp1: Turn frame end completion status into a bitfield
  v4l: vsp1: Add per-display list internal completion notification
    support
  v4l: vsp1: Generalize detection of entity removal from DRM pipeline
  v4l: vsp1: Assign BRU and BRS to pipelines dynamically
  v4l: vsp1: Add BRx dynamic assignment debugging messages
  v4l: vsp1: Rename BRU to BRx

 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   6 +-
 .../media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} | 202 ++---
 .../media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} |  18 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |  45 +-
 drivers/media/platform/vsp1/vsp1_dl.h              |   7 +-
 drivers/media/platform/vsp1/vsp1_drm.c             | 828 ++++++++++++---------
 drivers/media/platform/vsp1/vsp1_drm.h             |  16 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   8 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |   2 +
 drivers/media/platform/vsp1/vsp1_histo.c           |   2 +-
 drivers/media/platform/vsp1/vsp1_histo.h           |   3 -
 drivers/media/platform/vsp1/vsp1_pipe.c            |  53 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |  12 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  39 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   8 +-
 18 files changed, 718 insertions(+), 543 deletions(-)
 rename drivers/media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} (63%)
 rename drivers/media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} (66%)

-- 
Regards,

Laurent Pinchart
