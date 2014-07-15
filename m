Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60142 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaGOR5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 13:57:43 -0400
From: Felipe Balbi <balbi@ti.com>
To: <hans.verkuil@cisco.com>, Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>, <robh+dt@kernel.org>
CC: <linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <archit@ti.com>,
	<detheridge@ti.com>, <sakari.ailus@iki.fi>,
	<laurent.pinchart@ideasonboard.com>, <devicetree@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 3/5] arm: boot: dts: am4372: add vpfe DTS entries
Date: Tue, 15 Jul 2014 12:56:50 -0500
Message-ID: <1405447012-5340-4-git-send-email-balbi@ti.com>
In-Reply-To: <1405447012-5340-1-git-send-email-balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benoit Parrot <bparrot@ti.com>

Add Video Processing Front End (VPFE) device tree
nodes for AM34xx family of devices.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 8d3c163..b25ae13 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -888,6 +888,22 @@
 				clock-names = "fck";
 			};
 		};
+
+		vpfe0: vpfe@48326000 {
+			compatible = "ti,am437x-vpfe";
+			reg = <0x48326000 0x2000>;
+			interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+			ti,hwmods = "vpfe0";
+			status = "disabled";
+		};
+
+		vpfe1: vpfe@48328000 {
+			compatible = "ti,am437x-vpfe";
+			reg = <0x48328000 0x2000>;
+			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
+			ti,hwmods = "vpfe1";
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.0.0.390.gcb682f8

