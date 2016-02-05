Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55295 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbcBETKi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:38 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 7/8] [media] tvp5150: document input connectors DT bindings
Date: Fri,  5 Feb 2016 16:09:57 -0300
Message-Id: <1454699398-8581-8-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 decoder has different input connectors so extend the device
tree binding to allow device tree source files to define the connectors
that are available on a given board.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 .../devicetree/bindings/media/i2c/tvp5150.txt      | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
index 8c0fc1a26bf0..daa20e43a8e3 100644
--- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
+++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
@@ -12,6 +12,32 @@ Optional Properties:
 - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
 - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
 
+Optional nodes:
+- connectors: The input connectors of tvp5150 have to be defined under
+  a subnode name "connectors" using the following format:
+
+	input-connector-name {
+		input connector properties
+	};
+
+Each input connector must contain the following properties:
+
+	- label: a name for the connector.
+	- input: the input connector.
+
+The possible values for the "input" property are:
+	0: Composite0
+	1: Composite1
+	2: S-Video
+
+and on a tvp5150am1 and tvp5151 there is another:
+	4: Signal generator
+
+The list of valid input connectors are defined in dt-bindings/media/tvp5150.h
+header file and can be included by device tree source files.
+
+Each input connector can be defined only once.
+
 The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
@@ -36,6 +62,23 @@ Example:
 		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
 
+		connectors {
+			composite0 {
+				label = "Composite0";
+				input = <TVP5150_COMPOSITE0>;
+			};
+
+			composite1 {
+				label = "Composite1";
+				input = <TVP5150_COMPOSITE1>;
+			};
+
+			s-video {
+				label = "S-Video";
+				input = <TVP5150_SVIDEO>;
+			};
+		};
+
 		port {
 			tvp5150_1: endpoint {
 				remote-endpoint = <&ccdc_ep>;
-- 
2.5.0

