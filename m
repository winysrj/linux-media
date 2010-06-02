Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43383 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab0FBOLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 10:11:17 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 2 Jun 2010 19:37:05 +0530
Subject: RE: [PATCH 2/2] AM3517: Add VPFE Capture driver support to board
 file
Message-ID: <19F8576C6E063C45BE387C64729E7394044DA71055@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1274965876-21845-3-git-send-email-hvaibhav@ti.com>,<A69FA2915331DC488A831521EAE36FE4016B185703@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016B185703@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


________________________________________
From: Karicheri, Muralidharan
Sent: Wednesday, June 02, 2010 7:31 PM
To: Hiremath, Vaibhav; linux-media@vger.kernel.org
Cc: mchehab@redhat.com; linux-omap@vger.kernel.org
Subject: RE: [PATCH 2/2] AM3517: Add VPFE Capture driver support to board file

Vaibhav,

See below my comments...

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hiremath, Vaibhav
>Sent: Thursday, May 27, 2010 9:11 AM
>To: linux-media@vger.kernel.org
>Cc: mchehab@redhat.com; Karicheri, Muralidharan; linux-
>omap@vger.kernel.org; Hiremath, Vaibhav
>Subject: [PATCH 2/2] AM3517: Add VPFE Capture driver support to board file
>
>From: Vaibhav Hiremath <hvaibhav@ti.com>
>
>Also created vpfe master/slave clock aliases, since naming
>convention is different in both Davinci and AM3517 devices.
>
>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>---
> arch/arm/mach-omap2/board-am3517evm.c |  161
>+++++++++++++++++++++++++++++++++
> 1 files changed, 161 insertions(+), 0 deletions(-)
>
>diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-
>omap2/board-am3517evm.c
>index c1c4389..edcb6db 100644
>--- a/arch/arm/mach-omap2/board-am3517evm.c
>+++ b/arch/arm/mach-omap2/board-am3517evm.c
>@@ -30,15 +30,168 @@
>
> #include <plat/board.h>
> #include <plat/common.h>
>+#include <plat/control.h>
> #include <plat/usb.h>
> #include <plat/display.h>
>
>+#include <media/tvp514x.h>
>+#include <media/davinci/vpfe_capture.h>
>+
> #include "mux.h"
>
> #define LCD_PANEL_PWR         176
> #define LCD_PANEL_BKLIGHT_PWR 182
> #define LCD_PANEL_PWM         181
>
>+/*
>+ * VPFE - Video Decoder interface
>+ */
>+#define TVP514X_STD_ALL               (V4L2_STD_NTSC | V4L2_STD_PAL)
>+
>+/* Inputs available at the TVP5146 */
>+static struct v4l2_input tvp5146_inputs[] = {
>+      {
>+              .index  = 0,
>+              .name   = "Composite",
>+              .type   = V4L2_INPUT_TYPE_CAMERA,
>+              .std    = TVP514X_STD_ALL,
>+      },
>+      {
>+              .index  = 1,
>+              .name   = "S-Video",
>+              .type   = V4L2_INPUT_TYPE_CAMERA,
>+              .std    = TVP514X_STD_ALL,
>+      },
>+};
>+
>+static struct tvp514x_platform_data tvp5146_pdata = {
>+      .clk_polarity   = 0,
>+      .hs_polarity    = 1,
>+      .vs_polarity    = 1
>+};
>+
>+static struct vpfe_route tvp5146_routes[] = {
>+      {
>+              .input  = INPUT_CVBS_VI1A,
>+              .output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>+      },
>+      {
>+              .input  = INPUT_SVIDEO_VI2C_VI1C,
>+              .output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>+      },
>+};
>+
>+static struct vpfe_subdev_info vpfe_sub_devs[] = {
>+      {
>+              .name           = "tvp5146",
>+              .grp_id         = 0,
>+              .num_inputs     = ARRAY_SIZE(tvp5146_inputs),
>+              .inputs         = tvp5146_inputs,
>+              .routes         = tvp5146_routes,
>+              .can_route      = 1,
>+              .ccdc_if_params = {
>+                      .if_type = VPFE_BT656,
>+                      .hdpol  = VPFE_PINPOL_POSITIVE,
>+                      .vdpol  = VPFE_PINPOL_POSITIVE,
>+              },
>+              .board_info     = {
>+                      I2C_BOARD_INFO("tvp5146", 0x5C),
>+                      .platform_data = &tvp5146_pdata,
>+              },
>+      },
>+};
>+
>+static void am3517_evm_clear_vpfe_intr(int vdint)
>+{
>+      unsigned int vpfe_int_clr;
>+
>+      vpfe_int_clr = omap_ctrl_readl(AM35XX_CONTROL_LVL_INTR_CLEAR);
>+
>+      switch (vdint) {
>+      /* VD0 interrrupt */
>+      case INT_35XX_CCDC_VD0_IRQ:
>+              vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD0_INT_CLR;
>+              vpfe_int_clr |= AM35XX_VPFE_CCDC_VD0_INT_CLR;
>+              break;
>+      /* VD1 interrrupt */
>+      case INT_35XX_CCDC_VD1_IRQ:
>+              vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD1_INT_CLR;
>+              vpfe_int_clr |= AM35XX_VPFE_CCDC_VD1_INT_CLR;
>+              break;
>+      /* VD2 interrrupt */
>+      case INT_35XX_CCDC_VD2_IRQ:
>+              vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD2_INT_CLR;
>+              vpfe_int_clr |= AM35XX_VPFE_CCDC_VD2_INT_CLR;
>+              break;
>+      /* Clear all interrrupts */
>+      default:
>+              vpfe_int_clr &= ~(AM35XX_VPFE_CCDC_VD0_INT_CLR |
>+                              AM35XX_VPFE_CCDC_VD1_INT_CLR |
>+                              AM35XX_VPFE_CCDC_VD2_INT_CLR);
>+              vpfe_int_clr |= (AM35XX_VPFE_CCDC_VD0_INT_CLR |
>+                              AM35XX_VPFE_CCDC_VD1_INT_CLR |
>+                              AM35XX_VPFE_CCDC_VD2_INT_CLR);
>+              break;
>+      }
>+      omap_ctrl_writel(vpfe_int_clr, AM35XX_CONTROL_LVL_INTR_CLEAR);
>+      vpfe_int_clr = omap_ctrl_readl(AM35XX_CONTROL_LVL_INTR_CLEAR);
>+}
>+
>+static struct vpfe_config vpfe_cfg = {
>+      .num_subdevs    = ARRAY_SIZE(vpfe_sub_devs),
>+      .i2c_adapter_id = 3,
>+      .sub_devs       = vpfe_sub_devs,
>+      .clr_intr       = am3517_evm_clear_vpfe_intr,
>+      .card_name      = "DM6446 EVM",

>>[MK] You might want to change the card name to match with what you are using.
>> This is what user will see in querycap and should reflect the correct name IMO.

Opps. It should have been Copy-Paste error.

Thanks for pointing me to this. Will change and submit it.

>+      .ccdc           = "DM6446 CCDC",
>+};
>+
>+static struct resource vpfe_resources[] = {
>+      {
>+              .start  = INT_35XX_CCDC_VD0_IRQ,
>+              .end    = INT_35XX_CCDC_VD0_IRQ,
>+              .flags  = IORESOURCE_IRQ,
>+      },
>+      {
>+              .start  = INT_35XX_CCDC_VD1_IRQ,
>+              .end    = INT_35XX_CCDC_VD1_IRQ,
>+              .flags  = IORESOURCE_IRQ,
>+      },
>+};
>+
>+static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>+static struct platform_device vpfe_capture_dev = {
>+      .name           = CAPTURE_DRV_NAME,
>+      .id             = -1,
>+      .num_resources  = ARRAY_SIZE(vpfe_resources),
>+      .resource       = vpfe_resources,
>+      .dev = {
>+              .dma_mask               = &vpfe_capture_dma_mask,
>+              .coherent_dma_mask      = DMA_BIT_MASK(32),
>+              .platform_data          = &vpfe_cfg,
>+      },
>+};
>+
>+static struct resource dm644x_ccdc_resource[] = {
>+      /* CCDC Base address */
>+      {
>+              .start  = AM35XX_IPSS_VPFE_BASE,
>+              .end    = AM35XX_IPSS_VPFE_BASE + 0xffff,
>+              .flags  = IORESOURCE_MEM,
>+      },
>+};

