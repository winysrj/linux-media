Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2DOPxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Apr 2012 11:53:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so5403637pbc.19
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2012 08:53:38 -0700 (PDT)
Date: Sun, 15 Apr 2012 23:53:41 +0800
From: "=?utf-8?B?bmliYmxlLm1heA==?=" <nibble.max@gmail.com>
To: "=?utf-8?B?TWF1cm8gQ2FydmFsaG8gQ2hlaGFi?=" <mchehab@redhat.com>
Cc: "=?utf-8?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>
Subject: =?utf-8?B?W1BBVENIIDQvNl0gbTg4ZHMzMTAzLCBkdmJza3kgZHZiLXMyIGN4MjM4ODUgcGNpZSBjYXJkLg==?=
Message-ID: <201204152353392650604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbsky dvb-s2 pcie based on montage m88ds3103 demodulator.

Signed-off-by: Max nibble <nibble.max@gmail.com>
---
 drivers/media/video/cx23885/Kconfig         |    1 +
 drivers/media/video/cx23885/cx23885-cards.c |  107 +++++++++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-dvb.c   |   52 +++++++++++++
 drivers/media/video/cx23885/cx23885-f300.c  |   55 ++++++++++++++
 drivers/media/video/cx23885/cx23885-f300.h  |    6 ++
 drivers/media/video/cx23885/cx23885-input.c |   15 ++++
 drivers/media/video/cx23885/cx23885.h       |    3 +
 7 files changed, 239 insertions(+)

diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
index b391e9b..20337c7 100644
--- a/drivers/media/video/cx23885/Kconfig
+++ b/drivers/media/video/cx23885/Kconfig
@@ -20,6 +20,7 @@ config VIDEO_CX23885
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_STV6110 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_M88DS3103 if !DVB_FE_CUSTOMISE
 	select DVB_STV0900 if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
 	select DVB_STV0367 if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 19b5499..fdf9d0f 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -497,6 +497,20 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "TerraTec Cinergy T PCIe Dual",
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
+	},
+
+	[CX23885_BOARD_BST_PS8512] = {
+		.name		= "Bestunar PS8512",
+		.portb		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_DVBSKY_S950] = {
+		.name		= "DVBSKY S950",
+		.portb		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_DVBSKY_S952] = {
+		.name		= "DVBSKY S952",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
 	}
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
@@ -705,6 +719,18 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x153b,
 		.subdevice = 0x117e,
 		.card      = CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL,
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8512,
+		.card      = CX23885_BOARD_BST_PS8512,
+	}, {
+		.subvendor = 0x4254,
+		.subdevice = 0x0950,
+		.card      = CX23885_BOARD_DVBSKY_S950,		
+	}, {
+		.subvendor = 0x4254,
+		.subdevice = 0x0952,
+		.card      = CX23885_BOARD_DVBSKY_S952,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1216,9 +1242,57 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		/* enable irq */
 		cx_write(GPIO_ISM, 0x00000000);/* INTERRUPTS active low*/
 		break;
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_BST_PS8512:			
+		cx23885_gpio_enable(dev, GPIO_2, 1);
+		cx23885_gpio_clear(dev, GPIO_2);
+		msleep(100);		
+		cx23885_gpio_set(dev, GPIO_2);
+		break;
+	case CX23885_BOARD_DVBSKY_S952:		
+		cx_write(MC417_CTL, 0x00000037);/* enable GPIO3-18 pins */
+		
+		cx23885_gpio_enable(dev, GPIO_2, 1);
+		cx23885_gpio_enable(dev, GPIO_11, 1);
+		
+		cx23885_gpio_clear(dev, GPIO_2);
+		cx23885_gpio_clear(dev, GPIO_11);
+		msleep(100);		
+		cx23885_gpio_set(dev, GPIO_2);
+		cx23885_gpio_set(dev, GPIO_11);
+		
+		break;
 	}
 }
 
