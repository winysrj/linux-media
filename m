Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:49732 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZHWDv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 23:51:58 -0400
Received: by pxi34 with SMTP id 34so4646422pxi.4
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 20:52:00 -0700 (PDT)
From: hiranotaka@zng.jp
Date: Sun, 23 Aug 2009 12:51:22 +0900
Message-Id: <87my5r89xh.fsf@wei.zng.jp>
To: mchehab@infradead.org, linux-media@vger.kernel.org
CC: tomy@users.sourceforge.jp
Subject: [PATCH 2/2] Add a driver for Earthsoft PT1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Add a driver for Earthsoft PT1

Eearthsoft PT1 is a PCI card for Japanese broadcasting with two ISDB-S
and ISDB-T demodulators.

This card has neither MPEG decoder nor conditional access module
onboard. It transmits only compressed and possibly encrypted MPEG data
over the PCI bus, so you need an external software decoder and a
decrypter to watch TV on your computer.

This driver is originally developed by Tomoaki Ishikawa
<tomy@users.sourceforge.jp> by reverse engineering.

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>

diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig	Sun Aug 23 11:50:35 2009 +0900
+++ b/linux/drivers/media/dvb/Kconfig	Sun Aug 23 12:29:31 2009 +0900
@@ -55,6 +55,10 @@
 	depends on DVB_CORE && IEEE1394
 source "drivers/media/dvb/firewire/Kconfig"
 
+comment "Supported Earthsoft PT1 Adapters"
+	depends on DVB_CORE && PCI && I2C
+source "drivers/media/dvb/pt1/Kconfig"
+
 comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/Makefile
