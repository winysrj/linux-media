Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752370AbeBLSMN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 13:12:13 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH v2 2/5] dt-bindings: adv7511: Add support for i2c_new_secondary_device
Date: Mon, 12 Feb 2018 18:11:54 +0000
Message-Id: <1518459117-16733-3-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
References: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV7511 has four 256-byte maps that can be accessed via the main I²C
ports. Each map has it own I²C address and acts as a standard slave
device on the I²C bus.

Extend the device tree node bindings to be able to override the default
addresses so that address conflicts with other devices on the same bus
may be resolved at the board description level.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v2:
 - Fixed up reg: property description to account for multiple optional
   addresses.
 - Minor reword to commit message to account for DT only change
 - Collected Robs RB tag

 .../devicetree/bindings/display/bridge/adi,adv7511.txt | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
index 0047b1394c70..f1b5466b1ca7 100644
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
@@ -14,7 +14,13 @@ Required properties:
 		"adi,adv7513"
 		"adi,adv7533"
 
-- reg: I2C slave address
+- reg: I2C slave addresses
+  The ADV7511 internal registers are split into four pages exposed through
+  different I2C addresses, creating four register maps. Each map has it own
+  I2C address and acts as a standard slave device on the I²C bus. The main
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
+		 * The EDID page will be accessible on address 0x66 on the i2c
+		 * bus. All other maps continue to use their default addresses.
+		 */
+		reg = <0x39 0x66>;
+		reg-names = "main", "edid";
 		interrupt-parent = <&gpio3>;
 		interrupts = <29 IRQ_TYPE_EDGE_FALLING>;
 		clocks = <&cec_clock>;
-- 
2.7.4
