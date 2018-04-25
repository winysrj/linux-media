Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52488 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeDYAgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 20:36:46 -0400
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0F5C05172
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 02:36:44 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.17] UVC fixes
Date: Wed, 25 Apr 2018 03:37:00 +0300
Message-ID: <2618618.x2Pkc03X4B@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:                                                                                                                              
                                                                                                                                                                                                          
  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)                                                                                                                                                              
                                                                                                                                                                                                          
are available in the Git repository at:                                                                                                                                                                   
                                                                                                                                                                                                          
  git://linuxtv.org/pinchartl/media.git uvc/fixes                                                                                                                                                         
                                                                                                                                                                                                          
for you to fetch changes up to 3f22b63e8a488156467da43cdf9a3a7bd683f161:                                                                                                                                  
                                                                                                                                                                                                          
  media: uvcvideo: Prevent setting unavailable flags (2018-04-25 03:16:42 
+0300)                                                                                                                          
                                                                                                                                                                                                          
----------------------------------------------------------------                                                                                                                                          
Kieran Bingham (1):                                                                                                                                                                                       
      media: uvcvideo: Prevent setting unavailable flags                                                                                                                                                  
                                                                                                                                                                                                          
 drivers/media/usb/uvc/uvc_ctrl.c | 17 +++++++++--------                                                                                                                                                  
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart
