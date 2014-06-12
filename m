Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33046 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 23/26] mfd: syscon: add child device support
Date: Thu, 12 Jun 2014 19:06:37 +0200
Message-Id: <1402592800-2925-24-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For devices which have a complete register for themselves, it is possible to
place them next to the syscon device with overlapping reg ranges. The same is
not possible for devices which only occupy bitfields in registers shared with
other users.
For devices that are completely controlled by bitfields in the syscon address
range, such as multiplexers or voltage regulators, allow to put child devices
into the syscon device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
 drivers/mfd/syscon.c                             |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
index fe8150b..a7e11d5 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.txt
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
 OS driver) to determine the location of the registers, and access the
 registers directly.
 
+Optionally, devices that are only controlled through single syscon
+registers or bitfields can also be added as child nodes to the syscon
+device node. These devices can implicitly assume their parent node
+as syscon provider without referencing it explicitly via phandle.
+In this case, the syscon node should have #address-cells = <1> and
+#size-cells = <0> and no ranges property.
+
 Required properties:
 - compatible: Should contain "syscon".
 - reg: the register region can be accessed from syscon
 
+Optional properties:
+- #address-cells: Should be 1.
+- #size-cells: Should be 0.
+
 Examples:
 gpr: iomuxc-gpr@020e0000 {
 	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index dbea55d..4b5d237 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -147,6 +147,9 @@ static int syscon_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "regmap %pR registered\n", res);
 
+	if (!of_device_is_compatible(pdev->dev.of_node, "simple-bus"))
+		of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+
 	return 0;
 }
 
-- 
2.0.0.rc2

