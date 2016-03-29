Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:55102 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756730AbcC2LcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 07:32:20 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v6 3/8] arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
Date: Tue, 29 Mar 2016 19:32:05 +0800
Message-ID: <1459251130-53774-4-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1459251130-53774-3-git-send-email-tiffany.lin@mediatek.com>
References: <1459251130-53774-1-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-2-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-3-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

Add VPU drivers for MT8173

Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 60a1284..5b0b38a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -200,6 +200,18 @@
 		clock-output-names = "cpum_ck";
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+		vpu_dma_reserved: vpu_dma_mem_region {
+			compatible = "shared-dma-pool";
+			reg = <0 0xb7000000 0 0x500000>;
+			alignment = <0x1000>;
+			no-map;
+		};
+	};
+
 	thermal-zones {
 		cpu_thermal: cpu_thermal {
 			polling-delay-passive = <1000>; /* milliseconds */
@@ -422,6 +434,17 @@
 			clocks = <&infracfg CLK_INFRA_CEC>;
 		};
 
+		vpu: vpu@10020000 {
+			compatible = "mediatek,mt8173-vpu";
+			reg = <0 0x10020000 0 0x30000>,
+			      <0 0x10050000 0 0x100>;
+			reg-names = "tcm", "cfg_reg";
+			interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&topckgen CLK_TOP_SCP_SEL>;
+			clock-names = "main";
+			memory-region = <&vpu_dma_reserved>;
+		};
+
 		sysirq: intpol-controller@10200620 {
 			compatible = "mediatek,mt8173-sysirq",
 				     "mediatek,mt6577-sysirq";
-- 
1.7.9.5

