Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46101 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1FPJGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 05:06:19 -0400
Received: from lancelot.localnet (unknown [91.178.46.230])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 08E6A3599B
	for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 09:06:19 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.0] OMAP3 ISP and media controller fixes
Date: Thu, 16 Jun 2011 11:06:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161106.26227.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-stable-omap3isp

Laurent Pinchart (1):
      v4l: Don't access media entity after is has been destroyed

Ohad Ben-Cohen (1):
      media: omap3isp: fix a potential NULL deref

 drivers/media/video/omap3isp/isp.c |    2 +-
 drivers/media/video/v4l2-dev.c     |   39 ++++++-----------------------------
 2 files changed, 8 insertions(+), 33 deletions(-)

-- 
Regards,

Laurent Pinchart
