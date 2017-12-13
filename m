Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53101 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752786AbdLMOJf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:09:35 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] media: dt-bindings: coda: Add compatible for CodaHx4 on i.MX51
Date: Wed, 13 Dec 2017 15:09:17 +0100
Message-Id: <20171213140918.22500-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a compatible for the CodaHx4 VPU used on i.MX51.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/media/coda.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
index 2865d04e40305..660f5ecf2a23b 100644
--- a/Documentation/devicetree/bindings/media/coda.txt
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -7,6 +7,7 @@ called VPU (Video Processing Unit).
 Required properties:
 - compatible : should be "fsl,<chip>-src" for i.MX SoCs:
   (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
+  (a) "fsl,imx51-vpu" for CodaHx4 present in i.MX51
   (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
   (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
 - reg: should be register base and length as documented in the
-- 
2.11.0
