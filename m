Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46525 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbeJ3DOQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 23:14:16 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH v2 5/6] dt-bindings: media: mt9m111: adapt documentation to be more clear
Date: Mon, 29 Oct 2018 19:24:09 +0100
Message-Id: <20181029182410.18783-6-m.felsch@pengutronix.de>
In-Reply-To: <20181029182410.18783-1-m.felsch@pengutronix.de>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the vague binding by a more verbose. Remove the remote property
from the example since the driver don't support such a property. Also
remove the bus-width property from the endpoint since the driver don't
take care of it.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 .../devicetree/bindings/media/i2c/mt9m111.txt         | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index 6b910036b57e..921cc48c488b 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -9,8 +9,13 @@ Required Properties:
 - clocks: reference to the master clock.
 - clock-names: shall be "mclk".
 
-For further reading on port node refer to
-Documentation/devicetree/bindings/media/video-interfaces.txt.
+The device node must contain one 'port' child node with one 'endpoint' child
+sub-node for its digital output video port, in accordance with the video
+interface bindings defined in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
+
+Required endpoint properties:
+- remote-endpoint: For information see ../video-interfaces.txt.
 
 Example:
 
@@ -21,10 +26,8 @@ Example:
 			clocks = <&mclk>;
 			clock-names = "mclk";
 
-			remote = <&pxa_camera>;
 			port {
 				mt9m111_1: endpoint {
-					bus-width = <8>;
 					remote-endpoint = <&pxa_camera>;
 				};
 			};
-- 
2.19.1
