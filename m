Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA3BC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285812177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="CopHzcWe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfCMAFp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:45 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42032 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfCMAFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:45 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6A7E92DF;
        Wed, 13 Mar 2019 01:05:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435543;
        bh=9lZSm9Sxjmc+v9BmqU8FSeqPVDwZxayeSzX3obex8xs=;
        h=From:To:Cc:Subject:Date:From;
        b=CopHzcWeatXYCEvWMFFAN6gfFWv2pGa6XGcpr+dsTGvZfoHC10EAaugzyhOFIWsiN
         zdPIkK1O1yrMlqRLEy1NQrnI5EpOPA24/uk4tKr1SXMK8HXEdOkzUoGrNzb4Hpd9kJ
         jHmsqpZ+QvykmkDDq3ba4MpXHBDX06aWoW16csEI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 00/18] R-Car DU display writeback support
Date:   Wed, 13 Mar 2019 02:05:14 +0200
Message-Id: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello everybody,

This patch series implements display writeback support for the R-Car
Gen3 platforms in the VSP1 and DU drivers.

Patches 01/18 to 11/18 prepare the VSP1 driver for writeback support
with all the necessary plumbing, including extensions of the API between
the VSP1 and DU drivers.

Compared to v5 the major change is the usage of chained display lists in
the VSP to disable writeback after one frame, instead of patching the
active display list in memory. This should solve the potential DMA to
released buffer issue that could occur when the frame start interrupt
was delayed after frame end. Patch 06/18 and 07/18 are new in this
version to support usage of chained display pipelines.

Compared to v4 the major change is the move from V4L2 to DRM writeback
connectors for the userspace API. This has caused a few issues with
writeback support to be uncovered, and they are addressed by patches
12/18 to 14/18.

Patches 15/18 to 17/18 then perform refactoring of the DU driver, to
finally add writeback support in patch 18/18.

The writeback pixel format is restricted to RGB, due to the VSP1
outputting RGB to the display and lacking a separate colour space
conversion unit for writeback. The writeback framebuffer size must match
the active mode, writeback scaling is not supported by the hardware.

Writeback requests being part of atomic commits, they're queued to the
hardware when they are received, become active at the next vblank, and
complete on the following vblank. The display list chaining mechanism
ensures that writeback will be enabled for a single frame only, unless
the next atomic commit contains a separate writeback request.

The code is based on a merge of the media master branch, the drm-next
branch and the R-Car DT next branch. For convenience patches can be
found at

        git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback

Kieran Bingham (1):
  Revert "[media] v4l: vsp1: Supply frames to the DU continuously"

Laurent Pinchart (17):
  media: vsp1: wpf: Fix partition configuration for display pipelines
  media: vsp1: Replace leftover occurrence of fragment with body
  media: vsp1: Fix addresses of display-related registers for VSP-DL
  media: vsp1: Replace the display list internal flag with a flags field
  media: vsp1: Add vsp1_dl_list argument to .configure_stream()
    operation
  media: vsp1: dl: Allow chained display lists for display pipelines
  media: vsp1: wpf: Add writeback support
  media: vsp1: drm: Split RPF format setting to separate function
  media: vsp1: drm: Extend frame completion API to the DU driver
  media: vsp1: drm: Implement writeback support
  drm: writeback: Cleanup job ownership handling when queuing job
  drm: writeback: Fix leak of writeback job
  drm: writeback: Add job prepare and cleanup operations
  drm: rcar-du: Fix rcar_du_crtc structure documentation
  drm: rcar-du: Store V4L2 fourcc in rcar_du_format_info structure
  drm: rcar-du: vsp: Extract framebuffer (un)mapping to separate
    functions
  drm: rcar-du: Add writeback support for R-Car Gen3

 drivers/gpu/drm/arm/malidp_mw.c             |   3 +-
 drivers/gpu/drm/drm_atomic_helper.c         |  11 +
 drivers/gpu/drm/drm_atomic_state_helper.c   |   4 +
 drivers/gpu/drm/drm_atomic_uapi.c           |  31 +--
 drivers/gpu/drm/drm_writeback.c             |  73 +++++-
 drivers/gpu/drm/rcar-du/Kconfig             |   4 +
 drivers/gpu/drm/rcar-du/Makefile            |   3 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c      |   7 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h      |   9 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c       |  37 +++
 drivers/gpu/drm/rcar-du/rcar_du_kms.h       |   1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c       | 121 +++++-----
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h       |  17 ++
 drivers/gpu/drm/rcar-du/rcar_du_writeback.c | 243 ++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_writeback.h |  39 ++++
 drivers/gpu/drm/vc4/vc4_txp.c               |   2 +-
 drivers/media/platform/vsp1/vsp1_brx.c      |   1 +
 drivers/media/platform/vsp1/vsp1_clu.c      |   1 +
 drivers/media/platform/vsp1/vsp1_dl.c       |  84 ++++---
 drivers/media/platform/vsp1/vsp1_dl.h       |   5 +-
 drivers/media/platform/vsp1/vsp1_drm.c      |  94 +++++---
 drivers/media/platform/vsp1/vsp1_drm.h      |   2 +-
 drivers/media/platform/vsp1/vsp1_entity.c   |   3 +-
 drivers/media/platform/vsp1/vsp1_entity.h   |   7 +-
 drivers/media/platform/vsp1/vsp1_hgo.c      |   1 +
 drivers/media/platform/vsp1/vsp1_hgt.c      |   1 +
 drivers/media/platform/vsp1/vsp1_hsit.c     |   1 +
 drivers/media/platform/vsp1/vsp1_lif.c      |   1 +
 drivers/media/platform/vsp1/vsp1_lut.c      |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h     |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c      |   1 +
 drivers/media/platform/vsp1/vsp1_rwpf.h     |   2 +
 drivers/media/platform/vsp1/vsp1_sru.c      |   1 +
 drivers/media/platform/vsp1/vsp1_uds.c      |   1 +
 drivers/media/platform/vsp1/vsp1_uif.c      |   1 +
 drivers/media/platform/vsp1/vsp1_video.c    |  16 +-
 drivers/media/platform/vsp1/vsp1_wpf.c      |  90 ++++++--
 include/drm/drm_modeset_helper_vtables.h    |   7 +
 include/drm/drm_writeback.h                 |  30 ++-
 include/media/vsp1.h                        |  19 +-
 40 files changed, 781 insertions(+), 200 deletions(-)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.h

-- 
Regards,

Laurent Pinchart

