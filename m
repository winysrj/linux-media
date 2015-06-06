Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52604 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbbFFGYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 02:24:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Allwright <michael.allwright@upb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tero Kristo <t-kristo@ti.com>
Subject: Re: [RFC] v4l: omap4iss: DT bindings development
Date: Sat, 06 Jun 2015 06:01:52 +0300
Message-ID: <1908360.UcyYMlCq0t@avalon>
In-Reply-To: <CALcgO_7uZae-PE4QjZsfVKW59bhme3vjjfYfu5GJPVsJD61J7Q@mail.gmail.com>
References: <CALcgO_6mcTpEORqWMVzPONYHZH-h8bBMDMddkKxSyrc7F3-oiQ@mail.gmail.com> <5806279.gupgOqozEz@avalon> <CALcgO_7uZae-PE4QjZsfVKW59bhme3vjjfYfu5GJPVsJD61J7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2448378.QancbLChQg"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2448378.QancbLChQg
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Michael,

On Thursday 04 June 2015 16:56:47 Michael Allwright wrote:
> Thank you for the replies. Laurent I have started using the platform
> data to see if I can determine whether I have a software problem or a
> hardware problem. One thing that is confusing me, is how are memory
> resources are supposed to be properly mapped to a kernel module in a
> DT enabled kernel using the hwmod abstraction layer.
> 
> It seems that the omap4iss driver in the mainline is expecting
> resources to be declared in the format that was changed around about
> this commit:
> https://www.gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/8304f1
> 3d002dfaf618473a551dbbc35cfcdc2742
> 
> In the driver in the mainline, these resources are acquired in the
> probe function by this loop here from iss.c:1397
> for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) { ret =
> iss_map_mem_resource(pdev, iss, i); if (ret) goto error_iss; }
> 
> However the definitions of these registers have completely disappeared
> in the mainline, nor are they in the master branches of linux-media or
> linux-omap (see arch/arm/mach-omap2/devices.c / h). Interesting enough
> the definitions for the OMAP3 ISP are still there. Furthermore looking
> at the omap_hwmod_44xx_data.c in these branches I can see the hwmod
> layer is only declaring the first 0xff bytes of address space starting
> at 0x52000000, this obviously doesn't include the CSIA/B registers nor
> the CAMERARX registers which are all at addresses >0x520000ff.
> 
> TLDR: omap4iss seems somewhat broken in the mainline (3.17),
> linux-media (master) and linux-omap (master), which repo/branch are
> you using for testing? Or what happened to the omap4_iss_resources
> array?

I've mostly been using a TI v3.4 BSP to which I've backported the mainline 
driver. The iss hwmod is indeed broken in mainline.

The two attached patches should help for testing the ISS driver with platform 
data. As we're moving to DT it's probably not worth it pushing them to 
mainline.

I used the following board code when developing a driver for the Aptina AR0330 
used with a Panda board. That was quite a long time ago, I never managed to 
get it fully working and had to move to different projects. The code might 
thus not even compile.

#include <linux/gpio.h>
#include <linux/clk.h>
#include <linux/delay.h>

#include <plat/i2c.h>
#include <plat/omap-pm.h>

#include <asm/mach-types.h>

#include <media/ar0330.h>

#include "devices.h"
#include "../../../drivers/media/video/omap4iss/iss.h"

#include "control.h"
#include "mux.h"

#define PANDA_GPIO_CAM_RESET		83

#define AR0330_I2C_ADDRESS   		0x10

static struct ar0330_platform_data panda_ar0330_data = {
};

static struct i2c_board_info panda_camera_i2c_device = {
	I2C_BOARD_INFO("ar0330", AR0330_I2C_ADDRESS),
	.platform_data = &ar0330_platform_data,
};

static struct iss_subdev_i2c_board_info panda_ar0330_subdevs[] = {
	{
		.board_info = &panda_camera_i2c_device,
		.i2c_adapter_id = 3,
	},
	{ NULL, 0, },
};

