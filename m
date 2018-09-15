Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48068 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbeIOTxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 15:53:23 -0400
Received: from avalon.localnet (unknown [IPv6:2a02:a03f:445f:eb00:2fe7:4d9d:1e65:8525])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 727FACE
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2018 16:34:11 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.20] R-Car VSP1 changes
Date: Sat, 15 Sep 2018 17:34:25 +0300
Message-ID: <1963797.BROc79MLIv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 
11:21:52 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/vsp1-next-20180914

for you to fetch changes up to 585e8c594967672aeca0ec90a6472f7c13dc30a2:

  media: vsp1: Document max_width restriction on UDS (2018-09-15 17:27:37 
+0300)

----------------------------------------------------------------
R-Car VSP1 changes for v4.20

----------------------------------------------------------------
Kieran Bingham (5):
      MAINTAINERS: VSP1: Add co-maintainer
      media: vsp1: Remove artificial minimum width/height limitation
      media: vsp1: use periods at the end of comment sentences
      media: vsp1: Document max_width restriction on SRU
      media: vsp1: Document max_width restriction on UDS

Koji Matsuoka (1):
      media: vsp1: Fix YCbCr planar formats pitch calculation

Laurent Pinchart (2):
      media: vsp1: Fix vsp1_regs.h license header
      media: vsp1: Update LIF buffer thresholds

 MAINTAINERS                               |  1 +
 drivers/media/platform/vsp1/vsp1_brx.c    |  4 ++--
 drivers/media/platform/vsp1/vsp1_drm.c    | 11 ++++++++++-
 drivers/media/platform/vsp1/vsp1_drv.c    |  6 +++---
 drivers/media/platform/vsp1/vsp1_entity.c |  2 +-
 drivers/media/platform/vsp1/vsp1_lif.c    | 29 +++++++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_regs.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  4 ++--
 drivers/media/platform/vsp1/vsp1_sru.c    |  7 ++++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 14 +++++++++++---
 drivers/media/platform/vsp1/vsp1_video.c  |  9 +++------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  2 +-
 include/media/vsp1.h                      |  2 +-
 13 files changed, 67 insertions(+), 26 deletions(-)

-- 
Regards,

Laurent Pinchart
