Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40299 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3JRVJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 17:09:00 -0400
Received: from avalon.localnet (128.142-246-81.adsl-dyn.isp.belgacom.be [81.246.142.128])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1764935A49
	for <linux-media@vger.kernel.org>; Fri, 18 Oct 2013 23:08:25 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] VSP1 fixes
Date: Fri, 18 Oct 2013 23:09:21 +0200
Message-ID: <2655285.sM6opACD3k@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry for sending this so late in the -rc cycle. These three patches fix 
issues with the VSP1 driver, including two compile issues that would break 
allyesconfig and other compilation tests on v3.12.

The following changes since commit 9c9cff55bf4f13dc2fffb5abe466f13e4ac155f9:

  [media] saa7134: Fix crash when device is closed before streamoff 
(2013-10-14 06:37:00 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/fixes

for you to fetch changes up to b3e6a3ad4914d575a4026314c9fece0e47d4499e:

  v4l: VIDEO_RENESAS_VSP1 should depend on HAS_DMA (2013-10-15 17:37:46 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      v4l: VIDEO_RENESAS_VSP1 should depend on HAS_DMA

Laurent Pinchart (1):
      v4l: vsp1: Replace ioread32/iowrite32 I/O accessors with readl/writel

Wei Yongjun (1):
      v4l: vsp1: Fix error return code in vsp1_video_init()

 drivers/media/platform/Kconfig           | 2 +-
 drivers/media/platform/vsp1/vsp1.h       | 4 ++--
 drivers/media/platform/vsp1/vsp1_video.c | 4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

