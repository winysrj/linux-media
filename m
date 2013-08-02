Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42731 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3HBOFU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Aug 2013 10:05:20 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <dagriego@biglakesoftware.com>,
	<dale@farnsworth.org>, <pawel@osciak.com>,
	<m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>, Rajendra Nayak <rnayak@ti.com>,
	Sricharan R <r.sricharan@ti.com>
Subject: [PATCH 6/6] experimental: arm: dts: dra7xx: Add a DT node for VPE
Date: Fri, 2 Aug 2013 19:33:43 +0530
Message-ID: <1375452223-30524-7-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-1-git-send-email-archit@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a DT node for VPE in dra7.dtsi. This is experimental because we might need
to split the VPE address space a bit more, and also because the IRQ line
described is accessible the IRQ crossbar driver is added for DRA7XX.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index ce9a0f0..3237972 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -484,6 +484,17 @@
 			dmas = <&sdma 70>, <&sdma 71>;
 			dma-names = "tx0", "rx0";
 		};
+
+		vpe {
+			compatible = "ti,vpe";
+			ti,hwmods = "vpe";
+			reg = <0x489d0000 0xd000>, <0x489dd000 0x400>;
+			reg-names = "vpe", "vpdma";
+			interrupts = <0 159 0x4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 	};
 
 	clocks {
-- 
1.8.1.2

