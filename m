Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03D5FVv004123
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 08:05:15 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.231])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03D43Bx028502
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 08:04:04 -0500
Received: by rv-out-0506.google.com with SMTP id f6so7100250rvb.51
	for <video4linux-list@redhat.com>; Sat, 03 Jan 2009 05:04:02 -0800 (PST)
Message-ID: <f17812d70901030504rf0fcdafmc0e3d51ddcb128e@mail.gmail.com>
Date: Sat, 3 Jan 2009 21:04:02 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20090103104338.6822c576@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
	definitions
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

On Sat, Jan 3, 2009 at 8:43 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Fri, 2 Jan 2009 16:59:36 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
>> On Fri, 2 Jan 2009, Eric Miao wrote:
>>
>> > 1. now pxa_camera.c uses ioremap() for register access, pxa_camera.h is
>> >    totally useless. Remove it.
>> >
>> > 2. <asm/dma.h> does no longer include <mach/dma.h>, include the latter
>> >    file explicitly
>> >
>> > Signed-off-by: Eric Miao <eric.miao@marvell.com>
>>
>> Mauro, it looks like the drivers/media/video/pxa_camera.h part of
>> http://linuxtv.org/hg/~gliakhovetski/v4l-dvb/rev/30773c067724 has been
>> dropped on its way to
>> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed
>>
>> Your hg tree also includes the header hunks, so, it disappeared between
>> your hg tree and the git tree. Looks like you also lost this hunk
>>
>>  #include <asm/arch/camera.h>
>>  #endif
>>
>> -#include "pxa_camera.h"
>> -
>>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
>>
>> so that now registers are defined twice - by including the header and
>> directly in .c. What shall we do now? I presume, we cannot roll back
>> git-tree(s) any more, so, we have to somehow synchronise our hg-trees
>> now. (how much easier this would be in a perfect world without partial
>> hg-trees...)
>
> I had to manually solve some merging conflicts when updating the upstream
> driver. Maybe someone else's patch changed something there and we didn't
> backport the patch. Yet, I always run a script here to check for the
> differences between our tree and Linus one.
>
> Git annotate points this patch as the responsible for adding this header:
>
> 013132ca        ( Eric Miao     2008-11-28 09:16:52 +0800       41)#include "pxa_camera.h"
>
> A today check for differences, pointed the enclosed changes.
>

Apparently, the enclosed changes are not made in a single commit, I
don't know much about 'hg' (I'm wondering why v4l is not using git,
but that's another story), so anything that I can help, please let me
know.