+static int cx23885_ir_patch(struct i2c_adapter *i2c, u8 reg, u8 mask)
+{
+	struct i2c_msg msgs[2];
+	u8 tx_buf[2], rx_buf[1];
+	/* Write register address */
+	tx_buf[0] = reg;
+	msgs[0].addr = 0x4c;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = (char *) tx_buf;
+	/* Read data from register */
+	msgs[1].addr = 0x4c;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = 1;
+	msgs[1].buf = (char *) rx_buf;	
+	
+	i2c_transfer(i2c, msgs, 2);
+
+	tx_buf[0] = reg;
+	tx_buf[1] = rx_buf[0] | mask;
+	msgs[0].addr = 0x4c;
+	msgs[0].flags = 0;
+	msgs[0].len = 2;
+	msgs[0].buf = (char *) tx_buf;
+	
+	return i2c_transfer(i2c, msgs, 1);
+}
+
 int cx23885_ir_init(struct cx23885_dev *dev)
 {
 	static struct v4l2_subdev_io_pin_config ir_rxtx_pin_cfg[] = {
@@ -1301,6 +1375,20 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
 				 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
 		break;
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
+		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
+		if (dev->sd_ir == NULL) {
+			ret = -ENODEV;
+			break;
+		}
+		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
+				 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
+				 
+		cx23885_ir_patch(&(dev->i2c_bus[2].i2c_adap),0x1f,0x80);
+		cx23885_ir_patch(&(dev->i2c_bus[2].i2c_adap),0x23,0x80);
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		if (!enable_885_ir)
 			break;
@@ -1332,6 +1420,9 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
 		dev->sd_ir = NULL;
@@ -1375,6 +1466,9 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
 		if (dev->sd_ir)
 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
 		break;
@@ -1459,6 +1553,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_DVBWORLD_2005:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
@@ -1489,6 +1585,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+	case CX23885_BOARD_DVBSKY_S952:
+		ts1->gen_ctrl_val  = 0x5; /* Parallel */
+		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		ts2->gen_ctrl_val  = 0xe; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
@@ -1541,6 +1645,9 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MPX885:
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 6835eb1..c5a3fa3 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -51,6 +51,7 @@
 #include "stv6110.h"
 #include "lnbh24.h"
 #include "cx24116.h"
+#include "m88ds3103.h"
 #include "cimax2.h"
 #include "lgs8gxx.h"
 #include "netup-eeprom.h"
@@ -489,6 +490,30 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
 	.if_khz = 5380,
 };
 
+/* bestunar single dvb-s2 */
+static struct m88ds3103_config bst_ds3103_config = {
+	.demod_address = 0x68,
+	.ci_mode = 0,
+	.pin_ctrl = 0x82,
+	.ts_mode = 0,
+	.set_voltage = bst_set_voltage,
+};
+/* DVBSKY dual dvb-s2 */
+static struct m88ds3103_config dvbsky_ds3103_config_pri = {
+	.demod_address = 0x68,
+	.ci_mode = 0,
+	.pin_ctrl = 0x82,
+	.ts_mode = 0,
+	.set_voltage = bst_set_voltage,	
+};
+static struct m88ds3103_config dvbsky_ds3103_config_sec = {
+	.demod_address = 0x68,
+	.ci_mode = 0,
+	.pin_ctrl = 0x82,
+	.ts_mode = 1,
+	.set_voltage = dvbsky_set_voltage_sec,	
+};
+
 static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -1173,6 +1198,33 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+		i2c_bus = &dev->i2c_bus[1];	
+		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+					&bst_ds3103_config,
+					&i2c_bus->i2c_adap);
+		break;	
+			
+	case CX23885_BOARD_DVBSKY_S952:
+		switch (port->nr) {
+		/* port B */
+		case 1:
+			i2c_bus = &dev->i2c_bus[1];
+			fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+						&dvbsky_ds3103_config_pri,
+						&i2c_bus->i2c_adap);
+			break;
+		/* port C */
+		case 2:
+			i2c_bus = &dev->i2c_bus[0];
+			fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
+						&dvbsky_ds3103_config_sec,
+						&i2c_bus->i2c_adap);		
+			break;
+		}
+		break;
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
diff --git a/drivers/media/video/cx23885/cx23885-f300.c b/drivers/media/video/cx23885/cx23885-f300.c
index 93998f2..6be0369 100644
--- a/drivers/media/video/cx23885/cx23885-f300.c
+++ b/drivers/media/video/cx23885/cx23885-f300.c
@@ -175,3 +175,58 @@ int f300_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 
 	return f300_xfer(fe, buf);
 }
+
+/* bst control */
+int bst_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+	
+	cx23885_gpio_enable(dev, GPIO_1, 1);
+	cx23885_gpio_enable(dev, GPIO_0, 1);
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx23885_gpio_set(dev, GPIO_1);
+		cx23885_gpio_clear(dev, GPIO_0);
+		break;
+	case SEC_VOLTAGE_18:
+		cx23885_gpio_set(dev, GPIO_1);
+		cx23885_gpio_set(dev, GPIO_0);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx23885_gpio_clear(dev, GPIO_1);
+		cx23885_gpio_clear(dev, GPIO_0);
+		break;
+	}
+	
+
+	return 0;
+}
+
+int dvbsky_set_voltage_sec(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct cx23885_tsport *port = fe->dvb->priv;
+	struct cx23885_dev *dev = port->dev;
+	
+	cx23885_gpio_enable(dev, GPIO_12, 1);
+	cx23885_gpio_enable(dev, GPIO_13, 1);
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx23885_gpio_set(dev, GPIO_13);
+		cx23885_gpio_clear(dev, GPIO_12);
+		break;
+	case SEC_VOLTAGE_18:
+		cx23885_gpio_set(dev, GPIO_13);
+		cx23885_gpio_set(dev, GPIO_12);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx23885_gpio_clear(dev, GPIO_13);
+		cx23885_gpio_clear(dev, GPIO_12);
+		break;
+	}
+	
+
+	return 0;
+}
\ No newline at end of file
diff --git a/drivers/media/video/cx23885/cx23885-f300.h b/drivers/media/video/cx23885/cx23885-f300.h
index e73344c..cd02d02 100644
--- a/drivers/media/video/cx23885/cx23885-f300.h
+++ b/drivers/media/video/cx23885/cx23885-f300.h
@@ -1,2 +1,8 @@
+extern int dvbsky_set_voltage_sec(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage);
+				
+extern int bst_set_voltage(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage);
+
 extern int f300_set_voltage(struct dvb_frontend *fe,
 				fe_sec_voltage_t voltage);
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index ce765e3..69c01f3 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -87,6 +87,9 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
 		/*
 		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
@@ -138,6 +141,9 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -279,6 +285,15 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
+	case CX23885_BOARD_BST_PS8512:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
+		/* Integrated CX2388[58] IR controller */
+		driver_type = RC_DRIVER_IR_RAW;
+		allowed_protos = RC_TYPE_ALL;
+		/* A guess at the remote */
+		rc_map = RC_MAP_DVBSKY;
+		break;
 	default:
 		return -ENODEV;
 	}
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index f020f05..2724148 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -89,6 +89,9 @@
 #define CX23885_BOARD_MPX885                   32
 #define CX23885_BOARD_MYGICA_X8507             33
 #define CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL 34
+#define CX23885_BOARD_BST_PS8512               35
+#define CX23885_BOARD_DVBSKY_S952              36
+#define CX23885_BOARD_DVBSKY_S950              37
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.9.5

