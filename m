Return-path: <mchehab@pedra>
Received: from mail01.prevas.se ([62.95.78.3]:2648 "EHLO mail01.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162166Ab1FAI7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 04:59:50 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: SV: omap3isp - H3A auto white balance
Date: Wed, 1 Jun 2011 10:49:43 +0200
Message-ID: <CA7B7D6C54015B459601D68441548157C5A403@prevas1.prevas.se>
In-Reply-To: <201105311710.25200.laurent.pinchart@ideasonboard.com>
References: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se> <201105311201.15285.laurent.pinchart@ideasonboard.com> <CA7B7D6C54015B459601D68441548157C5A402@prevas1.prevas.se> <201105311710.25200.laurent.pinchart@ideasonboard.com>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> Hi Daniel,
> 
> On Tuesday 31 May 2011 12:07:08 Daniel Lundborg wrote:
> 
> [snip]
> 
> > > Any chance you will submit the driver for inclusion in the kernel
?
> > 
> > Yes if there is an interest in it. I can create a patch from your 
> > omap3isp-next-sensors tree if you want.
> 
> That would be nice, thank you.
> 
> --
> Regards,
> 
> Laurent Pinchart

Here's the patch:

--------------------------------------------------------

diff -urNp a/arch/arm/mach-omap2/board-overo.c
b/arch/arm/mach-omap2/board-overo.c
--- a/arch/arm/mach-omap2/board-overo.c	2011-06-01 10:45:32.000000000
+0200
+++ b/arch/arm/mach-omap2/board-overo.c	2011-06-01 10:09:40.000000000
+0200
@@ -28,6 +28,9 @@
 #include <linux/platform_device.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/spi/spi.h>
+#include <linux/interrupt.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -41,10 +44,14 @@
 
 #include <plat/board.h>
 #include <plat/common.h>
+#include <plat/display.h>
+#include <plat/panel-generic-dpi.h>
 #include <mach/gpio.h>
 #include <plat/gpmc.h>
 #include <mach/hardware.h>
 #include <plat/nand.h>
+#include <plat/mcspi.h>
+#include <plat/mux.h>
 #include <plat/usb.h>
 
 #include "mux.h"
@@ -53,17 +60,18 @@
 
 #define OVERO_GPIO_BT_XGATE	15
 #define OVERO_GPIO_W2W_NRESET	16
-#define OVERO_GPIO_PENDOWN	114
-#define OVERO_GPIO_BT_NRESET	164
-#define OVERO_GPIO_USBH_CPEN	168
-#define OVERO_GPIO_USBH_NRESET	183
+#define OVERO_GPIO_PENDOWN 114
+#define OVERO_GPIO_BT_NRESET 164
+#define OVERO_GPIO_USBH_CPEN 168
+#define OVERO_GPIO_USBH_NRESET 183
 
 #define NAND_BLOCK_SIZE SZ_128K
 
-#define OVERO_SMSC911X_CS      5
-#define OVERO_SMSC911X_GPIO    176
-#define OVERO_SMSC911X2_CS     4
-#define OVERO_SMSC911X2_GPIO   65
+#define OVERO_SMSC911X_CS 5
+#define OVERO_SMSC911X_GPIO 176
+#define OVERO_SMSC911X2_CS 4
+#define OVERO_SMSC911X2_GPIO 65
+#define OVERO_GPIO_CAM_RESET 109
 
 #if defined(CONFIG_TOUCHSCREEN_ADS7846) || \
 	defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
@@ -124,6 +132,7 @@ static void __init overo_ads7846_init(vo
 static inline void __init overo_ads7846_init(void) { return; }
 #endif
 
+
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
 
 #include <linux/smsc911x.h>
@@ -233,6 +242,8 @@ static inline void __init overo_init_sms
 static inline void __init overo_init_smsc911x(void) { return; }
 #endif
 
+
+
 static struct mtd_partition overo_nand_partitions[] = {
 	{
 		.name           = "xloader",
@@ -323,6 +334,93 @@ static struct regulator_consumer_supply 
 	.supply			= "vmmc",
 };
 
+#if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
+#include <linux/leds.h>
+
+static struct gpio_led gpio_leds[] = {
+	{
+		.name			= "overo:red:gpio21",
+		.default_trigger	= "heartbeat",
+		.gpio			= 21,
+		.active_low		= true,
+	},
+	{
+		.name			= "overo:blue:gpio22",
+		.default_trigger	= "none",
+		.gpio			= 22,
+		.active_low		= true,
+	},
+	{
+		.name			= "overo:blue:COM",
+		.default_trigger	= "mmc0",
+		.gpio			= -EINVAL,	/* gets replaced
*/
+		.active_low		= true,
+	},
+};
+
+static struct gpio_led_platform_data gpio_leds_pdata = {
+	.leds		= gpio_leds,
+	.num_leds	= ARRAY_SIZE(gpio_leds),
+};
+
+static struct platform_device gpio_leds_device = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &gpio_leds_pdata,
+	},
+};
+
+static void __init overo_init_led(void)
+{
+	platform_device_register(&gpio_leds_device);
+}
+
+#else
+static inline void __init overo_init_led(void) { return; }
+#endif
+
+#if defined(CONFIG_KEYBOARD_GPIO) ||
defined(CONFIG_KEYBOARD_GPIO_MODULE)
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+static struct gpio_keys_button gpio_buttons[] = {
+	{
+		.code			= BTN_0,
+		.gpio			= 23,
+		.desc			= "button0",
+		.wakeup			= 1,
+	},
+	{
+		.code			= BTN_1,
+		.gpio			= 14,
+		.desc			= "button1",
+		.wakeup			= 1,
+	},
+};
+
+static struct gpio_keys_platform_data gpio_keys_pdata = {
+	.buttons	= gpio_buttons,
+	.nbuttons	= ARRAY_SIZE(gpio_buttons),
+};
+
+static struct platform_device gpio_keys_device = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &gpio_keys_pdata,
+	},
+};
+
+static void __init overo_init_keys(void)
+{
+	platform_device_register(&gpio_keys_device);
+}
+
+#else
+static inline void __init overo_init_keys(void) { return; }
+#endif
+
 static int overo_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -330,6 +428,9 @@ static int overo_twl_gpio_setup(struct d
 
 	overo_vmmc1_supply.dev = mmc[0].dev;
 
+	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED)
*/
+	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
+
 	return 0;
 }
 
@@ -337,6 +438,7 @@ static struct twl4030_gpio_platform_data
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.use_leds	= true,
 	.setup		= overo_twl_gpio_setup,
 };
 
@@ -393,6 +495,7 @@ static int __init overo_i2c_init(void)
 			ARRAY_SIZE(overo_i2c_boardinfo));
 	/* i2c2 pins are used for gpio */
 	omap_register_i2c_bus(3, 400, NULL, 0);
+
 	return 0;
 }
 
@@ -415,7 +518,7 @@ static void __init overo_init_irq(void)
 	omap_board_config_size = ARRAY_SIZE(overo_config);
 	omap2_init_common_infrastructure();
 	omap2_init_common_devices(mt46h32m32lf6_sdrc_params,
-				  mt46h32m32lf6_sdrc_params);
+			     mt46h32m32lf6_sdrc_params);
 	omap_init_irq();
 }
 
