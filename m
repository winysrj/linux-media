Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3612 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaIUJwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 05:52:20 -0400
Message-ID: <541E9FC3.8000900@xs4all.nl>
Date: Sun, 21 Sep 2014 11:52:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Pete Eberlein <pete@sensoray.com>
Subject: [PATCH] saa7134: add saa7134-go7007
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support to saa7134 for 'WIS Voyager or compatible' PCI boards
such as the Sensoray model 614 with which this patch was tested. It is a
saa7134-based PCI board with a go7007 MPEG encoder. This was a patch when the
go7007 was still in staging and was not applied when go7007 was moved to
drivers/media since it needed more work.

That work is now done and this last piece of go7007 support can now go in.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/Makefile         |   3 +-
 drivers/media/pci/saa7134/saa7134-cards.c  |  29 ++
 drivers/media/pci/saa7134/saa7134-core.c   |  10 +-
 drivers/media/pci/saa7134/saa7134-go7007.c | 532 +++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134.h        |   5 +
 5 files changed, 576 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/pci/saa7134/saa7134-go7007.c

diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
index 58de9b0..b55bd9a 100644
--- a/drivers/media/pci/saa7134/Makefile
+++ b/drivers/media/pci/saa7134/Makefile
@@ -4,7 +4,7 @@ saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
 saa7134-y +=	saa7134-video.o
 saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o saa7134-empress.o saa7134-go7007.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
@@ -14,3 +14,4 @@ ccflags-y += -I$(srctree)/drivers/media/i2c
 ccflags-y += -I$(srctree)/drivers/media/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
+ccflags-y += -I$(srctree)/drivers/media/usb/go7007
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 6e4bdb9..3ca0780 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5827,6 +5827,29 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio = 0x0000800,
 		},
 	},
+	[SAA7134_BOARD_WIS_VOYAGER] = {
+		.name           = "WIS Voyager or compatible",
+		.audio_clock    = 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg		= SAA7134_MPEG_GO7007,
+		.inputs		= { {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+		.amux = LINE1,
+		} },
+	},
 
 };
 
