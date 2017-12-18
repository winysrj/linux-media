Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50029 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758141AbdLRKQi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 05:16:38 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/2] media: dt-bindings: coda: Add compatible for CodaHx4 on i.MX51
Date: Mon, 18 Dec 2017 11:16:28 +0100
Message-Id: <20171218101629.31395-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a compatible for the CodaHx4 VPU used on i.MX51.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
---
Changes since v1 [1]:
- Fix list enumerators, suggested by Baruch

[1] https://patchwork.linuxtv.org/patch/45929/
---
 Documentation/devicetree/bindings/media/coda.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
index 2865d04e40305..90eb74cc1993f 100644
--- a/Documentation/devicetree/bindings/media/coda.txt
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -7,8 +7,9 @@ called VPU (Video Processing Unit).
 Required properties:
 - compatible : should be "fsl,<chip>-src" for i.MX SoCs:
   (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
-  (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
-  (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
+  (b) "fsl,imx51-vpu" for CodaHx4 present in i.MX51
+  (c) "fsl,imx53-vpu" for CODA7541 present in i.MX53
+  (d) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
 - reg: should be register base and length as documented in the
   SoC reference manual
 - interrupts : Should contain the VPU interrupt. For CODA960,
-- 
2.11.0
