Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39455 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJMGk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Oct 2014 02:40:58 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so5356935pab.18
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 23:40:57 -0700 (PDT)
Date: Mon, 13 Oct 2014 14:40:52 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 1/3] DVBSky V3 PCIe card: add new SMI PCIe bridge driver
Message-ID: <201410131440494843520@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a new PCIe bridge chip(from SMI) used in DVBSky V3 seris cards, include S950 V3 and S952 V3 cards.
SMI pcie bridge chip is PCIe 1.1 compliant, supports MSI feature.
Main interface blocks:
1>Two DVB transport stream input ports(ts0,ts1).
2>Two I2C master bus(i2c0, i2c1).
3>IR controller.
4>reset pins and other GPIOs.

DVBSky S950 V3 card has a single channel of dvb-s/s2.
1>Frontend: tuner: M88TS2022, demod: M88DS3103
2>PCIe bridge: SMI PCIe

DVBSky S952 V3 card has a dual channels of dvb-s/s2.
1>Frontend: Integrated tuner and demod: M88RS6000
2>PCIe bridge: SMI PCIe

*The current driver does not support SMI IR function.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/Kconfig           |    1 +
 drivers/media/pci/Makefile          |    3 +-
 drivers/media/pci/smipcie/Kconfig   |   13 +
 drivers/media/pci/smipcie/Makefile  |    3 +
 drivers/media/pci/smipcie/smipcie.c | 1021 +++++++++++++++++++++++++++++++++++
 drivers/media/pci/smipcie/smipcie.h |  298 ++++++++++
 6 files changed, 1338 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index f8cec8e..218144a 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -46,6 +46,7 @@ source "drivers/media/pci/pt3/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
+source "drivers/media/pci/smipcie/Kconfig"
 endif
 
 endif #MEDIA_PCI_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index a12926e..0baf0d2 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -11,7 +11,8 @@ obj-y        +=	ttpci/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
