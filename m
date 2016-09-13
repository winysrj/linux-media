Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46911 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbcIMXQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 00/13] Renesas R-Car VSP: Scaling and rotation support on Gen3
Date: Wed, 14 Sep 2016 02:16:53 +0300
Message-Id: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds support for scaling and rotation to the VSP1 driver on
the R-Car Gen3 SoCs.

Unlike Gen2 that can scale full resolution images, the Gen3 VSP scaler has a
width limitation that prevent full images from being processed in one go. They
must be partitioned in slices that are then processed individually. The
rotation engine present in the Gen3 VSP has a similar limitation, and so does
the SRU.

The hardware supports queuing processing of multiple slices without generating
any interrupt between slices, so partitioning the image will not raise the
number of interrupts. It however has an impact on CPU usage as the register
settings for each partitions need to be computed, but there's no way around
that.

The series starts with bug fixes (patches 01/13 to 04/13), followed by a few
preparatory changes (patches 05/13 to 07/13). Patches 08/13 to 12/13 then
implement image partitioning support, and patch 13/13 finally adds rotation
support.

All the changes have been tests with the VSP test suite available at

	git://git.ideasonboard.com/renesas/vsp-tests.git master

on both Gen2 (H2 Lager) and Gen3 (H3 Salvator-X) boards. No regression has
been noticed.

Kieran Bingham (6):
  v4l: vsp1: Ensure pipeline locking in resume path
  v4l: vsp1: Repair race between frame end and qbuf handler
  v4l: vsp1: Use DFE instead of FRE for frame end
  v4l: vsp1: Support chained display lists
  v4l: vsp1: Determine partition requirements for scaled images
  v4l: vsp1: Support multiple partitions per frame

Laurent Pinchart (7):
  v4l: vsp1: Prevent pipelines from running when not streaming
  v4l: vsp1: Protect against race conditions between get and set format
  v4l: vsp1: Disable cropping on WPF sink pad
  v4l: vsp1: Fix RPF cropping
  v4l: vsp1: Pass parameter type to entity configuration operation
  v4l: vsp1: Replace .set_memory() with VSP1_ENTITY_PARAMS_PARTITION
  v4l: vsp1: wpf: Implement rotation support

 drivers/media/platform/vsp1/vsp1_bru.c    |  33 +++-
 drivers/media/platform/vsp1/vsp1_clu.c    |  61 ++++---
 drivers/media/platform/vsp1/vsp1_dl.c     | 119 ++++++++++---
 drivers/media/platform/vsp1/vsp1_dl.h     |   1 +
 drivers/media/platform/vsp1/vsp1_drm.c    |  15 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  22 ++-
 drivers/media/platform/vsp1/vsp1_entity.h |  25 ++-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  20 ++-
 drivers/media/platform/vsp1/vsp1_lif.c    |  20 ++-
 drivers/media/platform/vsp1/vsp1_lut.c    |  42 +++--
 drivers/media/platform/vsp1/vsp1_pipe.c   |   3 +
 drivers/media/platform/vsp1/vsp1_pipe.h   |   8 +
 drivers/media/platform/vsp1/vsp1_rpf.c    | 106 +++++++-----
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  86 ++++++----
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  16 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |  50 +++++-
 drivers/media/platform/vsp1/vsp1_uds.c    |  71 ++++++--
 drivers/media/platform/vsp1/vsp1_video.c  | 188 ++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_wpf.c    | 274 ++++++++++++++++++++++--------
 20 files changed, 880 insertions(+), 282 deletions(-)

-- 
Regards,

Laurent Pinchart

