Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40029 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758401AbdLROL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:11:58 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 5/6] arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
Date: Mon, 18 Dec 2017 15:11:45 +0100
Message-Id: <20171218141146.23746-6-embed3d@gmail.com>
In-Reply-To: <20171218141146.23746-1-embed3d@gmail.com>
References: <20171218141146.23746-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Bananapi M3 has an onboard IR receiver.
This enables the onboard IR receiver subnode.
Unlike the other IR receivers this one needs a base clock frequency
of 3000000 Hz (3 MHz), to be able to work.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
index 6550bf0e594b..ffc6445fd281 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -82,6 +82,13 @@
 	};
 };
 
+&cir {
+	pinctrl-names = "default";
+	pinctrl-0 = <&cir_pins>;
+	clock-frequency = <3000000>;
+	status = "okay";
+};
+
 &ehci0 {
 	/* Terminus Tech FE 1.1s 4-port USB 2.0 hub here */
 	status = "okay";
-- 
2.11.0
