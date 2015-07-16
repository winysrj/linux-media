Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38219 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbbGPIX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:23:29 -0400
Received: from avalon.localnet (89-27-67-84.bb.dnainternet.fi [89.27.67.84])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 315FF2005B
	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2015 10:22:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.3] VSP1 fixes
Date: Thu, 16 Jul 2015 11:23:54 +0300
Message-ID: <2206125.JSWmO800Ro@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 9bb44c299a19725e3ce0a7f15521a4fea898c0dc:

  v4l: vsp1: Don't sleep in atomic context (2015-07-16 11:21:25 +0300)

----------------------------------------------------------------
Laurent Pinchart (2):
      v4l: vsp1: Fix plane stride and size checks
      v4l: vsp1: Don't sleep in atomic context

 drivers/media/platform/vsp1/vsp1_entity.c | 18 +++++++++---------
 drivers/media/platform/vsp1/vsp1_entity.h |  4 ++--
 drivers/media/platform/vsp1/vsp1_video.c  |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

-- 
Regards,

Laurent Pinchart

