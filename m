Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51485 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0FCKxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 06:53:07 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 3 Jun 2010 16:22:48 +0530
Subject: RE: [PATCH-V1 2/2] AM3517: Add VPFE Capture driver support to board
 file
Message-ID: <19F8576C6E063C45BE387C64729E7394044E6D3188@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1275547321-31406-3-git-send-email-hvaibhav@ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0323207C30@dbde02.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044E6D30D6@dbde02.ent.ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0323207C6B@dbde02.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044E6D30E1@dbde02.ent.ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB0323207CE5@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0323207CE5@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: DebBarma, Tarun Kanti
> Sent: Thursday, June 03, 2010 2:46 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; Karicheri, Muralidharan; linux-omap@vger.kernel.org
> Subject: RE: [PATCH-V1 2/2] AM3517: Add VPFE Capture driver support to board
> file
> 
<snip>
> > > > > > +		break;
> > > > > > +	/* Clear all interrrupts */
> > > > > > +	default:
> > > > > > +		vpfe_int_clr &= ~(AM35XX_VPFE_CCDC_VD0_INT_CLR |
> > > > > > +				AM35XX_VPFE_CCDC_VD1_INT_CLR |
> > > > > > +				AM35XX_VPFE_CCDC_VD2_INT_CLR);
> > > > > > +		vpfe_int_clr |= (AM35XX_VPFE_CCDC_VD0_INT_CLR |
> > > > > > +				AM35XX_VPFE_CCDC_VD1_INT_CLR |
> > > > > > +				AM35XX_VPFE_CCDC_VD2_INT_CLR);
> > > > > > +		break;
> > > > > > +	}
> > > > > > +	omap_ctrl_writel(vpfe_int_clr, AM35XX_CONTROL_LVL_INTR_CLEAR);
> > > > > > +	vpfe_int_clr = omap_ctrl_readl(AM35XX_CONTROL_LVL_INTR_CLEAR);
> > > > >
> > > > > Is it necessary to assign to the local variable (vpfe_int_clr)? If
> > not,
> > > > we
> > > > > can reduce the size of this routine by two assembly instructions:
> > > > > One: copying the result to a register
> > > > > Two: pushing the register value to stack
> > > > >
> > > > [Hiremath, Vaibhav] How are you going to achieve this? How are you
> > going
> > > > to define the switch case values here?
> > >
> > > [Tarun] I am only referring to the last statement, outside the switch()
> > > statement.
> > [Hiremath, Vaibhav] Ohhh Ok.
> > It is required; actually the read operation is required to push/reflect
> > the value written to register. In the past we have seen issues like write
> > is not getting reflected immediately leading to spurious interrupts.
> 
> [Tarun Kanti DebBarma]
> Well, I understand & agree that the read is needed. What I am saying is
> whether the assignment to local variable is needed.
> 
[Hiremath, Vaibhav] Tarun,

Don't you think compiler will anyway take care of this, below is the output of objdump


c003aef8:       e3000594        movw    r0, #1428       ; 0x594
c003aef0:       e3001594        movw    r1, #1428       ; 0x594
c003aef4:       ebffe7fb        bl      c0034ee8 <omap_ctrl_writel> 
c003aefc:       e8bd4010        pop     {r4, lr}
c003af00:       eaffe7e9        b       c0034eac <omap_ctrl_readl>

Thanks,
Vaibhav

