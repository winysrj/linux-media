Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45002 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935182AbeBMMaC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 07:30:02 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RESEND PATCH v5 3/6] arm: dts: sun8i: a83t: Add the cir pin for the A83T
Date: Tue, 13 Feb 2018 13:29:49 +0100
Message-Id: <20180213122952.8420-4-embed3d@gmail.com>
In-Reply-To: <20180213122952.8420-1-embed3d@gmail.com>
References: <20180213122952.8420-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CIR Pin of the A83T is located at PL12.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 7f4955a5fab7..f7f78a27e21d 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -716,6 +716,11 @@
 			interrupt-controller;
 			#interrupt-cells = <3>;
 
+			r_cir_pin: r-cir-pin {
+				pins = "PL12";
+				function = "s_cir_rx";
+			};
+
 			r_rsb_pins: r-rsb-pins {
 				pins = "PL0", "PL1";
 				function = "s_rsb";
-- 
2.11.0
