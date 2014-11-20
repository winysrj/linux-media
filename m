Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbaKTP4R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 10:56:17 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 9/9] ARM: dts: sun6i: Enable ir receiver on the Mele M9
Date: Thu, 20 Nov 2014 16:55:28 +0100
Message-Id: <1416498928-1300-10-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Mele M9 has an ir receiver, enable it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31-m9.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31-m9.dts b/arch/arm/boot/dts/sun6i-a31-m9.dts
index 4202c64..94ddf9c 100644
--- a/arch/arm/boot/dts/sun6i-a31-m9.dts
+++ b/arch/arm/boot/dts/sun6i-a31-m9.dts
@@ -83,6 +83,12 @@
 				reg = <1>;
 			};
 		};
+
+		ir@01f02000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir_pins_a>;
+			status = "okay";
+		};
 	};
 
 	leds {
-- 
2.1.0

