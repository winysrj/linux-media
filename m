Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53407 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZJPQfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 12:35:17 -0400
Received: by pzk26 with SMTP id 26so1731432pzk.4
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:35:21 -0700 (PDT)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "Sikka\, Neil" <neilsikka@ti.com>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v1 1/4] DM365 Platform support for VPFE
References: <1250539529-2702-1-git-send-email-neilsikka@ti.com>
	<1250539529-2702-2-git-send-email-neilsikka@ti.com>
	<87y6ncz1op.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE4015555F60A@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 16 Oct 2009 09:35:19 -0700
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015555F60A@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Fri\, 16 Oct 2009 10\:29\:46 -0500")
Message-ID: <87my3rxpo8.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> I would like to wait on this one and re-submit a revised
> patch. There is a plan to use sub device model for ccdc driver. So I
> will re-submit the ccdc drivers with this change as well as the
> corresponding platform code.

Murali,

OK, thanks for the update, I'll drop from my queue and wait for
updated version.

Kevin

>>-----Original Message-----
>>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>>Of Kevin Hilman
>>Sent: Thursday, October 15, 2009 7:18 PM
>>To: Sikka, Neil
>>Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
>>media@vger.kernel.org
>>Subject: Re: [PATCH v1 1/4] DM365 Platform support for VPFE
>>
>>neilsikka@ti.com writes:
>>
>>> From: Neil Sikka <neilsikka@ti.com>
>>>
>>> This has platform and board setup changes to support the vpfe capture
>>> driver for DM365 EVMs.
>>>
>>> Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>>> Mandatory-Reviewer: Hans Verkuil <hverkuil@xs4all.nl>
>>> Mandatory-Reviewer: Kevin Hilman <khilman@deeprootsystems.com>
>>> Signed-off-by: Neil Sikka <neilsikka@ti.com>
>>
>>Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>>
>>for this patch, but the rest of the series needs to be reviewed by linux-
>>media folks.
>>
>>Kevin
>>
>>
>>> ---
>>> Applies to Kevin Hilman's linux-davinci repository
>>>  arch/arm/mach-davinci/board-dm365-evm.c    |   71
>>++++++++++++++++++++++++++++
>>>  arch/arm/mach-davinci/dm365.c              |   68
>>++++++++++++++++++++++++++
>>>  arch/arm/mach-davinci/include/mach/dm365.h |    2 +
>>>  3 files changed, 141 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-
>>davinci/board-dm365-evm.c
>>> index f6adf79..757ad13 100644
>>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>>> @@ -38,6 +38,8 @@
>>>  #include <mach/common.h>
>>>  #include <mach/mmc.h>
>>>  #include <mach/nand.h>
>>> +#include <linux/videodev2.h>
>>> +#include <media/tvp514x.h>
>>>
>>>
>>>  static inline int have_imager(void)
>>> @@ -98,6 +100,11 @@ static inline int have_tvp7002(void)
>>>
>>>  static void __iomem *cpld;
>>>
>>> +static struct tvp514x_platform_data tvp5146_pdata = {
>>> +       .clk_polarity = 0,
>>> +       .hs_polarity = 1,
>>> +       .vs_polarity = 1
>>> +};
>>>
>>>  /* NOTE:  this is geared for the standard config, with a socketed
>>>   * 2 GByte Micron NAND (MT29F16G08FAA) using 128KB sectors.  If you
>>> @@ -210,6 +217,68 @@ static int cpld_mmc_get_ro(int module)
>>>  	return !!(__raw_readb(cpld + CPLD_CARDSTAT) & BIT(module ? 5 : 1));
>>>  }
>>>
>>> +#define TVP514X_STD_ALL        (V4L2_STD_NTSC | V4L2_STD_PAL)
>>> +/* Inputs available at the TVP5146 */
>>> +static struct v4l2_input tvp5146_inputs[] = {
>>> +	{
>>> +		.index = 0,
>>> +		.name = "Composite",
>>> +		.type = V4L2_INPUT_TYPE_CAMERA,
>>> +		.std = TVP514X_STD_ALL,
>>> +	},
>>> +	{
>>> +		.index = 1,
>>> +		.name = "S-Video",
>>> +		.type = V4L2_INPUT_TYPE_CAMERA,
>>> +		.std = TVP514X_STD_ALL,
>>> +	},
>>> +};
>>> +
>>> +/*
>>> + * this is the route info for connecting each input to decoder
>>> + * ouput that goes to vpfe. There is a one to one correspondence
>>> + * with tvp5146_inputs
>>> + */
>>> +static struct vpfe_route tvp5146_routes[] = {
>>> +	{
>>> +		.input = INPUT_CVBS_VI2B,
>>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>>> +	},
>>> +{
>>> +		.input = INPUT_SVIDEO_VI2C_VI1C,
>>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>>> +	},
>>> +};
>>> +
>>> +static struct vpfe_subdev_info vpfe_sub_devs[] = {
>>> +{
>>> +		.module_name = "tvp5146",
>>> +		.grp_id = 0,
>>> +		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
>>> +		.inputs = tvp5146_inputs,
>>> +		.routes = tvp5146_routes,
>>> +		.can_route = 1,
>>> +		.ccdc_if_params = {
>>> +			.if_type = VPFE_BT656,
>>> +			.hdpol = VPFE_PINPOL_POSITIVE,
>>> +			.vdpol = VPFE_PINPOL_POSITIVE,
>>> +		},
>>> +		.board_info = {
>>> +			I2C_BOARD_INFO("tvp5146", 0x5d),
>>> +			.platform_data = &tvp5146_pdata,
>>> +		},
>>> +	}
>>> +};
>>> +
>>> +static struct vpfe_config vpfe_cfg = {
>>> +       .num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
>>> +       .sub_devs = vpfe_sub_devs,
>>> +       .card_name = "DM365 EVM",
>>> +       .ccdc = "DM365 ISIF",
>>> +       .num_clocks = 1,
>>> +       .clocks = {"vpss_master"},
>>> +};
>>> +
>>>  static struct davinci_mmc_config dm365evm_mmc_config = {
>>>  	.get_cd		= cpld_mmc_get_cd,
>>>  	.get_ro		= cpld_mmc_get_ro,
>>> @@ -461,6 +530,8 @@ static struct davinci_uart_config uart_config
>>__initdata = {
>>>
>>>  static void __init dm365_evm_map_io(void)
>>>  {
>>> +	/* setup input configuration for VPFE input devices */
>>> +	dm365_set_vpfe_config(&vpfe_cfg);
>>>  	dm365_init();
>>>  }
>>>
>>> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-
>>davinci/dm365.c
>>> index f8bac94..aa432d4 100644
>>> --- a/arch/arm/mach-davinci/dm365.c
>>> +++ b/arch/arm/mach-davinci/dm365.c
>>> @@ -904,6 +904,62 @@ void __init dm365_init(void)
>>>  	davinci_common_init(&davinci_soc_info_dm365);
>>>  }
>>>
>>> +static struct resource dm365_vpss_resources[] = {
>>> +	{
>>> +		/* VPSS ISP5 Base address */
>>> +		.name           = "vpss",
>>> +		.start          = 0x01c70000,
>>> +		.end            = 0x01c70000 + 0xff,
>>> +		.flags          = IORESOURCE_MEM,
>>> +	},
>>> +	{
>>> +		/* VPSS CLK Base address */
>>> +		.name           = "vpss",
>>> +		.start          = 0x01c70200,
>>> +		.end            = 0x01c70200 + 0xff,
>>> +		.flags          = IORESOURCE_MEM,
>>> +	},
>>> +};
>>> +
>>> +static struct platform_device dm365_vpss_device = {
>>> +       .name                   = "vpss",
>>> +       .id                     = -1,
>>> +       .dev.platform_data      = "dm365_vpss",
>>> +       .num_resources          = ARRAY_SIZE(dm365_vpss_resources),
>>> +       .resource               = dm365_vpss_resources,
>>> +};
>>> +
>>> +static struct resource vpfe_resources[] = {
>>> +	{
>>> +		.start          = IRQ_VDINT0,
>>> +		.end            = IRQ_VDINT0,
>>> +		.flags          = IORESOURCE_IRQ,
>>> +	},
>>> +	{
>>> +		.start          = IRQ_VDINT1,
>>> +		.end            = IRQ_VDINT1,
>>> +		.flags          = IORESOURCE_IRQ,
>>> +	},
>>> +	/* ISIF Base address */
>>> +	{
>>> +		.start          = 0x01c71000,
>>> +		.end            = 0x01c71000 + 0x1ff,
>>> +		.flags          = IORESOURCE_MEM,
>>> +	},
>>> +};
>>> +
>>> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>>> +static struct platform_device vpfe_capture_dev = {
>>> +	.name           = CAPTURE_DRV_NAME,
>>> +	.id             = -1,
>>> +	.num_resources  = ARRAY_SIZE(vpfe_resources),
>>> +	.resource       = vpfe_resources,
>>> +	.dev = {
>>> +		.dma_mask               = &vpfe_capture_dma_mask,
>>> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
>>> +	},
>>> +};
>>> +
>>>  static int __init dm365_init_devices(void)
>>>  {
>>>  	if (!cpu_is_davinci_dm365())
>>> @@ -913,6 +969,18 @@ static int __init dm365_init_devices(void)
>>>  	platform_device_register(&dm365_edma_device);
>>>  	platform_device_register(&dm365_emac_device);
>>>
>>> +	/*
>>> +	* setup Mux configuration for vpfe input and register
>>> +	* vpfe capture platform device
>>> +	*/
>>> +	platform_device_register(&dm365_vpss_device);
>>> +	platform_device_register(&vpfe_capture_dev);
>>> +
>>>  	return 0;
>>>  }
>>>  postcore_initcall(dm365_init_devices);
>>> +
>>> +void dm365_set_vpfe_config(struct vpfe_config *cfg)
>>> +{
>>> +       vpfe_capture_dev.dev.platform_data = cfg;
>>> +}
>>> diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-
>>davinci/include/mach/dm365.h
>>> index 09db434..2fbead2 100644
>>> --- a/arch/arm/mach-davinci/include/mach/dm365.h
>>> +++ b/arch/arm/mach-davinci/include/mach/dm365.h
>>> @@ -15,6 +15,7 @@
>>>
>>>  #include <linux/platform_device.h>
>>>  #include <mach/hardware.h>
>>> +#include <media/davinci/vpfe_capture.h>
>>>  #include <mach/emac.h>
>>>
>>>  #define DM365_EMAC_BASE			(0x01D07000)
>>> @@ -25,5 +26,6 @@
>>>  #define DM365_EMAC_CNTRL_RAM_SIZE	(0x2000)
>>>
>>>  void __init dm365_init(void);
>>> +void dm365_set_vpfe_config(struct vpfe_config *cfg);
>>>
>>>  #endif /* __ASM_ARCH_DM365_H */
>>> --
>>> 1.6.0.4
>>
>>_______________________________________________
>>Davinci-linux-open-source mailing list
>>Davinci-linux-open-source@linux.davincidsp.com
>>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
