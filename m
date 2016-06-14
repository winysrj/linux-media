Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36696 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbcFNWvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:23 -0400
Received: by mail-pf0-f193.google.com with SMTP id 62so299134pfd.3
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 25/38] ARM: dts: imx6qdl: add mem2mem device for sabre* boards
Date: Tue, 14 Jun 2016 15:49:21 -0700
Message-Id: <1465944574-15745-26-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables ipu-mem2mem device on SabreAuto, SabreSD, and SabreLite
(also on ipu2 for quad).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6q-sabreauto.dts    | 7 +++++++
 arch/arm/boot/dts/imx6q-sabrelite.dts    | 6 ++++++
 arch/arm/boot/dts/imx6q-sabresd.dts      | 6 ++++++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 6 ++++++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi   | 6 ++++++
 5 files changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts b/arch/arm/boot/dts/imx6q-sabreauto.dts
index 334b924..6e79396 100644
--- a/arch/arm/boot/dts/imx6q-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
@@ -18,8 +18,15 @@
 / {
 	model = "Freescale i.MX6 Quad SABRE Automotive Board";
 	compatible = "fsl,imx6q-sabreauto", "fsl,imx6q";
+
+	ipum2m1: ipum2m@ipu2 {
+		compatible = "fsl,imx-video-mem2mem";
+		ipu = <&ipu2>;
+		status = "okay";
+	};
 };
 
+
 &sata {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6q-sabrelite.dts b/arch/arm/boot/dts/imx6q-sabrelite.dts
index 66d10d8..95fe618 100644
--- a/arch/arm/boot/dts/imx6q-sabrelite.dts
+++ b/arch/arm/boot/dts/imx6q-sabrelite.dts
@@ -47,6 +47,12 @@
 / {
 	model = "Freescale i.MX6 Quad SABRE Lite Board";
 	compatible = "fsl,imx6q-sabrelite", "fsl,imx6q";
+
+	ipum2m1: ipum2m@ipu2 {
+		compatible = "fsl,imx-video-mem2mem";
+		ipu = <&ipu2>;
+		status = "okay";
+	};
 };
 
 &sata {
diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index ade6305..1156919 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -18,6 +18,12 @@
 / {
 	model = "Freescale i.MX6 Quad SABRE Smart Device Board";
 	compatible = "fsl,imx6q-sabresd", "fsl,imx6q";
+
+	ipum2m1: ipum2m@ipu2 {
+		compatible = "fsl,imx-video-mem2mem";
+		ipu = <&ipu2>;
+		status = "okay";
+	};
 };
 
 &sata {
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index f962f51..811059f 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -184,6 +184,12 @@
 			enable = <1>;
 		};
 	};
+
+	ipum2m0: ipum2m@ipu1 {
+		compatible = "fsl,imx-video-mem2mem";
+		ipu = <&ipu1>;
+		status = "okay";
+	};
 };
 
 &ipu1_csi0_from_ipu1_csi0_mux {
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index ce575e6..a67ad02 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -168,6 +168,12 @@
 		ports = <&ipu1_csi1>;
 		status = "okay";
 	};
+
+	ipum2m0: ipum2m@ipu1 {
+		compatible = "fsl,imx-video-mem2mem";
+		ipu = <&ipu1>;
+		status = "okay";
+	};
 };
 
 #ifdef __ENABLE_OV5642__
-- 
1.9.1

