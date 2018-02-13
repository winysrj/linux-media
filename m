Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965057AbeBMRtI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:49:08 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 3/5] [RFT] ARM: dts: wheat: Fix ADV7513 address usage
Date: Tue, 13 Feb 2018 17:48:55 +0000
Message-Id: <1518544137-2742-4-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
References: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The r8a7792 Wheat board has two ADV7513 devices sharing a single I2C
bus, however in low power mode the ADV7513 will reset it's slave maps to
use the hardware defined default addresses.

The ADV7511 driver was adapted to allow the two devices to be registered
correctly - but it did not take into account the fault whereby the
devices reset the addresses.

This results in an address conflict between the device using the default
addresses, and the other device if it is in low-power-mode.

Repair this issue by moving both devices away from the default address
definitions.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
 - Addition to series

v3:
 - Split map register addresses into individual declarations.

v4:
 - Normalise I2C usage

 arch/arm/boot/dts/r8a7792-wheat.dts | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7792-wheat.dts b/arch/arm/boot/dts/r8a7792-wheat.dts
index b9471b67b728..42fff8837eab 100644
--- a/arch/arm/boot/dts/r8a7792-wheat.dts
+++ b/arch/arm/boot/dts/r8a7792-wheat.dts
@@ -240,9 +240,16 @@
 	status = "okay";
 	clock-frequency = <400000>;
 
+	/*
+	 * The adv75xx resets its addresses to defaults during low power power
+	 * mode. Because we have two ADV7513 devices on the same bus, we must
+	 * change both of them away from the defaults so that they do not
+	 * conflict.
+	 */
 	hdmi@3d {
 		compatible = "adi,adv7513";
-		reg = <0x3d>;
+		reg = <0x3d>, <0x2d>, <0x4d>, <0x5d>;
+		reg-names = "main", "cec", "edid", "packet";
 
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
@@ -272,7 +279,8 @@
 
 	hdmi@39 {
 		compatible = "adi,adv7513";
-		reg = <0x39>;
+		reg = <0x39>, <0x29>, <0x49>, <0x59>;
+		reg-names = "main", "cec", "edid", "packet";
 
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
-- 
2.7.4
