Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:51780 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752756AbbCJThf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 15:37:35 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH 0/3] *** Updates against OMAP3ISP and BT.656
Date: Tue, 10 Mar 2015 14:24:51 -0500
Message-ID: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been doing some testing for a client's system that has a ADV7180 
attached to the omap3isp and integrating it with kernel v3.19 on a 
DM3730 platform.  I had some stability problems with the driver (it 
would crash sometimes upon stream startup or shutdown) as well as the 
ISR causing the system to lockup.  Additionally, for the system I've 
described everything with device tree (except for the omap3isp of course 
since those bindings aren't available yet), and I discovered that the 
omap3isp was starting before I2C in this case and it needed to support 
the deferral of probing the I2C client.

I also encountered the ISP getting in a state where the interrupts were 
enabled and firing, but it wasn't actually processing it since the 
pipeline state wasn't correct yet.  I added mitigation to this by 
modifying when the VD0 and VD1 interrupt trigger levels are setup, and 
causing these trigger levels to be high enough not to occur when the 
pipeline is disabled.

The other issues I encountered I believe are due to the interaction of 
the ISP on the OMAP3 and BT.656 in part.  It appears that the timing is 
critical for the ISR when entering since the current design busywaits in 
the ISR waiting for the ISP to no longer be busy, and it appears that it 
can end up missing its opportunity.  Thus I added some code to have a 
delayed buffering mode for BT.656 that causes it to hold onto buffers a 
bit longer than it otherwise would have and rely on the VSYNC latching 
for the buffers in the CCDC.

Tim Nordell (3):
  omap3isp: Defer probing when subdev isn't available
  omap3isp: Disable CCDC's VD0 and VD1 interrupts when stream is not
    enabled
  omap3isp: Add a delayed buffers for frame mode

 drivers/media/platform/omap3isp/isp.c      |   6 +-
 drivers/media/platform/omap3isp/ispccdc.c  |  43 ++++++--
 drivers/media/platform/omap3isp/ispvideo.c | 163 ++++++++++++++++++++++++-----
 drivers/media/platform/omap3isp/ispvideo.h |   3 +
 4 files changed, 178 insertions(+), 37 deletions(-)

-- 
2.0.4

