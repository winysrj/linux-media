Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55213 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2JSL2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 07:28:47 -0400
Received: from avalon.localnet (unknown [91.178.165.97])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9CA1835A8C
	for <linux-media@vger.kernel.org>; Fri, 19 Oct 2012 13:28:45 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] OMAP3 ISP patches
Date: Fri, 19 Oct 2012 13:29:34 +0200
Message-ID: <4416913.DZ8Yb0HW1N@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 74df06daf632ce2d321d01cb046004768352efc4:

  [media] Remove include/linux/dvb/ stuff (2012-10-19 07:41:50 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Laurent Pinchart (4):
      omap3isp: Use monotonic timestamps for statistics buffers
      omap3isp: Remove unneeded module memory address definitions
      omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
      omap3isp: Fix warning caused by bad subdev events operations prototypes

Sakari Ailus (3):
      omap3isp: Add CSI configuration registers from control block to ISP 
resources
      omap3isp: Add PHY routing configuration
      omap3isp: Configure CSI-2 phy based on platform data

 arch/arm/mach-omap2/devices.c               |   10 ++
 drivers/media/platform/omap3isp/isp.c       |    6 +-
 drivers/media/platform/omap3isp/isp.h       |    5 +-
 drivers/media/platform/omap3isp/ispccdc.c   |    4 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  225 ++++++++++++++++++--------
 drivers/media/platform/omap3isp/ispcsiphy.h |   10 --
 drivers/media/platform/omap3isp/isphist.c   |    5 +-
 drivers/media/platform/omap3isp/ispreg.h    |   99 +++---------
 drivers/media/platform/omap3isp/ispstat.c   |    9 +-
 drivers/media/platform/omap3isp/ispstat.h   |    6 +-
 drivers/media/platform/omap3isp/ispvideo.c  |    2 +-
 11 files changed, 216 insertions(+), 165 deletions(-)

-- 
Regards,

Laurent Pinchart

