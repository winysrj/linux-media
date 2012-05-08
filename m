Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40524 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2EHRxE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 13:53:04 -0400
Received: from avalon.localnet (unknown [193.190.208.38])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 980DB7B0B
	for <linux-media@vger.kernel.org>; Tue,  8 May 2012 19:53:02 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.5] Miscellaneous sensor drivers and control framework fixes
Date: Tue, 08 May 2012 19:53:04 +0200
Message-ID: <1931104.XfbWenVRRx@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit aeebb1b3146a70bf02d0115a2be690d856d12e8c:

  [media] pvrusb2: For querystd, start with list of hardware-supported 
standards (2012-05-07 16:58:00 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-sensors-next

Guennadi Liakhovetski (3):
      mt9m032: fix two dead-locks
      mt9m032: fix compilation breakage
      mt9m032: use the available subdev pointer, don't re-calculate it

Kartik Mohta (1):
      mt9v032: Correct the logic for the auto-exposure setting

Laurent Pinchart (5):
      mt9p031: Identify color/mono models using I2C device name
      mt9p031: Replace the reset board callback by a GPIO number
      mt9p031: Implement black level compensation control
      v4l: aptina-pll: Round up minimum multiplier factor value properly
      v4l: v4l2-ctrls: Add forward declaration of struct file

 drivers/media/video/Kconfig      |    2 +-
 drivers/media/video/aptina-pll.c |    5 +-
 drivers/media/video/mt9m032.c    |    9 +-
 drivers/media/video/mt9p031.c    |  161 +++++++++++++++++++++++++++++++++----
 drivers/media/video/mt9v032.c    |    2 +-
 include/media/mt9p031.h          |   19 +++--
 include/media/v4l2-ctrls.h       |    1 +
 7 files changed, 165 insertions(+), 34 deletions(-)

-- 
Regards,

Laurent Pinchart

