Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965057AbeBMRtE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:49:04 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 1/5] dt-bindings: media: adv7604: Extend bindings to allow specifying slave map addresses
Date: Tue, 13 Feb 2018 17:48:53 +0000
Message-Id: <1518544137-2742-2-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
References: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

The ADV7604 has thirteen 256-byte maps that can be accessed via the main
I2C ports. Each map has it own I2C address and acts as a standard slave
device on the I2C bus.

Extend the device tree node bindings to be able to override the default
addresses so that address conflicts with other devices on the same bus
may be resolved at the board description level.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
[Kieran: Re-adapted for mainline]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
Based upon the original posting :
  https://lkml.org/lkml/2014/10/22/469

v2:
 - DT Binding update separated from code change
 - Minor reword to commit message to account for DT only change.
 - Collected Rob's RB tag.

v3:
 - Split map register addresses into individual declarations.

v4:
 - Collect Laurents RB tag
 - Adapt commit title
 - Normalise I2C usage (I²C is harder to grep for)

 .../devicetree/bindings/media/i2c/adv7604.txt          | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index 9cbd92eb5d05..dcf57e7c60eb 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -13,7 +13,11 @@ Required Properties:
     - "adi,adv7611" for the ADV7611
     - "adi,adv7612" for the ADV7612
 
-  - reg: I2C slave address
+  - reg: I2C slave addresses
+    The ADV76xx has up to thirteen 256-byte maps that can be accessed via the
+    main I2C ports. Each map has it own I2C address and acts as a standard
+    slave device on the I2C bus. The main address is mandatory, others are
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
+		 * The edid page will be accessible @ 0x66 on the I2C bus. All
+		 * other maps will retain their default addresses.
+		 */
+		reg = <0x4c>, <0x66>;
+		reg-names "main", "edid";
 
 		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
 		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
-- 
2.7.4
