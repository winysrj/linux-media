Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59812 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2KMOeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 09:34:25 -0500
Received: from avalon.localnet (unknown [91.178.162.106])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 218E1359DA
	for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 15:34:24 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] OMAP3 ISP fixes
Date: Tue, 13 Nov 2012 15:35:20 +0100
Message-ID: <5165893.K67LFKXKHh@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 01aea0bfd8dfa8bc868df33904461984bb10a87a:

  [media] i2c: adv7183: use module_i2c_driver to simplify the code (2012-10-25 
17:08:46 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp/next

Laurent Pinchart (6):
      omap3isp: Use monotonic timestamps for statistics buffers
      omap3isp: Remove unneeded module memory address definitions
      omap3isp: Replace printk with dev_*
      omap3isp: preview: Add support for 8-bit formats at the sink pad
      omap3isp: Prepare/unprepare clocks before/after enable/disable
      omap3isp: Replace cpu_is_omap3630() with ISP revision check

Sakari Ailus (4):
      omap3isp: Add CSI configuration registers from control block to ISP 
resources
      omap3isp: Add PHY routing configuration
      omap3isp: Configure CSI-2 phy based on platform data
      omap3isp: Find source pad from external entity

Note that patch "Replace cpu_is_omap3630() with ISP revision check" has been 
already submitted and reverted at my request, as the proper solution should be 
implemented at the clock provider level. This is in progress and will require 
common clock framework support, which will likely reach mainline in v3.9. In 
order not to delay cpu_is_omap3630() removal I've decided to resubmit this 
patch, and will implement the proper fix when the common clock framework will 
be available for the OMAP3.

 arch/arm/mach-omap2/devices.c                |   10 +
 drivers/media/platform/omap3isp/isp.c        |   83 ++++++----
 drivers/media/platform/omap3isp/isp.h        |    5 +-
 drivers/media/platform/omap3isp/ispcsi2.c    |    6 +-
 drivers/media/platform/omap3isp/ispcsiphy.c  |  227 ++++++++++++++++++-------
 drivers/media/platform/omap3isp/ispcsiphy.h  |   10 -
 drivers/media/platform/omap3isp/isphist.c    |    8 +-
 drivers/media/platform/omap3isp/isppreview.c |   40 +++--
 drivers/media/platform/omap3isp/ispreg.h     |   99 +++---------
 drivers/media/platform/omap3isp/ispstat.c    |    5 +-
 drivers/media/platform/omap3isp/ispstat.h    |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c   |    3 +-
 12 files changed, 294 insertions(+), 204 deletions(-)

-- 
Regards,

Laurent Pinchart

