Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40284 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896AbcCITJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 14:09:59 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC PATCH 2/3] [media] tvp5150: Add input connectors DT bindings
Date: Wed,  9 Mar 2016 16:09:25 -0300
Message-Id: <1457550566-5465-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 and tvp5151 decoders support different video input source
connections to their AIP1A and AIP1B pins. Either two Composite input
signals or a S-Video (with separate Y and C signals) are supported.

The possible configurations are as follows:

- Analog Composite signal connected to AIP1A
- Analog Composite signal connected to AIP1B
- Analog S-Video Y (luminance) and C (chrominance)
  signals connected to AIP1A and AIP1B respectively.

Since the Composite signals shares the same pins than the S-Video ones,
some devices multiplex the physical connectors so the same connector
can be used for either Composite or a S-Video signal (Y or C). But from
the tvp5150 point of view, there are three different "connections", so
the DT binding models the hardware as three separate connectors instead.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
Hello,

There are still some questions about how the pins / video signals are
going to be represented in DT (if represented at all?). In this case
I chose to not describe that information in DT because the driver is
able to figure out from the connectors what links have to be created
and on which PADs.

But I guess that won't be possible for more complex hardware without
having that information in the DT so that should be discussed as well.

There is also the questions about how the connector bindings will be
extended to support other attributes like color/position/group using
the properties API.

Best regards,
Javier

 .../devicetree/bindings/media/i2c/tvp5150.txt      | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
index 8c0fc1a26bf0..df555650b0b4 100644
--- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
+++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
@@ -26,8 +26,46 @@ Required Endpoint Properties for parallel synchronization:
 If none of hsync-active, vsync-active and field-even-active is specified,
 the endpoint is assumed to use embedded BT.656 synchronization.
 
+-Optional nodes:
+- connectors: The list of tvp5150 input connectors available on a given
+  board. The node should contain a child 'port' node for each connector.
+
+  The tvp5150 has support for three possible connectors: 2 Composite and
+  1 S-video. The "reg" property is used to specify which input connector
+  is associated with each 'port', using the following possible values:
+
+  0: Composite0
+  1: Composite1
+  2: S-Video
+
+  The ports should have an endpoint subnode that is linked to a connector
+  node defined in Documentation/devicetree/bindings/display/connector/.
+  The linked connector compatible string should match the connector type.
+
 Example:
 
+composite0: connector@0 {
+	compatible = "composite-video-connector";
+	label = "Composite0";
+
+	port {
+		comp0_out: endpoint {
+			remote-endpoint = <&tvp5150_comp0_in>;
+		};
+	};
+};
+
+svideo: connector@1 {
+	compatible = "composite-video-connector";
+	label = "S-Video";
+
+	port {
+		svideo_out: endpoint {
+			remote-endpoint = <&tvp5150_svideo_in>;
+		};
+	};
+};
+
 &i2c2 {
 	...
 	tvp5150@5c {
@@ -36,6 +74,27 @@ Example:
 		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
 
+		connectors {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Composite0 input */
+			port@0 {
+				reg = <0>;
+				tvp5150_comp0_in: endpoint {
+					remote-endpoint = <&comp0_out>;
+				};
+			};
+
+			/* S-Video input */
+			port@2 {
+				reg = <2>;
+				tvp5150_svideo_in: endpoint {
+					remote-endpoint = <&svideo_out>;
+				};
+			};
+		};
+
 		port {
 			tvp5150_1: endpoint {
 				remote-endpoint = <&ccdc_ep>;
-- 
2.5.0

