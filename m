Return-path: <linux-media-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:38195 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584AbaGOKMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 06:12:17 -0400
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>,
	Tero Kristo <t-kristo@ti.com>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Subject: [PATCH] ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock
Date: Tue, 15 Jul 2014 12:02:35 +0200
Message-Id: <1405418556-7030-1-git-send-email-stefan@herbrechtsmeier.net>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set 'ti,set-rate-parent' property for the dpll4_m5x2_ck clock, which
is used for the ISP functional clock. This fixes the OMAP3 ISP driver's
clock rate configuration on OMAP34xx, which needs the rate to be
propagated properly to the divider node (dpll4_m5_ck).

Signed-off-by: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: <linux-media@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>
---
 arch/arm/boot/dts/omap3xxx-clocks.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap3xxx-clocks.dtsi b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
index e47ff69..5c37500 100644
--- a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
@@ -467,6 +467,7 @@
 		ti,bit-shift = <0x1e>;
 		reg = <0x0d00>;
 		ti,set-bit-to-disable;
+		ti,set-rate-parent;
 	};
 
 	dpll4_m6_ck: dpll4_m6_ck {
-- 
2.0.1

