Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26209 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBXRgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 12:36:55 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 03/10] Documentation: devicetree: Update Samsung FIMC DT
 binding
Date: Mon, 24 Feb 2014 18:35:15 +0100
Message-id: <1393263322-28215-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
References: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch documents following updates of the Exynos4 SoC camera subsystem
devicetree binding:

 - addition of #clock-cells property to 'camera' node - the #clock-cells
   property is needed when the sensor sub-devices use clock provided by
   the camera host interface,
 - addition of an optional clock-output-names property,
 - change of the clock-frequency at image sensor node from mandatory to
   an optional property - the sensor devices can now control their clock
   themselves and there should be no need to require this property by the
   camera host device binding, a default frequency value can ofen be used.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v4:
 - dropped a requirement of specific order of values in clocks/
   clock-names properties (Mark) and reference to clock-names in
   clock-output-names property description (Mark).
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   34 +++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 96312f6..dbd4020 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -32,6 +32,21 @@ way around.
 
 The 'camera' node must include at least one 'fimc' child node.
 
+Optional properties:
+
+- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
+  must be 1. A clock provider is associated with the 'camera' node and it should
+  be referenced by external sensors that use clocks provided by the SoC on
+  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a clock.
+  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
+
+- clock-output-names: from the common clock bindings, should contain names of
+  clocks registered by the camera subsystem corresponding to CAM_A_CLKOUT,
+  CAM_B_CLKOUT output clocks respectively.
+
+Note: #clock-cells and clock-output-names are mandatory properties if external
+image sensor devices reference 'camera' device node as a clock provider.
+
 'fimc' device nodes
 -------------------
 
@@ -97,8 +112,8 @@ Image sensor nodes
 The sensor device nodes should be added to their control bus controller (e.g.
 I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
 using the common video interfaces bindings, defined in video-interfaces.txt.
-The implementation of this bindings requires clock-frequency property to be
-present in the sensor device nodes.
+An optional clock-frequency property needs to be present in the sensor device
+nodes. Default value when this property is not present is 24 MHz.
 
 Example:
 
@@ -114,7 +129,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 1>;
 			clock-names = "mclk";
 
 			port {
@@ -135,7 +150,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 0>;
 			clock-names = "mclk";
 
 			port {
@@ -149,12 +164,15 @@ Example:
 
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

