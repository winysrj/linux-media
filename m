Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35061 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcEGPWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 11:22:30 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH 7/7] ARM: dts: n900: enable lirc-rx51 driver
Date: Sat,  7 May 2016 18:21:48 +0300
Message-Id: <1462634508-24961-8-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the needed DT data to enable IR TX driver

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 arch/arm/boot/dts/omap3-n900.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index b3c26a9..3d1e23e 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -143,6 +143,18 @@
 		io-channels = <&twl_madc 0>, <&twl_madc 4>, <&twl_madc 12>;
 		io-channel-names = "temp", "bsi", "vbat";
 	};
+
+	pwm9: dmtimer-pwm@9 {
+		compatible = "ti,omap-dmtimer-pwm";
+		#pwm-cells = <3>;
+		ti,timers = <&timer9>;
+		ti,clock-source = <0x00>; /* timer_sys_ck */
+	};
+
+	ir: lirc-rx51 {
+		compatible = "nokia,lirc-rx51";
+		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
+	};
 };
 
 &omap3_pmx_core {
-- 
1.9.1

