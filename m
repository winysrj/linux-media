Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752331AbeBLSMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 13:12:08 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH v2 1/5] dt-bindings: media: adv7604: Add support for i2c_new_secondary_device
Date: Mon, 12 Feb 2018 18:11:53 +0000
Message-Id: <1518459117-16733-2-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
References: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

The ADV7604 has thirteen 256-byte maps that can be accessed via the main
I²C ports. Each map has it own I²C address and acts as a standard slave
device on the I²C bus.

Extend the device tree node bindings to be able to override the default
addresses so that address conflicts with other devices on the same bus
may be resolved at the board description level.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
[Kieran: Re-adapted for mainline]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>

---
Based upon the original posting :
  https://lkml.org/lkml/2014/10/22/469

v2:
 - DT Binding update separated from code change
 - Minor reword to commit message to account for DT only change.
 - Collected Rob's RB tag.

 .../devicetree/bindings/media/i2c/adv7604.txt          | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index 9cbd92eb5d05..b64e313dcc66 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -13,7 +13,11 @@ Required Properties:
     - "adi,adv7611" for the ADV7611
     - "adi,adv7612" for the ADV7612
 
-  - reg: I2C slave address
+  - reg: I2C slave addresses
+    The ADV76xx has up to thirteen 256-byte maps that can be accessed via the
+    main I²C ports. Each map has it own I²C address and acts as a standard
+    slave device on the I²C bus. The main address is mandatory, others are
+    optional and revert to defaults if not specified.
 
   - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
     detection pins, one per HDMI input. The active flag indicates the GPIO
@@ -35,6 +39,11 @@ Optional Properties:
 
   - reset-gpios: Reference to the GPIO connected to the device's reset pin.
   - default-input: Select which input is selected after reset.
+  - reg-names : Names of maps with programmable addresses.
+		It can contain any map needing a non-default address.
+		Possible maps names are :
+		  "main", "avlink", "cec", "infoframe", "esdp", "dpp", "afe",
+		  "rep", "edid", "hdmi", "test", "cp", "vdp"
 
 Optional Endpoint Properties:
 
@@ -52,7 +61,12 @@ Example:
 
 	hdmi_receiver@4c {
 		compatible = "adi,adv7611";
-		reg = <0x4c>;
+		/*
+		 * The edid page will be accessible @ 0x66 on the i2c bus. All
+		 * other maps will retain their default addresses.
+		 */
+		reg = <0x4c 0x66>;
+		reg-names "main", "edid";
 
 		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
 		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
-- 
2.7.4
