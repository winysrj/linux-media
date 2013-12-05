Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:41273 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab3LES3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 13:29:45 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 3A35A2CC55
	for <linux-media@vger.kernel.org>; Thu,  5 Dec 2013 19:29:42 +0100 (CET)
From: Denis Carikli <denis@eukrea.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marek Vasut <marex@denx.de>, devel@driverdev.osuosl.org,
	Denis Carikli <denis@eukrea.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCHv5][ 3/8] staging: imx-drm: Correct BGR666 and the board's dts that use them.
Date: Thu,  5 Dec 2013 19:28:07 +0100
Message-Id: <1386268092-21719-3-git-send-email-denis@eukrea.com>
In-Reply-To: <1386268092-21719-1-git-send-email-denis@eukrea.com>
References: <1386268092-21719-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: devicetree@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Eric Bénard <eric@eukrea.com>
Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v5:
- New patch.
---
 arch/arm/boot/dts/imx51-apf51dev.dts    |    2 +-
 arch/arm/boot/dts/imx53-m53evk.dts      |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-apf51dev.dts b/arch/arm/boot/dts/imx51-apf51dev.dts
index f36a3aa..3b6de6a 100644
--- a/arch/arm/boot/dts/imx51-apf51dev.dts
+++ b/arch/arm/boot/dts/imx51-apf51dev.dts
@@ -19,7 +19,7 @@
 	display@di1 {
 		compatible = "fsl,imx-parallel-display";
 		crtcs = <&ipu 0>;
-		interface-pix-fmt = "bgr666";
+		interface-pix-fmt = "rgb666";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_ipu_disp1>;
 
diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index c623774..b98c897 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -24,7 +24,7 @@
 		display@di1 {
 			compatible = "fsl,imx-parallel-display";
 			crtcs = <&ipu 1>;
-			interface-pix-fmt = "bgr666";
+			interface-pix-fmt = "rgb666";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_ipu_disp1>;
 
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index 617e65b..b11a2aa 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -397,9 +397,9 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 
 	/* bgr666 */
 	ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
-	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 5, 0xfc); /* blue */
+	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 17, 0xfc); /* blue */
 	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* green */
-	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */
+	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 5, 0xfc); /* red */
 
 	/* bgr24 */
 	ipu_dc_map_clear(priv, IPU_DC_MAP_BGR24);
-- 
1.7.9.5

