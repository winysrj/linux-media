Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EBDC282D0
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE8C21852
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfA2QI0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:08:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45185 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfA2QIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:08:25 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1goVvk-0007VN-Q4; Tue, 29 Jan 2019 17:08:08 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1goVvj-0000dk-Ds; Tue, 29 Jan 2019 17:08:07 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sakari.ailus@linux.intel.com
Cc:     devicetree@vger.kernel.org, p.zabel@pengutronix.de,
        javierm@redhat.com, afshin.nasser@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        kernel@pengutronix.de, Rob Herring <robh@kernel.org>
Subject: [PATCH v4 3/7] media: dt-bindings: tvp5150: Add input port connectors DT bindings
Date:   Tue, 29 Jan 2019 17:07:53 +0100
Message-Id: <20190129160757.2314-4-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190129160757.2314-1-m.felsch@pengutronix.de>
References: <20190129160757.2314-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The TVP5150/1 decoders support different video input sources to their
AIP1A/B pins.

Possible configurations are as follows:
  - Analog Composite signal connected to AIP1A.
  - Analog Composite signal connected to AIP1B.
  - Analog S-Video Y (luminance) and C (chrominance)
    signals connected to AIP1A and AIP1B respectively.

This patch extends the device tree bindings documentation to describe
how the input connectors for these devices should be defined in a DT.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
---
Changelog:

v3:
- remove examples for one and two inputs
- replace space by tabs

v2:
- adapt port layout in accordance with
  https://www.spinics.net/lists/linux-media/msg138546.html with the
  svideo-connector deviation (use only one endpoint)

 .../devicetree/bindings/media/i2c/tvp5150.txt | 92 +++++++++++++++++--
 1 file changed, 85 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
index 8c0fc1a26bf0..bdd273d8b44d 100644
--- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
+++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
@@ -12,11 +12,31 @@ Optional Properties:
 - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
 - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
 
-The device node must contain one 'port' child node for its digital output
-video port, in accordance with the video interface bindings defined in
-Documentation/devicetree/bindings/media/video-interfaces.txt.
+The device node must contain one 'port' child node per device physical input
+and output port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
+are numbered as follows
 
-Required Endpoint Properties for parallel synchronization:
+	  Name		Type		Port
+	--------------------------------------
+	  AIP1A		sink		0
+	  AIP1B		sink		1
+	  Y-OUT		src		2
+
+The device node must contain at least one sink port and the src port. Each input
+port must be linked to an endpoint defined in
+Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt. The
+port/connector layout is as follows
+
+tvp-5150 port@0 (AIP1A)
+	endpoint@0 -----------> Comp0-Con  port
+	endpoint@1 -----------> Svideo-Con port
+tvp-5150 port@1 (AIP1B)
+	endpoint   -----------> Comp1-Con  port
+tvp-5150 port@2
+	endpoint (video bitstream output at YOUT[0-7] parallel bus)
+
+Required Endpoint Properties for parallel synchronization on output port:
 
 - hsync-active: active state of the HSYNC signal. Must be <1> (HIGH).
 - vsync-active: active state of the VSYNC signal. Must be <1> (HIGH).
@@ -26,17 +46,75 @@ Required Endpoint Properties for parallel synchronization:
 If none of hsync-active, vsync-active and field-even-active is specified,
 the endpoint is assumed to use embedded BT.656 synchronization.
 
-Example:
+Example - three input sources:
+
+comp_connector_0 {
+	compatible = "composite-video-connector";
+	label = "Composite0";
+
+	port {
+		composite0_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite0>;
+		};
+	};
+};
+
+comp_connector_1 {
+	compatible = "composite-video-connector";
+	label = "Composite1";
+
+	port {
+		composite1_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite1>;
+		};
+	};
+};
+
+svid_connector {
+	compatible = "svideo-connector";
+	label = "S-Video";
+
+	port {
+		svideo_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_svideo>;
+		};
+	};
+};
 
 &i2c2 {
-	...
 	tvp5150@5c {
 		compatible = "ti,tvp5150";
 		reg = <0x5c>;
 		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
 
-		port {
+		port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			tvp5150_to_composite0: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&composite0_to_tvp5150>;
+			};
+
+			tvp5150_to_svideo: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&svideo_to_tvp5150>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			tvp5150_to_composite1: endpoint {
+                                remote-endpoint = <&composite1_to_tvp5150>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
 			tvp5150_1: endpoint {
 				remote-endpoint = <&ccdc_ep>;
 			};
-- 
2.20.1

