Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:45531 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732094AbeHAVVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:21:19 -0400
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
To: linux-media@vger.kernel.org
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-amlogic@lists.infradead.org
Subject: [RFC 3/4] ARM64: dts: meson: add vdec entries
Date: Wed,  1 Aug 2018 21:33:19 +0200
Message-Id: <20180801193320.25313-4-maxi.jourdan@wanadoo.fr>
In-Reply-To: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables the video decoder for gxbb, gxl and gxm chips

Signed-off-by: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 8 ++++++++
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 8 ++++++++
 arch/arm64/boot/dts/amlogic/meson-gxm.dtsi  | 4 ++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 98cbba6809ca..0ea4b5684a11 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -774,3 +774,11 @@
 	compatible = "amlogic,meson-gxbb-vpu", "amlogic,meson-gx-vpu";
 	power-domains = <&pwrc_vpu>;
 };
+
+&vdec {
+	compatible = "amlogic,meson-gxbb-vdec";
+	clocks = <&clkc CLKID_DOS_PARSER>, <&clkc CLKID_DOS>, <&clkc CLKID_VDEC_1>, <&clkc CLKID_VDEC_HEVC>;
+	clock-names = "dos_parser", "dos", "vdec_1", "vdec_hevc";
+	resets = <&reset RESET_PARSER>;
+	reset-names = "esparser";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index c87a80e9bcc6..20045a9c26fa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -775,3 +775,11 @@
 	compatible = "amlogic,meson-gxl-vpu", "amlogic,meson-gx-vpu";
 	power-domains = <&pwrc_vpu>;
 };
+
+&vdec {
+	compatible = "amlogic,meson-gxl-vdec";
+	clocks = <&clkc CLKID_DOS_PARSER>, <&clkc CLKID_DOS>, <&clkc CLKID_VDEC_1>, <&clkc CLKID_VDEC_HEVC>;
+	clock-names = "dos_parser", "dos", "vdec_1", "vdec_hevc";
+	resets = <&reset RESET_PARSER>;
+	reset-names = "esparser";
+};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxm.dtsi
index 247888d68a3a..4ce7b12014bb 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm.dtsi
@@ -117,3 +117,7 @@
 &dwc3 {
 	phys = <&usb3_phy>, <&usb2_phy0>, <&usb2_phy1>, <&usb2_phy2>;
 };
+
+&vdec {
+	compatible = "amlogic,meson-gxm-vdec";
+};
-- 
2.17.1
