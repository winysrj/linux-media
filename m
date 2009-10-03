Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37958 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755218AbZJCLVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 07:21:19 -0400
Date: Sat, 3 Oct 2009 13:21:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 1/2] SH: add support for the RJ54N1CB0C camera for the kfr2r09
 platform
In-Reply-To: <Pine.LNX.4.64.0910031319320.5857@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910031320170.5857@axis700.grange>
References: <Pine.LNX.4.64.0910031319320.5857@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/sh/boards/mach-kfr2r09/setup.c |  139 +++++++++++++++++++++++++++++++++++
 1 files changed, 139 insertions(+), 0 deletions(-)

diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index c08d33f..ce01d6a 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -18,6 +18,8 @@
 #include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/usb/r8a66597.h>
+#include <media/soc_camera.h>
+#include <media/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/clock.h>
 #include <asm/machvec.h>
@@ -212,11 +214,131 @@ static struct platform_device kfr2r09_usb0_gadget_device = {
 	.resource	= kfr2r09_usb0_gadget_resources,
 };
 
+static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
+	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
+};
+
+static struct resource kfr2r09_ceu_resources[] = {
+	[0] = {
+		.name	= "CEU",
+		.start	= 0xfe910000,
+		.end	= 0xfe91009f,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = 52,
+		.end  = 52,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[2] = {
+		/* place holder for contiguous memory */
+	},
+};
+
+static struct platform_device kfr2r09_ceu_device = {
+	.name		= "sh_mobile_ceu",
+	.id             = 0, /* "ceu0" clock */
+	.num_resources	= ARRAY_SIZE(kfr2r09_ceu_resources),
+	.resource	= kfr2r09_ceu_resources,
+	.dev	= {
+		.platform_data	= &sh_mobile_ceu_info,
+	},
+	.archdata = {
+		.hwblk_id = HWBLK_CEU0,
+	},
+};
+
+static struct i2c_board_info kfr2r09_i2c_camera = {
+	I2C_BOARD_INFO("rj54n1cb0c", 0x50),
+};
+
+static struct clk *camera_clk;
+
+#define DRVCRB 0xA405018C
+static int camera_power(struct device *dev, int mode)
+{
+	int ret;
+
+	if (mode) {
+		long rate;
+
+		camera_clk = clk_get(NULL, "video_clk");
+		if (IS_ERR(camera_clk))
+			return PTR_ERR(camera_clk);
+
+		/* set VIO_CKO clock to 25MHz */
+		rate = clk_round_rate(camera_clk, 25000000);
+		ret = clk_set_rate(camera_clk, rate);
+		if (ret < 0)
+			goto eclkrate;
+
+		/* set DRVCRB
+		 *
+		 * use 1.8 V for VccQ_VIO
+		 * use 2.85V for VccQ_SR
+		 */
+		ctrl_outw((ctrl_inw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
+
+		/* reset clear */
+		ret = gpio_request(GPIO_PTB4, NULL);
+		if (ret < 0)
+			goto eptb4;
+		ret = gpio_request(GPIO_PTB7, NULL);
+		if (ret < 0)
+			goto eptb7;
+
+		ret = gpio_direction_output(GPIO_PTB4, 1);
+		if (!ret)
+			ret = gpio_direction_output(GPIO_PTB7, 1);
+		if (ret < 0)
+			goto egpioout;
+		msleep(1);
+
+		ret = clk_enable(camera_clk);	/* start VIO_CKO */
+		if (ret < 0)
+			goto eclkon;
+
+		return 0;
+	}
+
+	ret = 0;
+
+	clk_disable(camera_clk);
+eclkon:
+	gpio_set_value(GPIO_PTB7, 0);
+egpioout:
+	gpio_set_value(GPIO_PTB4, 0);
+	gpio_free(GPIO_PTB7);
+eptb7:
+	gpio_free(GPIO_PTB4);
+eptb4:
+eclkrate:
+	clk_put(camera_clk);
+	return ret;
+}
+
+static struct soc_camera_link rj54n1_link = {
+	.power		= camera_power,
+	.board_info	= &kfr2r09_i2c_camera,
+	.i2c_adapter_id	= 1,
+	.module_name	= "rj54n1cb0c",
+};
+
+static struct platform_device kfr2r09_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &rj54n1_link,
+	},
+};
+
 static struct platform_device *kfr2r09_devices[] __initdata = {
 	&kfr2r09_nor_flash_device,
 	&kfr2r09_nand_flash_device,
 	&kfr2r09_sh_keysc_device,
 	&kfr2r09_sh_lcdc_device,
+	&kfr2r09_ceu_device,
+	&kfr2r09_camera,
 };
 
 #define BSC_CS0BCR 0xfec10004
@@ -361,6 +483,23 @@ static int __init kfr2r09_devices_setup(void)
 	if (kfr2r09_usb0_gadget_setup() == 0)
 		platform_device_register(&kfr2r09_usb0_gadget_device);
 
+	/* CEU */
+	gpio_request(GPIO_FN_VIO_CKO, NULL);
+	gpio_request(GPIO_FN_VIO0_CLK, NULL);
+	gpio_request(GPIO_FN_VIO0_VD, NULL);
+	gpio_request(GPIO_FN_VIO0_HD, NULL);
+	gpio_request(GPIO_FN_VIO0_FLD, NULL);
+	gpio_request(GPIO_FN_VIO0_D7, NULL);
+	gpio_request(GPIO_FN_VIO0_D6, NULL);
+	gpio_request(GPIO_FN_VIO0_D5, NULL);
+	gpio_request(GPIO_FN_VIO0_D4, NULL);
+	gpio_request(GPIO_FN_VIO0_D3, NULL);
+	gpio_request(GPIO_FN_VIO0_D2, NULL);
+	gpio_request(GPIO_FN_VIO0_D1, NULL);
+	gpio_request(GPIO_FN_VIO0_D0, NULL);
+
+	platform_resource_setup_memory(&kfr2r09_ceu_device, "ceu", 4 << 20);
+
 	return platform_add_devices(kfr2r09_devices,
 				    ARRAY_SIZE(kfr2r09_devices));
 }
-- 
1.6.2.4

