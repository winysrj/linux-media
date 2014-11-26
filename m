Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:39143 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaKZUc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:32:28 -0500
Received: by mail-qa0-f48.google.com with SMTP id v10so2432584qac.7
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 12:32:28 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] of: Add named interrupts to CODA bindings
Date: Wed, 26 Nov 2014 18:32:04 -0200
Message-Id: <1417033924-27513-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1417033924-27513-1-git-send-email-festevam@gmail.com>
References: <1417033924-27513-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch documents named interrupt bindings for the CODA
video processing units.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 Documentation/devicetree/bindings/media/coda.txt | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
index f5e4d4b..a44c4aa 100644
--- a/Documentation/devicetree/bindings/media/coda.txt
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -12,19 +12,24 @@ Required properties:
   (d) "fsl,imx6dl-vpu", "cnm,coda960" for CODA960 present in i.MX6DL/S
 - reg: should be register base and length as documented in the
   SoC reference manual
-- interrupts : Should contain the VPU interrupt. For CODA960,
-  a second interrupt is needed for the MJPEG unit.
+- interrupts : Should contain the VPU (BIT processor) interrupt.
+  For CODA960, a second interrupt is needed for the JPEG unit.
 - clocks : Should contain the ahb and per clocks, in the order
   determined by the clock-names property.
 - clock-names : Should be "ahb", "per"
 - iram : phandle pointing to the SRAM device node
 
+Optional properties:
+- interrupt-names: Should be "bit" for the BIT processor interrupt
+  and "jpeg" for the JPEG unit interrupt on CODA960.
+
 Example:
 
 vpu: vpu@63ff4000 {
 	compatible = "fsl,imx53-vpu", "cnm,coda7541";
 	reg = <0x63ff4000 0x1000>;
 	interrupts = <9>;
+	interrupt-names = "bit";
 	clocks = <&clks 63>, <&clks 63>;
 	clock-names = "ahb", "per";
 	iram = <&ocram>;
-- 
1.9.1

