Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:47481 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732085AbeHAVVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:21:18 -0400
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
To: linux-media@vger.kernel.org
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-amlogic@lists.infradead.org
Subject: [RFC 2/4] ARM64: dts: meson-gx: add vdec entry
Date: Wed,  1 Aug 2018 21:33:18 +0200
Message-Id: <20180801193320.25313-3-maxi.jourdan@wanadoo.fr>
In-Reply-To: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the video decoder dts entry

Signed-off-by: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index b8dc4dbb391b..248052737aa7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -483,6 +483,20 @@
 			};
 		};
 
+		vdec: video-decoder@0xd0050000 {
+			compatible = "amlogic,meson-gx-vdec";
+			reg = <0x0 0xc8820000 0x0 0x10000
+			       0x0 0xc110a580 0x0 0xe4
+			       0x0 0xc8838000 0x0 0x60>;
+			reg-names = "dos", "esparser", "dmc";
+
+			interrupts = <GIC_SPI 44 IRQ_TYPE_EDGE_RISING
+				      GIC_SPI 32 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "vdec", "esparser";
+
+			amlogic,ao-sysctrl = <&sysctrl_AO>;
+		};
+
 		vpu: vpu@d0100000 {
 			compatible = "amlogic,meson-gx-vpu";
 			reg = <0x0 0xd0100000 0x0 0x100000>,
-- 
2.17.1
