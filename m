Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36244 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaACBrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 20:47:52 -0500
Received: from avalon.localnet (nblzone-211-213.nblnetworks.fi [83.145.211.213])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CF23835A53
	for <linux-media@vger.kernel.org>; Fri,  3 Jan 2014 02:46:59 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] More OMAP3 ISP fixes
Date: Fri, 03 Jan 2014 02:48:26 +0100
Message-ID: <3381881.orNTWCFLs7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7d459937dc09bb8e448d9985ec4623779427d8a5:

  [media] Add driver for Samsung S5K5BAF camera sensor (2013-12-21 07:01:36 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 7083663ca7326c8e36f0d145be4444f81a2edece:

  omap3isp: ccdc: Don't hang when the SBL fails to become idle (2014-01-02 
03:06:44 +0100)

----------------------------------------------------------------
Laurent Pinchart (3):
      omap3isp: Cancel streaming when a fatal error occurs
      omap3isp: Refactor modules stop failure handling
      omap3isp: ccdc: Don't hang when the SBL fails to become idle

 drivers/media/platform/omap3isp/isp.c      | 53 ++++++++++++++++++++++-------
 drivers/media/platform/omap3isp/isp.h      |  3 +++
 drivers/media/platform/omap3isp/ispccdc.c  |  2 ++
 drivers/media/platform/omap3isp/ispvideo.c | 46 +++++++++++++++++++++++++++++
 drivers/media/platform/omap3isp/ispvideo.h |  2 ++
 5 files changed, 92 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart

