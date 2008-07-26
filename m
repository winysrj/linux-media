Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6Q2lVrb031262
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:47:31 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6Q2lI1U031206
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:47:19 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6Q2krHx020073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:47:03 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id m6Q2kr3l024976
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:53 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6Q2krG29374
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:53 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6Q2kqIH009999
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:52 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6Q2kqx4009996
	for video4linux-list@redhat.com; Fri, 25 Jul 2008 21:46:52 -0500
Date: Fri, 25 Jul 2008 21:46:52 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080726024652.GA9991@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 4/4] sensor/lens driver for OMAP3 camera
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

From: Mohit Jalori <mjalori@ti.com>

Lens driver support for OMAP3 camera and DW9710 lens 

Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 board-3430sdp.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+)

diff -purN c/arch/arm/mach-omap2/board-3430sdp.c d/arch/arm/mach-omap2/board-3430sdp.c
--- c/arch/arm/mach-omap2/board-3430sdp.c	2008-07-24 17:38:30.000000000 -0500
+++ d/arch/arm/mach-omap2/board-3430sdp.c	2008-07-24 17:53:23.000000000 -0500
@@ -50,6 +50,10 @@
 #endif
 #endif
 
+#ifdef CONFIG_VIDEO_DW9710
+#include <../drivers/media/video/dw9710.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/delay.h>
 
@@ -212,6 +216,30 @@ static struct spi_board_info sdp3430_spi
 	},
 };
 
+#ifdef CONFIG_VIDEO_DW9710
+static int dw9710_lens_power_set(enum v4l2_power power)
+{
+
+	return 0;
+}
+
+static int dw9710_lens_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->dev_index = 0;
+	hwc->dev_minor = 0;
+	hwc->dev_type = OMAP34XXCAM_SLAVE_LENS;
+
+	return 0;
+}
+
+static struct dw9710_platform_data sdp3430_dw9710_platform_data = {
+	.power_set      = dw9710_lens_power_set,
+	.priv_data_set  = dw9710_lens_set_prv_data,
+};
+#endif
+
 #if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
 static void __iomem *fpga_map_addr;
 
@@ -382,7 +410,14 @@ static struct mt9p012_platform_data sdp3
 	.ifparm         = mt9p012_ifparm,
 };
 
+
 static struct i2c_board_info __initdata sdp3430_i2c_board_info[] = {
+#ifdef CONFIG_VIDEO_DW9710
+	{
+		I2C_BOARD_INFO(DW9710_NAME,  DW9710_AF_I2C_ADDR),
+		.platform_data = &sdp3430_dw9710_platform_data,
+	},
+#endif
 	{
 		I2C_BOARD_INFO("mt9p012", MT9P012_I2C_ADDR),
 		.platform_data = &sdp3430_mt9p012_platform_data,
@@ -391,6 +426,7 @@ static struct i2c_board_info __initdata 
 
 #endif
 
+
 static struct platform_device sdp3430_lcd_device = {
 	.name		= "sdp2430_lcd",
 	.id		= -1,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
