Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:57468 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbeKLK0o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 05:26:44 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v2 09/11] [media] marvell-ccic/mmp: add devicetree support
Date: Mon, 12 Nov 2018 01:35:18 +0100
Message-Id: <20181112003520.577592-10-lkundrak@v3.sk>
In-Reply-To: <20181112003520.577592-1-lkundrak@v3.sk>
References: <20181112003520.577592-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The platform data is actually not used anywhere (along with the CSI
support) and should be safe to remove.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Pavel Machek <pavel@ucw.cz>

---
Changes since v1:
- s/This are/These are/ in a comment

 .../media/platform/marvell-ccic/mmp-driver.c  | 36 ++++++++++++++-----
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
index 05cba74c0d13..0f65dbd1de66 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -19,6 +19,8 @@
 #include <media/v4l2-device.h>
 #include <linux/platform_data/media/mmp-camera.h>
 #include <linux/device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
@@ -196,6 +198,9 @@ static void mmpcam_calc_dphy(struct mcam_camera *mcam=
)
 	struct device *dev =3D &cam->pdev->dev;
 	unsigned long tx_clk_esc;
=20
+	if (!pdata)
+		return;
+
 	/*
 	 * If CSI2_DPHY3 is calculated dynamically,
 	 * pdata->lane_clk should be already set
@@ -314,10 +319,6 @@ static int mmpcam_probe(struct platform_device *pdev=
)
 	struct mmp_camera_platform_data *pdata;
 	int ret;
=20
-	pdata =3D pdev->dev.platform_data;
-	if (!pdata)
-		return -ENODEV;
-
 	cam =3D devm_kzalloc(&pdev->dev, sizeof(*cam), GFP_KERNEL);
 	if (cam =3D=3D NULL)
 		return -ENOMEM;
@@ -330,17 +331,29 @@ static int mmpcam_probe(struct platform_device *pde=
v)
 	mcam->calc_dphy =3D mmpcam_calc_dphy;
 	mcam->dev =3D &pdev->dev;
 	mcam->use_smbus =3D 0;
-	mcam->mclk_src =3D pdata->mclk_src;
-	mcam->mclk_div =3D pdata->mclk_div;
-	mcam->bus_type =3D pdata->bus_type;
-	mcam->dphy =3D pdata->dphy;
+	pdata =3D pdev->dev.platform_data;
+	if (pdata) {
+		mcam->mclk_src =3D pdata->mclk_src;
+		mcam->mclk_div =3D pdata->mclk_div;
+		mcam->bus_type =3D pdata->bus_type;
+		mcam->dphy =3D pdata->dphy;
+		mcam->lane =3D pdata->lane;
+	} else {
+		/*
+		 * These are values that used to be hardcoded in mcam-core and
+		 * work well on a OLPC XO 1.75 with a parallel bus sensor.
+		 * If it turns out other setups make sense, the values should
+		 * be obtained from the device tree.
+		 */
+		mcam->mclk_src =3D 3;
+		mcam->mclk_div =3D 2;
+	}
 	if (mcam->bus_type =3D=3D V4L2_MBUS_CSI2_DPHY) {
 		cam->mipi_clk =3D devm_clk_get(mcam->dev, "mipi");
 		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] =3D=3D 0))
 			return PTR_ERR(cam->mipi_clk);
 	}
 	mcam->mipi_enabled =3D false;
-	mcam->lane =3D pdata->lane;
 	mcam->chip_id =3D MCAM_ARMADA610;
 	mcam->buffer_mode =3D B_DMA_sg;
 	strscpy(mcam->bus_info, "platform:mmp-camera", sizeof(mcam->bus_info));
@@ -475,6 +488,10 @@ static int mmpcam_resume(struct platform_device *pde=
v)
=20
 #endif
=20
+static const struct of_device_id mmpcam_of_match[] =3D {
+	{ .compatible =3D "marvell,mmp2-ccic", },
+	{},
+};
=20
 static struct platform_driver mmpcam_driver =3D {
 	.probe		=3D mmpcam_probe,
@@ -485,6 +502,7 @@ static struct platform_driver mmpcam_driver =3D {
 #endif
 	.driver =3D {
 		.name	=3D "mmp-camera",
+		.of_match_table =3D of_match_ptr(mmpcam_of_match),
 	}
 };
=20
--=20
2.19.1
