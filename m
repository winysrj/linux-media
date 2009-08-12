Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38080 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbZHLUN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 16:13:59 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Wed, 12 Aug 2009 15:13:53 -0500
Subject: RE: [PATCH v0 1/5] DaVinci - re-structuring code to support vpif
 capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40145288A66@dlee06.ent.ti.com>
References: <1249599808-21673-1-git-send-email-m-karicheri2@ti.com>
 <87bpmn9qhp.fsf@deeprootsystems.com>
In-Reply-To: <87bpmn9qhp.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

Thanks for reviewing this. See below for my response.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

<snip>
>>
>>  #define VIDCH2CLK		(BIT(10))
>>  #define VIDCH3CLK		(BIT(11))
>> +#define VIDCH1CLK		(BIT(4))
>> +#define TVP7002_INPUT		(BIT(4))
>> +#define TVP5147_INPUT		(~BIT(4))
>> +#define VPIF_INPUT_ONE_CHANNEL	(BIT(5))
>> +#define VPIF_INPUT_TWO_CHANNEL	(~BIT(5))
>
>Hmm, I think the usage of the ~BIT(x) definitions are not exactly
>clear.
>
Is it not clear that for selecting one channel mode you need to set
bit 5 and two channel mode requires it to be reset from this? This looks very obvious for me. 
>I'd rather just see the single BIT(x) definition, and code the
>use of them differently...

Other way is to define it as Logical OR of all BITs except BIT5. Is it what you looking for? This will be unnecessary IMHO.
>
>> +#define TVP5147_CH0		"tvp514x-0"
>> +#define TVP5147_CH1		"tvp514x-1"
>> +

