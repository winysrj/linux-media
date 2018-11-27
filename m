Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38557 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbeK0VAt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:49 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH v3 5/6] dt-bindings: media: mt9m111: add pclk-sample property
Date: Tue, 27 Nov 2018 11:02:52 +0100
Message-Id: <20181127100253.30845-6-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the pclk-sample property to the list of optional properties
for the mt9m111 camera sensor.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index a431fb45704b..d0bed6fa901a 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -14,6 +14,10 @@ sub-node for its digital output video port, in accordance with the video
 interface bindings defined in:
 Documentation/devicetree/bindings/media/video-interfaces.txt
 
+Optional endpoint properties:
+- pclk-sample: For information see ../video-interfaces.txt. The value is set to
+  0 if it isn't specified.
+
 Example:
 
 	i2c_master {
@@ -26,6 +30,7 @@ Example:
 			port {
 				mt9m111_1: endpoint {
 					remote-endpoint = <&pxa_camera>;
+					pclk-sample = <1>;
 				};
 			};
 		};
-- 
2.19.1