>> [MK] Does it make sense to use am35xx_ccdc_resource[] instead? We know that
>> dm6446 ccdc device is re-used by looking at the device name below, right?
>> I think we also need to think about renaming the dm6446 ccdc device to
>> something generic in the future.

You got me right here. I think there are different ways to look at it. I will change this name for now till the time we do not have generic name for it.

Submitting this alone patch shortly.

Thanks,
Vaibhav

>+
>+static struct platform_device dm644x_ccdc_dev = {
>+      .name           = "dm644x_ccdc",
>+      .id             = -1,
>+      .num_resources  = ARRAY_SIZE(dm644x_ccdc_resource),
>+      .resource       = dm644x_ccdc_resource,
>+      .dev = {
>+              .dma_mask               = &vpfe_capture_dma_mask,
>+              .coherent_dma_mask      = DMA_BIT_MASK(32),
>+      },
>+};
>+
> static struct i2c_board_info __initdata am3517evm_i2c_boardinfo[] = {
>       {
>               I2C_BOARD_INFO("s35390a", 0x30),
>@@ -46,6 +199,7 @@ static struct i2c_board_info __initdata
>am3517evm_i2c_boardinfo[] = {
>       },
> };
>
>+
> /*
>  * RTC - S35390A
>  */
>@@ -261,6 +415,8 @@ static struct omap_board_config_kernel
>am3517_evm_config[] __initdata = {
>
> static struct platform_device *am3517_evm_devices[] __initdata = {
>       &am3517_evm_dss_device,
>+      &dm644x_ccdc_dev,
>+      &vpfe_capture_dev,
> };
>
> static void __init am3517_evm_init_irq(void)
>@@ -313,6 +469,11 @@ static void __init am3517_evm_init(void)
>
>       i2c_register_board_info(1, am3517evm_i2c_boardinfo,
>                               ARRAY_SIZE(am3517evm_i2c_boardinfo));
>+
>+      clk_add_alias("master", "dm644x_ccdc", "master",
>+                      &vpfe_capture_dev.dev);
>+      clk_add_alias("slave", "dm644x_ccdc", "slave",
>+                      &vpfe_capture_dev.dev);
> }
>
> static void __init am3517_evm_map_io(void)
>--
>1.6.2.4

