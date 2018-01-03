Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55912 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752249AbeACJ6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 04:58:39 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v5 3/5] media: dt-bindings: ov5640: refine CSI-2 and add parallel interface
Date: Wed, 3 Jan 2018 10:57:30 +0100
Message-ID: <1514973452-10464-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refine CSI-2 endpoint documentation and add bindings
for DVP parallel interface support.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 .../devicetree/bindings/media/i2c/ov5640.txt       | 46 +++++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
index 540b36c..8e36da0 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -1,4 +1,4 @@
-* Omnivision OV5640 MIPI CSI-2 sensor
+* Omnivision OV5640 MIPI CSI-2 / parallel sensor
 
 Required Properties:
 - compatible: should be "ovti,ov5640"
@@ -18,7 +18,25 @@ The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
 
-Example:
+OV5640 can be connected to a MIPI CSI-2 bus or a parallel bus endpoint.
+
+Endpoint node required properties for CSI-2 connection are:
+- remote-endpoint: a phandle to the bus receiver's endpoint node.
+- clock-lanes: should be set to <0> (clock lane on hardware lane 0)
+- data-lanes: should be set to <1> or <1 2> (one or two CSI-2 lanes supported)
+
+Endpoint node required properties for parallel connection are:
+- remote-endpoint: a phandle to the bus receiver's endpoint node.
+- bus-width: shall be set to <8> for 8 bits parallel bus
+	     or <10> for 10 bits parallel bus
+- data-shift: shall be set to <2> for 8 bits parallel bus
+	      (lines 9:2 are used) or <0> for 10 bits parallel bus
+- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
+	       signal.
+
+Examples:
 
 &i2c1 {
 	ov5640: camera@3c {
@@ -35,6 +53,7 @@ Example:
 		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
 
 		port {
+			/* MIPI CSI-2 bus endpoint */
 			ov5640_to_mipi_csi2: endpoint {
 				remote-endpoint = <&mipi_csi2_from_ov5640>;
 				clock-lanes = <0>;
@@ -43,3 +62,26 @@ Example:
 		};
 	};
 };
+
+&i2c1 {
+	ov5640: camera@3c {
+		compatible = "ovti,ov5640";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		reg = <0x3c>;
+		clocks = <&clk_ext_camera>;
+		clock-names = "xclk";
+
+		port {
+			/* Parallel bus endpoint */
+			ov5640_to_parallel: endpoint {
+				remote-endpoint = <&parallel_from_ov5640>;
+				bus-width = <8>;
+				data-shift = <2>; /* lines 9:2 are used */
+				hsync-active = <0>;
+				vsync-active = <0>;
+				pclk-sample = <1>;
+			};
+		};
+	};
+};
-- 
1.9.1