<Snip>
>> + */
>> +static int setup_vpif_input_path(int channel, const char *sub_dev_name)
>> +{
>> +	int err = 0;
>> +	int val;
>> +
>> +	/* for channel 1, we don't do anything */
>> +	if (channel != 0)
>> +		return 0;
>> +
>> +	if (NULL == cpld_client)
>> +		return -EFAULT;
>> +
>> +	val = i2c_smbus_read_byte(cpld_client);
>> +	if (val < 0)
>> +		return val;
>> +
>> +	if (!strcmp(sub_dev_name, TVP5147_CH0) ||
>> +	    !strcmp(sub_dev_name, TVP5147_CH1))
>
>Hmm, shouldn't this be '&&' instead of '||'.
>
No. You want to do this for either TVP5147_CH0 or TVP5147_CH1. How can this be && since the strcmp returns zero when there is a match? 

>> +		val &= TVP5147_INPUT;
>
>rather:
>
>                val &= ~TVP7002_INPUT; /* tvp5147 input */
>
TVP5147_INPUT is defined as a 0 for bit4. So val &= TVP5147_INPUT is correct.
>> +	else
>> +		val |= TVP7002_INPUT;
>> +
>> +	err = i2c_smbus_write_byte(cpld_client, val);
>> +	if (err)
>> +		return err;
>> +	return 0;
>> +}
>> +
>> +/**
>> + * setup_vpif_input_channel_mode()
>> + * @mux_mode:  mux mode. 0 - 1 channel or (1) - 2 channel
>> + *
>> + * This will setup input mode to one channel (TVP7002) or 2 channel
>(TVP5147)
>> + */
>> +static int setup_vpif_input_channel_mode(int mux_mode)
>> +{
>> +	int err = 0;
>> +	int val;
>> +	u32 value;
>> +	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
>
>Use ioremap() + readl/writel instead of IO_ADDRESS() +
>__raw_read/__raw_write.
Ok. I will change this.
>
>> +	val = i2c_smbus_read_byte(cpld_client);
>> +	if (val < 0)
>> +		return val;
>> +
>> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
>> +	if (mux_mode) {
>> +		val &= VPIF_INPUT_TWO_CHANNEL;
>> +		value |= VIDCH1CLK;
>> +	} else {
>> +		val |= VPIF_INPUT_ONE_CHANNEL;
>> +		value &= ~VIDCH1CLK;
>> +	}
>> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
>> +
>> +	err = i2c_smbus_write_byte(cpld_client, val);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct tvp514x_platform_data tvp5146_pdata = {
>> +	.clk_polarity = 0,
>> +	.hs_polarity = 1,
>> +	.vs_polarity = 1
>> +};
>> +
>> +#define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
>> +
>> +static struct vpif_subdev_info vpif_capture_sdev_info[] = {
>> +	{
>> +		.name	= TVP5147_CH0,
>> +		.board_info = {
>> +			I2C_BOARD_INFO("tvp5146", 0x5d),
>> +			.platform_data = &tvp5146_pdata,
>> +		},
>> +		.input = INPUT_CVBS_VI2B,
>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +		.can_route = 1,
>> +		.vpif_if = {
>> +			.if_type = VPIF_IF_BT656,
>> +			.hd_pol = 1,
>> +			.vd_pol = 1,
>> +			.fid_pol = 0,
>> +		},
>> +	},
>> +	{
>> +		.name	= TVP5147_CH1,
>> +		.board_info = {
>> +			I2C_BOARD_INFO("tvp5146", 0x5c),
>> +			.platform_data = &tvp5146_pdata,
>> +		},
>> +		.input = INPUT_SVIDEO_VI2C_VI1C,
>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +		.can_route = 1,
>> +		.vpif_if = {
>> +			.if_type = VPIF_IF_BT656,
>> +			.hd_pol = 1,
>> +			.vd_pol = 1,
>> +			.fid_pol = 0,
>> +		},
>> +	},
>> +};
>> +
>> +static const struct vpif_input dm6467_ch0_inputs[] = {
>> +	{
>> +		.input = {
>> +			.index = 0,
>> +			.name = "Composite",
>> +			.type = V4L2_INPUT_TYPE_CAMERA,
>> +			.std = TVP514X_STD_ALL,
>> +		},
>> +		.subdev_name = TVP5147_CH0,
>> +	},
>> +};
>> +
>> +static const struct vpif_input dm6467_ch1_inputs[] = {
>> +       {
>> +		.input = {
>> +			.index = 0,
>> +			.name = "S-Video",
>> +			.type = V4L2_INPUT_TYPE_CAMERA,
>> +			.std = TVP514X_STD_ALL,
>> +		},
>> +		.subdev_name = TVP5147_CH1,
>> +	},
>> +};
>> +
>> +static struct vpif_capture_config dm646x_vpif_capture_cfg = {
>> +	.setup_input_path = setup_vpif_input_path,
>> +	.setup_input_channel_mode = setup_vpif_input_channel_mode,
>> +	.subdev_info = vpif_capture_sdev_info,
>> +	.subdev_count = ARRAY_SIZE(vpif_capture_sdev_info),
>> +	.chan_config[0] = {
>> +		.inputs = dm6467_ch0_inputs,
>> +		.input_count = ARRAY_SIZE(dm6467_ch0_inputs),
>> +	},
>> +	.chan_config[1] = {
>> +		.inputs = dm6467_ch1_inputs,
>> +		.input_count = ARRAY_SIZE(dm6467_ch1_inputs),
>> +	},
>> +};
>> +
>>  static void __init evm_init_i2c(void)
>>  {
>>  	davinci_init_i2c(&i2c_pdata);
>> @@ -453,7 +617,8 @@ static __init void evm_init(void)
>>
>>  	soc_info->emac_pdata->phy_mask = DM646X_EVM_PHY_MASK;
>>  	soc_info->emac_pdata->mdio_max_freq = DM646X_EVM_MDIO_FREQUENCY;
>> -	dm646x_setup_vpif(&dm646x_vpif_config);
>> +	dm646x_setup_vpif(&dm646x_vpif_display_config,
>> +			  &dm646x_vpif_capture_cfg);
>>  }
>>
>>  static __init void davinci_dm646x_evm_irq_init(void)
>> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-
>davinci/dm646x.c
>> index fc02f22..4ee3b6f 100644
>> --- a/arch/arm/mach-davinci/dm646x.c
>> +++ b/arch/arm/mach-davinci/dm646x.c
>> @@ -613,9 +613,23 @@ static u64 vpif_dma_mask = DMA_BIT_MASK(32);
>>  static struct resource vpif_resource[] = {
>>  	{
>>  		.start	= DAVINCI_VPIF_BASE,
>> -		.end	= DAVINCI_VPIF_BASE + 0x03fff,
>> +		.end	= DAVINCI_VPIF_BASE + 0x03ff,
>>  		.flags	= IORESOURCE_MEM,
>> +	}
>> +};
>> +
>> +static struct platform_device vpif_dev = {
>> +	.name		= "vpif",
>> +	.id		= -1,
>> +	.dev		= {
>> +			.dma_mask 		= &vpif_dma_mask,
>> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>>  	},
>> +	.resource	= vpif_resource,
>> +	.num_resources	= ARRAY_SIZE(vpif_resource),
>> +};
>> +
>> +static struct resource vpif_display_resource[] = {
>>  	{
>>  		.start = IRQ_DM646X_VP_VERTINT2,
>>  		.end   = IRQ_DM646X_VP_VERTINT2,
>> @@ -633,10 +647,34 @@ static struct platform_device vpif_display_dev = {
>>  	.id		= -1,
>>  	.dev		= {
>>  			.dma_mask 		= &vpif_dma_mask,
>> -			.coherent_dma_mask	= DMA_32BIT_MASK,
>> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>>  	},
>> -	.resource	= vpif_resource,
>> -	.num_resources	= ARRAY_SIZE(vpif_resource),
>> +	.resource	= vpif_display_resource,
>> +	.num_resources	= ARRAY_SIZE(vpif_display_resource),
>> +};
>> +
>> +static struct resource vpif_capture_resource[] = {
>> +	{
>> +		.start = IRQ_DM646X_VP_VERTINT0,
>> +		.end   = IRQ_DM646X_VP_VERTINT0,
>> +		.flags = IORESOURCE_IRQ,
>> +	},
>> +	{
>> +		.start = IRQ_DM646X_VP_VERTINT1,
>> +		.end   = IRQ_DM646X_VP_VERTINT1,
>> +		.flags = IORESOURCE_IRQ,
>> +	},
>> +};
>> +
>> +static struct platform_device vpif_capture_dev = {
>> +	.name		= "vpif_capture",
>> +	.id		= -1,
>> +	.dev		= {
>> +			.dma_mask 		= &vpif_dma_mask,
>> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>> +	},
>> +	.resource	= vpif_capture_resource,
>> +	.num_resources	= ARRAY_SIZE(vpif_capture_resource),
>>  };
>>
>>  static struct resource ide_resources[] = {
>> @@ -853,7 +891,8 @@ void __init dm646x_init_mcasp1(struct
>snd_platform_data *pdata)
>>  	platform_device_register(&dm646x_dit_device);
>>  }
>>
>> -void dm646x_setup_vpif(struct vpif_config *config)
>> +void dm646x_setup_vpif(struct vpif_display_config *display_config,
>> +		       struct vpif_capture_config *capture_config)
>>  {
>>  	unsigned int value;
>>  	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
>> @@ -871,8 +910,11 @@ void dm646x_setup_vpif(struct vpif_config *config)
>>  	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
>>  	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
>>
>> -	vpif_display_dev.dev.platform_data = config;
>> +	vpif_display_dev.dev.platform_data = display_config;
>> +	vpif_capture_dev.dev.platform_data = capture_config;
>> +	platform_device_register(&vpif_dev);
>>  	platform_device_register(&vpif_display_dev);
>> +	platform_device_register(&vpif_capture_dev);
>>  }
>>
>>  void __init dm646x_init(void)
>> diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-
>davinci/include/mach/dm646x.h
>> index 737b549..b639142 100644
>> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
>> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
>> @@ -14,6 +14,8 @@
>>  #include <mach/hardware.h>
>>  #include <mach/emac.h>
>>  #include <mach/asp.h>
>> +#include <linux/i2c.h>
>> +#include <linux/videodev2.h>
>>
>>  #define DM646X_EMAC_BASE		(0x01C80000)
>>  #define DM646X_EMAC_CNTRL_OFFSET	(0x0000)
>> @@ -24,30 +26,64 @@
>>
>>  #define DM646X_ATA_REG_BASE		(0x01C66000)
>>
>> -struct vpif_output {
>> -	u16 id;
>> -	const char *name;
>> +enum vpif_if_type {
>> +	VPIF_IF_BT656,
>> +	VPIF_IF_BT1120,
>> +	VPIF_IF_RAW_BAYER
>> +};
>> +
>> +struct vpif_interface {
>> +	enum vpif_if_type if_type;
>> +	unsigned hd_pol:1;
>> +	unsigned vd_pol:1;
>> +	unsigned fid_pol:1;
>>  };
>>
>>  struct vpif_subdev_info {
>> -	unsigned short addr;
>>  	const char *name;
>> +	struct i2c_board_info board_info;
>> +	u32 input;
>> +	u32 output;
>> +	unsigned can_route:1;
>> +	struct vpif_interface vpif_if;
>>  };
>>
>> -struct vpif_config {
>> +struct vpif_display_config {
>>  	int (*set_clock)(int, int);
>> -	const struct vpif_subdev_info *subdevinfo;
>> +	struct vpif_subdev_info *subdevinfo;
>>  	int subdev_count;
>>  	const char **output;
>>  	int output_count;
>>  	const char *card_name;
>>  };
>>
>> +struct vpif_input {
>> +	struct v4l2_input input;
>> +	const char *subdev_name;
>> +};
>> +
>> +#define VPIF_CAPTURE_MAX_CHANNELS	2
>> +
>> +struct vpif_capture_chan_config {
>> +	const struct vpif_input *inputs;
>> +	int input_count;
>> +};
>> +
>> +struct vpif_capture_config {
>> +	int (*setup_input_channel_mode)(int);
>> +	int (*setup_input_path)(int, const char *);
>> +	struct vpif_capture_chan_config
>chan_config[VPIF_CAPTURE_MAX_CHANNELS];
>> +	struct vpif_subdev_info *subdev_info;
>> +	int subdev_count;
>> +	const char *card_name;
>> +};
>> +
>>  void __init dm646x_init(void);
>>  void __init dm646x_init_ide(void);
>>  void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
>>  void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
>>  void dm646x_video_init(void);
>> -void dm646x_setup_vpif(struct vpif_config *config);
>> +void dm646x_setup_vpif(struct vpif_display_config *,
>> +		       struct vpif_capture_config *);
>>
>>  #endif /* __ASM_ARCH_DM646X_H */
>> --
>> 1.6.0.4

