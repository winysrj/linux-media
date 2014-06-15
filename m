Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38674 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOT4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:56:47 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 2/9] ARM: lager: add i2c1, i2c2 pins
Date: Sun, 15 Jun 2014 20:56:27 +0100
Message-Id: <1402862194-17743-3-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pinctrl definitions for i2c1 and i2c2 busses on the Lager board
to ensure these are setup correctly at initialisation time. The i2c0
and i2c3 busses are connected to single function pins.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790-lager.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 8617755..4805c9f 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -204,6 +204,16 @@
 				 "msiof1_tx";
 		renesas,function = "msiof1";
 	};
+
+	i2c1_pins: i2c1 {
+		renesas,groups = "i2c1";
+		renesas,function = "i2c1";
+	};
+
+	i2c2_pins: i2c2 {
+		renesas,groups = "i2c2";
+		renesas,function = "i2c2";
+	};
 };
 
 &ether {
@@ -324,10 +334,14 @@
 
 &i2c1	{
 	status = "ok";
+	pinctrl-0 = <&i2c1_pins>;
+	pinctrl-names = "default";
 };
 
 &i2c2	{
 	status = "ok";
+	pinctrl-0 = <&i2c2_pins>;
+	pinctrl-names = "default";
 };
 
 &i2c3	{
-- 
2.0.0

