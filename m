Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55531 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3FJKBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:01:15 -0400
Received: from avalon.localnet (unknown [91.178.194.8])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2A40835A4D
	for <linux-media@vger.kernel.org>; Mon, 10 Jun 2013 12:01:09 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] OMAP3 ISP patches
Date: Mon, 10 Jun 2013 12:01:20 +0200
Message-ID: <2454788.qpgNgYd26s@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This should be the last set of OMAP3 ISP patches for v3.11.

The following changes since commit ab5060cdb8829c0503b7be2b239b52e9a25063b4:

  [media] drxk_hard: Remove most 80-cols checkpatch warnings (2013-06-08 
22:11:39 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to f25d34ca08fa4401f228d9b70e751fcadec5c577:

  omap3isp: ccp2: Don't ignore the regulator_enable() return value (2013-06-10 
11:53:49 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      omap3isp: include linux/mm_types.h

Laurent Pinchart (2):
      omap3isp: Defer probe when the IOMMU is not available
      omap3isp: ccp2: Don't ignore the regulator_enable() return value

Sachin Kamat (1):
      omap3isp: Remove redundant platform_set_drvdata()

 drivers/media/platform/omap3isp/isp.c      |  4 ++--
 drivers/media/platform/omap3isp/ispccp2.c  | 19 +++++++++++++++----
 drivers/media/platform/omap3isp/ispqueue.h |  1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

