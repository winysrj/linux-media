Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53546 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3LELjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 06:39:04 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v10 2/2] s5k5baf: add DT bindings for camera sensor
Date: Thu, 05 Dec 2013 12:38:40 +0100
Message-id: <1386243520-17117-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1386243520-17117-1-git-send-email-a.hajda@samsung.com>
References: <1386243520-17117-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds the DT bindings documentation for
Samsung S5K5BAF Image Sensor.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
v10
- bindings moved to separate patch,
- improved clocks description.
---
 .../devicetree/bindings/media/samsung-s5k5baf.txt  | 58 ++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
new file mode 100644
index 0000000..1f51e04
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
@@ -0,0 +1,58 @@
+Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
+--------------------------------------------------------------------
+
+Required properties:
+
+- compatible	  : "samsung,s5k5baf";
+- reg		  : I2C slave address of the sensor;
+- vdda-supply	  : analog power supply 2.8V (2.6V to 3.0V);
+- vddreg-supply	  : regulator input power supply 1.8V (1.7V to 1.9V)
+		    or 2.8V (2.6V to 3.0);
+- vddio-supply	  : I/O power supply 1.8V (1.65V to 1.95V)
+		    or 2.8V (2.5V to 3.1V);
+- stbyn-gpios	  : GPIO connected to STDBYN pin;
+- rstn-gpios	  : GPIO connected to RSTN pin;
+- clocks	  : list of phandle and clock specifier pairs
+		    according to common clock bindings for the
+		    clocks described in clock-names;
+- clock-names	  : should include "mclk" for the sensor's master clock;
+
+Optional properties:
+
+- clock-frequency : the frequency at which the "mclk" clock should be
+		    configured to operate, in Hz; if this property is not
+		    specified default 24 MHz value will be used.
+
+The device node should contain one 'port' child node with one child 'endpoint'
+node, according to the bindings defined in Documentation/devicetree/bindings/
+media/video-interfaces.txt. The following are properties specific to those
+nodes.
+
+endpoint node
+-------------
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+	       video-interfaces.txt. If present it should be <1> - the device
+	       supports only one data lane without re-mapping.
+
+Example:
+
+s5k5bafx@2d {
+	compatible = "samsung,s5k5baf";
+	reg = <0x2d>;
+	vdda-supply = <&cam_io_en_reg>;
+	vddreg-supply = <&vt_core_15v_reg>;
+	vddio-supply = <&vtcam_reg>;
+	stbyn-gpios = <&gpl2 0 1>;
+	rstn-gpios = <&gpl2 1 1>;
+	clock-names = "mclk";
+	clocks = <&clock_cam 0>;
+	clock-frequency = <24000000>;
+
+	port {
+		s5k5bafx_ep: endpoint {
+			remote-endpoint = <&csis1_ep>;
+			data-lanes = <1>;
+		};
+	};
+};
-- 
1.8.3.2

