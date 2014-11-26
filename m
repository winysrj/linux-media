Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:56285 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZUc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:32:26 -0500
Received: by mail-qg0-f45.google.com with SMTP id f51so2623124qge.32
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 12:32:25 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] of: Add new compatibles for CODA bindings
Date: Wed, 26 Nov 2014 18:32:03 -0200
Message-Id: <1417033924-27513-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch adds new compatibles using the new Chips&Media vendor
prefix "cnm" and CODA model name as well as a Freescale specific
compatible value for i.MX6DL/S.
The latter is because for some reason the i.MX6DL/S firmware
provided by Freescale differs from the i.MX6Q/D version.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 Documentation/devicetree/bindings/media/coda.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
index 2865d04..f5e4d4b 100644
--- a/Documentation/devicetree/bindings/media/coda.txt
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -5,10 +5,11 @@ Coda codec IPs are present in i.MX SoCs in various versions,
 called VPU (Video Processing Unit).
 
 Required properties:
-- compatible : should be "fsl,<chip>-src" for i.MX SoCs:
-  (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
-  (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
-  (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
+- compatible : should be "fsl,<chip>-src", "cnm,coda<model>" for i.MX SoCs:
+  (a) "fsl,imx27-vpu", "cnm,codadx6" for CodaDx6 present in i.MX27
+  (b) "fsl,imx53-vpu", "cnm,coda7541" for CODA7541 present in i.MX53
+  (c) "fsl,imx6q-vpu", "cnm,coda960" for CODA960 present in i.MX6Q/D
+  (d) "fsl,imx6dl-vpu", "cnm,coda960" for CODA960 present in i.MX6DL/S
 - reg: should be register base and length as documented in the
   SoC reference manual
 - interrupts : Should contain the VPU interrupt. For CODA960,
@@ -21,7 +22,7 @@ Required properties:
 Example:
 
 vpu: vpu@63ff4000 {
-	compatible = "fsl,imx53-vpu";
+	compatible = "fsl,imx53-vpu", "cnm,coda7541";
 	reg = <0x63ff4000 0x1000>;
 	interrupts = <9>;
 	clocks = <&clks 63>, <&clks 63>;
-- 
1.9.1

