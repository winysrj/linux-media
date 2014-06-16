Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33522 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:31 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 9CFE9D1AAE9
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:27 +0200 (CEST)
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
Subject: [PATCH v14 10/10] ARM: dts: mbimx51sd: Add CMO-QVGA backlight support.
Date: Mon, 16 Jun 2014 12:11:24 +0200
Message-Id: <1402913484-25910-10-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v13->v14:
- None

ChangeLog v11->v13:
- No changes
ChangeLog v9->v11:
- Now uses the drm-panel instead of the display-timings.

ChangeLog v8->v9:
- Removed the Cc. They are now set in git-send-email directly.
- The backlight is now on at boot.

ChangeLog v6->v7:
- Shrinked even more the Cc list.

ChangeLog v5->v6:
- Reordered the Cc list.

ChangeLog v3->v5:
- Updated to the new GPIO defines.

ChangeLog v2->v3:
- Splitted out from the patch that added support for the cpuimx51/mbimxsd51 boards.
- This patch now only adds backlight support.
- Added some interested people in the Cc list, and removed some people that
  might be annoyed by the receiving of that patch which is unrelated to their
  subsystem.
---
 .../imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts  |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
index d273d09..6e36dae 100644
--- a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
+++ b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
@@ -17,9 +17,19 @@
 	model = "Eukrea MBIMXSD51 with the CMO-QVGA Display";
 	compatible = "eukrea,mbimxsd51-baseboard-cmo-qvga", "eukrea,mbimxsd51-baseboard", "eukrea,cpuimx51", "fsl,imx51";
 
+	backlight: backlight {
+		compatible = "gpio-backlight";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_backlight_1>;
+		gpios = <&gpio3 4 GPIO_ACTIVE_HIGH>;
+		default-brightness-level = <1>;
+		default-on;
+	};
+
 	panel: panel {
 		compatible = "eukrea,mbimxsd51-cmo-qvga", "simple-panel";
 		power-supply = <&reg_lcd_3v3>;
+		backlight = <&backlight>;
 	};
 
 	reg_lcd_3v3: lcd-en {
-- 
1.7.9.5

