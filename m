Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:56634 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbbG1Owh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 10:52:37 -0400
From: serjk@netup.ru
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, aospan1@gmail.com,
	Kozlov Sergey <serjk@netup.ru>
Subject: [PATCH v3 5/5] [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
Date: Tue, 28 Jul 2015 17:33:04 +0300
Message-Id: <06cef00ffa5b1a07ec8e2d55a962dda9abeae657.1438090209.git.serjk@netup.ru>
In-Reply-To: <cover.1438090209.git.serjk@netup.ru>
References: <cover.1438090209.git.serjk@netup.ru>
In-Reply-To: <cover.1438090209.git.serjk@netup.ru>
References: <cover.1438090209.git.serjk@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kozlov Sergey <serjk@netup.ru>

Add NetUP Dual Universal CI PCIe board driver.
The board has
    - two CI slots
    - two I2C adapters
    - SPI master bus for accessing flash memory containing
      FPGA firmware

No changes required.

Signed-off-by: Kozlov Sergey <serjk@netup.ru>
---
 MAINTAINERS                                        |    9 +
 drivers/media/pci/Kconfig                          |    1 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/netup_unidvb/Kconfig             |   12 +
 drivers/media/pci/netup_unidvb/Makefile            |    9 +
 drivers/media/pci/netup_unidvb/netup_unidvb.h      |  133 +++
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c   |  248 +++++
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 1001 ++++++++++++++++++++
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c  |  381 ++++++++
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c  |  252 +++++
 10 files changed, 2048 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/pci/netup_unidvb/Kconfig
 create mode 100644 drivers/media/pci/netup_unidvb/Makefile
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb.h
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_core.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 40e630d..91da895 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6380,6 +6380,15 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/lnbh25*
 
+MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
+M:	Sergey Kozlov <serjk@netup.ru>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	drivers/media/pci/netup_unidvb/*
+
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 P:	LinuxTV.org Project
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 218144a..4bc9188 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -47,6 +47,7 @@ source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
 source "drivers/media/pci/smipcie/Kconfig"
+source "drivers/media/pci/netup_unidvb/Kconfig"
 endif
 
 endif #MEDIA_PCI_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 0baf0d2..515cf0f 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -12,7 +12,8 @@ obj-y        +=	ttpci/		\
 		ngene/		\
 		ddbridge/	\
 		saa7146/	\
-		smipcie/
+		smipcie/	\
+		netup_unidvb/
 
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
diff --git a/drivers/media/pci/netup_unidvb/Kconfig b/drivers/media/pci/netup_unidvb/Kconfig
new file mode 100644
index 0000000..f277b0b
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/Kconfig
@@ -0,0 +1,12 @@
+config DVB_NETUP_UNIDVB
+	tristate "NetUP Universal DVB card support"
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && SPI_MASTER
+    select VIDEOBUF2_DVB
+    select VIDEOBUF2_VMALLOC
+	select DVB_HORUS3A if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_ASCOT2E if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
+	---help---
+	  Support for NetUP PCI express Universal DVB card.
+
diff --git a/drivers/media/pci/netup_unidvb/Makefile b/drivers/media/pci/netup_unidvb/Makefile
new file mode 100644
index 0000000..ee6ae05
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/Makefile
@@ -0,0 +1,9 @@
+netup-unidvb-objs += netup_unidvb_core.o
+netup-unidvb-objs += netup_unidvb_i2c.o
+netup-unidvb-objs += netup_unidvb_ci.o
+netup-unidvb-objs += netup_unidvb_spi.o
+
+obj-$(CONFIG_DVB_NETUP_UNIDVB) += netup-unidvb.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb.h b/drivers/media/pci/netup_unidvb/netup_unidvb.h
new file mode 100644
index 0000000..fa95110
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb.h
@@ -0,0 +1,133 @@
+/*
+ * netup_unidvb.h
+ *
+ * Data type definitions for NetUP Universal Dual DVB-CI
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-dvb.h>
+#include <dvb_ca_en50221.h>
+
+#define NETUP_UNIDVB_NAME	"netup_unidvb"
+#define NETUP_UNIDVB_VERSION	"0.0.1"
+#define NETUP_VENDOR_ID		0x1b55
+#define NETUP_PCI_DEV_REVISION  0x2
+
+/* IRQ-related regisers */
+#define REG_ISR			0x4890
+#define REG_ISR_MASKED		0x4892
+#define REG_IMASK_SET		0x4894
+#define REG_IMASK_CLEAR		0x4896
+/* REG_ISR register bits */
+#define NETUP_UNIDVB_IRQ_SPI	(1 << 0)
+#define NETUP_UNIDVB_IRQ_I2C0	(1 << 1)
+#define NETUP_UNIDVB_IRQ_I2C1	(1 << 2)
+#define NETUP_UNIDVB_IRQ_FRA0	(1 << 4)
+#define NETUP_UNIDVB_IRQ_FRA1	(1 << 5)
+#define NETUP_UNIDVB_IRQ_FRB0	(1 << 6)
+#define NETUP_UNIDVB_IRQ_FRB1	(1 << 7)
+#define NETUP_UNIDVB_IRQ_DMA1	(1 << 8)
+#define NETUP_UNIDVB_IRQ_DMA2	(1 << 9)
+#define NETUP_UNIDVB_IRQ_CI	(1 << 10)
+#define NETUP_UNIDVB_IRQ_CAM0	(1 << 11)
+#define NETUP_UNIDVB_IRQ_CAM1	(1 << 12)
+
+struct netup_dma {
+	u8			num;
+	spinlock_t		lock;
+	struct netup_unidvb_dev	*ndev;
+	struct netup_dma_regs	*regs;
+	u32			ring_buffer_size;
+	u8			*addr_virt;
+	dma_addr_t		addr_phys;
+	u64			addr_last;
+	u32			high_addr;
+	u32			data_offset;
+	u32			data_size;
+	struct list_head	free_buffers;
+	struct work_struct	work;
+	struct timer_list	timeout;
+};
+
+enum netup_i2c_state {
+	STATE_DONE,
+	STATE_WAIT,
+	STATE_WANT_READ,
+	STATE_WANT_WRITE,
+	STATE_ERROR
+};
+
+struct netup_i2c_regs;
+
+struct netup_i2c {
+	spinlock_t			lock;
+	wait_queue_head_t		wq;
+	struct i2c_adapter		adap;
+	struct netup_unidvb_dev		*dev;
+	struct netup_i2c_regs		*regs;
+	struct i2c_msg			*msg;
+	enum netup_i2c_state		state;
+	u32				xmit_size;
+};
+
+struct netup_ci_state {
+	struct dvb_ca_en50221		ca;
+	u8 __iomem			*membase8_config;
+	u8 __iomem			*membase8_io;
+	struct netup_unidvb_dev		*dev;
+	int status;
+	int nr;
+};
+
+struct netup_spi;
+
+struct netup_unidvb_dev {
+	struct pci_dev			*pci_dev;
+	int				pci_bus;
+	int				pci_slot;
+	int				pci_func;
+	int				board_num;
+	int				old_fw;
+	u32 __iomem			*lmmio0;
+	u8 __iomem			*bmmio0;
+	u32 __iomem			*lmmio1;
+	u8 __iomem			*bmmio1;
+	u8				*dma_virt;
+	dma_addr_t			dma_phys;
+	u32				dma_size;
+	struct vb2_dvb_frontends	frontends[2];
+	struct netup_i2c		i2c[2];
+	struct workqueue_struct		*wq;
+	struct netup_dma		dma[2];
+	struct netup_ci_state		ci[2];
+	struct netup_spi		*spi;
+};
+
+int netup_i2c_register(struct netup_unidvb_dev *ndev);
+void netup_i2c_unregister(struct netup_unidvb_dev *ndev);
+irqreturn_t netup_ci_interrupt(struct netup_unidvb_dev *ndev);
+irqreturn_t netup_i2c_interrupt(struct netup_i2c *i2c);
+irqreturn_t netup_spi_interrupt(struct netup_spi *spi);
+int netup_unidvb_ci_register(struct netup_unidvb_dev *dev,
+			     int num, struct pci_dev *pci_dev);
+void netup_unidvb_ci_unregister(struct netup_unidvb_dev *dev, int num);
+int netup_spi_init(struct netup_unidvb_dev *ndev);
+void netup_spi_release(struct netup_unidvb_dev *ndev);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
new file mode 100644
index 0000000..751b51b
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
@@ -0,0 +1,248 @@
+/*
+ * netup_unidvb_ci.c
+ *
+ * DVB CAM support for NetUP Universal Dual DVB-CI
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kmod.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include "netup_unidvb.h"
+
+/* CI slot 0 base address */
+#define CAM0_CONFIG		0x0
+#define CAM0_IO			0x8000
+#define CAM0_MEM		0x10000
+#define CAM0_SZ			32
+/* CI slot 1 base address */
+#define CAM1_CONFIG		0x20000
+#define CAM1_IO			0x28000
+#define CAM1_MEM		0x30000
+#define CAM1_SZ			32
+/* ctrlstat registers */
+#define CAM_CTRLSTAT_READ_SET	0x4980
+#define CAM_CTRLSTAT_CLR	0x4982
+/* register bits */
+#define BIT_CAM_STCHG		(1<<0)
+#define BIT_CAM_PRESENT		(1<<1)
+#define BIT_CAM_RESET		(1<<2)
+#define BIT_CAM_BYPASS		(1<<3)
+#define BIT_CAM_READY		(1<<4)
+#define BIT_CAM_ERROR		(1<<5)
+#define BIT_CAM_OVERCURR	(1<<6)
+/* BIT_CAM_BYPASS bit shift for SLOT 1 */
+#define CAM1_SHIFT 8
+
+irqreturn_t netup_ci_interrupt(struct netup_unidvb_dev *ndev)
+{
+	writew(0x101, ndev->bmmio0 + CAM_CTRLSTAT_CLR);
+	return IRQ_HANDLED;
+}
+
+static int netup_unidvb_ci_slot_ts_ctl(struct dvb_ca_en50221 *en50221,
+				       int slot)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+	u16 shift = (state->nr == 1) ? CAM1_SHIFT : 0;
+
+	dev_dbg(&dev->pci_dev->dev, "%s(): CAM_CTRLSTAT=0x%x\n",
+		__func__, readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET));
+	if (slot != 0)
+		return -EINVAL;
+	/* pass data to CAM module */
+	writew(BIT_CAM_BYPASS << shift, dev->bmmio0 + CAM_CTRLSTAT_CLR);
+	dev_dbg(&dev->pci_dev->dev, "%s(): CAM_CTRLSTAT=0x%x done\n",
+		__func__, readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET));
+	return 0;
+}
+
+static int netup_unidvb_ci_slot_shutdown(struct dvb_ca_en50221 *en50221,
+					 int slot)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+
+	dev_dbg(&dev->pci_dev->dev, "%s()\n", __func__);
+	return 0;
+}
+
+static int netup_unidvb_ci_slot_reset(struct dvb_ca_en50221 *en50221,
+				      int slot)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+	unsigned long timeout = 0;
+	u16 shift = (state->nr == 1) ? CAM1_SHIFT : 0;
+	u16 ci_stat = 0;
+	int reset_counter = 3;
+
+	dev_dbg(&dev->pci_dev->dev, "%s(): CAM_CTRLSTAT_READ_SET=0x%x\n",
+		__func__, readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET));
+reset:
+	timeout = jiffies + msecs_to_jiffies(5000);
+	/* start reset */
+	writew(BIT_CAM_RESET << shift, dev->bmmio0 + CAM_CTRLSTAT_READ_SET);
+	dev_dbg(&dev->pci_dev->dev, "%s(): waiting for reset\n", __func__);
+	/* wait until reset done */
+	while (time_before(jiffies, timeout)) {
+		ci_stat = readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET);
+		if (ci_stat & (BIT_CAM_READY << shift))
+			break;
+		udelay(1000);
+	}
+	if (!(ci_stat & (BIT_CAM_READY << shift)) && reset_counter > 0) {
+		dev_dbg(&dev->pci_dev->dev,
+			"%s(): CAMP reset timeout! Will try again..\n",
+			 __func__);
+		reset_counter--;
+		goto reset;
+	}
+	return 0;
+}
+
+static int netup_unidvb_poll_ci_slot_status(struct dvb_ca_en50221 *en50221,
+					    int slot, int open)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+	u16 shift = (state->nr == 1) ? CAM1_SHIFT : 0;
+	u16 ci_stat = 0;
+
+	dev_dbg(&dev->pci_dev->dev, "%s(): CAM_CTRLSTAT_READ_SET=0x%x\n",
+		__func__, readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET));
+	ci_stat = readw(dev->bmmio0 + CAM_CTRLSTAT_READ_SET);
+	if (ci_stat & (BIT_CAM_READY << shift)) {
+		state->status = DVB_CA_EN50221_POLL_CAM_PRESENT |
+			DVB_CA_EN50221_POLL_CAM_READY;
+	} else if (ci_stat & (BIT_CAM_PRESENT << shift)) {
+		state->status = DVB_CA_EN50221_POLL_CAM_PRESENT;
+	} else {
+		state->status = 0;
+	}
+	return state->status;
+}
+
+static int netup_unidvb_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
+					      int slot, int addr)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+	u8 val = state->membase8_config[addr];
+
+	dev_dbg(&dev->pci_dev->dev,
+		"%s(): addr=0x%x val=0x%x\n", __func__, addr, val);
+	return val;
+}
+
+static int netup_unidvb_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
+					       int slot, int addr, u8 data)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+
+	dev_dbg(&dev->pci_dev->dev,
+		"%s(): addr=0x%x data=0x%x\n", __func__, addr, data);
+	state->membase8_config[addr] = data;
+	return 0;
+}
+
+static int netup_unidvb_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221,
+					int slot, u8 addr)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+	u8 val = state->membase8_io[addr];
+
+	dev_dbg(&dev->pci_dev->dev,
+		"%s(): addr=0x%x val=0x%x\n", __func__, addr, val);
+	return val;
+}
+
+static int netup_unidvb_ci_write_cam_ctl(struct dvb_ca_en50221 *en50221,
+					 int slot, u8 addr, u8 data)
+{
+	struct netup_ci_state *state = en50221->data;
+	struct netup_unidvb_dev *dev = state->dev;
+
+	dev_dbg(&dev->pci_dev->dev,
+		"%s(): addr=0x%x data=0x%x\n", __func__, addr, data);
+	state->membase8_io[addr] = data;
+	return 0;
+}
+
+int netup_unidvb_ci_register(struct netup_unidvb_dev *dev,
+			     int num, struct pci_dev *pci_dev)
+{
+	int result;
+	struct netup_ci_state *state;
+
+	if (num < 0 || num > 1) {
+		dev_err(&pci_dev->dev, "%s(): invalid CI adapter %d\n",
+			__func__, num);
+		return -EINVAL;
+	}
+	state = &dev->ci[num];
+	state->nr = num;
+	state->membase8_config = dev->bmmio1 +
+		((num == 0) ? CAM0_CONFIG : CAM1_CONFIG);
+	state->membase8_io = dev->bmmio1 +
+		((num == 0) ? CAM0_IO : CAM1_IO);
+	state->dev = dev;
+	state->ca.owner = THIS_MODULE;
+	state->ca.read_attribute_mem = netup_unidvb_ci_read_attribute_mem;
+	state->ca.write_attribute_mem = netup_unidvb_ci_write_attribute_mem;
+	state->ca.read_cam_control = netup_unidvb_ci_read_cam_ctl;
+	state->ca.write_cam_control = netup_unidvb_ci_write_cam_ctl;
+	state->ca.slot_reset = netup_unidvb_ci_slot_reset;
+	state->ca.slot_shutdown = netup_unidvb_ci_slot_shutdown;
+	state->ca.slot_ts_enable = netup_unidvb_ci_slot_ts_ctl;
+	state->ca.poll_slot_status = netup_unidvb_poll_ci_slot_status;
+	state->ca.data = state;
+	result = dvb_ca_en50221_init(&dev->frontends[num].adapter,
+		&state->ca, 0, 1);
+	if (result < 0) {
+		dev_err(&pci_dev->dev,
+			"%s(): dvb_ca_en50221_init result %d\n",
+			__func__, result);
+		return result;
+	}
+	writew(NETUP_UNIDVB_IRQ_CI, (u16 *)(dev->bmmio0 + REG_IMASK_SET));
+	dev_info(&pci_dev->dev,
+		"%s(): CI adapter %d init done\n", __func__, num);
+	return 0;
+}
+
+void netup_unidvb_ci_unregister(struct netup_unidvb_dev *dev, int num)
+{
+	struct netup_ci_state *state;
+
+	dev_dbg(&dev->pci_dev->dev, "%s()\n", __func__);
+	if (num < 0 || num > 1) {
+		dev_err(&dev->pci_dev->dev, "%s(): invalid CI adapter %d\n",
+				__func__, num);
+		return;
+	}
+	state = &dev->ci[num];
+	dvb_ca_en50221_release(&state->ca);
+}
+
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
new file mode 100644
index 0000000..6d8bf627
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -0,0 +1,1001 @@
+/*
+ * netup_unidvb_core.c
+ *
+ * Main module for NetUP Universal Dual DVB-CI
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kmod.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include "netup_unidvb.h"
+#include "cxd2841er.h"
+#include "horus3a.h"
+#include "ascot2e.h"
+#include "lnbh25.h"
+
+static int spi_enable;
+module_param(spi_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+
+MODULE_DESCRIPTION("Driver for NetUP Dual Universal DVB CI PCIe card");
+MODULE_AUTHOR("info@netup.ru");
+MODULE_VERSION(NETUP_UNIDVB_VERSION);
+MODULE_LICENSE("GPL");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+/* Avalon-MM PCI-E registers */
+#define	AVL_PCIE_IENR		0x50
+#define AVL_PCIE_ISR		0x40
+#define AVL_IRQ_ENABLE		0x80
+#define AVL_IRQ_ASSERTED	0x80
+/* GPIO registers */
+#define GPIO_REG_IO		0x4880
+#define GPIO_REG_IO_TOGGLE	0x4882
+#define GPIO_REG_IO_SET		0x4884
+#define GPIO_REG_IO_CLEAR	0x4886
+/* GPIO bits */
+#define GPIO_FEA_RESET		(1 << 0)
+#define GPIO_FEB_RESET		(1 << 1)
+#define GPIO_RFA_CTL		(1 << 2)
+#define GPIO_RFB_CTL		(1 << 3)
+#define GPIO_FEA_TU_RESET	(1 << 4)
+#define GPIO_FEB_TU_RESET	(1 << 5)
+/* DMA base address */
+#define NETUP_DMA0_ADDR		0x4900
+#define NETUP_DMA1_ADDR		0x4940
+/* 8 DMA blocks * 128 packets * 188 bytes*/
+#define NETUP_DMA_BLOCKS_COUNT	8
+#define NETUP_DMA_PACKETS_COUNT	128
+/* DMA status bits */
+#define BIT_DMA_RUN		1
+#define BIT_DMA_ERROR		2
+#define BIT_DMA_IRQ		0x200
+
+/**
+ * struct netup_dma_regs - the map of DMA module registers
+ * @ctrlstat_set:	Control register, write to set control bits
+ * @ctrlstat_clear:	Control register, write to clear control bits
+ * @start_addr_lo:	DMA ring buffer start address, lower part
+ * @start_addr_hi:	DMA ring buffer start address, higher part
+ * @size:		DMA ring buffer size register
+			Bits [0-7]:	DMA packet size, 188 bytes
+			Bits [16-23]:	packets count in block, 128 packets
+			Bits [24-31]:	blocks count, 8 blocks
+ * @timeout:		DMA timeout in units of 8ns
+			For example, value of 375000000 equals to 3 sec
+ * @curr_addr_lo:	Current ring buffer head address, lower part
+ * @curr_addr_hi:	Current ring buffer head address, higher part
+ * @stat_pkt_received:	Statistic register, not tested
+ * @stat_pkt_accepted:	Statistic register, not tested
+ * @stat_pkt_overruns:	Statistic register, not tested
+ * @stat_pkt_underruns:	Statistic register, not tested
+ * @stat_fifo_overruns:	Statistic register, not tested
+ */
+struct netup_dma_regs {
+	__le32	ctrlstat_set;
+	__le32	ctrlstat_clear;
+	__le32	start_addr_lo;
+	__le32	start_addr_hi;
+	__le32	size;
+	__le32	timeout;
+	__le32	curr_addr_lo;
+	__le32	curr_addr_hi;
+	__le32	stat_pkt_received;
+	__le32	stat_pkt_accepted;
+	__le32	stat_pkt_overruns;
+	__le32	stat_pkt_underruns;
+	__le32	stat_fifo_overruns;
+} __packed __aligned(1);
+
+struct netup_unidvb_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	u32			size;
+};
+
+static int netup_unidvb_tuner_ctrl(void *priv, int is_dvb_tc);
+static void netup_unidvb_queue_cleanup(struct netup_dma *dma);
+
+static struct cxd2841er_config demod_config = {
+	.i2c_addr = 0xc8
+};
+
+static struct horus3a_config horus3a_conf = {
+	.i2c_address = 0xc0,
+	.xtal_freq_mhz = 16,
+	.set_tuner_callback = netup_unidvb_tuner_ctrl
+};
+
+static struct ascot2e_config ascot2e_conf = {
+	.i2c_address = 0xc2,
+	.set_tuner_callback = netup_unidvb_tuner_ctrl
+};
+
+static struct lnbh25_config lnbh25_conf = {
+	.i2c_address = 0x10,
+	.data2_config = LNBH25_TEN | LNBH25_EXTM
+};
+
+static int netup_unidvb_tuner_ctrl(void *priv, int is_dvb_tc)
+{
+	u8 reg, mask;
+	struct netup_dma *dma = priv;
+	struct netup_unidvb_dev *ndev;
+
+	if (!priv)
+		return -EINVAL;
+	ndev = dma->ndev;
+	dev_dbg(&ndev->pci_dev->dev, "%s(): num %d is_dvb_tc %d\n",
+		__func__, dma->num, is_dvb_tc);
+	reg = readb(ndev->bmmio0 + GPIO_REG_IO);
+	mask = (dma->num == 0) ? GPIO_RFA_CTL : GPIO_RFB_CTL;
+	if (!is_dvb_tc)
+		reg |= mask;
+	else
+		reg &= ~mask;
+	writeb(reg, ndev->bmmio0 + GPIO_REG_IO);
+	return 0;
+}
+
+static void netup_unidvb_dev_enable(struct netup_unidvb_dev *ndev)
+{
+	u16 gpio_reg;
+
+	/* enable PCI-E interrupts */
+	writel(AVL_IRQ_ENABLE, ndev->bmmio0 + AVL_PCIE_IENR);
+	/* unreset frontends bits[0:1] */
+	writeb(0x00, ndev->bmmio0 + GPIO_REG_IO);
+	msleep(100);
+	gpio_reg =
+		GPIO_FEA_RESET | GPIO_FEB_RESET |
+		GPIO_FEA_TU_RESET | GPIO_FEB_TU_RESET |
+		GPIO_RFA_CTL | GPIO_RFB_CTL;
+	writeb(gpio_reg, ndev->bmmio0 + GPIO_REG_IO);
+	dev_dbg(&ndev->pci_dev->dev,
+		"%s(): AVL_PCIE_IENR 0x%x GPIO_REG_IO 0x%x\n",
+		__func__, readl(ndev->bmmio0 + AVL_PCIE_IENR),
+		(int)readb(ndev->bmmio0 + GPIO_REG_IO));
+
+}
+
+static void netup_unidvb_dma_enable(struct netup_dma *dma, int enable)
+{
+	u32 irq_mask = (dma->num == 0 ?
+		NETUP_UNIDVB_IRQ_DMA1 : NETUP_UNIDVB_IRQ_DMA2);
+
+	dev_dbg(&dma->ndev->pci_dev->dev,
+		"%s(): DMA%d enable %d\n", __func__, dma->num, enable);
+	if (enable) {
+		writel(BIT_DMA_RUN, &dma->regs->ctrlstat_set);
+		writew(irq_mask,
+			(u16 *)(dma->ndev->bmmio0 + REG_IMASK_SET));
+	} else {
+		writel(BIT_DMA_RUN, &dma->regs->ctrlstat_clear);
+		writew(irq_mask,
+			(u16 *)(dma->ndev->bmmio0 + REG_IMASK_CLEAR));
+	}
+}
+
+static irqreturn_t netup_dma_interrupt(struct netup_dma *dma)
+{
+	u64 addr_curr;
+	u32 size;
+	unsigned long flags;
+	struct device *dev = &dma->ndev->pci_dev->dev;
+
+	spin_lock_irqsave(&dma->lock, flags);
+	addr_curr = ((u64)readl(&dma->regs->curr_addr_hi) << 32) |
+		(u64)readl(&dma->regs->curr_addr_lo) | dma->high_addr;
+	/* clear IRQ */
+	writel(BIT_DMA_IRQ, &dma->regs->ctrlstat_clear);
+	/* sanity check */
+	if (addr_curr < dma->addr_phys ||
+			addr_curr > dma->addr_phys +  dma->ring_buffer_size) {
+		if (addr_curr != 0) {
+			dev_err(dev,
+				"%s(): addr 0x%llx not from 0x%llx:0x%llx\n",
+				__func__, addr_curr, (u64)dma->addr_phys,
+				(u64)(dma->addr_phys + dma->ring_buffer_size));
+		}
+		goto irq_handled;
+	}
+	size = (addr_curr >= dma->addr_last) ?
+		(u32)(addr_curr - dma->addr_last) :
+		(u32)(dma->ring_buffer_size - (dma->addr_last - addr_curr));
+	if (dma->data_size != 0) {
+		printk_ratelimited("%s(): lost interrupt, data size %d\n",
+			__func__, dma->data_size);
+		dma->data_size += size;
+	}
+	if (dma->data_size == 0 || dma->data_size > dma->ring_buffer_size) {
+		dma->data_size = size;
+		dma->data_offset = (u32)(dma->addr_last - dma->addr_phys);
+	}
+	dma->addr_last = addr_curr;
+	queue_work(dma->ndev->wq, &dma->work);
+irq_handled:
+	spin_unlock_irqrestore(&dma->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t netup_unidvb_isr(int irq, void *dev_id)
+{
+	struct pci_dev *pci_dev = (struct pci_dev *)dev_id;
+	struct netup_unidvb_dev *ndev = pci_get_drvdata(pci_dev);
+	u32 reg40, reg_isr;
+	irqreturn_t iret = IRQ_NONE;
+
+	/* disable interrupts */
+	writel(0, ndev->bmmio0 + AVL_PCIE_IENR);
+	/* check IRQ source */
+	reg40 = readl(ndev->bmmio0 + AVL_PCIE_ISR);
+	if ((reg40 & AVL_IRQ_ASSERTED) != 0) {
+		/* IRQ is being signaled */
+		reg_isr = readw(ndev->bmmio0 + REG_ISR);
+		if (reg_isr & NETUP_UNIDVB_IRQ_I2C0) {
+			iret = netup_i2c_interrupt(&ndev->i2c[0]);
+		} else if (reg_isr & NETUP_UNIDVB_IRQ_I2C1) {
+			iret = netup_i2c_interrupt(&ndev->i2c[1]);
+		} else if (reg_isr & NETUP_UNIDVB_IRQ_SPI) {
+			iret = netup_spi_interrupt(ndev->spi);
+		} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA1) {
+			iret = netup_dma_interrupt(&ndev->dma[0]);
+		} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA2) {
+			iret = netup_dma_interrupt(&ndev->dma[1]);
+		} else if (reg_isr & NETUP_UNIDVB_IRQ_CI) {
+			iret = netup_ci_interrupt(ndev);
+		} else {
+			dev_err(&pci_dev->dev,
+				"%s(): unknown interrupt 0x%x\n",
+				__func__, reg_isr);
+		}
+	}
+	/* re-enable interrupts */
+	writel(AVL_IRQ_ENABLE, ndev->bmmio0 + AVL_PCIE_IENR);
+	return iret;
+}
+
+static int netup_unidvb_queue_setup(struct vb2_queue *vq,
+				    const struct v4l2_format *fmt,
+				    unsigned int *nbuffers,
+				    unsigned int *nplanes,
+				    unsigned int sizes[],
+				    void *alloc_ctxs[])
+{
+	struct netup_dma *dma = vb2_get_drv_priv(vq);
+
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s()\n", __func__);
+
+	*nplanes = 1;
+	if (vq->num_buffers + *nbuffers < VIDEO_MAX_FRAME)
+		*nbuffers = VIDEO_MAX_FRAME - vq->num_buffers;
+	sizes[0] = PAGE_ALIGN(NETUP_DMA_PACKETS_COUNT * 188);
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s() nbuffers=%d sizes[0]=%d\n",
+		__func__, *nbuffers, sizes[0]);
+	return 0;
+}
+
+static int netup_unidvb_buf_prepare(struct vb2_buffer *vb)
+{
+	struct netup_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
+	struct netup_unidvb_buffer *buf = container_of(vb,
+				struct netup_unidvb_buffer, vb);
+
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s(): buf 0x%p\n", __func__, buf);
+	buf->size = 0;
+	return 0;
+}
+
+static void netup_unidvb_buf_queue(struct vb2_buffer *vb)
+{
+	unsigned long flags;
+	struct netup_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
+	struct netup_unidvb_buffer *buf = container_of(vb,
+				struct netup_unidvb_buffer, vb);
+
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s(): %p\n", __func__, buf);
+	spin_lock_irqsave(&dma->lock, flags);
+	list_add_tail(&buf->list, &dma->free_buffers);
+	spin_unlock_irqrestore(&dma->lock, flags);
+	mod_timer(&dma->timeout, jiffies + msecs_to_jiffies(1000));
+}
+
+static int netup_unidvb_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct netup_dma *dma = vb2_get_drv_priv(q);
+
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s()\n", __func__);
+	netup_unidvb_dma_enable(dma, 1);
+	return 0;
+}
+
+static void netup_unidvb_stop_streaming(struct vb2_queue *q)
+{
+	struct netup_dma *dma = vb2_get_drv_priv(q);
+
+	dev_dbg(&dma->ndev->pci_dev->dev, "%s()\n", __func__);
+	netup_unidvb_dma_enable(dma, 0);
+	netup_unidvb_queue_cleanup(dma);
+}
+
+static struct vb2_ops dvb_qops = {
+	.queue_setup		= netup_unidvb_queue_setup,
+	.buf_prepare		= netup_unidvb_buf_prepare,
+	.buf_queue		= netup_unidvb_buf_queue,
+	.start_streaming	= netup_unidvb_start_streaming,
+	.stop_streaming		= netup_unidvb_stop_streaming,
+};
+
+static int netup_unidvb_queue_init(struct netup_dma *dma,
+				   struct vb2_queue *vb_queue)
+{
+	int res;
+
+	/* Init videobuf2 queue structure */
+	vb_queue->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vb_queue->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	vb_queue->drv_priv = dma;
+	vb_queue->buf_struct_size = sizeof(struct netup_unidvb_buffer);
+	vb_queue->ops = &dvb_qops;
+	vb_queue->mem_ops = &vb2_vmalloc_memops;
+	vb_queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	res = vb2_queue_init(vb_queue);
+	if (res != 0) {
+		dev_err(&dma->ndev->pci_dev->dev,
+			"%s(): vb2_queue_init failed (%d)\n", __func__, res);
+	}
+	return res;
+}
+
+static int netup_unidvb_dvb_init(struct netup_unidvb_dev *ndev,
+				 int num)
+{
+	struct vb2_dvb_frontend *fe0, *fe1, *fe2;
+
+	if (num < 0 || num > 1) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to init DVB bus %d\n", __func__, num);
+		return -ENODEV;
+	}
+	mutex_init(&ndev->frontends[num].lock);
+	INIT_LIST_HEAD(&ndev->frontends[num].felist);
+	if (vb2_dvb_alloc_frontend(&ndev->frontends[num], 1) == NULL ||
+		vb2_dvb_alloc_frontend(
+			&ndev->frontends[num], 2) == NULL ||
+		vb2_dvb_alloc_frontend(
+			&ndev->frontends[num], 3) == NULL) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to to alllocate vb2_dvb_frontend\n",
+			__func__);
+		return -ENOMEM;
+	}
+	fe0 = vb2_dvb_get_frontend(&ndev->frontends[num], 1);
+	fe1 = vb2_dvb_get_frontend(&ndev->frontends[num], 2);
+	fe2 = vb2_dvb_get_frontend(&ndev->frontends[num], 3);
+	if (fe0 == NULL || fe1 == NULL || fe2 == NULL) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): frontends has not been allocated\n", __func__);
+		return -EINVAL;
+	}
+	netup_unidvb_queue_init(&ndev->dma[num], &fe0->dvb.dvbq);
+	netup_unidvb_queue_init(&ndev->dma[num], &fe1->dvb.dvbq);
+	netup_unidvb_queue_init(&ndev->dma[num], &fe2->dvb.dvbq);
+	fe0->dvb.name = "netup_fe0";
+	fe1->dvb.name = "netup_fe1";
+	fe2->dvb.name = "netup_fe2";
+	fe0->dvb.frontend = dvb_attach(cxd2841er_attach_s,
+		&demod_config, &ndev->i2c[num].adap);
+	if (fe0->dvb.frontend == NULL) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-S/S2 frontend\n",
+			__func__);
+		goto frontend_detach;
+	}
+	horus3a_conf.set_tuner_priv = &ndev->dma[num];
+	if (!dvb_attach(horus3a_attach, fe0->dvb.frontend,
+			&horus3a_conf, &ndev->i2c[num].adap)) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-S/S2 tuner frontend\n",
+			__func__);
+		goto frontend_detach;
+	}
+	if (!dvb_attach(lnbh25_attach, fe0->dvb.frontend,
+			&lnbh25_conf, &ndev->i2c[num].adap)) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach SEC frontend\n", __func__);
+		goto frontend_detach;
+	}
+	/* DVB-T/T2 frontend */
+	fe1->dvb.frontend = dvb_attach(cxd2841er_attach_t,
+		&demod_config, &ndev->i2c[num].adap);
+	if (fe1->dvb.frontend == NULL) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-T frontend\n", __func__);
+		goto frontend_detach;
+	}
+	fe1->dvb.frontend->id = 1;
+	ascot2e_conf.set_tuner_priv = &ndev->dma[num];
+	if (!dvb_attach(ascot2e_attach, fe1->dvb.frontend,
+			&ascot2e_conf, &ndev->i2c[num].adap)) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-T tuner frontend\n",
+			__func__);
+		goto frontend_detach;
+	}
+	/* DVB-C/C2 frontend */
+	fe2->dvb.frontend = dvb_attach(cxd2841er_attach_c,
+				&demod_config, &ndev->i2c[num].adap);
+	if (fe2->dvb.frontend == NULL) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-C frontend\n", __func__);
+		goto frontend_detach;
+	}
+	fe2->dvb.frontend->id = 2;
+	if (!dvb_attach(ascot2e_attach, fe2->dvb.frontend,
+			&ascot2e_conf, &ndev->i2c[num].adap)) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to attach DVB-T/C tuner frontend\n",
+			__func__);
+		goto frontend_detach;
+	}
+
+	if (vb2_dvb_register_bus(&ndev->frontends[num],
+			THIS_MODULE, NULL,
+			&ndev->pci_dev->dev, adapter_nr, 1)) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): unable to register DVB bus %d\n",
+			__func__, num);
+		goto frontend_detach;
+	}
+	dev_info(&ndev->pci_dev->dev, "DVB init done, num=%d\n", num);
+	return 0;
+frontend_detach:
+	vb2_dvb_dealloc_frontends(&ndev->frontends[num]);
+	return -EINVAL;
+}
+
+static void netup_unidvb_dvb_fini(struct netup_unidvb_dev *ndev, int num)
+{
+	if (num < 0 || num > 1) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): unable to unregister DVB bus %d\n",
+			__func__, num);
+		return;
+	}
+	vb2_dvb_unregister_bus(&ndev->frontends[num]);
+	dev_info(&ndev->pci_dev->dev,
+		"%s(): DVB bus %d unregistered\n", __func__, num);
+}
+
+static int netup_unidvb_dvb_setup(struct netup_unidvb_dev *ndev)
+{
+	int res;
+
+	res = netup_unidvb_dvb_init(ndev, 0);
+	if (res)
+		return res;
+	res = netup_unidvb_dvb_init(ndev, 1);
+	if (res) {
+		netup_unidvb_dvb_fini(ndev, 0);
+		return res;
+	}
+	return 0;
+}
+
+static int netup_unidvb_ring_copy(struct netup_dma *dma,
+				  struct netup_unidvb_buffer *buf)
+{
+	u32 copy_bytes, ring_bytes;
+	u32 buff_bytes = NETUP_DMA_PACKETS_COUNT * 188 - buf->size;
+	u8 *p = vb2_plane_vaddr(&buf->vb, 0);
+	struct netup_unidvb_dev *ndev = dma->ndev;
+
+	if (p == NULL) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): buffer is NULL\n", __func__);
+		return -EINVAL;
+	}
+	p += buf->size;
+	if (dma->data_offset + dma->data_size > dma->ring_buffer_size) {
+		ring_bytes = dma->ring_buffer_size - dma->data_offset;
+		copy_bytes = (ring_bytes > buff_bytes) ?
+			buff_bytes : ring_bytes;
+		memcpy_fromio(p, dma->addr_virt + dma->data_offset, copy_bytes);
+		p += copy_bytes;
+		buf->size += copy_bytes;
+		buff_bytes -= copy_bytes;
+		dma->data_size -= copy_bytes;
+		dma->data_offset += copy_bytes;
+		if (dma->data_offset == dma->ring_buffer_size)
+			dma->data_offset = 0;
+	}
+	if (buff_bytes > 0) {
+		ring_bytes = dma->data_size;
+		copy_bytes = (ring_bytes > buff_bytes) ?
+				buff_bytes : ring_bytes;
+		memcpy_fromio(p, dma->addr_virt + dma->data_offset, copy_bytes);
+		buf->size += copy_bytes;
+		dma->data_size -= copy_bytes;
+		dma->data_offset += copy_bytes;
+		if (dma->data_offset == dma->ring_buffer_size)
+			dma->data_offset = 0;
+	}
+	return 0;
+}
+
+static void netup_unidvb_dma_worker(struct work_struct *work)
+{
+	struct netup_dma *dma = container_of(work, struct netup_dma, work);
+	struct netup_unidvb_dev *ndev = dma->ndev;
+	struct netup_unidvb_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dma->lock, flags);
+	if (dma->data_size == 0) {
+		dev_dbg(&ndev->pci_dev->dev,
+			"%s(): data_size == 0\n", __func__);
+		goto work_done;
+	}
+	while (dma->data_size > 0) {
+		if (list_empty(&dma->free_buffers)) {
+			dev_dbg(&ndev->pci_dev->dev,
+				"%s(): no free buffers\n", __func__);
+			goto work_done;
+		}
+		buf = list_first_entry(&dma->free_buffers,
+			struct netup_unidvb_buffer, list);
+		if (buf->size >= NETUP_DMA_PACKETS_COUNT * 188) {
+			dev_dbg(&ndev->pci_dev->dev,
+				"%s(): buffer overflow, size %d\n",
+				__func__, buf->size);
+			goto work_done;
+		}
+		if (netup_unidvb_ring_copy(dma, buf))
+			goto work_done;
+		if (buf->size == NETUP_DMA_PACKETS_COUNT * 188) {
+			list_del(&buf->list);
+			dev_dbg(&ndev->pci_dev->dev,
+				"%s(): buffer %p done, size %d\n",
+				__func__, buf, buf->size);
+			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+			vb2_set_plane_payload(&buf->vb, 0, buf->size);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		}
+	}
+work_done:
+	dma->data_size = 0;
+	spin_unlock_irqrestore(&dma->lock, flags);
+}
+
+static void netup_unidvb_queue_cleanup(struct netup_dma *dma)
+{
+	struct netup_unidvb_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dma->lock, flags);
+	while (!list_empty(&dma->free_buffers)) {
+		buf = list_first_entry(&dma->free_buffers,
+			struct netup_unidvb_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&dma->lock, flags);
+}
+
+static void netup_unidvb_dma_timeout(unsigned long data)
+{
+	struct netup_dma *dma = (struct netup_dma *)data;
+	struct netup_unidvb_dev *ndev = dma->ndev;
+
+	dev_dbg(&ndev->pci_dev->dev, "%s()\n", __func__);
+	netup_unidvb_queue_cleanup(dma);
+}
+
+static int netup_unidvb_dma_init(struct netup_unidvb_dev *ndev, int num)
+{
+	struct netup_dma *dma;
+	struct device *dev = &ndev->pci_dev->dev;
+
+	if (num < 0 || num > 1) {
+		dev_err(dev, "%s(): unable to register DMA%d\n",
+			__func__, num);
+		return -ENODEV;
+	}
+	dma = &ndev->dma[num];
+	dev_info(dev, "%s(): starting DMA%d\n", __func__, num);
+	dma->num = num;
+	dma->ndev = ndev;
+	spin_lock_init(&dma->lock);
+	INIT_WORK(&dma->work, netup_unidvb_dma_worker);
+	INIT_LIST_HEAD(&dma->free_buffers);
+	dma->timeout.function = netup_unidvb_dma_timeout;
+	dma->timeout.data = (unsigned long)dma;
+	init_timer(&dma->timeout);
+	dma->ring_buffer_size = ndev->dma_size / 2;
+	dma->addr_virt = ndev->dma_virt + dma->ring_buffer_size * num;
+	dma->addr_phys = (dma_addr_t)((u64)ndev->dma_phys +
+		dma->ring_buffer_size * num);
+	dev_info(dev, "%s(): DMA%d buffer virt/phys 0x%p/0x%llx size %d\n",
+		__func__, num, dma->addr_virt,
+		(unsigned long long)dma->addr_phys,
+		dma->ring_buffer_size);
+	memset_io(dma->addr_virt, 0, dma->ring_buffer_size);
+	dma->addr_last = dma->addr_phys;
+	dma->high_addr = (u32)(dma->addr_phys & 0xC0000000);
+	dma->regs = (struct netup_dma_regs *)(num == 0 ?
+		ndev->bmmio0 + NETUP_DMA0_ADDR :
+		ndev->bmmio0 + NETUP_DMA1_ADDR);
+	writel((NETUP_DMA_BLOCKS_COUNT << 24) |
+		(NETUP_DMA_PACKETS_COUNT << 8) | 188, &dma->regs->size);
+	writel((u32)(dma->addr_phys & 0x3FFFFFFF), &dma->regs->start_addr_lo);
+	writel(0, &dma->regs->start_addr_hi);
+	writel(dma->high_addr, ndev->bmmio0 + 0x1000);
+	writel(375000000, &dma->regs->timeout);
+	msleep(1000);
+	writel(BIT_DMA_IRQ, &dma->regs->ctrlstat_clear);
+	return 0;
+}
+
+static void netup_unidvb_dma_fini(struct netup_unidvb_dev *ndev, int num)
+{
+	struct netup_dma *dma;
+
+	if (num < 0 || num > 1)
+		return;
+	dev_dbg(&ndev->pci_dev->dev, "%s(): num %d\n", __func__, num);
+	dma = &ndev->dma[num];
+	netup_unidvb_dma_enable(dma, 0);
+	msleep(50);
+	cancel_work_sync(&dma->work);
+	del_timer(&dma->timeout);
+}
+
+static int netup_unidvb_dma_setup(struct netup_unidvb_dev *ndev)
+{
+	int res;
+
+	res = netup_unidvb_dma_init(ndev, 0);
+	if (res)
+		return res;
+	res = netup_unidvb_dma_init(ndev, 1);
+	if (res) {
+		netup_unidvb_dma_fini(ndev, 0);
+		return res;
+	}
+	netup_unidvb_dma_enable(&ndev->dma[0], 0);
+	netup_unidvb_dma_enable(&ndev->dma[1], 0);
+	return 0;
+}
+
+static int netup_unidvb_ci_setup(struct netup_unidvb_dev *ndev,
+				 struct pci_dev *pci_dev)
+{
+	int res;
+
+	writew(NETUP_UNIDVB_IRQ_CI, ndev->bmmio0 + REG_IMASK_SET);
+	res = netup_unidvb_ci_register(ndev, 0, pci_dev);
+	if (res)
+		return res;
+	res = netup_unidvb_ci_register(ndev, 1, pci_dev);
+	if (res)
+		netup_unidvb_ci_unregister(ndev, 0);
+	return res;
+}
+
+static int netup_unidvb_request_mmio(struct pci_dev *pci_dev)
+{
+	if (!request_mem_region(pci_resource_start(pci_dev, 0),
+			pci_resource_len(pci_dev, 0), NETUP_UNIDVB_NAME)) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to request MMIO bar 0 at 0x%llx\n",
+			__func__,
+			(unsigned long long)pci_resource_start(pci_dev, 0));
+		return -EBUSY;
+	}
+	if (!request_mem_region(pci_resource_start(pci_dev, 1),
+			pci_resource_len(pci_dev, 1), NETUP_UNIDVB_NAME)) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to request MMIO bar 1 at 0x%llx\n",
+			__func__,
+			(unsigned long long)pci_resource_start(pci_dev, 1));
+		release_mem_region(pci_resource_start(pci_dev, 0),
+			pci_resource_len(pci_dev, 0));
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int netup_unidvb_request_modules(struct device *dev)
+{
+	static const char * const modules[] = {
+		"lnbh25", "ascot2e", "horus3a", "cxd2841er", NULL
+	};
+	const char * const *curr_mod = modules;
+	int err;
+
+	while (*curr_mod != NULL) {
+		err = request_module(*curr_mod);
+		if (err) {
+			dev_warn(dev, "request_module(%s) failed: %d\n",
+				*curr_mod, err);
+		}
+		++curr_mod;
+	}
+	return 0;
+}
+
+static int netup_unidvb_initdev(struct pci_dev *pci_dev,
+				const struct pci_device_id *pci_id)
+{
+	u8 board_revision;
+	u16 board_vendor;
+	struct netup_unidvb_dev *ndev;
+	int old_firmware = 0;
+
+	netup_unidvb_request_modules(&pci_dev->dev);
+
+	/* Check card revision */
+	if (pci_dev->revision != NETUP_PCI_DEV_REVISION) {
+		dev_err(&pci_dev->dev,
+			"netup_unidvb: expected card revision %d, got %d\n",
+			NETUP_PCI_DEV_REVISION, pci_dev->revision);
+		dev_err(&pci_dev->dev,
+			"Please upgrade firmware!\n");
+		dev_err(&pci_dev->dev,
+			"Instructions on http://www.netup.tv\n");
+		old_firmware = 1;
+		spi_enable = 1;
+	}
+
+	/* allocate device context */
+	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL);
+
+	if (!ndev)
+		goto dev_alloc_err;
+	memset(ndev, 0, sizeof(*ndev));
+	ndev->old_fw = old_firmware;
+	ndev->wq = create_singlethread_workqueue(NETUP_UNIDVB_NAME);
+	if (!ndev->wq) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to create workqueue\n", __func__);
+		goto wq_create_err;
+	}
+	ndev->pci_dev = pci_dev;
+	ndev->pci_bus = pci_dev->bus->number;
+	ndev->pci_slot = PCI_SLOT(pci_dev->devfn);
+	ndev->pci_func = PCI_FUNC(pci_dev->devfn);
+	ndev->board_num = ndev->pci_bus*10 + ndev->pci_slot;
+	pci_set_drvdata(pci_dev, ndev);
+	/* PCI init */
+	dev_info(&pci_dev->dev, "%s(): PCI device (%d). Bus:0x%x Slot:0x%x\n",
+		__func__, ndev->board_num, ndev->pci_bus, ndev->pci_slot);
+
+	if (pci_enable_device(pci_dev)) {
+		dev_err(&pci_dev->dev, "%s(): pci_enable_device failed\n",
+			__func__);
+		goto pci_enable_err;
+	}
+	/* read PCI info */
+	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &board_revision);
+	pci_read_config_word(pci_dev, PCI_VENDOR_ID, &board_vendor);
+	if (board_vendor != NETUP_VENDOR_ID) {
+		dev_err(&pci_dev->dev, "%s(): unknown board vendor 0x%x",
+			__func__, board_vendor);
+		goto pci_detect_err;
+	}
+	dev_info(&pci_dev->dev,
+		"%s(): board vendor 0x%x, revision 0x%x\n",
+		__func__, board_vendor, board_revision);
+	pci_set_master(pci_dev);
+	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+		dev_err(&pci_dev->dev,
+			"%s(): 32bit PCI DMA is not supported\n", __func__);
+		goto pci_detect_err;
+	}
+	dev_info(&pci_dev->dev, "%s(): using 32bit PCI DMA\n", __func__);
+	/* Clear "no snoop" and "relaxed ordering" bits, use default MRRS. */
+	pcie_capability_clear_and_set_word(pci_dev, PCI_EXP_DEVCTL,
+		PCI_EXP_DEVCTL_READRQ | PCI_EXP_DEVCTL_RELAX_EN |
+		PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
+	/* Adjust PCIe completion timeout. */
+	pcie_capability_clear_and_set_word(pci_dev,
+		PCI_EXP_DEVCTL2, 0xf, 0x2);
+
+	if (netup_unidvb_request_mmio(pci_dev)) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to request MMIO regions\n", __func__);
+		goto pci_detect_err;
+	}
+	ndev->lmmio0 = ioremap(pci_resource_start(pci_dev, 0),
+		pci_resource_len(pci_dev, 0));
+	if (!ndev->lmmio0) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to remap MMIO bar 0\n", __func__);
+		goto pci_bar0_error;
+	}
+	ndev->lmmio1 = ioremap(pci_resource_start(pci_dev, 1),
+		pci_resource_len(pci_dev, 1));
+	if (!ndev->lmmio1) {
+		dev_err(&pci_dev->dev,
+			"%s(): unable to remap MMIO bar 1\n", __func__);
+		goto pci_bar1_error;
+	}
+	ndev->bmmio0 = (u8 __iomem *)ndev->lmmio0;
+	ndev->bmmio1 = (u8 __iomem *)ndev->lmmio1;
+	dev_info(&pci_dev->dev,
+		"%s(): PCI MMIO at 0x%p (%d); 0x%p (%d); IRQ %d",
+		__func__,
+		ndev->lmmio0, (u32)pci_resource_len(pci_dev, 0),
+		ndev->lmmio1, (u32)pci_resource_len(pci_dev, 1),
+		pci_dev->irq);
+	if (request_irq(pci_dev->irq, netup_unidvb_isr, IRQF_SHARED,
+			"netup_unidvb", pci_dev) < 0) {
+		dev_err(&pci_dev->dev,
+			"%s(): can't get IRQ %d\n", __func__, pci_dev->irq);
+		goto irq_request_err;
+	}
+	ndev->dma_size = 2 * 188 *
+		NETUP_DMA_BLOCKS_COUNT * NETUP_DMA_PACKETS_COUNT;
+	ndev->dma_virt = dma_alloc_coherent(&pci_dev->dev,
+		ndev->dma_size, &ndev->dma_phys, GFP_KERNEL);
+	if (!ndev->dma_virt) {
+		dev_err(&pci_dev->dev, "%s(): unable to allocate DMA buffer\n",
+			__func__);
+		goto dma_alloc_err;
+	}
+	netup_unidvb_dev_enable(ndev);
+	if (spi_enable && netup_spi_init(ndev)) {
+		dev_warn(&pci_dev->dev,
+			"netup_unidvb: SPI flash setup failed\n");
+		goto spi_setup_err;
+	}
+	if (old_firmware) {
+		dev_err(&pci_dev->dev,
+			"netup_unidvb: card initialization was incomplete\n");
+		return 0;
+	}
+	if (netup_i2c_register(ndev)) {
+		dev_err(&pci_dev->dev, "netup_unidvb: I2C setup failed\n");
+		goto i2c_setup_err;
+	}
+	/* enable I2C IRQs */
+	writew(NETUP_UNIDVB_IRQ_I2C0 | NETUP_UNIDVB_IRQ_I2C1,
+		ndev->bmmio0 + REG_IMASK_SET);
+	usleep_range(5000, 10000);
+	if (netup_unidvb_dvb_setup(ndev)) {
+		dev_err(&pci_dev->dev, "netup_unidvb: DVB setup failed\n");
+		goto dvb_setup_err;
+	}
+	if (netup_unidvb_ci_setup(ndev, pci_dev)) {
+		dev_err(&pci_dev->dev, "netup_unidvb: CI setup failed\n");
+		goto ci_setup_err;
+	}
+	if (netup_unidvb_dma_setup(ndev)) {
+		dev_err(&pci_dev->dev, "netup_unidvb: DMA setup failed\n");
+		goto dma_setup_err;
+	}
+	dev_info(&pci_dev->dev,
+		"netup_unidvb: device has been initialized\n");
+	return 0;
+dma_setup_err:
+	netup_unidvb_ci_unregister(ndev, 0);
+	netup_unidvb_ci_unregister(ndev, 1);
+ci_setup_err:
+	netup_unidvb_dvb_fini(ndev, 0);
+	netup_unidvb_dvb_fini(ndev, 1);
+dvb_setup_err:
+	netup_i2c_unregister(ndev);
+i2c_setup_err:
+	if (ndev->spi)
+		netup_spi_release(ndev);
+spi_setup_err:
+	dma_free_coherent(&pci_dev->dev, ndev->dma_size,
+			ndev->dma_virt, ndev->dma_phys);
+dma_alloc_err:
+	free_irq(pci_dev->irq, pci_dev);
+irq_request_err:
+	iounmap(ndev->lmmio1);
+pci_bar1_error:
+	iounmap(ndev->lmmio0);
+pci_bar0_error:
+	release_mem_region(pci_resource_start(pci_dev, 0),
+		pci_resource_len(pci_dev, 0));
+	release_mem_region(pci_resource_start(pci_dev, 1),
+		pci_resource_len(pci_dev, 1));
+pci_detect_err:
+	pci_disable_device(pci_dev);
+pci_enable_err:
+	pci_set_drvdata(pci_dev, NULL);
+	destroy_workqueue(ndev->wq);
+wq_create_err:
+	kfree(ndev);
+dev_alloc_err:
+	dev_err(&pci_dev->dev,
+		"%s(): failed to initizalize device\n", __func__);
+	return -EIO;
+}
+
+static void netup_unidvb_finidev(struct pci_dev *pci_dev)
+{
+	struct netup_unidvb_dev *ndev = pci_get_drvdata(pci_dev);
+
+	dev_info(&pci_dev->dev, "%s(): trying to stop device\n", __func__);
+	if (!ndev->old_fw) {
+		netup_unidvb_dma_fini(ndev, 0);
+		netup_unidvb_dma_fini(ndev, 1);
+		netup_unidvb_ci_unregister(ndev, 0);
+		netup_unidvb_ci_unregister(ndev, 1);
+		netup_unidvb_dvb_fini(ndev, 0);
+		netup_unidvb_dvb_fini(ndev, 1);
+		netup_i2c_unregister(ndev);
+	}
+	if (ndev->spi)
+		netup_spi_release(ndev);
+	writew(0xffff, ndev->bmmio0 + REG_IMASK_CLEAR);
+	dma_free_coherent(&ndev->pci_dev->dev, ndev->dma_size,
+			ndev->dma_virt, ndev->dma_phys);
+	free_irq(pci_dev->irq, pci_dev);
+	iounmap(ndev->lmmio0);
+	iounmap(ndev->lmmio1);
+	release_mem_region(pci_resource_start(pci_dev, 0),
+		pci_resource_len(pci_dev, 0));
+	release_mem_region(pci_resource_start(pci_dev, 1),
+		pci_resource_len(pci_dev, 1));
+	pci_disable_device(pci_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	destroy_workqueue(ndev->wq);
+	kfree(ndev);
+	dev_info(&pci_dev->dev,
+		"%s(): device has been successfully stopped\n", __func__);
+}
+
+
+static struct pci_device_id netup_unidvb_pci_tbl[] = {
+	{ PCI_DEVICE(0x1b55, 0x18f6) },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, netup_unidvb_pci_tbl);
+
+static struct pci_driver netup_unidvb_pci_driver = {
+	.name     = "netup_unidvb",
+	.id_table = netup_unidvb_pci_tbl,
+	.probe    = netup_unidvb_initdev,
+	.remove   = netup_unidvb_finidev,
+	.suspend  = NULL,
+	.resume   = NULL,
+};
+
+static int __init netup_unidvb_init(void)
+{
+	return pci_register_driver(&netup_unidvb_pci_driver);
+}
+
+static void __exit netup_unidvb_fini(void)
+{
+	pci_unregister_driver(&netup_unidvb_pci_driver);
+}
+
+module_init(netup_unidvb_init);
+module_exit(netup_unidvb_fini);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
new file mode 100644
index 0000000..eaaa2d0
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
@@ -0,0 +1,381 @@
+/*
+ * netup_unidvb_i2c.c
+ *
+ * Internal I2C bus driver for NetUP Universal Dual DVB-CI
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include "netup_unidvb.h"
+
+#define NETUP_I2C_BUS0_ADDR		0x4800
+#define NETUP_I2C_BUS1_ADDR		0x4840
+#define NETUP_I2C_TIMEOUT		1000
+
+/* twi_ctrl0_stat reg bits */
+#define TWI_IRQEN_COMPL	0x1
+#define TWI_IRQEN_ANACK 0x2
+#define TWI_IRQEN_DNACK 0x4
+#define TWI_IRQ_COMPL	(TWI_IRQEN_COMPL << 8)
+#define TWI_IRQ_ANACK	(TWI_IRQEN_ANACK << 8)
+#define TWI_IRQ_DNACK	(TWI_IRQEN_DNACK << 8)
+#define TWI_IRQ_TX	0x800
+#define TWI_IRQ_RX	0x1000
+#define TWI_IRQEN	(TWI_IRQEN_COMPL | TWI_IRQEN_ANACK | TWI_IRQEN_DNACK)
+/* twi_addr_ctrl1 reg bits*/
+#define TWI_TRANSFER	0x100
+#define TWI_NOSTOP	0x200
+#define TWI_SOFT_RESET	0x2000
+/* twi_clkdiv reg value */
+#define TWI_CLKDIV	156
+/* fifo_stat_ctrl reg bits */
+#define FIFO_IRQEN	0x8000
+#define FIFO_RESET	0x4000
+/* FIFO size */
+#define FIFO_SIZE	16
+
+struct netup_i2c_fifo_regs {
+	union {
+		__u8	data8;
+		__le16	data16;
+		__le32	data32;
+	};
+	__u8		padding[4];
+	__le16		stat_ctrl;
+} __packed __aligned(1);
+
+struct netup_i2c_regs {
+	__le16				clkdiv;
+	__le16				twi_ctrl0_stat;
+	__le16				twi_addr_ctrl1;
+	__le16				length;
+	__u8				padding1[8];
+	struct netup_i2c_fifo_regs	tx_fifo;
+	__u8				padding2[6];
+	struct netup_i2c_fifo_regs	rx_fifo;
+} __packed __aligned(1);
+
+irqreturn_t netup_i2c_interrupt(struct netup_i2c *i2c)
+{
+	u16 reg, tmp;
+	unsigned long flags;
+	irqreturn_t iret = IRQ_HANDLED;
+
+	spin_lock_irqsave(&i2c->lock, flags);
+	reg = readw(&i2c->regs->twi_ctrl0_stat);
+	writew(reg & ~TWI_IRQEN, &i2c->regs->twi_ctrl0_stat);
+	dev_dbg(i2c->adap.dev.parent,
+		"%s(): twi_ctrl0_state 0x%x\n", __func__, reg);
+	if ((reg & TWI_IRQEN_COMPL) != 0 && (reg & TWI_IRQ_COMPL)) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): TWI_IRQEN_COMPL\n", __func__);
+		i2c->state = STATE_DONE;
+		goto irq_ok;
+	}
+	if ((reg & TWI_IRQEN_ANACK) != 0 && (reg & TWI_IRQ_ANACK)) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): TWI_IRQEN_ANACK\n", __func__);
+		i2c->state = STATE_ERROR;
+		goto irq_ok;
+	}
+	if ((reg & TWI_IRQEN_DNACK) != 0 && (reg & TWI_IRQ_DNACK)) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): TWI_IRQEN_DNACK\n", __func__);
+		i2c->state = STATE_ERROR;
+		goto irq_ok;
+	}
+	if ((reg & TWI_IRQ_RX) != 0) {
+		tmp = readw(&i2c->regs->rx_fifo.stat_ctrl);
+		writew(tmp & ~FIFO_IRQEN, &i2c->regs->rx_fifo.stat_ctrl);
+		i2c->state = STATE_WANT_READ;
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): want read\n", __func__);
+		goto irq_ok;
+	}
+	if ((reg & TWI_IRQ_TX) != 0) {
+		tmp = readw(&i2c->regs->tx_fifo.stat_ctrl);
+		writew(tmp & ~FIFO_IRQEN, &i2c->regs->tx_fifo.stat_ctrl);
+		i2c->state = STATE_WANT_WRITE;
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): want write\n", __func__);
+		goto irq_ok;
+	}
+	dev_warn(&i2c->adap.dev, "%s(): not mine interrupt\n", __func__);
+	iret = IRQ_NONE;
+irq_ok:
+	spin_unlock_irqrestore(&i2c->lock, flags);
+	if (iret == IRQ_HANDLED)
+		wake_up(&i2c->wq);
+	return iret;
+}
+
+static void netup_i2c_reset(struct netup_i2c *i2c)
+{
+	dev_dbg(i2c->adap.dev.parent, "%s()\n", __func__);
+	i2c->state = STATE_DONE;
+	writew(TWI_SOFT_RESET, &i2c->regs->twi_addr_ctrl1);
+	writew(TWI_CLKDIV, &i2c->regs->clkdiv);
+	writew(FIFO_RESET, &i2c->regs->tx_fifo.stat_ctrl);
+	writew(FIFO_RESET, &i2c->regs->rx_fifo.stat_ctrl);
+	writew(0x800, &i2c->regs->tx_fifo.stat_ctrl);
+	writew(0x800, &i2c->regs->rx_fifo.stat_ctrl);
+}
+
+static void netup_i2c_fifo_tx(struct netup_i2c *i2c)
+{
+	u8 data;
+	u32 fifo_space = FIFO_SIZE -
+		(readw(&i2c->regs->tx_fifo.stat_ctrl) & 0x3f);
+	u32 msg_length = i2c->msg->len - i2c->xmit_size;
+
+	msg_length = (msg_length < fifo_space ? msg_length : fifo_space);
+	while (msg_length--) {
+		data = i2c->msg->buf[i2c->xmit_size++];
+		writeb(data, &i2c->regs->tx_fifo.data8);
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): write 0x%02x\n", __func__, data);
+	}
+	if (i2c->xmit_size < i2c->msg->len) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): TX IRQ enabled\n", __func__);
+		writew(readw(&i2c->regs->tx_fifo.stat_ctrl) | FIFO_IRQEN,
+			&i2c->regs->tx_fifo.stat_ctrl);
+	}
+}
+
+static void netup_i2c_fifo_rx(struct netup_i2c *i2c)
+{
+	u8 data;
+	u32 fifo_size = readw(&i2c->regs->rx_fifo.stat_ctrl) & 0x3f;
+
+	dev_dbg(i2c->adap.dev.parent,
+		"%s(): RX fifo size %d\n", __func__, fifo_size);
+	while (fifo_size--) {
+		data = readb(&i2c->regs->rx_fifo.data8);
+		if ((i2c->msg->flags & I2C_M_RD) != 0 &&
+					i2c->xmit_size < i2c->msg->len) {
+			i2c->msg->buf[i2c->xmit_size++] = data;
+			dev_dbg(i2c->adap.dev.parent,
+				"%s(): read 0x%02x\n", __func__, data);
+		}
+	}
+	if (i2c->xmit_size < i2c->msg->len) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): RX IRQ enabled\n", __func__);
+		writew(readw(&i2c->regs->rx_fifo.stat_ctrl) | FIFO_IRQEN,
+			&i2c->regs->rx_fifo.stat_ctrl);
+	}
+}
+
+static void netup_i2c_start_xfer(struct netup_i2c *i2c)
+{
+	u16 rdflag = ((i2c->msg->flags & I2C_M_RD) ? 1 : 0);
+	u16 reg = readw(&i2c->regs->twi_ctrl0_stat);
+
+	writew(TWI_IRQEN | reg, &i2c->regs->twi_ctrl0_stat);
+	writew(i2c->msg->len, &i2c->regs->length);
+	writew(TWI_TRANSFER | (i2c->msg->addr << 1) | rdflag,
+		&i2c->regs->twi_addr_ctrl1);
+	dev_dbg(i2c->adap.dev.parent,
+		"%s(): length %d twi_addr_ctrl1 0x%x twi_ctrl0_stat 0x%x\n",
+		__func__, readw(&i2c->regs->length),
+		readw(&i2c->regs->twi_addr_ctrl1),
+		readw(&i2c->regs->twi_ctrl0_stat));
+	i2c->state = STATE_WAIT;
+	i2c->xmit_size = 0;
+	if (!rdflag)
+		netup_i2c_fifo_tx(i2c);
+	else
+		writew(FIFO_IRQEN | readw(&i2c->regs->rx_fifo.stat_ctrl),
+			&i2c->regs->rx_fifo.stat_ctrl);
+}
+
+static int netup_i2c_xfer(struct i2c_adapter *adap,
+			  struct i2c_msg *msgs, int num)
+{
+	unsigned long flags;
+	int i, trans_done, res = num;
+	struct netup_i2c *i2c = i2c_get_adapdata(adap);
+	u16 reg;
+
+	if (num <= 0) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): num == %d\n", __func__, num);
+		return -EINVAL;
+	}
+	spin_lock_irqsave(&i2c->lock, flags);
+	if (i2c->state != STATE_DONE) {
+		dev_dbg(i2c->adap.dev.parent,
+			"%s(): i2c->state == %d, resetting I2C\n",
+			__func__, i2c->state);
+		netup_i2c_reset(i2c);
+	}
+	dev_dbg(i2c->adap.dev.parent, "%s() num %d\n", __func__, num);
+	for (i = 0; i < num; i++) {
+		i2c->msg = &msgs[i];
+		netup_i2c_start_xfer(i2c);
+		trans_done = 0;
+		while (!trans_done) {
+			spin_unlock_irqrestore(&i2c->lock, flags);
+			if (wait_event_timeout(i2c->wq,
+					i2c->state != STATE_WAIT,
+					msecs_to_jiffies(NETUP_I2C_TIMEOUT))) {
+				spin_lock_irqsave(&i2c->lock, flags);
+				switch (i2c->state) {
+				case STATE_WANT_READ:
+					netup_i2c_fifo_rx(i2c);
+					break;
+				case STATE_WANT_WRITE:
+					netup_i2c_fifo_tx(i2c);
+					break;
+				case STATE_DONE:
+					if ((i2c->msg->flags & I2C_M_RD) != 0 &&
+						i2c->xmit_size != i2c->msg->len)
+						netup_i2c_fifo_rx(i2c);
+					dev_dbg(i2c->adap.dev.parent,
+						"%s(): msg %d OK\n",
+						__func__, i);
+					trans_done = 1;
+					break;
+				case STATE_ERROR:
+					res = -EIO;
+					dev_dbg(i2c->adap.dev.parent,
+						"%s(): error state\n",
+						__func__);
+					goto done;
+				default:
+					dev_dbg(i2c->adap.dev.parent,
+						"%s(): invalid state %d\n",
+						__func__, i2c->state);
+					res = -EINVAL;
+					goto done;
+				}
+				if (!trans_done) {
+					i2c->state = STATE_WAIT;
+					reg = readw(
+						&i2c->regs->twi_ctrl0_stat);
+					writew(TWI_IRQEN | reg,
+						&i2c->regs->twi_ctrl0_stat);
+				}
+				spin_unlock_irqrestore(&i2c->lock, flags);
+			} else {
+				spin_lock_irqsave(&i2c->lock, flags);
+				dev_dbg(i2c->adap.dev.parent,
+					"%s(): wait timeout\n", __func__);
+				res = -ETIMEDOUT;
+				goto done;
+			}
+			spin_lock_irqsave(&i2c->lock, flags);
+		}
+	}
+done:
+	spin_unlock_irqrestore(&i2c->lock, flags);
+	dev_dbg(i2c->adap.dev.parent, "%s(): result %d\n", __func__, res);
+	return res;
+}
+
+static u32 netup_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm netup_i2c_algorithm = {
+	.master_xfer	= netup_i2c_xfer,
+	.functionality	= netup_i2c_func,
+};
+
+static struct i2c_adapter netup_i2c_adapter = {
+	.owner		= THIS_MODULE,
+	.name		= NETUP_UNIDVB_NAME,
+	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
+	.algo		= &netup_i2c_algorithm,
+};
+
+static int netup_i2c_init(struct netup_unidvb_dev *ndev, int bus_num)
+{
+	int ret;
+	struct netup_i2c *i2c;
+
+	if (bus_num < 0 || bus_num > 1) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): invalid bus_num %d\n", __func__, bus_num);
+		return -EINVAL;
+	}
+	i2c = &ndev->i2c[bus_num];
+	spin_lock_init(&i2c->lock);
+	init_waitqueue_head(&i2c->wq);
+	i2c->regs = (struct netup_i2c_regs *)(ndev->bmmio0 +
+		(bus_num == 0 ? NETUP_I2C_BUS0_ADDR : NETUP_I2C_BUS1_ADDR));
+	netup_i2c_reset(i2c);
+	i2c->adap = netup_i2c_adapter;
+	i2c->adap.dev.parent = &ndev->pci_dev->dev;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	ret = i2c_add_adapter(&i2c->adap);
+	if (ret) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): failed to add I2C adapter\n", __func__);
+		return ret;
+	}
+	dev_info(&ndev->pci_dev->dev,
+		"%s(): registered I2C bus %d at 0x%x\n",
+		__func__,
+		bus_num, (bus_num == 0 ?
+			NETUP_I2C_BUS0_ADDR :
+			NETUP_I2C_BUS1_ADDR));
+	return 0;
+}
+
+static void netup_i2c_remove(struct netup_unidvb_dev *ndev, int bus_num)
+{
+	struct netup_i2c *i2c;
+
+	if (bus_num < 0 || bus_num > 1) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): invalid bus number %d\n", __func__, bus_num);
+		return;
+	}
+	i2c = &ndev->i2c[bus_num];
+	netup_i2c_reset(i2c);
+	/* remove adapter */
+	i2c_del_adapter(&i2c->adap);
+	dev_info(&ndev->pci_dev->dev,
+		"netup_i2c_remove: unregistered I2C bus %d\n", bus_num);
+}
+
+int netup_i2c_register(struct netup_unidvb_dev *ndev)
+{
+	int ret;
+
+	ret = netup_i2c_init(ndev, 0);
+	if (ret)
+		return ret;
+	ret = netup_i2c_init(ndev, 1);
+	if (ret) {
+		netup_i2c_remove(ndev, 0);
+		return ret;
+	}
+	return 0;
+}
+
+void netup_i2c_unregister(struct netup_unidvb_dev *ndev)
+{
+	netup_i2c_remove(ndev, 0);
+	netup_i2c_remove(ndev, 1);
+}
+
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
new file mode 100644
index 0000000..f55b327
--- /dev/null
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
@@ -0,0 +1,252 @@
+/*
+ * netup_unidvb_spi.c
+ *
+ * Internal SPI driver for NetUP Universal Dual DVB-CI
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "netup_unidvb.h"
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#include <linux/mtd/partitions.h>
+#include <mtd/mtd-abi.h>
+
+#define NETUP_SPI_CTRL_IRQ	0x1000
+#define NETUP_SPI_CTRL_IMASK	0x2000
+#define NETUP_SPI_CTRL_START	0x8000
+#define NETUP_SPI_CTRL_LAST_CS	0x4000
+
+#define NETUP_SPI_TIMEOUT	6000
+
+enum netup_spi_state {
+	SPI_STATE_START,
+	SPI_STATE_DONE,
+};
+
+struct netup_spi_regs {
+	__u8	data[1024];
+	__le16	control_stat;
+	__le16	clock_divider;
+} __packed __aligned(1);
+
+struct netup_spi {
+	struct device			*dev;
+	struct spi_master		*master;
+	struct netup_spi_regs		*regs;
+	u8 __iomem			*mmio;
+	spinlock_t			lock;
+	wait_queue_head_t		waitq;
+	enum netup_spi_state		state;
+};
+
+static char netup_spi_name[64] = "fpga";
+
+static struct mtd_partition netup_spi_flash_partitions = {
+	.name = netup_spi_name,
+	.size = 0x1000000, /* 16MB */
+	.offset = 0,
+	.mask_flags = MTD_CAP_ROM
+};
+
+static struct flash_platform_data spi_flash_data = {
+	.name = "netup0_m25p128",
+	.parts = &netup_spi_flash_partitions,
+	.nr_parts = 1,
+};
+
+static struct spi_board_info netup_spi_board = {
+	.modalias = "m25p128",
+	.max_speed_hz = 11000000,
+	.chip_select = 0,
+	.mode = SPI_MODE_0,
+	.platform_data = &spi_flash_data,
+};
+
+irqreturn_t netup_spi_interrupt(struct netup_spi *spi)
+{
+	u16 reg;
+	unsigned long flags;
+
+	if (!spi) {
+		dev_dbg(&spi->master->dev,
+			"%s(): SPI not initialized\n", __func__);
+		return IRQ_NONE;
+	}
+	spin_lock_irqsave(&spi->lock, flags);
+	reg = readw(&spi->regs->control_stat);
+	if (!(reg & NETUP_SPI_CTRL_IRQ)) {
+		spin_unlock_irqrestore(&spi->lock, flags);
+		dev_dbg(&spi->master->dev,
+			"%s(): not mine interrupt\n", __func__);
+		return IRQ_NONE;
+	}
+	writew(reg | NETUP_SPI_CTRL_IRQ, &spi->regs->control_stat);
+	reg = readw(&spi->regs->control_stat);
+	writew(reg & ~NETUP_SPI_CTRL_IMASK, &spi->regs->control_stat);
+	spi->state = SPI_STATE_DONE;
+	wake_up(&spi->waitq);
+	spin_unlock_irqrestore(&spi->lock, flags);
+	dev_dbg(&spi->master->dev,
+		"%s(): SPI interrupt handled\n", __func__);
+	return IRQ_HANDLED;
+}
+
+static int netup_spi_transfer(struct spi_master *master,
+			      struct spi_message *msg)
+{
+	struct netup_spi *spi = spi_master_get_devdata(master);
+	struct spi_transfer *t;
+	int result = 0;
+	u32 tr_size;
+
+	/* reset CS */
+	writew(NETUP_SPI_CTRL_LAST_CS, &spi->regs->control_stat);
+	writew(0, &spi->regs->control_stat);
+	list_for_each_entry(t, &msg->transfers, transfer_list) {
+		tr_size = t->len;
+		while (tr_size) {
+			u32 frag_offset = t->len - tr_size;
+			u32 frag_size = (tr_size > sizeof(spi->regs->data)) ?
+					sizeof(spi->regs->data) : tr_size;
+			int frag_last = 0;
+
+			if (list_is_last(&t->transfer_list,
+					&msg->transfers) &&
+					frag_offset + frag_size == t->len) {
+				frag_last = 1;
+			}
+			if (t->tx_buf) {
+				memcpy_toio(spi->regs->data,
+					t->tx_buf + frag_offset,
+					frag_size);
+			} else {
+				memset_io(spi->regs->data,
+					0, frag_size);
+			}
+			spi->state = SPI_STATE_START;
+			writew((frag_size & 0x3ff) |
+				NETUP_SPI_CTRL_IMASK |
+				NETUP_SPI_CTRL_START |
+				(frag_last ? NETUP_SPI_CTRL_LAST_CS : 0),
+				&spi->regs->control_stat);
+			dev_dbg(&spi->master->dev,
+				"%s(): control_stat 0x%04x\n",
+				__func__, readw(&spi->regs->control_stat));
+			wait_event_timeout(spi->waitq,
+				spi->state != SPI_STATE_START,
+				msecs_to_jiffies(NETUP_SPI_TIMEOUT));
+			if (spi->state == SPI_STATE_DONE) {
+				if (t->rx_buf) {
+					memcpy_fromio(t->rx_buf + frag_offset,
+						spi->regs->data, frag_size);
+				}
+			} else {
+				if (spi->state == SPI_STATE_START) {
+					dev_dbg(&spi->master->dev,
+						"%s(): transfer timeout\n",
+						__func__);
+				} else {
+					dev_dbg(&spi->master->dev,
+						"%s(): invalid state %d\n",
+						__func__, spi->state);
+				}
+				result = -EIO;
+				goto done;
+			}
+			tr_size -= frag_size;
+			msg->actual_length += frag_size;
+		}
+	}
+done:
+	msg->status = result;
+	spi_finalize_current_message(master);
+	return result;
+}
+
+static int netup_spi_setup(struct spi_device *spi)
+{
+	return 0;
+}
+
+int netup_spi_init(struct netup_unidvb_dev *ndev)
+{
+	struct spi_master *master;
+	struct netup_spi *nspi;
+
+	master = spi_alloc_master(&ndev->pci_dev->dev,
+		sizeof(struct netup_spi));
+	if (!master) {
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): unable to alloc SPI master\n", __func__);
+		return -EINVAL;
+	}
+	nspi = spi_master_get_devdata(master);
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
+	master->bus_num = -1;
+	master->num_chipselect = 1;
+	master->transfer_one_message = netup_spi_transfer;
+	master->setup = netup_spi_setup;
+	spin_lock_init(&nspi->lock);
+	init_waitqueue_head(&nspi->waitq);
+	nspi->master = master;
+	nspi->regs = (struct netup_spi_regs *)(ndev->bmmio0 + 0x4000);
+	writew(2, &nspi->regs->clock_divider);
+	writew(NETUP_UNIDVB_IRQ_SPI, ndev->bmmio0 + REG_IMASK_SET);
+	ndev->spi = nspi;
+	if (spi_register_master(master)) {
+		ndev->spi = NULL;
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): unable to register SPI bus\n", __func__);
+		return -EINVAL;
+	}
+	snprintf(netup_spi_name,
+		sizeof(netup_spi_name),
+		"fpga_%02x:%02x.%01x",
+		ndev->pci_bus,
+		ndev->pci_slot,
+		ndev->pci_func);
+	if (!spi_new_device(master, &netup_spi_board)) {
+		ndev->spi = NULL;
+		dev_err(&ndev->pci_dev->dev,
+			"%s(): unable to create SPI device\n", __func__);
+		return -EINVAL;
+	}
+	dev_dbg(&ndev->pci_dev->dev, "%s(): SPI init OK\n", __func__);
+	return 0;
+}
+
+void netup_spi_release(struct netup_unidvb_dev *ndev)
+{
+	u16 reg;
+	unsigned long flags;
+	struct netup_spi *spi = ndev->spi;
+
+	if (!spi) {
+		dev_dbg(&spi->master->dev,
+			"%s(): SPI not initialized\n", __func__);
+		return;
+	}
+	spin_lock_irqsave(&spi->lock, flags);
+	reg = readw(&spi->regs->control_stat);
+	writew(reg | NETUP_SPI_CTRL_IRQ, &spi->regs->control_stat);
+	reg = readw(&spi->regs->control_stat);
+	writew(reg & ~NETUP_SPI_CTRL_IMASK, &spi->regs->control_stat);
+	spin_unlock_irqrestore(&spi->lock, flags);
+	spi_unregister_master(spi->master);
+	ndev->spi = NULL;
+}
+
+
-- 
1.7.10.4

