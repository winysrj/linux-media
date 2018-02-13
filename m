Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965350AbeBMRtG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:49:06 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 2/5] dt-bindings: adv7511: Extend bindings to allow specifying slave map addresses
Date: Tue, 13 Feb 2018 17:48:54 +0000
Message-Id: <1518544137-2742-3-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
References: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV7511 has four 256-byte maps that can be accessed via the main I2C
ports. Each map has it own I2C address and acts as a standard slave
device on the I2C bus.

Extend the device tree node bindings to be able to override the default
addresses so that address conflicts with other devices on the same bus
may be resolved at the board description level.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
 - Fixed up reg: property description to account for multiple optional
   addresses.
 - Minor reword to commit message to account for DT only change
 - Collected Robs RB tag

v3:
 - Split map register addresses into individual declarations.

v4:
 - Update commit title
 - Collect Laurent's RB tag
 - Fix nitpickings
 - Normalise I2C usage (I²C is harder to grep for)

 .../devicetree/bindings/display/bridge/adi,adv7511.txt | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
index 0047b1394c70..2c887536258c 100644
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
@@ -14,7 +14,13 @@ Required properties:
 		"adi,adv7513"
 		"adi,adv7533"
 
-- reg: I2C slave address
+- reg: I2C slave addresses
+  The ADV7511 internal registers are split into four pages exposed through
+  different I2C addresses, creating four register maps. Each map has it own
+  I2C address and acts as a standard slave device on the I2C bus. The main
+  address is mandatory, others are optional and revert to defaults if not
+  specified.
+
 
 The ADV7511 supports a large number of input data formats that differ by their
 color depth, color format, clock mode, bit justification and random
@@ -70,6 +76,9 @@ Optional properties:
   rather than generate its own timings for HDMI output.
 - clocks: from common clock binding: reference to the CEC clock.
 - clock-names: from common clock binding: must be "cec".
+- reg-names : Names of maps with programmable addresses.
+	It can contain any map needing a non-default address.
+	Possible maps names are : "main", "edid", "cec", "packet"
 
 Required nodes:
 
@@ -88,7 +97,12 @@ Example
 
 	adv7511w: hdmi@39 {
 		compatible = "adi,adv7511w";
-		reg = <39>;
+		/*
+		 * The EDID page will be accessible on address 0x66 on the I2C
+		 * bus. All other maps continue to use their default addresses.
+		 */
+		reg = <0x39>, <0x66>;
+		reg-names = "main", "edid";
 		interrupt-parent = <&gpio3>;
 		interrupts = <29 IRQ_TYPE_EDGE_FALLING>;
 		clocks = <&cec_clock>;
-- 
2.7.4
