Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42787 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbeGMKNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 06:13:36 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH v2 1/2] media: dt-bindings: bind nokia,n900-ir to generic pwm-ir-tx driver
Date: Fri, 13 Jul 2018 10:59:35 +0100
Message-Id: <20180713095936.17673-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generic pwm-ir-tx driver should work for the Nokia n900.

Compile tested only.

Cc: Rob Herring <robh@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 .../devicetree/bindings/media/nokia,n900-ir   | 20 -------------------
 arch/arm/boot/dts/omap3-n900.dts              |  2 +-
 drivers/media/rc/pwm-ir-tx.c                  |  1 +
 3 files changed, 2 insertions(+), 21 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir

diff --git a/Documentation/devicetree/bindings/media/nokia,n900-ir b/Documentation/devicetree/bindings/media/nokia,n900-ir
deleted file mode 100644
index 13a18ce37dd1..000000000000
--- a/Documentation/devicetree/bindings/media/nokia,n900-ir
+++ /dev/null
@@ -1,20 +0,0 @@
-Device-Tree bindings for LIRC TX driver for Nokia N900(RX51)
-
-Required properties:
-	- compatible: should be "nokia,n900-ir".
-	- pwms: specifies PWM used for IR signal transmission.
-
-Example node:
-
-	pwm9: dmtimer-pwm@9 {
-		compatible = "ti,omap-dmtimer-pwm";
-		ti,timers = <&timer9>;
-		ti,clock-source = <0x00>; /* timer_sys_ck */
-		#pwm-cells = <3>;
-	};
-
-	ir: n900-ir {
-		compatible = "nokia,n900-ir";
-
-		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
-	};
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 182a53991c90..fd12dea15799 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -154,7 +154,7 @@
 	};
 
 	ir: n900-ir {
-		compatible = "nokia,n900-ir";
+		compatible = "nokia,n900-ir", "pwm-ir-tx";
 		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
 	};
 
diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
index 27d0f5837a76..272947b430c8 100644
--- a/drivers/media/rc/pwm-ir-tx.c
+++ b/drivers/media/rc/pwm-ir-tx.c
@@ -30,6 +30,7 @@ struct pwm_ir {
 };
 
 static const struct of_device_id pwm_ir_of_match[] = {
+	{ .compatible = "nokia,n900-ir" },
 	{ .compatible = "pwm-ir-tx", },
 	{ },
 };
-- 
2.17.1
