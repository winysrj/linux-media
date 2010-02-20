Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53310 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0BTRte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 12:49:34 -0500
Received: by bwz1 with SMTP id 1so781533bwz.21
        for <linux-media@vger.kernel.org>; Sat, 20 Feb 2010 09:49:33 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Hendrik Skarpeid <skarp@online.no>, linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Sat, 20 Feb 2010 19:49:36 +0200
References: <4B7D83B2.4030709@online.no>
In-Reply-To: <4B7D83B2.4030709@online.no>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wCCgLO2ZmR65Any"
Message-Id: <201002201949.36612.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_wCCgLO2ZmR65Any
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 18 =C6=C5=D7=D2=C1=CC=D1 2010, liplianin@me.by wrote:
> I also got the unbranded dm1105 card. I tried the four possible i2c
> addresses, just i case. Noen worked of course. Then I traced the i2c
> pins on the tuner to pins 100 and 101 on the DM1105.
> These are GPIO pins, so bit-banging i2c on these pins seems to be the
> solution.
>
> scl =3D p101 =3D gpio14
> sda =3D p100 =3D gpio13
Here is the patch to test. Use option card=3D4.
	modprobe dm1105 card=3D4
=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_wCCgLO2ZmR65Any
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="dm1105.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dm1105.c.diff"

--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Sun Feb 07 16:26:33 2010 +0200
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Sat Feb 20 16:35:08 2010 +0200
@@ -20,6 +20,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -47,11 +48,12 @@
 
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
@@ -155,23 +157,27 @@
 #define DM1105_MAX				0x04
 
 #define DRIVER_NAME				"dm1105"
+#define DM1105_I2C_GPIO_NAME			"dm1105-gpio"
 
 #define DM1105_DMA_PACKETS			47
 #define DM1105_DMA_PACKET_LENGTH		(128*4)
 #define DM1105_DMA_BYTES			(128 * 4 * DM1105_DMA_PACKETS)
 
 /* GPIO's for LNB power control */
-#define DM1105_LNB_MASK				0x00000000
+#define DM1105_LNB_MASK				0x00006000
 #define DM1105_LNB_OFF				0x00020000
 #define DM1105_LNB_13V				0x00010100
 #define DM1105_LNB_18V				0x00000100
 
 /* GPIO's for LNB power control for Axess DM05 */
-#define DM05_LNB_MASK				0x00000000
+#define DM05_LNB_MASK				0x00006000
 #define DM05_LNB_OFF				0x00020000/* actually 13v */
 #define DM05_LNB_13V				0x00020000
 #define DM05_LNB_18V				0x00030000
 
