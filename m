Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41359 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaIJLhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 07:37:50 -0400
Received: by mail-pa0-f54.google.com with SMTP id lj1so8352892pab.13
        for <linux-media@vger.kernel.org>; Wed, 10 Sep 2014 04:37:50 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: Bud <knightrider@are.ma>, crope@iki.fi, m.chehab@samsung.com,
	hdegoede@redhat.com, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH] Earthsoft PT3 ISDB-S/T driver (PCI bridge: FPGA, I2C, DMA handlers)
Date: Wed, 10 Sep 2014 20:37:41 +0900
Message-Id: <1410349061-30124-1-git-send-email-knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bud <knightrider@are.ma>


DVB driver for Earthsoft PT3 (PCIE ISDB-S/T receiver)
-----------------------------------------------------

Status: stable

Features:
- tuning enhancements, from  PT1 DVB
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#
- allocated devices
	ISDB-S : /dev/dvb/adapter0, /dev/dvb/adapter1
	ISDB-T : /dev/dvb/adapter2, /dev/dvb/adapter3

Main components:
1. Sharp	VA4M6JC2103	: contains 2 ISDB-S + 2 ISDB-T tuners
	ISDB-S : Sharp QM1D1C0042 RF-IC
	ISDB-T : MaxLinear CMOS Hybrid TV MxL301RF
2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
3. Altera	EP4CGX15BF14C8N	: customized FPGA PCI bridge

Full package:
- URL:	https://github.com/knight-rider/ptx/tree/master/pt3_dvb
- buildable as standalone, DKMS or tree embedded module
- installation:
	$ chmod +x dkms.install dkms.uninstall
	$ ./dkms.install

Changes since last release:
- cleanups (removed unused/useless features, simple is the best)
- removed .ops.write hacks

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/Kconfig             |   2 +-
 drivers/media/pci/Makefile            |   2 +-
 drivers/media/pci/pt3/Kconfig         |  11 +
 drivers/media/pci/pt3/Makefile        |   6 +
 drivers/media/pci/pt3/pt3_common.h    |  84 ++++++
 drivers/media/pci/pt3/pt3_dma.c       | 332 +++++++++++++++++++++
 drivers/media/pci/pt3/pt3_dma.h       |  50 ++++
 drivers/media/pci/pt3/pt3_i2c.c       | 191 +++++++++++++
 drivers/media/pci/pt3/pt3_i2c.h       |  25 ++
 drivers/media/pci/pt3/pt3_pci.c       | 403 ++++++++++++++++++++++++++

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 9332807..89bd2a5 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -20,7 +20,6 @@ source "drivers/media/pci/ivtv/Kconfig"
 source "drivers/media/pci/zoran/Kconfig"
 source "drivers/media/pci/saa7146/Kconfig"
 source "drivers/media/pci/solo6x10/Kconfig"
-source "drivers/media/pci/tw68/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
@@ -42,6 +41,7 @@ source "drivers/media/pci/b2c2/Kconfig"
 source "drivers/media/pci/pluto2/Kconfig"
 source "drivers/media/pci/dm1105/Kconfig"
 source "drivers/media/pci/pt1/Kconfig"
+source "drivers/media/pci/pt3/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 73d9c0f..9db6775 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -7,6 +7,7 @@ obj-y        +=	ttpci/		\
 		pluto2/		\
 		dm1105/		\
 		pt1/		\
+		pt3/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
@@ -21,7 +22,6 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
-obj-$(CONFIG_VIDEO_TW68) += tw68/
 obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
