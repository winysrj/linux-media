Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FEHKbQ000307
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 09:17:20 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1FEGnuK008435
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 09:16:49 -0500
Date: Fri, 15 Feb 2008 15:17:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802151515590.16741@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH soc-camera] Fix breakage in mt9m001 and mt9v022 driver if
 "CONFIG_GENERIC_GPIO is not set"
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

Both camera drivers can function without GPIO support, in which case they
will only support the 10 bit data width mode. But the two respective switch
options: CONFIG_MT9M001_PCA9536_SWITCH and CONFIG_MT9V022_PCA9536_SWITCH do
have to depend on CONFIG_GENERIC_GPIO. Additionally remove redundant
gpio_is_valid tests - they are repeated in bus_switch_request() functions.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

 drivers/media/video/Kconfig   |    4 ++--
 drivers/media/video/mt9m001.c |    6 ++----
 drivers/media/video/mt9v022.c |    6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e710d68..2e400d7 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -855,7 +855,7 @@ config SOC_CAMERA_MT9M001
 
 config MT9M001_PCA9536_SWITCH
 	bool "pca9536 datawidth switch for mt9m001"
-	depends on SOC_CAMERA_MT9M001
+	depends on SOC_CAMERA_MT9M001 && GENERIC_GPIO
 	help
 	  Select this if your MT9M001 camera uses a PCA9536 I2C GPIO
 	  extender to switch between 8 and 10 bit datawidth modes
@@ -869,7 +869,7 @@ config SOC_CAMERA_MT9V022
 
 config MT9V022_PCA9536_SWITCH
 	bool "pca9536 datawidth switch for mt9v022"
-	depends on SOC_CAMERA_MT9V022
+	depends on SOC_CAMERA_MT9V022 && GENERIC_GPIO
 	help
 	  Select this if your MT9V022 camera uses a PCA9536 I2C GPIO
 	  extender to switch between 8 and 10 bit datawidth modes
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index b65ff77..e3afc82 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -17,7 +17,9 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
+#ifdef CONFIG_MT9M001_PCA9536_SWITCH
 #include <asm/gpio.h>
+#endif
 
 /* mt9m001 i2c address 0x5d
  * The platform has to define i2c_board_info
@@ -223,10 +225,6 @@ static int mt9m001_set_capture_format(struct soc_camera_device *icd,
 	if ((mt9m001->datawidth != 10 && (width_flag == IS_DATAWIDTH_10)) ||
 	    (mt9m001->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
 	    (mt9m001->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
-		/* data width switch requested */
-		if (!gpio_is_valid(mt9m001->switch_gpio))
-			return -EINVAL;
-
 		/* Well, we actually only can do 10 or 8 bits... */
 		if (width_flag == IS_DATAWIDTH_9)
 			return -EINVAL;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 5fbeaa3..4683339 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -18,7 +18,9 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
+#ifdef CONFIG_MT9M001_PCA9536_SWITCH
 #include <asm/gpio.h>
+#endif
 
 /* mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
  * The platform has to define i2c_board_info
@@ -302,10 +304,6 @@ static int mt9v022_set_capture_format(struct soc_camera_device *icd,
 	if ((mt9v022->datawidth != 10 && (width_flag == IS_DATAWIDTH_10)) ||
 	    (mt9v022->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
 	    (mt9v022->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
-		/* data width switch requested */
-		if (!gpio_is_valid(mt9v022->switch_gpio))
-			return -EINVAL;
-
 		/* Well, we actually only can do 10 or 8 bits... */
 		if (width_flag == IS_DATAWIDTH_9)
 			return -EINVAL;
-- 
1.5.3.4


---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
