Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33463 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:05 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 77A2DD1AAE9
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:01 +0200 (CEST)
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
Subject: =?UTF-8?q?=5BPATCH=20v14=2003/10=5D=20imx-drm=3A=20Correct=20BGR666=20and=20the=20board=27s=20dts=20that=20use=20them=2E?=
Date: Mon, 16 Jun 2014 12:11:17 +0200
Message-Id: <1402913484-25910-3-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current BGR666 is not consistent with the other color mapings like BGR24.
BGR666 should be in the same byte order than BGR24.

Signed-off-by: Denis Carikli <denis@eukrea.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
ChangeLog v13->v14:
- Rebased
ChangeLog v10->v13:
- Rebased
ChangeLog v9->v10:
- Rebased.
- Added Philipp Zabel's Ack.
- Included Lothar Waßmann's suggestion about imx-ldb.c.
- Shortened the patch title

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
 arch/arm/boot/dts/imx51-apf51dev.dts |    2 +-
 arch/arm/boot/dts/imx53-m53evk.dts   |    2 +-
 drivers/gpu/ipu-v3/ipu-dc.c          |    4 ++--
 drivers/staging/imx-drm/imx-ldb.c    |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-apf51dev.dts b/arch/arm/boot/dts/imx51-apf51dev.dts
index c5a9a24..7b3851d 100644
--- a/arch/arm/boot/dts/imx51-apf51dev.dts
+++ b/arch/arm/boot/dts/imx51-apf51dev.dts
@@ -18,7 +18,7 @@
 
 	display@di1 {
 		compatible = "fsl,imx-parallel-display";
-		interface-pix-fmt = "bgr666";
+		interface-pix-fmt = "rgb666";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_ipu_disp1>;
 
diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index d5d146a..4b036b4 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -24,7 +24,7 @@
 	soc {
 		display1: display@di1 {
 			compatible = "fsl,imx-parallel-display";
-			interface-pix-fmt = "bgr666";
+			interface-pix-fmt = "rgb666";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_ipu_disp1>;
 
diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 100d410..9974d41 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -439,9 +439,9 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 
 	/* bgr666 */
 	ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
-	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 5, 0xfc); /* blue */
+	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 17, 0xfc); /* blue */
 	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* green */
-	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */
+	ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 5, 0xfc); /* red */
 
 	/* lvds666 */
 	ipu_dc_map_clear(priv, IPU_DC_MAP_LVDS666);
diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index 7e3f019..5d22e40 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -188,11 +188,11 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 	switch (imx_ldb_ch->chno) {
 	case 0:
 		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH0_24) ?
-			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_BGR666;
+			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_RGB666;
 		break;
 	case 1:
 		pixel_fmt = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH1_24) ?
-			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_BGR666;
+			V4L2_PIX_FMT_RGB24 : V4L2_PIX_FMT_RGB666;
 		break;
 	default:
 		dev_err(ldb->dev, "unable to config di%d panel format\n",
-- 
1.7.9.5

