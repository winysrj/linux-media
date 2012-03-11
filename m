Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41734 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2CKUng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 16:43:36 -0400
Received: from avalon.localnet (unknown [91.178.213.60])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5434F362B0
	for <linux-media@vger.kernel.org>; Sun, 11 Mar 2012 21:43:34 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.4] MT9P031 and MT9M032 sensor drivers
Date: Sun, 11 Mar 2012 21:43:58 +0100
Message-ID: <3507195.B7nhaZS51H@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:

  [media] cx25821: Add a card definition for "No brand" cards that have: 
subvendor = 0x0000 subdevice = 0x0000 (2012-03-08 12:42:28 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-sensors-next

Laurent Pinchart (3):
      mt9p031: Remove unused xskip and yskip fields in struct mt9p031
      v4l: Aptina-style sensor PLL support
      mt9p031: Use generic PLL setup code

Martin Hostettler (1):
      v4l: Add driver for Micron MT9M032 camera sensor

 drivers/media/video/Kconfig      |   12 +
 drivers/media/video/Makefile     |    5 +
 drivers/media/video/aptina-pll.c |  174 ++++++++
 drivers/media/video/aptina-pll.h |   56 +++
 drivers/media/video/mt9m032.c    |  868 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/mt9p031.c    |   66 ++--
 include/media/mt9m032.h          |   36 ++
 7 files changed, 1178 insertions(+), 39 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

