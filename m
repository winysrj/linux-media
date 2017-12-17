Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40676 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757685AbdLQWp4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 17:45:56 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 3/5] arm: dts: sun8i: a83t: Add the ir pin for the A83T
Date: Sun, 17 Dec 2017 23:45:45 +0100
Message-Id: <20171217224547.21481-4-embed3d@gmail.com>
In-Reply-To: <20171217224547.21481-1-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CIR Pin of the A83T is located at PL12.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index a384b766f3dc..954c2393325f 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -521,6 +521,11 @@
 				drive-strength = <20>;
 				bias-pull-up;
 			};
+
+			ir_pins_a: ir@0 {
+				pins = "PL12";
+				function = "s_cir_rx";
+			};
 		};
 
 		r_rsb: rsb@1f03400 {
-- 
2.11.0
