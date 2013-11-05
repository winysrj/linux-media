Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48332 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3KEGNz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 01:13:55 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v11 11/12] V4L: Add DT binding doc for s5k4e5 image sensor
Date: Tue,  5 Nov 2013 11:42:42 +0530
Message-Id: <1383631964-26514-12-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

S5K4E5 is a Samsung raw image sensor controlled via I2C.
This patch adds the DT binding documentation for the same.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 .../devicetree/bindings/media/samsung-s5k4e5.txt   |   45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k4e5.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt b/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
new file mode 100644
index 0000000..fc37792
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
@@ -0,0 +1,45 @@
+* Samsung S5K4E5 Raw Image Sensor
+
+S5K4E5 is a raw image sensor with maximum resolution of 2560x1920
+pixels. Data transfer is carried out via MIPI CSI-2 port and controls
+via I2C bus.
+
+Required Properties:
+- compatible	: should contain "samsung,s5k4e5"
+- reg		: I2C device address
+- reset-gpios	: specifier of a GPIO connected to the RESET pin
+- clocks	: should refer to the clock named in clock-names, from
+		  the common clock bindings
+- clock-names	: should contain "extclk" entry
+- svdda-supply	: core voltage supply
+- svddio-supply	: I/O voltage supply
+
+Optional Properties:
+- clock-frequency : the frequency at which the "extclk" clock should be
+		    configured to operate, in Hz; if this property is not
+		    specified default 24 MHz value will be used
+
+The device node should be added to respective control bus controller
+(e.g. I2C0) nodes and linked to the csis port node, using the common
+video interfaces bindings, defined in video-interfaces.txt.
+
+Example:
+
+	i2c-isp@13130000 {
+		s5k4e5@20 {
+			compatible = "samsung,s5k4e5";
+			reg = <0x20>;
+			reset-gpios = <&gpx1 2 1>;
+			clock-frequency = <24000000>;
+			clocks = <&clock 129>;
+			clock-names = "extclk"
+			svdda-supply = <...>;
+			svddio-supply = <...>;
+			port {
+				is_s5k4e5_ep: endpoint {
+					data-lanes = <1 2 3 4>;
+					remote-endpoint = <&csis0_ep>;
+				};
+			};
+		};
+	};
-- 
1.7.9.5

