Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47731 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:37 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 68E892CB9F
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:34 +0200 (CEST)
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v14 05/10] ARM: dts: imx5*, imx6*: correct display-timings nodes.
Date: Mon, 16 Jun 2014 12:11:19 +0200
Message-Id: <1402913484-25910-5-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imx-drm driver can't use the de-active and
pixelclk-active display-timings properties yet.

Instead the data-enable and the pixel data clock
polarity are hardcoded in the imx-drm driver.

So theses properties are now set to keep
the same behaviour when imx-drm will start
using them.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v13->v14:
- None
ChangeLog v10->v11:
- imx53-tx53-x03x.dts change was removed because it 
  already had the correct setting.
ChangeLog v9->v10:
- New patch that was splitted out of:
  "staging imx-drm: Use de-active and pixelclk-active
  display-timings."
---
 arch/arm/boot/dts/imx51-babbage.dts       |    2 ++
 arch/arm/boot/dts/imx53-m53evk.dts        |    2 ++
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi     |    2 ++
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi     |    2 ++
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi |    2 ++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi  |    2 ++
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi  |    2 ++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi    |    2 ++
 8 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/imx51-babbage.dts b/arch/arm/boot/dts/imx51-babbage.dts
index ee51a10..b64a9e3 100644
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -56,6 +56,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index 4b036b4..d03ced7 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -41,6 +41,8 @@
 					vfront-porch = <9>;
 					vsync-len = <3>;
 					vsync-active = <1>;
+					de-active = <1>;
+					pixelclk-active = <0>;
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/imx6qdl-gw53xx.dtsi b/arch/arm/boot/dts/imx6qdl-gw53xx.dtsi
index d3125f0..7f993d6 100644
--- a/arch/arm/boot/dts/imx6qdl-gw53xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw53xx.dtsi
@@ -512,6 +512,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
index 532347f..e06cf9e 100644
--- a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
@@ -534,6 +534,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 4c4b175..bcf5178 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -353,6 +353,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 009abd6..230bbc6 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -405,6 +405,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index 6df6127..9f6b406 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -353,6 +353,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index e446192..3297779 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -494,6 +494,8 @@
 				vfront-porch = <7>;
 				hsync-len = <60>;
 				vsync-len = <10>;
+				de-active = <1>;
+				pixelclk-active = <0>;
 			};
 		};
 	};
-- 
1.7.9.5

