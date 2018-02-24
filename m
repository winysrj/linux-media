Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59770 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeBXIG2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 03:06:28 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 1D974200D4
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 09:04:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] R-Car VSP changes
Date: Sat, 24 Feb 2018 10:07:13 +0200
Message-ID: <6524772.KnxT3VjmRJ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 
-0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/vsp1/next

for you to fetch changes up to 3ce28e6d5808d2f805018c7903366d306f483ee8:

  v4l: vsp1: Fix video output on R8A77970 (2018-02-23 15:03:17 +0200)

----------------------------------------------------------------
Kieran Bingham (1):
      v4l: vsp1: Fix header display list status check in continuous mode

Laurent Pinchart (2):
      v4l: vsp1: Fix display stalls when requesting too many inputs
      v4l: vsp1: Print the correct blending unit name in debug messages

Sergei Shtylyov (1):
      v4l: vsp1: Fix video output on R8A77970                                                                                                                                                             
                                                                                                                                                                                                          
Wolfram Sang (1):                                                                                                                                                                                         
      v4l: vsp1: Fix mask creation for MULT_ALPHA_RATIO                                                                                                                                                   
                                                                                                                                                                                                          
 drivers/media/platform/vsp1/vsp1_dl.c   |  3 ++-                                                                                                                                                         
 drivers/media/platform/vsp1/vsp1_drm.c  | 30 +++++++++++++++++-------------                                                                                                                              
 drivers/media/platform/vsp1/vsp1_lif.c  | 12 ++++++++++++                                                                                                                                                
 drivers/media/platform/vsp1/vsp1_regs.h |  8 +++++++-                                                                                                                                                    
 4 files changed, 38 insertions(+), 15 deletions(-)

-- 
Regards,

Laurent Pinchart
