Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB382wNJ011307
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 03:02:58 -0500
Received: from cathcart.site5.com (89.6b.364a.static.theplanet.com
	[74.54.107.137])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB382i05032146
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 03:02:44 -0500
Message-ID: <49363D20.60301@compulab.co.il>
Date: Wed, 03 Dec 2008 10:02:40 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
	<Pine.LNX.4.64.0811252225200.10677@axis700.grange>
	<492D1A2D.8070701@compulab.co.il> <493242F1.8000605@compulab.co.il>
	<Pine.LNX.4.64.0812010927530.3915@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0812010927530.3915@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH 2/2] mt9m111: add support for mt9m112 since sensors seem
	identical
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Update mt9m11 driver and Kconfig

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 drivers/media/video/Kconfig   |    4 ++--
 drivers/media/video/mt9m111.c |   16 ++++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 47102c2..0848032 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -725,10 +725,10 @@ config MT9M001_PCA9536_SWITCH
 	  extender to switch between 8 and 10 bit datawidth modes

 config SOC_CAMERA_MT9M111
-	tristate "mt9m111 support"
+	tristate "mt9m111 and mt9m112 support"
 	depends on SOC_CAMERA && I2C
 	help
-	  This driver supports MT9M111 cameras from Micron
+	  This driver supports MT9M111 and MT9M112 cameras from Micron

 config SOC_CAMERA_MT9V022
 	tristate "mt9v022 support"
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index da0b2d5..9a428b7 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -1,5 +1,5 @@
 /*
- * Driver for MT9M111 CMOS Image Sensor from Micron
+ * Driver for MT9M111/MT9M112 CMOS Image Sensor from Micron
  *
  * Copyright (C) 2008, Robert Jarzmik <robert.jarzmik@free.fr>
  *
@@ -19,7 +19,7 @@
 #include <media/soc_camera.h>

 /*
- * mt9m111 i2c address is 0x5d or 0x48 (depending on SAddr pin)
+ * mt9m111 and mt9m112 i2c address is 0x5d or 0x48 (depending on SAddr pin)
  * The platform has to define i2c_board_info and call i2c_register_board_info()
  */

@@ -841,10 +841,11 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 	data = reg_read(CHIP_VERSION);

 	switch (data) {
-	case 0x143a:
+	case 0x143a: /* MT9M111 */
 		mt9m111->model = V4L2_IDENT_MT9M111;
-		icd->formats = mt9m111_colour_formats;
-		icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
+		break;
+	case 0x148c: /* MT9M112 */
+		mt9m111->model = V4L2_IDENT_MT9M112;
 		break;
 	default:
 		ret = -ENODEV;
@@ -853,6 +854,9 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 		goto ei2c;
 	}

+	icd->formats = mt9m111_colour_formats;
+	icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
+
 	dev_info(&icd->dev, "Detected a MT9M111 chip ID 0x143a\n");

 	ret = soc_camera_video_start(icd);
@@ -968,6 +972,6 @@ static void __exit mt9m111_mod_exit(void)
 module_init(mt9m111_mod_init);
 module_exit(mt9m111_mod_exit);

-MODULE_DESCRIPTION("Micron MT9M111 Camera driver");
+MODULE_DESCRIPTION("Micron MT9M111/MT9M112 Camera driver");
 MODULE_AUTHOR("Robert Jarzmik");
 MODULE_LICENSE("GPL");

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