> I think that the better procedure is just to backport those upstream changes
> into -hg. Then, you can write a patch fixing the issues, and I'll send it
> upstream.
>
> Cheers,
> Mauro
>
>  arch/arm/mach-pxa/devices.c          |   95 ++++++++++++++++++++++++++++-------
>  arch/arm/mach-pxa/pcm990-baseboard.c |   10 ++-
>  drivers/media/video/pxa_camera.c     |    4 +
>  3 files changed, 86 insertions(+), 23 deletions(-)
>
> diff -upr oldtree/arch/arm/mach-pxa/devices.c /home/v4l/tokernel/wrk/linux-2.6/arch/arm/mach-pxa/devices.c
> --- oldtree/arch/arm/mach-pxa/devices.c 2009-01-03 10:29:18.000000000 -0200
> +++ /home/v4l/tokernel/wrk/linux-2.6/arch/arm/mach-pxa/devices.c        2008-12-31 01:18:53.000000000 -0200
> @@ -4,13 +4,12 @@
>  #include <linux/platform_device.h>
>  #include <linux/dma-mapping.h>
>
> -#include <mach/gpio.h>
> +#include <mach/pxa-regs.h>
>  #include <mach/udc.h>
>  #include <mach/pxafb.h>
>  #include <mach/mmc.h>
>  #include <mach/irda.h>
>  #include <mach/i2c.h>
> -#include <mach/mfp-pxa27x.h>
>  #include <mach/ohci.h>
>  #include <mach/pxa27x_keypad.h>
>  #include <mach/pxa2xx_spi.h>
> @@ -156,8 +155,8 @@ void __init set_pxa_fb_parent(struct dev
>
>  static struct resource pxa_resource_ffuart[] = {
>        {
> -               .start  = __PREG(FFUART),
> -               .end    = __PREG(FFUART) + 35,
> +               .start  = 0x40100000,
> +               .end    = 0x40100023,
>                .flags  = IORESOURCE_MEM,
>        }, {
>                .start  = IRQ_FFUART,
> @@ -175,8 +174,8 @@ struct platform_device pxa_device_ffuart
>
>  static struct resource pxa_resource_btuart[] = {
>        {
> -               .start  = __PREG(BTUART),
> -               .end    = __PREG(BTUART) + 35,
> +               .start  = 0x40200000,
> +               .end    = 0x40200023,
>                .flags  = IORESOURCE_MEM,
>        }, {
>                .start  = IRQ_BTUART,
> @@ -194,8 +193,8 @@ struct platform_device pxa_device_btuart
>
>  static struct resource pxa_resource_stuart[] = {
>        {
> -               .start  = __PREG(STUART),
> -               .end    = __PREG(STUART) + 35,
> +               .start  = 0x40700000,
> +               .end    = 0x40700023,
>                .flags  = IORESOURCE_MEM,
>        }, {
>                .start  = IRQ_STUART,
> @@ -213,8 +212,8 @@ struct platform_device pxa_device_stuart
>
>  static struct resource pxa_resource_hwuart[] = {
>        {
> -               .start  = __PREG(HWUART),
> -               .end    = __PREG(HWUART) + 47,
> +               .start  = 0x41600000,
> +               .end    = 0x4160002F,
>                .flags  = IORESOURCE_MEM,
>        }, {
>                .start  = IRQ_HWUART,
> @@ -249,18 +248,53 @@ struct platform_device pxa_device_i2c =
>        .num_resources  = ARRAY_SIZE(pxai2c_resources),
>  };
>
> -static unsigned long pxa27x_i2c_mfp_cfg[] = {
> -       GPIO117_I2C_SCL,
> -       GPIO118_I2C_SDA,
> -};
> -
>  void __init pxa_set_i2c_info(struct i2c_pxa_platform_data *info)
>  {
> -       if (cpu_is_pxa27x())
> -               pxa2xx_mfp_config(ARRAY_AND_SIZE(pxa27x_i2c_mfp_cfg));
>        pxa_register_device(&pxa_device_i2c, info);
>  }
>
> +#ifdef CONFIG_PXA27x
> +static struct resource pxa27x_resources_i2c_power[] = {
> +       {
> +               .start  = 0x40f00180,
> +               .end    = 0x40f001a3,
> +               .flags  = IORESOURCE_MEM,
> +       }, {
> +               .start  = IRQ_PWRI2C,
> +               .end    = IRQ_PWRI2C,
> +               .flags  = IORESOURCE_IRQ,
> +       },
> +};
> +
> +struct platform_device pxa27x_device_i2c_power = {
> +       .name           = "pxa2xx-i2c",
> +       .id             = 1,
> +       .resource       = pxa27x_resources_i2c_power,
> +       .num_resources  = ARRAY_SIZE(pxa27x_resources_i2c_power),
> +};
> +#endif
> +
> +#ifdef CONFIG_PXA3xx
> +static struct resource pxa3xx_resources_i2c_power[] = {
> +       {
> +               .start  = 0x40f500c0,
> +               .end    = 0x40f500d3,
> +               .flags  = IORESOURCE_MEM,
> +       }, {
> +               .start  = IRQ_PWRI2C,
> +               .end    = IRQ_PWRI2C,
> +               .flags  = IORESOURCE_IRQ,
> +       },
> +};
> +
> +struct platform_device pxa3xx_device_i2c_power = {
> +       .name           = "pxa2xx-i2c",
> +       .id             = 1,
> +       .resource       = pxa3xx_resources_i2c_power,
> +       .num_resources  = ARRAY_SIZE(pxa3xx_resources_i2c_power),
> +};
> +#endif
> +
>  static struct resource pxai2s_resources[] = {
>        {
>                .start  = 0x40400000,
> @@ -296,11 +330,36 @@ void __init pxa_set_ficp_info(struct pxa
>        pxa_register_device(&pxa_device_ficp, info);
>  }
>
> -struct platform_device pxa_device_rtc = {
> +static struct resource pxa_rtc_resources[] = {
> +       [0] = {
> +               .start  = 0x40900000,
> +               .end    = 0x40900000 + 0x3b,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [1] = {
> +               .start  = IRQ_RTC1Hz,
> +               .end    = IRQ_RTC1Hz,
> +               .flags  = IORESOURCE_IRQ,
> +       },
> +       [2] = {
> +               .start  = IRQ_RTCAlrm,
> +               .end    = IRQ_RTCAlrm,
> +               .flags  = IORESOURCE_IRQ,
> +       },
> +};
> +
> +struct platform_device sa1100_device_rtc = {
>        .name           = "sa1100-rtc",
>        .id             = -1,
>  };
>
> +struct platform_device pxa_device_rtc = {
> +       .name           = "pxa-rtc",
> +       .id             = -1,
> +       .num_resources  = ARRAY_SIZE(pxa_rtc_resources),
> +       .resource       = pxa_rtc_resources,
> +};
> +
>  static struct resource pxa_ac97_resources[] = {
>        [0] = {
>                .start  = 0x40500000,
> diff -upr oldtree/arch/arm/mach-pxa/pcm990-baseboard.c /home/v4l/tokernel/wrk/linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
> --- oldtree/arch/arm/mach-pxa/pcm990-baseboard.c        2009-01-03 10:29:18.000000000 -0200
> +++ /home/v4l/tokernel/wrk/linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c       2008-12-31 01:18:53.000000000 -0200
> @@ -55,6 +55,10 @@ static unsigned long pcm990_pin_config[]
>        GPIO89_USBH1_PEN,
>        /* PWM0 */
>        GPIO16_PWM0_OUT,
> +
> +       /* I2C */
> +       GPIO117_I2C_SCL,
> +       GPIO118_I2C_SDA,
>  };
>
>  /*
> @@ -100,8 +104,7 @@ static struct pxafb_mode_info fb_info_sh
>  static struct pxafb_mach_info pcm990_fbinfo __initdata = {
>        .modes                  = &fb_info_sharp_lq084v1dg21,
>        .num_modes              = 1,
> -       .lccr0                  = LCCR0_PAS,
> -       .lccr3                  = LCCR3_PCP,
> +       .lcd_conn               = LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
>        .pxafb_lcd_power        = pcm990_lcd_power,
>  };
>  #elif defined(CONFIG_PCM990_DISPLAY_NEC)
> @@ -123,8 +126,7 @@ struct pxafb_mode_info fb_info_nec_nl644
>  static struct pxafb_mach_info pcm990_fbinfo __initdata = {
>        .modes                  = &fb_info_nec_nl6448bc20_18d,
>        .num_modes              = 1,
> -       .lccr0                  = LCCR0_Act,
> -       .lccr3                  = LCCR3_PixFlEdg,
> +       .lcd_conn               = LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
>        .pxafb_lcd_power        = pcm990_lcd_power,
>  };
>  #endif
> diff -upr oldtree/drivers/media/video/pxa_camera.c /home/v4l/tokernel/wrk/linux-2.6/drivers/media/video/pxa_camera.c
> --- oldtree/drivers/media/video/pxa_camera.c    2009-01-03 10:29:19.000000000 -0200
> +++ /home/v4l/tokernel/wrk/linux-2.6/drivers/media/video/pxa_camera.c   2008-12-31 01:18:53.000000000 -0200
> @@ -38,6 +38,8 @@
>  #include <mach/pxa-regs.h>
>  #include <mach/camera.h>
>
> +#include "pxa_camera.h"
> +
>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
>
> @@ -1402,7 +1404,7 @@ static int pxa_camera_probe(struct platf
>                goto exit;
>        }
>
> -       pcdev->clk = clk_get(&pdev->dev, "CAMCLK");
> +       pcdev->clk = clk_get(&pdev->dev, NULL);
>        if (IS_ERR(pcdev->clk)) {
>                err = PTR_ERR(pcdev->clk);
>                goto exit_kfree;
>



-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
