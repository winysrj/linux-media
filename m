Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:41224 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395AbZCSRA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 13:00:57 -0400
Received: by yw-out-2324.google.com with SMTP id 5so598941ywb.1
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 10:00:55 -0700 (PDT)
To: chaithrika@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC 1/7] ARM: DaVinci: DM646x Video: Platform and board specific setup
References: <1236934840-31839-1-git-send-email-chaithrika@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 19 Mar 2009 10:00:50 -0700
In-Reply-To: <1236934840-31839-1-git-send-email-chaithrika@ti.com> (chaithrika@ti.com's message of "Fri\, 13 Mar 2009 14\:30\:40 +0530")
Message-ID: <8763i5moql.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

chaithrika@ti.com writes:

> From: Chaithrika U S <chaithrika@ti.com>
>
> Add pin mux definitions, display device setup, clock setup functions
>
> Add pin mux related code for the display device, also add platform device
> and resource structures. Also define a platform specific clock setup function
> that can be accessed by the driver to configure the clock and CPLD.
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>

Hi Chaithrika,

The mux and clock additions could be separated out into a separate
patch that could go into DaVinci git today since they are independent
of the video subsytem.

Kevin


> ---
> Applies to linux-davinci GIT tree at
> http://git.kernel.org/?p=linux/kernel/git/khilman/linux-davinci.git;a=commit;h=486afa37130356662213cc1a2199a285b4fd72af
>
>  arch/arm/mach-davinci/board-dm646x-evm.c    |  109 +++++++++++++++++++++++++++
>  arch/arm/mach-davinci/dm646x.c              |  100 ++++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/dm646x.h |    9 ++
>  arch/arm/mach-davinci/include/mach/mux.h    |   17 ++++
>  4 files changed, 235 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 907f424..a6bf180 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -39,6 +39,7 @@
>  #include <mach/serial.h>
>  #include <mach/i2c.h>
>  #include <mach/mmc.h>
> +#include <mach/mux.h>
>  
>  #include <linux/platform_device.h>
>  #include <linux/i2c.h>
> @@ -46,6 +47,21 @@
>  #include <linux/etherdevice.h>
>  #include <mach/emac.h>
>  
> +#include <media/adv7343.h>
> +
> +#define VIDCLKCTL_OFFSET	(0x38)
> +#define VSCLKDIS_OFFSET		(0x6c)
> +
> +#define VCH2CLK_MASK		(0x07 << 8)
> +#define VCH2CLK_SYSCLK8		(0x02 << 8)
> +#define VCH2CLK_AUXCLK		(0x03 << 8)
> +#define VCH3CLK_MASK		(0x07 << 12)
> +#define VCH3CLK_SYSCLK8		(0x02 << 12)
> +#define VCH3CLK_AUXCLK		(0x03 << 12)
> +
> +#define VIDCH2CLK		(0x01 << 10)
> +#define VIDCH3CLK		(0x01 << 11)
> +
>  static struct davinci_uart_config uart_config __initdata = {
>  	.enabled_uarts = (1 << 0),
>  };
> @@ -95,11 +111,54 @@ int dm646xevm_eeprom_write(void *buf, off_t off, size_t count)
>  }
>  EXPORT_SYMBOL(dm646xevm_eeprom_write);
>  
> +static struct i2c_client *cpld_client;
> +
> +static int cpld_video_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	cpld_client = client;
> +	return 0;
> +}
> +
> +static int __devexit cpld_video_remove(struct i2c_client *client)
> +{
> +	cpld_client = NULL;
> +	return 0;
> +}
> +
> +static const struct i2c_device_id cpld_video_id[] = {
> +	{ "cpld_video", 0 },
> +	{ }
> +};
> +
> +static struct i2c_driver cpld_video_driver = {
> +	.driver = {
> +		.name	= "cpld_video",
> +	},
> +	.probe		= cpld_video_probe,
> +	.remove		= cpld_video_remove,
> +	.id_table	= cpld_video_id,
> +};
> +
> +static void evm_init_cpld(void)
> +{
> +	i2c_add_driver(&cpld_video_driver);
> +}
> +
>  static struct i2c_board_info __initdata i2c_info[] =  {
>  	{
>  		I2C_BOARD_INFO("24c256", 0x50),
>  		.platform_data  = &eeprom_info,
>  	},
> +	{
> +		I2C_BOARD_INFO("adv7343", 0x2A),
> +	},
> +	{
> +		I2C_BOARD_INFO("ths7303", 0x2C),
> +	},
> +	{
> +		I2C_BOARD_INFO("cpld_video", 0x3B),
> +	},
>  };
>  
>  static struct davinci_i2c_platform_data i2c_pdata = {
> @@ -107,10 +166,59 @@ static struct davinci_i2c_platform_data i2c_pdata = {
>  	.bus_delay      = 0 /* usec */,
>  };
>  
> +static int set_vpif_clock(int mux_mode, int hd)
> +{
> +	int val = 0;
> +	int err = 0;
> +	unsigned int value;
> +	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> +
> +	/* disable the clock */
> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> +	value |= (VIDCH3CLK | VIDCH2CLK);
> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
> +
> +	val = i2c_smbus_read_byte(cpld_client);
> +	if (val < 0)
> +		return val;
> +
> +	if (mux_mode == 1)
> +		val &= ~0x40;
> +	else
> +		val |= 0x40;
> +
> +	err = i2c_smbus_write_byte(cpld_client, val);
> +	if (err)
> +		return err;
> +
> +	value = __raw_readl(base + VIDCLKCTL_OFFSET);
> +	value &= ~(VCH2CLK_MASK);
> +	value &= ~(VCH3CLK_MASK);
> +
> +	if (hd >= 1)
> +		value |= (VCH2CLK_SYSCLK8 | VCH3CLK_SYSCLK8);
> +	else
> +		value |= (VCH2CLK_AUXCLK | VCH3CLK_AUXCLK);
> +
> +	__raw_writel(value, base + VIDCLKCTL_OFFSET);
> +
> +	/* enable the clock */
> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> +	value &= ~(VIDCH3CLK | VIDCH2CLK);
> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
> +
> +	return 0;
> +}
> +
> +static struct dm646x_vpif_config vpif_config = {
> +	.set_clock	= set_vpif_clock,
> +};
> +
>  static void __init evm_init_i2c(void)
>  {
>  	davinci_init_i2c(&i2c_pdata);
>  	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
> +	evm_init_cpld();
>  }
>  
>  static void __init davinci_map_io(void)
> @@ -123,6 +231,7 @@ static __init void evm_init(void)
>  {
>  	evm_init_i2c();
>  	davinci_serial_init(&uart_config);
> +	dm646x_setup_vpif(&vpif_config);
>  }
>  
>  static __init void davinci_dm646x_evm_irq_init(void)
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
> index af040cf..f069ab9 100644
> --- a/arch/arm/mach-davinci/dm646x.c
> +++ b/arch/arm/mach-davinci/dm646x.c
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/clk.h>
>  #include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
>  
>  #include <mach/dm646x.h>
>  #include <mach/clock.h>
> @@ -24,6 +25,14 @@
>  #include "clock.h"
>  #include "mux.h"
>  
> +#define DAVINCI_VPIF_BASE       0x01C12000
> +#define VDD3P3V_PWDN_OFFSET	(0x48)
> +#define VSCLKDIS_OFFSET		(0x6C)
> +
> +#define VDD3P3V_VID_MASK	(0x0000000F)
> +
> +#define VSCLKDIS_MASK		(0x00000F00)
> +
>  /*
>   * Device specific clocks
>   */
> @@ -230,6 +239,20 @@ static struct clk timer2_clk = {
>  	.flags = ALWAYS_ENABLED, /* no LPSC, always enabled; c.f. spruep9a */
>  };
>  
> +static struct clk vpif0_clk = {
> +	.name = "vpif0",
> +	.parent = &ref_clk,
> +	.lpsc = DM646X_LPSC_VPSSMSTR,
> +	.flags = ALWAYS_ENABLED,
> +};
> +
> +static struct clk vpif1_clk = {
> +	.name = "vpif1",
> +	.parent = &ref_clk,
> +	.lpsc = DM646X_LPSC_VPSSSLV,
> +	.flags = ALWAYS_ENABLED,
> +};
> +
>  struct davinci_clk dm646x_clks[] = {
>  	CLK(NULL, "ref", &ref_clk),
>  	CLK(NULL, "aux", &aux_clkin),
> @@ -260,6 +283,8 @@ struct davinci_clk dm646x_clks[] = {
>  	CLK(NULL, "timer0", &timer0_clk),
>  	CLK(NULL, "timer1", &timer1_clk),
>  	CLK("watchdog", NULL, &timer2_clk),
> +	CLK(NULL, "vpif0", &vpif0_clk),
> +	CLK(NULL, "vpif1", &vpif1_clk),
>  	CLK(NULL, NULL, NULL),
>  };
>  
> @@ -275,6 +300,28 @@ MUX_CFG(DM646X, ATAEN,		0,   0,     1,	  1,	 true)
>  MUX_CFG(DM646X, AUDCK1,		0,   29,    1,	  0,	 false)
>  
>  MUX_CFG(DM646X, AUDCK0,		0,   28,    1,	  0,	 false)
> +
> +MUX_CFG(DM646X, CRGMUX,			0,   24,    7,    5,	 true)
> +
> +MUX_CFG(DM646X, STSOMUX_DISABLE,	0,   22,    3,    0,	 true)
> +
> +MUX_CFG(DM646X, STSIMUX_DISABLE,	0,   20,    3,    0,	 true)
> +
> +MUX_CFG(DM646X, PTSOMUX_DISABLE,	0,   18,    3,    0,	 true)
> +
> +MUX_CFG(DM646X, PTSIMUX_DISABLE,	0,   16,    3,    0,	 true)
> +
> +MUX_CFG(DM646X, STSOMUX,		0,   22,    3,    2,	 true)
> +
> +MUX_CFG(DM646X, STSIMUX,		0,   20,    3,    2,	 true)
> +
> +MUX_CFG(DM646X, PTSOMUX_PARALLEL,	0,   18,    3,    2,	 true)
> +
> +MUX_CFG(DM646X, PTSIMUX_PARALLEL,	0,   16,    3,    2,	 true)
> +
> +MUX_CFG(DM646X, PTSOMUX_SERIAL,		0,   18,    3,    3,	 true)
> +
> +MUX_CFG(DM646X, PTSIMUX_SERIAL,		0,   16,    3,    3,	 true)
>  };
>  
>  /*----------------------------------------------------------------------*/
> @@ -345,8 +392,61 @@ static struct platform_device dm646x_edma_device = {
>  	.resource		= edma_resources,
>  };
>  
> +static u64 vpif_dma_mask = DMA_32BIT_MASK;
> +
> +static struct resource vpif_resource[] = {
> +	{
> +		.start	= DAVINCI_VPIF_BASE,
> +		.end	= DAVINCI_VPIF_BASE + 0x03fff,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start = IRQ_DM646X_VP_VERTINT2,
> +		.end   = IRQ_DM646X_VP_VERTINT2,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = IRQ_DM646X_VP_VERTINT3,
> +		.end   = IRQ_DM646X_VP_VERTINT3,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device vpif_display_dev = {
> +	.name		= "vpif_display",
> +	.id		= -1,
> +	.dev		= {
> +			.dma_mask 		= &vpif_dma_mask,
> +			.coherent_dma_mask	= DMA_32BIT_MASK,
> +	},
> +	.resource	= vpif_resource,
> +	.num_resources	= ARRAY_SIZE(vpif_resource),
> +};
> +
>  /*----------------------------------------------------------------------*/
>  
> +void dm646x_setup_vpif(struct dm646x_vpif_config *config)
> +{
> +	unsigned int value;
> +	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> +
> +	value = __raw_readl(base + VSCLKDIS_OFFSET);
> +	value &= ~VSCLKDIS_MASK;
> +	__raw_writel(value, base + VSCLKDIS_OFFSET);
> +
> +	value = __raw_readl(base + VDD3P3V_PWDN_OFFSET);
> +	value &= ~VDD3P3V_VID_MASK;
> +	__raw_writel(value, base + VDD3P3V_PWDN_OFFSET);
> +
> +	davinci_cfg_reg(DM646X_STSOMUX_DISABLE);
> +	davinci_cfg_reg(DM646X_STSIMUX_DISABLE);
> +	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
> +	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
> +
> +	vpif_display_dev.dev.platform_data = config;
> +
> +	platform_device_register(&vpif_display_dev);
> +}
>  
>  void __init dm646x_init(void)
>  {
> diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
> index d917939..216345c 100644
> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> @@ -12,7 +12,16 @@
>  #define __ASM_ARCH_DM646X_H
>  
>  #include <mach/hardware.h>
> +#include <linux/i2c.h>
>  
>  void __init dm646x_init(void);
>  
> +void dm646x_video_init(void);
> +
> +struct dm646x_vpif_config {
> +	int (*set_clock)(int, int);
> +};
> +
> +void dm646x_setup_vpif(struct dm646x_vpif_config *config);
> +
>  #endif /* __ASM_ARCH_DM646X_H */
> diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
> index cd95629..557bebf 100644
> --- a/arch/arm/mach-davinci/include/mach/mux.h
> +++ b/arch/arm/mach-davinci/include/mach/mux.h
> @@ -109,6 +109,23 @@ enum davinci_dm646x_index {
>  	/* AUDIO Clock */
>  	DM646X_AUDCK1,
>  	DM646X_AUDCK0,
> +
> +	/* CRGEN Control */
> +	DM646X_CRGMUX,
> +
> +	/* VPIF Control */
> +	DM646X_STSOMUX_DISABLE,
> +	DM646X_STSIMUX_DISABLE,
> +	DM646X_PTSOMUX_DISABLE,
> +	DM646X_PTSIMUX_DISABLE,
> +
> +	/* TSIF Control */
> +	DM646X_STSOMUX,
> +	DM646X_STSIMUX,
> +	DM646X_PTSOMUX_PARALLEL,
> +	DM646X_PTSIMUX_PARALLEL,
> +	DM646X_PTSOMUX_SERIAL,
> +	DM646X_PTSIMUX_SERIAL,
>  };
>  
>  enum davinci_dm355_index {
> -- 
> 1.5.6
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