> >
> > Thanks,
> > Vaibhav
> > > >
> > > > Also currently this covers only VPFE Capture related interrupts but
> > this
> > > > function may required for other modules which are part of IPSS, like
> > HECC,
> > > > EMAC and USBOTG.
> > > >
> > > > Thanks,
> > > > Vaibhav
> > > >
> > > > > -Tarun
> > > > >
> > > > >
> > > > > > +}
> > > > > > +
> > > > > > +static struct vpfe_config vpfe_cfg = {
> > > > > > +	.num_subdevs	= ARRAY_SIZE(vpfe_sub_devs),
> > > > > > +	.i2c_adapter_id	= 3,
> > > > > > +	.sub_devs	= vpfe_sub_devs,
> > > > > > +	.clr_intr	= am3517_evm_clear_vpfe_intr,
> > > > > > +	.card_name	= "AM3517 EVM",
> > > > > > +	.ccdc		= "DM6446 CCDC",
> > > > > > +};
> > > > > > +
> > > > > > +static struct resource vpfe_resources[] = {
> > > > > > +	{
> > > > > > +		.start	= INT_35XX_CCDC_VD0_IRQ,
> > > > > > +		.end	= INT_35XX_CCDC_VD0_IRQ,
> > > > > > +		.flags	= IORESOURCE_IRQ,
> > > > > > +	},
> > > > > > +	{
> > > > > > +		.start	= INT_35XX_CCDC_VD1_IRQ,
> > > > > > +		.end	= INT_35XX_CCDC_VD1_IRQ,
> > > > > > +		.flags	= IORESOURCE_IRQ,
> > > > > > +	},
> > > > > > +};
> > > > > > +
> > > > > > +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> > > > > > +static struct platform_device vpfe_capture_dev = {
> > > > > > +	.name		= CAPTURE_DRV_NAME,
> > > > > > +	.id		= -1,
> > > > > > +	.num_resources	= ARRAY_SIZE(vpfe_resources),
> > > > > > +	.resource	= vpfe_resources,
> > > > > > +	.dev = {
> > > > > > +		.dma_mask		= &vpfe_capture_dma_mask,
> > > > > > +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> > > > > > +		.platform_data		= &vpfe_cfg,
> > > > > > +	},
> > > > > > +};
> > > > > > +
> > > > > > +static struct resource am3517_ccdc_resource[] = {
> > > > > > +	/* CCDC Base address */
> > > > > > +	{
> > > > > > +		.start	= AM35XX_IPSS_VPFE_BASE,
> > > > > > +		.end	= AM35XX_IPSS_VPFE_BASE + 0xffff,
> > > > > > +		.flags	= IORESOURCE_MEM,
> > > > > > +	},
> > > > > > +};
> > > > > > +
> > > > > > +static struct platform_device am3517_ccdc_dev = {
> > > > > > +	.name		= "dm644x_ccdc",
> > > > > > +	.id		= -1,
> > > > > > +	.num_resources	= ARRAY_SIZE(am3517_ccdc_resource),
> > > > > > +	.resource	= am3517_ccdc_resource,
> > > > > > +	.dev = {
> > > > > > +		.dma_mask		= &vpfe_capture_dma_mask,
> > > > > > +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> > > > > > +	},
> > > > > > +};
> > > > > > +
> > > > > >  static struct i2c_board_info __initdata am3517evm_i2c_boardinfo[]
> > = {
> > > > > >  	{
> > > > > >  		I2C_BOARD_INFO("s35390a", 0x30),
> > > > > > @@ -46,6 +199,7 @@ static struct i2c_board_info __initdata
> > > > > > am3517evm_i2c_boardinfo[] = {
> > > > > >  	},
> > > > > >  };
> > > > > >
> > > > > > +
> > > > > >  /*
> > > > > >   * RTC - S35390A
> > > > > >   */
> > > > > > @@ -261,6 +415,8 @@ static struct omap_board_config_kernel
> > > > > > am3517_evm_config[] __initdata = {
> > > > > >
> > > > > >  static struct platform_device *am3517_evm_devices[] __initdata =
> > {
> > > > > >  	&am3517_evm_dss_device,
> > > > > > +	&am3517_ccdc_dev,
> > > > > > +	&vpfe_capture_dev,
> > > > > >  };
> > > > > >
> > > > > >  static void __init am3517_evm_init_irq(void)
> > > > > > @@ -313,6 +469,11 @@ static void __init am3517_evm_init(void)
> > > > > >
> > > > > >  	i2c_register_board_info(1, am3517evm_i2c_boardinfo,
> > > > > >  				ARRAY_SIZE(am3517evm_i2c_boardinfo));
> > > > > > +
> > > > > > +	clk_add_alias("master", "dm644x_ccdc", "master",
> > > > > > +			&vpfe_capture_dev.dev);
> > > > > > +	clk_add_alias("slave", "dm644x_ccdc", "slave",
> > > > > > +			&vpfe_capture_dev.dev);
> > > > > >  }
> > > > > >
> > > > > >  static void __init am3517_evm_map_io(void)
> > > > > > --
> > > > > > 1.6.2.4
> > > > > >
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-
> > omap"
> > > > in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
