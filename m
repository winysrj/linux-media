Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33638 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbeHHTwP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 15:52:15 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: mchehab@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] dt-bindings: media: adv748x: Document secondary addresses
Date: Wed,  8 Aug 2018 18:31:28 +0100
Message-Id: <20180808173128.6400-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x supports configurable slave addresses for its I2C pages.
Document the page names, and example for setting each of the pages
excplicitly.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 .../devicetree/bindings/media/i2c/adv748x.txt          | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
index 21ffb5ed8183..9515d8ad0e31 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
@@ -18,6 +18,11 @@ Optional Properties:
 		     "intrq3". All interrupts are optional. The "intrq3" interrupt
 		     is only available on the adv7481
   - interrupts: Specify the interrupt lines for the ADV748x
+  - reg-names : Names of maps with programmable addresses.
+		It can contain any map needed a non-default address.
+		Possible map names are:
+		  "main", "dpll", "cp", "hdmi", "edid", "repeater",
+		  "infoframe", "cbus", "cec", "sdp", "txa", "txb"
 
 The device node must contain one 'port' child node per device input and output
 port, in accordance with the video interface bindings defined in
@@ -47,7 +52,10 @@ Example:
 
 	video-receiver@70 {
 		compatible = "adi,adv7482";
-		reg = <0x70>;
+		reg = <0x70 0x71 0x72 0x73 0x74 0x75
+		       0x60 0x61 0x62 0x63 0x64 0x65>;
+		reg-names = "main", "dpll", "cp", "hdmi", "edid", "repeater",
+			    "infoframe", "cbus", "cec", "sdp", "txa", "txb";
 
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.17.1
