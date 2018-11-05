Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:49582 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbeKEQt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 11:49:56 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 07/11] [media] marvell-ccic: drop unused stuff
Date: Mon,  5 Nov 2018 08:30:50 +0100
Message-Id: <20181105073054.24407-8-lkundrak@v3.sk>
In-Reply-To: <20181105073054.24407-1-lkundrak@v3.sk>
References: <20181105073054.24407-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove structure members and headers that are not actually used. Saves
us from some noise in subsequent cleanup commits.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/platform/marvell-ccic/mcam-core.c  | 1 -
 drivers/media/platform/marvell-ccic/mcam-core.h  | 3 ---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 3 ---
 include/linux/platform_data/media/mmp-camera.h   | 1 -
 4 files changed, 8 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
index 1b879035948c..0113b8d37d03 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1776,7 +1776,6 @@ int mccic_register(struct mcam_camera *cam)
 	 */
 	sensor_cfg.clock_speed =3D cam->clock_speed;
 	sensor_cfg.use_smbus =3D cam->use_smbus;
-	cam->sensor_addr =3D ov7670_info.addr;
 	cam->sensor =3D v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
 			cam->i2c_adapter, &ov7670_info, NULL);
 	if (cam->sensor =3D=3D NULL) {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/me=
dia/platform/marvell-ccic/mcam-core.h
index f93f23faf364..b828b1bb59d3 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -112,11 +112,9 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
=20
-	int mclk_min;	/* The minimal value of mclk */
 	int mclk_src;	/* which clock source the mclk derives from */
 	int mclk_div;	/* Clock Divider Value for MCLK */
=20
-	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
 	/* The dphy config value, allocated in board file
@@ -153,7 +151,6 @@ struct mcam_camera {
 	 */
 	struct video_device vdev;
 	struct v4l2_subdev *sensor;
-	unsigned short sensor_addr;
=20
 	/* Videobuf2 stuff */
 	struct vb2_queue vb_queue;
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
index 92a79ad8a12c..9e988e527b0d 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/platform_data/i2c-gpio.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -333,8 +332,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->calc_dphy =3D mmpcam_calc_dphy;
 	mcam->dev =3D &pdev->dev;
 	mcam->use_smbus =3D 0;
-	mcam->ccic_id =3D pdev->id;
-	mcam->mclk_min =3D pdata->mclk_min;
 	mcam->mclk_src =3D pdata->mclk_src;
 	mcam->mclk_div =3D pdata->mclk_div;
 	mcam->bus_type =3D pdata->bus_type;
diff --git a/include/linux/platform_data/media/mmp-camera.h b/include/lin=
ux/platform_data/media/mmp-camera.h
index d2d3a443eedf..4c3a80a45883 100644
--- a/include/linux/platform_data/media/mmp-camera.h
+++ b/include/linux/platform_data/media/mmp-camera.h
@@ -16,7 +16,6 @@ struct mmp_camera_platform_data {
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
 	enum v4l2_mbus_type bus_type;
-	int mclk_min;	/* The minimal value of MCLK */
 	int mclk_src;	/* which clock source the MCLK derives from */
 	int mclk_div;	/* Clock Divider Value for MCLK */
 	/*
--=20
2.19.1
