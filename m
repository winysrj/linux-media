Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaFGV5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:37 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3909538pbb.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:37 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 35/43] ARM: dts: imx6qdl: Add simple-bus to ipu compatibility
Date: Sat,  7 Jun 2014 14:56:37 -0700
Message-Id: <1402178205-22697-36-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IPU can have child devices now, so add "simple-bus" to
compatible list to ensure creation of the children.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    6 ++++--
 arch/arm/boot/dts/imx6q.dtsi                       |    2 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
index 3be5ce7..dc759e4 100644
--- a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
+++ b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
@@ -21,7 +21,9 @@ Freescale i.MX IPUv3
 ====================
 
 Required properties:
-- compatible: Should be "fsl,<chip>-ipu"
+- compatible: Should be "fsl,<chip>-ipu". The IPU can also have child
+  devices, so also must include "simple-bus" to ensure creation of the
+  children.
 - reg: should be register base and length as documented in the
   datasheet
 - interrupts: Should contain sync interrupt and error interrupt,
@@ -39,7 +41,7 @@ example:
 ipu: ipu@18000000 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-	compatible = "fsl,imx53-ipu";
+	compatible = "fsl,imx53-ipu", "simple-bus";
 	reg = <0x18000000 0x080000000>;
 	interrupts = <11 10>;
 	resets = <&src 2>;
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index c7544f0..50e2a32 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -149,7 +149,7 @@
 		ipu2: ipu@02800000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "fsl,imx6q-ipu";
+			compatible = "fsl,imx6q-ipu", "simple-bus";
 			reg = <0x02800000 0x400000>;
 			interrupts = <0 8 IRQ_TYPE_LEVEL_HIGH>,
 				     <0 7 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 00130a8..089a84a 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1096,7 +1096,7 @@
 		ipu1: ipu@02400000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "fsl,imx6q-ipu";
+			compatible = "fsl,imx6q-ipu", "simple-bus";
 			reg = <0x02400000 0x400000>;
 			interrupts = <0 6 IRQ_TYPE_LEVEL_HIGH>,
 				     <0 5 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.7.9.5