@@ -7080,6 +7103,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x2055, /* AverTV Satellite Hybrid+FM A706 */
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_A706,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1905, /* WIS */
+		.subdevice    = 0x7007,
+		.driver_data  = SAA7134_BOARD_WIS_VOYAGER,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 9ff03a6..236ed72 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -160,6 +160,8 @@ static void request_module_async(struct work_struct *work){
 		request_module("saa7134-empress");
 	if (card_is_dvb(dev))
 		request_module("saa7134-dvb");
+	if (card_is_go7007(dev))
+		request_module("saa7134-go7007");
 	if (alsa) {
 		if (dev->pci->device != PCI_DEVICE_ID_PHILIPS_SAA7130)
 			request_module("saa7134-alsa");
@@ -563,8 +565,12 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 			saa7134_irq_vbi_done(dev,status);
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA2) &&
-		    card_has_mpeg(dev))
-			saa7134_irq_ts_done(dev,status);
+		    card_has_mpeg(dev)) {
+			if (dev->mops->irq_ts_done != NULL)
+				dev->mops->irq_ts_done(dev, status);
+			else
+				saa7134_irq_ts_done(dev, status);
+		}
 
 		if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			switch (dev->has_remote) {
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
new file mode 100644
index 0000000..3e9ca48
--- /dev/null
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -0,0 +1,532 @@
+/*
+ * Copyright (C) 2005-2006 Micronas USA Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/mm.h>
+#include <linux/usb.h>
+#include <linux/i2c.h>
+#include <asm/byteorder.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include "saa7134.h"
+#include "saa7134-reg.h"
+#include "go7007-priv.h"
+
+/*#define GO7007_HPI_DEBUG*/
+
+enum hpi_address {
+	HPI_ADDR_VIDEO_BUFFER = 0xe4,
+	HPI_ADDR_INIT_BUFFER = 0xea,
+	HPI_ADDR_INTR_RET_VALUE = 0xee,
+	HPI_ADDR_INTR_RET_DATA = 0xec,
+	HPI_ADDR_INTR_STATUS = 0xf4,
+	HPI_ADDR_INTR_WR_PARAM = 0xf6,
+	HPI_ADDR_INTR_WR_INDEX = 0xf8,
+};
+
+enum gpio_command {
+	GPIO_COMMAND_RESET = 0x00, /* 000b */
+	GPIO_COMMAND_REQ1  = 0x04, /* 001b */
+	GPIO_COMMAND_WRITE = 0x20, /* 010b */
+	GPIO_COMMAND_REQ2  = 0x24, /* 011b */
+	GPIO_COMMAND_READ  = 0x80, /* 100b */
+	GPIO_COMMAND_VIDEO = 0x84, /* 101b */
+	GPIO_COMMAND_IDLE  = 0xA0, /* 110b */
+	GPIO_COMMAND_ADDR  = 0xA4, /* 111b */
+};
+
+struct saa7134_go7007 {
+	struct v4l2_subdev sd;
+	struct saa7134_dev *dev;
+	u8 *top;
+	u8 *bottom;
+	dma_addr_t top_dma;
+	dma_addr_t bottom_dma;
+};
+
+static inline struct saa7134_go7007 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct saa7134_go7007, sd);
+}
+
+static const struct go7007_board_info board_voyager = {
+	.flags		 = 0,
+	.sensor_flags	 = GO7007_SENSOR_656 |
+				GO7007_SENSOR_VALID_ENABLE |
+				GO7007_SENSOR_TV |
+				GO7007_SENSOR_VBI,
+	.audio_flags	= GO7007_AUDIO_I2S_MODE_1 |
+				GO7007_AUDIO_WORD_16,
+	.audio_rate	 = 48000,
+	.audio_bclk_div	 = 8,
+	.audio_main_div	 = 2,
+	.hpi_buffer_cap  = 7,
+	.num_inputs	 = 1,
+	.inputs		 = {
+		{
+			.name		= "SAA7134",
+		},
+	},
+};
+
+/********************* Driver for GPIO HPI interface *********************/
+
+static int gpio_write(struct saa7134_dev *dev, u8 addr, u16 data)
+{
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0xff);
+
+	/* Write HPI address */
+	saa_writeb(SAA7134_GPIO_GPSTATUS0, addr);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_ADDR);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	/* Write low byte */
+	saa_writeb(SAA7134_GPIO_GPSTATUS0, data & 0xff);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_WRITE);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	/* Write high byte */
+	saa_writeb(SAA7134_GPIO_GPSTATUS0, data >> 8);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_WRITE);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	return 0;
+}
+
+static int gpio_read(struct saa7134_dev *dev, u8 addr, u16 *data)
+{
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0xff);
+
+	/* Write HPI address */
+	saa_writeb(SAA7134_GPIO_GPSTATUS0, addr);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_ADDR);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0x00);
+
+	/* Read low byte */
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_READ);
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	*data = saa_readb(SAA7134_GPIO_GPSTATUS0);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	/* Read high byte */
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_READ);
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	*data |= saa_readb(SAA7134_GPIO_GPSTATUS0) << 8;
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+
+	return 0;
+}
+
+static int saa7134_go7007_interface_reset(struct go7007 *go)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev = saa->dev;
+	u32 status;
+	u16 intr_val, intr_data;
+	int count = 20;
+
+	saa_clearb(SAA7134_TS_PARALLEL, 0x80); /* Disable TS interface */
+	saa_writeb(SAA7134_GPIO_GPMODE2, 0xa4);
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0xff);
+
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ1);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_RESET);
+	msleep(1);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ1);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ2);
+	msleep(10);
+
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+	status = saa_readb(SAA7134_GPIO_GPSTATUS2);
+	/*pr_debug("status is %s\n", status & 0x40 ? "OK" : "not OK"); */
+
+	/* enter command mode...(?) */
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ1);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ2);
+
+	do {
+		saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+		saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+		status = saa_readb(SAA7134_GPIO_GPSTATUS2);
+		/*pr_info("gpio is %08x\n", saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)); */
+	} while (--count > 0);
+
+	/* Wait for an interrupt to indicate successful hardware reset */
+	if (go7007_read_interrupt(go, &intr_val, &intr_data) < 0 ||
+			(intr_val & ~0x1) != 0x55aa) {
+		pr_err("saa7134-go7007: unable to reset the GO7007\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int saa7134_go7007_write_interrupt(struct go7007 *go, int addr, int data)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev = saa->dev;
+	int i;
+	u16 status_reg;
+
+#ifdef GO7007_HPI_DEBUG
+	pr_debug("saa7134-go7007: WriteInterrupt: %04x %04x\n", addr, data);
+#endif
+
+	for (i = 0; i < 100; ++i) {
+		gpio_read(dev, HPI_ADDR_INTR_STATUS, &status_reg);
+		if (!(status_reg & 0x0010))
+			break;
+		msleep(10);
+	}
+	if (i == 100) {
+		pr_err("saa7134-go7007: device is hung, status reg = 0x%04x\n",
+			status_reg);
+		return -1;
+	}
+	gpio_write(dev, HPI_ADDR_INTR_WR_PARAM, data);
+	gpio_write(dev, HPI_ADDR_INTR_WR_INDEX, addr);
+
+	return 0;
+}
+
+static int saa7134_go7007_read_interrupt(struct go7007 *go)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev = saa->dev;
+
+	/* XXX we need to wait if there is no interrupt available */
+	go->interrupt_available = 1;
+	gpio_read(dev, HPI_ADDR_INTR_RET_VALUE, &go->interrupt_value);
+	gpio_read(dev, HPI_ADDR_INTR_RET_DATA, &go->interrupt_data);
+#ifdef GO7007_HPI_DEBUG
+	pr_debug("saa7134-go7007: ReadInterrupt: %04x %04x\n",
+			go->interrupt_value, go->interrupt_data);
+#endif
+	return 0;
+}
+
+static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
+						unsigned long status)
+{
+	struct go7007 *go = video_get_drvdata(dev->empress_dev);
+	struct saa7134_go7007 *saa = go->hpi_context;
+
+	if (!vb2_is_streaming(&go->vidq))
+		return;
+	if (0 != (status & 0x000f0000))
+		pr_debug("saa7134-go7007: irq: lost %ld\n",
+				(status >> 16) & 0x0f);
+	if (status & 0x100000) {
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
+		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
+	} else {
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
+		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
+	}
+}
+
+static int saa7134_go7007_stream_start(struct go7007 *go)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev = saa->dev;
+
+	saa->top_dma = dma_map_page(&dev->pci->dev, virt_to_page(saa->top),
+			0, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&dev->pci->dev, saa->top_dma))
+		return -ENOMEM;
+	saa->bottom_dma = dma_map_page(&dev->pci->dev,
+			virt_to_page(saa->bottom),
+			0, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&dev->pci->dev, saa->bottom_dma)) {
+		dma_unmap_page(&dev->pci->dev, saa->top_dma, PAGE_SIZE,
+				DMA_FROM_DEVICE);
+		return -ENOMEM;
+	}
+
+	saa_writel(SAA7134_VIDEO_PORT_CTRL0 >> 2, 0xA300B000);
+	saa_writel(SAA7134_VIDEO_PORT_CTRL4 >> 2, 0x40000200);
+
+	/* Set HPI interface for video */
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0xff);
+	saa_writeb(SAA7134_GPIO_GPSTATUS0, HPI_ADDR_VIDEO_BUFFER);
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_ADDR);
+	saa_writeb(SAA7134_GPIO_GPMODE0, 0x00);
+
+	/* Enable TS interface */
+	saa_writeb(SAA7134_TS_PARALLEL, 0xe6);
+
+	/* Reset TS interface */
+	saa_setb(SAA7134_TS_SERIAL1, 0x01);
+	saa_clearb(SAA7134_TS_SERIAL1, 0x01);
+
+	/* Set up transfer block size */
+	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 128 - 1);
+	saa_writeb(SAA7134_TS_DMA0, (PAGE_SIZE >> 7) - 1);
+	saa_writeb(SAA7134_TS_DMA1, 0);
+	saa_writeb(SAA7134_TS_DMA2, 0);
+
+	/* Enable video streaming mode */
+	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_VIDEO);
+
+	saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
+	saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
+	saa_writel(SAA7134_RS_PITCH(5), 128);
+	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_MAX);
+
+	/* Enable TS FIFO */
+	saa_setl(SAA7134_MAIN_CTRL, SAA7134_MAIN_CTRL_TE5);
+
+	/* Enable DMA IRQ */
+	saa_setl(SAA7134_IRQ1,
+			SAA7134_IRQ1_INTE_RA2_1 | SAA7134_IRQ1_INTE_RA2_0);
+
+	return 0;
+}
+
+static int saa7134_go7007_stream_stop(struct go7007 *go)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev;
+
+	if (!saa)
+		return -EINVAL;
+	dev = saa->dev;
+	if (!dev)
+		return -EINVAL;
+
+	/* Shut down TS FIFO */
+	saa_clearl(SAA7134_MAIN_CTRL, SAA7134_MAIN_CTRL_TE5);
+
+	/* Disable DMA IRQ */
+	saa_clearl(SAA7134_IRQ1,
+			SAA7134_IRQ1_INTE_RA2_1 | SAA7134_IRQ1_INTE_RA2_0);
+
+	/* Disable TS interface */
+	saa_clearb(SAA7134_TS_PARALLEL, 0x80);
+
+	dma_unmap_page(&dev->pci->dev, saa->top_dma, PAGE_SIZE,
+			DMA_FROM_DEVICE);
+	dma_unmap_page(&dev->pci->dev, saa->bottom_dma, PAGE_SIZE,
+			DMA_FROM_DEVICE);
+
+	return 0;
+}
+
+static int saa7134_go7007_send_firmware(struct go7007 *go, u8 *data, int len)
+{
+	struct saa7134_go7007 *saa = go->hpi_context;
+	struct saa7134_dev *dev = saa->dev;
+	u16 status_reg;
+	int i;
+
+#ifdef GO7007_HPI_DEBUG
+	pr_debug("saa7134-go7007: DownloadBuffer sending %d bytes\n", len);
+#endif
+
+	while (len > 0) {
+		i = len > 64 ? 64 : len;
+		saa_writeb(SAA7134_GPIO_GPMODE0, 0xff);
+		saa_writeb(SAA7134_GPIO_GPSTATUS0, HPI_ADDR_INIT_BUFFER);
+		saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_ADDR);
+		saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+		while (i-- > 0) {
+			saa_writeb(SAA7134_GPIO_GPSTATUS0, *data);
+			saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_WRITE);
+			saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_IDLE);
+			++data;
+			--len;
+		}
+		for (i = 0; i < 100; ++i) {
+			gpio_read(dev, HPI_ADDR_INTR_STATUS, &status_reg);
+			if (!(status_reg & 0x0002))
+				break;
+		}
+		if (i == 100) {
+			pr_err("saa7134-go7007: device is hung, status reg = 0x%04x\n",
+			       status_reg);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static struct go7007_hpi_ops saa7134_go7007_hpi_ops = {
+	.interface_reset	= saa7134_go7007_interface_reset,
+	.write_interrupt	= saa7134_go7007_write_interrupt,
+	.read_interrupt		= saa7134_go7007_read_interrupt,
+	.stream_start		= saa7134_go7007_stream_start,
+	.stream_stop		= saa7134_go7007_stream_stop,
+	.send_firmware		= saa7134_go7007_send_firmware,
+};
+MODULE_FIRMWARE("go7007/go7007tv.bin");
+
+/* --------------------------------------------------------------------------*/
+
+static int saa7134_go7007_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+#if 0
+	struct saa7134_go7007 *saa = to_state(sd);
+	struct saa7134_dev *dev = saa->dev;
+
+	return saa7134_s_std_internal(dev, NULL, norm);
+#else
+	return 0;
+#endif
+}
+
+static const struct v4l2_subdev_video_ops saa7134_go7007_video_ops = {
+	.s_std = saa7134_go7007_s_std,
+};
+
+static const struct v4l2_subdev_ops saa7134_go7007_sd_ops = {
+	.video = &saa7134_go7007_video_ops,
+};
+
+/* --------------------------------------------------------------------------*/
+
+
+/********************* Add/remove functions *********************/
+
+static int saa7134_go7007_init(struct saa7134_dev *dev)
+{
+	struct go7007 *go;
+	struct saa7134_go7007 *saa;
+	struct v4l2_subdev *sd;
+
+	pr_debug("saa7134-go7007: probing new SAA713X board\n");
+
+	go = go7007_alloc(&board_voyager, &dev->pci->dev);
+	if (go == NULL)
+		return -ENOMEM;
+
+	saa = kzalloc(sizeof(struct saa7134_go7007), GFP_KERNEL);
+	if (saa == NULL) {
+		kfree(go);
+		return -ENOMEM;
+	}
+
+	go->board_id = GO7007_BOARDID_PCI_VOYAGER;
+	snprintf(go->bus_info, sizeof(go->bus_info), "PCI:%s", pci_name(dev->pci));
+	strlcpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
+	go->hpi_ops = &saa7134_go7007_hpi_ops;
+	go->hpi_context = saa;
+	saa->dev = dev;
+
+	/* Init the subdevice interface */
+	sd = &saa->sd;
+	v4l2_subdev_init(sd, &saa7134_go7007_sd_ops);
+	v4l2_set_subdevdata(sd, saa);
+	strncpy(sd->name, "saa7134-go7007", sizeof(sd->name));
+
+	/* Allocate a couple pages for receiving the compressed stream */
+	saa->top = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!saa->top)
+		goto allocfail;
+	saa->bottom = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!saa->bottom)
+		goto allocfail;
+
+	/* Boot the GO7007 */
+	if (go7007_boot_encoder(go, go->board_info->flags &
+					GO7007_BOARD_USE_ONBOARD_I2C) < 0)
+		goto allocfail;
+
+	/* Do any final GO7007 initialization, then register the
+	 * V4L2 and ALSA interfaces */
+	if (go7007_register_encoder(go, go->board_info->num_i2c_devs) < 0)
+		goto allocfail;
+
+	/* Register the subdevice interface with the go7007 device */
+	if (v4l2_device_register_subdev(&go->v4l2_dev, sd) < 0)
+		pr_info("saa7134-go7007: register subdev failed\n");
+
+	dev->empress_dev = &go->vdev;
+
+	go->status = STATUS_ONLINE;
+	return 0;
+
+allocfail:
+	if (saa->top)
+		free_page((unsigned long)saa->top);
+	if (saa->bottom)
+		free_page((unsigned long)saa->bottom);
+	kfree(saa);
+	kfree(go);
+	return -ENOMEM;
+}
+
+static int saa7134_go7007_fini(struct saa7134_dev *dev)
+{
+	struct go7007 *go;
+	struct saa7134_go7007 *saa;
+
+	if (NULL == dev->empress_dev)
+		return 0;
+
+	go = video_get_drvdata(dev->empress_dev);
+	if (go->audio_enabled)
+		go7007_snd_remove(go);
+
+	saa = go->hpi_context;
+	go->status = STATUS_SHUTDOWN;
+	free_page((unsigned long)saa->top);
+	free_page((unsigned long)saa->bottom);
+	v4l2_device_unregister_subdev(&saa->sd);
+	kfree(saa);
+	video_unregister_device(&go->vdev);
+
+	v4l2_device_put(&go->v4l2_dev);
+	dev->empress_dev = NULL;
+
+	return 0;
+}
+
+static struct saa7134_mpeg_ops saa7134_go7007_ops = {
+	.type          = SAA7134_MPEG_GO7007,
+	.init          = saa7134_go7007_init,
+	.fini          = saa7134_go7007_fini,
+	.irq_ts_done   = saa7134_go7007_irq_ts_done,
+};
+
+static int __init saa7134_go7007_mod_init(void)
+{
+	return saa7134_ts_register(&saa7134_go7007_ops);
+}
+
+static void __exit saa7134_go7007_mod_cleanup(void)
+{
+	saa7134_ts_unregister(&saa7134_go7007_ops);
+}
+
+module_init(saa7134_go7007_mod_init);
+module_exit(saa7134_go7007_mod_cleanup);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index e47edd4..1a82dd0 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -338,6 +338,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
 #define SAA7134_BOARD_HAWELL_HW_9004V1      191
 #define SAA7134_BOARD_AVERMEDIA_A706		192
