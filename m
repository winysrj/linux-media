Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:35893 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaCFQCQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Mar 2014 11:02:16 -0500
From: Denis Carikli <denis@eukrea.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v9][ 3/8] staging: imx-drm: Correct BGR666 and the board's dts that use them.
Date: Thu,  6 Mar 2014 17:01:42 +0100
Message-Id: <1394121702-13257-3-git-send-email-denis@eukrea.com>
In-Reply-To: <1394121702-13257-1-git-send-email-denis@eukrea.com>
References: <1394121702-13257-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current BGR666 is not consistent with the other color mapings like BGR24.
BGR666 should be in the same byte order than BGR24.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v8->v9:
- Removed the Cc. They are now set in git-send-email directly.

ChangeLog v7->v8:
- Shrinked even more the Cc list.

ChangeLog v6->v7:
- Shrinked even more the Cc list.

ChangeLog v5->v6:
- Remove people not concerned by this patch from the Cc list.
- Added a better explanation of the change.

ChangeLog v5:
- New patch.
---
 arch/arm/boot/dts/imx51-apf51dev.dts    |    2 +-
 arch/arm/boot/dts/imx53-m53evk.dts      |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-apf51dev.dts b/arch/arm/boot/dts/imx51-apf51dev.dts
index c29cfa9..bff3201 100644
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
index d939ba8..4250e74 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -24,7 +24,7 @@
 		display1: display@di1 {
 			compatible = "fsl,imx-parallel-display";
 			crtcs = <&ipu 1>;
-			interface-pix-fmt = "bgr666";
+			interface-pix-fmt = "rgb666";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_ipu_disp1>;
 
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index 6f9abe8..154d293 100644
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

