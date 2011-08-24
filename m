Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60058 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1HXKcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 06:32:09 -0400
Received: from lancelot.localnet (unknown [91.178.79.172])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id B649D35A9E
	for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 10:32:08 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.2] OMAP3 ISP fixes and new sensor driver
Date: Wed, 24 Aug 2011 12:32:23 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241232.23846.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e:

  [media] tuner_xc2028: Allow selection of the frequency adjustment code for 
XC3028 (2011-08-06 09:52:47 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-sensors-next

Javier Martin (1):
      mt9p031: Aptina (Micron) MT9P031 5MP sensor driver

Laurent Pinchart (2):
      omap3isp: Don't accept pipelines with no video source as valid
      omap3isp: Move platform data definitions from isp.h to media/omap3isp.h

Michael Jones (1):
      omap3isp: queue: fail QBUF if user buffer is too small

 drivers/media/video/Kconfig             |    7 +
 drivers/media/video/Makefile            |    1 +
 drivers/media/video/mt9p031.c           |  963 ++++++++++++++++++++++++++++++
 drivers/media/video/omap3isp/isp.h      |   85 +---
 drivers/media/video/omap3isp/ispccp2.c  |    4 +-
 drivers/media/video/omap3isp/ispqueue.c |    4 +
 drivers/media/video/omap3isp/ispvideo.c |   14 +-
 include/media/mt9p031.h                 |   19 +
 include/media/omap3isp.h                |  140 +++++
 9 files changed, 1147 insertions(+), 90 deletions(-)
 create mode 100644 drivers/media/video/mt9p031.c
 create mode 100644 include/media/mt9p031.h
 create mode 100644 include/media/omap3isp.h

-- 
Regards,

Laurent Pinchart
