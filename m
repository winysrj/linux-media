Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47580 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964844AbeALR5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 12:57:04 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] media: dt-bindings: Add OF properties to ov7670
Date: Fri, 12 Jan 2018 18:56:47 +0100
Message-Id: <1515779808-21420-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1515779808-21420-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1515779808-21420-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe newly introduced OF properties for ov7670 image sensor.
The driver supports two standard properties to configure synchronism
signals polarities and one custom property already supported as
platform data options by the driver to suppress pixel clock during
horizontal blanking.

Re-phrase child nodes description while at there.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/i2c/ov7670.txt | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
index 826b656..7c89ea5 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
@@ -9,14 +9,23 @@ Required Properties:
 - clocks: reference to the xclk input clock.
 - clock-names: should be "xclk".
 
+Required Endpoint Properties:
+- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+  Default is active high.
+- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+  Default is active high.
+
 Optional Properties:
 - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
   Active is low.
 - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
   Active is high.
+- ov7670,pclk-hb-disable: a boolean property to suppress pixel clock output
+  signal during horizontal blankings.
 
-The device node must contain one 'port' child node for its digital output
-video port, in accordance with the video interface bindings defined in
+The device node must contain one 'port' child node with one 'endpoint' child
+sub-node for its digital output video port, in accordance with the video
+interface bindings defined in:
 Documentation/devicetree/bindings/media/video-interfaces.txt.
 
 Example:
@@ -34,8 +43,13 @@ Example:
 			assigned-clocks = <&pck0>;
 			assigned-clock-rates = <25000000>;
 
+			ov7670,pclk-hb-disable;
+
 			port {
 				ov7670_0: endpoint {
+					hsync-active = <0>;
+					vsync-active = <0>;
+
 					remote-endpoint = <&isi_0>;
 				};
 			};
-- 
2.7.4
