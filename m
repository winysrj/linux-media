Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39518 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbcBWSsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 13:48:25 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devicetree@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] Revert "[media] tvp5150: document input connectors DT bindings"
Date: Tue, 23 Feb 2016 15:48:08 -0300
Message-Id: <1456253288-397-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 82c2ffeb217a ("[media] tvp5150: document input
connectors DT bindings") since the DT binding is too device driver
specific and should instead be more generic and use the bindings
in Documentation/devicetree/bindings/display/connector/ and linked
to the tvp5150 using the OF graph port and endpoints.

There are still ongoing discussions about how the input connectors
will be supported by the Media Controller framework so until that
is settled, it is better to revert the connectors portion of the
bindings to avoid known to be broken bindings docs to hit mainline.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 .../devicetree/bindings/media/i2c/tvp5150.txt      | 43 ----------------------
 1 file changed, 43 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
index daa20e43a8e3..8c0fc1a26bf0 100644
--- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
+++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
@@ -12,32 +12,6 @@ Optional Properties:
 - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
 - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
 
-Optional nodes:
-- connectors: The input connectors of tvp5150 have to be defined under
-  a subnode name "connectors" using the following format:
-
-	input-connector-name {
-		input connector properties
-	};
-
-Each input connector must contain the following properties:
-
-	- label: a name for the connector.
-	- input: the input connector.
-
-The possible values for the "input" property are:
-	0: Composite0
-	1: Composite1
-	2: S-Video
-
-and on a tvp5150am1 and tvp5151 there is another:
-	4: Signal generator
-
-The list of valid input connectors are defined in dt-bindings/media/tvp5150.h
-header file and can be included by device tree source files.
-
-Each input connector can be defined only once.
-
 The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
@@ -62,23 +36,6 @@ Example:
 		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
 
-		connectors {
-			composite0 {
-				label = "Composite0";
-				input = <TVP5150_COMPOSITE0>;
-			};
-
-			composite1 {
-				label = "Composite1";
-				input = <TVP5150_COMPOSITE1>;
-			};
-
-			s-video {
-				label = "S-Video";
-				input = <TVP5150_SVIDEO>;
-			};
-		};
-
 		port {
 			tvp5150_1: endpoint {
 				remote-endpoint = <&ccdc_ep>;
-- 
2.5.0

