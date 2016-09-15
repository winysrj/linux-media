Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52574 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755327AbcIOWDr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 18:03:47 -0400
Received: from avalon.localnet (dfj612yywbrz---v8rgfy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:120b:a9ff:fe3c:7148])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 4E42120035
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 00:03:14 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] R-Car VSP1 fixes and features
Date: Fri, 16 Sep 2016 01:04:29 +0300
Message-ID: <2597519.9ICdzoYvx9@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's my (if all goes well last) pull request for the VSP1 driver for v4.9. 
As discussed over IRC I've dropped the rotation patch as it's still requires 
discussions. The rest should not be controversial, it's a bunch of fixes 
(mostly for race conditions), a bit of refactoring, dropping support for 
features that the hardware doesn't actually support, and implementation of 
image partitioning to enable scaling on Gen3 SoCs (without any change to the 
userspace API).

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 7fccbd66953e10deaa4725cff560e149deee66f5:

  v4l: vsp1: Disable VYUY on Gen3 (2016-09-15 22:14:02 +0300)

----------------------------------------------------------------
Kieran Bingham (6):
      v4l: vsp1: Ensure pipeline locking in resume path
      v4l: vsp1: Repair race between frame end and qbuf handler
      v4l: vsp1: Use DFE instead of FRE for frame end
      v4l: vsp1: Support chained display lists
      v4l: vsp1: Determine partition requirements for scaled images
      v4l: vsp1: Support multiple partitions per frame

Laurent Pinchart (8):
      v4l: vsp1: Prevent pipelines from running when not streaming
      v4l: vsp1: Protect against race conditions between get and set format
      v4l: vsp1: Disable cropping on WPF sink pad
      v4l: vsp1: Fix RPF cropping
      v4l: vsp1: Pass parameter type to entity configuration operation
      v4l: vsp1: Replace .set_memory() with VSP1_ENTITY_PARAMS_PARTITION
      v4l: vsp1: Fix spinlock in mixed IRQ context function
      v4l: vsp1: Disable VYUY on Gen3

 drivers/media/platform/vsp1/vsp1_bru.c    |  33 +++++--
 drivers/media/platform/vsp1/vsp1_clu.c    |  61 ++++++++-----
 drivers/media/platform/vsp1/vsp1_dl.c     | 119 ++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_dl.h     |   1 +
 drivers/media/platform/vsp1/vsp1_drm.c    |  17 ++--
 drivers/media/platform/vsp1/vsp1_drv.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  22 ++++-
 drivers/media/platform/vsp1/vsp1_entity.h |  25 +++--
 drivers/media/platform/vsp1/vsp1_hsit.c   |  20 ++--
 drivers/media/platform/vsp1/vsp1_lif.c    |  20 ++--
 drivers/media/platform/vsp1/vsp1_lut.c    |  42 ++++++---
 drivers/media/platform/vsp1/vsp1_pipe.c   |  11 ++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  11 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 106 ++++++++++++++--------
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  81 +++++++++++------
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  13 ---
 drivers/media/platform/vsp1/vsp1_sru.c    |  50 ++++++++--
 drivers/media/platform/vsp1/vsp1_uds.c    |  71 ++++++++++++---
 drivers/media/platform/vsp1/vsp1_video.c  | 186 ++++++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_wpf.c    | 129 ++++++++++++++++----------
 20 files changed, 754 insertions(+), 266 deletions(-)

-- 
Regards,

Laurent Pinchart

