Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39878 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3EIMpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:45:45 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00MI07FQ6DC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 21:45:44 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, hj210.choi@samsung.com,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] exynos4-is: Fix example dts in .../bindings/samsung-fimc.txt
Date: Thu, 09 May 2013 14:45:17 +0200
Message-id: <1368103517-16710-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5c73m3 sensor node should be off an I2C bus controller node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 51c776b..96312f6 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -127,22 +127,22 @@ Example:
 				};
 			};
 		};
-	};
 
-	/* MIPI CSI-2 bus IF sensor */
-	s5c73m3: sensor@0x1a {
-		compatible = "samsung,s5c73m3";
-		reg = <0x1a>;
-		vddio-supply = <...>;
+		/* MIPI CSI-2 bus IF sensor */
+		s5c73m3: sensor@0x1a {
+			compatible = "samsung,s5c73m3";
+			reg = <0x1a>;
+			vddio-supply = <...>;
 
-		clock-frequency = <24000000>;
-		clocks = <...>;
-		clock-names = "mclk";
+			clock-frequency = <24000000>;
+			clocks = <...>;
+			clock-names = "mclk";
 
-		port {
-			s5c73m3_1: endpoint {
-				data-lanes = <1 2 3 4>;
-				remote-endpoint = <&csis0_ep>;
+			port {
+				s5c73m3_1: endpoint {
+					data-lanes = <1 2 3 4>;
+					remote-endpoint = <&csis0_ep>;
+				};
 			};
 		};
 	};
-- 
1.7.9.5

