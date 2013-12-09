Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56158 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab3LINK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 08:10:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp device tree support
Date: Mon, 09 Dec 2013 14:11:06 +0100
Message-ID: <99045482.9AfPL8T2Si@avalon>
In-Reply-To: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Friday 06 December 2013 11:13:50 Enrico wrote:
> Hi,
> 
> i know there is some work going on for omap3isp device tree support,
> but right now is it possible to enable it in some other way in a DT
> kernel?
> 
> I've tried enabling it in board-generic.c (omap3_init_camera(...) with
> proper platform data) but it hangs early at boot, do someone know if
> it's possible and how to do it?

Here's what I currently use to test the mt9v032 driver on my Beagleboard-xM
with a mainline kernel. If you need proper regulators support it will get more
complex.

commit 9184392db932be81ea9d33080c1740c3a20f5132
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Mon Jun 20 13:21:17 2011 +0200

    board-omap3beagle: Add support for the MT9V034 sensor module
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 1f25f3e..8bc8695 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -239,7 +239,8 @@ obj-$(CONFIG_SOC_OMAP2420)		+= msdi.o
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o pdata-quirks.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
 obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
-obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o
+obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
+					   board-omap3beagle-camera.o
 obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o
 obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o
 obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o
diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c b/arch/arm/mach-omap2/board-omap3beagle-camera.c
new file mode 100644
index 0000000..c927c23
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
@@ -0,0 +1,93 @@
+/*
+ * arch/arm/mach-omap2/board-omap3beagle-camera.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/mach-types.h>
+#include <linux/clk.h>
+#include <linux/i2c.h>
+#include <linux/regulator/fixed.h>
+#include <linux/regulator/machine.h>
+#include <plat/cpu.h>
+#include <plat/i2c.h>
+
+#include <media/mt9v032.h>
+#include <media/omap3isp.h>
+
+#include "devices.h"
+
+#define MT9V034_RESET_GPIO	98
+
+static struct regulator_consumer_supply mt9v034_dummy_supplies[] = {
+	REGULATOR_SUPPLY("vaa", "3-0048"),
+	REGULATOR_SUPPLY("vdd", "3-0048"),
+	REGULATOR_SUPPLY("vdd_io", "3-0048"),
+};
+
+static const s64 mt9v034_link_freqs[] = {
+	13000000,
+	26600000,
+	27000000,
+	0,
+};
+
+static struct mt9v032_platform_data beagle_mt9v034_platform_data = {
+	.clk_pol	= 0,
+	.link_freqs	= mt9v034_link_freqs,
+	.link_def_freq	= 26600000,
+};
+
+static struct i2c_board_info mt9v034_camera_i2c_device = {
+	I2C_BOARD_INFO("mt9v034", 0x48),
+	.platform_data = &beagle_mt9v034_platform_data,
+};
+
+static struct isp_subdev_i2c_board_info mt9v034_camera_subdevs[] = {
+	{
+		.board_info = &mt9v034_camera_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
+	{
+		.subdevs = mt9v034_camera_subdevs,
+		.interface = ISP_INTERFACE_PARALLEL,
+		.bus = {
+			.parallel = {
+				.data_lane_shift = ISP_LANE_SHIFT_2,
+				.clk_pol = 0,
+			}
+		},
+	},
+	{ },
+};
+
+static struct isp_platform_data beagle_isp_platform_data = {
+	.xclks = {
+		[0] = {
+			.dev_id = "3-0048",
+		},
+	},
+	.subdevs = beagle_camera_subdevs,
+};
+
+static int __init beagle_camera_init(void)
+{
+	if (!of_machine_is_compatible("ti,omap3-beagle-xm"))
+		return 0;
+
+	clk_add_alias(NULL, "3-0048", "cam_xclka", NULL);
+
+	regulator_register_fixed(0, mt9v034_dummy_supplies,
+				 ARRAY_SIZE(mt9v034_dummy_supplies));
+
+	omap3_init_camera(&beagle_isp_platform_data);
+
+	return 0;
+}
+late_initcall(beagle_camera_init);

-- 
Regards,

Laurent Pinchart