+#define SAA7134_BOARD_WIS_VOYAGER           193
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
@@ -368,6 +369,7 @@ enum saa7134_mpeg_type {
 	SAA7134_MPEG_UNUSED,
 	SAA7134_MPEG_EMPRESS,
 	SAA7134_MPEG_DVB,
+	SAA7134_MPEG_GO7007,
 };
 
 enum saa7134_mpeg_ts_type {
@@ -407,6 +409,7 @@ struct saa7134_board {
 #define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
 #define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
 #define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
+#define card_is_go7007(dev)   (SAA7134_MPEG_GO7007  == saa7134_boards[dev->board].mpeg)
 #define card_has_mpeg(dev)    (SAA7134_MPEG_UNUSED  != saa7134_boards[dev->board].mpeg)
 #define card(dev)             (saa7134_boards[dev->board])
 #define card_in(dev,n)        (saa7134_boards[dev->board].inputs[n])
@@ -522,6 +525,8 @@ struct saa7134_mpeg_ops {
 	int                        (*init)(struct saa7134_dev *dev);
 	int                        (*fini)(struct saa7134_dev *dev);
 	void                       (*signal_change)(struct saa7134_dev *dev);
+	void                       (*irq_ts_done)(struct saa7134_dev *dev,
+						  unsigned long status);
 };
 
 /* global device status */
-- 
2.1.0

