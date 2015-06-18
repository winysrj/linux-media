Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39065 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbFRUap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 16:30:45 -0400
Received: from avalon.localnet (a91-152-136-245.elisa-laajakaista.fi [91.152.136.245])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 031942039D
	for <linux-media@vger.kernel.org>; Thu, 18 Jun 2015 22:29:44 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.2] VSP1 miscellaneous fixes
Date: Thu, 18 Jun 2015 23:31:33 +0300
Message-ID: <1526864.UJrODxtOuG@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I suppose it's too late for v4.2, but who knows :-) If it is, v4.3 is fine as 
well.

The following changes since commit f8d5556fa9dbf6b88e1a8fe88e47ad1b8ddb4742:

  [media] videodev2.h: fix copy-and-paste error in V4L2_MAP_XFER_FUNC_DEFAULT 
(2015-06-18 14:34:46 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next2

for you to fetch changes up to 2a2d600528e8d7c26fef1dc077c74057c1586702:

  v4l: vsp1: Align crop rectangle to even boundary for YUV formats (2015-06-18 
23:27:36 +0300)

----------------------------------------------------------------
Damian Hobson-Garcia (1):
      v4l: vsp1: Align crop rectangle to even boundary for YUV formats

Laurent Pinchart (1):
      v4l: vsp1: Fix race condition when stopping pipeline

Nobuhiro Iwamatsu (3):
      v4l: vsp1: Fix VI6_WPF_SZCLIP_SIZE_MASK macro
      v4l: vsp1: Fix VI6_DPR_ROUTE_FP_MASK macro
      v4l: vsp1: Fix VI6_DPR_ROUTE_FXA_MASK macro

Sei Fumizono (1):
      v4l: vsp1: Fix Suspend-to-RAM

 drivers/media/platform/vsp1/vsp1_drv.c   | 13 +++++--
 drivers/media/platform/vsp1/vsp1_regs.h  |  6 +--
 drivers/media/platform/vsp1/vsp1_rwpf.c  | 11 ++++++
 drivers/media/platform/vsp1/vsp1_video.c | 83 ++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |  5 ++-
 5 files changed, 109 insertions(+), 9 deletions(-)

-- 
Regards,

Laurent Pinchart

