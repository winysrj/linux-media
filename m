Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54762 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1GTN6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 09:58:12 -0400
Received: from lancelot.localnet (unknown [91.178.170.101])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4ED04359A1
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2011 13:58:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.1] OMAP3 ISP fixes
Date: Wed, 20 Jul 2011 15:58:11 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107201558.12877.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9bc5f6fa12c9e3e1e73e66bfabe9d463ea779b08:

  [media] drxk: Remove goto/break after return (2011-07-15 09:35:58 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-next-omap3isp

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
