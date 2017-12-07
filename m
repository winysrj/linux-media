Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55219 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753396AbdLGMls (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 07:41:48 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 3/5] media: dt-bindings: ov5640: add support of DVP parallel interface
Date: Thu, 7 Dec 2017 13:40:51 +0100
Message-ID: <1512650453-24476-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
References: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings for OV5640 DVP parallel interface support.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 .../devicetree/bindings/media/i2c/ov5640.txt       | 27 ++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
index 540b36c..04e2a91 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -1,4 +1,4 @@
-* Omnivision OV5640 MIPI CSI-2 sensor
+* Omnivision OV5640 MIPI CSI-2 / parallel sensor
 
 Required Properties:
 - compatible: should be "ovti,ov5640"
@@ -18,7 +18,11 @@ The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
 
-Example:
+Parallel or CSI mode is selected according to optional endpoint properties.
+Without properties (or bus properties), parallel mode is selected.
+Specifying any CSI properties such as lanes will enable CSI mode.
+
+Examples:
 
 &i2c1 {
 	ov5640: camera@3c {
@@ -35,6 +39,7 @@ Example:
 		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
 
 		port {
+			/* MIPI CSI-2 bus endpoint */
 			ov5640_to_mipi_csi2: endpoint {
 				remote-endpoint = <&mipi_csi2_from_ov5640>;
 				clock-lanes = <0>;
@@ -43,3 +48,21 @@ Example:
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
+			};
+		};
+	};
+};
-- 
1.9.1
