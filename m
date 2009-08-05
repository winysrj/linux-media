Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39244 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbZHEFFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 01:05:19 -0400
From: "chaithrika" <chaithrika@ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	<linux@arm.linux.org.uk>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
	<mchehab@infradead.org>, <linux-media@vger.kernel.org>
References: <1248076882-18564-1-git-send-email-chaithrika@ti.com> <A69FA2915331DC488A831521EAE36FE4014518157D@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4014518157D@dlee06.ent.ti.com>
Subject: RE: [PATCH v3] ARM: DaVinci: DM646x Video: Platform and board specific	setup
Date: Wed, 5 Aug 2009 10:33:06 +0530
Message-ID: <007501ca158a$0502f330$0f08d990$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 05, 2009 at 02:45:36, Karicheri, Muralidharan wrote:
> 
> 
> >-----Original Message-----
> >From: davinci-linux-open-source-bounces@linux.davincidsp.com
> >[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
> >Of Subrahmanya, Chaithrika
> >Sent: Monday, July 20, 2009 4:01 AM
> >To: linux@arm.linux.org.uk
> >Cc: davinci-linux-open-source@linux.davincidsp.com;
mchehab@infradead.org;
> >linux-media@vger.kernel.org
> >Subject: [PATCH v3] ARM: DaVinci: DM646x Video: Platform and board
specific
> >setup
> >
> >Platform specific display device setup for DM646x EVM
> >
> >Add platform device and resource structures. Also define a platform
> >specific
> >clock setup function that can be accessed by the driver to configure the
> >clock
> >and CPLD.
> >
> >Signed-off-by: Manjunath Hadli <mrh@ti.com>
> >Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> >Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> >Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> >---
> >Applies to Davinci GIT tree. Minor updates like change in structure name-
> >subdev_info to vpif_subdev_info and correction to VDD3P3V_VID_MASK value.
> >
> > arch/arm/mach-davinci/board-dm646x-evm.c    |  125
> >+++++++++++++++++++++++++++
> > arch/arm/mach-davinci/dm646x.c              |   62 +++++++++++++
> > arch/arm/mach-davinci/include/mach/dm646x.h |   24 +++++
> > 3 files changed, 211 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-
> >davinci/board-dm646x-evm.c
> >index b1bf18c..8c88fd0 100644
> >--- a/arch/arm/mach-davinci/board-dm646x-evm.c
> >+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> >@@ -63,6 +63,19 @@
> > #define DM646X_EVM_PHY_MASK		(0x2)
> > #define DM646X_EVM_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
> >
> >+#define VIDCLKCTL_OFFSET	(0x38)
> >+#define VSCLKDIS_OFFSET		(0x6c)
> >+
> >+#define VCH2CLK_MASK		(BIT_MASK(10) | BIT_MASK(9) |
BIT_MASK(8))
> >+#define VCH2CLK_SYSCLK8		(BIT(9))
> >+#define VCH2CLK_AUXCLK		(BIT(9) | BIT(8))
> >+#define VCH3CLK_MASK		(BIT_MASK(14) | BIT_MASK(13) |
BIT_MASK(12))
> >+#define VCH3CLK_SYSCLK8		(BIT(13))
> >+#define VCH3CLK_AUXCLK		(BIT(14) | BIT(13))
> >+
> >+#define VIDCH2CLK		(BIT(10))
> >+#define VIDCH3CLK		(BIT(11))
> >+
> > static struct davinci_uart_config uart_config __initdata = {
> > 	.enabled_uarts = (1 << 0),
> > };
> >@@ -288,6 +301,40 @@ static struct snd_platform_data
dm646x_evm_snd_data[]
> >= {
> > 	},
> > };
> >
> >+static struct i2c_client *cpld_client;
> >+
> >+static int cpld_video_probe(struct i2c_client *client,
> >+			const struct i2c_device_id *id)
> >+{
> >+	cpld_client = client;
> >+	return 0;
> >+}
> >+
> >+static int __devexit cpld_video_remove(struct i2c_client *client)
> >+{
> >+	cpld_client = NULL;
> >+	return 0;
> >+}
> >+
> >+static const struct i2c_device_id cpld_video_id[] = {
> >+	{ "cpld_video", 0 },
> >+	{ }
> >+};
> >+
> >+static struct i2c_driver cpld_video_driver = {
> >+	.driver = {
> >+		.name	= "cpld_video",
> >+	},
> >+	.probe		= cpld_video_probe,
> >+	.remove		= cpld_video_remove,
> >+	.id_table	= cpld_video_id,
> >+};
> >+
> >+static void evm_init_cpld(void)
> >+{
> >+	i2c_add_driver(&cpld_video_driver);
> >+}
> >+
> > static struct i2c_board_info __initdata i2c_info[] =  {
> > 	{
> > 		I2C_BOARD_INFO("24c256", 0x50),
> >@@ -300,6 +347,9 @@ static struct i2c_board_info __initdata i2c_info[] =
{
> > 	{
> > 		I2C_BOARD_INFO("cpld_reg0", 0x3a),
> > 	},
> >+	{
> >+		I2C_BOARD_INFO("cpld_video", 0x3B),
> >+	},
> > };
> >
> > static struct davinci_i2c_platform_data i2c_pdata = {
> >@@ -307,11 +357,85 @@ static struct davinci_i2c_platform_data i2c_pdata =
{
> > 	.bus_delay      = 0 /* usec */,
> > };
> >
> >+static int set_vpif_clock(int mux_mode, int hd)
> >+{
> >+	int val = 0;
> >+	int err = 0;
> >+	unsigned int value;
> >+	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> >+
> >+	if (!cpld_client)
> >+		return -ENXIO;
> >+
> >+	/* disable the clock */
> >+	value = __raw_readl(base + VSCLKDIS_OFFSET);
> >+	value |= (VIDCH3CLK | VIDCH2CLK);
> >+	__raw_writel(value, base + VSCLKDIS_OFFSET);
> >+
> >+	val = i2c_smbus_read_byte(cpld_client);
> >+	if (val < 0)
> >+		return val;
> >+
> >+	if (mux_mode == 1)
> >+		val &= ~0x40;
> >+	else
> >+		val |= 0x40;
> >+
> >+	err = i2c_smbus_write_byte(cpld_client, val);
> >+	if (err)
> >+		return err;
> >+
> >+	value = __raw_readl(base + VIDCLKCTL_OFFSET);
> >+	value &= ~(VCH2CLK_MASK);
> >+	value &= ~(VCH3CLK_MASK);
> >+
> >+	if (hd >= 1)
> >+		value |= (VCH2CLK_SYSCLK8 | VCH3CLK_SYSCLK8);
> >+	else
> >+		value |= (VCH2CLK_AUXCLK | VCH3CLK_AUXCLK);
> >+
> >+	__raw_writel(value, base + VIDCLKCTL_OFFSET);
> >+
> >+	/* enable the clock */
> >+	value = __raw_readl(base + VSCLKDIS_OFFSET);
> >+	value &= ~(VIDCH3CLK | VIDCH2CLK);
> >+	__raw_writel(value, base + VSCLKDIS_OFFSET);
> >+
> >+	return 0;
> >+}
> >+
> >+static const struct vpif_subdev_info dm646x_vpif_subdev[] = {
> >+	{
> >+		.addr	= 0x2A,
> >+		.name	= "adv7343",
> >+	},
> >+	{
> >+		.addr	= 0x2C,
> >+		.name	= "ths7303",
> >+	},
> >+};
> >+
> >+static const char *output[] = {
> >+	"Composite",
> >+	"Component",
> >+	"S-Video",
> >+};
> >+
> >+static struct vpif_config dm646x_vpif_config = {
> >+	.set_clock	= set_vpif_clock,
> >+	.subdevinfo	= dm646x_vpif_subdev,
> >+	.subdev_count	= ARRAY_SIZE(dm646x_vpif_subdev),
> >+	.output		= output,
> >+	.output_count	= ARRAY_SIZE(output),
> >+	.card_name	= "DM646x EVM",
> >+};
> >+
> > static void __init evm_init_i2c(void)
> > {
> > 	davinci_init_i2c(&i2c_pdata);
> > 	i2c_add_driver(&dm6467evm_cpld_driver);
> > 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
> >+	evm_init_cpld();
> > }
> >
> > static void __init davinci_map_io(void)
> >@@ -333,6 +457,7 @@ static __init void evm_init(void)
> >
> > 	soc_info->emac_pdata->phy_mask = DM646X_EVM_PHY_MASK;
> > 	soc_info->emac_pdata->mdio_max_freq = DM646X_EVM_MDIO_FREQUENCY;
> >+	dm646x_setup_vpif(&dm646x_vpif_config);
> > }
> >
> > static __init void davinci_dm646x_evm_irq_init(void)
> >diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-
> >davinci/dm646x.c
> >index 8fa2803..a9b20e5 100644
> >--- a/arch/arm/mach-davinci/dm646x.c
> >+++ b/arch/arm/mach-davinci/dm646x.c
> >@@ -32,6 +32,15 @@
> > #include "clock.h"
> > #include "mux.h"
> >
> >+#define DAVINCI_VPIF_BASE       (0x01C12000)
> >+#define VDD3P3V_PWDN_OFFSET	(0x48)
> >+#define VSCLKDIS_OFFSET		(0x6C)
> >+
> >+#define VDD3P3V_VID_MASK	(BIT_MASK(3) | BIT_MASK(2) | BIT_MASK(1) |\
> >+					BIT_MASK(0))
> >+#define VSCLKDIS_MASK		(BIT_MASK(11) | BIT_MASK(10) |
BIT_MASK(9) |\
> >+					BIT_MASK(8))
> >+
> > /*
> >  * Device specific clocks
> >  */
> >@@ -686,6 +695,37 @@ static struct platform_device dm646x_dit_device = {
> > 	.id	= -1,
> > };
> >
> >+static u64 vpif_dma_mask = DMA_BIT_MASK(32);
> >+
> >+static struct resource vpif_resource[] = {
> >+	{
> >+		.start	= DAVINCI_VPIF_BASE,
> >+		.end	= DAVINCI_VPIF_BASE + 0x03fff,
> >+		.flags	= IORESOURCE_MEM,
> >+	},
> >+	{
> >+		.start = IRQ_DM646X_VP_VERTINT2,
> >+		.end   = IRQ_DM646X_VP_VERTINT2,
> >+		.flags = IORESOURCE_IRQ,
> >+	},
> >+	{
> >+		.start = IRQ_DM646X_VP_VERTINT3,
> >+		.end   = IRQ_DM646X_VP_VERTINT3,
> >+		.flags = IORESOURCE_IRQ,
> >+	},
> >+};
> >+
> >+static struct platform_device vpif_display_dev = {
> >+	.name		= "vpif_display",
> >+	.id		= -1,
> >+	.dev		= {
> >+			.dma_mask 		= &vpif_dma_mask,
> >+			.coherent_dma_mask	= DMA_BIT_MASK(32),
> >+	},
> >+	.resource	= vpif_resource,
> >+	.num_resources	= ARRAY_SIZE(vpif_resource),
> >+};
> >+
> >
/*----------------------------------------------------------------------*/
> >
> > static struct map_desc dm646x_io_desc[] = {
> >@@ -814,6 +854,28 @@ void __init dm646x_init_mcasp1(struct
> >snd_platform_data *pdata)
> > 	platform_device_register(&dm646x_dit_device);
> > }
> >
> >+void dm646x_setup_vpif(struct vpif_config *config)
> >+{
> >+	unsigned int value;
> >+	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> >+
> >+	value = __raw_readl(base + VSCLKDIS_OFFSET);
> >+	value &= ~VSCLKDIS_MASK;
> >+	__raw_writel(value, base + VSCLKDIS_OFFSET);
> >+
> >+	value = __raw_readl(base + VDD3P3V_PWDN_OFFSET);
> >+	value &= ~VDD3P3V_VID_MASK;
> >+	__raw_writel(value, base + VDD3P3V_PWDN_OFFSET);
> >+
> >+	davinci_cfg_reg(DM646X_STSOMUX_DISABLE);
> >+	davinci_cfg_reg(DM646X_STSIMUX_DISABLE);
> >+	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
> >+	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
> >+
> >+	vpif_display_dev.dev.platform_data = config;
> >+	platform_device_register(&vpif_display_dev);
> >+}
> >+
> > void __init dm646x_init(void)
> > {
> > 	davinci_common_init(&davinci_soc_info_dm646x);
> >diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-
> >davinci/include/mach/dm646x.h
> >index feb1e02..1ac424c 100644
> >--- a/arch/arm/mach-davinci/include/mach/dm646x.h
> >+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> >@@ -29,4 +29,28 @@ void __init dm646x_init_ide(void);
> > void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
> > void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
> >
> >+void dm646x_video_init(void);
> >+
> >+struct vpif_output {
> >+	u16 id;
> >+	const char *name;
> >+};
> >+
> >+struct vpif_subdev_info {
> >+	unsigned short addr;
> >+	const char *name;
> >+};
> >+
> >+struct vpif_config {
> >+	int (*set_clock)(int, int);
> >+	const struct subdev_info *subdevinfo;
> Shouldn't this change as well to below?
> const struct vpif_subdev_info *subdevinfo;

Yes, it should be, will submit an updated patch soon.

Thanks,
Chaithrika

> 
> >+	int subdev_count;
> >+	const char **output;
> >+	int output_count;
> >+	const char *card_name;
> >+};
> >+
> >+
> >+void dm646x_setup_vpif(struct vpif_config *config);
> >+
> > #endif /* __ASM_ARCH_DM646X_H */
> >--
> >1.5.6
> >
> >_______________________________________________
> >Davinci-linux-open-source mailing list
> >Davinci-linux-open-source@linux.davincidsp.com
> >http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Chaithrika


