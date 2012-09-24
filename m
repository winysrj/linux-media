Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57549 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2IXMUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 08:20:44 -0400
Received: from avalon.localnet (unknown [91.178.17.105])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CE9D73598C
	for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 14:20:43 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Re: [PULL FOR v3.7] OMAP3 ISP patches
Date: Mon, 24 Sep 2012 14:21:21 +0200
Message-ID: <4139151.yl0yH9AjyI@avalon>
In-Reply-To: <2089319.1KIpnbuWf7@avalon>
References: <2089319.1KIpnbuWf7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's an additional patch if there's still time.

The following changes since commit f9040ef3fab8f6f5f6fced5583203695d08efde3:                                                                                                                               
                                                                                                                                                                                                           
  [media] stv090x: add support for multistream (2012-09-23 21:27:19 -0300)                                                                                                                                 
                                                                                                                                                                                                           
are available in the git repository at:                                                                                                                                                                    
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next                                                                                                                                             
                                                                                                                                                                                                           
Laurent Pinchart (1):                                                                                                                                                                                      
      omap3isp: Use monotonic timestamps for statistics buffers                                                                                                                                            
                                                                                                                                                                                                           
Peter Senna Tschudin (1):                                                                                                                                                                                  
      omap3isp: Fix error return code in probe function                                                                                                                                                    
                                                                                                                                                                                                           
Wanlong Gao (1):                                                                                                                                                                                           
      omap3isp: Fix up ENOIOCTLCMD error handling                                                                                                                                                          

 drivers/media/platform/omap3isp/isp.c      |    4 +++-
 drivers/media/platform/omap3isp/ispstat.c  |    2 +-
 drivers/media/platform/omap3isp/ispstat.h  |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c |    8 ++++----
 include/linux/omap3isp.h                   |    7 ++++++-
 5 files changed, 15 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart

