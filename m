Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:51045 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbcF2I2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 04:28:03 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] media: platform/xilinx: Set VTC VSYNC/VBLANK values
Date: Wed, 29 Jun 2016 09:27:30 +0100
Message-Id: <d9d1fcdd495c25beff71d54f44fb1ec48e6c94f4.1467188641.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch sets the values of VSYNC and VBLANK in
Xilinx VTC.

The patch was tested using a modified version of this
driver and using an HDMI compliance equipment. There
is still missing the polarity settings for H/V which
would require a change in the interface of this driver.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/xilinx/xilinx-vtc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vtc.c b/drivers/media/platform/xilinx/xilinx-vtc.c
index 01c750e..49e82f2 100644
--- a/drivers/media/platform/xilinx/xilinx-vtc.c
+++ b/drivers/media/platform/xilinx/xilinx-vtc.c
@@ -211,11 +211,15 @@ int xvtc_generator_start(struct xvtc_device *xvtc,
 	xvtc_gen_write(xvtc, XVTC_HSYNC,
 		       (config->hsync_end << XVTC_HSYNC_END_SHIFT) |
 		       (config->hsync_start << XVTC_HSYNC_START_SHIFT));
-	xvtc_gen_write(xvtc, XVTC_F0_VBLANK_H, 0);
+	xvtc_gen_write(xvtc, XVTC_F0_VBLANK_H,
+		       (config->hsync_start << XVTC_F0_VBLANK_HEND_SHIFT) |
+		       (config->hsync_start << XVTC_F0_VBLANK_HSTART_SHIFT));
 	xvtc_gen_write(xvtc, XVTC_F0_VSYNC_V,
 		       (config->vsync_end << XVTC_F0_VSYNC_VEND_SHIFT) |
 		       (config->vsync_start << XVTC_F0_VSYNC_VSTART_SHIFT));
-	xvtc_gen_write(xvtc, XVTC_F0_VSYNC_H, 0);
+	xvtc_gen_write(xvtc, XVTC_F0_VSYNC_H,
+		       (config->hsync_start << XVTC_F0_VSYNC_HEND_SHIFT) |
+		       (config->hsync_start << XVTC_F0_VSYNC_HSTART_SHIFT));
 
 	/* Enable the generator. Set the source of all generator parameters to
 	 * generator registers.
-- 
2.1.4

