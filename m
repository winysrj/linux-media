Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53300 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3HUME3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 08:04:29 -0400
Received: from avalon.localnet (unknown [91.178.209.154])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5904635A73
	for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 14:04:07 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] Sensor patches
Date: Wed, 21 Aug 2013 14:05:42 +0200
Message-ID: <2718568.oJtOv9VFKs@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bfd22c490bc74f9603ea90c37823036660a313e2:

  v4l2-common: warning fix (W=1): add a missed function prototype (2013-08-18 
10:18:30 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 83a4700f417f668addb796b9cc095c132e3a4bc3:

  smiapp: Call the clock "ext_clk" (2013-08-21 14:00:49 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
      smiapp: re-use clamp_t instead of min(..., max(...))

Laurent Pinchart (1):
      mt9v032: Use the common clock framework

(Yes, I've double-checked that the mt9v032 driver isn't used by a USB camera 
driver :-)).

Sakari Ailus (3):
      smiapp-pll: Add a few comments to PLL calculation
      smiapp: Prepare and unprepare clocks correctly
      smiapp: Call the clock "ext_clk"

 drivers/media/i2c/mt9v032.c            | 17 +++++++++++------
 drivers/media/i2c/smiapp-pll.c         | 17 +++++++++++++++++
 drivers/media/i2c/smiapp/smiapp-core.c | 31 ++++++++++++++-----------------
 include/media/mt9v032.h                |  4 ----
 include/media/smiapp.h                 |  1 -
 5 files changed, 42 insertions(+), 28 deletions(-)

-- 
Regards,

Laurent Pinchart

