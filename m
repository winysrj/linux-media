Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46063 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbeK0VAr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:47 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH v3 4/6] dt-bindings: media: mt9m111: adapt documentation to be more clear
Date: Tue, 27 Nov 2018 11:02:51 +0100
Message-Id: <20181127100253.30845-5-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the vague binding by a more verbose. Remove the remote property
from the example since the driver don't support such a property. Also
remove the bus-width property from the endpoint since the driver don't
take care of it.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>

---
Changelog:

v3:
- drop remote-endpoint docu, since it is documented by
  video-interfaces.txt.

v2:
- initial commit

 Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index 6b910036b57e..a431fb45704b 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -9,8 +9,10 @@ Required Properties:
 - clocks: reference to the master clock.
 - clock-names: shall be "mclk".
 
-For further reading on port node refer to
-Documentation/devicetree/bindings/media/video-interfaces.txt.
+The device node must contain one 'port' child node with one 'endpoint' child
+sub-node for its digital output video port, in accordance with the video
+interface bindings defined in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
 
 Example:
 
@@ -21,10 +23,8 @@ Example:
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
