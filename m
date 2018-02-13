Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43028 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935011AbeBMMaF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 07:30:05 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RESEND PATCH v5 5/6] arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
Date: Tue, 13 Feb 2018 13:29:51 +0100
Message-Id: <20180213122952.8420-6-embed3d@gmail.com>
In-Reply-To: <20180213122952.8420-1-embed3d@gmail.com>
References: <20180213122952.8420-1-embed3d@gmail.com>
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
index 6550bf0e594b..26c015fd4f4d 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -145,6 +145,11 @@
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
