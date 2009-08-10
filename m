Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:59191 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZHJXwE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 19:52:04 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1223580wfd.4
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 16:52:05 -0700 (PDT)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v0 1/5] DaVinci - re-structuring code to support vpif capture driver
References: <1249599808-21673-1-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 10 Aug 2009 16:52:02 -0700
In-Reply-To: <1249599808-21673-1-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Thu\,  6 Aug 2009 19\:03\:27 -0400")
Message-ID: <87bpmn9qhp.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> This patch makes the following changes:-
> 	1) Modify vpif_subdev_info to add board_info, routing information
> 	   and vpif interface configuration. Remove addr since it is
> 	   part of board_info
> 	 
> 	2) Add code to setup channel mode and input decoder path for
> 	   vpif capture driver
>
> NOTE: This patch is dependent on the patch from Chaithrika for vpif
> display. Also the arch sepcific files are manually merged to
> linux-davinci tree before creating this patch. So this is only for
> review. Final patch to be merged will be created later
>
> Mandatory reviewers : Hans Verkuil <hverkuil@xs4all.nl>
> 		      Kevin Hilman <khilman@deeprootsystems.com>
>  
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>

Looks mostly OK, some minor nits...

> ---
>  arch/arm/mach-davinci/board-dm646x-evm.c    |  179 +++++++++++++++++++++++++-
>  arch/arm/mach-davinci/dm646x.c              |   54 +++++++-
>  arch/arm/mach-davinci/include/mach/dm646x.h |   50 +++++++-
>  3 files changed, 263 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 38a1022..cb4246b 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -33,7 +33,7 @@
>  #include <linux/i2c/at24.h>
>  #include <linux/i2c/pcf857x.h>
>  #include <linux/etherdevice.h>
> -
> +#include <media/tvp514x.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -75,6 +75,14 @@
>  
>  #define VIDCH2CLK		(BIT(10))
>  #define VIDCH3CLK		(BIT(11))
> +#define VIDCH1CLK		(BIT(4))
> +#define TVP7002_INPUT		(BIT(4))
> +#define TVP5147_INPUT		(~BIT(4))
> +#define VPIF_INPUT_ONE_CHANNEL	(BIT(5))
> +#define VPIF_INPUT_TWO_CHANNEL	(~BIT(5))

Hmm, I think the usage of the ~BIT(x) definitions are not exactly
clear.

I'd rather just see the single BIT(x) definition, and code the
use of them differently...