new file mode 100644
index 0000000..0d866a0
--- /dev/null
+++ b/drivers/media/pci/pt3/Kconfig
@@ -0,0 +1,11 @@
+config PT3_DVB
+	tristate "Earthsoft PT3 ISDB-S/T cards"
+	depends on DVB_CORE && PCI
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for Earthsoft PT3 PCI-Express cards.
+	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)
+	  Say Y or M if you own such a device and want to use it.
+
diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
new file mode 100644
index 0000000..ede00e1
--- /dev/null
+++ b/drivers/media/pci/pt3/Makefile
@@ -0,0 +1,6 @@
+pt3_dvb-objs := pt3_pci.o pt3_dma.o pt3_i2c.o
+
+obj-$(CONFIG_PT3_DVB) += pt3_dvb.o
+
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
+
diff --git a/drivers/media/pci/pt3/pt3_common.h b/drivers/media/pci/pt3/pt3_common.h
new file mode 100644
index 0000000..92b6597
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_common.h
@@ -0,0 +1,84 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__PT3_COMMON_H__
+#define	__PT3_COMMON_H__
+
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "dvb_demux.h"
+#include "dmxdev.h"
+#include "dvb_frontend.h"
+
+#define DRV_NAME KBUILD_MODNAME
+
+/* register idx */
+#define PT3_REG_VERSION	0x00	/*	R	Version		*/
+#define PT3_REG_BUS	0x04	/*	R	Bus		*/
+#define PT3_REG_SYS_W	0x08	/*	W	System		*/
+#define PT3_REG_SYS_R	0x0c	/*	R	System		*/
+#define PT3_REG_I2C_W	0x10	/*	W	I2C		*/
+#define PT3_REG_I2C_R	0x14	/*	R	I2C		*/
+#define PT3_REG_RAM_W	0x18	/*	W	RAM		*/
+#define PT3_REG_RAM_R	0x1c	/*	R	RAM		*/
+#define PT3_REG_BASE	0x40	/* + 0x18*idx			*/
+#define PT3_REG_DMA_D_L	0x00	/*	W	DMA descriptor	*/
+#define PT3_REG_DMA_D_H	0x04	/*	W	DMA descriptor	*/
+#define PT3_REG_DMA_CTL	0x08	/*	W	DMA		*/
+#define PT3_REG_TS_CTL	0x0c	/*	W	TS		*/
+#define PT3_REG_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define PT3_REG_TS_ERR	0x14	/*	R	TS		*/
+
+struct pt3_adapter;
+
+struct pt3_board {
+	struct mutex lock;
+	int lnb;
+	bool reset;
+
+	struct pci_dev *pdev;
+	int bars;
+	void __iomem *bar_reg, *bar_mem;
+	struct i2c_adapter i2c;
+	u8 i2c_buf;
+	u32 i2c_addr;
+	bool i2c_filled;
+
+	struct pt3_adapter **adap;
+};
+
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
+
+	u8 idx;
+	bool sleep;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	int users, voltage;
+
+	struct dvb_frontend *fe;
+	int (*orig_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	int (*orig_sleep)(struct dvb_frontend *fe);
+	int (*orig_init)(struct dvb_frontend *fe);
+};
+
+#endif
+
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
new file mode 100644
index 0000000..90ff7e5
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.c
@@ -0,0 +1,332 @@
+/*
+ * DMA handler for Earthsoft PT3 ISDB-S/T PCI-E card DVB driver
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "pt3_dma.h"
+
+#define PT3_DMA_MAX_DESCS	204
+#define PT3_DMA_PAGE_SIZE	(PT3_DMA_MAX_DESCS * sizeof(struct pt3_dma_desc))
+#define PT3_DMA_BLOCK_COUNT	17
+#define PT3_DMA_BLOCK_SIZE	(PT3_DMA_PAGE_SIZE * 47)
+#define PT3_DMA_TS_BUF_SIZE	(PT3_DMA_BLOCK_SIZE * PT3_DMA_BLOCK_COUNT)
+#define PT3_DMA_TS_SYNC		0x47
+#define PT3_DMA_TS_NOT_SYNC	0x74
+
+void pt3_dma_free(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *page;
+	u32 i;
+
+	if (dma->ts_info) {
+		for (i = 0; i < dma->ts_count; i++) {
+			page = &dma->ts_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->ts_info);
+	}
+	if (dma->desc_info) {
+		for (i = 0; i < dma->desc_count; i++) {
+			page = &dma->desc_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->desc_info);
+	}
+	kfree(dma);
+}
+
+struct pt3_dma_desc {
+	u64 page_addr;
+	u32 page_size;
+	u64 next_desc;
+} __packed;
+
+void pt3_dma_build_page_descriptor(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *desc_info, *ts_info;
+	u64 ts_addr, desc_addr;
+	u32 i, j, ts_size, desc_remain, ts_info_pos, desc_info_pos;
+	struct pt3_dma_desc *prev, *curr;
+
+	dev_dbg(dma->adap->dvb.device, "#%d %s ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
+		dma->adap->idx, __func__, dma->ts_count, dma->ts_info[0].size, dma->desc_count, dma->desc_info[0].size);
+	desc_info_pos = ts_info_pos = 0;
+	desc_info = &dma->desc_info[desc_info_pos];
+	desc_addr   = desc_info->addr;
+	desc_remain = desc_info->size;
+	desc_info->data_pos = 0;
+	prev = NULL;
+	curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+	desc_info_pos++;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		if (unlikely(ts_info_pos >= dma->ts_count)) {
+			dev_dbg(dma->adap->dvb.device, "#%d ts_info overflow max=%d curr=%d\n", dma->adap->idx, dma->ts_count, ts_info_pos);
+			return;
+		}
+		ts_info = &dma->ts_info[ts_info_pos];
+		ts_addr = ts_info->addr;
+		ts_size = ts_info->size;
+		ts_info_pos++;
+		dev_dbg(dma->adap->dvb.device, "#%d i=%d, ts_info addr=0x%llx ts_size=%d\n", dma->adap->idx, i, ts_addr, ts_size);
+		for (j = 0; j < ts_size / PT3_DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct pt3_dma_desc)) {
+				if (unlikely(desc_info_pos >= dma->desc_count)) {
+					dev_dbg(dma->adap->dvb.device, "#%d desc_info overflow max=%d curr=%d\n",
+						dma->adap->idx, dma->desc_count, desc_info_pos);
+					return;
+				}
+				desc_info = &dma->desc_info[desc_info_pos];
+				desc_info->data_pos = 0;
+				curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+				dev_dbg(dma->adap->dvb.device, "#%d desc_info_pos=%d ts_addr=0x%llx remain=%d\n",
+					dma->adap->idx, desc_info_pos, ts_addr, desc_remain);
+				desc_addr = desc_info->addr;
+				desc_remain = desc_info->size;
+				desc_info_pos++;
+			}
+			if (prev)
+				prev->next_desc = desc_addr | 0b10;
+			curr->page_addr = ts_addr           | 0b111;
+			curr->page_size = PT3_DMA_PAGE_SIZE | 0b111;
+			curr->next_desc = 0b10;
+			dev_dbg(dma->adap->dvb.device, "#%d j=%d dma write desc ts_addr=0x%llx desc_info_pos=%d desc_remain=%d\n",
+				dma->adap->idx, j, ts_addr, desc_info_pos, desc_remain);
+			ts_addr += PT3_DMA_PAGE_SIZE;
+
+			prev = curr;
+			desc_info->data_pos += sizeof(struct pt3_dma_desc);
+			if (unlikely(desc_info->data_pos > desc_info->size)) {
+				dev_dbg(dma->adap->dvb.device, "#%d dma desc_info data overflow max=%d curr=%d\n",
+					dma->adap->idx, desc_info->size, desc_info->data_pos);
+				return;
+			}
+			curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+			desc_addr += sizeof(struct pt3_dma_desc);
+			desc_remain -= sizeof(struct pt3_dma_desc);
+		}
+	}
+	if (prev)
+		prev->next_desc = dma->desc_info->addr | 0b10;
+}
+
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap)
+{
+	struct pt3_dma_page *page;
+	u32 i;
+	struct pt3_dma *dma = kzalloc(sizeof(struct pt3_dma), GFP_KERNEL);
+
+	if (!dma)
+		goto fail;
+	dma->adap = adap;
+	dma->enabled = false;
+	mutex_init(&dma->lock);
+
+	dma->ts_count = PT3_DMA_BLOCK_COUNT;
+	dma->ts_info = kcalloc(dma->ts_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->ts_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate TS DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc TS buf (ts_count %d)\n", adap->idx, dma->ts_count);
+	for (i = 0; i < dma->ts_count; i++) {
+		page = &dma->ts_info[i];
+		page->size = PT3_DMA_BLOCK_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent. %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	dma->desc_count = 1 + (PT3_DMA_TS_BUF_SIZE / PT3_DMA_PAGE_SIZE - 1) / PT3_DMA_MAX_DESCS;
+	dma->desc_info = kcalloc(dma->desc_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->desc_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate Desc DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc Descriptor buf (desc_count %d)\n", adap->idx, dma->desc_count);
+	for (i = 0; i < dma->desc_count; i++) {
+		page = &dma->desc_info[i];
+		page->size = PT3_DMA_PAGE_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	dev_dbg(adap->dvb.device, "#%d build page descriptor\n", adap->idx);
+	pt3_dma_build_page_descriptor(dma);
+	return dma;
+fail:
+	if (dma)
+		pt3_dma_free(dma);
+	return NULL;
+}
+
+void __iomem *pt3_dma_get_base_addr(struct pt3_dma *dma)
+{
+	return dma->adap->pt3->bar_reg + PT3_REG_BASE + (0x18 * dma->adap->idx);
+}
+
+void pt3_dma_reset(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u32 i;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		ts = &dma->ts_info[i];
+		memset(ts->data, 0, ts->size);
+		ts->data_pos = 0;
+		*ts->data = PT3_DMA_TS_NOT_SYNC;
+	}
+	dma->ts_pos = 0;
+}
+
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u64 start_addr = dma->desc_info->addr;
+
+	if (enabled) {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA enable start_addr=%llx\n", dma->adap->idx, start_addr);
+		pt3_dma_reset(dma);
+		writel(1 << 1, base + PT3_REG_DMA_CTL);	/* stop DMA */
+		writel(start_addr         & 0xffffffff, base + PT3_REG_DMA_D_L);
+		writel((start_addr >> 32) & 0xffffffff, base + PT3_REG_DMA_D_H);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address low %llx\n",  start_addr         & 0xffffffff);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address high %llx\n", (start_addr >> 32) & 0xffffffff);
+		writel(1 << 0, base + PT3_REG_DMA_CTL);	/* start DMA */
+	} else {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + PT3_REG_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!(readl(base + PT3_REG_STATUS) & 1))
+				break;
+			msleep_interruptible(1);
+		}
+	}
+	dma->enabled = enabled;
+}
+
+/* convert Gray code to binary, e.g. 1001 -> 1110 */
+static u32 pt3_dma_gray2binary(u32 gray, u32 bit)
+{
+	u32 binary = 0, i, j, k;
+
+	for (i = 0; i < bit; i++) {
+		k = 0;
+		for (j = i; j < bit; j++)
+			k ^= (gray >> j) & 1;
+		binary |= k << i;
+	}
+	return binary;
+}
+
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + PT3_REG_TS_ERR), 32);
+}
+
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
+
+	dev_dbg(dma->adap->dvb.device, "#%d %s base=%p data=0x%04x\n", dma->adap->idx, __func__, base, data);
+	writel(data, base + PT3_REG_TS_CTL);
+}
+
+bool pt3_dma_ready(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u8 *p;
+	u32 next = dma->ts_pos + 1;
+
+	if (next >= dma->ts_count)
+		next = 0;
+	ts = &dma->ts_info[next];
+	p = &ts->data[ts->data_pos];
+
+	if (*p == PT3_DMA_TS_SYNC)
+		return true;
+	if (*p == PT3_DMA_TS_NOT_SYNC)
+		return false;
+
+	dev_dbg(dma->adap->dvb.device, "#%d invalid sync byte value=0x%02x ts_pos=%d data_pos=%d curr=0x%02x\n",
+		dma->adap->idx, *p, next, ts->data_pos, dma->ts_info[dma->ts_pos].data[0]);
+	return false;
+}
+
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux)
+{
+	bool ready;
+	struct pt3_dma_page *ts;
+	u32 i, prev;
+	size_t csize, remain = dma->ts_info[dma->ts_pos].size;
+
+	mutex_lock(&dma->lock);
+	dev_dbg(dma->adap->dvb.device, "#%d dma_copy ts_pos=0x%x data_pos=0x%x\n",
+		   dma->adap->idx, dma->ts_pos, dma->ts_info[dma->ts_pos].data_pos);
+	for (;;) {
+		for (i = 0; i < 20; i++) {
+			ready = pt3_dma_ready(dma);
+			if (ready)
+				break;
+			msleep_interruptible(30);
+		}
+		if (!ready) {
+			dev_dbg(dma->adap->dvb.device, "#%d dma_copy NOT READY\n", dma->adap->idx);
+			goto last;
+		}
+		prev = dma->ts_pos - 1;
+		if (prev < 0 || dma->ts_count <= prev)
+			prev = dma->ts_count - 1;
+		if (dma->ts_info[prev].data[0] != PT3_DMA_TS_NOT_SYNC)
+			dev_dbg(dma->adap->dvb.device, "#%d DMA buffer overflow. prev=%d data=0x%x\n",
+					dma->adap->idx, prev, dma->ts_info[prev].data[0]);
+		ts = &dma->ts_info[dma->ts_pos];
+		for (;;) {
+			csize = (remain < (ts->size - ts->data_pos)) ?
+				 remain : (ts->size - ts->data_pos);
+			dvb_dmx_swfilter(demux, &ts->data[ts->data_pos], csize);
+			remain -= csize;
+			ts->data_pos += csize;
+			if (ts->data_pos >= ts->size) {
+				ts->data_pos = 0;
+				ts->data[ts->data_pos] = PT3_DMA_TS_NOT_SYNC;
+				dma->ts_pos++;
+				if (dma->ts_pos >= dma->ts_count)
+					dma->ts_pos = 0;
+				break;
+			}
+			if (remain <= 0)
+				goto last;
+		}
+	}
+last:
+	mutex_unlock(&dma->lock);
+	return dma->ts_info[dma->ts_pos].size - remain;
+}
+
+u32 pt3_dma_get_status(struct pt3_dma *dma)
+{
+	return readl(pt3_dma_get_base_addr(dma) + PT3_REG_STATUS);
+}
+
diff --git a/drivers/media/pci/pt3/pt3_dma.h b/drivers/media/pci/pt3/pt3_dma.h
new file mode 100644
index 0000000..934c222
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.h
@@ -0,0 +1,50 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__PT3_DMA_H__
+#define	__PT3_DMA_H__
+
+#include "pt3_common.h"
+
+struct pt3_dma_page {
+	dma_addr_t addr;
+	u8 *data;
+	u32 size, data_pos;
+};
+
+enum pt3_dma_mode {
+	USE_LFSR = 1 << 16,
+	REVERSE  = 1 << 17,
+	RESET    = 1 << 18,
+};
+
+struct pt3_dma {
+	struct pt3_adapter *adap;
+	bool enabled;
+	u32 ts_pos, ts_count, desc_count;
+	struct pt3_dma_page *ts_info, *desc_info;
+	struct mutex lock;
+};
+
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux);
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap);
+void pt3_dma_free(struct pt3_dma *dma);
+u32 pt3_dma_get_status(struct pt3_dma *dma);
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma);
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled);
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval);
+
+#endif
diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
new file mode 100644
index 0000000..a8df77d
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.c
@@ -0,0 +1,191 @@
+/*
+ * I2C handler for Earthsoft PT3 ISDB-S/T PCI-E card DVB driver
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "pt3_i2c.h"
+
+#define PT3_I2C_DATA_OFFSET	2048
+#define PT3_I2C_START_ADDR	0x17fa
+
+enum pt3_i2c_cmd {
+	I_END,
+	I_ADDRESS,
+	I_CLOCK_L,
+	I_CLOCK_H,
+	I_DATA_L,
+	I_DATA_H,
+	I_RESET,
+	I_SLEEP,
+	I_DATA_L_NOP  = 0x08,
+	I_DATA_H_NOP  = 0x0c,
+	I_DATA_H_READ = 0x0d,
+	I_DATA_H_ACK0 = 0x0e,
+	I_DATA_H_ACK1 = 0x0f,
+};
+
+bool pt3_i2c_is_clean(struct pt3_board *pt3)
+{
+	return (readl(pt3->bar_reg + PT3_REG_I2C_R) >> 3) & 1;
+}
+
+void pt3_i2c_reset(struct pt3_board *pt3)
+{
+	writel(1 << 17, pt3->bar_reg + PT3_REG_I2C_W);			/* 0x00020000 */
+}
+
+void pt3_i2c_wait(struct pt3_board *pt3, u32 *status)
+{
+	u32 val;
+
+	while (1) {
+		val = readl(pt3->bar_reg + PT3_REG_I2C_R);
+		if (!(val & 1))						/* sequence stopped */
+			break;
+		msleep_interruptible(1);
+	}
+	if (status)
+		*status = val;						/* I2C register status */
+}
+
+void pt3_i2c_mem_write(struct pt3_board *pt3, u8 data)
+{
+	void __iomem *dst = pt3->bar_mem + PT3_I2C_DATA_OFFSET + pt3->i2c_addr;
+
+	if (pt3->i2c_filled) {
+		pt3->i2c_buf |= data << 4;
+		writeb(pt3->i2c_buf, dst);
+		pt3->i2c_addr++;
+	} else
+		pt3->i2c_buf = data;
+	pt3->i2c_filled ^= true;
+}
+
+void pt3_i2c_start(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_L);
+}
+
+void pt3_i2c_cmd_write(struct pt3_board *pt3, const u8 *data, u32 size)
+{
+	u32 i, j;
+	u8 byte;
+
+	for (i = 0; i < size; i++) {
+		byte = data[i];
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, (byte >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
+		pt3_i2c_mem_write(pt3, I_DATA_H_ACK0);
+	}
+}
+
+void pt3_i2c_cmd_read(struct pt3_board *pt3, u8 *data, u32 size)
+{
+	u32 i, j;
+
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, I_DATA_H_READ);
+		if (i == (size - 1))
+			pt3_i2c_mem_write(pt3, I_DATA_H_NOP);
+		else
+			pt3_i2c_mem_write(pt3, I_DATA_L_NOP);
+	}
+}
+
+void pt3_i2c_stop(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+}
+
+int pt3_i2c_flush(struct pt3_board *pt3, bool end, u32 start_addr)
+{
+	u32 status;
+
+	if (end) {
+		pt3_i2c_mem_write(pt3, I_END);
+		if (pt3->i2c_filled)
+			pt3_i2c_mem_write(pt3, I_END);
+	}
+	pt3_i2c_wait(pt3, &status);
+	writel(1 << 16 | start_addr, pt3->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
+	pt3_i2c_wait(pt3, &status);
+	if (status & 0b0110) {						/* ACK status */
+		dev_err(&pt3->i2c.dev, "%s %s failed, status=0x%x\n", pt3->i2c.name, __func__, status);
+		return -EIO;
+	}
+	return 0;
+}
+
+u32 pt3_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C;
+}
+
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num)
+{
+	struct pt3_board *pt3 = i2c_get_adapdata(i2c);
+	int i, j;
+
+	if (!num)
+		return pt3_i2c_flush(pt3, false, PT3_I2C_START_ADDR);
+	if ((num < 1) || (num > 3) || !msg || msg[0].flags)		/* always write first */
+		return -ENOTSUPP;
+	mutex_lock(&pt3->lock);
+	pt3->i2c_addr = 0;
+	for (i = 0; i < num; i++) {
+		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
+
+		pt3_i2c_start(pt3);
+		pt3_i2c_cmd_write(pt3, &byte, 1);
+		if (msg[i].flags == I2C_M_RD)
+			pt3_i2c_cmd_read(pt3, msg[i].buf, msg[i].len);
+		else
+			pt3_i2c_cmd_write(pt3, msg[i].buf, msg[i].len);
+	}
+	pt3_i2c_stop(pt3);
+	if (pt3_i2c_flush(pt3, true, 0))
+		num = -EIO;
+	else
+		for (i = 1; i < num; i++)
+			if (msg[i].flags == I2C_M_RD)
+				for (j = 0; j < msg[i].len; j++)
+					msg[i].buf[j] = readb(pt3->bar_mem + PT3_I2C_DATA_OFFSET + j);
+	mutex_unlock(&pt3->lock);
+	return num;
+}
+
+static const struct i2c_algorithm pt3_i2c_algo = {
+	.functionality = pt3_i2c_func,
+	.master_xfer = pt3_i2c_xfer,
+};
+
+int pt3_i2c_add_adapter(struct pt3_board *pt3)
+{
+	struct i2c_adapter *i2c = &pt3->i2c;
+
+	i2c->algo = &pt3_i2c_algo;
+	i2c->algo_data = NULL;
+	i2c->dev.parent = &pt3->pdev->dev;
+	strcpy(i2c->name, DRV_NAME);
+	i2c_set_adapdata(i2c, pt3);
+	return	i2c_add_adapter(i2c) ||
+		(!pt3_i2c_is_clean(pt3) && pt3_i2c_flush(pt3, false, 0));
+}
+
diff --git a/drivers/media/pci/pt3/pt3_i2c.h b/drivers/media/pci/pt3/pt3_i2c.h
new file mode 100644
index 0000000..8424fd5
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.h
@@ -0,0 +1,25 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__PT3_I2C_H__
+#define	__PT3_I2C_H__
+
+#include "pt3_common.h"
+
+void pt3_i2c_reset(struct pt3_board *pt3);
+int pt3_i2c_add_adapter(struct pt3_board *pt3);
+
+#endif
diff --git a/drivers/media/pci/pt3/pt3_pci.c b/drivers/media/pci/pt3/pt3_pci.c
new file mode 100644
index 0000000..0bca3ec
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_pci.c
@@ -0,0 +1,403 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "pt3_dma.h"
+#include "pt3_i2c.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
+
+static struct pci_device_id pt3_id_table[] = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
+
+static int lnb = 2;
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+struct pt3_lnb {
+	u32 bits;
+	char *str;
+};
+
+static const struct pt3_lnb pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
+
+struct pt3_cfg {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_demod;
+};
+
+static const struct pt3_cfg pt3_cfg[] = {
+	{SYS_ISDBS, 0x63, 0b00010001},
+	{SYS_ISDBS, 0x60, 0b00010011},
+	{SYS_ISDBT, 0x62, 0b00010000},
+	{SYS_ISDBT, 0x61, 0b00010010},
+};
+#define PT3_ADAPN ARRAY_SIZE(pt3_cfg)
+
+int pt3_update_lnb(struct pt3_board *pt3)
+{
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->bar_reg + PT3_REG_SYS_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
+
+		for (i = 0; i < PT3_ADAPN; i++) {
+			adap = pt3->adap[i];
+			dev_dbg(adap->dvb.device, "#%d sleep %d\n", adap->idx, adap->sleep);
+			if ((pt3_cfg[i].type == SYS_ISDBS) && (!adap->sleep))
+				lnb_eff |= adap->voltage ? adap->voltage : lnb;
+		}
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			dev_err(&pt3->pdev->dev, "Inconsistent LNB settings\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->bar_reg + PT3_REG_SYS_W);
+			pt3->lnb = lnb_eff;
+		}
+	}
+	dev_dbg(&pt3->pdev->dev, "LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
+
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while ((ret = pt3_dma_copy(adap->dma, &adap->demux)) > 0)
+			;
+		if (ret < 0) {
+			dev_dbg(adap->dvb.device, "#%d fail dma_copy\n", adap->idx);
+			msleep_interruptible(1);
+		}
+	}
+	return 0;
+}
+
+int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int ret = 0;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!adap->users++) {
+		dev_dbg(adap->dvb.device, "#%d %s selected, DMA %s\n",
+			adap->idx, (pt3_cfg[adap->idx].type == SYS_ISDBS) ? "S" : "T",
+			pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		mutex_lock(&adap->lock);
+		if (!adap->kthread) {
+			adap->kthread = kthread_run(pt3_thread, adap, DRV_NAME "_%d", adap->idx);
+			if (IS_ERR(adap->kthread)) {
+				ret = PTR_ERR(adap->kthread);
+				adap->kthread = NULL;
+			} else {
+				pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset error count */
+				pt3_dma_set_enabled(adap->dma, true);
+			}
+		}
+		mutex_unlock(&adap->lock);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!--adap->users) {
+		mutex_lock(&adap->lock);
+		if (adap->kthread) {
+			pt3_dma_set_enabled(adap->dma, false);
+			dev_dbg(adap->dvb.device, "#%d DMA ts_err packet cnt %d\n",
+				adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+			kthread_stop(adap->kthread);
+			adap->kthread = NULL;
+		}
+		mutex_unlock(&adap->lock);
+		msleep_interruptible(40);
+	}
+	return 0;
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct pt3_adapter *pt3_dvb_register_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+	adap->pt3 = pt3;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, DRV_NAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	dev_dbg(dvb->device, "adapter%d registered\n", ret);
+	if (ret >= 0) {
+		demux = &adap->demux;
+		demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+		demux->priv = adap;
+		demux->feednum = 256;
+		demux->filternum = 256;
+		demux->start_feed = pt3_start_feed;
+		demux->stop_feed = pt3_stop_feed;
+		demux->write_to_decoder = NULL;
+		ret = dvb_dmx_init(demux);
+		if (ret >= 0) {
+			dmxdev = &adap->dmxdev;
+			dmxdev->filternum = 256;
+			dmxdev->demux = &demux->dmx;
+			dmxdev->capabilities = 0;
+			ret = dvb_dmxdev_init(dmxdev, dvb);
+			if (ret >= 0)
+				return adap;
+			dvb_dmx_release(demux);
+		}
+		dvb_unregister_adapter(dvb);
+	}
+	kfree(adap);
+	return ERR_PTR(ret);
+}
+
+int pt3_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_sleep);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+int pt3_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_init);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+int pt3_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+
+	adap->voltage = voltage == SEC_VOLTAGE_18 ? 2 : voltage == SEC_VOLTAGE_13 ? 1 : 0;
+	return (adap->orig_voltage) ? adap->orig_voltage(fe, voltage) : 0;
+}
+
+void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
+	if (adap->fe) {
+		dvb_unregister_frontend(adap->fe);
+		adap->fe->ops.release(adap->fe);
+	}
+	if (adap->dma) {
+		if (adap->dma->enabled)
+			pt3_dma_set_enabled(adap->dma, false);
+		pt3_dma_free(adap->dma);
+	}
+	adap->demux.dmx.close(&adap->demux.dmx);
+	dvb_dmxdev_release(&adap->dmxdev);
+	dvb_dmx_release(&adap->demux);
+	dvb_unregister_adapter(&adap->dvb);
+	kfree(adap);
+}
+
+void pt3_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
+
+	if (pt3) {
+		pt3->reset = true;
+		pt3_update_lnb(pt3);
+		for (i = 0; i < PT3_ADAPN; i++)
+			pt3_cleanup_adapter(pt3->adap[i]);
+		pt3_i2c_reset(pt3);
+		i2c_del_adapter(&pt3->i2c);
+		if (pt3->bar_mem)
+			iounmap(pt3->bar_mem);
+		if (pt3->bar_reg)
+			iounmap(pt3->bar_reg);
+		pci_release_selected_regions(pdev, pt3->bars);
+		kfree(pt3->adap);
+		kfree(pt3);
+	}
+	pci_disable_device(pdev);
+}
+
+int pt3_abort(struct pci_dev *pdev, int ret, char *fmt, ...)
+{
+	va_list ap;
+	char *s = NULL;
+	int slen;
+
+	va_start(ap, fmt);
+	slen = vsnprintf(s, 0, fmt, ap);
+	s = vzalloc(slen);
+	if (slen > 0 && s) {
+		vsnprintf(s, slen, fmt, ap);
+		dev_err(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	pt3_remove(pdev);
+	return ret;
+}
+
+int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct pt3_board *pt3;
+	struct pt3_adapter *adap;
+	const struct pt3_cfg *cfg = pt3_cfg;
+	struct dvb_frontend *fe[PT3_ADAPN];
+	int i, err, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	err = pci_enable_device(pdev)					||
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(64))		||
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))	||
+		pci_read_config_dword(pdev, PCI_CLASS_REVISION, &i)	||
+		pci_request_selected_regions(pdev, bars, DRV_NAME);
+	if (err)
+		return pt3_abort(pdev, err, "PCI/DMA error\n");
+	if ((i & 0xFF) != 1)
+		return pt3_abort(pdev, -EINVAL, "Revision 0x%x is not supported\n", i & 0xFF);
+
+	pci_set_master(pdev);
+	err = pci_save_state(pdev);
+	if (err)
+		return pt3_abort(pdev, err, "Failed pci_save_state\n");
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+	pt3->adap = kcalloc(PT3_ADAPN, sizeof(struct pt3_adapter *), GFP_KERNEL);
+	if (!pt3->adap)
+		return pt3_abort(pdev, -ENOMEM, "No memory for *adap\n");
+
+	pt3->bars = bars;
+	pt3->pdev = pdev;
+	pci_set_drvdata(pdev, pt3);
+	pt3->bar_reg = pci_ioremap_bar(pdev, 0);
+	pt3->bar_mem = pci_ioremap_bar(pdev, 2);
+	if (!pt3->bar_reg || !pt3->bar_mem)
+		return pt3_abort(pdev, -EIO, "Failed pci_ioremap_bar\n");
+
+	err = readl(pt3->bar_reg + PT3_REG_VERSION);
+	i = ((err >> 24) & 0xFF);
+	if (i != 3)
+		return pt3_abort(pdev, -EIO, "ID=0x%x, not a PT3\n", i);
+	i = ((err >>  8) & 0xFF);
+	if (i != 4)
+		return pt3_abort(pdev, -EIO, "FPGA version 0x%x is not supported\n", i);
+	err = pt3_i2c_add_adapter(pt3);
+	if (err < 0)
+		return pt3_abort(pdev, err, "Cannot add I2C\n");
+	mutex_init(&pt3->lock);
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		adap = pt3_dvb_register_adapter(pt3);
+		if (IS_ERR(adap))
+			return pt3_abort(pdev, PTR_ERR(adap), "Failed pt3_dvb_register_adapter\n");
+		adap->idx = i;
+		adap->dma = pt3_dma_create(adap);
+		if (!adap->dma)
+			return pt3_abort(pdev, -ENOMEM, "Failed pt3_dma_create\n");
+		pt3->adap[i] = adap;
+		adap->sleep = true;
+		mutex_init(&adap->lock);
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		fe[i] = tc90522_attach(&pt3->i2c, cfg[i].type, cfg[i].addr_demod, i + 1 == PT3_ADAPN);
+		if (!fe[i] || (cfg[i].type == SYS_ISDBS ?
+			qm1d1c0042_attach(fe[i], cfg[i].addr_tuner) : mxl301rf_attach(fe[i], cfg[i].addr_tuner))) {
+			while (i--)
+				fe[i]->ops.release(fe[i]);
+			return pt3_abort(pdev, -ENOMEM, "Cannot attach frontend\n");
+		}
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+
+		dev_dbg(&pdev->dev, "#%d %s\n", i, __func__);
+		adap->orig_voltage	= fe[i]->ops.set_voltage;
+		adap->orig_sleep	= fe[i]->ops.sleep;
+		adap->orig_init		= fe[i]->ops.init;
+		fe[i]->ops.set_voltage	= pt3_set_voltage;
+		fe[i]->ops.sleep	= pt3_sleep;
+		fe[i]->ops.init		= pt3_wakeup;
+		fe[i]->dvb		= &adap->dvb;
+		if ((adap->orig_init(fe[i]) && adap->orig_init(fe[i]) && adap->orig_init(fe[i])) ||
+			adap->orig_sleep(fe[i]) || dvb_register_frontend(&adap->dvb, fe[i])) {
+			while (i--)
+				dvb_unregister_frontend(fe[i]);
+			for (i = 0; i < PT3_ADAPN; i++) {
+				fe[i]->ops.release(fe[i]);
+				adap->fe = NULL;
+			}
+			return pt3_abort(pdev, -EREMOTEIO, "Cannot register frontend\n");
+		}
+		adap->fe = fe[i];
+	}
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
+	return 0;
+}
+
+static struct pci_driver pt3_driver = {
+	.name		= DRV_NAME,
+	.probe		= pt3_probe,
+	.remove		= pt3_remove,
+	.id_table	= pt3_id_table,
+};
+
+module_pci_driver(pt3_driver);