+#define GPIO13					(1 << 13)
+#define GPIO14					(1 << 14)
+
 static unsigned int card[]  = {[0 ... 3] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
@@ -185,7 +191,9 @@
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct dm1105_board {
-	char                    *name;
+	char		*name;
+	int		i2c_on_gpio;
+	u32		gpio_scl, gpio_sda;
 };
 
 struct dm1105_subid {
@@ -207,6 +215,12 @@
 	[DM1105_BOARD_AXESS_DM05] = {
 		.name		= "Axess/EasyTv DM05",
 	},
+	[DM1105_BOARD_UNBRANDED_I2C_ON_GPIO] = {
+		.name		= "Unbranded DM1105 with i2c on GPIOs",
+		.i2c_on_gpio	= 1,
+		.gpio_scl	= GPIO14,
+		.gpio_sda	= GPIO13,
+	},
 };
 
 static const struct dm1105_subid dm1105_subids[] = {
@@ -292,6 +306,8 @@
 
 	/* i2c */
 	struct i2c_adapter i2c_adap;
+	struct i2c_adapter i2c_bb_adap;
+	struct i2c_algo_bit_data i2c_bit;
 
 	/* irq */
 	struct work_struct work;
@@ -327,6 +343,97 @@
 #define dm_setl(reg, bit)	dm_andorl((reg), (bit), (bit))
 #define dm_clearl(reg, bit)	dm_andorl((reg), (bit), 0)
 
+/* The chip has 18 GPIOs. In HOST mode GPIO's used as 15 bit address lines,
+ so we can use only 3 GPIO's from GPIO15 to GPIO17.
+ Here I don't check whether HOST is enebled as it is not implemented yet.
+ */
+void dm1105_gpio_set(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		dm_setl(DM1105_GPIOVAL, mask & 0x0003ffff);
+
+}
+
+void dm1105_gpio_clear(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		dm_clearl(DM1105_GPIOVAL, mask & 0x0003ffff);
+
+}
+
+u32 dm1105_gpio_get(struct dm1105_dev *dev, u32 mask)
+{
+	if (mask & 0xfffc0000)
+		printk(KERN_ERR "%s: Only 18 GPIO's are allowed\n", __func__);
+
+	if (mask & 0x0003ffff)
+		return dm_readl(DM1105_GPIOVAL);
+
+	return 0;
+}
+
+void dm1105_gpio_enable(struct dm1105_dev *dev, u32 mask, int asoutput)
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
+	return dm1105_gpio_get(dev, dm1105_boards[dev->boardnr].gpio_sda);
+}
+
+static int dm1105_getscl(void *data)
+{
+	struct dm1105_dev *dev = data;
+
+	return dm1105_gpio_get(dev, dm1105_boards[dev->boardnr].gpio_scl);
+}
+
+//static int dm1105_i2c_bb_xfer(struct i2c_adapter *i2c_adap,
+//			    struct i2c_msg *msgs, int num)
+//{
+//	return num;
+//}
+
 static int dm1105_i2c_xfer(struct i2c_adapter *i2c_adap,
 			    struct i2c_msg *msgs, int num)
 {
@@ -425,6 +532,14 @@
 #endif
 };
 
+//static struct i2c_algorithm dm1105_bb_algo = {
+//	.master_xfer   = dm1105_i2c_bb_xfer,
+//	.functionality = functionality,
+//#ifdef NEED_ALGO_CONTROL
+//	.algo_control = dummy_algo_control,
+//#endif
+//};
+
 static inline struct dm1105_dev *feed_to_dm1105_dev(struct dvb_demux_feed *feed)
 {
 	return container_of(feed->demux, struct dm1105_dev, demux);
@@ -742,6 +857,33 @@
 	int ret;
 
 	switch (dev->boardnr) {
+	case DM1105_BOARD_UNBRANDED_I2C_ON_GPIO:
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
@@ -904,12 +1046,48 @@
 
 	if (ret < 0)
 		goto err_dm1105_hw_exit;
+#if 0
+	/* second i2c for GPIO connected devices */
+	i2c_set_adapdata(&dev->i2c_bb_adap, dev);
+	strcpy(dev->i2c_bb_adap.name, DM1105_I2C_GPIO_NAME);
+	dev->i2c_bb_adap.owner = THIS_MODULE;
+	dev->i2c_bb_adap.class = I2C_CLASS_TV_DIGITAL;
+	dev->i2c_bb_adap.dev.parent = &pdev->dev;
+	dev->i2c_bb_adap.algo = &dm1105_bb_algo;
+	dev->i2c_bb_adap.algo_data = dev;
+	ret = i2c_add_adapter(&dev->i2c_bb_adap);
 
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+#else
+	/* i2c */
+	i2c_set_adapdata(&dev->i2c_adap, dev);
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
+#endif
 	/* dvb */
 	ret = dvb_register_adapter(&dev->dvb_adapter, DRIVER_NAME,
 					THIS_MODULE, &pdev->dev, adapter_nr);
 	if (ret < 0)
-		goto err_i2c_del_adapter;
+		goto err_i2c_del_adapters;
 
 	dvb_adapter = &dev->dvb_adapter;
 
@@ -991,6 +1169,8 @@
 	dvb_dmx_release(dvbdemux);
 err_dvb_unregister_adapter:
 	dvb_unregister_adapter(dvb_adapter);
+err_i2c_del_adapters:
+	i2c_del_adapter(&dev->i2c_bb_adap);
 err_i2c_del_adapter:
 	i2c_del_adapter(&dev->i2c_adap);
 err_dm1105_hw_exit:

--Boundary-00=_wCCgLO2ZmR65Any--