-		saa7146/
+		saa7146/	\
+		smipcie/
 
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
new file mode 100644
index 0000000..75a2992
--- /dev/null
+++ b/drivers/media/pci/smipcie/Kconfig
@@ -0,0 +1,13 @@
+config DVB_SMIPCIE
+	tristate "SMI PCIe DVBSky cards"
+	depends on DVB_CORE && PCI && I2C
+	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for cards with SMI PCIe bridge:
+	  - DVBSky S950 V3
+	  - DVBSky S952 V3
+
+	  Say Y or M if you own such a device and want to use it.
+	  If unsure say N.
diff --git a/drivers/media/pci/smipcie/Makefile b/drivers/media/pci/smipcie/Makefile
new file mode 100644
index 0000000..20af47a
--- /dev/null
+++ b/drivers/media/pci/smipcie/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_DVB_SMIPCIE) += smipcie.o
+
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
new file mode 100644
index 0000000..77ded52
--- /dev/null
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -0,0 +1,1021 @@
+/*
+ * SMI PCIe driver for DVBSky cards.
+ *
+ * Copyright (C) 2014 Max nibble <nibble.max@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#include "smipcie.h"
+#include "m88ds3103.h"
+#include "m88ts2022.h"
+#include "m88rs6000t.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static int smi_hw_init(struct smi_dev *dev)
+{
+	u32 port_mux, port_ctrl, int_stat;
+
+	/* set port mux.*/
+	port_mux = smi_read(MUX_MODE_CTRL);
+	port_mux &= ~(rbPaMSMask);
+	port_mux |= rbPaMSDtvNoGpio;
+	port_mux &= ~(rbPbMSMask);
+	port_mux |= rbPbMSDtvNoGpio;
+	port_mux &= ~(0x0f0000);
+	port_mux |= 0x50000;
+	smi_write(MUX_MODE_CTRL, port_mux);
+
+	/* set DTV register.*/
+	/* Port A */
+	port_ctrl = smi_read(VIDEO_CTRL_STATUS_A);
+	port_ctrl &= ~0x01;
+	smi_write(VIDEO_CTRL_STATUS_A, port_ctrl);
+	port_ctrl = smi_read(MPEG2_CTRL_A);
+	port_ctrl &= ~0x40;
+	port_ctrl |= 0x80;
+	smi_write(MPEG2_CTRL_A, port_ctrl);
+	/* Port B */
+	port_ctrl = smi_read(VIDEO_CTRL_STATUS_B);
+	port_ctrl &= ~0x01;
+	smi_write(VIDEO_CTRL_STATUS_B, port_ctrl);
+	port_ctrl = smi_read(MPEG2_CTRL_B);
+	port_ctrl &= ~0x40;
+	port_ctrl |= 0x80;
+	smi_write(MPEG2_CTRL_B, port_ctrl);
+
+	/* disable and clear interrupt.*/
+	smi_write(MSI_INT_ENA_CLR, ALL_INT);
+	int_stat = smi_read(MSI_INT_STATUS);
+	smi_write(MSI_INT_STATUS_CLR, int_stat);
+
+	/* reset demod.*/
+	smi_clear(PERIPHERAL_CTRL, 0x0303);
+	msleep(50);
+	smi_set(PERIPHERAL_CTRL, 0x0101);
+	return 0;
+}
+
+/* i2c bit bus.*/
+static void smi_i2c_cfg(struct smi_dev *dev, u32 sw_ctl)
+{
+	u32 dwCtrl;
+
+	dwCtrl = smi_read(sw_ctl);
+	dwCtrl &= ~0x18; /* disable output.*/
+	dwCtrl |= 0x21; /* reset and software mode.*/
+	dwCtrl &= ~0xff00;
+	dwCtrl |= 0x6400;
+	smi_write(sw_ctl, dwCtrl);
+	msleep(20);
+	dwCtrl = smi_read(sw_ctl);
+	dwCtrl &= ~0x20;
+	smi_write(sw_ctl, dwCtrl);
+}
+
+static void smi_i2c_setsda(struct smi_dev *dev, int state, u32 sw_ctl)
+{
+	if (state) {
+		/* set as input.*/
+		smi_clear(sw_ctl, SW_I2C_MSK_DAT_EN);
+	} else {
+		smi_clear(sw_ctl, SW_I2C_MSK_DAT_OUT);
+		/* set as output.*/
+		smi_set(sw_ctl, SW_I2C_MSK_DAT_EN);
+	}
+}
+
+static void smi_i2c_setscl(void *data, int state, u32 sw_ctl)
+{
+	struct smi_dev *dev = data;
+
+	if (state) {
+		/* set as input.*/
+		smi_clear(sw_ctl, SW_I2C_MSK_CLK_EN);
+	} else {
+		smi_clear(sw_ctl, SW_I2C_MSK_CLK_OUT);
+		/* set as output.*/
+		smi_set(sw_ctl, SW_I2C_MSK_CLK_EN);
+	}
+}
+
+static int smi_i2c_getsda(void *data, u32 sw_ctl)
+{
+	struct smi_dev *dev = data;
+	/* set as input.*/
+	smi_clear(sw_ctl, SW_I2C_MSK_DAT_EN);
+	udelay(1);
+	return (smi_read(sw_ctl) & SW_I2C_MSK_DAT_IN) ? 1 : 0;
+}
+
+static int smi_i2c_getscl(void *data, u32 sw_ctl)
+{
+	struct smi_dev *dev = data;
+	/* set as input.*/
+	smi_clear(sw_ctl, SW_I2C_MSK_CLK_EN);
+	udelay(1);
+	return (smi_read(sw_ctl) & SW_I2C_MSK_CLK_IN) ? 1 : 0;
+}
+/* i2c 0.*/
+static void smi_i2c0_setsda(void *data, int state)
+{
+	struct smi_dev *dev = data;
+
+	smi_i2c_setsda(dev, state, I2C_A_SW_CTL);
+}
+
+static void smi_i2c0_setscl(void *data, int state)
+{
+	struct smi_dev *dev = data;
+
+	smi_i2c_setscl(dev, state, I2C_A_SW_CTL);
+}
+
+static int smi_i2c0_getsda(void *data)
+{
+	struct smi_dev *dev = data;
+
+	return	smi_i2c_getsda(dev, I2C_A_SW_CTL);
+}
+
+static int smi_i2c0_getscl(void *data)
+{
+	struct smi_dev *dev = data;
+
+	return	smi_i2c_getscl(dev, I2C_A_SW_CTL);
+}
+/* i2c 1.*/
+static void smi_i2c1_setsda(void *data, int state)
+{
+	struct smi_dev *dev = data;
+
+	smi_i2c_setsda(dev, state, I2C_B_SW_CTL);
+}
+
+static void smi_i2c1_setscl(void *data, int state)
+{
+	struct smi_dev *dev = data;
+
+	smi_i2c_setscl(dev, state, I2C_B_SW_CTL);
+}
+
+static int smi_i2c1_getsda(void *data)
+{
+	struct smi_dev *dev = data;
+
+	return	smi_i2c_getsda(dev, I2C_B_SW_CTL);
+}
+
+static int smi_i2c1_getscl(void *data)
+{
+	struct smi_dev *dev = data;
+
+	return	smi_i2c_getscl(dev, I2C_B_SW_CTL);
+}
+
+static int smi_i2c_init(struct smi_dev *dev)
+{
+	int ret;
+
+	/* i2c bus 0 */
+	smi_i2c_cfg(dev, I2C_A_SW_CTL);
+	i2c_set_adapdata(&dev->i2c_bus[0], dev);
+	strcpy(dev->i2c_bus[0].name, "SMI-I2C0");
+	dev->i2c_bus[0].owner = THIS_MODULE;
+	dev->i2c_bus[0].dev.parent = &dev->pci_dev->dev;
+	dev->i2c_bus[0].algo_data = &dev->i2c_bit[0];
+	dev->i2c_bit[0].data = dev;
+	dev->i2c_bit[0].setsda = smi_i2c0_setsda;
+	dev->i2c_bit[0].setscl = smi_i2c0_setscl;
+	dev->i2c_bit[0].getsda = smi_i2c0_getsda;
+	dev->i2c_bit[0].getscl = smi_i2c0_getscl;
+	dev->i2c_bit[0].udelay = 12;
+	dev->i2c_bit[0].timeout = 10;
+	/* Raise SCL and SDA */
+	smi_i2c0_setsda(dev, 1);
+	smi_i2c0_setscl(dev, 1);
+
+	ret = i2c_bit_add_bus(&dev->i2c_bus[0]);
+	if (ret < 0)
+		return ret;
+
+	/* i2c bus 1 */
+	smi_i2c_cfg(dev, I2C_B_SW_CTL);
+	i2c_set_adapdata(&dev->i2c_bus[1], dev);
+	strcpy(dev->i2c_bus[1].name, "SMI-I2C1");
+	dev->i2c_bus[1].owner = THIS_MODULE;
+	dev->i2c_bus[1].dev.parent = &dev->pci_dev->dev;
+	dev->i2c_bus[1].algo_data = &dev->i2c_bit[1];
+	dev->i2c_bit[1].data = dev;
+	dev->i2c_bit[1].setsda = smi_i2c1_setsda;
+	dev->i2c_bit[1].setscl = smi_i2c1_setscl;
+	dev->i2c_bit[1].getsda = smi_i2c1_getsda;
+	dev->i2c_bit[1].getscl = smi_i2c1_getscl;
+	dev->i2c_bit[1].udelay = 12;
+	dev->i2c_bit[1].timeout = 10;
+	/* Raise SCL and SDA */
+	smi_i2c1_setsda(dev, 1);
+	smi_i2c1_setscl(dev, 1);
+
+	ret = i2c_bit_add_bus(&dev->i2c_bus[1]);
+	if (ret < 0)
+		i2c_del_adapter(&dev->i2c_bus[0]);
+
+	return ret;
+}
+
+static void smi_i2c_exit(struct smi_dev *dev)
+{
+	i2c_del_adapter(&dev->i2c_bus[0]);
+	i2c_del_adapter(&dev->i2c_bus[1]);
+}
+
+static int smi_read_eeprom(struct i2c_adapter *i2c, u16 reg, u8 *data, u16 size)
+{
+	int ret;
+	u8 b0[2] = { (reg >> 8) & 0xff, reg & 0xff };
+
+	struct i2c_msg msg[] = {
+		{ .addr = 0x50, .flags = 0,
+			.buf = b0, .len = 2 },
+		{ .addr = 0x50, .flags = I2C_M_RD,
+			.buf = data, .len = size }
+	};
+
+	ret = i2c_transfer(i2c, msg, 2);
+
+	if (ret != 2) {
+		dev_err(&i2c->dev, "%s: reg=0x%x (error=%d)\n",
+			__func__, reg, ret);
+		return ret;
+	}
+	return ret;
+}
+
+/* ts port interrupt operations */
+static void smi_port_disableInterrupt(struct smi_port *port)
+{
+	struct smi_dev *dev = port->dev;
+
+	smi_write(MSI_INT_ENA_CLR,
+		(port->_dmaInterruptCH0 | port->_dmaInterruptCH1));
+}
+
+static void smi_port_enableInterrupt(struct smi_port *port)
+{
+	struct smi_dev *dev = port->dev;
+
+	smi_write(MSI_INT_ENA_SET,
+		(port->_dmaInterruptCH0 | port->_dmaInterruptCH1));
+}
+
+static void smi_port_clearInterrupt(struct smi_port *port)
+{
+	struct smi_dev *dev = port->dev;
+
+	smi_write(MSI_INT_STATUS_CLR,
+		(port->_dmaInterruptCH0 | port->_dmaInterruptCH1));
+}
+
+/* tasklet handler: DMA data to dmx.*/
+static void smi_dma_xfer(unsigned long data)
+{
+	struct smi_port *port = (struct smi_port *) data;
+	struct smi_dev *dev = port->dev;
+	u32 intr_status, finishedData, dmaManagement;
+	u8 dmaChan0State, dmaChan1State;
+
+	intr_status = port->_int_status;
+	dmaManagement = smi_read(port->DMA_MANAGEMENT);
+	dmaChan0State = (u8)((dmaManagement & 0x00000030) >> 4);
+	dmaChan1State = (u8)((dmaManagement & 0x00300000) >> 20);
+
+	/* CH-0 DMA interrupt.*/
+	if ((intr_status & port->_dmaInterruptCH0) && (dmaChan0State == 0x01)) {
+		dev_dbg(&dev->pci_dev->dev,
+			"Port[%d]-DMA CH0 engine complete successful !\n",
+			port->idx);
+		finishedData = smi_read(port->DMA_CHAN0_TRANS_STATE);
+		finishedData &= 0x003FFFFF;
+		/* value of DMA_PORT0_CHAN0_TRANS_STATE register [21:0]
+		 * indicate dma total transfer length and
+		 * zero of [21:0] indicate dma total transfer length
+		 * equal to 0x400000 (4MB)*/
+		if (finishedData == 0)
+			finishedData = 0x00400000;
+		if (finishedData != SMI_TS_DMA_BUF_SIZE) {
+			dev_dbg(&dev->pci_dev->dev,
+				"DMA CH0 engine complete length mismatched, finish data=%d !\n",
+				finishedData);
+		}
+		dvb_dmx_swfilter_packets(&port->demux,
+			port->cpu_addr[0], (finishedData / 188));
+		/*dvb_dmx_swfilter(&port->demux,
+			port->cpu_addr[0], finishedData);*/
+	}
+	/* CH-1 DMA interrupt.*/
+	if ((intr_status & port->_dmaInterruptCH1) && (dmaChan1State == 0x01)) {
+		dev_dbg(&dev->pci_dev->dev,
+			"Port[%d]-DMA CH1 engine complete successful !\n",
+			port->idx);
+		finishedData = smi_read(port->DMA_CHAN1_TRANS_STATE);
+		finishedData &= 0x003FFFFF;
+		/* value of DMA_PORT0_CHAN0_TRANS_STATE register [21:0]
+		 * indicate dma total transfer length and
+		 * zero of [21:0] indicate dma total transfer length
+		 * equal to 0x400000 (4MB)*/
+		if (finishedData == 0)
+			finishedData = 0x00400000;
+		if (finishedData != SMI_TS_DMA_BUF_SIZE) {
+			dev_dbg(&dev->pci_dev->dev,
+				"DMA CH1 engine complete length mismatched, finish data=%d !\n",
+				finishedData);
+		}
+		dvb_dmx_swfilter_packets(&port->demux,
+			port->cpu_addr[1], (finishedData / 188));
+		/*dvb_dmx_swfilter(&port->demux,
+			port->cpu_addr[1], finishedData);*/
+	}
+	/* restart DMA.*/
+	if (intr_status & port->_dmaInterruptCH0)
+		dmaManagement |= 0x00000002;
+	if (intr_status & port->_dmaInterruptCH1)
+		dmaManagement |= 0x00020000;
+	smi_write(port->DMA_MANAGEMENT, dmaManagement);
+	/* Re-enable interrupts */
+	smi_port_enableInterrupt(port);
+}
+
+static void smi_port_dma_free(struct smi_port *port)
+{
+	if (port->cpu_addr[0]) {
+		pci_free_consistent(port->dev->pci_dev, SMI_TS_DMA_BUF_SIZE,
+				    port->cpu_addr[0], port->dma_addr[0]);
+		port->cpu_addr[0] = NULL;
+	}
+	if (port->cpu_addr[1]) {
+		pci_free_consistent(port->dev->pci_dev, SMI_TS_DMA_BUF_SIZE,
+				    port->cpu_addr[1], port->dma_addr[1]);
+		port->cpu_addr[1] = NULL;
+	}
+}
+
+static int smi_port_init(struct smi_port *port, int dmaChanUsed)
+{
+	dev_dbg(&port->dev->pci_dev->dev,
+		"%s, port %d, dmaused %d\n", __func__, port->idx, dmaChanUsed);
+	port->enable = 0;
+	if (port->idx == 0) {
+		/* Port A */
+		port->_dmaInterruptCH0 = dmaChanUsed & 0x01;
+		port->_dmaInterruptCH1 = dmaChanUsed & 0x02;
+
+		port->DMA_CHAN0_ADDR_LOW	= DMA_PORTA_CHAN0_ADDR_LOW;
+		port->DMA_CHAN0_ADDR_HI		= DMA_PORTA_CHAN0_ADDR_HI;
+		port->DMA_CHAN0_TRANS_STATE	= DMA_PORTA_CHAN0_TRANS_STATE;
+		port->DMA_CHAN0_CONTROL		= DMA_PORTA_CHAN0_CONTROL;
+		port->DMA_CHAN1_ADDR_LOW	= DMA_PORTA_CHAN1_ADDR_LOW;
+		port->DMA_CHAN1_ADDR_HI		= DMA_PORTA_CHAN1_ADDR_HI;
+		port->DMA_CHAN1_TRANS_STATE	= DMA_PORTA_CHAN1_TRANS_STATE;
+		port->DMA_CHAN1_CONTROL		= DMA_PORTA_CHAN1_CONTROL;
+		port->DMA_MANAGEMENT		= DMA_PORTA_MANAGEMENT;
+	} else {
+		/* Port B */
+		port->_dmaInterruptCH0 = (dmaChanUsed << 2) & 0x04;
+		port->_dmaInterruptCH1 = (dmaChanUsed << 2) & 0x08;
+
+		port->DMA_CHAN0_ADDR_LOW	= DMA_PORTB_CHAN0_ADDR_LOW;
+		port->DMA_CHAN0_ADDR_HI		= DMA_PORTB_CHAN0_ADDR_HI;
+		port->DMA_CHAN0_TRANS_STATE	= DMA_PORTB_CHAN0_TRANS_STATE;
+		port->DMA_CHAN0_CONTROL		= DMA_PORTB_CHAN0_CONTROL;
+		port->DMA_CHAN1_ADDR_LOW	= DMA_PORTB_CHAN1_ADDR_LOW;
+		port->DMA_CHAN1_ADDR_HI		= DMA_PORTB_CHAN1_ADDR_HI;
+		port->DMA_CHAN1_TRANS_STATE	= DMA_PORTB_CHAN1_TRANS_STATE;
+		port->DMA_CHAN1_CONTROL		= DMA_PORTB_CHAN1_CONTROL;
+		port->DMA_MANAGEMENT		= DMA_PORTB_MANAGEMENT;
+	}
+
+	if (port->_dmaInterruptCH0) {
+		port->cpu_addr[0] = pci_alloc_consistent(port->dev->pci_dev,
+					SMI_TS_DMA_BUF_SIZE,
+					&port->dma_addr[0]);
+		if (!port->cpu_addr[0]) {
+			dev_err(&port->dev->pci_dev->dev,
+				"Port[%d] DMA CH0 memory allocation failed!\n",
+				port->idx);
+			goto err;
+		}
+	}
+
+	if (port->_dmaInterruptCH1) {
+		port->cpu_addr[1] = pci_alloc_consistent(port->dev->pci_dev,
+					SMI_TS_DMA_BUF_SIZE,
+					&port->dma_addr[1]);
+		if (!port->cpu_addr[1]) {
+			dev_err(&port->dev->pci_dev->dev,
+				"Port[%d] DMA CH1 memory allocation failed!\n",
+				port->idx);
+			goto err;
+		}
+	}
+
+	smi_port_disableInterrupt(port);
+	tasklet_init(&port->tasklet, smi_dma_xfer, (unsigned long)port);
+	tasklet_disable(&port->tasklet);
+	port->enable = 1;
+	return 0;
+err:
+	smi_port_dma_free(port);
+	return -ENOMEM;
+}
+
+static void smi_port_exit(struct smi_port *port)
+{
+	smi_port_disableInterrupt(port);
+	tasklet_kill(&port->tasklet);
+	smi_port_dma_free(port);
+	port->enable = 0;
+}
+
+static void smi_port_irq(struct smi_port *port, u32 int_status)
+{
+	u32 port_req_irq = port->_dmaInterruptCH0 | port->_dmaInterruptCH1;
+
+	if (int_status & port_req_irq) {
+		smi_port_disableInterrupt(port);
+		port->_int_status = int_status;
+		smi_port_clearInterrupt(port);
+		tasklet_schedule(&port->tasklet);
+	}
+}
+
+static irqreturn_t smi_irq_handler(int irq, void *dev_id)
+{
+	struct smi_dev *dev = dev_id;
+	struct smi_port *port0 = &dev->ts_port[0];
+	struct smi_port *port1 = &dev->ts_port[1];
+
+	u32 intr_status = smi_read(MSI_INT_STATUS);
+
+	/* ts0 interrupt.*/
+	if (dev->info->ts_0)
+		smi_port_irq(port0, intr_status);
+
+	/* ts1 interrupt.*/
+	if (dev->info->ts_1)
+		smi_port_irq(port1, intr_status);
+
+	return IRQ_HANDLED;
+}
+
+static const struct m88ds3103_config smi_dvbsky_m88ds3103_cfg = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.clock_out = 0,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
+	.agc = 0x99,
+	.lnb_hv_pol = 0,
+	.lnb_en_pol = 1,
+};
+
+static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
+{
+	int ret = 0;
+	struct smi_dev *dev = port->dev;
+	struct i2c_adapter *i2c;
+	/* tuner I2C module */
+	struct i2c_adapter *tuner_i2c_adapter;
+	struct i2c_client *tuner_client;
+	struct i2c_board_info tuner_info;
+	struct m88ts2022_config m88ts2022_config = {
+			.clock = 27000000,
+		};
+	memset(&tuner_info, 0, sizeof(struct i2c_board_info));
+	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
+
+	/* attach demod */
+	port->fe = dvb_attach(m88ds3103_attach,
+			&smi_dvbsky_m88ds3103_cfg, i2c, &tuner_i2c_adapter);
+	if (!port->fe) {
+		ret = -ENODEV;
+		return ret;
+	}
+	/* attach tuner */
+	m88ts2022_config.fe = port->fe;
+	strlcpy(tuner_info.type, "m88ts2022", I2C_NAME_SIZE);
+	tuner_info.addr = 0x60;
+	tuner_info.platform_data = &m88ts2022_config;
+	request_module("m88ts2022");
+	tuner_client = i2c_new_device(tuner_i2c_adapter, &tuner_info);
+	if (tuner_client == NULL || tuner_client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_device;
+	}
+
+	if (!try_module_get(tuner_client->dev.driver->owner)) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_module;
+	}
+
+	/* delegate signal strength measurement to tuner */
+	port->fe->ops.read_signal_strength =
+			port->fe->ops.tuner_ops.get_rf_strength;
+
+	port->i2c_client_tuner = tuner_client;
+	return ret;
+
+err_tuner_i2c_module:
+	i2c_unregister_device(tuner_client);
+err_tuner_i2c_device:
+	dvb_frontend_detach(port->fe);
+	return ret;
+}
+
+static const struct m88ds3103_config smi_dvbsky_m88rs6000_cfg = {
+	.i2c_addr = 0x69,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
+	.agc = 0x99,
+	.lnb_hv_pol = 0,
+	.lnb_en_pol = 1,
+};
+
+static int smi_dvbsky_m88rs6000_fe_attach(struct smi_port *port)
+{
+	int ret = 0;
+	struct smi_dev *dev = port->dev;
+	struct i2c_adapter *i2c;
+	/* tuner I2C module */
+	struct i2c_adapter *tuner_i2c_adapter;
+	struct i2c_client *tuner_client;
+	struct i2c_board_info tuner_info;
+	struct m88rs6000t_config m88rs6000t_config;
+
+	memset(&tuner_info, 0, sizeof(struct i2c_board_info));
+	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
+
+	/* attach demod */
+	port->fe = dvb_attach(m88ds3103_attach,
+			&smi_dvbsky_m88rs6000_cfg, i2c, &tuner_i2c_adapter);
+	if (!port->fe) {
+		ret = -ENODEV;
+		return ret;
+	}
+	/* attach tuner */
+	m88rs6000t_config.fe = port->fe;
+	strlcpy(tuner_info.type, "m88rs6000t", I2C_NAME_SIZE);
+	tuner_info.addr = 0x21;
+	tuner_info.platform_data = &m88rs6000t_config;
+	request_module("m88rs6000t");
+	tuner_client = i2c_new_device(tuner_i2c_adapter, &tuner_info);
+	if (tuner_client == NULL || tuner_client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_device;
+	}
+
+	if (!try_module_get(tuner_client->dev.driver->owner)) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_module;
+	}
+
+	/* delegate signal strength measurement to tuner */
+	port->fe->ops.read_signal_strength =
+			port->fe->ops.tuner_ops.get_rf_strength;
+
+	port->i2c_client_tuner = tuner_client;
+	return ret;
+
+err_tuner_i2c_module:
+	i2c_unregister_device(tuner_client);
+err_tuner_i2c_device:
+	dvb_frontend_detach(port->fe);
+	return ret;
+}
+
+static int smi_fe_init(struct smi_port *port)
+{
+	int ret = 0;
+	struct smi_dev *dev = port->dev;
+	struct dvb_adapter *adap = &port->dvb_adapter;
+	u8 mac_ee[16];
+
+	dev_dbg(&port->dev->pci_dev->dev,
+		"%s: port %d, fe_type = %d\n",
+		__func__, port->idx, port->fe_type);
+	switch (port->fe_type) {
+	case DVBSKY_FE_M88DS3103:
+		ret = smi_dvbsky_m88ds3103_fe_attach(port);
+		break;
+	case DVBSKY_FE_M88RS6000:
+		ret = smi_dvbsky_m88rs6000_fe_attach(port);
+		break;
+	}
+	if (ret < 0)
+		return ret;
+
+	/* register dvb frontend */
+	ret = dvb_register_frontend(adap, port->fe);
+	if (ret < 0) {
+		i2c_unregister_device(port->i2c_client_tuner);
+		dvb_frontend_detach(port->fe);
+		return ret;
+	}
+	/* init MAC.*/
+	ret = smi_read_eeprom(&dev->i2c_bus[0], 0xc0, mac_ee, 16);
+	dev_info(&port->dev->pci_dev->dev,
+		"DVBSky SMI PCIe MAC= %pM\n", mac_ee + (port->idx)*8);
+	memcpy(adap->proposed_mac, mac_ee + (port->idx)*8, 6);
+	return ret;
+}
+
+static void smi_fe_exit(struct smi_port *port)
+{
+	struct i2c_client *tuner_client;
+
+	dvb_unregister_frontend(port->fe);
+	/* remove I2C tuner */
+	tuner_client = port->i2c_client_tuner;
+	if (tuner_client) {
+		module_put(tuner_client->dev.driver->owner);
+		i2c_unregister_device(tuner_client);
+	}
+	dvb_frontend_detach(port->fe);
+}
+
+static int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
+			    int (*start_feed)(struct dvb_demux_feed *),
+			    int (*stop_feed)(struct dvb_demux_feed *),
+			    void *priv)
+{
+	dvbdemux->priv = priv;
+
+	dvbdemux->filternum = 256;
+	dvbdemux->feednum = 256;
+	dvbdemux->start_feed = start_feed;
+	dvbdemux->stop_feed = stop_feed;
+	dvbdemux->write_to_decoder = NULL;
+	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
+				      DMX_SECTION_FILTERING |
+				      DMX_MEMORY_BASED_FILTERING);
+	return dvb_dmx_init(dvbdemux);
+}
+
+static int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
+			       struct dvb_demux *dvbdemux,
+			       struct dmx_frontend *hw_frontend,
+			       struct dmx_frontend *mem_frontend,
+			       struct dvb_adapter *dvb_adapter)
+{
+	int ret;
+
+	dmxdev->filternum = 256;
+	dmxdev->demux = &dvbdemux->dmx;
+	dmxdev->capabilities = 0;
+	ret = dvb_dmxdev_init(dmxdev, dvb_adapter);
+	if (ret < 0)
+		return ret;
+
+	hw_frontend->source = DMX_FRONTEND_0;
+	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, hw_frontend);
+	mem_frontend->source = DMX_MEMORY_FE;
+	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, mem_frontend);
+	return dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, hw_frontend);
+}
+
+static u32 smi_config_DMA(struct smi_port *port)
+{
+	struct smi_dev *dev = port->dev;
+	u32 totalLength = 0, dmaMemPtrLow, dmaMemPtrHi, dmaCtlReg;
+	u8 chanLatencyTimer = 0, dmaChanEnable = 1, dmaTransStart = 1;
+	u32 dmaManagement = 0, tlpTransUnit = DMA_TRANS_UNIT_188;
+	u8 tlpTc = 0, tlpTd = 1, tlpEp = 0, tlpAttr = 0;
+	u64 mem;
+
+	dmaManagement = smi_read(port->DMA_MANAGEMENT);
+    /* Setup Channel-0 */
+	if (port->_dmaInterruptCH0) {
+		totalLength = SMI_TS_DMA_BUF_SIZE;
+		mem = port->dma_addr[0];
+		dmaMemPtrLow = mem & 0xffffffff;
+		dmaMemPtrHi = mem >> 32;
+		dmaCtlReg = (totalLength) | (tlpTransUnit << 22) | (tlpTc << 25)
+			| (tlpTd << 28) | (tlpEp << 29) | (tlpAttr << 30);
+		dmaManagement |= dmaChanEnable | (dmaTransStart << 1)
+			| (chanLatencyTimer << 8);
+		/* write DMA register, start DMA engine */
+		smi_write(port->DMA_CHAN0_ADDR_LOW, dmaMemPtrLow);
+		smi_write(port->DMA_CHAN0_ADDR_HI, dmaMemPtrHi);
+		smi_write(port->DMA_CHAN0_CONTROL, dmaCtlReg);
+	}
+	/* Setup Channel-1 */
+	if (port->_dmaInterruptCH1) {
+		totalLength = SMI_TS_DMA_BUF_SIZE;
+		mem = port->dma_addr[1];
+		dmaMemPtrLow = mem & 0xffffffff;
+		dmaMemPtrHi = mem >> 32;
+		dmaCtlReg = (totalLength) | (tlpTransUnit << 22) | (tlpTc << 25)
+			| (tlpTd << 28) | (tlpEp << 29) | (tlpAttr << 30);
+		dmaManagement |= (dmaChanEnable << 16) | (dmaTransStart << 17)
+			| (chanLatencyTimer << 24);
+		/* write DMA register, start DMA engine */
+		smi_write(port->DMA_CHAN1_ADDR_LOW, dmaMemPtrLow);
+		smi_write(port->DMA_CHAN1_ADDR_HI, dmaMemPtrHi);
+		smi_write(port->DMA_CHAN1_CONTROL, dmaCtlReg);
+	}
+	return dmaManagement;
+}
+
+static int smi_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
+	struct smi_port *port = dvbdmx->priv;
+	struct smi_dev *dev = port->dev;
+	u32 dmaManagement;
+
+	if (port->users++ == 0) {
+		dmaManagement = smi_config_DMA(port);
+		smi_port_clearInterrupt(port);
+		smi_port_enableInterrupt(port);
+		smi_write(port->DMA_MANAGEMENT, dmaManagement);
+		tasklet_enable(&port->tasklet);
+	}
+	return port->users;
+}
+
+static int smi_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
+	struct smi_port *port = dvbdmx->priv;
+	struct smi_dev *dev = port->dev;
+
+	if (--port->users)
+		return port->users;
+
+	tasklet_disable(&port->tasklet);
+	smi_port_disableInterrupt(port);
+	smi_clear(port->DMA_MANAGEMENT, 0x30003);
+	return 0;
+}
+
+static int smi_dvb_init(struct smi_port *port)
+{
+	int ret;
+	struct dvb_adapter *adap = &port->dvb_adapter;
+	struct dvb_demux *dvbdemux = &port->demux;
+
+	dev_dbg(&port->dev->pci_dev->dev,
+		"%s, port %d\n", __func__, port->idx);
+
+	ret = dvb_register_adapter(adap, "SMI_DVB", THIS_MODULE,
+				   &port->dev->pci_dev->dev,
+				   adapter_nr);
+	if (ret < 0) {
+		dev_err(&port->dev->pci_dev->dev, "Fail to register DVB adapter.\n");
+		return ret;
+	}
+	ret = my_dvb_dmx_ts_card_init(dvbdemux, "SW demux",
+				      smi_start_feed,
+				      smi_stop_feed, port);
+	if (ret < 0)
+		goto err_del_dvb_register_adapter;
+
+	ret = my_dvb_dmxdev_ts_card_init(&port->dmxdev, &port->demux,
+					 &port->hw_frontend,
+					 &port->mem_frontend, adap);
+	if (ret < 0)
+		goto err_del_dvb_dmx;
+
+	ret = dvb_net_init(adap, &port->dvbnet, port->dmxdev.demux);
+	if (ret < 0)
+		goto err_del_dvb_dmxdev;
+	return 0;
+err_del_dvb_dmxdev:
+	dvbdemux->dmx.close(&dvbdemux->dmx);
+	dvbdemux->dmx.remove_frontend(&dvbdemux->dmx, &port->hw_frontend);
+	dvbdemux->dmx.remove_frontend(&dvbdemux->dmx, &port->mem_frontend);
+	dvb_dmxdev_release(&port->dmxdev);
+err_del_dvb_dmx:
+	dvb_dmx_release(&port->demux);
+err_del_dvb_register_adapter:
+	dvb_unregister_adapter(&port->dvb_adapter);
+	return ret;
+}
+
+static void smi_dvb_exit(struct smi_port *port)
+{
+	struct dvb_demux *dvbdemux = &port->demux;
+
+	dvb_net_release(&port->dvbnet);
+
+	dvbdemux->dmx.close(&dvbdemux->dmx);
+	dvbdemux->dmx.remove_frontend(&dvbdemux->dmx, &port->hw_frontend);
+	dvbdemux->dmx.remove_frontend(&dvbdemux->dmx, &port->mem_frontend);
+	dvb_dmxdev_release(&port->dmxdev);
+	dvb_dmx_release(&port->demux);
+
+	dvb_unregister_adapter(&port->dvb_adapter);
+}
+
+static int smi_port_attach(struct smi_dev *dev,
+		struct smi_port *port, int index)
+{
+	int ret, dmachs;
+
+	port->dev = dev;
+	port->idx = index;
+	port->fe_type = (index == 0) ? dev->info->fe_0 : dev->info->fe_1;
+	dmachs = (index == 0) ? dev->info->ts_0 : dev->info->ts_1;
+	/* port init.*/
+	ret = smi_port_init(port, dmachs);
+	if (ret < 0)
+		return ret;
+	/* dvb init.*/
+	ret = smi_dvb_init(port);
+	if (ret < 0)
+		goto err_del_port_init;
+	/* fe init.*/
+	ret = smi_fe_init(port);
+	if (ret < 0)
+		goto err_del_dvb_init;
+	return 0;
+err_del_dvb_init:
+	smi_dvb_exit(port);
+err_del_port_init:
+	smi_port_exit(port);
+	return ret;
+}
+
+static void smi_port_detach(struct smi_port *port)
+{
+	smi_fe_exit(port);
+	smi_dvb_exit(port);
+	smi_port_exit(port);
+}
+
+static int smi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct smi_dev *dev;
+	int ret = -ENOMEM;
+
+	if (pci_enable_device(pdev) < 0)
+		return -ENODEV;
+
+	dev = kzalloc(sizeof(struct smi_dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err_pci_disable_device;
+	}
+
+	dev->pci_dev = pdev;
+	pci_set_drvdata(pdev, dev);
+	dev->info = (struct smi_cfg_info *) id->driver_data;
+	dev_info(&dev->pci_dev->dev,
+		"card detected: %s\n", dev->info->name);
+
+	dev->nr = dev->info->type;
+	dev->lmmio = ioremap(pci_resource_start(dev->pci_dev, 0),
+			    pci_resource_len(dev->pci_dev, 0));
+	if (!dev->lmmio) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+
+	/* should we set to 32bit DMA? */
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret < 0)
+		goto err_pci_iounmap;
+
+	pci_set_master(pdev);
+
+	ret = smi_hw_init(dev);
+	if (ret < 0)
+		goto err_pci_iounmap;
+
+	ret = smi_i2c_init(dev);
+	if (ret < 0)
+		goto err_pci_iounmap;
+
+	if (dev->info->ts_0) {
+		ret = smi_port_attach(dev, &dev->ts_port[0], 0);
+		if (ret < 0)
+			goto err_del_i2c_adaptor;
+	}
+
+	if (dev->info->ts_1) {
+		ret = smi_port_attach(dev, &dev->ts_port[1], 1);
+		if (ret < 0)
+			goto err_del_port0_attach;
+	}
+
+#ifdef CONFIG_PCI_MSI /* to do msi interrupt.???*/
+	if (pci_msi_enabled())
+		ret = pci_enable_msi(dev->pci_dev);
+	if (ret)
+		dev_info(&dev->pci_dev->dev, "MSI not available.\n");
+#endif
+
+	ret = request_irq(dev->pci_dev->irq, smi_irq_handler,
+			   IRQF_SHARED, "SMI_PCIE", dev);
+	if (ret < 0)
+		goto err_del_port1_attach;
+
+	return 0;
+
+err_del_port1_attach:
+	if (dev->info->ts_1)
+		smi_port_detach(&dev->ts_port[1]);
+err_del_port0_attach:
+	if (dev->info->ts_0)
+		smi_port_detach(&dev->ts_port[0]);
+err_del_i2c_adaptor:
+	smi_i2c_exit(dev);
+err_pci_iounmap:
+	iounmap(dev->lmmio);
+err_kfree:
+	pci_set_drvdata(pdev, 0);
+	kfree(dev);
+err_pci_disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void smi_remove(struct pci_dev *pdev)
+{
+	struct smi_dev *dev = pci_get_drvdata(pdev);
+
+	smi_write(MSI_INT_ENA_CLR, ALL_INT);
+	free_irq(dev->pci_dev->irq, dev);
+#ifdef CONFIG_PCI_MSI
+	pci_disable_msi(dev->pci_dev);
+#endif
+	if (dev->info->ts_1)
+		smi_port_detach(&dev->ts_port[1]);
+	if (dev->info->ts_0)
+		smi_port_detach(&dev->ts_port[0]);
+
+	smi_i2c_exit(dev);
+	iounmap(dev->lmmio);
+	pci_set_drvdata(pdev, 0);
+	pci_disable_device(pdev);
+	kfree(dev);
+}
+
+/* DVBSky cards */
+static struct smi_cfg_info dvbsky_s950_cfg = {
+	.type = SMI_DVBSKY_S950,
+	.name = "DVBSky S950 V3",
+	.ts_0 = SMI_TS_NULL,
+	.ts_1 = SMI_TS_DMA_BOTH,
+	.fe_0 = DVBSKY_FE_NULL,
+	.fe_1 = DVBSKY_FE_M88DS3103,
+};
+
+static struct smi_cfg_info dvbsky_s952_cfg = {
+	.type = SMI_DVBSKY_S952,
+	.name = "DVBSky S952 V3",
+	.ts_0 = SMI_TS_DMA_BOTH,
+	.ts_1 = SMI_TS_DMA_BOTH,
+	.fe_0 = DVBSKY_FE_M88RS6000,
+	.fe_1 = DVBSKY_FE_M88RS6000,
+};
+
+/* PCI IDs */
+#define SMI_ID(_subvend, _subdev, _driverdata) {	\
+	.vendor      = SMI_VID,    .device    = SMI_PID, \
+	.subvendor   = _subvend, .subdevice = _subdev, \
+	.driver_data = (unsigned long)&_driverdata }
+
+static const struct pci_device_id smi_id_table[] = {
+	SMI_ID(0x4254, 0x0550, dvbsky_s950_cfg),
+	SMI_ID(0x4254, 0x0552, dvbsky_s952_cfg),
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, smi_id_table);
+
+static struct pci_driver smipcie_driver = {
+	.name = "SMI PCIe driver",
+	.id_table = smi_id_table,
+	.probe = smi_probe,
+	.remove = smi_remove,
+};
+
+module_pci_driver(smipcie_driver);
+
+MODULE_AUTHOR("Max nibble <nibble.max@gmail.com>");
+MODULE_DESCRIPTION("SMI PCIe driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
new file mode 100644
index 0000000..2bc8a0f
--- /dev/null
+++ b/drivers/media/pci/smipcie/smipcie.h
@@ -0,0 +1,298 @@
+/*
+ * SMI PCIe driver for DVBSky cards.
+ *
+ * Copyright (C) 2014 Max nibble <nibble.max@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#ifndef _SMI_PCIE_H_
+#define _SMI_PCIE_H_
+
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+#include "demux.h"
+#include "dmxdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+#include "dvbdev.h"
+
+/* -------- Register Base -------- */
+#define    MSI_CONTROL_REG_BASE                 0x0800
+#define    SYSTEM_CONTROL_REG_BASE              0x0880
+#define    PCIE_EP_DEBUG_REG_BASE               0x08C0
+#define    IR_CONTROL_REG_BASE                  0x0900
+#define    I2C_A_CONTROL_REG_BASE               0x0940
+#define    I2C_B_CONTROL_REG_BASE               0x0980
+#define    ATV_PORTA_CONTROL_REG_BASE           0x09C0
+#define    DTV_PORTA_CONTROL_REG_BASE           0x0A00
+#define    AES_PORTA_CONTROL_REG_BASE           0x0A80
+#define    DMA_PORTA_CONTROL_REG_BASE           0x0AC0
+#define    ATV_PORTB_CONTROL_REG_BASE           0x0B00
+#define    DTV_PORTB_CONTROL_REG_BASE           0x0B40
+#define    AES_PORTB_CONTROL_REG_BASE           0x0BC0
+#define    DMA_PORTB_CONTROL_REG_BASE           0x0C00
+#define    UART_A_REGISTER_BASE                 0x0C40
+#define    UART_B_REGISTER_BASE                 0x0C80
+#define    GPS_CONTROL_REG_BASE                 0x0CC0
+#define    DMA_PORTC_CONTROL_REG_BASE           0x0D00
+#define    DMA_PORTD_CONTROL_REG_BASE           0x0D00
+#define    AES_RANDOM_DATA_BASE                 0x0D80
+#define    AES_KEY_IN_BASE                      0x0D90
+#define    RANDOM_DATA_LIB_BASE                 0x0E00
+#define    IR_DATA_BUFFER_BASE                  0x0F00
+#define    PORTA_TS_BUFFER_BASE                 0x1000
+#define    PORTA_I2S_BUFFER_BASE                0x1400
+#define    PORTB_TS_BUFFER_BASE                 0x1800
+#define    PORTB_I2S_BUFFER_BASE                0x1C00
+
+/* -------- MSI control and state register -------- */
+#define MSI_DELAY_TIMER             (MSI_CONTROL_REG_BASE + 0x00)
+#define MSI_INT_STATUS              (MSI_CONTROL_REG_BASE + 0x08)
+#define MSI_INT_STATUS_CLR          (MSI_CONTROL_REG_BASE + 0x0C)
+#define MSI_INT_STATUS_SET          (MSI_CONTROL_REG_BASE + 0x10)
+#define MSI_INT_ENA                 (MSI_CONTROL_REG_BASE + 0x14)
+#define MSI_INT_ENA_CLR             (MSI_CONTROL_REG_BASE + 0x18)
+#define MSI_INT_ENA_SET             (MSI_CONTROL_REG_BASE + 0x1C)
+#define MSI_SOFT_RESET              (MSI_CONTROL_REG_BASE + 0x20)
+#define MSI_CFG_SRC0                (MSI_CONTROL_REG_BASE + 0x24)
+
+/* -------- Hybird Controller System Control register -------- */
+#define MUX_MODE_CTRL         (SYSTEM_CONTROL_REG_BASE + 0x00)
+	#define rbPaMSMask        0x07
+	#define rbPaMSDtvNoGpio   0x00 /*[2:0], DTV Simple mode */
+	#define rbPaMSDtv4bitGpio 0x01 /*[2:0], DTV TS2 Serial mode)*/
+	#define rbPaMSDtv7bitGpio 0x02 /*[2:0], DTV TS0 Serial mode*/
+	#define rbPaMS8bitGpio    0x03 /*[2:0], GPIO mode selected;(8bit GPIO)*/
+	#define rbPaMSAtv         0x04 /*[2:0], 3'b1xx: ATV mode select*/
+	#define rbPbMSMask        0x38
+	#define rbPbMSDtvNoGpio   0x00 /*[5:3], DTV Simple mode */
+	#define rbPbMSDtv4bitGpio 0x08 /*[5:3], DTV TS2 Serial mode*/
+	#define rbPbMSDtv7bitGpio 0x10 /*[5:3], DTV TS0 Serial mode*/
+	#define rbPbMS8bitGpio    0x18 /*[5:3], GPIO mode selected;(8bit GPIO)*/
+	#define rbPbMSAtv         0x20 /*[5:3], 3'b1xx: ATV mode select*/
+	#define rbPaAESEN         0x40 /*[6], port A AES enable bit*/
+	#define rbPbAESEN         0x80 /*[7], port B AES enable bit*/
+
+#define INTERNAL_RST                (SYSTEM_CONTROL_REG_BASE + 0x04)
+#define PERIPHERAL_CTRL             (SYSTEM_CONTROL_REG_BASE + 0x08)
+#define GPIO_0to7_CTRL              (SYSTEM_CONTROL_REG_BASE + 0x0C)
+#define GPIO_8to15_CTRL             (SYSTEM_CONTROL_REG_BASE + 0x10)
+#define GPIO_16to24_CTRL            (SYSTEM_CONTROL_REG_BASE + 0x14)
+#define GPIO_INT_SRC_CFG            (SYSTEM_CONTROL_REG_BASE + 0x18)
+#define SYS_BUF_STATUS              (SYSTEM_CONTROL_REG_BASE + 0x1C)
+#define PCIE_IP_REG_ACS             (SYSTEM_CONTROL_REG_BASE + 0x20)
+#define PCIE_IP_REG_ACS_ADDR        (SYSTEM_CONTROL_REG_BASE + 0x24)
+#define PCIE_IP_REG_ACS_DATA        (SYSTEM_CONTROL_REG_BASE + 0x28)
+
+/* -------- IR Control register -------- */
+#define   IR_Init_Reg         (IR_CONTROL_REG_BASE + 0x00)
+#define   IR_Idle_Cnt_Low     (IR_CONTROL_REG_BASE + 0x04)
+#define   IR_Idle_Cnt_High    (IR_CONTROL_REG_BASE + 0x05)
+#define   IR_Unit_Cnt_Low     (IR_CONTROL_REG_BASE + 0x06)
+#define   IR_Unit_Cnt_High    (IR_CONTROL_REG_BASE + 0x07)
+#define   IR_Data_Cnt         (IR_CONTROL_REG_BASE + 0x08)
+#define   rbIRen            0x80
+#define   rbIRhighidle      0x10
+#define   rbIRlowidle       0x00
+#define   rbIRVld           0x04
+
+/* -------- I2C A control and state register -------- */
+#define I2C_A_CTL_STATUS                 (I2C_A_CONTROL_REG_BASE + 0x00)
+#define I2C_A_ADDR                       (I2C_A_CONTROL_REG_BASE + 0x04)
+#define I2C_A_SW_CTL                     (I2C_A_CONTROL_REG_BASE + 0x08)
+#define I2C_A_TIME_OUT_CNT               (I2C_A_CONTROL_REG_BASE + 0x0C)
+#define I2C_A_FIFO_STATUS                (I2C_A_CONTROL_REG_BASE + 0x10)
+#define I2C_A_FS_EN                      (I2C_A_CONTROL_REG_BASE + 0x14)
+#define I2C_A_FIFO_DATA                  (I2C_A_CONTROL_REG_BASE + 0x20)
+
+/* -------- I2C B control and state register -------- */
+#define I2C_B_CTL_STATUS                 (I2C_B_CONTROL_REG_BASE + 0x00)
+#define I2C_B_ADDR                       (I2C_B_CONTROL_REG_BASE + 0x04)
+#define I2C_B_SW_CTL                     (I2C_B_CONTROL_REG_BASE + 0x08)
+#define I2C_B_TIME_OUT_CNT               (I2C_B_CONTROL_REG_BASE + 0x0C)
+#define I2C_B_FIFO_STATUS                (I2C_B_CONTROL_REG_BASE + 0x10)
+#define I2C_B_FS_EN                      (I2C_B_CONTROL_REG_BASE + 0x14)
+#define I2C_B_FIFO_DATA                  (I2C_B_CONTROL_REG_BASE + 0x20)
+
+#define VIDEO_CTRL_STATUS_A	(ATV_PORTA_CONTROL_REG_BASE + 0x04)
+
+/* -------- Digital TV control register, Port A -------- */
+#define MPEG2_CTRL_A		(DTV_PORTA_CONTROL_REG_BASE + 0x00)
+#define SERIAL_IN_ADDR_A	(DTV_PORTA_CONTROL_REG_BASE + 0x4C)
+#define VLD_CNT_ADDR_A		(DTV_PORTA_CONTROL_REG_BASE + 0x60)
+#define ERR_CNT_ADDR_A		(DTV_PORTA_CONTROL_REG_BASE + 0x64)
+#define BRD_CNT_ADDR_A		(DTV_PORTA_CONTROL_REG_BASE + 0x68)
+
+/* -------- DMA Control Register, Port A  -------- */
+#define DMA_PORTA_CHAN0_ADDR_LOW        (DMA_PORTA_CONTROL_REG_BASE + 0x00)
+#define DMA_PORTA_CHAN0_ADDR_HI         (DMA_PORTA_CONTROL_REG_BASE + 0x04)
+#define DMA_PORTA_CHAN0_TRANS_STATE     (DMA_PORTA_CONTROL_REG_BASE + 0x08)
+#define DMA_PORTA_CHAN0_CONTROL         (DMA_PORTA_CONTROL_REG_BASE + 0x0C)
+#define DMA_PORTA_CHAN1_ADDR_LOW        (DMA_PORTA_CONTROL_REG_BASE + 0x10)
+#define DMA_PORTA_CHAN1_ADDR_HI         (DMA_PORTA_CONTROL_REG_BASE + 0x14)
+#define DMA_PORTA_CHAN1_TRANS_STATE     (DMA_PORTA_CONTROL_REG_BASE + 0x18)
+#define DMA_PORTA_CHAN1_CONTROL         (DMA_PORTA_CONTROL_REG_BASE + 0x1C)
+#define DMA_PORTA_MANAGEMENT            (DMA_PORTA_CONTROL_REG_BASE + 0x20)
+#define VIDEO_CTRL_STATUS_B             (ATV_PORTB_CONTROL_REG_BASE + 0x04)
+
+/* -------- Digital TV control register, Port B -------- */
+#define MPEG2_CTRL_B		(DTV_PORTB_CONTROL_REG_BASE + 0x00)
+#define SERIAL_IN_ADDR_B	(DTV_PORTB_CONTROL_REG_BASE + 0x4C)
+#define VLD_CNT_ADDR_B		(DTV_PORTB_CONTROL_REG_BASE + 0x60)
+#define ERR_CNT_ADDR_B		(DTV_PORTB_CONTROL_REG_BASE + 0x64)
+#define BRD_CNT_ADDR_B		(DTV_PORTB_CONTROL_REG_BASE + 0x68)
+
+/* -------- AES control register, Port B -------- */
+#define AES_CTRL_B		(AES_PORTB_CONTROL_REG_BASE + 0x00)
+#define AES_KEY_BASE_B	(AES_PORTB_CONTROL_REG_BASE + 0x04)
+
+/* -------- DMA Control Register, Port B  -------- */
+#define DMA_PORTB_CHAN0_ADDR_LOW        (DMA_PORTB_CONTROL_REG_BASE + 0x00)
+#define DMA_PORTB_CHAN0_ADDR_HI         (DMA_PORTB_CONTROL_REG_BASE + 0x04)
+#define DMA_PORTB_CHAN0_TRANS_STATE     (DMA_PORTB_CONTROL_REG_BASE + 0x08)
+#define DMA_PORTB_CHAN0_CONTROL         (DMA_PORTB_CONTROL_REG_BASE + 0x0C)
+#define DMA_PORTB_CHAN1_ADDR_LOW        (DMA_PORTB_CONTROL_REG_BASE + 0x10)
+#define DMA_PORTB_CHAN1_ADDR_HI         (DMA_PORTB_CONTROL_REG_BASE + 0x14)
+#define DMA_PORTB_CHAN1_TRANS_STATE     (DMA_PORTB_CONTROL_REG_BASE + 0x18)
+#define DMA_PORTB_CHAN1_CONTROL         (DMA_PORTB_CONTROL_REG_BASE + 0x1C)
+#define DMA_PORTB_MANAGEMENT            (DMA_PORTB_CONTROL_REG_BASE + 0x20)
+
+#define DMA_TRANS_UNIT_188 (0x00000007)
+
+/* -------- Macro define of 24 interrupt resource --------*/
+#define DMA_A_CHAN0_DONE_INT   (0x00000001)
+#define DMA_A_CHAN1_DONE_INT   (0x00000002)
+#define DMA_B_CHAN0_DONE_INT   (0x00000004)
+#define DMA_B_CHAN1_DONE_INT   (0x00000008)
+#define DMA_C_CHAN0_DONE_INT   (0x00000010)
+#define DMA_C_CHAN1_DONE_INT   (0x00000020)
+#define DMA_D_CHAN0_DONE_INT   (0x00000040)
+#define DMA_D_CHAN1_DONE_INT   (0x00000080)
+#define DATA_BUF_OVERFLOW_INT  (0x00000100)
+#define UART_0_X_INT           (0x00000200)
+#define UART_1_X_INT           (0x00000400)
+#define IR_X_INT               (0x00000800)
+#define GPIO_0_INT             (0x00001000)
+#define GPIO_1_INT             (0x00002000)
+#define GPIO_2_INT             (0x00004000)
+#define GPIO_3_INT             (0x00008000)
+#define ALL_INT                (0x0000FFFF)
+
+/* software I2C bit mask */
+#define SW_I2C_MSK_MODE         0x01
+#define SW_I2C_MSK_CLK_OUT      0x02
+#define SW_I2C_MSK_DAT_OUT      0x04
+#define SW_I2C_MSK_CLK_EN       0x08
+#define SW_I2C_MSK_DAT_EN       0x10
+#define SW_I2C_MSK_DAT_IN       0x40
+#define SW_I2C_MSK_CLK_IN       0x80
+
+#define SMI_VID		0x1ADE
+#define SMI_PID		0x3038
+#define SMI_TS_DMA_BUF_SIZE	(1024 * 188)
+
+struct smi_cfg_info {
+#define SMI_DVBSKY_S952         0
+#define SMI_DVBSKY_S950         1
+#define SMI_DVBSKY_T9580        2
+#define SMI_DVBSKY_T982         3
+	int type;
+	char *name;
+#define SMI_TS_NULL             0
+#define SMI_TS_DMA_SINGLE       1
+#define SMI_TS_DMA_BOTH         3
+/* SMI_TS_NULL: not use;
+ * SMI_TS_DMA_SINGLE: use DMA 0 only;
+ * SMI_TS_DMA_BOTH:use DMA 0 and 1.*/
+	int ts_0;
+	int ts_1;
+#define DVBSKY_FE_NULL          0
+#define DVBSKY_FE_M88RS6000     1
+#define DVBSKY_FE_M88DS3103     2
+#define DVBSKY_FE_SIT2          3
+	int fe_0;
+	int fe_1;
+};
+
+struct smi_port {
+	struct smi_dev *dev;
+	int idx;
+	int enable;
+	int fe_type;
+	/* regs */
+	u32 DMA_CHAN0_ADDR_LOW;
+	u32 DMA_CHAN0_ADDR_HI;
+	u32 DMA_CHAN0_TRANS_STATE;
+	u32 DMA_CHAN0_CONTROL;
+	u32 DMA_CHAN1_ADDR_LOW;
+	u32 DMA_CHAN1_ADDR_HI;
+	u32 DMA_CHAN1_TRANS_STATE;
+	u32 DMA_CHAN1_CONTROL;
+	u32 DMA_MANAGEMENT;
+	/* dma */
+	dma_addr_t dma_addr[2];
+	u8 *cpu_addr[2];
+	u32 _dmaInterruptCH0;
+	u32 _dmaInterruptCH1;
+	u32 _int_status;
+	struct tasklet_struct tasklet;
+	/* dvb */
+	struct dmx_frontend hw_frontend;
+	struct dmx_frontend mem_frontend;
+	struct dmxdev dmxdev;
+	struct dvb_adapter dvb_adapter;
+	struct dvb_demux demux;
+	struct dvb_net dvbnet;
+	int users;
+	struct dvb_frontend *fe;
+	/* frontend i2c module */
+	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_tuner;
+};
+
+struct smi_dev {
+	int nr;
+	struct smi_cfg_info *info;
+
+	/* pcie */
+	struct pci_dev *pci_dev;
+	u32 __iomem *lmmio;
+
+	/* ts port */
+	struct smi_port ts_port[2];
+
+	/* i2c */
+	struct i2c_adapter i2c_bus[2];
+	struct i2c_algo_bit_data i2c_bit[2];
+};
+
+#define smi_read(reg)             readl(dev->lmmio + ((reg)>>2))
+#define smi_write(reg, value)     writel((value), dev->lmmio + ((reg)>>2))
+
+#define smi_andor(reg, mask, value) \
+	writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
+	((value) & (mask)), dev->lmmio+((reg)>>2))
+
+#define smi_set(reg, bit)          smi_andor((reg), (bit), (bit))
+#define smi_clear(reg, bit)        smi_andor((reg), (bit), 0)
+
+#endif /* #ifndef _SMI_PCIE_H_ */

-- 
1.9.1