> +#define TVP5147_CH0		"tvp514x-0"
> +#define TVP5147_CH1		"tvp514x-1"
> +
>  
>  static struct davinci_uart_config uart_config __initdata = {
>  	.enabled_uarts = (1 << 0),
> @@ -348,7 +356,7 @@ static struct i2c_board_info __initdata i2c_info[] =  {
>  		I2C_BOARD_INFO("cpld_reg0", 0x3a),
>  	},
>  	{
> -		I2C_BOARD_INFO("cpld_video", 0x3B),
> +		I2C_BOARD_INFO("cpld_video", 0x3b),
>  	},
>  };
>  
> @@ -400,14 +408,18 @@ static int set_vpif_clock(int mux_mode, int hd)
>  	return 0;
>  }
>  
> -static const struct vpif_subdev_info dm646x_vpif_subdev[] = {
> +static struct vpif_subdev_info dm646x_vpif_subdev[] = {
>  	{
> -		.addr	= 0x2A,
>  		.name	= "adv7343",
> +		.board_info = {
> +			I2C_BOARD_INFO("adv7343", 0x2a),
> +		},
>  	},
>  	{
> -		.addr	= 0x2C,
>  		.name	= "ths7303",
> +		.board_info = {
> +			I2C_BOARD_INFO("ths7303", 0x2c),
> +		},
>  	},
>  };
>  
> @@ -417,7 +429,7 @@ static const char *output[] = {
>  	"S-Video",
>  };
>  
> -static struct vpif_config dm646x_vpif_config = {
> +static struct vpif_display_config dm646x_vpif_display_config = {
>  	.set_clock	= set_vpif_clock,
>  	.subdevinfo	= dm646x_vpif_subdev,
>  	.subdev_count	= ARRAY_SIZE(dm646x_vpif_subdev),
> @@ -426,6 +438,158 @@ static struct vpif_config dm646x_vpif_config = {
>  	.card_name	= "DM646x EVM",
>  };
>  
> +/**
> + * setup_vpif_input_path()
> + * @channel: channel id (0 - CH0, 1 - CH1)
> + * @sub_dev_name: ptr sub device name
> + *
> + * This will set vpif input to capture data from tvp514x or
> + * tvp7002.
> + */
> +static int setup_vpif_input_path(int channel, const char *sub_dev_name)
> +{
> +	int err = 0;
> +	int val;
> +
> +	/* for channel 1, we don't do anything */
> +	if (channel != 0)
> +		return 0;
> +
> +	if (NULL == cpld_client)
> +		return -EFAULT;
> +
> +	val = i2c_smbus_read_byte(cpld_client);
> +	if (val < 0)
> +		return val;
> +
> +	if (!strcmp(sub_dev_name, TVP5147_CH0) ||
> +	    !strcmp(sub_dev_name, TVP5147_CH1))

Hmm, shouldn't this be '&&' instead of '||'.

> +		val &= TVP5147_INPUT;

rather:

                val &= ~TVP7002_INPUT; /* tvp5147 input */

> +	else
> +		val |= TVP7002_INPUT;
> +
> +	err = i2c_smbus_write_byte(cpld_client, val);
> +	if (err)
> +		return err;
> +	return 0;
> +}
> +
> +/**
> + * setup_vpif_input_channel_mode()
> + * @mux_mode:  mux mode. 0 - 1 channel or (1) - 2 channel
> + *
> + * This will setup input mode to one channel (TVP7002) or 2 channel (TVP5147)
> + */
> +static int setup_vpif_input_channel_mode(int mux_mode)
> +{
> +	int err = 0;
> +	int val;
> +	u32 value;
> +	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);

Use ioremap() + readl/writel instead of IO_ADDRESS() + __raw_read/__raw_write.

> +	val = i2c_smbus_read_byte(cpld_client);
> +	if (val < 0)
> +		return val;
> +
> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> +	if (mux_mode) {
> +		val &= VPIF_INPUT_TWO_CHANNEL;
> +		value |= VIDCH1CLK;
> +	} else {
> +		val |= VPIF_INPUT_ONE_CHANNEL;
> +		value &= ~VIDCH1CLK;
> +	}
> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
> +
> +	err = i2c_smbus_write_byte(cpld_client, val);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity = 0,
> +	.hs_polarity = 1,
> +	.vs_polarity = 1
> +};
> +
> +#define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
> +
> +static struct vpif_subdev_info vpif_capture_sdev_info[] = {
> +	{
> +		.name	= TVP5147_CH0,
> +		.board_info = {
> +			I2C_BOARD_INFO("tvp5146", 0x5d),
> +			.platform_data = &tvp5146_pdata,
> +		},
> +		.input = INPUT_CVBS_VI2B,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +		.can_route = 1,
> +		.vpif_if = {
> +			.if_type = VPIF_IF_BT656,
> +			.hd_pol = 1,
> +			.vd_pol = 1,
> +			.fid_pol = 0,
> +		},
> +	},
> +	{
> +		.name	= TVP5147_CH1,
> +		.board_info = {
> +			I2C_BOARD_INFO("tvp5146", 0x5c),
> +			.platform_data = &tvp5146_pdata,
> +		},
> +		.input = INPUT_SVIDEO_VI2C_VI1C,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +		.can_route = 1,
> +		.vpif_if = {
> +			.if_type = VPIF_IF_BT656,
> +			.hd_pol = 1,
> +			.vd_pol = 1,
> +			.fid_pol = 0,
> +		},
> +	},
> +};
> +
> +static const struct vpif_input dm6467_ch0_inputs[] = {
> +	{
> +		.input = {
> +			.index = 0,
> +			.name = "Composite",
> +			.type = V4L2_INPUT_TYPE_CAMERA,
> +			.std = TVP514X_STD_ALL,
> +		},
> +		.subdev_name = TVP5147_CH0,
> +	},
> +};
> +
> +static const struct vpif_input dm6467_ch1_inputs[] = {
> +       {
> +		.input = {
> +			.index = 0,
> +			.name = "S-Video",
> +			.type = V4L2_INPUT_TYPE_CAMERA,
> +			.std = TVP514X_STD_ALL,
> +		},
> +		.subdev_name = TVP5147_CH1,
> +	},
> +};
> +
> +static struct vpif_capture_config dm646x_vpif_capture_cfg = {
> +	.setup_input_path = setup_vpif_input_path,
> +	.setup_input_channel_mode = setup_vpif_input_channel_mode,
> +	.subdev_info = vpif_capture_sdev_info,
> +	.subdev_count = ARRAY_SIZE(vpif_capture_sdev_info),
> +	.chan_config[0] = {
> +		.inputs = dm6467_ch0_inputs,
> +		.input_count = ARRAY_SIZE(dm6467_ch0_inputs),
> +	},
> +	.chan_config[1] = {
> +		.inputs = dm6467_ch1_inputs,
> +		.input_count = ARRAY_SIZE(dm6467_ch1_inputs),
> +	},
> +};
> +
>  static void __init evm_init_i2c(void)
>  {
>  	davinci_init_i2c(&i2c_pdata);
> @@ -453,7 +617,8 @@ static __init void evm_init(void)
>  
>  	soc_info->emac_pdata->phy_mask = DM646X_EVM_PHY_MASK;
>  	soc_info->emac_pdata->mdio_max_freq = DM646X_EVM_MDIO_FREQUENCY;
> -	dm646x_setup_vpif(&dm646x_vpif_config);
> +	dm646x_setup_vpif(&dm646x_vpif_display_config,
> +			  &dm646x_vpif_capture_cfg);
>  }
>  
>  static __init void davinci_dm646x_evm_irq_init(void)
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
> index fc02f22..4ee3b6f 100644
> --- a/arch/arm/mach-davinci/dm646x.c
> +++ b/arch/arm/mach-davinci/dm646x.c
> @@ -613,9 +613,23 @@ static u64 vpif_dma_mask = DMA_BIT_MASK(32);
>  static struct resource vpif_resource[] = {
>  	{
>  		.start	= DAVINCI_VPIF_BASE,
> -		.end	= DAVINCI_VPIF_BASE + 0x03fff,
> +		.end	= DAVINCI_VPIF_BASE + 0x03ff,
>  		.flags	= IORESOURCE_MEM,
> +	}
> +};
> +
> +static struct platform_device vpif_dev = {
> +	.name		= "vpif",
> +	.id		= -1,
> +	.dev		= {
> +			.dma_mask 		= &vpif_dma_mask,
> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>  	},
> +	.resource	= vpif_resource,
> +	.num_resources	= ARRAY_SIZE(vpif_resource),
> +};
> +
> +static struct resource vpif_display_resource[] = {
>  	{
>  		.start = IRQ_DM646X_VP_VERTINT2,
>  		.end   = IRQ_DM646X_VP_VERTINT2,
> @@ -633,10 +647,34 @@ static struct platform_device vpif_display_dev = {
>  	.id		= -1,
>  	.dev		= {
>  			.dma_mask 		= &vpif_dma_mask,
> -			.coherent_dma_mask	= DMA_32BIT_MASK,
> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>  	},
> -	.resource	= vpif_resource,
> -	.num_resources	= ARRAY_SIZE(vpif_resource),
> +	.resource	= vpif_display_resource,
> +	.num_resources	= ARRAY_SIZE(vpif_display_resource),
> +};
> +
> +static struct resource vpif_capture_resource[] = {
> +	{
> +		.start = IRQ_DM646X_VP_VERTINT0,
> +		.end   = IRQ_DM646X_VP_VERTINT0,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = IRQ_DM646X_VP_VERTINT1,
> +		.end   = IRQ_DM646X_VP_VERTINT1,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device vpif_capture_dev = {
> +	.name		= "vpif_capture",
> +	.id		= -1,
> +	.dev		= {
> +			.dma_mask 		= &vpif_dma_mask,
> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +	.resource	= vpif_capture_resource,
> +	.num_resources	= ARRAY_SIZE(vpif_capture_resource),
>  };
>  
>  static struct resource ide_resources[] = {
> @@ -853,7 +891,8 @@ void __init dm646x_init_mcasp1(struct snd_platform_data *pdata)
>  	platform_device_register(&dm646x_dit_device);
>  }
>  
> -void dm646x_setup_vpif(struct vpif_config *config)
> +void dm646x_setup_vpif(struct vpif_display_config *display_config,
> +		       struct vpif_capture_config *capture_config)
>  {
>  	unsigned int value;
>  	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> @@ -871,8 +910,11 @@ void dm646x_setup_vpif(struct vpif_config *config)
>  	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
>  	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
>  
> -	vpif_display_dev.dev.platform_data = config;
> +	vpif_display_dev.dev.platform_data = display_config;
> +	vpif_capture_dev.dev.platform_data = capture_config;
> +	platform_device_register(&vpif_dev);
>  	platform_device_register(&vpif_display_dev);
> +	platform_device_register(&vpif_capture_dev);
>  }
>  
>  void __init dm646x_init(void)
> diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
> index 737b549..b639142 100644
> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> @@ -14,6 +14,8 @@
>  #include <mach/hardware.h>
>  #include <mach/emac.h>
>  #include <mach/asp.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
>  
>  #define DM646X_EMAC_BASE		(0x01C80000)
>  #define DM646X_EMAC_CNTRL_OFFSET	(0x0000)
> @@ -24,30 +26,64 @@
>  
>  #define DM646X_ATA_REG_BASE		(0x01C66000)
>  
> -struct vpif_output {
> -	u16 id;
> -	const char *name;
> +enum vpif_if_type {
> +	VPIF_IF_BT656,
> +	VPIF_IF_BT1120,
> +	VPIF_IF_RAW_BAYER
> +};
> +
> +struct vpif_interface {
> +	enum vpif_if_type if_type;
> +	unsigned hd_pol:1;
> +	unsigned vd_pol:1;
> +	unsigned fid_pol:1;
>  };
>  
>  struct vpif_subdev_info {
> -	unsigned short addr;
>  	const char *name;
> +	struct i2c_board_info board_info;
> +	u32 input;
> +	u32 output;
> +	unsigned can_route:1;
> +	struct vpif_interface vpif_if;
>  };
>  
> -struct vpif_config {
> +struct vpif_display_config {
>  	int (*set_clock)(int, int);
> -	const struct vpif_subdev_info *subdevinfo;
> +	struct vpif_subdev_info *subdevinfo;
>  	int subdev_count;
>  	const char **output;
>  	int output_count;
>  	const char *card_name;
>  };
>  
> +struct vpif_input {
> +	struct v4l2_input input;
> +	const char *subdev_name;
> +};
> +
> +#define VPIF_CAPTURE_MAX_CHANNELS	2
> +
> +struct vpif_capture_chan_config {
> +	const struct vpif_input *inputs;
> +	int input_count;
> +};
> +
> +struct vpif_capture_config {
> +	int (*setup_input_channel_mode)(int);
> +	int (*setup_input_path)(int, const char *);
> +	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
> +	struct vpif_subdev_info *subdev_info;
> +	int subdev_count;
> +	const char *card_name;
> +};
> +
>  void __init dm646x_init(void);
>  void __init dm646x_init_ide(void);
>  void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
>  void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
>  void dm646x_video_init(void);
> -void dm646x_setup_vpif(struct vpif_config *config);
> +void dm646x_setup_vpif(struct vpif_display_config *,
> +		       struct vpif_capture_config *);
>  
>  #endif /* __ASM_ARCH_DM646X_H */
> -- 
> 1.6.0.4