static struct iss_v4l2_subdevs_group panda_camera_subdevs[] = {
	{
		.subdevs = panda_ar0330_subdevs,
		.interface = ISS_INTERFACE_CSI2A_PHY1,
		.bus = { .csi2 = {
			.lanecfg	= {
				.clk = {
					.pol = 0,
					.pos = 2,
				},
				.data[0] = {
					.pol = 0,
					.pos = 1,
				},
				.data[1] = {
					.pol = 0,
					.pos = 3,
				},
			},
		} },
	},
	{ },
};

static void panda_omap4iss_set_constraints(struct iss_device *iss, bool 
enable)
{
	if (!iss)
		return;

	/* FIXME: Look for something more precise as a good throughtput limit */
	omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
				 enable ? 800000 : -1);
}

static struct iss_platform_data panda_iss_platform_data = {
	.subdevs = panda_camera_subdevs,
	.set_constraints = panda_omap4iss_set_constraints,
};

static struct omap_device_pad omap4iss_pads[] = {
	{
		.name   = "csi21_dx0.csi21_dx0",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
	{
		.name   = "csi21_dy0.csi21_dy0",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
	{
		.name   = "csi21_dx1.csi21_dx1",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
	{
		.name   = "csi21_dy1.csi21_dy1",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
	{
		.name   = "csi21_dx2.csi21_dx2",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
	{
		.name   = "csi21_dy2.csi21_dy2",
		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
	},
};

static struct omap_board_data omap4iss_data = {
	.id	    		= 1,
	.pads	 		= omap4iss_pads,
	.pads_cnt       	= ARRAY_SIZE(omap4iss_pads),
};

static int __init panda_camera_init(void)
{
	struct clk *clk;

	if (!machine_is_omap4_panda())
		return 0;

	clk = clk_get(NULL, "auxclk1_ck");
	if (IS_ERR(clk)) {
		printk(KERN_ERR "Unable to get auxclk1_ck\n");
		return -ENODEV;
	}

	panda_ar0330_data.clock = clk;

	/* Select GPIO 83 */
	omap_mux_init_gpio(PANDA_GPIO_CAM_RESET, OMAP_PIN_OUTPUT);

	/* Init FREF_CLK1_OUT */
	omap_mux_init_signal("fref_clk1_out", OMAP_PIN_OUTPUT);

	if (gpio_request_one(PANDA_GPIO_CAM_RESET, GPIOF_OUT_INIT_HIGH,
			     "CAM_RESET"))
		printk(KERN_WARNING "Cannot request GPIO %d\n",
		       PANDA_GPIO_CAM_RESET);

	panda_ar0330_data.reset = PANDA_GPIO_CAM_RESET;

	return omap4_init_camera(&panda_iss_platform_data, &omap4iss_data);
}
late_initcall(panda_camera_init);


> On 2 June 2015 at 18:22, Laurent Pinchart wrote:
> > On Tuesday 02 June 2015 09:12:25 Tony Lindgren wrote:
> >> * Michael Allwright <michael.allwright@upb.de> [150602 01:41]:
> >> > Hi Everyone,
> >> > 
> >> > I'm working on the DT bindings for the OMAP4 ISS at the moment, but I
> >> > am unable to capture any data in my test setup. As detailed below, it
> >> > seems that everything has been configured correctly however I never
> >> > get any interrupts from the ISS unless I do something drastic like
> >> > removing one of the wires from the clock differential pair which
> >> > results in constant complex IO error interrupts from CSIA until I
> >> > restore the physical connection.
> >> > 
> >> > My test setup includes a OV6540 sensor camera module (MIPI) from
> >> > Lepoard Imaging, an Duovero COM from Gumstix and breakout boards
> >> > forming an interconnect between the two. The sensor is connected to
> >> > CSI21 on the OMAP4 using a clock lane (on position 1, default
> >> > polarity) and a single data lane (on position 2, default polarity),
> >> > the sensor input clock XVCLK uses the OMAP4 auxclk1_ck channel (rounds
> >> > to 19.2MHz when asked for 24MHz).
> >> > 
> >> > The relevant parts of my device tree can be seen here:
> >> > https://gist.github.com/allsey87/fdf1feb6eb6a94158638 - I'm actually
> >> > somewhat unclear what effect stating the ti,hwmod="iss" parameter has.
> >> > Does anything else need to be done here? As far as I can tell I think
> >> > all clocks and power has been switched on. I do make two function
> >> > calls to the PM API in the ISS probe function, i.e.:
> >> > 
> >> > pm_runtime_enable(&pdev->dev);
> >> > r = pm_runtime_get_sync(&pdev->dev);
> >> 
> >> The ti,hwmod = "iss" hooks up the device with the PM runtime, see
> >> omap_hwmod_44xx_data.c for "iss".
> >> 
> >> > Regarding my debugging, this is what I have checked so far
> >> > 
> >> > * Changing the pixel rate of the sensor - this lead me to discover a
> >> > possible bug in iss.c or perhaps my ov5640 driver, as the
> >> > V4L2_CID_PIXEL_RATE control was always returning zero. I patched this
> >> > by copying what Laurent has done in the OMAP3ISP driver which now
> >> > works.
> >> > * As I only have a 100MHz scope, I had to slow down the camera
> >> > significantly (MIPI clock => 10-12MHz range) to verify that I was
> >> > getting reasonable output from the sensor (i.e. signals that were
> >> > characteristic of CSI2/MIPI). I checked the calculations and made sure
> >> > these updated values came across via the V4L2_CID_PIXEL_RATE control
> >> > and ended up in the THS_TERM and THS_SETTLE fields of register 0.
> >> > * Using the omapconf tool, I have manually and one by one pulled up
> >> > the CSI2 pins and verified multiple times all connections to the
> >> > sensor module and have even manually tried swapping the DP/DN pairs in
> >> > case they were still somehow backwards despite previous testing
> >> > * Verified that the interrupt service routine is called by generating
> >> > a test interrupt HS_VS from inside the ISS i.e.
> >> > 
> >> > ./omapconf write ISS_HL_IRQENABLE_SET_5 0x00020000
> >> > ./omapconf write ISS_HL_IRQSTATUS_RAW_5 0x00020000
> >> > 
> >> > * Verified that the default CMA region is being used, it ends up in
> >> > the ping-pong resisters of the ISS.
> >> > 
> >> > Additional information:
> >> > 
> >> > * Initialisation of pipe line and stream commands:
> >> > 
> >> > media-ctl -r -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS CSI2a output":0 [1]'
> >> > media-ctl -V '"ov5640 2-003c":0 [UYVY 640x480]','"OMAP4 ISS CSI2a":0
> >> > [UYVY 640x480]'
> >> > yavta /dev/video0 -c4 -n1 -s640x480 -fUYVY -Fov5640-640x480-#.uyvy
> >> > 
> >> > * Output from OMAPCONF tool is in the second part of:
> >> > https://gist.github.com/allsey87/fdf1feb6eb6a94158638
> >> > 
> >> > Anyway, at this point, I'm almost completely out of ideas on how to
> >> > move forwards so any suggestions, criticisms or help of any nature
> >> > would be appreciated!
> >> 
> >> Usually it's pinmuxing or some regulator or clock not enabled. Or
> >> incorrect hwmod sysc and syss configuration for iss that prevents
> >> enabling it properly.
> > 
> > And have you tried the same setup with platform data ?

-- 
Regards,

Laurent Pinchart

--nextPart2448378.QancbLChQg
Content-Disposition: attachment; filename="0001-ARM-OMAP4-hwmod-Enable-ISS.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-ARM-OMAP4-hwmod-Enable-ISS.patch"

>From 05eea18a101240ed9960a99d23b67aba4672b70a Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Wed, 30 Nov 2011 10:19:42 -0600
Subject: [PATCH 1/2] ARM: OMAP4: hwmod: Enable ISS

Add the CSI2A, CSI2B, CSIPHY1, CSIPHY2, ISP SYS1, ISIF, IPIPEIF, IPIPE,
BTE and RESIZER memory sections to the ISS hwmod entry.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 50 ++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 8f0058ef3838..85f2cb55e7d8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -3233,6 +3233,56 @@ static struct omap_hwmod_addr_space omap44xx_iss_addrs[] = {
 		.pa_end		= 0x520000ff,
 		.flags		= ADDR_TYPE_RT
 	},
+	{
+		.pa_start	= 0x52001000,
+		.pa_end		= 0x5200116f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001170,
+		.pa_end		= 0x5200118f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001400,
+		.pa_end		= 0x5200156f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001570,
+		.pa_end		= 0x5200158f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52002000,
+		.pa_end		= 0x520021FF,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52010000,
+		.pa_end		= 0x5201009F,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52010400,
+		.pa_end		= 0x520107FF,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52010800,
+		.pa_end		= 0x52010FFF,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52011000,
+		.pa_end		= 0x520111FF,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52011200,
+		.pa_end		= 0x5201127F,
+		.flags		= ADDR_TYPE_RT
+	},
 	{ }
 };
 
-- 
2.3.6


--nextPart2448378.QancbLChQg
Content-Disposition: attachment; filename="0002-ARM-OMAP4-Add-support-for-the-camera-interface-ISS.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-ARM-OMAP4-Add-support-for-the-camera-interface-ISS.patch"

>From 3bbfd1931f54fb8075fe0b37530fc0e5965b6e82 Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Wed, 25 Jan 2012 01:48:33 -0600
Subject: [PATCH 2/2] ARM: OMAP4: Add support for the camera interface (ISS)

Add an omap4_init_camera() to be used by board files to initialize the
OMAP4 ISS.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c | 40 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/devices.h |  4 ++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index b57116e0b394..e64cc04dc2a0 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -22,7 +22,12 @@
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
 #include <linux/pm_runtime.h>
+#ifdef CONFIG_CMA
+#include <linux/dma-contiguous.h>
+#endif
+
 #include <media/omap3isp.h>
+#include <media/omap4iss.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
@@ -300,6 +305,41 @@ int omap3_init_camera(struct isp_platform_data *pdata)
 
 #endif
 
+int omap4_init_camera(struct iss_platform_data *pdata, struct omap_board_data *bdata)
+{
+	struct platform_device *pdev;
+	struct omap_hwmod *oh;
+	struct iss_platform_data *omap4iss_pdata;
+	const char *oh_name = "iss";
+	const char *name = "omap4iss";
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("Could not look up %s\n", oh_name);
+		return -ENODEV;
+	}
+
+	omap4iss_pdata = pdata;
+
+	pdev = omap_device_build(name, -1, oh, omap4iss_pdata,
+			sizeof(struct iss_platform_data), NULL, 0, 0);
+
+	if (IS_ERR(pdev)) {
+		WARN(1, "Can't build omap_device for %s:%s.\n",
+						name, oh->name);
+		return PTR_ERR(pdev);
+	}
+
+	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
+
+#ifdef CONFIG_CMA
+	/* Create private 32MiB contiguous memory area for omap4iss device */
+	dma_declare_contiguous(&pdev->dev, 32*SZ_1M, 0, 0);
+#endif
+
+	return 0;
+}
+
 static inline void omap_init_camera(void)
 {
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
index f61eb6e5d136..31ba87fb9030 100644
--- a/arch/arm/mach-omap2/devices.h
+++ b/arch/arm/mach-omap2/devices.h
@@ -16,4 +16,8 @@ struct isp_platform_data;
 
 int omap3_init_camera(struct isp_platform_data *pdata);
 
+struct iss_platform_data;
+
+int omap4_init_camera(struct iss_platform_data *pdata,
+			     struct omap_board_data *bdata);
 #endif
-- 
2.3.6


--nextPart2448378.QancbLChQg--

