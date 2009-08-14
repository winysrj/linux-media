Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36836 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZHNVBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 17:01:47 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	khilman@deeprootsystems.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif capture driver
Date: Fri, 14 Aug 2009 17:01:41 -0400
Message-Id: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch makes the following changes:-
	1) Modify vpif_subdev_info to add board_info, routing information
	   and vpif interface configuration. Remove addr since it is
	   part of board_info
	 
	2) Add code to setup channel mode and input decoder path for
	   vpif capture driver

Also incorporated comments against version v0 of the patch series and
added a spinlock to protect writes to common registers

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to DaVinci tree
 arch/arm/mach-davinci/board-dm646x-evm.c    |  227 ++++++++++++++++++++++++--
 arch/arm/mach-davinci/dm646x.c              |   52 ++++++-
 arch/arm/mach-davinci/include/mach/dm646x.h |   49 +++++-
 3 files changed, 298 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 8c88fd0..c8c65d8 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -33,7 +33,7 @@
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pcf857x.h>
 #include <linux/etherdevice.h>
-
+#include <media/tvp514x.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -63,8 +63,8 @@
 #define DM646X_EVM_PHY_MASK		(0x2)
 #define DM646X_EVM_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
 
-#define VIDCLKCTL_OFFSET	(0x38)
-#define VSCLKDIS_OFFSET		(0x6c)
+#define VIDCLKCTL_OFFSET	(DAVINCI_SYSTEM_MODULE_BASE + 0x38)
+#define VSCLKDIS_OFFSET		(DAVINCI_SYSTEM_MODULE_BASE + 0x6c)
 
 #define VCH2CLK_MASK		(BIT_MASK(10) | BIT_MASK(9) | BIT_MASK(8))
 #define VCH2CLK_SYSCLK8		(BIT(9))
@@ -75,6 +75,18 @@
 
 #define VIDCH2CLK		(BIT(10))
 #define VIDCH3CLK		(BIT(11))
+#define VIDCH1CLK		(BIT(4))
+#define TVP7002_INPUT		(BIT(4))
+#define TVP5147_INPUT		(~BIT(4))
+#define VPIF_INPUT_ONE_CHANNEL	(BIT(5))
+#define VPIF_INPUT_TWO_CHANNEL	(~BIT(5))
+#define TVP5147_CH0		"tvp514x-0"
+#define TVP5147_CH1		"tvp514x-1"
+
+static void __iomem *vpif_vidclkctl_reg;
+static void __iomem *vpif_vsclkdis_reg;
+/* spin lock for updating above registers */
+static spinlock_t vpif_reg_lock;
 
 static struct davinci_uart_config uart_config __initdata = {
 	.enabled_uarts = (1 << 0),
@@ -348,7 +360,7 @@ static struct i2c_board_info __initdata i2c_info[] =  {
 		I2C_BOARD_INFO("cpld_reg0", 0x3a),
 	},
 	{
-		I2C_BOARD_INFO("cpld_video", 0x3B),
+		I2C_BOARD_INFO("cpld_video", 0x3b),
 	},
 };
 
