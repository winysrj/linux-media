Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:41368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0JYU0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 16:26:31 -0400
Received: from 201-68-231-211.dsl.telesp.net.br ([201.68.231.211] helo=[192.168.30.170])
	by casper.infradead.org with esmtpsa (Exim 4.72 #1 (Red Hat Linux))
	id 1PATci-0007LS-4N
	for linux-media@vger.kernel.org; Mon, 25 Oct 2010 20:26:29 +0000
Message-ID: <4CC5E7F0.3080408@infradead.org>
Date: Mon, 25 Oct 2010 18:26:24 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fwd: Re: DM1105: could not attach frontend 195d:1105
Content-Type: multipart/mixed;
 boundary="------------070700080707050908040704"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070700080707050908040704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Patchwork lost a few patches, including this one. Probably some database corruption
and a later rollback, since this patch were already a patchwork ID...


Sorry for the noise.

-------- Mensagem original --------
Assunto: Re: DM1105: could not attach frontend 195d:1105
Data: Sat, 23 Oct 2010 12:20:51 +0300
De: Igor M. Liplianin <liplianin@me.by>
Para: Hendrik Skarpeid <skarp@online.no>,	Mauro Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,	Nameer Kazzaz <nameer.kazzaz@gmail.com>

В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
> Igor M. Liplianin skrev:
> > On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
> >> Igor M. Liplianin wrote:
> >>> Now to find GPIO's for LNB power control and ... watch TV :)
> >> 
> >> Yep. No succesful tuning at the moment. There might also be an issue
> >> with the reset signal and writing to GPIOCTR, as the module at the
> >> moment loads succesfully only once.
> >> As far as I can make out, the LNB power control is probably GPIO 16 and
> >> 17, not sure which is which, and how they work.
> >> GPIO15 is wired to tuner #reset
> > 
> > New patch to test
> 
> I think the LNB voltage may be a little to high on my card, 14.5V and
> 20V. I would be a little more happy if they were 14 and 19, 13 and 18
> would be perfect.
> Anyways, as Igor pointet out, I don't have any signal from the LNB,
> checked with another tuner card. It's a quad LNB, and the other outputs
> are fine. Maybe it's' toasted from to high supply voltage! I little word
> of warning then.
> Anyways, here's my tweaked driver.

Here is reworked patch for clear GPIO's handling.
It allows to support I2C on GPIO's and per board LNB control through GPIO's.
Also incuded support for Hendrik's card.
I think it is clear how to change and test GPIO's for LNB and other stuff now.
To Hendrik:
	Not shure, but there is maybe GPIO for raise/down LNB voltage a little (~1v).
	It is used for long coaxial lines to compensate voltage dropping.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>



--------------070700080707050908040704
Content-Type: text/x-patch;
 name="dm1105_i2c_gpio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dm1105_i2c_gpio.patch"

diff -r abd3aac6644e linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Sat Oct 23 11:58:32 2010 +0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -50,11 +51,12 @@
 
 #define UNSET (-1U)
 
-#define DM1105_BOARD_NOAUTO		UNSET
-#define DM1105_BOARD_UNKNOWN		0
-#define DM1105_BOARD_DVBWORLD_2002	1
-#define DM1105_BOARD_DVBWORLD_2004	2
-#define DM1105_BOARD_AXESS_DM05		3
+#define DM1105_BOARD_NOAUTO			UNSET
+#define DM1105_BOARD_UNKNOWN			0
+#define DM1105_BOARD_DVBWORLD_2002		1
+#define DM1105_BOARD_DVBWORLD_2004		2
+#define DM1105_BOARD_AXESS_DM05			3
+#define DM1105_BOARD_UNBRANDED_I2C_ON_GPIO	4
 
 /* ----------------------------------------------- */
 /*
@@ -158,22 +160,38 @@
 #define DM1105_MAX				0x04
 
 #define DRIVER_NAME				"dm1105"
+#define DM1105_I2C_GPIO_NAME			"dm1105-gpio"
 
 #define DM1105_DMA_PACKETS			47
 #define DM1105_DMA_PACKET_LENGTH		(128*4)
 #define DM1105_DMA_BYTES			(128 * 4 * DM1105_DMA_PACKETS)
 
+/*  */
+#define GPIO08					(1 << 8)
+#define GPIO13					(1 << 13)
+#define GPIO14					(1 << 14)
+#define GPIO15					(1 << 15)
+#define GPIO16					(1 << 16)
+#define GPIO17					(1 << 17)
+#define GPIO_ALL				0x03ffff
+
 /* GPIO's for LNB power control */
-#define DM1105_LNB_MASK				0x00000000
-#define DM1105_LNB_OFF				0x00020000
-#define DM1105_LNB_13V				0x00010100
-#define DM1105_LNB_18V				0x00000100
+#define DM1105_LNB_MASK				(GPIO_ALL & ~(GPIO14 | GPIO13))
+#define DM1105_LNB_OFF				GPIO17
+#define DM1105_LNB_13V				(GPIO16 | GPIO08)
+#define DM1105_LNB_18V				GPIO08
 
 /* GPIO's for LNB power control for Axess DM05 */
-#define DM05_LNB_MASK				0x00000000
-#define DM05_LNB_OFF				0x00020000/* actually 13v */
-#define DM05_LNB_13V				0x00020000
-#define DM05_LNB_18V				0x00030000
+#define DM05_LNB_MASK				(GPIO_ALL & ~(GPIO14 | GPIO13))
+#define DM05_LNB_OFF				GPIO17/* actually 13v */
+#define DM05_LNB_13V				GPIO17
+#define DM05_LNB_18V				(GPIO17 | GPIO16)
+
+/* GPIO's for LNB power control for unbranded with I2C on GPIO */
+#define UNBR_LNB_MASK				(GPIO17 | GPIO16)
+#define UNBR_LNB_OFF				0
+#define UNBR_LNB_13V				GPIO17
+#define UNBR_LNB_18V				(GPIO17 | GPIO16)
 
 static unsigned int card[]  = {[0 ... 3] = UNSET };
 module_param_array(card,  int, NULL, 0444);
@@ -188,7 +206,11 @@
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct dm1105_board {
-	char                    *name;
+	char	*name;
+	struct	{
+		u32	mask, off, v13, v18;
+	} lnb;
+	u32	gpio_scl, gpio_sda;
 };
 
 struct dm1105_subid {
@@ -200,15 +222,50 @@
 static const struct dm1105_board dm1105_boards[] = {
 	[DM1105_BOARD_UNKNOWN] = {
 		.name		= "UNKNOWN/GENERIC",
+		.lnb = {
+			.mask = DM1105_LNB_MASK,
+			.off = DM1105_LNB_OFF,
+			.v13 = DM1105_LNB_13V,
+			.v18 = DM1105_LNB_18V,
+		},
 	},
 	[DM1105_BOARD_DVBWORLD_2002] = {
 		.name		= "DVBWorld PCI 2002",
+		.lnb = {
+			.mask = DM1105_LNB_MASK,
+			.off = DM1105_LNB_OFF,
+			.v13 = DM1105_LNB_13V,
+			.v18 = DM1105_LNB_18V,
+		},
 	},
 	[DM1105_BOARD_DVBWORLD_2004] = {
 		.name		= "DVBWorld PCI 2004",
+		.lnb = {
+			.mask = DM1105_LNB_MASK,
+			.off = DM1105_LNB_OFF,
+			.v13 = DM1105_LNB_13V,
+			.v18 = DM1105_LNB_18V,
+		},
 	},
 	[DM1105_BOARD_AXESS_DM05] = {
 		.name		= "Axess/EasyTv DM05",
+		.lnb = {
+			.mask = DM05_LNB_MASK,
+			.off = DM05_LNB_OFF,
+			.v13 = DM05_LNB_13V,
+			.v18 = DM05_LNB_18V,
+		},
+	},
+	[DM1105_BOARD_UNBRANDED_I2C_ON_GPIO] = {
+		.name		= "Unbranded DM1105 with i2c on GPIOs",
+		.lnb = {
+			.mask = UNBR_LNB_MASK,
+			.off = UNBR_LNB_OFF,
+			.v13 = UNBR_LNB_13V,
+			.v18 = UNBR_LNB_18V,
+		},
+		.gpio_scl	= GPIO14,
+		.gpio_sda	= GPIO13,
 	},
 };
 
@@ -294,6 +351,8 @@
 
 	/* i2c */
 	struct i2c_adapter i2c_adap;
+	struct i2c_adapter i2c_bb_adap;
+	struct i2c_algo_bit_data i2c_bit;
 
 	/* irq */
 	struct work_struct work;
@@ -329,6 +388,103 @@
 #define dm_setl(reg, bit)	dm_andorl((reg), (bit), (bit))
 #define dm_clearl(reg, bit)	dm_andorl((reg), (bit), 0)
 
+/* The chip has 18 GPIOs. In HOST mode GPIO's used as 15 bit address lines,
+ so we can use only 3 GPIO's from GPIO15 to GPIO17.
+ Here I don't check whether HOST is enebled as it is not implemented yet.
+ */
+static void dm1105_gpio_set(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		dm_setl(DM1105_GPIOVAL, mask & 0x0003ffff);
+
+}
+
+static void dm1105_gpio_clear(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		dm_clearl(DM1105_GPIOVAL, mask & 0x0003ffff);
+
+}
+
+static void dm1105_gpio_andor(struct dm1105_dev *dev, u32 mask, u32 val)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		dm_andorl(DM1105_GPIOVAL, mask & 0x0003ffff, val);
+
+}
+
+static u32 dm1105_gpio_get(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		return dm_readl(DM1105_GPIOVAL) & mask & 0x0003ffff;
+
+	return 0;
+}
+
+static void dm1105_gpio_enable(struct dm1105_dev *dev, u32 mask, int asoutput)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if ((mask & 0x0003ffff) && asoutput)
+		dm_clearl(DM1105_GPIOCTR, mask & 0x0003ffff);
+	else if ((mask & 0x0003ffff) && !asoutput)
+		dm_setl(DM1105_GPIOCTR, mask & 0x0003ffff);
+
+}
+
+static void dm1105_setline(struct dm1105_dev *dev, u32 line, int state)
+{
+	if (state)
+		dm1105_gpio_enable(dev, line, 0);
+	else {
+		dm1105_gpio_enable(dev, line, 1);
+		dm1105_gpio_clear(dev, line);
+	}
+}
+
+static void dm1105_setsda(void *data, int state)
+{
+	struct dm1105_dev *dev = data;
+
+	dm1105_setline(dev, dm1105_boards[dev->boardnr].gpio_sda, state);
+}
+
+static void dm1105_setscl(void *data, int state)
+{
+	struct dm1105_dev *dev = data;
+
+	dm1105_setline(dev, dm1105_boards[dev->boardnr].gpio_scl, state);
+}
+
+static int dm1105_getsda(void *data)
+{
+	struct dm1105_dev *dev = data;
+
+	return dm1105_gpio_get(dev, dm1105_boards[dev->boardnr].gpio_sda)
+									? 1 : 0;
+}
+
+static int dm1105_getscl(void *data)
+{
+	struct dm1105_dev *dev = data;
+
+	return dm1105_gpio_get(dev, dm1105_boards[dev->boardnr].gpio_scl)
+									? 1 : 0;
+}
+
 static int dm1105_i2c_xfer(struct i2c_adapter *i2c_adap,
 			    struct i2c_msg *msgs, int num)
 {
@@ -440,31 +596,20 @@
 static int dm1105_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	struct dm1105_dev *dev = frontend_to_dm1105_dev(fe);
-	u32 lnb_mask, lnb_13v, lnb_18v, lnb_off;
 
-	switch (dev->boardnr) {
-	case DM1105_BOARD_AXESS_DM05:
-		lnb_mask = DM05_LNB_MASK;
-		lnb_off = DM05_LNB_OFF;
-		lnb_13v = DM05_LNB_13V;
-		lnb_18v = DM05_LNB_18V;
-		break;
-	case DM1105_BOARD_DVBWORLD_2002:
-	case DM1105_BOARD_DVBWORLD_2004:
-	default:
-		lnb_mask = DM1105_LNB_MASK;
-		lnb_off = DM1105_LNB_OFF;
-		lnb_13v = DM1105_LNB_13V;
-		lnb_18v = DM1105_LNB_18V;
-	}
-
-	dm_writel(DM1105_GPIOCTR, lnb_mask);
+	dm1105_gpio_enable(dev, dm1105_boards[dev->boardnr].lnb.mask, 1);
 	if (voltage == SEC_VOLTAGE_18)
-		dm_writel(DM1105_GPIOVAL, lnb_18v);
+		dm1105_gpio_andor(dev,
+				dm1105_boards[dev->boardnr].lnb.mask,
+				dm1105_boards[dev->boardnr].lnb.v18);
 	else if (voltage == SEC_VOLTAGE_13)
-		dm_writel(DM1105_GPIOVAL, lnb_13v);
+		dm1105_gpio_andor(dev,
+				dm1105_boards[dev->boardnr].lnb.mask,
+				dm1105_boards[dev->boardnr].lnb.v13);
 	else
-		dm_writel(DM1105_GPIOVAL, lnb_off);
+		dm1105_gpio_andor(dev,
+				dm1105_boards[dev->boardnr].lnb.mask,
+				dm1105_boards[dev->boardnr].lnb.off);
 
 	return 0;
 }
