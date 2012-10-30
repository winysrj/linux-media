Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:37101
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab2J3MDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:03:51 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <kernel@pengutronix.de>, <mchehab@infradead.org>,
	<gcembed@gmail.com>, <javier.martin@vista-silicon.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Date: Tue, 30 Oct 2012 10:03:25 -0200
Message-ID: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the clock conversion for mx27 the "per4_gate" clock was missed to get
registered as a dependency of mx2-camera driver.

In the old mx27 clock driver we used to have:

DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);

,so does the same in the new clock driver

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
---
Changes since v3:
- Use imx27-camera.0 instead of mx2-camera.0, due to recent changes in the
imx27 clock (commit 27b76486a3: media: mx2_camera: remove cpu_is_xxx by using platform_device_id)

 arch/arm/mach-imx/clk-imx27.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 585ab25..2880bd9 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx21-fb.0");
 	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx21-fb.0");
 	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "imx27-camera.0");
+	clk_register_clkdev(clk[per4_gate], "per", "imx27-camera.0");
 	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
-- 
1.7.9.5


