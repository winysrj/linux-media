Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44304 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaKRLl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 06:41:26 -0500
Received: by mail-ie0-f172.google.com with SMTP id ar1so9163110iec.17
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 03:41:25 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 18 Nov 2014 12:41:25 +0100
Message-ID: <CAPW4HR0_KjAdDESvmZ5O6uq6yVW=g_aBz4CHvsgbTSsw8viFqQ@mail.gmail.com>
Subject: MT9V034 sensor in OMAP3 ISP (IGEPv2 board)
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have one question about capture with the OMAP3ISP.
I'm trying to capture images with the MT0V034 sensor included in the
IGEP Cam Bird with the IGEPv2 board. I'm using the 3.17 mainline
kernel with some modifications to register the sensor and configure
the pin muxes.
The sensor is registering correctly and I can configure the media
pipeline, but when I try to capture with Yavta all the system freezes
when Yavta try to queue the buffers, then the sensor is throwing data
by the parallel port, I can see this, but ISP seems don't get nothing.

This is the patch I wrote for this:

diff --git a/arch/arm/boot/dts/omap3-igep.dtsi
b/arch/arm/boot/dts/omap3-igep.dtsi
index e2d163b..a184af9 100644
--- a/arch/arm/boot/dts/omap3-igep.dtsi
+++ b/arch/arm/boot/dts/omap3-igep.dtsi
@@ -159,7 +159,7 @@
 &i2c2 {
        pinctrl-names = "default";
        pinctrl-0 = <&i2c2_pins>;
-       clock-frequency = <400000>;
+       clock-frequency = <50000>;
 };

 &i2c3 {
diff --git a/arch/arm/boot/dts/omap3-igep0020.dts
b/arch/arm/boot/dts/omap3-igep0020.dts
index b22caaa..47128b2 100644
--- a/arch/arm/boot/dts/omap3-igep0020.dts
+++ b/arch/arm/boot/dts/omap3-igep0020.dts
@@ -109,6 +109,7 @@
        pinctrl-0 = <
                &tfp410_pins
                &dss_dpi_pins
+                &cam_pins
        >;

        tfp410_pins: pinmux_tfp410_pins {
@@ -117,6 +118,31 @@
                >;
        };

+        cam_pins: pinmux_cam_pins {
+                pinctrl-single,pins = <
+                        OMAP3_CORE1_IOPAD(0x210c, PIN_INPUT |
MUX_MODE0)  /* cam_hs.cam_hs */
+                        OMAP3_CORE1_IOPAD(0x210e, PIN_INPUT |
MUX_MODE0)  /* cam_vs.cam_vs */
+                        OMAP3_CORE1_IOPAD(0x2110, PIN_OUTPUT|
MUX_MODE0)  /* cam_xclka.cam_xclka */
+                        OMAP3_CORE1_IOPAD(0x2112, PIN_INPUT |
MUX_MODE0)  /* cam_pclk.cam_pclk */
+                        OMAP3_CORE1_IOPAD(0x2114, PIN_INPUT |
MUX_MODE4)  /* cam_fld.gpio98 */
+                        OMAP3_CORE1_IOPAD(0x2116, PIN_INPUT |
MUX_MODE0)  /* cam_d0.cam_d0 */
+                        OMAP3_CORE1_IOPAD(0x2118, PIN_INPUT |
MUX_MODE0)  /* cam_d1.cam_d1 */
+                        OMAP3_CORE1_IOPAD(0x211a, PIN_INPUT |
MUX_MODE0)  /* cam_d2.cam_d2 */
+                        OMAP3_CORE1_IOPAD(0x211c, PIN_INPUT |
MUX_MODE0)  /* cam_d3.cam_d3 */
+                        OMAP3_CORE1_IOPAD(0x211e, PIN_INPUT |
MUX_MODE0)  /* cam_d4.cam_d4 */
+                        OMAP3_CORE1_IOPAD(0x2120, PIN_INPUT |
MUX_MODE0)  /* cam_d5.cam_d5 */
+                        OMAP3_CORE1_IOPAD(0x2122, PIN_INPUT |
MUX_MODE0)  /* cam_d6.cam_d6 */
+                        OMAP3_CORE1_IOPAD(0x2124, PIN_INPUT |
MUX_MODE0)  /* cam_d7.cam_d7 */
+                        OMAP3_CORE1_IOPAD(0x2126, PIN_INPUT |
MUX_MODE0)  /* cam_d8.cam_d8 */
+                        OMAP3_CORE1_IOPAD(0x2128, PIN_INPUT |
MUX_MODE0)  /* cam_d9.cam_d9 */
+                        OMAP3_CORE1_IOPAD(0x212a, PIN_INPUT |
MUX_MODE0)  /* cam_d10.cam_d10 */
+                        OMAP3_CORE1_IOPAD(0x212c, PIN_INPUT |
MUX_MODE0)  /* cam_d11.cam_d11 */
+                        OMAP3_CORE1_IOPAD(0x212e, PIN_INPUT |
MUX_MODE4)  /* cam_xclkb.gpio111 */
+                        OMAP3_CORE1_IOPAD(0x2130, PIN_INPUT |
MUX_MODE0)  /* cam_wen.cam_wen */
+                        OMAP3_CORE1_IOPAD(0x2132, PIN_INPUT |
MUX_MODE0)  /* cam_strobe.cam_strobe */
+                >;
+        };
+
        dss_dpi_pins: pinmux_dss_dpi_pins {
                pinctrl-single,pins = <
                        0x0a4 (PIN_OUTPUT | MUX_MODE0)   /* dss_pclk.dss_pclk */
diff --git a/arch/arm/mach-omap2/pdata-quirks.c
b/arch/arm/mach-omap2/pdata-quirks.c
index c95346c..cf4bd2d 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -10,17 +10,25 @@
 #include <linux/clk.h>
 #include <linux/davinci_emac.h>
 #include <linux/gpio.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
+#include <linux/regulator/fixed.h>
+#include <linux/regulator/machine.h>
 #include <linux/wl12xx.h>

+#include <media/mt9v032.h>
+#include <media/omap3isp.h>
+
 #include <linux/platform_data/pinctrl-single.h>
 #include <linux/platform_data/iommu-omap.h>

 #include "am35xx.h"
 #include "common.h"
 #include "common-board-devices.h"
+#include "devices.h"
 #include "dss-common.h"
 #include "control.h"
 #include "omap_device.h"
@@ -35,6 +42,61 @@ struct pdata_init {
 struct of_dev_auxdata omap_auxdata_lookup[];
 static struct twl4030_gpio_platform_data twl_gpio_auxdata;

+static struct regulator_consumer_supply igep00x0_dummy_supplies[] = {
+       REGULATOR_SUPPLY("vaa", "1-005c"),
+};
+
+static const s64 mt9v032_link_freqs[] = {
+        13000000,
+        26600000,
+        27000000,
+        0,
+};
+
+static struct mt9v032_platform_data mt9v032_pdata = {
+        .link_freqs     = mt9v032_link_freqs,
+        .link_def_freq  = 13000000,
+};
+
+static struct i2c_board_info mt9v032_i2c_device = {
+        I2C_BOARD_INFO("mt9v032", 0xb8 >> 1),
+        .platform_data = &mt9v032_pdata,
+};
+
+static struct isp_subdev_i2c_board_info mt9v032_board_info[] = {
+        {
+                .board_info = &mt9v032_i2c_device,
+                .i2c_adapter_id = 1,
+        },
+        { NULL, 0, },
+};
+
+
+static struct isp_v4l2_subdevs_group igep00x0_camera_subdevs[] = {
+       {
+               .subdevs = mt9v032_board_info,
+               .interface = ISP_INTERFACE_PARALLEL,
+               .bus = {
+                       .parallel = {
+                               .data_lane_shift = ISP_LANE_SHIFT_0,
+                               /* Sample on falling edge */
+                               .clk_pol = 1,
+                       }
+               },
+       },
+       { },
+};
+
+static struct isp_platform_data igep00x0_isp_pdata = {
+       .xclks = {
+               [0] = {
+                       .dev_id = "1-005c",
+               },
+       },
+        .subdevs = igep00x0_camera_subdevs,
+};
+
+
 #if IS_ENABLED(CONFIG_WL12XX)

 static struct wl12xx_platform_data wl12xx __initdata;
@@ -141,6 +203,12 @@ static void __init omap3_sbc_t3530_legacy_init(void)

 static void __init omap3_igep0020_legacy_init(void)
 {
+       clk_add_alias(NULL, "1-005c", "cam_xclka", NULL);
+
+       regulator_register_fixed(0, igep00x0_dummy_supplies,
+                           ARRAY_SIZE(igep00x0_dummy_supplies));
+
+       omap3_init_camera(&igep00x0_isp_pdata);
 }

And in runtime I test with this pipeline:

Media controller API version 0.0.0



Media device information

------------------------

driver          omap3isp

model           TI OMAP3 ISP

serial

bus info

hw revision     0xf0

driver version  0.0.0



Device topology

- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)

            type V4L2 subdev subtype Unknown flags 0

            device node name /dev/v4l-subdev0

                pad0: Sink

                               [fmt:SGRBG10/4096x4096]

                               <- "OMAP3 ISP CCP2 input":0 []

                pad1: Source

                               [fmt:SGRBG10/4096x4096]

                               -> "OMAP3 ISP CCDC":0 []



- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)

            type Node subtype V4L flags 0

            device node name /dev/video0

                pad0: Source

                               -> "OMAP3 ISP CCP2":0 []



- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)

            type V4L2 subdev subtype Unknown flags 0

            device node name /dev/v4l-subdev1

                pad0: Sink

                               [fmt:SGRBG10/4096x4096]

                pad1: Source

                               [fmt:SGRBG10/4096x4096]

                               -> "OMAP3 ISP CSI2a output":0 []

                               -> "OMAP3 ISP CCDC":0 []



- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)

            type Node subtype V4L flags 0

            device node name /dev/video1

                pad0: Sink

                               <- "OMAP3 ISP CSI2a":1 []



- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)

            type V4L2 subdev subtype Unknown flags 0

            device node name /dev/v4l-subdev2

                pad0: Sink

                               [fmt:SGRBG10/752x480]

                               <- "OMAP3 ISP CCP2":1 []

                               <- "OMAP3 ISP CSI2a":1 []

                               <- "mt9v032 1-005c":0 [ENABLED]

                pad1: Source

                               [fmt:SGRBG10/752x480

                                crop.bounds:(0,0)/752x480

                                crop:(0,0)/752x480]

                               -> "OMAP3 ISP CCDC output":0 []

                               -> "OMAP3 ISP resizer":0 []

                pad2: Source

                               [fmt:SGRBG10/752x479]

                               -> "OMAP3 ISP preview":0 [ENABLED]

                               -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]

                               -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]

                               -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]



- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)

            type Node subtype V4L flags 0

            device node name /dev/video2

                pad0: Sink

                               <- "OMAP3 ISP CCDC":1 []



- entity 7: OMAP3 ISP preview (2 pads, 4 links)

            type V4L2 subdev subtype Unknown flags 0

            device node name /dev/v4l-subdev3

                pad0: Sink

                               [fmt:SGRBG10/752x479

                                crop.bounds:(10,4)/734x471

                                crop:(10,4)/734x471]

                               <- "OMAP3 ISP CCDC":2 [ENABLED]

                               <- "OMAP3 ISP preview input":0 []

                pad1: Source

                               [fmt:UYVY/734x471]

                               -> "OMAP3 ISP preview output":0 [ENABLED]

                               -> "OMAP3 ISP resizer":0 []



