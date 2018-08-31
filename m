Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44510 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbeHaSsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 14:48:38 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/6] VSP1 Updates
Date: Fri, 31 Aug 2018 15:40:38 +0100
Message-Id: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An assorted selection of fixes and updates for the VSP1 to improve code
quality and remove incorrect limitations.

The SRU and UDS are capable of larger partitions, as part of the
partition algorithm - but we only document this support for now, as
updating it should be done in consideration with the overlap and phase
corrections necessary.

Kieran Bingham (6):
  media: vsp1: Remove artificial pixel limitation
  media: vsp1: Correct the pitch on multiplanar formats
  media: vsp1: Implement partition algorithm restrictions
  media: vsp1: Document max_width restriction on SRU
  media: vsp1: Document max_width restriction on UDS
  media: vsp1: use periods at the end of comment sentences

 drivers/media/platform/vsp1/vsp1_brx.c    |  4 +--
 drivers/media/platform/vsp1/vsp1_drm.c    | 10 ++++++
 drivers/media/platform/vsp1/vsp1_drv.c    |  6 ++--
 drivers/media/platform/vsp1/vsp1_entity.c |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  4 +--
 drivers/media/platform/vsp1/vsp1_sru.c    | 13 ++++++--
 drivers/media/platform/vsp1/vsp1_sru.h    |  1 +
 drivers/media/platform/vsp1/vsp1_uds.c    | 14 +++++++--
 drivers/media/platform/vsp1/vsp1_video.c  | 38 ++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_wpf.c    |  2 +-
 include/media/vsp1.h                      |  2 +-
 11 files changed, 73 insertions(+), 23 deletions(-)

-- 
2.17.1
