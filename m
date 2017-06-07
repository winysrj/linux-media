Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33827 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdFGSei (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 14:34:38 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v8 04/34] ARM: dts: imx6qdl: add multiplexer controls
Date: Wed,  7 Jun 2017 11:33:43 -0700
Message-Id: <1496860453-6282-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The IOMUXC General Purpose Register space contains various bitfields
that control video bus multiplexers. Describe them using a mmio-mux
node. The placement of the IPU CSI video mux controls differs between
i.MX6D/Q and i.MX6S/DL.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx6dl.dtsi  | 10 ++++++++++
 arch/arm/boot/dts/imx6q.dtsi   | 10 ++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi |  7 ++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 7aa120f..10bc9d1 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -181,6 +181,16 @@
 		      "di0", "di1";
 };
 
+&mux {
+	mux-reg-masks = <0x34 0x00000007>, /* IPU_CSI0_MUX */
+			<0x34 0x00000038>, /* IPU_CSI1_MUX */
+			<0x0c 0x0000000c>, /* HDMI_MUX_CTL */
+			<0x0c 0x000000c0>, /* LVDS0_MUX_CTL */
+			<0x0c 0x00000300>, /* LVDS1_MUX_CTL */
+			<0x28 0x00000003>, /* DCIC1_MUX_CTL */
+			<0x28 0x0000000c>; /* DCIC2_MUX_CTL */
+};
+
 &vpu {
 	compatible = "fsl,imx6dl-vpu", "cnm,coda960";
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e9a5d0b..a6962be 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -332,6 +332,16 @@
 	};
 };
 
+&mux {
+	mux-reg-masks = <0x04 0x00080000>, /* MIPI_IPU1_MUX */
+			<0x04 0x00100000>, /* MIPI_IPU2_MUX */
+			<0x0c 0x0000000c>, /* HDMI_MUX_CTL */
+			<0x0c 0x000000c0>, /* LVDS0_MUX_CTL */
+			<0x0c 0x00000300>, /* LVDS1_MUX_CTL */
+			<0x28 0x00000003>, /* DCIC1_MUX_CTL */
+			<0x28 0x0000000c>; /* DCIC2_MUX_CTL */
+};
+
 &vpu {
 	compatible = "fsl,imx6q-vpu", "cnm,coda960";
 };
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e426faa..50534dd 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -808,8 +808,13 @@
 			};
 
 			gpr: iomuxc-gpr@020e0000 {
-				compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
+				compatible = "fsl,imx6q-iomuxc-gpr", "syscon", "simple-mfd";
 				reg = <0x020e0000 0x38>;
+
+				mux: mux-controller {
+					compatible = "mmio-mux";
+					#mux-control-cells = <1>;
+				};
 			};
 
 			iomuxc: iomuxc@020e0000 {
-- 
2.7.4