- entity 8: OMAP3 ISP preview input (1 pad, 1 link)

            type Node subtype V4L flags 0

            device node name /dev/video3

                pad0: Source

                               -> "OMAP3 ISP preview":0 []



- entity 9: OMAP3 ISP preview output (1 pad, 1 link)

            type Node subtype V4L flags 0

            device node name /dev/video4

                pad0: Sink

                               <- "OMAP3 ISP preview":1 [ENABLED]



- entity 10: OMAP3 ISP resizer (2 pads, 4 links)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev4

                pad0: Sink

                               [fmt:YUYV/4095x4095

                                crop.bounds:(4,6)/4086x4082

                                crop:(4,6)/4086x4082]

                               <- "OMAP3 ISP CCDC":1 []

                               <- "OMAP3 ISP preview":1 []

                               <- "OMAP3 ISP resizer input":0 []

                pad1: Source

                               [fmt:YUYV/4096x4095]

                               -> "OMAP3 ISP resizer output":0 []



- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)

             type Node subtype V4L flags 0

             device node name /dev/video5

                pad0: Source

                               -> "OMAP3 ISP resizer":0 []



- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)

             type Node subtype V4L flags 1

             device node name /dev/video6

                pad0: Sink

                               <- "OMAP3 ISP resizer":1 []



- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev5

                pad0: Sink

                               <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]



- entity 14: OMAP3 ISP AF (1 pad, 1 link)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev6

                pad0: Sink

                               <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]



- entity 15: OMAP3 ISP histogram (1 pad, 1 link)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev7

                pad0: Sink

                               <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]



- entity 16: mt9v032 1-005c (1 pad, 1 link)

             type V4L2 subdev subtype Unknown flags 0

             device node name /dev/v4l-subdev8

                pad0: Source

                               [fmt:SGRBG10/752x480

                                crop:(1,5)/752x480]

                               -> "OMAP3 ISP CCDC":0 [ENABLED]

Have you some idea about what is not working? I think it's something
in OMAP3 ISP but I can't find the reason.

Thanks,

Carlos S.
