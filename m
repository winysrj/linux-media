Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57284 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaCKQfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:35:07 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v8 3/10] Documentation: devicetree: Update Samsung FIMC DT
 binding
Date: Tue, 11 Mar 2014 17:34:30 +0100
Message-id: <1394555670-14155-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1823087.0J3KNi6X3C@avalon>
References: <1823087.0J3KNi6X3C@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch documents following updates of the Exynos4 SoC camera subsystem
devicetree binding:

 - addition of #clock-cells and clock-output-names properties to 'camera'
   node - these are now needed so the image sensor sub-devices can reference
   clocks provided by the camera host interface,
 - dropped a note about required clock-frequency properties at the
   image sensor nodes; the sensor devices can now control their clock
   explicitly through the clk API and there is no need to require this
   property in the camera host interface binding.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v7:
 - dropped a note about clock-frequency property in sensor nodes.

Changes since v6:
 - #clock-cells, clock-output-names documented as mandatory properties;
 - renamed "cam_mclk_{a,b}" to "cam_{a,b}_clkout in the example dts,
   this now matches changes in exynos4.dtsi further in the patch series;
 - marked "samsung,camclk-out" property as deprecated.

Changes since v5:
 - none.

Changes since v4:
 - dropped a requirement of specific order of values in clocks/
   clock-names properties (Mark) and reference to clock-names in
   clock-output-names property description (Mark).
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   44 +++++++++++++-------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 96312f6..922d6f8 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -15,11 +15,21 @@ Common 'camera' node

 Required properties:

-- compatible	: must be "samsung,fimc", "simple-bus"
-- clocks	: list of clock specifiers, corresponding to entries in
-		  the clock-names property;
-- clock-names	: must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
-		  "pxl_async1" entries, matching entries in the clocks property.
+- compatible: must be "samsung,fimc", "simple-bus"
+- clocks: list of clock specifiers, corresponding to entries in
+  the clock-names property;
+- clock-names : must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
+  "pxl_async1" entries, matching entries in the clocks property.
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

 The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
 to define a required pinctrl state named "default" and optional pinctrl states:
@@ -32,6 +42,7 @@ way around.

 The 'camera' node must include at least one 'fimc' child node.

+
 'fimc' device nodes
 -------------------

@@ -88,8 +99,8 @@ port nodes specifies data input - 0, 1 indicates input A, B respectively.

 Optional properties

-- samsung,camclk-out : specifies clock output for remote sensor,
-		       0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
+- samsung,camclk-out (deprecated) : specifies clock output for remote sensor,
+  0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;

 Image sensor nodes
 ------------------
@@ -97,8 +108,6 @@ Image sensor nodes
 The sensor device nodes should be added to their control bus controller (e.g.
 I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
 using the common video interfaces bindings, defined in video-interfaces.txt.
-The implementation of this bindings requires clock-frequency property to be
-present in the sensor device nodes.

 Example:

@@ -114,7 +123,7 @@ Example:
 			vddio-supply = <...>;

 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 1>;
 			clock-names = "mclk";

 			port {
@@ -135,7 +144,7 @@ Example:
 			vddio-supply = <...>;

 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camera 0>;
 			clock-names = "mclk";

 			port {
@@ -149,12 +158,17 @@ Example:

 	camera {
 		compatible = "samsung,fimc", "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		status = "okay";
-
+		clocks = <&clock 132>, <&clock 133>, <&clock 351>,
+			 <&clock 352>;
+		clock-names = "sclk_cam0", "sclk_cam1", "pxl_async0",
+			      "pxl_async1";
+		#clock-cells = <1>;
+		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		status = "okay";
+		#address-cells = <1>;
+		#size-cells = <1>;

 		/* parallel camera ports */
 		parallel-ports {
--
1.7.9.5

