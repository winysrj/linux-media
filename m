Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44659 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbeJ3DOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 23:14:17 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH v2 6/6] dt-bindings: media: mt9m111: add pclk-sample property
Date: Mon, 29 Oct 2018 19:24:10 +0100
Message-Id: <20181029182410.18783-7-m.felsch@pengutronix.de>
In-Reply-To: <20181029182410.18783-1-m.felsch@pengutronix.de>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the pclk-sample property to the list of optional properties
for the mt9m111 camera sensor.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index 921cc48c488b..6dfd0f0f6245 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -17,6 +17,10 @@ Documentation/devicetree/bindings/media/video-interfaces.txt
 Required endpoint properties:
 - remote-endpoint: For information see ../video-interfaces.txt.
 
+Optional endpoint properties:
+- pclk-sample: For information see ../video-interfaces.txt. The value is set to
+  0 if it isn't specified.
+
 Example:
 
 	i2c_master {
@@ -29,6 +33,7 @@ Example:
 			port {
 				mt9m111_1: endpoint {
 					remote-endpoint = <&pxa_camera>;
+					pclk-sample = <1>;
 				};
 			};
 		};
-- 
2.19.1
