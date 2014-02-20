Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19276 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaBTTlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:41:11 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 03/10] Documentation: devicetree: Update Samsung FIMC DT
 binding
Date: Thu, 20 Feb 2014 20:40:30 +0100
Message-id: <1392925237-31394-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch documents following updates of the Exynos4 SoC camera subsystem
devicetree binding:
 - addition of #clock-cells property to 'camera' node - the #clock-cells
   property is needed when the sensor sub-devices use clock provided by
   the camera host interface;
 - addition of an optional clock-output-names property;
 - change of the clock-frequency at image sensor node from mandatory to
   an optional property - there should be no need to require this property
   by the camera host device binding, a default frequency value can ofen
   be used;
 - addition of a requirement of specific order of values in clocks/
   clock-names properties, so the first two entry in the clock-names
   property can be used as parent clock names for the camera master
   clock provider.  It happens all in-kernel dts files list the clock
   in such order, thus there should be no regression as far as in-kernel
   dts files are concerned.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   36 +++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 96312f6..1a5820d 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -20,6 +20,7 @@ Required properties:
 		  the clock-names property;
 - clock-names	: must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
 		  "pxl_async1" entries, matching entries in the clocks property.
+		  First two entries must be "sclk_cam0", "sclk_cam1".
 
 The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
 to define a required pinctrl state named "default" and optional pinctrl states:
@@ -32,6 +33,22 @@ way around.
 
 The 'camera' node must include at least one 'fimc' child node.
 
+Optional properties (*:
+
+- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
+  must be 1. A clock provider is associated with the 'camera' node and it should
+  be referenced by external sensors that use clocks provided by the SoC on
+  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a clock.
+  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
+
+- clock-output-names: from the common clock bindings, should contain names of
+  clocks registered by the camera subsystem corresponding to CAM_A_CLKOUT,
+  CAM_B_CLKOUT output clocks, in this order. Parent clock of these clocks are
+  specified be first two entries of the clock-names property.
+
+(* #clock-cells and clock-output-names are mandatory properties if external
+image sensor devices reference 'camera' device node as a clock provider.
+
 'fimc' device nodes
 -------------------
 
@@ -97,8 +114,8 @@ Image sensor nodes
 The sensor device nodes should be added to their control bus controller (e.g.
 I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
 using the common video interfaces bindings, defined in video-interfaces.txt.
-The implementation of this bindings requires clock-frequency property to be
-present in the sensor device nodes.
+An optional clock-frequency property needs to be present in the sensor device
+nodes. Default value when this property is not present is 24 MHz.
 
 Example:
 
@@ -114,7 +131,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 1>;
 			clock-names = "mclk";
 
 			port {
@@ -135,7 +152,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 0>;
 			clock-names = "mclk";
 
 			port {
@@ -149,12 +166,15 @@ Example:
 
 	camera {
 		compatible = "samsung,fimc", "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		status = "okay";
-
+		clocks = <&clock 132>, <&clock 133>;
+		clock-names = "sclk_cam0", "sclk_cam1";
+		#clock-cells = <1>;
+		clock-output-names = "cam_mclk_a", "cam_mclk_b";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		status = "okay";
+		#address-cells = <1>;
+		#size-cells = <1>;
 
 		/* parallel camera ports */
 		parallel-ports {
-- 
1.7.9.5

