Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56016 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaEIMlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:41:31 -0400
Received: from avalon.localnet (161.23-200-80.adsl-dyn.isp.belgacom.be [80.200.23.161])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5AB6F359FA
	for <linux-media@vger.kernel.org>; Fri,  9 May 2014 14:38:52 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] OMAP4 ISS fixes
Date: Fri, 09 May 2014 14:41:30 +0200
Message-ID: <4256351.pCDU32q4aJ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 616862a3c32b0e1ce9ac99635806b2962e5f50f0:

  omap4iss: Relax usleep ranges (2014-05-09 14:39:47 +0200)

----------------------------------------------------------------
Laurent Pinchart (4):
      omap4iss: Don't check for DEBUG when printing IRQ debugging messages
      omap4iss: Add missing white space
      omap4iss: Use a common macro for all sleep-based poll loops
      omap4iss: Relax usleep ranges

Paul Bolle (1):
      omap4iss: Remove VIDEO_OMAP4_DEBUG Kconfig option

 drivers/staging/media/omap4iss/Kconfig     |  6 -----
 drivers/staging/media/omap4iss/iss.c       | 52 ++++++++++++++---------------
 drivers/staging/media/omap4iss/iss.h       | 14 ++++++++++
 drivers/staging/media/omap4iss/iss_csi2.c  | 39 ++++++++--------------------
 drivers/staging/media/omap4iss/iss_video.h |  2 +-
 5 files changed, 49 insertions(+), 64 deletions(-)

-- 
Regards,

Laurent Pinchart

