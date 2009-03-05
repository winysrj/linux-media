Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:35439 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbZCEDKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 22:10:25 -0500
Message-ID: <49AF451B.2040401@windriver.com>
Date: Thu, 05 Mar 2009 11:20:59 +0800
From: "stanley.miao" <stanley.miao@windriver.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH 5/5] LDP: Add support for built-in camera
References: <A24693684029E5489D1D202277BE89442E1D9224@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E1D9224@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre Rodriguez, Sergio Alberto wrote:
> This patch adds support for the LDP builtin camera sensor:
>  - Primary sensor (/dev/video4): OV3640 (CSI2).
>
> It introduces also a new file for storing all camera sensors board
> specific related functions, like other platforms do (N800 for example).
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/Makefile                |    3 +-
>  arch/arm/mach-omap2/board-ldp-camera.c      |  203 +++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-ldp.c             |   17 +++
>  arch/arm/plat-omap/include/mach/board-ldp.h |    1 +
>  4 files changed, 223 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-ldp-camera.c
>
> <snip>
> diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
> index 1e1fd84..513aa8f 100644
> --- a/arch/arm/mach-omap2/board-ldp.c
> +++ b/arch/arm/mach-omap2/board-ldp.c
> @@ -47,6 +47,13 @@
>  #define SDP3430_SMC91X_CS	3
>  #define CONFIG_DISABLE_HFCLK 1
>  
> +#include <media/v4l2-int-device.h>
> +
> +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> +#include <media/ov3640.h>
> +extern struct ov3640_platform_data ldp_ov3640_platform_data;
> +#endif
> +
>  #define ENABLE_VAUX1_DEDICATED	0x03
>  #define ENABLE_VAUX1_DEV_GRP	0x20
>  
> @@ -496,6 +503,15 @@ static struct i2c_board_info __initdata ldp_i2c_boardinfo[] = {
>  	},
>  };
>  
> +static struct i2c_board_info __initdata ldp_i2c_boardinfo_2[] = {
> +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> +	{
> +		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> +		.platform_data = &ldp_ov3640_platform_data,
> +	},
> +#endif
> +};
>   
This new added i2c_board_info was not registered.
After I added this line,

omap_register_i2c_bus(2, 400, ldp_i2c_boardinfo_2,
                        ARRAY_SIZE(ldp_i2c_boardinfo_2));

the sensor was found. but the test still failed. A lot of error came out 
when I run my test program.

<3>CSI2: ComplexIO Error IRQ 80
CSI2: ComplexIO Error IRQ 80
<3>CSI2: ComplexIO Error IRQ c2
CSI2: ComplexIO Error IRQ c2
<3>CSI2: ComplexIO Error IRQ c2
CSI2: ComplexIO Error IRQ c2
<3>CSI2: ComplexIO Error IRQ c6
CSI2: ComplexIO Error IRQ c6
<3>CSI2: ECC correction failed
CSI2: ECC correction failed
<3>CSI2: ComplexIO Error IRQ 6
CSI2: ComplexIO Error IRQ 6
<3>CSI2: ComplexIO Error IRQ 6
CSI2: ComplexIO Error IRQ 6
<3>CSI2: ComplexIO Error IRQ 6
CSI2: ComplexIO Error IRQ 6
<3>CSI2: ComplexIO Error IRQ 6
CSI2: ComplexIO Error IRQ 6


Stanley.
> +
>  static int __init omap_i2c_init(void)
>  {
>  	omap_register_i2c_bus(1, 2600, ldp_i2c_boardinfo,
> @@ -530,6 +546,7 @@ static void __init omap_ldp_init(void)
>  	omap_serial_init();
>  	usb_musb_init();
>  	twl4030_mmc_init(mmc);
> +	ldp_cam_init();
>  }
>  
>  static void __init omap_ldp_map_io(void)
> diff --git a/arch/arm/plat-omap/include/mach/board-ldp.h b/arch/arm/plat-omap/include/mach/board-ldp.h
> index f233996..8e5d90b 100644
> --- a/arch/arm/plat-omap/include/mach/board-ldp.h
> +++ b/arch/arm/plat-omap/include/mach/board-ldp.h
> @@ -30,6 +30,7 @@
>  #define __ASM_ARCH_OMAP_LDP_H
>  
>  extern void twl4030_bci_battery_init(void);
> +extern void ldp_cam_init(void);
>  
>  #define TWL4030_IRQNUM		INT_34XX_SYS_NIRQ
>  #define LDP_SMC911X_CS         1
>   