@@ -436,16 +539,292 @@ static const struct ehci_hcd_omap_platfo
 
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux board_mux[] __initdata = {
+  // SDR/DDR RAM chips
+  OMAP3_MUX(SDRC_CKE0, OMAP_PIN_OUTPUT | OMAP_MUX_MODE0),
+  OMAP3_MUX(SDRC_CKE1, OMAP_PIN_OUTPUT | OMAP_MUX_MODE0),
+  
+  // Camera driver
+  // Camera - Parallel Data
+  OMAP3_MUX(CAM_D0, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D3, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D4, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D5, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D6, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D7, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D8, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_D9, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_PCLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  
+  // Camera - HS/VS signals
+  OMAP3_MUX(CAM_HS, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  OMAP3_MUX(CAM_VS, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
+  
+  // Camera - XCLK
+  OMAP3_MUX(CAM_XCLKA, OMAP_MUX_MODE0 | OMAP_PIN_OUTPUT),
+
+  OMAP3_MUX(CAM_FLD, OMAP_PIN_OUTPUT | OMAP_MUX_MODE2), //
cam_global_reset
+  OMAP3_MUX(CAM_WEN, OMAP_PIN_OUTPUT | OMAP_MUX_MODE2), // cam_shutter
+  OMAP3_MUX(CAM_D10, OMAP_PIN_OUTPUT | OMAP_MUX_MODE4), // gpio_109 =
CAM_RESET
+  
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
+#else
+#define board_mux	NULL
 #endif
 
 static struct omap_musb_board_data musb_board_data = {
 	.interface_type		= MUSB_INTERFACE_ULPI,
+#if defined(CONFIG_USB_MUSB_OTG)
 	.mode			= MUSB_OTG,
+#elif defined(CONFIG_USB_GADGET_MUSB_HDRC)
+	.mode			= MUSB_PERIPHERAL,
+#else
+	.mode			= MUSB_HOST,
+#endif
 	.power			= 100,
 };
 
+static inline int do_gpio_request_out(int gpio, const char *gpio_id)
+{
+  int ret;
+  
+  omap_mux_init_gpio(gpio, OMAP_PIN_OUTPUT);
+  ret = gpio_request(gpio, gpio_id);
+  if (ret < 0)
+    return ret;
+    
+  ret = gpio_direction_output(gpio, 1);
+  if (ret < 0)
+    return ret;
+  
+  gpio_export(gpio, 0);
+  
+  return ret;
+}
+
+static inline int do_gpio_request_in(int gpio, const char *gpio_id)
+{
+  int ret;
+  
+  omap_mux_init_gpio(gpio, OMAP_PIN_INPUT);
+  ret = gpio_request(gpio, gpio_id);
+  if (ret < 0)
+    return ret;
+    
+  ret = gpio_direction_input(gpio);
+  if (ret < 0)
+    return ret;
+  
+  gpio_export(gpio, 0);
+  
+  return ret;
+}
+
+static void overo_init_gpios(void)
+{
+  if (do_gpio_request_out(OVERO_GPIO_W2W_NRESET,
"OVERO_GPIO_W2W_NRESET") < 0 ||
+      do_gpio_request_out(OVERO_GPIO_BT_XGATE, "OVERO_GPIO_BT_XGATE") <
0 ||
+      do_gpio_request_out(OVERO_GPIO_BT_NRESET, "OVERO_GPIO_BT_NRESET")
< 0 ||
+      do_gpio_request_out(OVERO_GPIO_USBH_CPEN, "OVERO_GPIO_USBH_CPEN")
< 0 ||
+      do_gpio_request_out(OVERO_GPIO_CAM_RESET, "OVERO_GPIO_CAM_RESET")
< 0)
+    return;
+
+  gpio_set_value(OVERO_GPIO_W2W_NRESET, 0);
+	udelay(10);
+	gpio_set_value(OVERO_GPIO_W2W_NRESET, 1);
+
+  gpio_set_value(OVERO_GPIO_CAM_RESET, 1); // Set cam reset to 1 (off)
+}
+
+#if defined(CONFIG_VIDEO_OMAP3) && defined(CONFIG_VIDEO_MT9V034)
+
+#include <linux/videodev2.h>
+#include <media/v4l2-subdev.h>
+#include <media/mt9v034.h>
+#include <../drivers/media/video/omap3isp/isp.h>
+#include <../drivers/media/video/omap3isp/ispreg.h>
+#include "devices.h"
+
+#define OVERO_CAMERA_XCLK ISP_XCLK_A
+
+static void print_isp_reg(struct v4l2_subdev *s, const char *name, enum
isp_mem_resources isp_mmio_range, u32 reg_offset)
+{
+  u32 value;
+	struct isp_device *isp = v4l2_dev_to_isp_device(s->v4l2_dev);
+	
+  value = isp_reg_readl(isp, isp_mmio_range, reg_offset);
+  printk(KERN_ALERT "Omap ISP register %s = 0x%x\n", name, value);
+}
+
+static inline void print_isp_regs(struct v4l2_subdev *s, const char
*str)
+{
+	printk(KERN_ALERT "%s\n", str);
+  print_isp_reg(s, "TCTRL_CTRL", OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL);
+  print_isp_reg(s, "TCTRL_SHUT_DELAY", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_SHUT_DELAY);
+  print_isp_reg(s, "TCTRL_SHUT_LENGTH", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_SHUT_LENGTH);
+  print_isp_reg(s, "TCTRL_GRESET_LENGTH", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_GRESET_LENGTH);
+  print_isp_reg(s, "TCTRL_FRAME", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_FRAME);
+  print_isp_reg(s, "TCTRL_PSTRB_DELAY", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_PSTRB_DELAY);
+  print_isp_reg(s, "TCTRL_STRB_DELAY", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_STRB_DELAY);
+  print_isp_reg(s, "TCTRL_PSTRB_LENGTH", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_PSTRB_LENGTH);
+  print_isp_reg(s, "TCTRL_STRB_LENGTH", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_STRB_LENGTH);
+  print_isp_reg(s, "TCTRL_TCTRL_GRESET_LENGTH", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_GRESET_LENGTH);
+  print_isp_reg(s, "TCTRL_PSTRB_REPLAY", OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_PSTRB_REPLAY);
+  print_isp_reg(s, "CTRL", OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
+  print_isp_reg(s, "SECURE", OMAP3_ISP_IOMEM_MAIN, ISP_SECURE);
+  print_isp_reg(s, "PID", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PID);
+  print_isp_reg(s, "SYN_MODE", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+  print_isp_reg(s, "PCR", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PCR);
+  print_isp_reg(s, "HD_VD_WID", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_HD_VD_WID);
+  print_isp_reg(s, "PIX_LINES", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_PIX_LINES);
+  print_isp_reg(s, "HORZ_INFO", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_HORZ_INFO);
+  print_isp_reg(s, "VERT_START", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_VERT_START);
+  print_isp_reg(s, "VERT_LINES", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_VERT_LINES);
+  print_isp_reg(s, "CULLING", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CULLING);
+  print_isp_reg(s, "HSIZE_OFF", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_HSIZE_OFF);
+  print_isp_reg(s, "SDOFST", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST);
+  print_isp_reg(s, "SDR_ADDR", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDR_ADDR);
+  print_isp_reg(s, "CLAMP", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CLAMP);
+  print_isp_reg(s, "DCSUB", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_DCSUB);
+  print_isp_reg(s, "COLPTN", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_COLPTN);
+  print_isp_reg(s, "BLKCMP", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_BLKCMP);
+  print_isp_reg(s, "FPC", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
+  print_isp_reg(s, "FPC_ADDR", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC_ADDR);
+  print_isp_reg(s, "VDINT", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+  print_isp_reg(s, "ALAW", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_ALAW);
+  print_isp_reg(s, "REC656IF", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF);
+  print_isp_reg(s, "CFG", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG);
+  print_isp_reg(s, "FMTCFG", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
+  print_isp_reg(s, "FMT_HORZ", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ);
+  print_isp_reg(s, "FMT_VERT", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
+  print_isp_reg(s, "FMT_ADDR0", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR0);
+  print_isp_reg(s, "FMT_ADDR1", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR1);
+  print_isp_reg(s, "FMT_ADDR2", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR2);
+  print_isp_reg(s, "FMT_ADDR3", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR3);
+  print_isp_reg(s, "FMT_ADDR4", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR4);
+  print_isp_reg(s, "FMT_ADDR5", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR5);
+  print_isp_reg(s, "FMT_ADDR6", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR6);
+  print_isp_reg(s, "FMT_ADDR7", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_FMT_ADDR7);
+  print_isp_reg(s, "PRGEVEN0", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGEVEN0);
+  print_isp_reg(s, "PRGEVEN1", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGEVEN1);
+  print_isp_reg(s, "PRGODD0", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGODD0);
+  print_isp_reg(s, "PRGODD1", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGODD1);
+  print_isp_reg(s, "VP_OUT", OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
+  print_isp_reg(s, "LSC_CONFIG", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_LSC_CONFIG);
+  print_isp_reg(s, "LSC_INITIAL", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_LSC_INITIAL);
+  print_isp_reg(s, "LSC_TABLE_BASE", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_LSC_TABLE_BASE);
+  print_isp_reg(s, "LSC_TABLE_OFFSET", OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_LSC_TABLE_OFFSET);
+}
+
+void overo_camera_configure(struct v4l2_subdev *subdev)
+{
+	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);
+  
+  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
~0x9a1b63ff, 0x98036000); // Set CAM_GLOBAL_RESET pin as output, enable
shutter, set DIVC = 216
+  isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_DELAY,
0x01ffffff);  // Set no shutter delay  
+  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_LENGTH,
0x01ffffff, 0x000003e8); // Set shutter signal length to 1000 (=> 1000 *
1/216MHz * 216 = 1 ms)
+  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_GRESET_LENGTH,
0x01ffffff, 0x000003e8); // Set CAM_GLOBAL_RESET signal length to 1000
(=> 1000 * 1/216MHz * 216 = 1 ms)
+  isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG,
0xffffffff);  // Disable LSC
+  isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG, 0xffffffff);
// Disable Preview, H3A, HIST
+}
+
+static void overo_camera_take_picture(struct v4l2_subdev *subdev, int
nr_pics, int exposure_time_ms)
+{
+	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);
+  u32 isp_value;
+  
+//print_isp_regs(subdev, "before take_pic");
+
+  for (; nr_pics >= 0; --nr_pics)  // Take a picture again?
+  {
+    isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0,
0x00e00000);  // Enable shutter (SHUTEN bit = 1)
+    isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0,
0x20000000);  // Start generation of CAM_GLOBAL_RESET signal (GRESETEN
bit = 1)
+
+    msleep(exposure_time_ms + 2);
+    
+    do
+    {
+      usleep_range(10, 20);
+      isp_value = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_PCR);
+    }
+    while ((isp_value & 0x2) != 0);  // Wait until PCR is not busy (bit
2)
+
+    usleep_range(1800, 2000);
+  }
+  
+//  print_isp_regs(subdev, "after take_pic");
+}
+
+static void overo_camera_set_clock(struct v4l2_subdev *subdev, unsigned
int rate)
+{
+	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);
+
+	isp->platform_cb.set_xclk(isp, rate, OVERO_CAMERA_XCLK);
+}
+
+static void overo_camera_reset(void)
+{
+  gpio_set_value(OVERO_GPIO_CAM_RESET, 0);
+  
+  msleep(1);
+  
+  gpio_set_value(OVERO_GPIO_CAM_RESET, 1);
+}
+
+
+static struct mt9v034_platform_data overo_mt9v034_platform_data = {
+  .clk_pol = 0,
+	.set_clock = overo_camera_set_clock,
+	.take_picture = overo_camera_take_picture,
+  .configure = overo_camera_configure,
+  .reset = overo_camera_reset,
+};
+
+static struct i2c_board_info overo_camera_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("mt9v034", 0x48),
+		.platform_data = &overo_mt9v034_platform_data,
+	},
+};
+
+static struct isp_subdev_i2c_board_info overo_camera_i2c_subdevs[] = {
+	{
+		.board_info = &overo_camera_i2c_devices[0],
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group overo_camera_subdevs[] = {
+	{
+		.subdevs = overo_camera_i2c_subdevs,
+		.interface = ISP_INTERFACE_PARALLEL,
+		.bus = {
+  		.parallel = {
+    		.data_lane_shift = 0,
+    		.clk_pol = 0,
+    		.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
+		  } 
+		},
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_platform_data overo_isp_platform_data = {
+	.subdevs = overo_camera_subdevs,
+};
+
+void __init overo_camera_init(void)
+{
+	if (omap3_init_camera(&overo_isp_platform_data) < 0)
+		printk(KERN_ALERT "%s: Unable to register camera
platform device\n", __func__);
+}
+#else
+void __init overo_camera_init(void) {}
+#endif  // CONFIG_VIDEO_OMAP3 && CONFIG_MT9V034
+
 static void __init overo_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
@@ -457,48 +836,13 @@ static void __init overo_init(void)
 	usb_ehci_init(&ehci_pdata);
 	overo_ads7846_init();
 	overo_init_smsc911x();
-
-	/* Ensure SDRC pins are mux'd for self-refresh */
-	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
-	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-
-	if ((gpio_request(OVERO_GPIO_W2W_NRESET,
-			  "OVERO_GPIO_W2W_NRESET") == 0) &&
-	    (gpio_direction_output(OVERO_GPIO_W2W_NRESET, 1) == 0)) {
-		gpio_export(OVERO_GPIO_W2W_NRESET, 0);
-		gpio_set_value(OVERO_GPIO_W2W_NRESET, 0);
-		udelay(10);
-		gpio_set_value(OVERO_GPIO_W2W_NRESET, 1);
-	} else {
-		printk(KERN_ERR "could not obtain gpio for "
-					"OVERO_GPIO_W2W_NRESET\n");
-	}
-
-	if ((gpio_request(OVERO_GPIO_BT_XGATE, "OVERO_GPIO_BT_XGATE") ==
0) &&
-	    (gpio_direction_output(OVERO_GPIO_BT_XGATE, 0) == 0))
-		gpio_export(OVERO_GPIO_BT_XGATE, 0);
-	else
-		printk(KERN_ERR "could not obtain gpio for
OVERO_GPIO_BT_XGATE\n");
-
-	if ((gpio_request(OVERO_GPIO_BT_NRESET, "OVERO_GPIO_BT_NRESET")
== 0) &&
-	    (gpio_direction_output(OVERO_GPIO_BT_NRESET, 1) == 0)) {
-		gpio_export(OVERO_GPIO_BT_NRESET, 0);
-		gpio_set_value(OVERO_GPIO_BT_NRESET, 0);
-		mdelay(6);
-		gpio_set_value(OVERO_GPIO_BT_NRESET, 1);
-	} else {
-		printk(KERN_ERR "could not obtain gpio for "
-					"OVERO_GPIO_BT_NRESET\n");
-	}
-
-	if ((gpio_request(OVERO_GPIO_USBH_CPEN, "OVERO_GPIO_USBH_CPEN")
== 0) &&
-	    (gpio_direction_output(OVERO_GPIO_USBH_CPEN, 1) == 0))
-		gpio_export(OVERO_GPIO_USBH_CPEN, 0);
-	else
-		printk(KERN_ERR "could not obtain gpio for "
-					"OVERO_GPIO_USBH_CPEN\n");
+	overo_init_led();
+	overo_init_keys();
+	overo_init_gpios();
+  	overo_camera_init();
 }
 
+
 MACHINE_START(OVERO, "Gumstix Overo")
 	.boot_params	= 0x80000100,
 	.map_io		= omap3_map_io,
diff -urNp a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig	2011-06-01 10:46:46.000000000
+0200
+++ b/drivers/media/video/Kconfig	2011-06-01 10:06:01.000000000
+0200
@@ -344,6 +344,13 @@ config VIDEO_MT9V032
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
 
+config VIDEO_MT9V034
+	tristate "Aptina MT9V034 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  MT9V032 752x480 CMOS sensor. Only for snapshot.
+
 config VIDEO_TCM825X
 	tristate "TCM825x camera sensor support"
 	depends on I2C && VIDEO_V4L2
diff -urNp a/drivers/media/video/Makefile b/drivers/media/video/Makefile
--- a/drivers/media/video/Makefile	2011-06-01 10:46:46.000000000
+0200
+++ b/drivers/media/video/Makefile	2011-06-01 10:06:45.000000000
+0200
@@ -67,6 +67,7 @@ obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
+obj-$(CONFIG_VIDEO_MT9V034) += mt9v034.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 
diff -urNp a/drivers/media/video/mt9v034.c
b/drivers/media/video/mt9v034.c
--- a/drivers/media/video/mt9v034.c	1970-01-01 01:00:00.000000000
+0100
+++ b/drivers/media/video/mt9v034.c	2011-05-30 15:04:44.000000000
+0200
@@ -0,0 +1,1114 @@
+/*
+ * Driver for MT9V034 CMOS Image Sensor from Micron
+ *
+ * Copyright (C) 2011, Daniel Lundborg <daniel.lundborg@prevas.se>
+ *
+ * Copyright (C) 2010, Laurent Pinchart
<laurent.pinchart@ideasonboard.com>
+ *
+ * Based on the MT9M001 driver,
+ *
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/log2.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+
+#include <media/mt9v034.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#define MT9V034_CHIP_VERSION                         0x00
+#define		MT9V034_CHIP_ID 0x1324
+#define MT9V034_COLUMN_START_CONTEXT_A               0x01
+#define		MT9V034_COLUMN_START_MIN		1
+#define		MT9V034_COLUMN_START_DEF		2
+#define		MT9V034_COLUMN_START_MAX		752
+#define MT9V034_ROW_START_CONTEXT_A                  0x02
+#define		MT9V034_ROW_START_MIN			4
+#define		MT9V034_ROW_START_DEF			10
+#define		MT9V034_ROW_START_MAX			482
+#define MT9V034_WIN_HEIGHT_CONTEXT_A                 0x03
+#define		MT9V034_WINDOW_HEIGHT_MIN		1
+#define		MT9V034_WINDOW_HEIGHT_DEF		480
+#define		MT9V034_WINDOW_HEIGHT_MAX		480
+#define MT9V034_WIN_WIDTH_CONTEXT_A                  0x04
+#define		MT9V034_WINDOW_WIDTH_MIN		1
+#define		MT9V034_WINDOW_WIDTH_DEF		752
+#define		MT9V034_WINDOW_WIDTH_MAX		752
+#define MT9V034_HORIZONTAL_BLANCING_CONTEXT_A        0x05
+#define		MT9V034_HORIZONTAL_BLANKING_MIN		43
+#define		MT9V034_HORIZONTAL_BLANKING_MAX		1023
+#define MT9V034_VERTICAL_BLANCING_CONTEXT_A          0x06
+#define		MT9V034_VERTICAL_BLANKING_MIN		4
+#define		MT9V034_VERTICAL_BLANKING_MAX		3000
+#define MT9V034_CHIP_CONTROL                         0x07
+#define 	MT9V034_CHIP_CONTROL_MASTER_MODE	(1 << 3)
+#define   MT9V034_CHIP_CONTROL_SNAPSHOT_MODE (3 << 3)
+#define 	MT9V034_CHIP_CONTROL_DOUT_ENABLE	(1 << 7)
+#define 	MT9V034_CHIP_CONTROL_SEQUENTIAL		(1 << 8)
+#define   MT9V034_CHIP_CONTROL_RESERVED (1 << 9)
+#define MT9V034_COARSE_SHUTTER_WIDTH1_CONTEXT_A      0x08
+#define MT9V034_COARSE_SHUTTER_WIDTH2_CONTEXT_A      0x09
+#define MT9V034_SHUTTER_WIDTH_CTRL_CONTEXT_A         0x0a
+#define MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_A 0x0b
+#define		MT9V034_TOTAL_SHUTTER_WIDTH_MIN_US	1000
+#define		MT9V034_TOTAL_SHUTTER_WIDTH_DEF_US	8000
+#define		MT9V034_TOTAL_SHUTTER_WIDTH_MAX_US	500000
+#define MT9V034_RESET                                0x0c
+#define MT9V034_READ_MODE_CONTEXT_A                  0x0d
+#define		MT9V034_READ_MODE_ROW_BIN_MASK		(3 << 0)
+#define		MT9V034_READ_MODE_ROW_BIN_SHIFT		0
+#define		MT9V034_READ_MODE_COLUMN_BIN_MASK	(3 << 2)
+#define		MT9V034_READ_MODE_COLUMN_BIN_SHIFT	2
+#define		MT9V034_READ_MODE_ROW_FLIP		(1 << 4)
+#define		MT9V034_READ_MODE_COLUMN_FLIP		(1 << 5)
+#define		MT9V034_READ_MODE_DARK_COLUMNS		(1 << 6)
+#define		MT9V034_READ_MODE_DARK_ROWS		(1 << 7)
+#define MT9V034_READ_MODE_CONTEXT_B                  0x0e
+#define MT9V034_SENSOR_TYPE_HDR_ENABLE               0x0f
+#define MT9V034_LED_OUT_CTRL                         0x1b
+#define MT9V034_COMPANDING                           0x1c
+#define MT9V034_VREF_ADC_CTRL                        0x2c
+#define MT9V034_V1_CONTROL_CONTEXT_A                 0x31
+#define MT9V034_V2_CONTROL_CONTEXT_A                 0x32
+#define MT9V034_V3_CONTROL_CONTEXT_A                 0x33
+#define MT9V034_V4_CONTROL_CONTEXT_A                 0x34
+#define MT9V034_ANALOG_GAIN_CONTEXT_A                0x35
+#define		MT9V034_ANALOG_GAIN_MIN			1
+#define		MT9V034_ANALOG_GAIN_DEF			1
+#define		MT9V034_ANALOG_GAIN_MAX			4
+#define MT9V034_ANALOG_GAIN_CONTEXT_B                0x36
+#define MT9V034_V1_CONTROL_CONTEXT_B                 0x39
+#define MT9V034_V2_CONTROL_CONTEXT_B                 0x3a
+#define MT9V034_V3_CONTROL_CONTEXT_B                 0x3b
+#define MT9V034_V4_CONTROL_CONTEXT_B                 0x3c
+#define MT9V034_FRAME_DARK_AVERAGE                   0x42
+#define MT9V034_DARK_AVERAGE_THRESHOLD               0x46
+#define MT9V034_BL_CALIB_CTRL                        0x47
+#define MT9V034_BLACK_LEVEL_CALIBRATION_VALUE        0x48
+#define MT9V034_BL_CALIB_STEP_SIZE                   0x4c
+#define MT9V034_ROW_NOISE_CORR_CONTROL               0x70
+#define MT9V034_ROW_NOISE_CONSTANT                   0x71
+#define MT9V034_PIXCLK_FV_LV_CTRL                    0x72
+#define 	MT9V034_PIXEL_CLOCK_INV_LINE		(1 << 0)
+#define 	MT9V034_PIXEL_CLOCK_INV_FRAME		(1 << 1)
+#define 	MT9V034_PIXEL_CLOCK_XOR_LINE		(1 << 2)
+#define 	MT9V034_PIXEL_CLOCK_CONT_LINE		(1 << 3)
+#define 	MT9V034_PIXEL_CLOCK_INV_PXL_CLK		(1 << 4)
+#define MT9V034_DIGITAL_TEST_PATTERN                 0x7f
+#define 	MT9V034_TEST_PATTERN_DATA_MASK		(1023 << 0)
+#define 	MT9V034_TEST_PATTERN_DATA_SHIFT		0
+#define 	MT9V034_TEST_PATTERN_USE_DATA		(1 << 10)
+#define 	MT9V034_TEST_PATTERN_GRAY_MASK		(3 << 11)
+#define 	MT9V034_TEST_PATTERN_GRAY_NONE		(0 << 11)
+#define 	MT9V034_TEST_PATTERN_GRAY_VERTICAL	(1 << 11)
+#define 	MT9V034_TEST_PATTERN_GRAY_HORIZONTAL	(2 << 11)
+#define 	MT9V034_TEST_PATTERN_GRAY_DIAGONAL	(3 << 11)
+#define 	MT9V034_TEST_PATTERN_ENABLE		(1 << 13)
+#define 	MT9V034_TEST_PATTERN_FLIP		(1 << 14)
+#define MT9V034_TILE_WEIGHT_GAIN_X0_Y0               0x80
+#define MT9V034_TILE_WEIGHT_GAIN_X1_Y0               0x81
+#define MT9V034_TILE_WEIGHT_GAIN_X2_Y0               0x82
+#define MT9V034_TILE_WEIGHT_GAIN_X3_Y0               0x83
+#define MT9V034_TILE_WEIGHT_GAIN_X4_Y0               0x84
+#define MT9V034_TILE_WEIGHT_GAIN_X0_Y1               0x85
+#define MT9V034_TILE_WEIGHT_GAIN_X1_Y1               0x86
+#define MT9V034_TILE_WEIGHT_GAIN_X2_Y1               0x87
+#define MT9V034_TILE_WEIGHT_GAIN_X3_Y1               0x88
+#define MT9V034_TILE_WEIGHT_GAIN_X4_Y1               0x89
+#define MT9V034_TILE_WEIGHT_GAIN_X0_Y2               0x8a
+#define MT9V034_TILE_WEIGHT_GAIN_X1_Y2               0x8b
+#define MT9V034_TILE_WEIGHT_GAIN_X2_Y2               0x8c
+#define MT9V034_TILE_WEIGHT_GAIN_X3_Y2               0x8d
+#define MT9V034_TILE_WEIGHT_GAIN_X4_Y2               0x8e
+#define MT9V034_TILE_WEIGHT_GAIN_X0_Y3               0x8f
+#define MT9V034_TILE_WEIGHT_GAIN_X1_Y3               0x90
+#define MT9V034_TILE_WEIGHT_GAIN_X2_Y3               0x91
+#define MT9V034_TILE_WEIGHT_GAIN_X3_Y3               0x92
+#define MT9V034_TILE_WEIGHT_GAIN_X4_Y3               0x93
+#define MT9V034_TILE_WEIGHT_GAIN_X0_Y4               0x94
+#define MT9V034_TILE_WEIGHT_GAIN_X1_Y4               0x95
+#define MT9V034_TILE_WEIGHT_GAIN_X2_Y4               0x96
+#define MT9V034_TILE_WEIGHT_GAIN_X3_Y4               0x97
+#define MT9V034_TILE_WEIGHT_GAIN_X4_Y4               0x98
+#define MT9V034_TILE_COORD_X0_5                      0x99
+#define MT9V034_TILE_COORD_X1_5                      0x9a
+#define MT9V034_TILE_COORD_X2_5                      0x9b
+#define MT9V034_TILE_COORD_X3_5                      0x9c
+#define MT9V034_TILE_COORD_X4_5                      0x9d
+#define MT9V034_TILE_COORD_X5_5                      0x9e
+#define MT9V034_TILE_COORD_Y0_5                      0x9f
+#define MT9V034_TILE_COORD_Y1_5                      0xa0
+#define MT9V034_TILE_COORD_Y2_5                      0xa1
+#define MT9V034_TILE_COORD_Y3_5                      0xa2
+#define MT9V034_TILE_COORD_Y4_5                      0xa3
+#define MT9V034_TILE_COORD_Y5_5                      0xa4
+#define MT9V034_AEC_AGC_DESIRED_BIN                  0xa5
+#define MT9V034_AEC_UPDATE_FREQUENCY                 0xa6
+#define MT9V034_AEC_LPF                              0xa8
+#define MT9V034_AGC_UPDATE_FREQUENCY                 0xa9
+#define MT9V034_AGC_LPF                              0xaa
+#define MT9V034_MAX_ANALOG_GAIN                      0xab
+#define MT9V034_AEC_MINIMUM_EXPOSURE                 0xac
+#define MT9V034_AEC_MAXIMUM_EXPOSURE                 0xad
+#define MT9V034_BIN_DIFFERENCE_THRESHOLD             0xae
+#define MT9V034_AEC_AGC_ENABLE_A_B                   0xaf
+#define 	MT9V034_AEC_ENABLE			(1 << 0)
+#define 	MT9V034_AGC_ENABLE			(1 << 1)
+#define MT9V034_AEC_AGC_PIX_COUNT                    0xb0
+#define MT9V034_LVDS_MASTER_CTRL                     0xb1
+#define MT9V034_LVDS_SHIFT_CLK_CTRL                  0xb2
+#define MT9V034_LVDS_DATA_CTRL                       0xb3
+#define MT9V034_DATA_STREAM_LATENCY                  0xb4
+#define MT9V034_LVDS_INTERNAL_SYNC                   0xb5
+#define MT9V034_LVDS_PAYLOAD_CONTROL                 0xb6
+#define MT9V034_STEREOSCOP_ERROR_CTRL                0xb7
+#define MT9V034_STEREOSCOP_ERROR_FLAG                0xb8
+#define MT9V034_LVDS_DATA_OUTPUT                     0xb9
+#define MT9V034_AGC_GAIN_OUTPUT                      0xba
+#define MT9V034_AEC_GAIN_OUTPUT                      0xbb
+#define MT9V034_AGC_AEC_CURRENT_BIN                  0xbc
+#define MT9V034_INTERLACE_FIELD_BLANC                0xbf
+#define MT9V034_MON_MODE_CAPTURE_CONTROL             0xc0
+#define MT9V034_ANTI_ECLIPSE_CONTROL                 0xc2
+#define MT9V034_NTSV_FV_LV_CONTROL                   0xc6
+#define MT9V034_NTSC_HORIZ_BLANC_CTRL                0xc7
+#define MT9V034_NTSC_VERT_BLANC_CTRL                 0xc8
+#define MT9V034_COLUMN_START_CONTEXT_B               0xc9
+#define MT9V034_ROW_START_CONTEXT_B                  0xca
+#define MT9V034_WIN_HEIGHT_CONTEXT_B                 0xcb
+#define MT9V034_WIN_WIDTH_CONTEXT_B                  0xcc
+#define MT9V034_HORIZONTAL_BLANCING_CONTEXT_B        0xcd
+#define MT9V034_VERTICAL_BLANCING_CONTEXT_B          0xce
+#define MT9V034_COARSE_SW1_CONTEXT_B                 0xcf
+#define MT9V034_COARSE_SW2_CONTEXT_B                 0xd0
+#define MT9V034_SHUTTER_WIDTH_CTRL_CONTEXT_B         0xd1
+#define MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_B 0xd2
+#define MT9V034_FINE_SW1_CONTEXT_A                   0xd3
+#define MT9V034_FINE_SW2_CONTEXT_A                   0xd4
+#define MT9V034_FINE_SHUTTER_WIDTH_TOTAL_CONTEXT_A   0xd5
+#define MT9V034_FINE_SW1_CONTEXT_B                   0xd6
+#define MT9V034_FINE_SW2_CONTEXT_B                   0xd7
+#define MT9V034_FINE_SHUTTER_WIDTH_TOTAL_CONTEXT_B   0xd8
+#define MT9V034_MONITOR_MODE                         0xd9
+#define MT9V034_BYTEWISE_ADDR                        0xf0
+#define MT9V034_REGISTER_LOCK                        0xfe
+
+#define MT9V034_PIXEL_ARRAY_HEIGHT		492
+#define MT9V034_PIXEL_ARRAY_WIDTH			782
+#define MT9V034_MAX_PICS_IN_A_ROW 5
+#define MT9V034_EXPOSURE_TIME_USEC 8000
+
+#ifndef DEBUG_PRINTOUTS
+//  #define DEBUG_PRINTOUTS 1
+//  #define DPRINT(s) printk(KERN_ALERT "%s\n", s)
+//#else
+  #define DPRINT(s)
+#endif
+
+struct mt9v034 {
+	struct v4l2_subdev subdev;
+	struct media_pad pad;
+
+	struct v4l2_mbus_framefmt format;
+	struct v4l2_rect crop;
+
+	struct v4l2_ctrl_handler ctrls;
+
+	struct mutex power_lock;
+	int power_count;
+
+	struct mt9v034_platform_data *pdata;
+	u16 chip_control;
+	u16 aec_agc;
+  int isReady;
+  
+  int exposure_time_us;
+  int analog_gain;
+};
+
+struct mt9v034 *g_mt9v034 = 0;  // Global structure so other drivers
can use the mt9v034_takepic function
+
+static int mt9v034_set_chip_control(struct mt9v034 *mt9v034, u16 clear,
u16 set);
+static int mt9v034_read(struct i2c_client *client, const u8 reg);
+
+static struct mt9v034 *to_mt9v034(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct mt9v034, subdev);
+}
+
+static void mt9v034_takepic(int nr_pics, int wait_ms, struct timespec
*cam_timespec)
+{
+  int nr;
+  int pic_ms;
+  int exp_ms;
+	 struct i2c_client *client;
+   u16 temp;
+
+  if (!g_mt9v034 || !g_mt9v034->isReady)
+    return;
+
+   client = v4l2_get_subdevdata(&g_mt9v034->subdev);    
+  // g_mt9v034->aec_agc = mt9v034_read(client,
MT9V034_AEC_AGC_ENABLE_A_B);
+  // printk(KERN_ALERT "MT9v034 aec_agc = 0x%x.\n",
g_mt9v034->aec_agc);
+  
+  temp = mt9v034_read(client, MT9V034_BL_CALIB_CTRL);
+  printk(KERN_ALERT "MT9V034_BL_CALIB_CTRL = 0x%x.\n", temp);
+  
+  temp = mt9v034_read(client, MT9V034_ROW_NOISE_CORR_CONTROL);
+  printk(KERN_ALERT "MT9V034_ROW_NOISE_CORR_CONTROL = 0x%x.\n", temp);
+    
+  exp_ms = (g_mt9v034->exposure_time_us / 1000);
+  pic_ms = 20 + exp_ms;
+  
+  if (wait_ms > pic_ms)         // Should we wait before taking the
first picture?
+    msleep(wait_ms - pic_ms);   // Sleep the time wanted minus 1
picture time
+  
+  nr = (nr_pics > MT9V034_MAX_PICS_IN_A_ROW)? MT9V034_MAX_PICS_IN_A_ROW
: nr_pics;
+  
+  ktime_get_ts(cam_timespec);
+  
+  // Will take 1 picture more that is overexposed
+  g_mt9v034->pdata->take_picture(&g_mt9v034->subdev, nr,
g_mt9v034->exposure_time_us / 1000); // Take pictures
+}
+EXPORT_SYMBOL_GPL(mt9v034_takepic);
+
+static int mt9v034_read(struct i2c_client *client, const u8 reg)
+{
+	s32 data = i2c_smbus_read_word_data(client, reg);
+	dev_dbg(&client->dev, "%s: read 0x%04x from 0x%02x\n", __func__,
+		swab16(data), reg);
+	return data < 0 ? data : swab16(data);
+}
+
+static int mt9v034_write(struct i2c_client *client, const u8 reg,
+			 const u16 data)
+{
+	dev_dbg(&client->dev, "%s: writing 0x%04x to 0x%02x\n",
__func__, data, reg);
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
+}
+
+static int mt9v034_set_chip_control(struct mt9v034 *mt9v034, u16 clear,
u16 set)
+{
+	struct i2c_client *client =
v4l2_get_subdevdata(&mt9v034->subdev);
+	u16 value;
+	int ret;
+
+  mt9v034->chip_control = mt9v034_read(client, MT9V034_CHIP_CONTROL);
+  value = (mt9v034->chip_control & ~clear) | set;
+	ret = mt9v034_write(client, MT9V034_CHIP_CONTROL, value);
+	if (ret < 0)
+		return ret;
+
+	mt9v034->chip_control = value;
+	return 0;
+}
+
+static int mt9v034_update_aec_agc(struct mt9v034 *mt9v034, u16 which,
int enable)
+{
+	struct i2c_client *client =
v4l2_get_subdevdata(&mt9v034->subdev);
+	u16 value = mt9v034->aec_agc;
+	int ret;
+
+	if (enable)
+		value |= which;
+	else
+		value &= ~which;
+
+	ret = mt9v034_write(client, MT9V034_AEC_AGC_ENABLE_A_B, value);
+	if (ret < 0)
+		return ret;
+
+	mt9v034->aec_agc = value;
+	return 0;
+}
+
+static int mt9v034_configure(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+	struct v4l2_mbus_framefmt *format = &mt9v034->format;
+	struct v4l2_rect *crop = &mt9v034->crop;
+	unsigned int hratio;
+	unsigned int vratio;
+	int ret;
+  unsigned int exposure_value;
+  unsigned int gain_value;
+  s32 temp;
+  
+  DPRINT("mt9v034_configure");
+
+  ret = mt9v034_set_chip_control(mt9v034,
MT9V034_CHIP_CONTROL_RESERVED, MT9V034_CHIP_CONTROL_SNAPSHOT_MODE);  //
Clear bit 9 for normal operation and set to snapshot mode
+  if (ret < 0)
+    return ret;
+  
+	/* Configure the window size and row/column bin */
+	hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
+	vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
+  
+	ret = mt9v034_write(client, MT9V034_COLUMN_START_CONTEXT_A,
crop->left);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9v034_write(client, MT9V034_ROW_START_CONTEXT_A,
crop->top);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9v034_write(client, MT9V034_WIN_WIDTH_CONTEXT_A,
crop->width);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9v034_write(client, MT9V034_WIN_HEIGHT_CONTEXT_A,
crop->height);
+	if (ret < 0)
+		return ret;
+    
+  ret = mt9v034_write(client, MT9V034_AEC_AGC_ENABLE_A_B,
mt9v034->aec_agc);  // Set AEC (Automatic Exposure Control) and AGC
(Automatic Gain Control)
+  if (ret < 0)
+    return ret;
+
+  if (!mt9v034->aec_agc)  // No automatic exposure or gain control?
+  {
+    exposure_value = (30375 * mt9v034->exposure_time_us / 1000000);
+    
+    ret = mt9v034_write(client,
MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_A, exposure_value); // Set
"Total shutter width" register so exposure time is set
+    if (ret < 0)
+    {
+      printk(KERN_ALERT "Error setting exposure on MT9V034 camera
sensor.\n");
+      return ret;
+    }
+    
+    gain_value = 16 * mt9v034->analog_gain;
+    
+    ret = mt9v034_write(client,  MT9V034_ANALOG_GAIN_CONTEXT_A,
gain_value); // Set "Analog gain" register so gain is set
+    if (ret < 0)
+    {
+      printk(KERN_ALERT "Error setting analog gain on MT9V034 camera
sensor.\n");
+      return ret;
+    }
+  }
+  
+	ret = mt9v034_write(client, MT9V034_BL_CALIB_CTRL, 1);  //
Override automatic black level correction with programmed values
+	if (ret < 0)
+		return ret;
+    
+	ret = mt9v034_write(client,
MT9V034_BLACK_LEVEL_CALIBRATION_VALUE, 0);  // Disable black calibration
+	if (ret < 0)
+		return ret;
+  
+	ret = mt9v034_write(client, MT9V034_ROW_NOISE_CORR_CONTROL, 0);
// Disable row noise correction
+	if (ret < 0)
+		return ret;
+
+	v4l2_ctrl_handler_setup(&mt9v034->ctrls);
+  
+  mt9v034->isReady = 1;
+  
+  return 0;
+}
+
+static int mt9v034_power_on(struct mt9v034 *mt9v034)
+{
+	if (mt9v034->pdata->set_clock) {
+		mt9v034->pdata->set_clock(&mt9v034->subdev, 24000000);
+	}
+
+  msleep(1);
+
+  mt9v034->pdata->configure(&mt9v034->subdev);
+
+  msleep(1);
+
+  mt9v034->pdata->reset();
+  
+  return mt9v034_configure(&mt9v034->subdev);
+}
+
+static void mt9v034_power_off(struct mt9v034 *mt9v034)
+{
+	if (mt9v034->pdata->set_clock)
+		mt9v034->pdata->set_clock(&mt9v034->subdev, 0);
+    
+  mt9v034->isReady = 0;
+}
+
+static int __mt9v034_set_power(struct mt9v034 *mt9v034, int on)
+{
+	struct i2c_client *client =
v4l2_get_subdevdata(&mt9v034->subdev);
+	int ret;
+
+	if (!on) {
+		mt9v034_power_off(mt9v034);
+    return 0;
+	}
+
+	ret = mt9v034_power_on(mt9v034);
+	if (ret < 0)
+		return ret;
+
+	/* Configure the pixel clock polarity */
+	if (mt9v034->pdata && mt9v034->pdata->clk_pol) {
+		ret  = mt9v034_write(client, MT9V034_PIXCLK_FV_LV_CTRL,
MT9V034_PIXEL_CLOCK_INV_PXL_CLK);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
------------------------------------------------------------------------
-----
+ * V4L2 subdev video operations
+ */
+
+static struct v4l2_mbus_framefmt *
+__mt9v034_get_pad_format(struct mt9v034 *mt9v034, struct v4l2_subdev_fh
*fh,
+			 unsigned int pad, enum
v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &mt9v034->format;
+	default:
+		return NULL;
+	}
+}
+
+static struct v4l2_rect *
+__mt9v034_get_pad_crop(struct mt9v034 *mt9v034, struct v4l2_subdev_fh
*fh,
+		       unsigned int pad, enum v4l2_subdev_format_whence
which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &mt9v034->crop;
+	default:
+		return NULL;
+	}
+}
+
+static inline void print_reg(struct mt9v034 *sensor, const char *name,
u8 address)
+{
+	struct i2c_client *client =
v4l2_get_subdevdata(&sensor->subdev);
+  s32 reg_value = i2c_smbus_read_word_data(client, address);
+  printk(KERN_ALERT "%s = 0x%x\n", name, swab16(reg_value));
+}
+
+static inline void mt9v034_print_registers(struct mt9v034 *sensor)
+{
+  print_reg(sensor, "MT9V034_CHIP_VERSION", 0x00);
+  print_reg(sensor, "MT9V034_COLUMN_START_CONTEXT_A", 0x01);
+  print_reg(sensor, "MT9V034_ROW_START_CONTEXT_A", 0x02);
+  print_reg(sensor, "MT9V034_WIN_HEIGHT_CONTEXT_A", 0x03);
+  print_reg(sensor, "MT9V034_WIN_WIDTH_CONTEXT_A", 0x04);
+  print_reg(sensor, "MT9V034_HORIZONTAL_BLANCING_CONTEXT_A", 0x05);
+  print_reg(sensor, "MT9V034_VERTICAL_BLANCING_CONTEXT_A", 0x06);
+  print_reg(sensor, "MT9V034_CHIP_CONTROL", 0x07);
+  print_reg(sensor, "MT9V034_COARSE_SHUTTER_WIDTH1_CONTEXT_A", 0x08);
+  print_reg(sensor, "MT9V034_COARSE_SHUTTER_WIDTH2_CONTEXT_A", 0x09);
+  print_reg(sensor, "MT9V034_SHUTTER_WIDTH_CTRL_CONTEXT_A", 0x0a);
+  print_reg(sensor, "MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_A",
0x0b);
+  print_reg(sensor, "MT9V034_RESET", 0x0c);
+  print_reg(sensor, "MT9V034_READ_MODE_CONTEXT_A", 0x0d);
+  print_reg(sensor, "MT9V034_READ_MODE_CONTEXT_B", 0x0e);
+  print_reg(sensor, "MT9V034_SENSOR_TYPE_HDR_ENABLE", 0x0f);
+  print_reg(sensor, "MT9V034_LED_OUT_CTRL", 0x1b);
+  print_reg(sensor, "MT9V034_COMPANDING", 0x1c);
+  print_reg(sensor, "MT9V034_VREF_ADC_CTRL", 0x2c);
+  print_reg(sensor, "MT9V034_V1_CONTROL_CONTEXT_A", 0x31);
+  print_reg(sensor, "MT9V034_V2_CONTROL_CONTEXT_A", 0x32);
+  print_reg(sensor, "MT9V034_V3_CONTROL_CONTEXT_A", 0x33);
+  print_reg(sensor, "MT9V034_V4_CONTROL_CONTEXT_A", 0x34);
+  print_reg(sensor, "MT9V034_ANALOG_GAIN_CONTEXT_A", 0x35);
+  print_reg(sensor, "MT9V034_ANALOG_GAIN_CONTEXT_B", 0x36);
+  print_reg(sensor, "MT9V034_V1_CONTROL_CONTEXT_B", 0x39);
+  print_reg(sensor, "MT9V034_V2_CONTROL_CONTEXT_B", 0x3a);
+  print_reg(sensor, "MT9V034_V3_CONTROL_CONTEXT_B", 0x3b);
+  print_reg(sensor, "MT9V034_V4_CONTROL_CONTEXT_B", 0x3c);
+  print_reg(sensor, "MT9V034_FRAME_DARK_AVERAGE", 0x42);
+  print_reg(sensor, "MT9V034_DARK_AVERAGE_THRESHOLD", 0x46);
+  print_reg(sensor, "MT9V034_BL_CALIB_CTRL", 0x47);
+  print_reg(sensor, "MT9V034_BLACK_LEVEL_CALIBRATION_VALUE", 0x48);
+  print_reg(sensor, "MT9V034_BL_CALIB_STEP_SIZE", 0x4c);
+  print_reg(sensor, "MT9V034_ROW_NOISE_CORR_CONTROL", 0x70);
+  print_reg(sensor, "MT9V034_ROW_NOISE_CONSTANT", 0x71);
+  print_reg(sensor, "MT9V034_PIXCLK_FV_LV_CTRL", 0x72);
+  print_reg(sensor, "MT9V034_DIGITAL_TEST_PATTERN", 0x7f);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X0_Y0", 0x80);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X1_Y0", 0x81);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X2_Y0", 0x82);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X3_Y0", 0x83);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X4_Y0", 0x84);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X0_Y1", 0x85);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X1_Y1", 0x86);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X2_Y1", 0x87);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X3_Y1", 0x88);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X4_Y1", 0x89);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X0_Y2", 0x8a);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X1_Y2", 0x8b);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X2_Y2", 0x8c);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X3_Y2", 0x8d);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X4_Y2", 0x8e);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X0_Y3", 0x8f);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X1_Y3", 0x90);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X2_Y3", 0x91);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X3_Y3", 0x92);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X4_Y3", 0x93);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X0_Y4", 0x94);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X1_Y4", 0x95);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X2_Y4", 0x96);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X3_Y4", 0x97);
+  print_reg(sensor, "MT9V034_TILE_WEIGHT_GAIN_X4_Y4", 0x98);
+  print_reg(sensor, "MT9V034_TILE_COORD_X0_5", 0x99);
+  print_reg(sensor, "MT9V034_TILE_COORD_X1_5", 0x9a);
+  print_reg(sensor, "MT9V034_TILE_COORD_X2_5", 0x9b);
+  print_reg(sensor, "MT9V034_TILE_COORD_X3_5", 0x9c);
+  print_reg(sensor, "MT9V034_TILE_COORD_X4_5", 0x9d);
+  print_reg(sensor, "MT9V034_TILE_COORD_X5_5", 0x9e);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y0_5", 0x9f);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y1_5", 0xa0);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y2_5", 0xa1);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y3_5", 0xa2);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y4_5", 0xa3);
+  print_reg(sensor, "MT9V034_TILE_COORD_Y5_5", 0xa4);
+  print_reg(sensor, "MT9V034_AEC_AGC_DESIRED_BIN", 0xa5);
+  print_reg(sensor, "MT9V034_AEC_UPDATE_FREQUENCY", 0xa6);
+  print_reg(sensor, "MT9V034_AEC_LPF", 0xa8);
+  print_reg(sensor, "MT9V034_AGC_UPDATE_FREQUENCY", 0xa9);
+  print_reg(sensor, "MT9V034_AGC_LPF", 0xaa);
+  print_reg(sensor, "MT9V034_MAX_ANALOG_GAIN", 0xab);
+  print_reg(sensor, "MT9V034_AEC_MINIMUM_EXPOSURE", 0xac);
+  print_reg(sensor, "MT9V034_AEC_MAXIMUM_EXPOSURE", 0xad);
+  print_reg(sensor, "MT9V034_BIN_DIFFERENCE_THRESHOLD", 0xae);
+  print_reg(sensor, "MT9V034_AEC_AGC_ENABLE_A_B", 0xaf);
+  print_reg(sensor, "MT9V034_AEC_AGC_PIX_COUNT", 0xb0);
+  print_reg(sensor, "MT9V034_LVDS_MASTER_CTRL", 0xb1);
+  print_reg(sensor, "MT9V034_LVDS_SHIFT_CLK_CTRL", 0xb2);
+  print_reg(sensor, "MT9V034_LVDS_DATA_CTRL", 0xb3);
+  print_reg(sensor, "MT9V034_DATA_STREAM_LATENCY", 0xb4);
+  print_reg(sensor, "MT9V034_LVDS_INTERNAL_SYNC", 0xb5);
+  print_reg(sensor, "MT9V034_LVDS_PAYLOAD_CONTROL", 0xb6);
+  print_reg(sensor, "MT9V034_STEREOSCOP_ERROR_CTRL", 0xb7);
+  print_reg(sensor, "MT9V034_STEREOSCOP_ERROR_FLAG", 0xb8);
+  print_reg(sensor, "MT9V034_LVDS_DATA_OUTPUT", 0xb9);
+  print_reg(sensor, "MT9V034_AGC_GAIN_OUTPUT", 0xba);
+  print_reg(sensor, "MT9V034_AEC_GAIN_OUTPUT", 0xbb);
+  print_reg(sensor, "MT9V034_AGC_AEC_CURRENT_BIN", 0xbc);
+  print_reg(sensor, "MT9V034_INTERLACE_FIELD_BLANC", 0xbf);
+  print_reg(sensor, "MT9V034_MON_MODE_CAPTURE_CONTROL", 0xc0);
+  print_reg(sensor, "MT9V034_ANTI_ECLIPSE_CONTROL", 0xc2);
+  print_reg(sensor, "MT9V034_NTSV_FV_LV_CONTROL", 0xc6);
+  print_reg(sensor, "MT9V034_NTSC_HORIZ_BLANC_CTRL", 0xc7);
+  print_reg(sensor, "MT9V034_NTSC_VERT_BLANC_CTRL", 0xc8);
+  print_reg(sensor, "MT9V034_COLUMN_START_CONTEXT_B", 0xc9);
+  print_reg(sensor, "MT9V034_ROW_START_CONTEXT_B", 0xca);
+  print_reg(sensor, "MT9V034_ROW_WIN_HEIGHT_CONTEXT_B", 0xcb);
+  print_reg(sensor, "MT9V034_WINDOW_WIDTH_CONTEXT_B", 0xcc);
+  print_reg(sensor, "MT9V034_HORIZONTAL_BLANCING_CONTEXT_B", 0xcd);
+  print_reg(sensor, "MT9V034_VERTICAL_BLANCING_CONTEXT_B", 0xce);
+  print_reg(sensor, "MT9V034_COARSE_SW1_CONTEXT_B", 0xcf);
+  print_reg(sensor, "MT9V034_COARSE_SW2_CONTEXT_B", 0xd0);
+  print_reg(sensor, "MT9V034_SHUTTER_WIDTH_CTRL_CONTEXT_B", 0xd1);
+  print_reg(sensor, "MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_B",
0xd2);
+  print_reg(sensor, "MT9V034_FINE_SW1_CONTEXT_A", 0xd3);
+  print_reg(sensor, "MT9V034_FINE_SW2_CONTEXT_A", 0xd4);
+  print_reg(sensor, "MT9V034_FINE_SHUTTER_WIDTH_TOTAL_CONTEXT_A",
0xd5);
+  print_reg(sensor, "MT9V034_FINE_SW1_CONTEXT_B", 0xd6);
+  print_reg(sensor, "MT9V034_FINE_SW2_CONTEXT_B", 0xd7);
+  print_reg(sensor, "MT9V034_FINE_SHUTTER_WIDTH_TOTAL_CONTEXT_B",
0xd8);
+  print_reg(sensor, "MT9V034_MONITOR_MODE", 0xd9);
+  print_reg(sensor, "MT9V034_BYTEWISE_ADDR", 0xf0);
+  print_reg(sensor, "MT9V034_REGISTER_LOCK", 0xfe);
+}
+
+static int mt9v034_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+  struct timespec t;
+	int ret;
+
+	DPRINT("mt9v034_s_stream");
+	
+	if (!enable) {
+		return __mt9v034_set_power(mt9v034, 0);
+	}
+
+	ret = __mt9v034_set_power(mt9v034, 1);
+	if (ret < 0)
+		return ret;
+
+//  mt9v034_print_registers(mt9v034);
+
+  msleep(40);
+  
+  mt9v034_takepic(0, 0, &t); // Take 1 picture that has old settings
(automatic gain/exposure). Ignore it.
+  
+	return 0;
+}
+
+static int mt9v034_enum_mbus_code(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum
*code)
+{
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	return 0;
+}
+
+static int mt9v034_enum_frame_size(struct v4l2_subdev *subdev,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum
*fse)
+{
+	if (fse->index >= 8 || fse->code != V4L2_MBUS_FMT_SGRBG10_1X10)
+		return -EINVAL;
+
+	fse->min_width = MT9V034_WINDOW_WIDTH_DEF / fse->index;
+	fse->max_width = fse->min_width;
+	fse->min_height = MT9V034_WINDOW_HEIGHT_DEF / fse->index;
+	fse->max_height = fse->min_height;
+
+	return 0;
+}
+
+static int mt9v034_get_format(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+
+	format->format = *__mt9v034_get_pad_format(mt9v034, fh,
format->pad, format->which);
+	return 0;
+}
+
+static int mt9v034_set_format(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+	struct v4l2_mbus_framefmt *__format;
+	struct v4l2_rect *__crop;
+	unsigned int width;
+	unsigned int height;
+	unsigned int hratio;
+	unsigned int vratio;
+
+	__crop = __mt9v034_get_pad_crop(mt9v034, fh, format->pad,
+					format->which);
+
+	/* Clamp the width and height to avoid dividing by zero. */
+	width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
+			max(__crop->width / 8,
MT9V034_WINDOW_WIDTH_MIN),
+			__crop->width);
+	height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
+			 max(__crop->height / 8,
MT9V034_WINDOW_HEIGHT_MIN),
+			 __crop->height);
+
+	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
+	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
+
+	__format = __mt9v034_get_pad_format(mt9v034, fh, format->pad,
+					    format->which);
+	__format->width = __crop->width / hratio;
+	__format->height = __crop->height / vratio;
+
+	format->format = *__format;
+
+	return 0;
+}
+
+static int mt9v034_get_crop(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+
+	crop->rect = *__mt9v034_get_pad_crop(mt9v034, fh, crop->pad,
+					     crop->which);
+	return 0;
+}
+
+static int mt9v034_set_crop(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+	struct v4l2_mbus_framefmt *__format;
+	struct v4l2_rect *__crop;
+	struct v4l2_rect rect;
+
+	/* Clamp the crop rectangle boundaries and align them to a
multiple of 2
+	 * pixels.
+	 */
+	rect.left = clamp(ALIGN(crop->rect.left, 2),
+			  MT9V034_COLUMN_START_MIN,
+			  MT9V034_COLUMN_START_MAX);
+	rect.top = clamp(ALIGN(crop->rect.top, 2),
+			 MT9V034_ROW_START_MIN,
+			 MT9V034_ROW_START_MAX);
+	rect.width = clamp(ALIGN(crop->rect.width, 2),
+			   MT9V034_WINDOW_WIDTH_MIN,
+			   MT9V034_WINDOW_WIDTH_MAX);
+	rect.height = clamp(ALIGN(crop->rect.height, 2),
+			    MT9V034_WINDOW_HEIGHT_MIN,
+			    MT9V034_WINDOW_HEIGHT_MAX);
+	rect.width = min(rect.width, MT9V034_PIXEL_ARRAY_WIDTH -
rect.left);
+	rect.height = min(rect.height, MT9V034_PIXEL_ARRAY_HEIGHT -
rect.top);
+
+	__crop = __mt9v034_get_pad_crop(mt9v034, fh, crop->pad,
crop->which);
+
+	if (rect.width != __crop->width || rect.height !=
__crop->height) {
+		/* Reset the output image size if the crop rectangle
size has
+		 * been modified.
+		 */
+		__format = __mt9v034_get_pad_format(mt9v034, fh,
crop->pad,
+						    crop->which);
+		__format->width = rect.width;
+		__format->height = rect.height;
+	}
+
+	*__crop = rect;
+	crop->rect = rect;
+
+	return 0;
+}
+
+/*
------------------------------------------------------------------------
-----
+ * V4L2 subdev control operations
+ */
+
+#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
+
+static int mt9v034_s_ctrl(struct v4l2_ctrl *ctrl)
+{ 
+  struct mt9v034 *mt9v034 = container_of(ctrl->handler, struct mt9v034,
ctrls);
+	struct i2c_client *client =
v4l2_get_subdevdata(&mt9v034->subdev);
+	u16 data;
+  int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		return mt9v034_update_aec_agc(mt9v034,
MT9V034_AGC_ENABLE, ctrl->val);
+
+	case V4L2_CID_GAIN:
+    mt9v034->analog_gain = ctrl->val;
+    return ret;
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		return mt9v034_update_aec_agc(mt9v034,
MT9V034_AEC_ENABLE, !ctrl->val);
+
+	case V4L2_CID_EXPOSURE:
+    mt9v034->exposure_time_us = ctrl->val;
+		return 0;
+
+	case V4L2_CID_TEST_PATTERN:
+		switch (ctrl->val) {
+		case 0:
+			data = 0;
+			break;
+		case 1:
+			data = MT9V034_TEST_PATTERN_GRAY_VERTICAL
+			     | MT9V034_TEST_PATTERN_ENABLE;
+			break;
+		case 2:
+			data = MT9V034_TEST_PATTERN_GRAY_HORIZONTAL
+			     | MT9V034_TEST_PATTERN_ENABLE;
+			break;
+		case 3:
+			data = MT9V034_TEST_PATTERN_GRAY_DIAGONAL
+			     | MT9V034_TEST_PATTERN_ENABLE;
+			break;
+		default:
+			data = (ctrl->val <<
MT9V034_TEST_PATTERN_DATA_SHIFT)
+			     | MT9V034_TEST_PATTERN_USE_DATA
+			     | MT9V034_TEST_PATTERN_ENABLE
+			     | MT9V034_TEST_PATTERN_FLIP;
+			break;
+		}
+
+		return mt9v034_write(client,
MT9V034_DIGITAL_TEST_PATTERN, data);
+	}
+
+	return 0;
+}
+
+static struct v4l2_ctrl_ops mt9v034_ctrl_ops = {
+	.s_ctrl = mt9v034_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config mt9v034_ctrls[] = {
+	{
+		.ops		= &mt9v034_ctrl_ops,
+		.id		= V4L2_CID_TEST_PATTERN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Test pattern",
+		.min		= 0,
+		.max		= 1023,
+		.step		= 1,
+		.def		= 0,
+		.flags		= 0,
+	},
+};
+
+/*
------------------------------------------------------------------------
-----
+ * V4L2 subdev core operations
+ */
+
+static int mt9v034_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+	int ret = 0;
+
+	mutex_lock(&mt9v034->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to
0,
+	 * update the power state.
+	 */
+	if (mt9v034->power_count == !on) {
+		ret = __mt9v034_set_power(mt9v034, !!on);
+		if (ret < 0)
+			goto done;
+	}
+
+	/* Update the power count. */
+	mt9v034->power_count += on ? 1 : -1;
+	WARN_ON(mt9v034->power_count < 0);
+
+done:
+	mutex_unlock(&mt9v034->power_lock);
+	return ret;
+}
+
+/*
------------------------------------------------------------------------
-----
+ * V4L2 subdev internal operations
+ */
+
+static int mt9v034_registered(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+	s32 data;
+	int ret;
+
+	dev_info(&client->dev, "Probing MT9V034 at address 0x%02x\n",
+			client->addr);
+
+	ret = mt9v034_power_on(mt9v034);
+	if (ret < 0) {
+		dev_err(&client->dev, "MT9V034 power up failed\n");
+		return ret;
+	}
+
+	/* Read and check the sensor version */
+	data = mt9v034_read(client, MT9V034_CHIP_VERSION);
+	if (data != MT9V034_CHIP_ID) {
+		dev_err(&client->dev, "MT9V034 not detected, wrong
version "
+				"0x%04x\n", data);
+		return -ENODEV;
+	}
+
+	mt9v034_power_off(mt9v034);
+
+	dev_info(&client->dev, "MT9V034 detected at address 0x%02x\n",
+			client->addr);
+
+	return ret;
+}
+
+static int mt9v034_open(struct v4l2_subdev *subdev, struct
v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	crop = v4l2_subdev_get_try_crop(fh, 0);
+	crop->left = MT9V034_COLUMN_START_DEF;
+	crop->top = MT9V034_ROW_START_DEF;
+	crop->width = MT9V034_WINDOW_WIDTH_DEF;
+	crop->height = MT9V034_WINDOW_HEIGHT_DEF;
+
+	format = v4l2_subdev_get_try_format(fh, 0);
+	format->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format->width = MT9V034_WINDOW_WIDTH_DEF;
+	format->height = MT9V034_WINDOW_HEIGHT_DEF;
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	return mt9v034_set_power(subdev, 1);
+}
+
+static int mt9v034_close(struct v4l2_subdev *subdev, struct
v4l2_subdev_fh *fh)
+{
+	return mt9v034_set_power(subdev, 0);
+}
+
+static struct v4l2_subdev_core_ops mt9v034_subdev_core_ops = {
+	.s_power	= mt9v034_set_power,
+};
+
+static struct v4l2_subdev_video_ops mt9v034_subdev_video_ops = {
+	.s_stream	= mt9v034_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops mt9v034_subdev_pad_ops = {
+	.enum_mbus_code = mt9v034_enum_mbus_code,
+	.enum_frame_size = mt9v034_enum_frame_size,
+	.get_fmt = mt9v034_get_format,
+	.set_fmt = mt9v034_set_format,
+	.get_crop = mt9v034_get_crop,
+	.set_crop = mt9v034_set_crop,
+};
+
+static struct v4l2_subdev_ops mt9v034_subdev_ops = {
+	.core	= &mt9v034_subdev_core_ops,
+	.video	= &mt9v034_subdev_video_ops,
+	.pad	= &mt9v034_subdev_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops
mt9v034_subdev_internal_ops = {
+	.registered = mt9v034_registered,
+	.open = mt9v034_open,
+	.close = mt9v034_close,
+};
+
+/*
------------------------------------------------------------------------
-----
+ * Driver initialization and probing
+ */
+
+static int mt9v034_probe(struct i2c_client *client,
+		const struct i2c_device_id *did)
+{
+	struct mt9v034 *mt9v034;
+	unsigned int i;
+	int ret;
+	
+	DPRINT("mt9v034_probe");
+
+	if (!i2c_check_functionality(client->adapter,
I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_warn(&client->adapter->dev,
+			 "I2C-Adapter doesn't support
I2C_FUNC_SMBUS_WORD\n");
+		return -EIO;
+	}
+
+	mt9v034 = kzalloc(sizeof(*mt9v034), GFP_KERNEL);
+	if (!mt9v034)
+		return -ENOMEM;
+
+	mutex_init(&mt9v034->power_lock);
+	mt9v034->pdata = client->dev.platform_data;
+
+	v4l2_ctrl_handler_init(&mt9v034->ctrls,
ARRAY_SIZE(mt9v034_ctrls) + 4);
+
+	v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
+			  V4L2_CID_AUTOGAIN, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
+			  V4L2_CID_GAIN, MT9V034_ANALOG_GAIN_MIN,
+			  MT9V034_ANALOG_GAIN_MAX, 1,
MT9V034_ANALOG_GAIN_DEF);
+	v4l2_ctrl_new_std_menu(&mt9v034->ctrls, &mt9v034_ctrl_ops,
+			       V4L2_CID_EXPOSURE_AUTO,
V4L2_EXPOSURE_MANUAL, 0,
+			       V4L2_EXPOSURE_MANUAL);
+	v4l2_ctrl_new_std(&mt9v034->ctrls, &mt9v034_ctrl_ops,
+			  V4L2_CID_EXPOSURE,
MT9V034_TOTAL_SHUTTER_WIDTH_MIN_US,
+			  MT9V034_TOTAL_SHUTTER_WIDTH_MAX_US, 1,
+			  MT9V034_TOTAL_SHUTTER_WIDTH_DEF_US);
+
+	for (i = 0; i < ARRAY_SIZE(mt9v034_ctrls); ++i)
+		v4l2_ctrl_new_custom(&mt9v034->ctrls, &mt9v034_ctrls[i],
NULL);
+
+	mt9v034->subdev.ctrl_handler = &mt9v034->ctrls;
+
+	if (mt9v034->ctrls.error)
+		printk(KERN_INFO "%s: control initialization error
%d\n",
+		       __func__, mt9v034->ctrls.error);
+
+	mt9v034->crop.left = MT9V034_COLUMN_START_DEF;
+	mt9v034->crop.top = MT9V034_ROW_START_DEF;
+	mt9v034->crop.width = MT9V034_WINDOW_WIDTH_DEF;
+	mt9v034->crop.height = MT9V034_WINDOW_HEIGHT_DEF;
+
+	mt9v034->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	
+	mt9v034->format.width = MT9V034_WINDOW_WIDTH_DEF;
+	mt9v034->format.height = MT9V034_WINDOW_HEIGHT_DEF;
+	mt9v034->format.field = V4L2_FIELD_NONE;
+	mt9v034->format.colorspace = V4L2_COLORSPACE_SRGB;
+
+	mt9v034->aec_agc = 0; // Disable AEC and AGC
+  mt9v034->isReady = 0;
+  mt9v034->exposure_time_us = MT9V034_EXPOSURE_TIME_USEC;
+  mt9v034->analog_gain = MT9V034_ANALOG_GAIN_DEF;
+	
+	v4l2_i2c_subdev_init(&mt9v034->subdev, client,
&mt9v034_subdev_ops);
+	mt9v034->subdev.internal_ops = &mt9v034_subdev_internal_ops;
+	mt9v034->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	mt9v034->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&mt9v034->subdev.entity, 1,
&mt9v034->pad, 0);
+
+  if (ret < 0)
+    kfree(mt9v034);	
+  else
+    g_mt9v034 = mt9v034;
+    
+  return ret;
+}
+
+static int mt9v034_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
+
+	v4l2_device_unregister_subdev(subdev);
+	media_entity_cleanup(&subdev->entity);
+
+	kfree(mt9v034);
+	
+	g_mt9v034 = 0;
+	
+	return 0;
+}
+
+static const struct i2c_device_id mt9v034_id[] = {
+	{ "mt9v034", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, mt9v034_id);
+
+static struct i2c_driver mt9v034_driver = {
+	.driver = {
+		.name = "mt9v034",
+	},
+	.probe		= mt9v034_probe,
+	.remove		= mt9v034_remove,
+	.id_table	= mt9v034_id,
+};
+
+static int __init mt9v034_init(void)
+{
+	return i2c_add_driver(&mt9v034_driver);
+}
+
+static void __exit mt9v034_exit(void)
+{
+	i2c_del_driver(&mt9v034_driver);
+}
+
+module_init(mt9v034_init);
+module_exit(mt9v034_exit);
+
+MODULE_DESCRIPTION("Aptina MT9V034 Camera driver");
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_LICENSE("GPL");
diff -urNp a/include/media/mt9v034.h b/include/media/mt9v034.h
--- a/include/media/mt9v034.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/media/mt9v034.h	2011-05-30 15:04:44.000000000 +0200
@@ -0,0 +1,15 @@
+#ifndef _MEDIA_MT9V034_H
+#define _MEDIA_MT9V034_H
+
+struct v4l2_subdev;
+
+struct mt9v034_platform_data {
+  unsigned int clk_pol:1;
+	
+  void (*set_clock)(struct v4l2_subdev *subdev, unsigned int rate);
+  void (*configure)(struct v4l2_subdev *subdev);
+  void (*take_picture)(struct v4l2_subdev *subdev, int nr_pics, int
exposure_time_ms);
+  void (*reset)(void);
+};
+
+#endif
 
--------------------------------------------------------

Hope it comes to some use. :)

Regards,

Daniel Lundborg
