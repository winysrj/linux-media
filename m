Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43332 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2KWQJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 11:09:55 -0500
Received: from avalon.localnet (unknown [91.178.103.90])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 48A0B359DB
	for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 17:09:54 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] OMAP3 ISP patches
Date: Fri, 23 Nov 2012 17:10:55 +0100
Message-ID: <1395278.dKzbc8SgHB@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This time the pull request should be good :-)

The following changes since commit 1323024fd3296537dd34da70fe70b4df12a308ec:

  [media] siano: fix build with allmodconfig (2012-11-23 13:48:39 -0200)

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
                                                                                                                                                                                                           
 arch/arm/mach-omap2/devices.c                |   10 +                                                                                                                                                     
 drivers/media/platform/omap3isp/isp.c        |   83 ++++++----                                                                                                                                            
 drivers/media/platform/omap3isp/isp.h        |    5 +-                                                                                                                                                    
 drivers/media/platform/omap3isp/ispcsi2.c    |    6 +-                                                                                                                                                    
 drivers/media/platform/omap3isp/ispcsiphy.c  |  227 ++++++++++++++++++-------                                                                                                                            
 drivers/media/platform/omap3isp/ispcsiphy.h  |   10 -                                                                                                                                                     
 drivers/media/platform/omap3isp/isphist.c    |    8 +-                                                                                                                                                    
 drivers/media/platform/omap3isp/isppreview.c |   41 +++--
 drivers/media/platform/omap3isp/ispreg.h     |   99 +++---------
 drivers/media/platform/omap3isp/ispstat.c    |    5 +-
 drivers/media/platform/omap3isp/ispstat.h    |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c   |    3 +-
 12 files changed, 294 insertions(+), 205 deletions(-)

-- 
Regards,

Laurent Pinchart