@@ -359,18 +371,20 @@ static struct davinci_i2c_platform_data i2c_pdata = {
 
 static int set_vpif_clock(int mux_mode, int hd)
 {
+	unsigned long flags;
+	unsigned int value;
 	int val = 0;
 	int err = 0;
-	unsigned int value;
-	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
 
-	if (!cpld_client)
+	if (!vpif_vidclkctl_reg || !vpif_vsclkdis_reg || !cpld_client)
 		return -ENXIO;
 
 	/* disable the clock */
-	value = __raw_readl(base + VSCLKDIS_OFFSET);
+	spin_lock_irqsave(&vpif_reg_lock, flags);
+	value = __raw_readl(vpif_vsclkdis_reg);
 	value |= (VIDCH3CLK | VIDCH2CLK);
-	__raw_writel(value, base + VSCLKDIS_OFFSET);
+	__raw_writel(value, vpif_vsclkdis_reg);
+	spin_unlock_irqrestore(&vpif_reg_lock, flags);
 
 	val = i2c_smbus_read_byte(cpld_client);
 	if (val < 0)
@@ -385,7 +399,7 @@ static int set_vpif_clock(int mux_mode, int hd)
 	if (err)
 		return err;
 
-	value = __raw_readl(base + VIDCLKCTL_OFFSET);
+	value = __raw_readl(vpif_vidclkctl_reg);
 	value &= ~(VCH2CLK_MASK);
 	value &= ~(VCH3CLK_MASK);
 
@@ -394,24 +408,30 @@ static int set_vpif_clock(int mux_mode, int hd)
 	else
 		value |= (VCH2CLK_AUXCLK | VCH3CLK_AUXCLK);
 
-	__raw_writel(value, base + VIDCLKCTL_OFFSET);
+	__raw_writel(value, vpif_vidclkctl_reg);
 
 	/* enable the clock */
-	value = __raw_readl(base + VSCLKDIS_OFFSET);
+	spin_lock_irqsave(&vpif_reg_lock, flags);
+	value = __raw_readl(vpif_vsclkdis_reg);
 	value &= ~(VIDCH3CLK | VIDCH2CLK);
-	__raw_writel(value, base + VSCLKDIS_OFFSET);
+	__raw_writel(value, vpif_vsclkdis_reg);
+	spin_unlock_irqrestore(&vpif_reg_lock, flags);
 
 	return 0;
 }
 
-static const struct vpif_subdev_info dm646x_vpif_subdev[] = {
+static struct vpif_subdev_info dm646x_vpif_subdev[] = {
 	{
-		.addr	= 0x2A,
 		.name	= "adv7343",
+		.board_info = {
+			I2C_BOARD_INFO("adv7343", 0x2a),
+		},
 	},
 	{
-		.addr	= 0x2C,
 		.name	= "ths7303",
+		.board_info = {
+			I2C_BOARD_INFO("ths7303", 0x2c),
+		},
 	},
 };
 
@@ -421,7 +441,7 @@ static const char *output[] = {
 	"S-Video",
 };
 
-static struct vpif_config dm646x_vpif_config = {
+static struct vpif_display_config dm646x_vpif_display_config = {
 	.set_clock	= set_vpif_clock,
 	.subdevinfo	= dm646x_vpif_subdev,
 	.subdev_count	= ARRAY_SIZE(dm646x_vpif_subdev),
@@ -430,6 +450,177 @@ static struct vpif_config dm646x_vpif_config = {
 	.card_name	= "DM646x EVM",
 };
 
+/**
+ * setup_vpif_input_path()
+ * @channel: channel id (0 - CH0, 1 - CH1)
+ * @sub_dev_name: ptr sub device name
+ *
+ * This will set vpif input to capture data from tvp514x or
+ * tvp7002.
+ */
+static int setup_vpif_input_path(int channel, const char *sub_dev_name)
+{
+	int err = 0;
+	int val;
+
+	/* for channel 1, we don't do anything */
+	if (channel != 0)
+		return 0;
+
+	if (!cpld_client)
+		return -ENXIO;
+
+	val = i2c_smbus_read_byte(cpld_client);
+	if (val < 0)
+		return val;
+
+	if (!strcmp(sub_dev_name, TVP5147_CH0) ||
+	    !strcmp(sub_dev_name, TVP5147_CH1))
+		val &= TVP5147_INPUT;
+	else
+		val |= TVP7002_INPUT;
+
+	err = i2c_smbus_write_byte(cpld_client, val);
+	if (err)
+		return err;
+	return 0;
+}
+
+/**
+ * setup_vpif_input_channel_mode()
+ * @mux_mode:  mux mode. 0 - 1 channel or (1) - 2 channel
+ *
+ * This will setup input mode to one channel (TVP7002) or 2 channel (TVP5147)
+ */
+static int setup_vpif_input_channel_mode(int mux_mode)
+{
+	unsigned long flags;
+	int err = 0;
+	int val;
+	u32 value;
+
+	if (!vpif_vsclkdis_reg || !cpld_client)
+		return -ENXIO;
+
+	val = i2c_smbus_read_byte(cpld_client);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&vpif_reg_lock, flags);
+	value = __raw_readl(vpif_vsclkdis_reg);
+	if (mux_mode) {
+		val &= VPIF_INPUT_TWO_CHANNEL;
+		value |= VIDCH1CLK;
+	} else {
+		val |= VPIF_INPUT_ONE_CHANNEL;
+		value &= ~VIDCH1CLK;
+	}
+	__raw_writel(value, vpif_vsclkdis_reg);
+	spin_unlock_irqrestore(&vpif_reg_lock, flags);
+
+	err = i2c_smbus_write_byte(cpld_client, val);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct tvp514x_platform_data tvp5146_pdata = {
+	.clk_polarity = 0,
+	.hs_polarity = 1,
+	.vs_polarity = 1
+};
+
+#define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
+
+static struct vpif_subdev_info vpif_capture_sdev_info[] = {
+	{
+		.name	= TVP5147_CH0,
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5d),
+			.platform_data = &tvp5146_pdata,
+		},
+		.input = INPUT_CVBS_VI2B,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+		.can_route = 1,
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol = 1,
+			.vd_pol = 1,
+			.fid_pol = 0,
+		},
+	},
+	{
+		.name	= TVP5147_CH1,
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5c),
+			.platform_data = &tvp5146_pdata,
+		},
+		.input = INPUT_SVIDEO_VI2C_VI1C,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+		.can_route = 1,
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol = 1,
+			.vd_pol = 1,
+			.fid_pol = 0,
+		},
+	},
+};
+
+static const struct vpif_input dm6467_ch0_inputs[] = {
+	{
+		.input = {
+			.index = 0,
+			.name = "Composite",
+			.type = V4L2_INPUT_TYPE_CAMERA,
+			.std = TVP514X_STD_ALL,
+		},
+		.subdev_name = TVP5147_CH0,
+	},
+};
+
+static const struct vpif_input dm6467_ch1_inputs[] = {
+       {
+		.input = {
+			.index = 0,
+			.name = "S-Video",
+			.type = V4L2_INPUT_TYPE_CAMERA,
+			.std = TVP514X_STD_ALL,
+		},
+		.subdev_name = TVP5147_CH1,
+	},
+};
+
+static struct vpif_capture_config dm646x_vpif_capture_cfg = {
+	.setup_input_path = setup_vpif_input_path,
+	.setup_input_channel_mode = setup_vpif_input_channel_mode,
+	.subdev_info = vpif_capture_sdev_info,
+	.subdev_count = ARRAY_SIZE(vpif_capture_sdev_info),
+	.chan_config[0] = {
+		.inputs = dm6467_ch0_inputs,
+		.input_count = ARRAY_SIZE(dm6467_ch0_inputs),
+	},
+	.chan_config[1] = {
+		.inputs = dm6467_ch1_inputs,
+		.input_count = ARRAY_SIZE(dm6467_ch1_inputs),
+	},
+};
+
+static void __init evm_init_video(void)
+{
+	vpif_vidclkctl_reg = ioremap(VIDCLKCTL_OFFSET, 4);
+	vpif_vsclkdis_reg = ioremap(VSCLKDIS_OFFSET, 4);
+	if (!vpif_vidclkctl_reg || !vpif_vsclkdis_reg) {
+		pr_err("Can't map VPIF VIDCLKCTL or VSCLKDIS registers\n");
+		return;
+	}
+	spin_lock_init(&vpif_reg_lock);
+
+	dm646x_setup_vpif(&dm646x_vpif_display_config,
+			  &dm646x_vpif_capture_cfg);
+}
+
 static void __init evm_init_i2c(void)
 {
 	davinci_init_i2c(&i2c_pdata);
@@ -457,7 +648,7 @@ static __init void evm_init(void)
 
 	soc_info->emac_pdata->phy_mask = DM646X_EVM_PHY_MASK;
 	soc_info->emac_pdata->mdio_max_freq = DM646X_EVM_MDIO_FREQUENCY;
-	dm646x_setup_vpif(&dm646x_vpif_config);
+	evm_init_video();
 }
 
 static __init void davinci_dm646x_evm_irq_init(void)
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index a9b20e5..0976049 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -700,9 +700,23 @@ static u64 vpif_dma_mask = DMA_BIT_MASK(32);
 static struct resource vpif_resource[] = {
 	{
 		.start	= DAVINCI_VPIF_BASE,
-		.end	= DAVINCI_VPIF_BASE + 0x03fff,
+		.end	= DAVINCI_VPIF_BASE + 0x03ff,
 		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device vpif_dev = {
+	.name		= "vpif",
+	.id		= -1,
+	.dev		= {
+			.dma_mask 		= &vpif_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
+	.resource	= vpif_resource,
+	.num_resources	= ARRAY_SIZE(vpif_resource),
+};
+
+static struct resource vpif_display_resource[] = {
 	{
 		.start = IRQ_DM646X_VP_VERTINT2,
 		.end   = IRQ_DM646X_VP_VERTINT2,
@@ -722,8 +736,32 @@ static struct platform_device vpif_display_dev = {
 			.dma_mask 		= &vpif_dma_mask,
 			.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
-	.resource	= vpif_resource,
-	.num_resources	= ARRAY_SIZE(vpif_resource),
+	.resource	= vpif_display_resource,
+	.num_resources	= ARRAY_SIZE(vpif_display_resource),
+};
+
+static struct resource vpif_capture_resource[] = {
+	{
+		.start = IRQ_DM646X_VP_VERTINT0,
+		.end   = IRQ_DM646X_VP_VERTINT0,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.start = IRQ_DM646X_VP_VERTINT1,
+		.end   = IRQ_DM646X_VP_VERTINT1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vpif_capture_dev = {
+	.name		= "vpif_capture",
+	.id		= -1,
+	.dev		= {
+			.dma_mask 		= &vpif_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.resource	= vpif_capture_resource,
+	.num_resources	= ARRAY_SIZE(vpif_capture_resource),
 };
 
 /*----------------------------------------------------------------------*/
@@ -854,7 +892,8 @@ void __init dm646x_init_mcasp1(struct snd_platform_data *pdata)
 	platform_device_register(&dm646x_dit_device);
 }
 
-void dm646x_setup_vpif(struct vpif_config *config)
+void dm646x_setup_vpif(struct vpif_display_config *display_config,
+		       struct vpif_capture_config *capture_config)
 {
 	unsigned int value;
 	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
@@ -872,8 +911,11 @@ void dm646x_setup_vpif(struct vpif_config *config)
 	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
 	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
 
-	vpif_display_dev.dev.platform_data = config;
+	vpif_display_dev.dev.platform_data = display_config;
+	vpif_capture_dev.dev.platform_data = capture_config;
+	platform_device_register(&vpif_dev);
 	platform_device_register(&vpif_display_dev);
+	platform_device_register(&vpif_capture_dev);
 }
 
 void __init dm646x_init(void)
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
index 792c226..8cec746 100644
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -14,6 +14,8 @@
 #include <mach/hardware.h>
 #include <mach/emac.h>
 #include <mach/asp.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
 
 #define DM646X_EMAC_BASE		(0x01C80000)
 #define DM646X_EMAC_CNTRL_OFFSET	(0x0000)
@@ -31,26 +33,59 @@ void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
 
 void dm646x_video_init(void);
 
-struct vpif_output {
-	u16 id;
-	const char *name;
+enum vpif_if_type {
+	VPIF_IF_BT656,
+	VPIF_IF_BT1120,
+	VPIF_IF_RAW_BAYER
+};
+
+struct vpif_interface {
+	enum vpif_if_type if_type;
+	unsigned hd_pol:1;
+	unsigned vd_pol:1;
+	unsigned fid_pol:1;
 };
 
 struct vpif_subdev_info {
-	unsigned short addr;
 	const char *name;
+	struct i2c_board_info board_info;
+	u32 input;
+	u32 output;
+	unsigned can_route:1;
+	struct vpif_interface vpif_if;
 };
 
-struct vpif_config {
+struct vpif_display_config {
 	int (*set_clock)(int, int);
-	const struct vpif_subdev_info *subdevinfo;
+	struct vpif_subdev_info *subdevinfo;
 	int subdev_count;
 	const char **output;
 	int output_count;
 	const char *card_name;
 };
 
+struct vpif_input {
+	struct v4l2_input input;
+	const char *subdev_name;
+};
+
+#define VPIF_CAPTURE_MAX_CHANNELS	2
+
+struct vpif_capture_chan_config {
+	const struct vpif_input *inputs;
+	int input_count;
+};
+
+struct vpif_capture_config {
+	int (*setup_input_channel_mode)(int);
+	int (*setup_input_path)(int, const char *);
+	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
+	struct vpif_subdev_info *subdev_info;
+	int subdev_count;
+	const char *card_name;
+};
 
-void dm646x_setup_vpif(struct vpif_config *config);
+void dm646x_setup_vpif(struct vpif_display_config *,
+		       struct vpif_capture_config *);
 
 #endif /* __ASM_ARCH_DM646X_H */
-- 
1.6.0.4

