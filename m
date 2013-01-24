Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3AXPEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 10:04:21 -0500
Received: from avalon.localnet (unknown [91.178.45.136])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 92F5E3598B
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 16:04:19 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] OMAP3 ISP patches
Date: Thu, 24 Jan 2013 16:04:21 +0100
Message-ID: <1927378.yJrjV1buA9@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 94a93e5f85040114d6a77c085457b3943b6da889:

  [media] dvb_frontend: print a msg if a property doesn't exist (2013-01-23 
19:10:57 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 459eb3da07ce01345e9aa3bdafbb5510d5679ece:

  omap3isp: Fix histogram regions (2013-01-24 16:02:30 +0100)

----------------------------------------------------------------
Johannes Schellen (1):
      omap3isp: Fix histogram regions

Laurent Pinchart (3):
      omap3isp: preview: Lower the crop margins
      omap3isp: Remove unneeded memset after kzalloc
      omap3isp: Use devm_* managed functions

 drivers/media/platform/omap3isp/isp.c         | 74 +++++---------------------
 drivers/media/platform/omap3isp/ispccp2.c     |  8 +---
 drivers/media/platform/omap3isp/isph3a_aewb.c | 28 +++----------
 drivers/media/platform/omap3isp/isph3a_af.c   | 28 +++----------
 drivers/media/platform/omap3isp/isphist.c     | 21 +++++-----
 drivers/media/platform/omap3isp/isppreview.c  | 40 ++++++++++---------
 6 files changed, 56 insertions(+), 143 deletions(-)

The corresponding patchwork commands are

pwclient update -s 'superseded' 15787
pwclient update -s 'accepted' 15788
pwclient update -s 'accepted' 16049
pwclient update -s 'accepted' 16050
pwclient update -s 'accepted' 16224

-- 
Regards,

Laurent Pinchart

