Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:48827
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab2JEVxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 17:53:22 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <kernel@pengutronix.de>
CC: <g.liakhovetski@gmx.de>, <mchehab@infradead.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <javier.martin@vista-silicon.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Date: Fri, 5 Oct 2012 18:53:01 -0300
Message-ID: <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the clock conversion for mx27 the "per4_gate" clock was missed to get
registered as a dependency of mx2-camera driver.

In the old mx27 clock driver we used to have:

DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);

,so does the same in the new clock driver.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/mach-imx/clk-imx27.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 3b6b640..5ef0f08 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
 	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
+	clk_register_clkdev(clk[per4_gate], "per", "mx2-camera.0");
 	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
-- 
1.7.9.5


