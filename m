Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53435 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbbKQMzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:17 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 2/8] arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
Date: Tue, 17 Nov 2015 20:54:39 +0800
Message-ID: <1447764885-23100-3-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

add VPU drivers for MT8173

Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 4dd5f93..098c15e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -258,6 +258,17 @@
 			clock-names = "spi", "wrap";
 		};
 
+		vpu: vpu@10020000 {
+			compatible = "mediatek,mt8173-vpu";
+			reg = <0 0x10020000 0 0x30000>,
+			      <0 0x10050000 0 0x100>;
+			reg-names = "sram", "cfg_reg";
+			interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&topckgen CLK_TOP_SCP_SEL>;
+			clock-names = "main";
+			iommus = <&iommu M4U_LARB3_ID M4U_PORT_VENC_RCPU>;
+		};
+
 		sysirq: intpol-controller@10200620 {
 			compatible = "mediatek,mt8173-sysirq",
 				     "mediatek,mt6577-sysirq";
-- 
1.7.9.5

