Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52955 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFGV5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:32 -0400
Received: by mail-pb0-f42.google.com with SMTP id md12so3908040pbc.29
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:32 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>
Subject: [PATCH 30/43] ARM: dts: imx6: add pin groups for imx6q/dl for IPU1 CSI0
Date: Sat,  7 Jun 2014 14:56:32 -0700
Message-Id: <1402178205-22697-31-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi |   52 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 04c978c..d793cd6 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -664,6 +664,58 @@
 			iomuxc: iomuxc@020e0000 {
 				compatible = "fsl,imx6dl-iomuxc", "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
+
+				ipu1 {
+					pinctrl_ipu1_csi0_d4_d7: ipu1-csi0-d4-d7 {
+						fsl,pins = <
+							MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04 0x80000000
+							MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05 0x80000000
+							MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06 0x80000000
+							MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07 0x80000000
+						>;
+					};
+					pinctrl_ipu1_csi0_1: ipu1-csi0-1 {
+						fsl,pins = <
+							MX6QDL_PAD_CSI0_DAT8__IPU1_CSI0_DATA08 0x80000000
+							MX6QDL_PAD_CSI0_DAT9__IPU1_CSI0_DATA09 0x80000000
+							MX6QDL_PAD_CSI0_DAT10__IPU1_CSI0_DATA10 0x80000000
+							MX6QDL_PAD_CSI0_DAT11__IPU1_CSI0_DATA11 0x80000000
+							MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12 0x80000000
+							MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13 0x80000000
+							MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14 0x80000000
+							MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15 0x80000000
+							MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16 0x80000000
+							MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17 0x80000000
+							MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18 0x80000000
+							MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19 0x80000000
+							MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC 0x80000000
+							MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK 0x80000000
+							MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC 0x80000000
+						>;
+					};
+
+					pinctrl_ipu1_csi0_2: ipu1-csi0-2 {
+						fsl,pins = <
+							MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12  0x80000000
+							MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13  0x80000000
+							MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14  0x80000000
+							MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15  0x80000000
+							MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16  0x80000000
+							MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17  0x80000000
+							MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18  0x80000000
+							MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19  0x80000000
+							MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC    0x80000000
+							MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK 0x80000000
+							MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC   0x80000000
+						>;
+					};
+
+					pinctrl_ipu1_csi0_data_en: ipu1-csi0-data-en {
+						fsl,pins = <
+							MX6QDL_PAD_CSI0_DATA_EN__IPU1_CSI0_DATA_EN 0x80000000
+						>;
+					};
+				};
 			};
 
 			ldb: ldb@020e0008 {
-- 
1.7.9.5

