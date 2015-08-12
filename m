Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43104 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbHLHsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:48:05 -0400
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 5B1272000F
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2015 09:46:43 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.3] OMAP3 ISP changes
Date: Wed, 12 Aug 2015 10:48:59 +0300
Message-ID: <1594454.XZmytAGbqn@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2696f495bdc046d84da6c909a1e7f535138a2a62:

  [media] Staging: media: lirc: use USB API functions rather than constants 
(2015-08-11 18:00:30 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 32b7a848266fcf5c2c087106fd001abbac0405ee:

  v4l: omap3isp: Drop platform data support (2015-08-12 10:39:46 +0300)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: omap3isp: Drop platform data support

 drivers/media/platform/Kconfig                          |   2 +-
 drivers/media/platform/omap3isp/isp.c                   | 133 ++++-----------
 drivers/media/platform/omap3isp/isp.h                   |   7 +-
 drivers/media/platform/omap3isp/ispcsiphy.h             |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c              |   9 +-
 .../media/platform/omap3isp}/omap3isp.h                 |  42 ++------
 6 files changed, 34 insertions(+), 161 deletions(-)
 rename {include/media => drivers/media/platform/omap3isp}/omap3isp.h (77%)

-- 
Regards,

Laurent Pinchart

