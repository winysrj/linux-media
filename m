Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23520 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3H2J2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 05:28:03 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mturquette@linaro.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	swarren@wwwdotorg.org, pawel.moll@arm.com, rob.herring@calxeda.com,
	galak@codeaurora.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v2 2/7] V4L: s5k6a3: Add DT binding documentation
Date: Thu, 29 Aug 2013 11:24:33 +0200
Message-id: <1377768278-15391-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1377768278-15391-1-git-send-email-s.nawrocki@samsung.com>
References: <1377768278-15391-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds binding documentation for the Samsung S5K6A3(YX)
raw image sensor.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

The binding of this sensors shows some issue in the generic video-interfaces
binding. Namely The video bus type (serial MIPI CSI-2, parallel ITU-R BT.656,
etc.) is being determined by the binding parser (v4l2-of.c) depending on what
properties are found in an enddpoint node.

Please have a look at the data-lanes property description. The sensor supports
MIPI CSI-2 and SMIA CCP2 interfaces which both use one data lane. One data lane
is everything this sensors supports. During our discussions on the generic
bidings in the past I proposed to introduce a property in the endpoint node
that would indicate what bus type (standard/protocol) is used, e.g. MIPI CSI-2,
ITU-R BT.656, SMIA CCP2, etc. It was argued though that we can well determine
bus type based on properties found in the endpoint node.

So now in case of this sensor I'm not sure how it can be differentiated
whether MIPI CSI-2 or CCP2 bus is used. There is no CCP2 specific generic
properties yet. Anyway I'm not really happy there is no property like bus_type
that would clearly indicate what data bus type is used. Then would would for
instance not specify "data-lanes" in endpoint node just to differentiate
between MIPI CSI-2 and the parallel busses.

The main issue for this particular binding is that even with data-lanes = <1>;
it is still impossible to figure out whether MIPI CSI-2 or SMIA CCP2 data bus
is used.

So how about introducing, e.g. a string type "bus_type" common property ?
I'm considering starting a separate thread for discussing this.
---
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   31 ++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
new file mode 100644
index 0000000..a51fbe8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
@@ -0,0 +1,31 @@
+Samsung S5K6A3(YX) raw image sensor
+---------------------------------
+
+S5K6A3YX is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
+and CCI (I2C compatible) control bus.
+
+Required properties:
+
+- compatible	: "samsung,s5k6a3yx";
+- reg		: I2C slave address of the sensor;
+- svdda-supply	: core voltage supply;
+- svddio-supply	: I/O voltage supply;
+- gpios		: specifier of a GPIO connected to the RESET pin;
+- clocks	: should contain the sensor's EXTCLK clock specifier, from
+		  the common clock bindings.
+- clock-names	: should contain "extclk" entry;
+
+Optional properties:
+
+- clock-frequency : the frequency at which the "extclk" clock should be
+		    configured to operate, in Hz; if this property is not
+		    specified default 24 MHz value will be used.
+
+The common video interfaces bindings (see video-interfaces.txt) should be
+used to specify link to the image data receiver. The S5K6A3(YX) device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Following properties are valid for the endpoint node:
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+  video-interfaces.txt.  The sensor supports only one data lane.
--
1.7.9.5

