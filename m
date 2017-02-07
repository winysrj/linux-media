Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35791 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbdBGQlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 11:41:52 -0500
Received: by mail-wm0-f45.google.com with SMTP id v186so18848712wmd.0
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 08:41:52 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 05/10] ARM: dts: da850: add vpif video display pins
Date: Tue,  7 Feb 2017 17:41:18 +0100
Message-Id: <1486485683-11427-6-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new pinctrl sub-node for vpif display pins. Move VP_CLKIN3 and
VP_CLKIN2 to the display node where they actually belong (vide section
35.2.2 of the da850 datasheet).

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/boot/dts/da850-evm.dts |  2 +-
 arch/arm/boot/dts/da850.dtsi    | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 3d6dd66..6db16ba 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -295,7 +295,7 @@
 
 &vpif {
 	pinctrl-names = "default";
-	pinctrl-0 = <&vpif_capture_pins>;
+	pinctrl-0 = <&vpif_capture_pins>, <&vpif_display_pins>;
 	status = "okay";
 
 	/* VPIF capture port */
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 768a58c..d317bc5 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -218,8 +218,21 @@
 					0x3c 0x11111111 0xffffffff
 					/* VP_DIN[8..9] */
 					0x40 0x00000011 0x000000ff
-					/* VP_CLKIN3, VP_CLKIN2 */
-					0x4c 0x00010100 0x000f0f00
+				>;
+			};
+			vpif_display_pins: vpif_display_pins {
+				pinctrl-single,bits = <
+					/* VP_DOUT[2..7] */
+					0x40 0x11111100 0xffffff00
+					/* VP_DOUT[10..15,0..1] */
+					0x44 0x11111111 0xffffffff
+					/*  VP_DOUT[8..9] */
+					0x48 0x00000011 0x000000ff
+					/*
+					 * VP_CLKOUT3, VP_CLKIN3,
+					 * VP_CLKOUT2, VP_CLKIN2
+					 */
+					0x4c 0x00111100 0x00ffff00
 				>;
 			};
 		};
-- 
2.9.3

