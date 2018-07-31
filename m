Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36341 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbeGaLC2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 07:02:28 -0400
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v6 3/4] ARM: dts: sun8i: a83t: bananapi-m3: Enable IR controller
Date: Tue, 31 Jul 2018 11:22:57 +0200
Message-Id: <20180731092258.2279-4-embed3d@gmail.com>
In-Reply-To: <20180731092258.2279-1-embed3d@gmail.com>
References: <20180731092258.2279-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Bananapi M3 has an onboard IR receiver.
This enables the onboard IR receiver subnode.
Unlike the other IR receivers this one needs a base clock frequency
of 3000000 Hz (3 MHz), to be able to work.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
index 3b579d7567c8..ea23ff821166 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -183,6 +183,11 @@
 	status = "okay";
 };
 
+&r_cir {
+	clock-frequency = <3000000>;
+	status = "okay";
+};
+
 &r_rsb {
 	status = "okay";
 
-- 
2.11.0
