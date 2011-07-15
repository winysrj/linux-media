Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33594 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1GOSYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 14:24:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH 0/3] OMAP3 ISP patches for v3.1
Date: Fri, 15 Jul 2011 20:24:07 +0200
Message-Id: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are the OMAP3 ISP patches in my queue for v3.1. I'll send a pull request
in a couple of days if there's no objection.

Kalle Jokiniemi (2):
  OMAP3: ISP: Add regulator control for omap34xx
  OMAP3: RX-51: define vdds_csib regulator supply

Laurent Pinchart (1):
  omap3isp: Support configurable HS/VS polarities

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 ++++
 drivers/media/video/omap3isp/isp.h           |    6 +++++
 drivers/media/video/omap3isp/ispccdc.c       |    4 +-
 drivers/media/video/omap3isp/ispccp2.c       |   27 ++++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispccp2.h       |    1 +
 5 files changed, 39 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