@@ -740,6 +885,38 @@
 	int ret;
 
 	switch (dev->boardnr) {
+	case DM1105_BOARD_UNBRANDED_I2C_ON_GPIO:
+		dm1105_gpio_enable(dev, GPIO15, 1);
+		dm1105_gpio_clear(dev, GPIO15);
+		msleep(100);
+		dm1105_gpio_set(dev, GPIO15);
+		msleep(200);
+		dev->fe = dvb_attach(
+			stv0299_attach, &sharp_z0194a_config,
+			&dev->i2c_bb_adap);
+		if (dev->fe) {
+			dev->fe->ops.set_voltage = dm1105_set_voltage;
+			dvb_attach(dvb_pll_attach, dev->fe, 0x60,
+					&dev->i2c_bb_adap, DVB_PLL_OPERA1);
+			break;
+		}
+
+		dev->fe = dvb_attach(
+			stv0288_attach, &earda_config,
+			&dev->i2c_bb_adap);
+		if (dev->fe) {
+			dev->fe->ops.set_voltage = dm1105_set_voltage;
+			dvb_attach(stb6000_attach, dev->fe, 0x61,
+					&dev->i2c_bb_adap);
+			break;
+		}
+
+		dev->fe = dvb_attach(
+			si21xx_attach, &serit_config,
+			&dev->i2c_bb_adap);
+		if (dev->fe)
+			dev->fe->ops.set_voltage = dm1105_set_voltage;
+		break;
 	case DM1105_BOARD_DVBWORLD_2004:
 		dev->fe = dvb_attach(
 			cx24116_attach, &serit_sp2633_config,
@@ -903,11 +1080,33 @@
 	if (ret < 0)
 		goto err_dm1105_hw_exit;
 
+	i2c_set_adapdata(&dev->i2c_bb_adap, dev);
+	strcpy(dev->i2c_bb_adap.name, DM1105_I2C_GPIO_NAME);
+	dev->i2c_bb_adap.owner = THIS_MODULE;
+	dev->i2c_bb_adap.class = I2C_CLASS_TV_DIGITAL;
+	dev->i2c_bb_adap.dev.parent = &pdev->dev;
+	dev->i2c_bb_adap.algo_data = &dev->i2c_bit;
+	dev->i2c_bit.data = dev;
+	dev->i2c_bit.setsda = dm1105_setsda;
+	dev->i2c_bit.setscl = dm1105_setscl;
+	dev->i2c_bit.getsda = dm1105_getsda;
+	dev->i2c_bit.getscl = dm1105_getscl;
+	dev->i2c_bit.udelay = 10;
+	dev->i2c_bit.timeout = 10;
+
+	/* Raise SCL and SDA */
+	dm1105_setsda(dev, 1);
+	dm1105_setscl(dev, 1);
+
+	ret = i2c_bit_add_bus(&dev->i2c_bb_adap);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
 	/* dvb */
 	ret = dvb_register_adapter(&dev->dvb_adapter, DRIVER_NAME,
 					THIS_MODULE, &pdev->dev, adapter_nr);
 	if (ret < 0)
-		goto err_i2c_del_adapter;
+		goto err_i2c_del_adapters;
 
 	dvb_adapter = &dev->dvb_adapter;
 
@@ -989,6 +1188,8 @@
 	dvb_dmx_release(dvbdemux);
 err_dvb_unregister_adapter:
 	dvb_unregister_adapter(dvb_adapter);
+err_i2c_del_adapters:
+	i2c_del_adapter(&dev->i2c_bb_adap);
 err_i2c_del_adapter:
 	i2c_del_adapter(&dev->i2c_adap);
 err_dm1105_hw_exit:



--------------070700080707050908040704--
