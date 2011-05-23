Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1EWHZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 03:25:02 -0400
MIME-Version: 1.0
In-Reply-To: <4DD9146B.2050408@compulab.co.il>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com>
	<1305899272-31839-2-git-send-email-javier.martin@vista-silicon.com>
	<4DD9146B.2050408@compulab.co.il>
Date: Mon, 23 May 2011 09:25:01 +0200
Message-ID: <BANLkTi=sqZpAKFxeCbwqpU_7+WZABGa4=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-media@vger.kernel.org, beagleboard@googlegroups.com,
	carlighting@yahoo.co.nz, g.liakhovetski@gmx.de,
	linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 22 May 2011 15:49, Igor Grinberg <grinberg@compulab.co.il> wrote:
> Hi Javier,
>
>
> linux-omap should be CC'ed - added.
>
> In addition to Koen's comments, some comments below.
>
>
> On 05/20/11 16:47, Javier Martin wrote:
>
>> isp.h file has to be included as a temporal measure
>> since clocks of the isp are not exposed yet.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  arch/arm/mach-omap2/board-omap3beagle.c |  127 ++++++++++++++++++++++++++++++-
>>  1 files changed, 123 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
>> index 33007fd..f52e6ae 100644
>> --- a/arch/arm/mach-omap2/board-omap3beagle.c
>> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
>> @@ -24,15 +24,20 @@
>>  #include <linux/input.h>
>>  #include <linux/gpio_keys.h>
>>  #include <linux/opp.h>
>> +#include <linux/i2c.h>
>> +#include <linux/mm.h>
>> +#include <linux/videodev2.h>
>>
>>  #include <linux/mtd/mtd.h>
>>  #include <linux/mtd/partitions.h>
>>  #include <linux/mtd/nand.h>
>>  #include <linux/mmc/host.h>
>> -
>> +#include <linux/gpio.h>
>
> Why include this for second time?

Good catch, I'll fix it.

[snip]
>> @@ -309,6 +357,15 @@ static int beagle_twl_gpio_setup(struct device *dev,
>>                       pr_err("%s: unable to configure EHCI_nOC\n", __func__);
>>       }
>>
>> +     if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM) {
>> +             /*
>> +              * Power on camera interface - only on pre-production, not
>> +              * needed on production boards
>> +              */
>> +             gpio_request(gpio + 2, "CAM_EN");
>> +             gpio_direction_output(gpio + 2, 1);
>
> Why not gpio_request_one()?

Just to follow the same approach as in the rest of the code.
Maybe a further patch could change all "gpio_request()" uses to
"gpio_request_one()".

>
>> +     }
>> +
>>       /*
>>        * TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, XM active
>>        * high / others active low)
>> @@ -451,6 +508,8 @@ static struct twl4030_platform_data beagle_twldata = {
>>       .vsim           = &beagle_vsim,
>>       .vdac           = &beagle_vdac,
>>       .vpll2          = &beagle_vpll2,
>> +     .vaux3          = &beagle_vaux3,
>> +     .vaux4          = &beagle_vaux4,
>>  };
>>
>>  static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
>> @@ -463,15 +522,16 @@ static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
>>  };
>>
>>  static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
>> -       {
>> -               I2C_BOARD_INFO("eeprom", 0x50),
>> -       },
>> +     {
>> +             I2C_BOARD_INFO("eeprom", 0x50),
>> +     },
>>  };
>
> This part of the hunk is not related to the patch
> and should be in a separate (cleanup) patch.
>

Sure, I'll fix it.

>>
>>  static int __init omap3_beagle_i2c_init(void)
>>  {
>>       omap_register_i2c_bus(1, 2600, beagle_i2c_boardinfo,
>>                       ARRAY_SIZE(beagle_i2c_boardinfo));
>> +     omap_register_i2c_bus(2, 100, NULL, 0); /* Enable I2C2 for camera */
>>       /* Bus 3 is attached to the DVI port where devices like the pico DLP
>>        * projector don't work reliably with 400kHz */
>>       omap_register_i2c_bus(3, 100, beagle_i2c_eeprom, ARRAY_SIZE(beagle_i2c_eeprom));
>> @@ -654,6 +714,60 @@ static void __init beagle_opp_init(void)
>>       return;
>>  }
>>
>> +static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
>> +{
>> +     struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
>> +     int ret;
>> +
>> +     ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
>> +     return 0;
>> +}
>
> Why do you need ret variable here, if you always return zero?
>

You are right, it's not needed any longer.


>> +
>> +static int beagle_cam_reset(struct v4l2_subdev *subdev, int active)
>> +{
>> +     /* Set RESET_BAR to !active */
>> +     gpio_set_value(MT9P031_RESET_GPIO, !active);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct mt9p031_platform_data beagle_mt9p031_platform_data = {
>> +     .set_xclk               = beagle_cam_set_xclk,
>> +     .reset                  = beagle_cam_reset,
>> +};
>> +
>> +static struct i2c_board_info mt9p031_camera_i2c_device = {
>> +     I2C_BOARD_INFO("mt9p031", 0x48),
>> +     .platform_data = &beagle_mt9p031_platform_data,
>> +};
>> +
>> +static struct isp_subdev_i2c_board_info mt9p031_camera_subdevs[] = {
>> +     {
>> +             .board_info = &mt9p031_camera_i2c_device,
>> +             .i2c_adapter_id = 2,
>> +     },
>> +     { NULL, 0, },
>> +};
>> +
>> +static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
>> +     {
>> +             .subdevs = mt9p031_camera_subdevs,
>> +             .interface = ISP_INTERFACE_PARALLEL,
>> +             .bus = {
>> +                     .parallel = {
>> +                             .data_lane_shift = 0,
>> +                             .clk_pol = 1,
>> +                             .bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
>> +                     }
>> +             },
>> +     },
>> +     { },
>> +};
>> +
>> +static struct isp_platform_data beagle_isp_platform_data = {
>> +     .subdevs = beagle_camera_subdevs,
>> +};
>> +
>>  static void __init omap3_beagle_init(void)
>>  {
>>       omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>> @@ -679,6 +793,11 @@ static void __init omap3_beagle_init(void)
>>
>>       beagle_display_init();
>>       beagle_opp_init();
>> +
>> +     /* Enable camera */
>> +     gpio_request(MT9P031_RESET_GPIO, "cam_rst");
>> +     gpio_direction_output(MT9P031_RESET_GPIO, 0);
>
> gpio_request_one()?

ditto

>> +     omap3_init_camera(&beagle_isp_platform_data);
>>  }
>>
>>  MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
>
>
>
> --
> Regards,
> Igor.
>
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