--- a/linux/drivers/media/dvb/Makefile	Sun Aug 23 11:50:35 2009 +0900
+++ b/linux/drivers/media/dvb/Makefile	Sun Aug 23 12:29:31 2009 +0900
@@ -2,6 +2,6 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y        := dvb-core/ frontends/ ttpci/ ttusb-dec/ ttusb-budget/ b2c2/ bt8xx/ dvb-usb/ pluto2/ siano/ dm1105/
+obj-y        := dvb-core/ frontends/ ttpci/ ttusb-dec/ ttusb-budget/ b2c2/ bt8xx/ dvb-usb/ pluto2/ siano/ dm1105/ pt1/
 
 obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/Kconfig
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/Kconfig	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,12 @@
+config DVB_PT1
+	tristate "PT1 cards"
+	depends on DVB_CORE && PCI && I2C
+	help
+	  Support for Earthsoft PT1 PCI cards.
+
+	  Since these cards have no MPEG decoder onboard, they transmit
+	  only compressed MPEG data over the PCI bus, so you need
+	  an external software decoder to watch TV on your computer.
+
+	  Say Y or M if you own such a device and want to use it.
+
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/Makefile
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/Makefile	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,5 @@
+earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
+
+obj-$(CONFIG_DVB_PT1) += earth-pt1.o
+
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core -Idrivers/media/dvb/frontends
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/pt1.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/pt1.c	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,1056 @@
+/*
+ * driver for Earthsoft PT1
+ *
+ * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
+ *
+ * based on pt1dvr - http://pt1dvr.sourceforge.jp/
+ * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dmxdev.h"
+#include "dvb_net.h"
+#include "dvb_frontend.h"
+
+#include "va1j5jf8007t.h"
+#include "va1j5jf8007s.h"
+
+#define DRIVER_NAME "earth-pt1"
+
+#define PT1_PAGE_SHIFT 12
+#define PT1_PAGE_SIZE (1 << PT1_PAGE_SHIFT)
+#define PT1_NR_UPACKETS 1024
+#define PT1_NR_BUFS 511
+
+struct pt1_buffer_page {
+	__le32 upackets[PT1_NR_UPACKETS];
+};
+
+struct pt1_table_page {
+	__le32 next_pfn;
+	__le32 buf_pfns[PT1_NR_BUFS];
+};
+
+struct pt1_buffer {
+	struct pt1_buffer_page *page;
+	dma_addr_t addr;
+};
+
+struct pt1_table {
+	struct pt1_table_page *page;
+	dma_addr_t addr;
+	struct pt1_buffer bufs[PT1_NR_BUFS];
+};
+
+#define PT1_NR_ADAPS 4
+
+struct pt1_adapter;
+
+struct pt1 {
+	struct pci_dev *pdev;
+	void __iomem *regs;
+	struct i2c_adapter i2c_adap;
+	int i2c_running;
+	struct pt1_adapter *adaps[PT1_NR_ADAPS];
+	struct pt1_table *tables;
+	struct task_struct *kthread;
+};
+
+struct pt1_adapter {
+	struct pt1 *pt1;
+	int index;
+
+	u8 *buf;
+	int upacket_count;
+	int packet_count;
+
+	struct dvb_adapter adap;
+	struct dvb_demux demux;
+	int users;
+	struct dmxdev dmxdev;
+	struct dvb_net net;
+	struct dvb_frontend *fe;
+	int (*orig_set_voltage)(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage);
+};
+
+#define pt1_printk(level, pt1, format, arg...)	\
+	dev_printk(level, &(pt1)->pdev->dev, format, ##arg)
+
+static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
+{
+	writel(data, pt1->regs + reg * 4);
+}
+
+static u32 pt1_read_reg(struct pt1 *pt1, int reg)
+{
+	return readl(pt1->regs + reg * 4);
+}
+
+static int pt1_nr_tables = 64;
+module_param_named(nr_tables, pt1_nr_tables, int, 0);
+
+static void pt1_increment_table_count(struct pt1 *pt1)
+{
+	pt1_write_reg(pt1, 0, 0x00000020);
+}
+
+static void pt1_init_table_count(struct pt1 *pt1)
+{
+	pt1_write_reg(pt1, 0, 0x00000010);
+}
+
+static void pt1_register_tables(struct pt1 *pt1, u32 first_pfn)
+{
+	pt1_write_reg(pt1, 5, first_pfn);
+	pt1_write_reg(pt1, 0, 0x0c000040);
+}
+
+static void pt1_unregister_tables(struct pt1 *pt1)
+{
+	pt1_write_reg(pt1, 0, 0x08080000);
+}
+
+static int pt1_sync(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < 57; i++) {
+		if (pt1_read_reg(pt1, 0) & 0x20000000)
+			return 0;
+		pt1_write_reg(pt1, 0, 0x00000008);
+	}
+	pt1_printk(KERN_ERR, pt1, "could not sync\n");
+	return -EIO;
+}
+
+static u64 pt1_identify(struct pt1 *pt1)
+{
+	int i;
+	u64 id;
+	id = 0;
+	for (i = 0; i < 57; i++) {
+		id |= (u64)(pt1_read_reg(pt1, 0) >> 30 & 1) << i;
+		pt1_write_reg(pt1, 0, 0x00000008);
+	}
+	return id;
+}
+
+static int pt1_unlock(struct pt1 *pt1)
+{
+	int i;
+	pt1_write_reg(pt1, 0, 0x00000008);
+	for (i = 0; i < 3; i++) {
+		if (pt1_read_reg(pt1, 0) & 0x80000000)
+			return 0;
+		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	}
+	pt1_printk(KERN_ERR, pt1, "could not unlock\n");
+	return -EIO;
+}
+
+static int pt1_reset_pci(struct pt1 *pt1)
+{
+	int i;
+	pt1_write_reg(pt1, 0, 0x01010000);
+	pt1_write_reg(pt1, 0, 0x01000000);
+	for (i = 0; i < 10; i++) {
+		if (pt1_read_reg(pt1, 0) & 0x00000001)
+			return 0;
+		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	}
+	pt1_printk(KERN_ERR, pt1, "could not reset PCI\n");
+	return -EIO;
+}
+
+static int pt1_reset_ram(struct pt1 *pt1)
+{
+	int i;
+	pt1_write_reg(pt1, 0, 0x02020000);
+	pt1_write_reg(pt1, 0, 0x02000000);
+	for (i = 0; i < 10; i++) {
+		if (pt1_read_reg(pt1, 0) & 0x00000002)
+			return 0;
+		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	}
+	pt1_printk(KERN_ERR, pt1, "could not reset RAM\n");
+	return -EIO;
+}
+
+static int pt1_do_enable_ram(struct pt1 *pt1)
+{
+	int i, j;
+	u32 status;
+	status = pt1_read_reg(pt1, 0) & 0x00000004;
+	pt1_write_reg(pt1, 0, 0x00000002);
+	for (i = 0; i < 10; i++) {
+		for (j = 0; j < 1024; j++) {
+			if ((pt1_read_reg(pt1, 0) & 0x00000004) != status)
+				return 0;
+		}
+		schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	}
+	pt1_printk(KERN_ERR, pt1, "could not enable RAM\n");
+	return -EIO;
+}
+
+static int pt1_enable_ram(struct pt1 *pt1)
+{
+	int i, ret;
+	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+	for (i = 0; i < 10; i++) {
+		ret = pt1_do_enable_ram(pt1);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static void pt1_disable_ram(struct pt1 *pt1)
+{
+	pt1_write_reg(pt1, 0, 0x0b0b0000);
+}
+
+static void pt1_set_stream(struct pt1 *pt1, int index, int enabled)
+{
+	pt1_write_reg(pt1, 2, 1 << (index + 8) | enabled << index);
+}
+
+static void pt1_init_streams(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < PT1_NR_ADAPS; i++)
+		pt1_set_stream(pt1, i, 0);
+}
+
+static int pt1_filter(struct pt1 *pt1, struct pt1_buffer_page *page)
+{
+	u32 upacket;
+	int i;
+	int index;
+	struct pt1_adapter *adap;
+	int offset;
+	u8 *buf;
+
+	if (!page->upackets[PT1_NR_UPACKETS - 1])
+		return 0;
+
+	for (i = 0; i < PT1_NR_UPACKETS; i++) {
+		upacket = le32_to_cpu(page->upackets[i]);
+		index = (upacket >> 29) - 1;
+		if (index < 0 || index >=  PT1_NR_ADAPS)
+			continue;
+
+		adap = pt1->adaps[index];
+		if (upacket >> 25 & 1)
+			adap->upacket_count = 0;
+		else if (!adap->upacket_count)
+			continue;
+
+		buf = adap->buf;
+		offset = adap->packet_count * 188 + adap->upacket_count * 3;
+		buf[offset] = upacket >> 16;
+		buf[offset + 1] = upacket >> 8;
+		if (adap->upacket_count != 62)
+			buf[offset + 2] = upacket;
+
+		if (++adap->upacket_count >= 63) {
+			adap->upacket_count = 0;
+			if (++adap->packet_count >= 21) {
+				dvb_dmx_swfilter_packets(&adap->demux, buf, 21);
+				adap->packet_count = 0;
+			}
+		}
+	}
+
+	page->upackets[PT1_NR_UPACKETS - 1] = 0;
+	return 1;
+}
+
+static int pt1_thread(void *data)
+{
+	struct pt1 *pt1;
+	int table_index;
+	int buf_index;
+	struct pt1_buffer_page *page;
+
+	pt1 = data;
+	set_freezable();
+
+	table_index = 0;
+	buf_index = 0;
+
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+
+		page = pt1->tables[table_index].bufs[buf_index].page;
+		if (!pt1_filter(pt1, page)) {
+			schedule_timeout_interruptible((HZ + 999) / 1000);
+			continue;
+		}
+
+		if (++buf_index >= PT1_NR_BUFS) {
+			pt1_increment_table_count(pt1);
+			buf_index = 0;
+			if (++table_index >= pt1_nr_tables)
+				table_index = 0;
+		}
+	}
+
+	return 0;
+}
+
+static void pt1_free_page(struct pt1 *pt1, void *page, dma_addr_t addr)
+{
+	dma_free_coherent(&pt1->pdev->dev, PT1_PAGE_SIZE, page, addr);
+}
+
+static void *pt1_alloc_page(struct pt1 *pt1, dma_addr_t *addrp, u32 *pfnp)
+{
+	void *page;
+	dma_addr_t addr;
+
+	page = dma_alloc_coherent(&pt1->pdev->dev, PT1_PAGE_SIZE, &addr,
+				  GFP_KERNEL);
+	if (page == NULL)
+		return NULL;
+
+	BUG_ON(addr & (PT1_PAGE_SIZE - 1));
+	BUG_ON(addr >> PT1_PAGE_SHIFT >> 31 >> 1);
+
+	*addrp = addr;
+	*pfnp = addr >> PT1_PAGE_SHIFT;
+	return page;
+}
+
+static void pt1_cleanup_buffer(struct pt1 *pt1, struct pt1_buffer *buf)
+{
+	pt1_free_page(pt1, buf->page, buf->addr);
+}
+
+static int
+pt1_init_buffer(struct pt1 *pt1, struct pt1_buffer *buf,  u32 *pfnp)
+{
+	struct pt1_buffer_page *page;
+	dma_addr_t addr;
+
+	page = pt1_alloc_page(pt1, &addr, pfnp);
+	if (page == NULL)
+		return -ENOMEM;
+
+	page->upackets[PT1_NR_UPACKETS - 1] = 0;
+
+	buf->page = page;
+	buf->addr = addr;
+	return 0;
+}
+
+static void pt1_cleanup_table(struct pt1 *pt1, struct pt1_table *table)
+{
+	int i;
+
+	for (i = 0; i < PT1_NR_BUFS; i++)
+		pt1_cleanup_buffer(pt1, &table->bufs[i]);
+
+	pt1_free_page(pt1, table->page, table->addr);
+}
+
+static int
+pt1_init_table(struct pt1 *pt1, struct pt1_table *table, u32 *pfnp)
+{
+	struct pt1_table_page *page;
+	dma_addr_t addr;
+	int i, ret;
+	u32 buf_pfn;
+
+	page = pt1_alloc_page(pt1, &addr, pfnp);
+	if (page == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < PT1_NR_BUFS; i++) {
+		ret = pt1_init_buffer(pt1, &table->bufs[i], &buf_pfn);
+		if (ret < 0)
+			goto err;
+
+		page->buf_pfns[i] = cpu_to_le32(buf_pfn);
+	}
+
+	pt1_increment_table_count(pt1);
+	table->page = page;
+	table->addr = addr;
+	return 0;
+
+err:
+	while (i--)
+		pt1_cleanup_buffer(pt1, &table->bufs[i]);
+
+	pt1_free_page(pt1, page, addr);
+	return ret;
+}
+
+static void pt1_cleanup_tables(struct pt1 *pt1)
+{
+	struct pt1_table *tables;
+	int i;
+
+	tables = pt1->tables;
+	pt1_unregister_tables(pt1);
+
+	for (i = 0; i < pt1_nr_tables; i++)
+		pt1_cleanup_table(pt1, &tables[i]);
+
+	vfree(tables);
+}
+
+static int pt1_init_tables(struct pt1 *pt1)
+{
+	struct pt1_table *tables;
+	int i, ret;
+	u32 first_pfn, pfn;
+
+	tables = vmalloc(sizeof(struct pt1_table) * pt1_nr_tables);
+	if (tables == NULL)
+		return -ENOMEM;
+
+	pt1_init_table_count(pt1);
+
+	i = 0;
+	if (pt1_nr_tables) {
+		ret = pt1_init_table(pt1, &tables[0], &first_pfn);
+		if (ret)
+			goto err;
+		i++;
+	}
+
+	while (i < pt1_nr_tables) {
+		ret = pt1_init_table(pt1, &tables[i], &pfn);
+		if (ret)
+			goto err;
+		tables[i - 1].page->next_pfn = cpu_to_le32(pfn);
+		i++;
+	}
+
+	tables[pt1_nr_tables - 1].page->next_pfn = cpu_to_le32(first_pfn);
+
+	pt1_register_tables(pt1, first_pfn);
+	pt1->tables = tables;
+	return 0;
+
+err:
+	while (i--)
+		pt1_cleanup_table(pt1, &tables[i]);
+
+	vfree(tables);
+	return ret;
+}
+
+static int pt1_start_feed(struct dvb_demux_feed *feed)
+{
+	struct pt1_adapter *adap;
+	adap = container_of(feed->demux, struct pt1_adapter, demux);
+	if (!adap->users++)
+		pt1_set_stream(adap->pt1, adap->index, 1);
+	return 0;
+}
+
+static int pt1_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt1_adapter *adap;
+	adap = container_of(feed->demux, struct pt1_adapter, demux);
+	if (!--adap->users)
+		pt1_set_stream(adap->pt1, adap->index, 0);
+	return 0;
+}
+
+static void
+pt1_set_power(struct pt1 *pt1, int power, int lnb, int reset)
+{
+	pt1_write_reg(pt1, 1, power | lnb << 1 | !reset << 3);
+}
+
+static int pt1_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct pt1_adapter *adap;
+	int lnb;
+
+	adap = container_of(fe->dvb, struct pt1_adapter, adap);
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13: /* actually 11V */
+		lnb = 2;
+		break;
+	case SEC_VOLTAGE_18: /* actually 15V */
+		lnb = 3;
+		break;
+	case SEC_VOLTAGE_OFF:
+		lnb = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pt1_set_power(adap->pt1, 1, lnb, 0);
+
+	if (adap->orig_set_voltage)
+		return adap->orig_set_voltage(fe, voltage);
+	else
+		return 0;
+}
+
+static void pt1_free_adapter(struct pt1_adapter *adap)
+{
+	dvb_unregister_frontend(adap->fe);
+	dvb_net_release(&adap->net);
+	adap->demux.dmx.close(&adap->demux.dmx);
+	dvb_dmxdev_release(&adap->dmxdev);
+	dvb_dmx_release(&adap->demux);
+	dvb_unregister_adapter(&adap->adap);
+	free_page((unsigned long)adap->buf);
+	kfree(adap);
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static struct pt1_adapter *
+pt1_alloc_adapter(struct pt1 *pt1, struct dvb_frontend *fe)
+{
+	struct pt1_adapter *adap;
+	void *buf;
+	struct dvb_adapter *dvb_adap;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	int ret;
+
+	adap = kzalloc(sizeof(struct pt1_adapter), GFP_KERNEL);
+	if (!adap) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	adap->pt1 = pt1;
+
+	adap->orig_set_voltage = fe->ops.set_voltage;
+	fe->ops.set_voltage = pt1_set_voltage;
+
+	buf = (u8 *)__get_free_page(GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+
+	adap->buf = buf;
+	adap->upacket_count = 0;
+	adap->packet_count = 0;
+
+	dvb_adap = &adap->adap;
+	dvb_adap->priv = adap;
+	ret = dvb_register_adapter(dvb_adap, DRIVER_NAME, THIS_MODULE,
+				   &pt1->pdev->dev, adapter_nr);
+	if (ret < 0)
+		goto err_free_page;
+
+	demux = &adap->demux;
+	demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+	demux->priv = adap;
+	demux->feednum = 256;
+	demux->filternum = 256;
+	demux->start_feed = pt1_start_feed;
+	demux->stop_feed = pt1_stop_feed;
+	demux->write_to_decoder = NULL;
+	ret = dvb_dmx_init(demux);
+	if (ret < 0)
+		goto err_unregister_adapter;
+
+	dmxdev = &adap->dmxdev;
+	dmxdev->filternum = 256;
+	dmxdev->demux = &demux->dmx;
+	dmxdev->capabilities = 0;
+	ret = dvb_dmxdev_init(dmxdev, dvb_adap);
+	if (ret < 0)
+		goto err_dmx_release;
+
+	dvb_net_init(dvb_adap, &adap->net, &demux->dmx);
+
+	ret = dvb_register_frontend(dvb_adap, fe);
+	if (ret < 0)
+		goto err_net_release;
+	adap->fe = fe;
+
+	return adap;
+
+err_net_release:
+	dvb_net_release(&adap->net);
+	adap->demux.dmx.close(&adap->demux.dmx);
+	dvb_dmxdev_release(&adap->dmxdev);
+err_dmx_release:
+	dvb_dmx_release(demux);
+err_unregister_adapter:
+	dvb_unregister_adapter(dvb_adap);
+err_free_page:
+	free_page((unsigned long)buf);
+err_kfree:
+	kfree(adap);
+err:
+	return ERR_PTR(ret);
+}
+
+static void pt1_cleanup_adapters(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < PT1_NR_ADAPS; i++)
+		pt1_free_adapter(pt1->adaps[i]);
+}
+
+struct pt1_config {
+	struct va1j5jf8007s_config va1j5jf8007s_config;
+	struct va1j5jf8007t_config va1j5jf8007t_config;
+};
+
+static const struct pt1_config pt1_configs[2] = {
+	{
+		{ .demod_address = 0x1b },
+		{ .demod_address = 0x1a },
+	}, {
+		{ .demod_address = 0x19 },
+		{ .demod_address = 0x18 },
+	},
+};
+
+static int pt1_init_adapters(struct pt1 *pt1)
+{
+	int i, j;
+	struct i2c_adapter *i2c_adap;
+	const struct pt1_config *config;
+	struct dvb_frontend *fe[4];
+	struct pt1_adapter *adap;
+	int ret;
+
+	i = 0;
+	j = 0;
+
+	i2c_adap = &pt1->i2c_adap;
+	do {
+		config = &pt1_configs[i / 2];
+
+		fe[i] = va1j5jf8007s_attach(&config->va1j5jf8007s_config,
+					    i2c_adap);
+		if (!fe[i]) {
+			ret = -ENODEV; /* This does not sound nice... */
+			goto err;
+		}
+		i++;
+
+		fe[i] = va1j5jf8007t_attach(&config->va1j5jf8007t_config,
+					    i2c_adap);
+		if (!fe[i]) {
+			ret = -ENODEV;
+			goto err;
+		}
+		i++;
+
+		ret = va1j5jf8007s_prepare(fe[i - 2]);
+		if (ret < 0)
+			goto err;
+
+		ret = va1j5jf8007t_prepare(fe[i - 1]);
+		if (ret < 0)
+			goto err;
+
+	} while (i < 4);
+
+	do {
+		adap = pt1_alloc_adapter(pt1, fe[j]);
+		if (IS_ERR(adap))
+			goto err;
+		adap->index = j;
+		pt1->adaps[j] = adap;
+	} while (++j < 4);
+
+	return 0;
+
+err:
+	while (i-- > j)
+		fe[i]->ops.release(fe[i]);
+
+	while (j--)
+		pt1_free_adapter(pt1->adaps[j]);
+
+	return ret;
+}
+
+static void pt1_i2c_emit(struct pt1 *pt1, int addr, int busy, int read_enable,
+			 int clock, int data, int next_addr)
+{
+	pt1_write_reg(pt1, 4, addr << 18 | busy << 13 | read_enable << 12 |
+		      !clock << 11 | !data << 10 | next_addr);
+}
+
+static void pt1_i2c_write_bit(struct pt1 *pt1, int addr, int *addrp, int data)
+{
+	pt1_i2c_emit(pt1, addr,     1, 0, 0, data, addr + 1);
+	pt1_i2c_emit(pt1, addr + 1, 1, 0, 1, data, addr + 2);
+	pt1_i2c_emit(pt1, addr + 2, 1, 0, 0, data, addr + 3);
+	*addrp = addr + 3;
+}
+
+static void pt1_i2c_read_bit(struct pt1 *pt1, int addr, int *addrp)
+{
+	pt1_i2c_emit(pt1, addr,     1, 0, 0, 1, addr + 1);
+	pt1_i2c_emit(pt1, addr + 1, 1, 0, 1, 1, addr + 2);
+	pt1_i2c_emit(pt1, addr + 2, 1, 1, 1, 1, addr + 3);
+	pt1_i2c_emit(pt1, addr + 3, 1, 0, 0, 1, addr + 4);
+	*addrp = addr + 4;
+}
+
+static void pt1_i2c_write_byte(struct pt1 *pt1, int addr, int *addrp, int data)
+{
+	int i;
+	for (i = 0; i < 8; i++)
+		pt1_i2c_write_bit(pt1, addr, &addr, data >> (7 - i) & 1);
+	pt1_i2c_write_bit(pt1, addr, &addr, 1);
+	*addrp = addr;
+}
+
+static void pt1_i2c_read_byte(struct pt1 *pt1, int addr, int *addrp, int last)
+{
+	int i;
+	for (i = 0; i < 8; i++)
+		pt1_i2c_read_bit(pt1, addr, &addr);
+	pt1_i2c_write_bit(pt1, addr, &addr, last);
+	*addrp = addr;
+}
+
+static void pt1_i2c_prepare(struct pt1 *pt1, int addr, int *addrp)
+{
+	pt1_i2c_emit(pt1, addr,     1, 0, 1, 1, addr + 1);
+	pt1_i2c_emit(pt1, addr + 1, 1, 0, 1, 0, addr + 2);
+	pt1_i2c_emit(pt1, addr + 2, 1, 0, 0, 0, addr + 3);
+	*addrp = addr + 3;
+}
+
+static void
+pt1_i2c_write_msg(struct pt1 *pt1, int addr, int *addrp, struct i2c_msg *msg)
+{
+	int i;
+	pt1_i2c_prepare(pt1, addr, &addr);
+	pt1_i2c_write_byte(pt1, addr, &addr, msg->addr << 1);
+	for (i = 0; i < msg->len; i++)
+		pt1_i2c_write_byte(pt1, addr, &addr, msg->buf[i]);
+	*addrp = addr;
+}
+
+static void
+pt1_i2c_read_msg(struct pt1 *pt1, int addr, int *addrp, struct i2c_msg *msg)
+{
+	int i;
+	pt1_i2c_prepare(pt1, addr, &addr);
+	pt1_i2c_write_byte(pt1, addr, &addr, msg->addr << 1 | 1);
+	for (i = 0; i < msg->len; i++)
+		pt1_i2c_read_byte(pt1, addr, &addr, i == msg->len - 1);
+	*addrp = addr;
+}
+
+static int pt1_i2c_end(struct pt1 *pt1, int addr)
+{
+	pt1_i2c_emit(pt1, addr,     1, 0, 0, 0, addr + 1);
+	pt1_i2c_emit(pt1, addr + 1, 1, 0, 1, 0, addr + 2);
+	pt1_i2c_emit(pt1, addr + 2, 1, 0, 1, 1, 0);
+
+	pt1_write_reg(pt1, 0, 0x00000004);
+	do {
+		if (signal_pending(current))
+			return -EINTR;
+		schedule_timeout_interruptible((HZ + 999) / 1000);
+	} while (pt1_read_reg(pt1, 0) & 0x00000080);
+	return 0;
+}
+
+static void pt1_i2c_begin(struct pt1 *pt1, int *addrp)
+{
+	int addr;
+	addr = 0;
+
+	pt1_i2c_emit(pt1, addr,     0, 0, 1, 1, addr /* itself */);
+	addr = addr + 1;
+
+	if (!pt1->i2c_running) {
+		pt1_i2c_emit(pt1, addr,     1, 0, 1, 1, addr + 1);
+		pt1_i2c_emit(pt1, addr + 1, 1, 0, 1, 0, addr + 2);
+		addr = addr + 2;
+		pt1->i2c_running = 1;
+	}
+	*addrp = addr;
+}
+
+static int pt1_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct pt1 *pt1;
+	int i;
+	struct i2c_msg *msg, *next_msg;
+	int addr, ret;
+	u16 len;
+	u32 word;
+
+	pt1 = i2c_get_adapdata(adap);
+
+	for (i = 0; i < num; i++) {
+		msg = &msgs[i];
+		if (msg->flags & I2C_M_RD)
+			return -ENOTSUPP;
+
+		if (i + 1 < num)
+			next_msg = &msgs[i + 1];
+		else
+			next_msg = NULL;
+
+		if (next_msg && next_msg->flags & I2C_M_RD) {
+			i++;
+
+			len = next_msg->len;
+			if (len > 4)
+				return -ENOTSUPP;
+
+			pt1_i2c_begin(pt1, &addr);
+			pt1_i2c_write_msg(pt1, addr, &addr, msg);
+			pt1_i2c_read_msg(pt1, addr, &addr, next_msg);
+			ret = pt1_i2c_end(pt1, addr);
+			if (ret < 0)
+				return ret;
+
+			word = pt1_read_reg(pt1, 2);
+			while (len--) {
+				next_msg->buf[len] = word;
+				word >>= 8;
+			}
+		} else {
+			pt1_i2c_begin(pt1, &addr);
+			pt1_i2c_write_msg(pt1, addr, &addr, msg);
+			ret = pt1_i2c_end(pt1, addr);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return num;
+}
+
+static u32 pt1_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm pt1_i2c_algo = {
+	.master_xfer = pt1_i2c_xfer,
+	.functionality = pt1_i2c_func,
+};
+
+static void pt1_i2c_wait(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < 128; i++)
+		pt1_i2c_emit(pt1, 0, 0, 0, 1, 1, 0);
+}
+
+static void pt1_i2c_init(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < 1024; i++)
+		pt1_i2c_emit(pt1, i, 0, 0, 1, 1, 0);
+}
+
+static void __devexit pt1_remove(struct pci_dev *pdev)
+{
+	struct pt1 *pt1;
+	void __iomem *regs;
+
+	pt1 = pci_get_drvdata(pdev);
+	regs = pt1->regs;
+
+	kthread_stop(pt1->kthread);
+	pt1_cleanup_tables(pt1);
+	pt1_cleanup_adapters(pt1);
+	pt1_disable_ram(pt1);
+	pt1_set_power(pt1, 0, 0, 1);
+	i2c_del_adapter(&pt1->i2c_adap);
+	pci_set_drvdata(pdev, NULL);
+	kfree(pt1);
+	pci_iounmap(pdev, regs);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static int __devinit
+pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int ret;
+	void __iomem *regs;
+	struct pt1 *pt1;
+	struct i2c_adapter *i2c_adap;
+	struct task_struct *kthread;
+
+	ret = pci_enable_device(pdev);
+	if (ret < 0)
+		goto err;
+
+	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (ret < 0)
+		goto err_pci_disable_device;
+
+	pci_set_master(pdev);
+
+	ret = pci_request_regions(pdev, DRIVER_NAME);
+	if (ret < 0)
+		goto err_pci_disable_device;
+
+	regs = pci_iomap(pdev, 0, 0);
+	if (!regs) {
+		ret = -EIO;
+		goto err_pci_release_regions;
+	}
+
+	pt1 = kzalloc(sizeof(struct pt1), GFP_KERNEL);
+	if (!pt1) {
+		ret = -ENOMEM;
+		goto err_pci_iounmap;
+	}
+
+	pt1->pdev = pdev;
+	pt1->regs = regs;
+	pci_set_drvdata(pdev, pt1);
+
+	i2c_adap = &pt1->i2c_adap;
+	i2c_adap->class = I2C_CLASS_TV_DIGITAL;
+	i2c_adap->algo = &pt1_i2c_algo;
+	i2c_adap->algo_data = NULL;
+	i2c_adap->dev.parent = &pdev->dev;
+	i2c_set_adapdata(i2c_adap, pt1);
+	ret = i2c_add_adapter(i2c_adap);
+	if (ret < 0)
+		goto err_kfree;
+
+	pt1_set_power(pt1, 0, 0, 1);
+
+	pt1_i2c_init(pt1);
+	pt1_i2c_wait(pt1);
+
+	ret = pt1_sync(pt1);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
+	pt1_identify(pt1);
+
+	ret = pt1_unlock(pt1);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
+	ret = pt1_reset_pci(pt1);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
+	ret = pt1_reset_ram(pt1);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
+	ret = pt1_enable_ram(pt1);
+	if (ret < 0)
+		goto err_i2c_del_adapter;
+
+	pt1_init_streams(pt1);
+
+	pt1_set_power(pt1, 1, 0, 1);
+	schedule_timeout_uninterruptible((HZ + 49) / 50);
+
+	pt1_set_power(pt1, 1, 0, 0);
+	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+
+	ret = pt1_init_adapters(pt1);
+	if (ret < 0)
+		goto err_pt1_disable_ram;
+
+	ret = pt1_init_tables(pt1);
+	if (ret < 0)
+		goto err_pt1_cleanup_adapters;
+
+	kthread = kthread_run(pt1_thread, pt1, "pt1");
+	if (IS_ERR(kthread)) {
+		ret = PTR_ERR(kthread);
+		goto err_pt1_cleanup_tables;
+	}
+
+	pt1->kthread = kthread;
+	return 0;
+
+err_pt1_cleanup_tables:
+	pt1_cleanup_tables(pt1);
+err_pt1_cleanup_adapters:
+	pt1_cleanup_adapters(pt1);
+err_pt1_disable_ram:
+	pt1_disable_ram(pt1);
+	pt1_set_power(pt1, 0, 0, 1);
+err_i2c_del_adapter:
+	i2c_del_adapter(i2c_adap);
+err_kfree:
+	pci_set_drvdata(pdev, NULL);
+	kfree(pt1);
+err_pci_iounmap:
+	pci_iounmap(pdev, regs);
+err_pci_release_regions:
+	pci_release_regions(pdev);
+err_pci_disable_device:
+	pci_disable_device(pdev);
+err:
+	return ret;
+
+}
+
+static struct pci_device_id pt1_id_table[] = {
+	{ PCI_DEVICE(0x10ee, 0x211a) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt1_id_table);
+
+static struct pci_driver pt1_driver = {
+	.name		= DRIVER_NAME,
+	.probe		= pt1_probe,
+	.remove		= __devexit_p(pt1_remove),
+	.id_table	= pt1_id_table,
+};
+
+
+static int __init pt1_init(void)
+{
+	return pci_register_driver(&pt1_driver);
+}
+
+
+static void __exit pt1_cleanup(void)
+{
+	pci_unregister_driver(&pt1_driver);
+}
+
+module_init(pt1_init);
+module_exit(pt1_cleanup);
+
+MODULE_AUTHOR("Takahito HIRANO <hiranotaka@zng.info>");
+MODULE_DESCRIPTION("Earthsoft PT1 Driver");
+MODULE_LICENSE("GPL");
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/va1j5jf8007s.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007s.c	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,658 @@
+/*
+ * ISDB-S driver for VA1J5JF8007
+ *
+ * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
+ *
+ * based on pt1dvr - http://pt1dvr.sourceforge.jp/
+ * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+#include "va1j5jf8007s.h"
+
+enum va1j5jf8007s_tune_state {
+	VA1J5JF8007S_IDLE,
+	VA1J5JF8007S_SET_FREQUENCY_1,
+	VA1J5JF8007S_SET_FREQUENCY_2,
+	VA1J5JF8007S_SET_FREQUENCY_3,
+	VA1J5JF8007S_CHECK_FREQUENCY,
+	VA1J5JF8007S_SET_MODULATION,
+	VA1J5JF8007S_CHECK_MODULATION,
+	VA1J5JF8007S_SET_TS_ID,
+	VA1J5JF8007S_CHECK_TS_ID,
+	VA1J5JF8007S_TRACK,
+};
+
+struct va1j5jf8007s_state {
+	const struct va1j5jf8007s_config *config;
+	struct i2c_adapter *adap;
+	struct dvb_frontend fe;
+	enum va1j5jf8007s_tune_state tune_state;
+};
+
+static int va1j5jf8007s_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static int
+va1j5jf8007s_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct va1j5jf8007s_state *state;
+
+	state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case VA1J5JF8007S_IDLE:
+	case VA1J5JF8007S_SET_FREQUENCY_1:
+	case VA1J5JF8007S_SET_FREQUENCY_2:
+	case VA1J5JF8007S_SET_FREQUENCY_3:
+	case VA1J5JF8007S_CHECK_FREQUENCY:
+		*status = 0;
+		return 0;
+
+
+	case VA1J5JF8007S_SET_MODULATION:
+	case VA1J5JF8007S_CHECK_MODULATION:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007S_SET_TS_ID:
+	case VA1J5JF8007S_CHECK_TS_ID:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case VA1J5JF8007S_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+
+	BUG();
+}
+
+struct va1j5jf8007s_cb_map {
+	u32 frequency;
+	u8 cb;
+};
+
+static const struct va1j5jf8007s_cb_map va1j5jf8007s_cb_maps[] = {
+	{  986000, 0xb2 },
+	{ 1072000, 0xd2 },
+	{ 1154000, 0xe2 },
+	{ 1291000, 0x20 },
+	{ 1447000, 0x40 },
+	{ 1615000, 0x60 },
+	{ 1791000, 0x80 },
+	{ 1972000, 0xa0 },
+};
+
+static u8 va1j5jf8007s_lookup_cb(u32 frequency)
+{
+	int i;
+	const struct va1j5jf8007s_cb_map *map;
+
+	for (i = 0; i < ARRAY_SIZE(va1j5jf8007s_cb_maps); i++) {
+		map = &va1j5jf8007s_cb_maps[i];
+		if (frequency < map->frequency)
+			return map->cb;
+	}
+	return 0xc0;
+}
+
+static int va1j5jf8007s_set_frequency_1(struct va1j5jf8007s_state *state)
+{
+	u32 frequency;
+	u16 word;
+	u8 buf[6];
+	struct i2c_msg msg;
+
+	frequency = state->fe.dtv_property_cache.frequency;
+
+	word = (frequency + 500) / 1000;
+	if (frequency < 1072000)
+		word = (word << 1 & ~0x1f) | (word & 0x0f);
+
+	buf[0] = 0xfe;
+	buf[1] = 0xc0;
+	buf[2] = 0x40 | word >> 8;
+	buf[3] = word;
+	buf[4] = 0xe0;
+	buf[5] = va1j5jf8007s_lookup_cb(frequency);
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007s_set_frequency_2(struct va1j5jf8007s_state *state)
+{
+	u8 buf[3];
+	struct i2c_msg msg;
+
+	buf[0] = 0xfe;
+	buf[1] = 0xc0;
+	buf[2] = 0xe4;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007s_set_frequency_3(struct va1j5jf8007s_state *state)
+{
+	u32 frequency;
+	u8 buf[4];
+	struct i2c_msg msg;
+
+	frequency = state->fe.dtv_property_cache.frequency;
+
+	buf[0] = 0xfe;
+	buf[1] = 0xc0;
+	buf[2] = 0xf4;
+	buf[3] = va1j5jf8007s_lookup_cb(frequency) | 0x4;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int
+va1j5jf8007s_check_frequency(struct va1j5jf8007s_state *state, int *lock)
+{
+	u8 addr;
+	u8 write_buf[2], read_buf[1];
+	struct i2c_msg msgs[2];
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0xfe;
+	write_buf[1] = 0xc1;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	*lock = read_buf[0] & 0x40;
+	return 0;
+}
+
+static int va1j5jf8007s_set_modulation(struct va1j5jf8007s_state *state)
+{
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	buf[0] = 0x03;
+	buf[1] = 0x01;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int
+va1j5jf8007s_check_modulation(struct va1j5jf8007s_state *state, int *lock)
+{
+	u8 addr;
+	u8 write_buf[1], read_buf[1];
+	struct i2c_msg msgs[2];
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0xc3;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	*lock = !(read_buf[0] & 0x10);
+	return 0;
+}
+
+static int
+va1j5jf8007s_set_ts_id(struct va1j5jf8007s_state *state)
+{
+	u32 ts_id;
+	u8 buf[3];
+	struct i2c_msg msg;
+
+	ts_id = state->fe.dtv_property_cache.isdb_ts_id;
+	if (!ts_id)
+		return 0;
+
+	buf[0] = 0x8f;
+	buf[1] = ts_id >> 8;
+	buf[2] = ts_id;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int
+va1j5jf8007s_check_ts_id(struct va1j5jf8007s_state *state, int *lock)
+{
+	u8 addr;
+	u8 write_buf[1], read_buf[2];
+	struct i2c_msg msgs[2];
+	u32 ts_id;
+
+	ts_id = state->fe.dtv_property_cache.isdb_ts_id;
+	if (!ts_id) {
+		*lock = 1;
+		return 0;
+	}
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0xe6;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	*lock = (read_buf[0] << 8 | read_buf[1]) == ts_id;
+	return 0;
+}
+
+static int
+va1j5jf8007s_tune(struct dvb_frontend *fe,
+		  struct dvb_frontend_parameters *params,
+		  unsigned int mode_flags,  unsigned int *delay,
+		  fe_status_t *status)
+{
+	struct va1j5jf8007s_state *state;
+	int ret;
+	int lock;
+
+	state = fe->demodulator_priv;
+
+	if (params != NULL)
+		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_1;
+
+	switch (state->tune_state) {
+	case VA1J5JF8007S_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007S_SET_FREQUENCY_1:
+		ret = va1j5jf8007s_set_frequency_1(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_2;
+		*delay = 0;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007S_SET_FREQUENCY_2:
+		ret = va1j5jf8007s_set_frequency_2(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_3;
+		*delay = (HZ + 99) / 100;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007S_SET_FREQUENCY_3:
+		ret = va1j5jf8007s_set_frequency_3(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007S_CHECK_FREQUENCY;
+		*delay = 0;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007S_CHECK_FREQUENCY:
+		ret = va1j5jf8007s_check_frequency(state, &lock);
+		if (ret < 0)
+			return ret;
+
+		if (!lock)  {
+			*delay = (HZ + 999) / 1000;
+			*status = 0;
+			return 0;
+		}
+
+		state->tune_state = VA1J5JF8007S_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007S_SET_MODULATION:
+		ret = va1j5jf8007s_set_modulation(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007S_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007S_CHECK_MODULATION:
+		ret = va1j5jf8007s_check_modulation(state, &lock);
+		if (ret < 0)
+			return ret;
+
+		if (!lock)  {
+			*delay = (HZ + 49) / 50;
+			*status = FE_HAS_SIGNAL;
+			return 0;
+		}
+
+		state->tune_state = VA1J5JF8007S_SET_TS_ID;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case VA1J5JF8007S_SET_TS_ID:
+		ret = va1j5jf8007s_set_ts_id(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007S_CHECK_TS_ID;
+		return 0;
+
+	case VA1J5JF8007S_CHECK_TS_ID:
+		ret = va1j5jf8007s_check_ts_id(state, &lock);
+		if (ret < 0)
+			return ret;
+
+		if (!lock)  {
+			*delay = (HZ + 99) / 100;
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+			return 0;
+		}
+
+		state->tune_state = VA1J5JF8007S_TRACK;
+		/* fall through */
+
+	case VA1J5JF8007S_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+
+	BUG();
+}
+
+static int va1j5jf8007s_init_frequency(struct va1j5jf8007s_state *state)
+{
+	u8 buf[4];
+	struct i2c_msg msg;
+
+	buf[0] = 0xfe;
+	buf[1] = 0xc0;
+	buf[2] = 0xf0;
+	buf[3] = 0x04;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007s_set_sleep(struct va1j5jf8007s_state *state, int sleep)
+{
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	buf[0] = 0x17;
+	buf[1] = sleep ? 0x01 : 0x00;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007s_sleep(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007s_state *state;
+	int ret;
+
+	state = fe->demodulator_priv;
+
+	ret = va1j5jf8007s_init_frequency(state);
+	if (ret < 0)
+		return ret;
+
+	return va1j5jf8007s_set_sleep(state, 1);
+}
+
+static int va1j5jf8007s_init(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007s_state *state;
+
+	state = fe->demodulator_priv;
+	state->tune_state = VA1J5JF8007S_IDLE;
+
+	return va1j5jf8007s_set_sleep(state, 0);
+}
+
+static void va1j5jf8007s_release(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007s_state *state;
+	state = fe->demodulator_priv;
+	kfree(state);
+}
+
+static struct dvb_frontend_ops va1j5jf8007s_ops = {
+	.info = {
+		.name = "VA1J5JF8007 ISDB-S",
+		.type = FE_QPSK,
+		.frequency_min = 950000,
+		.frequency_max = 2150000,
+		.frequency_stepsize = 1000,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
+			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+
+	.get_frontend_algo = va1j5jf8007s_get_frontend_algo,
+	.read_status = va1j5jf8007s_read_status,
+	.tune = va1j5jf8007s_tune,
+	.sleep = va1j5jf8007s_sleep,
+	.init = va1j5jf8007s_init,
+	.release = va1j5jf8007s_release,
+};
+
+static int va1j5jf8007s_prepare_1(struct va1j5jf8007s_state *state)
+{
+	u8 addr;
+	u8 write_buf[1], read_buf[1];
+	struct i2c_msg msgs[2];
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0x07;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	if (read_buf[0] != 0x41)
+		return -EIO;
+
+	return 0;
+}
+
+static const u8 va1j5jf8007s_prepare_bufs[][2] = {
+	{0x04, 0x02}, {0x0d, 0x55}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01},
+	{0x1c, 0x0a}, {0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0},
+	{0x52, 0x89}, {0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69},
+	{0x87, 0x04}, {0x8e, 0x02}, {0xa3, 0xf7}, {0xa5, 0xc0},
+};
+
+static int va1j5jf8007s_prepare_2(struct va1j5jf8007s_state *state)
+{
+	u8 addr;
+	u8 buf[2];
+	struct i2c_msg msg;
+	int i;
+
+	addr = state->config->demod_address;
+
+	msg.addr = addr;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = buf;
+	for (i = 0; i < ARRAY_SIZE(va1j5jf8007s_prepare_bufs); i++) {
+		memcpy(buf, va1j5jf8007s_prepare_bufs[i], sizeof(buf));
+		if (i2c_transfer(state->adap, &msg, 1) != 1)
+			return -EREMOTEIO;
+	}
+
+	return 0;
+}
+
+/* must be called after va1j5jf8007t_attach */
+int va1j5jf8007s_prepare(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007s_state *state;
+	int ret;
+
+	state = fe->demodulator_priv;
+
+	ret = va1j5jf8007s_prepare_1(state);
+	if (ret < 0)
+		return ret;
+
+	ret = va1j5jf8007s_prepare_2(state);
+	if (ret < 0)
+		return ret;
+
+	return va1j5jf8007s_init_frequency(state);
+}
+
+struct dvb_frontend *
+va1j5jf8007s_attach(const struct va1j5jf8007s_config *config,
+		    struct i2c_adapter *adap)
+{
+	struct va1j5jf8007s_state *state;
+	struct dvb_frontend *fe;
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	state = kzalloc(sizeof(struct va1j5jf8007s_state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->config = config;
+	state->adap = adap;
+
+	fe = &state->fe;
+	memcpy(&fe->ops, &va1j5jf8007s_ops, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = state;
+
+	buf[0] = 0x01;
+	buf[1] = 0x80;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1) {
+		kfree(state);
+		return NULL;
+	}
+
+	return fe;
+}
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/va1j5jf8007s.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007s.h	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,40 @@
+/*
+ * ISDB-S driver for VA1J5JF8007
+ *
+ * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
+ *
+ * based on pt1dvr - http://pt1dvr.sourceforge.jp/
+ * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef VA1J5JF8007S_H
+#define VA1J5JF8007S_H
+
+struct va1j5jf8007s_config {
+	u8 demod_address;
+};
+
+struct i2c_adapter;
+
+struct dvb_frontend *
+va1j5jf8007s_attach(const struct va1j5jf8007s_config *config,
+		    struct i2c_adapter *adap);
+
+/* must be called after va1j5jf8007t_attach */
+int va1j5jf8007s_prepare(struct dvb_frontend *fe);
+
+#endif
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/va1j5jf8007t.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007t.c	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,468 @@
+/*
+ * ISDB-T driver for VA1J5JF8007
+ *
+ * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
+ *
+ * based on pt1dvr - http://pt1dvr.sourceforge.jp/
+ * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+#include "dvb_math.h"
+#include "va1j5jf8007t.h"
+
+enum va1j5jf8007t_tune_state {
+	VA1J5JF8007T_IDLE,
+	VA1J5JF8007T_SET_FREQUENCY,
+	VA1J5JF8007T_CHECK_FREQUENCY,
+	VA1J5JF8007T_SET_MODULATION,
+	VA1J5JF8007T_CHECK_MODULATION,
+	VA1J5JF8007T_TRACK,
+	VA1J5JF8007T_ABORT,
+};
+
+struct va1j5jf8007t_state {
+	const struct va1j5jf8007t_config *config;
+	struct i2c_adapter *adap;
+	struct dvb_frontend fe;
+	enum va1j5jf8007t_tune_state tune_state;
+};
+
+static int va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static int
+va1j5jf8007t_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct va1j5jf8007t_state *state;
+
+	state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case VA1J5JF8007T_IDLE:
+	case VA1J5JF8007T_SET_FREQUENCY:
+	case VA1J5JF8007T_CHECK_FREQUENCY:
+		*status = 0;
+		return 0;
+
+
+	case VA1J5JF8007T_SET_MODULATION:
+	case VA1J5JF8007T_CHECK_MODULATION:
+	case VA1J5JF8007T_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007T_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+
+	BUG();
+}
+
+struct va1j5jf8007t_cb_map {
+	u32 frequency;
+	u8 cb;
+};
+
+static const struct va1j5jf8007t_cb_map va1j5jf8007t_cb_maps[] = {
+	{  90000000, 0x80 },
+	{ 140000000, 0x81 },
+	{ 170000000, 0xa1 },
+	{ 220000000, 0x62 },
+	{ 330000000, 0xa2 },
+	{ 402000000, 0xe2 },
+	{ 450000000, 0x64 },
+	{ 550000000, 0x84 },
+	{ 600000000, 0xa4 },
+	{ 700000000, 0xc4 },
+};
+
+static u8 va1j5jf8007t_lookup_cb(u32 frequency)
+{
+	int i;
+	const struct va1j5jf8007t_cb_map *map;
+
+	for (i = 0; i < ARRAY_SIZE(va1j5jf8007t_cb_maps); i++) {
+		map = &va1j5jf8007t_cb_maps[i];
+		if (frequency < map->frequency)
+			return map->cb;
+	}
+	return 0xe4;
+}
+
+static int va1j5jf8007t_set_frequency(struct va1j5jf8007t_state *state)
+{
+	u32 frequency;
+	u16 word;
+	u8 buf[6];
+	struct i2c_msg msg;
+
+	frequency = state->fe.dtv_property_cache.frequency;
+
+	word = (frequency + 71428) / 142857 + 399;
+	buf[0] = 0xfe;
+	buf[1] = 0xc2;
+	buf[2] = word >> 8;
+	buf[3] = word;
+	buf[4] = 0x80;
+	buf[5] = va1j5jf8007t_lookup_cb(frequency);
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int
+va1j5jf8007t_check_frequency(struct va1j5jf8007t_state *state, int *lock)
+{
+	u8 addr;
+	u8 write_buf[2], read_buf[1];
+	struct i2c_msg msgs[2];
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0xfe;
+	write_buf[1] = 0xc3;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	*lock = read_buf[0] & 0x40;
+	return 0;
+}
+
+static int va1j5jf8007t_set_modulation(struct va1j5jf8007t_state *state)
+{
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	buf[0] = 0x01;
+	buf[1] = 0x40;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007t_check_modulation(struct va1j5jf8007t_state *state,
+					 int *lock, int *retry)
+{
+	u8 addr;
+	u8 write_buf[1], read_buf[1];
+	struct i2c_msg msgs[2];
+
+	addr = state->config->demod_address;
+
+	write_buf[0] = 0x80;
+
+	msgs[0].addr = addr;
+	msgs[0].flags = 0;
+	msgs[0].len = sizeof(write_buf);
+	msgs[0].buf = write_buf;
+
+	msgs[1].addr = addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = sizeof(read_buf);
+	msgs[1].buf = read_buf;
+
+	if (i2c_transfer(state->adap, msgs, 2) != 2)
+		return -EREMOTEIO;
+
+	*lock = !(read_buf[0] & 0x10);
+	*retry = read_buf[0] & 0x80;
+	return 0;
+}
+
+static int
+va1j5jf8007t_tune(struct dvb_frontend *fe,
+		  struct dvb_frontend_parameters *params,
+		  unsigned int mode_flags,  unsigned int *delay,
+		  fe_status_t *status)
+{
+	struct va1j5jf8007t_state *state;
+	int ret;
+	int lock, retry;
+
+	state = fe->demodulator_priv;
+
+	if (params != NULL)
+		state->tune_state = VA1J5JF8007T_SET_FREQUENCY;
+
+	switch (state->tune_state) {
+	case VA1J5JF8007T_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007T_SET_FREQUENCY:
+		ret = va1j5jf8007t_set_frequency(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007T_CHECK_FREQUENCY;
+		*delay = 0;
+		*status = 0;
+		return 0;
+
+	case VA1J5JF8007T_CHECK_FREQUENCY:
+		ret = va1j5jf8007t_check_frequency(state, &lock);
+		if (ret < 0)
+			return ret;
+
+		if (!lock)  {
+			*delay = (HZ + 999) / 1000;
+			*status = 0;
+			return 0;
+		}
+
+		state->tune_state = VA1J5JF8007T_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007T_SET_MODULATION:
+		ret = va1j5jf8007t_set_modulation(state);
+		if (ret < 0)
+			return ret;
+
+		state->tune_state = VA1J5JF8007T_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case VA1J5JF8007T_CHECK_MODULATION:
+		ret = va1j5jf8007t_check_modulation(state, &lock, &retry);
+		if (ret < 0)
+			return ret;
+
+		if (!lock)  {
+			if (!retry)  {
+				state->tune_state = VA1J5JF8007T_ABORT;
+				*delay = 3 * HZ;
+				*status = FE_HAS_SIGNAL;
+				return 0;
+			}
+			*delay = (HZ + 999) / 1000;
+			*status = FE_HAS_SIGNAL;
+			return 0;
+		}
+
+		state->tune_state = VA1J5JF8007T_TRACK;
+		/* fall through */
+
+	case VA1J5JF8007T_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case VA1J5JF8007T_ABORT:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+
+	BUG();
+}
+
+static int va1j5jf8007t_init_frequency(struct va1j5jf8007t_state *state)
+{
+	u8 buf[7];
+	struct i2c_msg msg;
+
+	buf[0] = 0xfe;
+	buf[1] = 0xc2;
+	buf[2] = 0x01;
+	buf[3] = 0x8f;
+	buf[4] = 0xc1;
+	buf[5] = 0x80;
+	buf[6] = 0x80;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007t_set_sleep(struct va1j5jf8007t_state *state, int sleep)
+{
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	buf[0] = 0x03;
+	buf[1] = sleep ? 0x90 : 0x80;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int va1j5jf8007t_sleep(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007t_state *state;
+	int ret;
+
+	state = fe->demodulator_priv;
+
+	ret = va1j5jf8007t_init_frequency(state);
+	if (ret < 0)
+		return ret;
+
+	return va1j5jf8007t_set_sleep(state, 1);
+}
+
+static int va1j5jf8007t_init(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007t_state *state;
+
+	state = fe->demodulator_priv;
+	state->tune_state = VA1J5JF8007T_IDLE;
+
+	return va1j5jf8007t_set_sleep(state, 0);
+}
+
+static void va1j5jf8007t_release(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007t_state *state;
+	state = fe->demodulator_priv;
+	kfree(state);
+}
+
+static struct dvb_frontend_ops va1j5jf8007t_ops = {
+	.info = {
+		.name = "VA1J5JF8007 ISDB-T",
+		.type = FE_OFDM,
+		.frequency_min = 90000000,
+		.frequency_max = 770000000,
+		.frequency_stepsize = 142857,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
+			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+
+	.get_frontend_algo = va1j5jf8007t_get_frontend_algo,
+	.read_status = va1j5jf8007t_read_status,
+	.tune = va1j5jf8007t_tune,
+	.sleep = va1j5jf8007t_sleep,
+	.init = va1j5jf8007t_init,
+	.release = va1j5jf8007t_release,
+};
+
+static const u8 va1j5jf8007t_prepare_bufs[][2] = {
+	{0x03, 0x90}, {0x14, 0x8f}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2},
+	{0x22, 0x83}, {0x31, 0x0d}, {0x32, 0xe0}, {0x39, 0xd3}, {0x3a, 0x00},
+	{0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x02}, {0x76, 0x4e}, {0x77, 0x03},
+	{0xef, 0x01}
+};
+
+int va1j5jf8007t_prepare(struct dvb_frontend *fe)
+{
+	struct va1j5jf8007t_state *state;
+	u8 buf[2];
+	struct i2c_msg msg;
+	int i;
+
+	state = fe->demodulator_priv;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	for (i = 0; i < ARRAY_SIZE(va1j5jf8007t_prepare_bufs); i++) {
+		memcpy(buf, va1j5jf8007t_prepare_bufs[i], sizeof(buf));
+		if (i2c_transfer(state->adap, &msg, 1) != 1)
+			return -EREMOTEIO;
+	}
+
+	return va1j5jf8007t_init_frequency(state);
+}
+
+struct dvb_frontend *
+va1j5jf8007t_attach(const struct va1j5jf8007t_config *config,
+		    struct i2c_adapter *adap)
+{
+	struct va1j5jf8007t_state *state;
+	struct dvb_frontend *fe;
+	u8 buf[2];
+	struct i2c_msg msg;
+
+	state = kzalloc(sizeof(struct va1j5jf8007t_state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->config = config;
+	state->adap = adap;
+
+	fe = &state->fe;
+	memcpy(&fe->ops, &va1j5jf8007t_ops, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = state;
+
+	buf[0] = 0x01;
+	buf[1] = 0x80;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.len = sizeof(buf);
+	msg.buf = buf;
+
+	if (i2c_transfer(state->adap, &msg, 1) != 1) {
+		kfree(state);
+		return NULL;
+	}
+
+	return fe;
+}
diff -r bc34617eca49 -r eb11a965cbb6 linux/drivers/media/dvb/pt1/va1j5jf8007t.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007t.h	Sun Aug 23 12:29:31 2009 +0900
@@ -0,0 +1,40 @@
+/*
+ * ISDB-T driver for VA1J5JF8007
+ *
+ * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
+ *
+ * based on pt1dvr - http://pt1dvr.sourceforge.jp/
+ * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef VA1J5JF8007T_H
+#define VA1J5JF8007T_H
+
+struct va1j5jf8007t_config {
+	u8 demod_address;
+};
+
+struct i2c_adapter;
+
+struct dvb_frontend *
+va1j5jf8007t_attach(const struct va1j5jf8007t_config *config,
+		    struct i2c_adapter *adap);
+
+/* must be called after va1j5jf8007s_attach */
+int va1j5jf8007t_prepare(struct dvb_frontend *fe);
+
+#endif
