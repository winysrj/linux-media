Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35148 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbcBOUHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 15:07:36 -0500
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD?=
	 =?UTF-8?q?=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>,
	linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 7/7] PCI bridge driver for PT3 & PXQ3PE
Date: Tue, 16 Feb 2016 05:07:32 +0900
Message-Id: <5e75079f8651e67460c88ee9cbc0e2640fdca994.1455566804.git.knightrider@are.ma>
In-Reply-To: <cover.1455566803.git.knightrider@are.ma>
References: <cover.1455566803.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/Kconfig          |   2 +-
 drivers/media/pci/Makefile         |   2 +-
 drivers/media/pci/ptx/Kconfig      |  21 ++
 drivers/media/pci/ptx/Makefile     |   8 +
 drivers/media/pci/ptx/pt3_pci.c    | 509 +++++++++++++++++++++++++++++++
 drivers/media/pci/ptx/ptx_common.c | 215 +++++++++++++
 drivers/media/pci/ptx/ptx_common.h |  73 +++++
 drivers/media/pci/ptx/pxq3pe_pci.c | 605 +++++++++++++++++++++++++++++++++++++
 8 files changed, 1433 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/pci/ptx/Kconfig
 create mode 100644 drivers/media/pci/ptx/Makefile
 create mode 100644 drivers/media/pci/ptx/pt3_pci.c
 create mode 100644 drivers/media/pci/ptx/ptx_common.c
 create mode 100644 drivers/media/pci/ptx/ptx_common.h
 create mode 100644 drivers/media/pci/ptx/pxq3pe_pci.c

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 48a611b..9d63ad6 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -44,7 +44,7 @@ source "drivers/media/pci/b2c2/Kconfig"
 source "drivers/media/pci/pluto2/Kconfig"
 source "drivers/media/pci/dm1105/Kconfig"
 source "drivers/media/pci/pt1/Kconfig"
-source "drivers/media/pci/pt3/Kconfig"
+source "drivers/media/pci/ptx/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 5f8aacb..984e37c 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -7,7 +7,7 @@ obj-y        +=	ttpci/		\
 		pluto2/		\
 		dm1105/		\
 		pt1/		\
-		pt3/		\
+		ptx/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
diff --git a/drivers/media/pci/ptx/Kconfig b/drivers/media/pci/ptx/Kconfig
new file mode 100644
index 0000000..792acfe
--- /dev/null
+++ b/drivers/media/pci/ptx/Kconfig
@@ -0,0 +1,21 @@
+config DVB_PT3
+	tristate "Earthsoft PT3 cards"
+	depends on DVB_CORE && PCI && I2C
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for Earthsoft PT3 ISDB-S/T PCIe cards.
+
+	  Say Y or M if you own such a device and want to use it.
+
+config DVB_PXQ3PE
+	tristate "PLEX PX-Q3PE cards"
+	depends on DVB_CORE && PCI && I2C
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for PLEX PX-Q3PE ISDB-S/T PCIe cards.
+
+	  Say Y or M if you own such a device and want to use it.
diff --git a/drivers/media/pci/ptx/Makefile b/drivers/media/pci/ptx/Makefile
new file mode 100644
index 0000000..b10ad8a
--- /dev/null
+++ b/drivers/media/pci/ptx/Makefile
@@ -0,0 +1,8 @@
+pt3-objs	:= pt3_pci.o ptx_common.o
+pxq3pe-objs	:= pxq3pe_pci.o ptx_common.o
+
+obj-$(CONFIG_DVB_PT3)		+= pt3.o
+obj-$(CONFIG_DVB_PXQ3PE)	+= pxq3pe.o
+
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
+
diff --git a/drivers/media/pci/ptx/pt3_pci.c b/drivers/media/pci/ptx/pt3_pci.c
new file mode 100644
index 0000000..3af9e48
--- /dev/null
+++ b/drivers/media/pci/ptx/pt3_pci.c
@@ -0,0 +1,509 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "dvb_frontend.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
+#include "ptx_common.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
+
+static struct pci_device_id pt3_id[] = {
+	{PCI_DEVICE(0x1172, 0x4c15)},
+	{},
+};
+MODULE_DEVICE_TABLE(pci, pt3_id);
+
+enum ePT3 {
+	PT3_REG_VERSION	= 0x00,	/*	R	Version		*/
+	PT3_REG_BUS	= 0x04,	/*	R	Bus		*/
+	PT3_REG_SYS_W	= 0x08,	/*	W	System		*/
+	PT3_REG_SYS_R	= 0x0c,	/*	R	System		*/
+	PT3_REG_I2C_W	= 0x10,	/*	W	I2C		*/
+	PT3_REG_I2C_R	= 0x14,	/*	R	I2C		*/
+	PT3_REG_RAM_W	= 0x18,	/*	W	RAM		*/
+	PT3_REG_RAM_R	= 0x1c,	/*	R	RAM		*/
+	PT3_DMA_BASE	= 0x40,	/* + 0x18*idx			*/
+	PT3_DMA_OFFSET	= 0x18,
+	PT3_DMA_DESC_L	= 0x00,	/*	W	DMA descriptor	*/
+	PT3_DMA_DESC_H	= 0x04,	/*	W	DMA descriptor	*/
+	PT3_DMA_CTL	= 0x08,	/*	W	DMA		*/
+	PT3_TS_CTL	= 0x0c,	/*	W	TS		*/
+	PT3_STATUS	= 0x10,	/*	R	DMA/FIFO/TS	*/
+	PT3_TS_ERR	= 0x14,	/*	R	TS		*/
+
+	PT3_I2C_DATA_OFFSET	= 0x800,
+	PT3_I2C_START_ADDR	= 0x17fa,
+
+	PT3_PWR_OFF		= 0x00,
+	PT3_PWR_AMP_ON		= 0x04,
+	PT3_PWR_TUNER_ON	= 0x40,
+};
+
+struct pt3_card {
+	void __iomem	*bar_reg,
+			*bar_mem;
+};
+
+struct pt3_dma {
+	dma_addr_t	adr;
+	u8		*dat;
+	u32		sz,
+			pos;
+};
+
+struct pt3_adap {
+	u32	ts_pos,
+		ts_count,
+		desc_count;
+	void __iomem	*dma_base;
+	struct pt3_dma	*ts_info,
+			*desc_info;
+};
+
+int pt3_i2c_flush(struct pt3_card *c, u32 start_addr)
+{
+	u32 i2c_wait(void)
+	{
+		while (1) {
+			u32 val = readl(c->bar_reg + PT3_REG_I2C_R);
+
+			if (!(val & 1))					/* sequence stopped */
+				return val;
+			msleep_interruptible(1);
+		}
+	}
+	i2c_wait();
+	writel(1 << 16 | start_addr, c->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
+	return i2c_wait() & 0b0110 ? -EIO : 0;				/* ACK status */
+}
+
+int pt3_i2c_xfr(struct i2c_adapter *i2c, struct i2c_msg *msg, int sz)
+{
+	enum pt3_i2c_cmd {
+		I_END,
+		I_ADDRESS,
+		I_CLOCK_L,
+		I_CLOCK_H,
+		I_DATA_L,
+		I_DATA_H,
+		I_RESET,
+		I_SLEEP,
+		I_DATA_L_NOP	= 0x08,
+		I_DATA_H_NOP	= 0x0c,
+		I_DATA_H_READ	= 0x0d,
+		I_DATA_H_ACK0	= 0x0e,
+	};
+	struct ptx_card *card	= i2c_get_adapdata(i2c);
+	struct pt3_card *c	= card->priv;
+	u32	offset		= 0;
+	u8	buf;
+	bool	filled		= false;
+
+	void i2c_shoot(u8 dat)
+	{
+		if (filled) {
+			buf |= dat << 4;
+			writeb(buf, c->bar_mem + PT3_I2C_DATA_OFFSET + offset);
+			offset++;
+		} else
+			buf = dat;
+		filled ^= true;
+	}
+
+	void i2c_w(const u8 *dat, u32 size)
+	{
+		u32 i, j;
+
+		for (i = 0; i < size; i++) {
+			for (j = 0; j < 8; j++)
+				i2c_shoot((dat[i] >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
+			i2c_shoot(I_DATA_H_ACK0);
+		}
+	}
+
+	void i2c_r(u32 size)
+	{
+		u32 i, j;
+
+		for (i = 0; i < size; i++) {
+			for (j = 0; j < 8; j++)
+				i2c_shoot(I_DATA_H_READ);
+			if (i == (size - 1))
+				i2c_shoot(I_DATA_H_NOP);
+			else
+				i2c_shoot(I_DATA_L_NOP);
+		}
+	}
+	int i, j;
+
+	if (sz < 1 || sz > 3 || !msg || msg[0].flags)		/* always write first */
+		return -ENOTSUPP;
+	mutex_lock(&card->lock);
+	for (i = 0; i < sz; i++) {
+		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
+
+		/* start */
+		i2c_shoot(I_DATA_H);
+		i2c_shoot(I_CLOCK_H);
+		i2c_shoot(I_DATA_L);
+		i2c_shoot(I_CLOCK_L);
+		i2c_w(&byte, 1);
+		if (msg[i].flags == I2C_M_RD)
+			i2c_r(msg[i].len);
+		else
+			i2c_w(msg[i].buf, msg[i].len);
+	}
+
+	/* stop */
+	i2c_shoot(I_DATA_L);
+	i2c_shoot(I_CLOCK_H);
+	i2c_shoot(I_DATA_H);
+	i2c_shoot(I_END);
+	if (filled)
+		i2c_shoot(I_END);
+	if (pt3_i2c_flush(c, 0))
+		sz = -EIO;
+	else
+		for (i = 1; i < sz; i++)
+			if (msg[i].flags == I2C_M_RD)
+				for (j = 0; j < msg[i].len; j++)
+					msg[i].buf[j] = readb(c->bar_mem + PT3_I2C_DATA_OFFSET + j);
+	mutex_unlock(&card->lock);
+	return sz;
+}
+
+static const struct i2c_algorithm pt3_i2c_algo = {
+	.functionality	= ptx_i2c_func,
+	.master_xfer	= pt3_i2c_xfr,
+};
+
+void pt3_lnb(struct ptx_card *card, bool lnb)
+{
+	struct pt3_card *c = card->priv;
+
+	writel(lnb ? 0b1111 : 0b1100, c->bar_reg + PT3_REG_SYS_W);
+}
+
+int pt3_thread(void *dat)
+{
+	struct ptx_adap	*adap	= dat;
+	struct pt3_adap	*p	= adap->priv;
+	struct pt3_dma	*ts;
+	u32		i,
+			prev;
+	size_t		csize,
+			remain	= 0;
+
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while (p->ts_info[p->ts_pos].sz > remain) {
+			remain = p->ts_info[p->ts_pos].sz;
+			mutex_lock(&adap->lock);
+			while (remain > 0) {
+				for (i = 0; i < 20; i++) {
+					struct pt3_dma	*ts;
+					u32	next	= p->ts_pos + 1;
+
+					if (next >= p->ts_count)
+						next = 0;
+					ts = &p->ts_info[next];
+					if (ts->dat[ts->pos] == PTX_TS_SYNC)
+						break;
+					msleep_interruptible(30);
+				}
+				if (i == 20)
+					break;
+				prev = p->ts_pos - 1;
+				if (prev < 0 || p->ts_count <= prev)
+					prev = p->ts_count - 1;
+				ts = &p->ts_info[p->ts_pos];
+				while (remain > 0) {
+					csize = (remain < (ts->sz - ts->pos)) ?
+						 remain : (ts->sz - ts->pos);
+					dvb_dmx_swfilter_raw(&adap->demux, &ts->dat[ts->pos], csize);
+					remain -= csize;
+					ts->pos += csize;
+					if (ts->pos < ts->sz)
+						continue;
+					ts->pos = 0;
+					ts->dat[ts->pos] = PTX_TS_NOT_SYNC;
+					p->ts_pos++;
+					if (p->ts_pos >= p->ts_count)
+						p->ts_pos = 0;
+					break;
+				}
+			}
+			mutex_unlock(&adap->lock);
+		}
+		if (p->ts_info[p->ts_pos].sz < remain)
+			msleep_interruptible(1);
+	}
+	return 0;
+}
+
+void pt3_dma_run(struct ptx_adap *adap, bool ON)
+{
+	struct pt3_adap	*p		= adap->priv;
+	void __iomem	*base		= p->dma_base;
+	u64		start_addr	= p->desc_info->adr,
+			i;
+
+	if (ON) {
+		writel(1 << 18, base + PT3_TS_CTL);	/* reset error count */
+		for (i = 0; i < p->ts_count; i++) {
+			struct pt3_dma *ts = &p->ts_info[i];
+
+			memset(ts->dat, 0, ts->sz);
+			ts->pos = 0;
+			*ts->dat = PTX_TS_NOT_SYNC;
+		}
+		p->ts_pos = 0;
+		writel(1 << 1, base + PT3_DMA_CTL);	/* stop DMA */
+		writel(start_addr & 0xffffffff, base + PT3_DMA_DESC_L);
+		writel(start_addr >> 32, base + PT3_DMA_DESC_H);
+		writel(1 << 0, base + PT3_DMA_CTL);	/* start DMA */
+	} else {
+		writel(1 << 1, base + PT3_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!(readl(base + PT3_STATUS) & 1))
+				break;
+			msleep_interruptible(1);
+		}
+	}
+}
+
+int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
+
+	if (adap->kthread) {
+		pt3_dma_run(adap, false);
+		kthread_stop(adap->kthread);
+		adap->kthread = NULL;
+	}
+	return 0;
+}
+
+int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int		err	= 0;
+	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
+
+	if (!adap->kthread) {
+		adap->kthread = kthread_run(pt3_thread, adap, "%s_%d", adap->card->name, adap->fe.id);
+		if (IS_ERR(adap->kthread)) {
+			err = PTR_ERR(adap->kthread);
+			adap->kthread = NULL;
+		} else
+			pt3_dma_run(adap, true);
+	}
+	return err;
+}
+
+void pt3_dma_free(struct ptx_adap *adap)
+{
+	struct pt3_adap	*p	= adap->priv;
+	struct pt3_dma	*page;
+	u32 i;
+
+	if (p->ts_info) {
+		for (i = 0; i < p->ts_count; i++) {
+			page = &p->ts_info[i];
+			if (page->dat)
+				pci_free_consistent(adap->card->pdev, page->sz, page->dat, page->adr);
+		}
+		kfree(p->ts_info);
+	}
+	if (p->desc_info) {
+		for (i = 0; i < p->desc_count; i++) {
+			page = &p->desc_info[i];
+			if (page->dat)
+				pci_free_consistent(adap->card->pdev, page->sz, page->dat, page->adr);
+		}
+		kfree(p->desc_info);
+	}
+}
+
+int pt3_power(struct dvb_frontend *fe, u8 pwr)
+{
+	struct ptx_adap	*adap	= container_of(fe, struct ptx_adap, fe);
+	u8		buf[]	= {0x1e, pwr | 0b10011001};
+	struct i2c_msg msg[] = {
+		{.addr = fe->id,	.flags = 0,	.buf = buf,	.len = 2,},
+	};
+
+	return i2c_transfer(&adap->card->i2c, msg, 1) == 1 ? 0 : -EIO;
+}
+
+void pt3_remove(struct pci_dev *pdev)
+{
+	struct ptx_card	*card	= pci_get_drvdata(pdev);
+	struct pt3_card	*c	= card->priv;
+	struct ptx_adap *adap	= card->adap;
+	int i;
+
+	if (!card)
+		return;
+	for (i = 0; i < card->adapn; i++, adap++) {
+		pt3_dma_run(adap, false);
+		pt3_dma_free(adap);
+		ptx_sleep(&adap->fe);
+		pt3_power(&adap->fe, PT3_PWR_OFF);
+	}
+	ptx_unregister_adap_fe(card);
+	if (c->bar_reg) {
+		writel(1 << 17, c->bar_reg + PT3_REG_I2C_W);		/* i2c_reset */
+		iounmap(c->bar_reg);
+	}
+	if (c->bar_mem)
+		iounmap(c->bar_mem);
+}
+
+int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct dma_desc {
+		u64 page_addr;
+		u32 page_size;
+		u64 next_desc;
+	} __packed;
+	enum {
+		DMA_MAX_DESCS	= 204,
+		DMA_PAGE_SIZE	= DMA_MAX_DESCS * sizeof(struct dma_desc),
+		DMA_BLOCK_COUNT	= 17,
+		DMA_BLOCK_SIZE	= DMA_PAGE_SIZE * 47,
+		DMA_TS_BUF_SIZE	= DMA_BLOCK_SIZE * DMA_BLOCK_COUNT,
+	};
+	struct ptx_subdev_info	pt3_subdev_info[] = {
+		{SYS_ISDBS, 0b00010001, TC90522_MODNAME, 0x63, QM1D1C0042_MODNAME},
+		{SYS_ISDBS, 0b00010011, TC90522_MODNAME, 0x60, QM1D1C0042_MODNAME},
+		{SYS_ISDBT, 0b00010000, TC90522_MODNAME, 0x62, MXL301RF_MODNAME},
+		{SYS_ISDBT, 0b00010010, TC90522_MODNAME, 0x61, MXL301RF_MODNAME},
+	};
+	struct ptx_card	*card	= ptx_alloc(pdev, KBUILD_MODNAME, ARRAY_SIZE(pt3_subdev_info),
+					sizeof(struct pt3_card), sizeof(struct pt3_adap), pt3_lnb);
+	struct pt3_card	*c	= card->priv;
+	struct ptx_adap	*adap;
+
+	bool dma_create(void)
+	{
+		struct pt3_adap	*p		= adap->priv;
+		struct pt3_dma	*descinfo;
+		struct dma_desc	*prev		= NULL,
+				*curr;
+		u32		i,
+				j,
+				desc_remain	= 0,
+				desc_info_pos	= 0;
+		u64		desc_addr;
+
+		p->ts_count	= DMA_BLOCK_COUNT;
+		p->ts_info	= kcalloc(p->ts_count, sizeof(struct pt3_dma), GFP_KERNEL);
+		p->desc_count	= 1 + (DMA_TS_BUF_SIZE / DMA_PAGE_SIZE - 1) / DMA_MAX_DESCS;
+		p->desc_info	= kcalloc(p->desc_count, sizeof(struct pt3_dma), GFP_KERNEL);
+		if (!p->ts_info || !p->desc_info)
+			return false;
+		for (i = 0; i < p->ts_count; i++) {
+			p->ts_info[i].sz	= DMA_BLOCK_SIZE;
+			p->ts_info[i].pos	= 0;
+			p->ts_info[i].dat	= pci_alloc_consistent(adap->card->pdev, p->ts_info[i].sz, &p->ts_info[i].adr);
+			if (!p->ts_info[i].dat)
+				return false;
+		}
+		for (i = 0; i < p->desc_count; i++) {
+			p->desc_info[i].sz	= DMA_PAGE_SIZE;
+			p->desc_info[i].pos	= 0;
+			p->desc_info[i].dat	= pci_alloc_consistent(adap->card->pdev, p->desc_info[i].sz, &p->desc_info[i].adr);
+			if (!p->desc_info[i].dat)
+				return false;
+		}
+		for (i = 0; i < p->ts_count; i++)
+			for (j = 0; j < p->ts_info[i].sz / DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct dma_desc)) {
+				descinfo	= &p->desc_info[desc_info_pos];
+				descinfo->pos	= 0;
+				curr		= (struct dma_desc *)&descinfo->dat[descinfo->pos];
+				desc_addr	= descinfo->adr;
+				desc_remain	= descinfo->sz;
+				desc_info_pos++;
+			}
+			if (prev)
+				prev->next_desc = desc_addr | 0b10;
+			curr->page_addr = 0b111 | (p->ts_info[i].adr + DMA_PAGE_SIZE * j);
+			curr->page_size = 0b111 | DMA_PAGE_SIZE;
+			curr->next_desc = 0b10;
+
+			prev		= curr;
+			descinfo->pos	+= sizeof(struct dma_desc);
+			curr		= (struct dma_desc *)&descinfo->dat[descinfo->pos];
+			desc_addr	+= sizeof(struct dma_desc);
+			desc_remain	-= sizeof(struct dma_desc);
+		}
+		prev->next_desc = p->desc_info->adr | 0b10;
+		return true;
+	}
+
+	bool i2c_is_clean(void)
+	{
+		return (readl(c->bar_reg + PT3_REG_I2C_R) >> 3) & 1;
+	}
+	u8	i;
+	int	err	= !card || pci_read_config_byte(pdev, PCI_CLASS_REVISION, &i);
+
+	if (err)
+		return ptx_abort(pdev, pt3_remove, err, "PCI/DMA/memory error");
+	if (i != 1)
+		return ptx_abort(pdev, pt3_remove, -EINVAL, "Revision 0x%X is not supported", i);
+	pci_set_master(pdev);
+	c->bar_reg	= pci_ioremap_bar(pdev, 0);
+	c->bar_mem	= pci_ioremap_bar(pdev, 2);
+	if (!c->bar_reg || !c->bar_mem)
+		return ptx_abort(pdev, pt3_remove, -EIO, "Failed pci_ioremap_bar");
+	err = readl(c->bar_reg + PT3_REG_VERSION);
+	i = ((err >> 24) & 0xFF);
+	if (i != 3)
+		return ptx_abort(pdev, pt3_remove, -EIO, "ID=0x%X, not a PT3", i);
+	i = ((err >>  8) & 0xFF);
+	if (i != 4)
+		return ptx_abort(pdev, pt3_remove, -EIO, "FPGA version 0x%X is not supported", i);
+	if (ptx_i2c_add_adapter(card, &pt3_i2c_algo) || (!i2c_is_clean() && pt3_i2c_flush(c, 0)))
+		return ptx_abort(pdev, pt3_remove, err, "Cannot add I2C");
+	for (i = 0, adap = card->adap; i < card->adapn; i++, adap++) {
+		struct dvb_frontend	*fe	= &adap->fe;
+		struct pt3_adap		*p	= adap->priv;
+
+		fe->id		= pt3_subdev_info[i].demod_addr;
+		p->dma_base	= c->bar_reg + PT3_DMA_BASE + PT3_DMA_OFFSET * i;
+		if (!dma_create())
+			return ptx_abort(pdev, pt3_remove, -ENOMEM, "Failed dma_create");
+	}
+	err =	ptx_register_adap_fe(card, pt3_subdev_info, pt3_start_feed, pt3_stop_feed)	||
+		pt3_power(&card->adap[i - 1].fe, PT3_PWR_TUNER_ON)				||
+		pt3_i2c_flush(c, PT3_I2C_START_ADDR)						||
+		pt3_power(&card->adap[i - 1].fe, PT3_PWR_TUNER_ON | PT3_PWR_AMP_ON);
+	return err ? ptx_abort(pdev, pt3_remove, err, "Unable to register DVB adapter/frontend") : 0;
+}
+
+static struct pci_driver pt3_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= pt3_id,
+	.probe		= pt3_probe,
+	.remove		= pt3_remove,
+};
+module_pci_driver(pt3_driver);
+
diff --git a/drivers/media/pci/ptx/ptx_common.c b/drivers/media/pci/ptx/ptx_common.c
new file mode 100644
index 0000000..2d98d27
--- /dev/null
+++ b/drivers/media/pci/ptx/ptx_common.c
@@ -0,0 +1,215 @@
+/*
+ * Common procedures for PT3 & PX-Q3PE DVB driver
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ */
+
+#include <linux/pci.h>
+#include "dvb_frontend.h"
+#include "ptx_common.h"
+
+void ptx_lnb(struct ptx_card *card)
+{
+	int	i;
+	bool	lnb = false;
+
+	for (i = 0; i < card->adapn; i++)
+		if (card->adap[i].fe.dtv_property_cache.delivery_system == SYS_ISDBS && card->adap[i].ON) {
+			lnb = true;
+			break;
+		}
+	if (card->lnbON != lnb) {
+		card->lnb(card, lnb);
+		card->lnbON = lnb;
+	}
+}
+
+int ptx_sleep(struct dvb_frontend *fe)
+{
+	struct ptx_adap	*adap	= container_of(fe, struct ptx_adap, fe);
+
+	adap->ON = false;
+	ptx_lnb(adap->card);
+	return adap->fe_sleep ? adap->fe_sleep(fe) : 0;
+}
+
+int ptx_wakeup(struct dvb_frontend *fe)
+{
+	struct ptx_adap	*adap	= container_of(fe, struct ptx_adap, fe);
+
+	adap->ON = true;
+	ptx_lnb(adap->card);
+	return adap->fe_wakeup ? adap->fe_wakeup(fe) : 0;
+}
+
+struct ptx_card *ptx_alloc(struct pci_dev *pdev, u8 *name, u8 adapn, u32 sz_card_priv, u32 sz_adap_priv,
+			void (*lnb)(struct ptx_card *, bool))
+{
+	u8 i;
+	struct ptx_card *card = kzalloc(sizeof(struct ptx_card) + sz_card_priv + adapn *
+					(sizeof(struct ptx_adap) + sz_adap_priv), GFP_KERNEL);
+	if (!card)
+		return NULL;
+	card->priv	= sz_card_priv ? &card[1] : NULL;
+	card->adap	= (struct ptx_adap *)((u8 *)&card[1] + sz_card_priv);
+	card->pdev	= pdev;
+	card->adapn	= adapn;
+	card->name	= name;
+	card->lnbON	= true;
+	card->lnb	= lnb;
+	for (i = 0; i < card->adapn; i++) {
+		struct ptx_adap *p = &card->adap[i];
+
+		p->card	= card;
+		p->priv	= sz_adap_priv ? (u8 *)&card->adap[card->adapn] + i * sz_adap_priv : NULL;
+	}
+	if (pci_enable_device(pdev)					||
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(32))		||
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))	||
+		pci_request_regions(pdev, name)) {
+		kfree(card);
+		return NULL;
+	}
+	pci_set_drvdata(pdev, card);
+	return card;
+}
+
+int ptx_i2c_add_adapter(struct ptx_card *card, const struct i2c_algorithm *algo)
+{
+	struct i2c_adapter *i2c = &card->i2c;
+
+	i2c->algo	= algo;
+	i2c->dev.parent	= &card->pdev->dev;
+	strcpy(i2c->name, card->name);
+	i2c_set_adapdata(i2c, card);
+	mutex_init(&card->lock);
+	return	i2c_add_adapter(i2c);
+}
+
+void ptx_unregister_subdev(struct i2c_client *c)
+{
+	if (!c)
+		return;
+	if (c->dev.driver)
+		module_put(c->dev.driver->owner);
+	i2c_unregister_device(c);
+}
+
+struct i2c_client *ptx_register_subdev(struct i2c_adapter *i2c, void *dat, u16 adr, char *type)
+{
+	struct i2c_client	*c;
+	struct i2c_board_info	info = {
+		.platform_data	= dat,
+		.addr		= adr,
+	};
+
+	strlcpy(info.type, type, I2C_NAME_SIZE);
+	request_module("%s", info.type);
+	c = i2c_new_device(i2c, &info);
+	if (c) {
+		if (c->dev.driver && try_module_get(c->dev.driver->owner))
+			return c;
+		i2c_unregister_device(c);
+	}
+	return NULL;
+}
+
+void ptx_unregister_adap_fe(struct ptx_card *card)
+{
+	int		i	= card->adapn - 1;
+	struct ptx_adap	*adap	= card->adap + i;
+
+	for (; i >= 0; i--, adap--) {
+		if (adap->fe.frontend_priv)
+			dvb_unregister_frontend(&adap->fe);
+		if (adap->fe.ops.release)
+			adap->fe.ops.release(&adap->fe);
+		ptx_unregister_subdev(adap->tuner);
+		ptx_unregister_subdev(adap->demod);
+		if (adap->demux.dmx.close)
+			adap->demux.dmx.close(&adap->demux.dmx);
+		if (adap->dmxdev.filter)
+			dvb_dmxdev_release(&adap->dmxdev);
+		if (adap->demux.cnt_storage)
+			dvb_dmx_release(&adap->demux);
+		if (adap->dvb.name)
+			dvb_unregister_adapter(&adap->dvb);
+	}
+	i2c_del_adapter(&card->i2c);
+	pci_release_regions(card->pdev);
+	pci_set_drvdata(card->pdev, NULL);
+	pci_disable_device(card->pdev);
+	kfree(card);
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adap_no);
+int ptx_register_adap_fe(struct ptx_card *card, const struct ptx_subdev_info *info,
+			int (*start)(struct dvb_demux_feed *), int (*stop)(struct dvb_demux_feed *))
+{
+	struct ptx_adap	*adap;
+	u8	i;
+	int	err;
+
+	for (i = 0, adap = card->adap; i < card->adapn; i++, adap++) {
+		struct dvb_adapter	*dvb	= &adap->dvb;
+		struct dvb_demux	*demux	= &adap->demux;
+		struct dmxdev		*dmxdev	= &adap->dmxdev;
+		struct dvb_frontend	*fe	= &adap->fe;
+
+		if (dvb_register_adapter(dvb, card->name, THIS_MODULE, &card->pdev->dev, adap_no) < 0)
+			return -ENFILE;
+		demux->feednum		= 1;
+		demux->filternum	= 1;
+		demux->start_feed	= start;
+		demux->stop_feed	= stop;
+		if (dvb_dmx_init(demux) < 0)
+			return -ENOMEM;
+		dmxdev->filternum	= 1;
+		dmxdev->demux		= &demux->dmx;
+		err = dvb_dmxdev_init(dmxdev, dvb);
+		if (err)
+			return err;
+		fe->dtv_property_cache.delivery_system	= info[i].type;
+		fe->dvb	= &adap->dvb;
+		adap->demod = ptx_register_subdev(&card->i2c, &adap->fe, info[i].demod_addr, info[i].demod_name);
+		adap->tuner = ptx_register_subdev(&card->i2c, &adap->fe, info[i].tuner_addr, info[i].tuner_name);
+		if (!adap->demod || !adap->tuner)
+			return -ENFILE;
+		adap->fe_sleep		= adap->fe.ops.sleep;
+		adap->fe_wakeup		= adap->fe.ops.init;
+		adap->fe.ops.sleep	= ptx_sleep;
+		adap->fe.ops.init	= ptx_wakeup;
+		adap->fe.dvb		= &adap->dvb;
+		if (dvb_register_frontend(&adap->dvb, &adap->fe))
+			return -EIO;
+		ptx_sleep(&adap->fe);
+		mutex_init(&adap->lock);
+	}
+	return 0;
+}
+
+int ptx_abort(struct pci_dev *pdev, void remover(struct pci_dev *), int err, char *fmt, ...)
+{
+	va_list	ap;
+	char	*s = NULL;
+	int	slen;
+
+	va_start(ap, fmt);
+	slen	= vsnprintf(s, 0, fmt, ap) + 1;
+	s	= vzalloc(slen);
+	if (s) {
+		vsnprintf(s, slen, fmt, ap);
+		dev_err(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	remover(pdev);
+	return err;
+}
+
+u32 ptx_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_NOSTART;
+}
+
+
diff --git a/drivers/media/pci/ptx/ptx_common.h b/drivers/media/pci/ptx/ptx_common.h
new file mode 100644
index 0000000..f00c03c
--- /dev/null
+++ b/drivers/media/pci/ptx/ptx_common.h
@@ -0,0 +1,73 @@
+/*
+ * Defs & procs for PT3 & PX-Q3PE DVB driver
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * This program is distributed in hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef	PTX_COMMON_H
+#define PTX_COMMON_H
+
+#include <linux/vmalloc.h>
+#include "dvb_demux.h"
+#include "dmxdev.h"
+
+enum ePTX {
+	PTX_MODE_GPIO	= 0,
+	PTX_MODE_TUNER	= 1,
+	PTX_MODE_STAT	= 2,
+
+	PTX_TS_SYNC	= 0x47,
+	PTX_TS_NOT_SYNC	= 0x74,
+};
+
+struct ptx_subdev_info {
+	enum fe_delivery_system	type;
+	u8	demod_addr,	*demod_name,
+		tuner_addr,	*tuner_name;
+};
+
+struct ptx_card {
+	struct ptx_adap		*adap;
+	struct mutex		lock;
+	struct i2c_adapter	i2c;
+	struct pci_dev		*pdev;
+	u8	*name,
+		adapn;
+	bool	lnbON;
+	void	*priv,
+		(*lnb)(struct ptx_card *card, bool lnb);
+};
+
+struct ptx_adap {
+	struct ptx_card		*card;
+	struct mutex		lock;
+	bool			ON;
+	struct dvb_frontend	fe;
+	struct dvb_adapter	dvb;
+	struct dvb_demux	demux;
+	struct dmxdev		dmxdev;
+	struct i2c_client	*demod,
+				*tuner;
+	struct task_struct	*kthread;
+	void			*priv;
+	int	(*fe_sleep)(struct dvb_frontend *),
+		(*fe_wakeup)(struct dvb_frontend *);
+};
+
+struct ptx_card *ptx_alloc(struct pci_dev *pdev, u8 *name, u8 adapn, u32 sz_card_priv, u32 sz_adap_priv,
+			void (*lnb)(struct ptx_card *, bool));
+int ptx_sleep(struct dvb_frontend *fe);
+int ptx_wakeup(struct dvb_frontend *fe);
+int ptx_i2c_add_adapter(struct ptx_card *card, const struct i2c_algorithm *algo);
+void ptx_unregister_adap_fe(struct ptx_card *card);
+int ptx_register_adap_fe(struct ptx_card *card, const struct ptx_subdev_info *info,
+			int (*start)(struct dvb_demux_feed *), int (*stop)(struct dvb_demux_feed *));
+int ptx_abort(struct pci_dev *pdev, void remover(struct pci_dev *), int err, char *fmt, ...);
+u32 ptx_i2c_func(struct i2c_adapter *i2c);
+
+#endif
diff --git a/drivers/media/pci/ptx/pxq3pe_pci.c b/drivers/media/pci/ptx/pxq3pe_pci.c
new file mode 100644
index 0000000..eec3c46
--- /dev/null
+++ b/drivers/media/pci/ptx/pxq3pe_pci.c
@@ -0,0 +1,605 @@
+/*
+ * DVB driver for PLEX PX-Q3PE ISDB-S/T PCIE receiver
+ *
+ * Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
+ *
+ * Main components:
+ *	ASIE5606X8	- controller
+ *	TC90522		- 2ch OFDM ISDB-T + 2ch 8PSK ISDB-S demodulator
+ *	TDA20142	- ISDB-S tuner
+ *	NM120		- ISDB-T tuner
+ */
+
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "dvb_frontend.h"
+#include "ptx_common.h"
+#include "tc90522.h"
+#include "tda2014x.h"
+#include "nm131.h"
+
+#define MOD_AUTH "Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>"
+MODULE_AUTHOR(MOD_AUTH);
+MODULE_DESCRIPTION("PLEX PX-Q3PE Driver");
+MODULE_LICENSE("GPL");
+
+static char	*auth	= MOD_AUTH;
+static int	ni,
+		nx,
+		idx[8]	= {0},
+		xor[4]	= {0};
+module_param(auth, charp, 0);
+module_param_array(idx, int, &ni, 0);
+module_param_array(xor, int, &nx, 0);
+
+static struct pci_device_id pxq3pe_id_table[] = {
+	{0x188B, 0x5220, 0x0B06, 0x0002, 0, 0, 0},
+	{}
+};
+MODULE_DEVICE_TABLE(pci, pxq3pe_id_table);
+
+enum ePXQ3PE {
+	PKT_BYTES	= 188,
+	PKT_NUM		= 312,
+	PKT_BUFSZ	= PKT_BYTES * PKT_NUM,
+
+	PXQ3PE_IRQ_STAT		= 0x808,
+	PXQ3PE_IRQ_CLEAR	= 0x80C,
+	PXQ3PE_IRQ_ACTIVE	= 0x814,
+	PXQ3PE_IRQ_DISABLE	= 0x818,
+	PXQ3PE_IRQ_ENABLE	= 0x81C,
+
+	PXQ3PE_I2C_ADR_GPIO	= 0x4A,
+	PXQ3PE_I2C_CTL_STAT	= 0x940,
+	PXQ3PE_I2C_ADR		= 0x944,
+	PXQ3PE_I2C_SW_CTL	= 0x948,
+	PXQ3PE_I2C_FIFO_STAT	= 0x950,
+	PXQ3PE_I2C_FIFO_DATA	= 0x960,
+
+	PXQ3PE_DMA_OFFSET_PORT	= 0x140,
+	PXQ3PE_DMA_TSMODE	= 0xA00,
+	PXQ3PE_DMA_MGMT		= 0xAE0,
+	PXQ3PE_DMA_OFFSET_CH	= 0x10,
+	PXQ3PE_DMA_ADR_LO	= 0xAC0,
+	PXQ3PE_DMA_ADR_HI	= 0xAC4,
+	PXQ3PE_DMA_XFR_STAT	= 0xAC8,
+	PXQ3PE_DMA_CTL		= 0xACC,
+
+	PXQ3PE_MAX_LOOP		= 0xFFFF,
+};
+
+struct pxq3pe_card {
+	void __iomem		*bar;
+	struct {
+		dma_addr_t	adr;
+		u8		*dat;
+		u32		sz;
+		bool		ON[2];
+	} dma;
+};
+
+struct pxq3pe_adap {
+	u8	tBuf[PKT_BUFSZ],
+		*sBuf;
+	u32	tBufIdx,
+		sBufSize,
+		sBufStart,
+		sBufStop,
+		sBufByteCnt;
+};
+
+bool pxq3pe_w(struct ptx_card *card, u8 slvadr, u8 regadr, u8 *wdat, u8 bytelen, u8 mode)
+{
+	struct pxq3pe_card	*c	= card->priv;
+	void __iomem		*bar	= c->bar;
+	int	i,
+		j,
+		k;
+	u8	i2cCtlByte,
+		i2cFifoWSz;
+
+	if ((readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F) != 0x10 || readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00)
+		return false;
+	writel(0, bar + PXQ3PE_I2C_CTL_STAT);
+	switch (mode) {
+	case PTX_MODE_GPIO:
+		i2cCtlByte = 0xC0;
+		break;
+	case PTX_MODE_TUNER:
+		slvadr = 2 * slvadr + 0x20;
+		regadr = 0;
+		i2cCtlByte = 0x80;
+		break;
+	case PTX_MODE_STAT:
+		slvadr = 2 * slvadr + 0x20;
+		regadr = 0;
+		i2cCtlByte = 0x84;
+		break;
+	default:
+		return false;
+	}
+	writel((slvadr << 8) + regadr, bar + PXQ3PE_I2C_ADR);
+	for (i = 0; i < 16 && i < bytelen; i += 4) {
+		udelay(1000);
+		writel(*((u32 *)(wdat + i)), bar + PXQ3PE_I2C_FIFO_DATA);
+	}
+	writew((bytelen << 8) + i2cCtlByte, bar + PXQ3PE_I2C_CTL_STAT);
+	for (j = 0; j < PXQ3PE_MAX_LOOP; j++) {
+		if (i < bytelen) {
+			i2cFifoWSz = readb(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F;
+			for (k = 0; bytelen > 16 && k < PXQ3PE_MAX_LOOP && i2cFifoWSz < bytelen - 16; k++) {
+				i2cFifoWSz = readb(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F;
+				udelay(1000);
+			}
+			if (i2cFifoWSz & 3)
+				continue;
+			if (i2cFifoWSz) {
+				for (k = i; k < bytelen && k - i < i2cFifoWSz; k += 4)
+					writel(*((u32 *)(wdat + k)), bar + PXQ3PE_I2C_FIFO_DATA);
+				i = k;
+			}
+		}
+		udelay(10);
+		if (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0x400000)
+			break;
+	}
+	return j < PXQ3PE_MAX_LOOP ? !(readl(bar + PXQ3PE_I2C_CTL_STAT) & 0x280000) : false;
+}
+
+bool pxq3pe_r(struct ptx_card *card, u8 slvadr, u8 regadr, u8 *rdat, u8 bytelen, u8 mode)
+{
+	struct pxq3pe_card	*c	= card->priv;
+	void __iomem		*bar	= c->bar;
+	u8	i2cCtlByte,
+		i2cStat,
+		i2cFifoRSz,
+		i2cByteCnt;
+	int	i		= 0,
+		j,
+		idx;
+	bool	ret		= false;
+
+	if ((readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F) != 0x10 || readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00)
+		return false;
+	writel(0, bar + PXQ3PE_I2C_CTL_STAT);
+	switch (mode) {
+	case PTX_MODE_GPIO:
+		i2cCtlByte = 0xE0;
+		break;
+	case PTX_MODE_TUNER:
+		slvadr = 2 * slvadr + 0x20;
+		regadr = 0;
+		i2cCtlByte = 0xA0;
+		break;
+	default:
+		return false;
+	}
+	writel((slvadr << 8) + regadr, bar + PXQ3PE_I2C_ADR);
+	writew(i2cCtlByte + (bytelen << 8), bar + PXQ3PE_I2C_CTL_STAT);
+	i2cByteCnt = bytelen;
+	j = 0;
+	while (j < PXQ3PE_MAX_LOOP) {
+		udelay(10);
+		i2cStat = (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0xFF0000) >> 16;
+		if (i2cStat & 0x80) {
+			if (i2cStat & 0x28)
+				break;
+			ret = true;
+		}
+		i2cFifoRSz = (readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00) >> 8;
+		if (i2cFifoRSz & 3) {
+			++j;
+			continue;
+		}
+		for (idx = i; i2cFifoRSz && idx < i2cByteCnt && idx - i < i2cFifoRSz; idx += 4)
+			*(u32 *)(rdat + idx) = readl(bar + PXQ3PE_I2C_FIFO_DATA);
+		i = idx;
+		if (i < bytelen) {
+			if (i2cFifoRSz)
+				i2cByteCnt -= i2cFifoRSz;
+			else
+				++j;
+			continue;
+		}
+		i2cStat = (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0xFF0000) >> 16;
+		if (i2cStat & 0x80) {
+			if (i2cStat & 0x28)
+				break;
+			ret = true;
+			break;
+		}
+		++j;
+	}
+	return !(readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00) && ret;
+}
+
+int pxq3pe_xfr(struct i2c_adapter *i2c, struct i2c_msg *msg, int sz)
+{
+	struct ptx_card	*card	= i2c_get_adapdata(i2c);
+	u8		i;
+	bool		ret	= true;
+
+	if (!i2c || !card || !msg)
+		return -EINVAL;
+	for (i = 0; i < sz && ret; i++, msg++) {
+		u8	slvadr	= msg->addr,
+			regadr	= msg->len ? *msg->buf : 0,
+			mode	= slvadr == PXQ3PE_I2C_ADR_GPIO	? PTX_MODE_GPIO
+				: sz > 1 && i == sz - 2		? PTX_MODE_STAT
+				: PTX_MODE_TUNER;
+
+		mutex_lock(&card->lock);
+		if (msg->flags & I2C_M_RD) {
+			u8 buf[sz];
+
+			ret = pxq3pe_r(card, slvadr, regadr, buf, msg->len, mode);
+			memcpy(msg->buf, buf, msg->len);
+		} else
+			ret = pxq3pe_w(card, slvadr, regadr, msg->buf, msg->len, mode);
+		mutex_unlock(&card->lock);
+	}
+	return i;
+}
+
+bool pxq3pe_w_gpio2(struct ptx_card *card, u8 dat, u8 mask)
+{
+	u8 val;
+
+	return	pxq3pe_r(card, PXQ3PE_I2C_ADR_GPIO, 0xB, &val, 1, PTX_MODE_GPIO)	&&
+		(val = (mask & dat) | (val & ~mask), pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0xB, &val, 1, PTX_MODE_GPIO));
+}
+
+void pxq3pe_w_gpio1(struct ptx_card *card, u8 val, u8 mask)
+{
+	struct pxq3pe_card *c = card->priv;
+
+	mask <<= 3;
+	writeb((readb(c->bar + 0x890) & ~mask) | ((val << 3) & mask), c->bar + 0x890);
+}
+
+void pxq3pe_w_gpio0(struct ptx_card *card, u8 val, u8 mask)
+{
+	struct pxq3pe_card *c = card->priv;
+
+	writeb((-(mask & 1) & 4 & -(val & 1)) | (readb(c->bar + 0x890) & ~(-(mask & 1) & 4)), c->bar + 0x890);
+	writeb((mask & val) | (readb(c->bar + 0x894) & ~mask), c->bar + 0x894);
+}
+
+void pxq3pe_power(struct ptx_card *card, bool ON)
+{
+	if (ON) {
+		pxq3pe_w_gpio0(card, 1, 1);
+		pxq3pe_w_gpio0(card, 0, 1);
+		pxq3pe_w_gpio0(card, 1, 1);
+		pxq3pe_w_gpio1(card, 1, 1);
+		pxq3pe_w_gpio1(card, 0, 1);
+		pxq3pe_w_gpio2(card, 2, 2);
+		pxq3pe_w_gpio2(card, 0, 2);
+		pxq3pe_w_gpio2(card, 2, 2);
+		pxq3pe_w_gpio2(card, 4, 4);
+		pxq3pe_w_gpio2(card, 0, 4);
+		pxq3pe_w_gpio2(card, 4, 4);
+	} else {
+		pxq3pe_w_gpio0(card, 0, 1);
+		pxq3pe_w_gpio0(card, 1, 1);
+		pxq3pe_w_gpio1(card, 1, 1);
+	}
+}
+
+irqreturn_t pxq3pe_irq(int irq, void *ctx)
+{
+	struct ptx_card		*card	= ctx;
+	struct pxq3pe_card	*c	= card->priv;
+	void __iomem		*bar	= c->bar;
+	u32	dmamgmt,
+		i,
+		intstat = readl(bar + PXQ3PE_IRQ_STAT);
+	bool	ch	= intstat & 0b0101 ? 0 : 1,
+		port	= intstat & 0b0011 ? 0 : 1;
+	u8	*tbuf	= c->dma.dat + PKT_BUFSZ * (port * 2 + ch);
+
+	void pxq3pe_dma_put_stream(struct pxq3pe_adap *p)
+	{
+		u8	*src	= p->tBuf;
+		u32	len	= p->tBufIdx,
+			savesz	= len <= p->sBufSize - p->sBufStop ? len : p->sBufSize - p->sBufStop,
+			remain	= len - savesz;
+
+		memcpy(&p->sBuf[p->sBufStop], src, savesz);
+		if (remain)
+			memcpy(p->sBuf, &src[savesz], remain);
+		p->sBufStop = (p->sBufStop + len) % p->sBufSize;
+		if (p->sBufByteCnt == p->sBufSize)
+			p->sBufStart = p->sBufStop;
+		else {
+			if (p->sBufSize >= p->sBufByteCnt + len)
+				p->sBufByteCnt += len;
+			else {
+				p->sBufStart = p->sBufStop;
+				p->sBufByteCnt = p->sBufSize;
+			}
+		}
+	}
+
+	if (!(intstat & 0b1111))
+		return IRQ_HANDLED;
+	writel(intstat, bar + PXQ3PE_IRQ_CLEAR);
+	dmamgmt = readl(bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+	if ((readl(bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * ch + PXQ3PE_DMA_XFR_STAT) & 0x3FFFFF) == PKT_BUFSZ)
+		for (i = 0; i < PKT_BUFSZ; i += PKT_BYTES) {
+		u8 i2cadr = !port * 4 + (tbuf[i] == 0xC7 ? 0 : tbuf[i] == 0x47 ?
+					1 : tbuf[i] == 0x07 ? 2 : tbuf[i] == 0x87 ? 3 : card->adapn);
+		struct ptx_adap		*adap	= &card->adap[i2cadr];
+		struct pxq3pe_adap	*p	= adap->priv;
+
+		if (i2cadr < card->adapn && adap->ON) {
+			tbuf[i] = PTX_TS_SYNC;
+			memcpy(&p->tBuf[p->tBufIdx], &tbuf[i], PKT_BYTES);
+			p->tBufIdx += PKT_BYTES;
+			if (p->tBufIdx >= PKT_BUFSZ) {
+				pxq3pe_dma_put_stream(p);
+				p->tBufIdx = 0;
+			}
+		}
+	}
+	if (c->dma.ON[port])
+		writel(dmamgmt | (2 << (ch * 16)), bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+	return IRQ_HANDLED;
+}
+
+int pxq3pe_thread(void *dat)
+{
+	struct ptx_adap		*adap	= dat;
+	struct pxq3pe_adap	*p	= adap->priv;
+
+	set_freezable();
+	while (!kthread_should_stop()) {
+		u8	*rbuf	= &p->sBuf[p->sBufStart];
+		int	i	= 0,
+			j	= 0,
+			k,
+			sz	= p->sBufSize - p->sBufStart;
+
+		try_to_freeze();
+		if (!p->sBufByteCnt) {
+			msleep_interruptible(0);
+			continue;
+		}
+		if (sz > p->sBufByteCnt)
+			sz = p->sBufByteCnt;
+		while (j < sz / PKT_BYTES) {
+			j++;
+			i += 4;
+			while (i < j * PKT_BYTES)
+				for (k = 0; k < 8; k++, i++)
+					rbuf[i] ^= xor[idx[k]];
+		}
+		dvb_dmx_swfilter_raw(&adap->demux, rbuf, sz);
+		p->sBufStart = (p->sBufStart + sz) % p->sBufSize;
+		p->sBufByteCnt -= sz;
+	}
+	return 0;
+}
+
+void pxq3pe_dma_stop(struct ptx_adap *adap)
+{
+	struct ptx_card		*card	= adap->card;
+	struct pxq3pe_card	*c	= card->priv;
+	u8			i2cadr	= adap->fe.id,
+				i;
+	bool			port	= !(i2cadr & 4);
+
+	for (i = 0; i < card->adapn; i++)
+		if (!c->dma.ON[port] || (i2cadr != i && (i & 4) == (i2cadr & 4) && c->dma.ON[port]))
+			return;
+
+	i = readb(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+	if ((i & 0b1100) == 4)
+		writeb(i & 0xFD, c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+	writeb(0b0011 << (port * 2), c->bar + PXQ3PE_IRQ_DISABLE);
+	c->dma.ON[port] = false;
+}
+
+bool pxq3pe_dma_start(struct ptx_adap *adap)
+{
+	struct ptx_card		*card	= adap->card;
+	struct pxq3pe_card	*c	= card->priv;
+	struct pxq3pe_adap	*p	= adap->priv;
+	u8	i2cadr	= adap->fe.id,
+		i;
+	bool	port	= !(i2cadr & 4);
+	u32	val	= 0b0011 << (port * 2);
+
+	p->sBufByteCnt	= 0;
+	p->sBufStop	= 0;
+	p->sBufStart	= 0;
+	if (c->dma.ON[port])
+		return true;
+
+	/* SetTSMode */
+	i = readb(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_TSMODE);
+	if ((i & 0x80) == 0)
+		writeb(i | 0x80, c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_TSMODE);
+
+	/* irq_enable */
+	writel(val, c->bar + PXQ3PE_IRQ_ENABLE);
+	if (val != (readl(c->bar + PXQ3PE_IRQ_ACTIVE) & val))
+		return false;
+
+	/* cfg_dma */
+	for (i = 0; i < 2; i++) {
+		val		= readl(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+		writel(c->dma.adr + PKT_BUFSZ * (port * 2 + i),
+					c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_ADR_LO);
+		writel(0,		c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_ADR_HI);
+		writel(0x11C0E520,	c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_CTL);
+		writel(val | 3 << (i * 16),
+					c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
+	}
+	c->dma.ON[port] = true;
+	return true;
+}
+
+int pxq3pe_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
+
+	pxq3pe_dma_stop(adap);
+	kthread_stop(adap->kthread);
+	return 0;
+}
+
+int pxq3pe_start_feed(struct dvb_demux_feed *feed)
+{
+	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
+
+	if (!pxq3pe_dma_start(adap))
+		return	-EIO;
+	adap->kthread = kthread_run(pxq3pe_thread, adap, "%s_%d", adap->card->name, adap->fe.id);
+	return IS_ERR(adap->kthread) ? PTR_ERR(adap->kthread) : 0;
+}
+
+void pxq3pe_lnb(struct ptx_card *card, bool lnb)
+{
+	pxq3pe_w_gpio2(card, lnb ? 0x20 : 0, 0x20);
+}
+
+void pxq3pe_remove(struct pci_dev *pdev)
+{
+	struct dma_map_ops	*ops	= get_dma_ops(&pdev->dev);
+	struct ptx_card		*card	= pci_get_drvdata(pdev);
+	struct pxq3pe_card	*c	= card->priv;
+	u8	regctl = 0,
+		i;
+
+	if (!card)
+		return;
+	for (i = 0; i < card->adapn; i++) {
+		struct ptx_adap	*adap	= &card->adap[i];
+
+		pxq3pe_dma_stop(adap);
+		ptx_sleep(&adap->fe);
+	}
+	pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0x80, &regctl, 1, PTX_MODE_GPIO);
+	pxq3pe_power(card, false);
+
+	/* dma_hw_unmap */
+	free_irq(pdev->irq, card);
+	if (c->dma.dat && ops && ops->free)
+		ops->free(&pdev->dev, c->dma.sz, c->dma.dat, c->dma.adr, NULL);
+	for (i = 0; i < card->adapn; i++) {
+		struct ptx_adap		*adap	= &card->adap[i];
+		struct pxq3pe_adap	*p	= adap->priv;
+
+		vfree(p->sBuf);
+	}
+	if (c->bar)
+		pci_iounmap(pdev, c->bar);
+	ptx_unregister_adap_fe(card);
+}
+
+static const struct i2c_algorithm pxq3pe_algo = {
+	.functionality	= ptx_i2c_func,
+	.master_xfer	= pxq3pe_xfr,
+};
+
+static int pxq3pe_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+{
+	struct ptx_subdev_info	pxq3pe_subdev_info[] = {
+		{SYS_ISDBT, 0x10, TC90522_MODNAME, 0x20, NM131_MODNAME},
+		{SYS_ISDBS, 0x11, TC90522_MODNAME, 0x21, TDA2014X_MODNAME},
+		{SYS_ISDBT, 0x12, TC90522_MODNAME, 0x22, NM131_MODNAME},
+		{SYS_ISDBS, 0x13, TC90522_MODNAME, 0x23, TDA2014X_MODNAME},
+		{SYS_ISDBT, 0x14, TC90522_MODNAME, 0x24, NM131_MODNAME},
+		{SYS_ISDBS, 0x15, TC90522_MODNAME, 0x25, TDA2014X_MODNAME},
+		{SYS_ISDBT, 0x16, TC90522_MODNAME, 0x26, NM131_MODNAME},
+		{SYS_ISDBS, 0x17, TC90522_MODNAME, 0x27, TDA2014X_MODNAME},
+	};
+	struct ptx_card		*card	= ptx_alloc(pdev, KBUILD_MODNAME, ARRAY_SIZE(pxq3pe_subdev_info),
+						sizeof(struct pxq3pe_card), sizeof(struct pxq3pe_adap), pxq3pe_lnb);
+	struct pxq3pe_card	*c	= card->priv;
+	struct device		*dev	= &pdev->dev;
+	struct dma_map_ops	*ops	= get_dma_ops(dev);
+	u8	regctl	= 0xA0,
+		i;
+	u16	cfg;
+	int	err	= !card || pci_read_config_word(pdev, PCI_COMMAND, &cfg);
+
+	if (err || !ops)
+		return ptx_abort(pdev, pxq3pe_remove, err, "Memory/PCI/DMA error, card=%p", card);
+	if (!(cfg & PCI_COMMAND_MASTER)) {
+		pci_set_master(pdev);
+		pci_read_config_word(pdev, PCI_COMMAND, &cfg);
+		if (!(cfg & PCI_COMMAND_MASTER))
+			return ptx_abort(pdev, pxq3pe_remove, -EIO, "Bus Mastering is disabled");
+	}
+	c->bar	= pci_iomap(pdev, 0, 0);
+	if (!c->bar)
+		return ptx_abort(pdev, pxq3pe_remove, -EIO, "I/O map failed");
+	if (ptx_i2c_add_adapter(card, &pxq3pe_algo))
+		return ptx_abort(pdev, pxq3pe_remove, -EIO, "Cannot add I2C");
+
+	for (i = 0; i < card->adapn; i++) {
+		struct ptx_adap		*adap	= &card->adap[i];
+		struct pxq3pe_adap	*p	= adap->priv;
+
+		adap->fe.id	= i;
+		p->sBufSize	= PKT_BYTES * 100 << 9;
+		p->sBuf		= vzalloc(p->sBufSize);
+		if (!p->sBuf)
+			return ptx_abort(pdev, pxq3pe_remove, -ENOMEM, "No memory for stream buffer");
+	}
+
+	/* dma_map */
+	c->dma.sz = PKT_BUFSZ * 4;
+	if (request_irq(pdev->irq, pxq3pe_irq, IRQF_SHARED, KBUILD_MODNAME, card))
+		return ptx_abort(pdev, pxq3pe_remove, -EIO, "IRQ failed");
+	if (dev->dma_mask && *dev->dma_mask && ops->alloc) {
+		u32 gfp = dev->coherent_dma_mask ? 0x21 - (dev->coherent_dma_mask >= 0x1000000) : 0x20;
+
+		if ((!dev->coherent_dma_mask || dev->coherent_dma_mask <= 0xFFFFFFFF) && !(gfp & 1))
+			gfp |= 4;
+		c->dma.dat = ops->alloc(dev, c->dma.sz, &c->dma.adr, gfp, NULL);
+	}
+	if (!c->dma.dat)
+		return ptx_abort(pdev, pxq3pe_remove, -EIO, "DMA mapping failed");
+
+	/* hw_init */
+	writeb(readb(c->bar + 0x880) & 0xC0, c->bar + 0x880);
+	writel(0x3200C8, c->bar + 0x904);
+	writel(0x90,	 c->bar + 0x900);
+	writel(0x10000,	 c->bar + 0x880);
+	writel(0x0080,	 c->bar + PXQ3PE_DMA_TSMODE);
+	writel(0x0080,	 c->bar + PXQ3PE_DMA_TSMODE + PXQ3PE_DMA_OFFSET_PORT);
+	writel(0x0000,	 c->bar + 0x888);
+	writel(0x00CF,	 c->bar + 0x894);
+	writel(0x8000,	 c->bar + 0x88C);
+	writel(0x1004,	 c->bar + 0x890);
+	writel(0x0090,	 c->bar + 0x900);
+	writel(0x3200C8, c->bar + 0x904);
+	pxq3pe_w_gpio0(card, 8, 0xFF);
+	pxq3pe_w_gpio1(card, 0, 2);
+	pxq3pe_w_gpio1(card, 1, 1);
+	pxq3pe_w_gpio0(card, 1, 1);
+	pxq3pe_w_gpio0(card, 0, 1);
+	pxq3pe_w_gpio0(card, 1, 1);
+	for (i = 0; i < 16; i++)
+		if (!pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0x10 + i, auth + i, 1, PTX_MODE_GPIO))
+			break;
+	if (i < 16 || !pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 5, &regctl, 1, PTX_MODE_GPIO))
+		return ptx_abort(pdev, pxq3pe_remove, -EIO, "hw_init failed");
+	pxq3pe_power(card, true);
+	err = ptx_register_adap_fe(card, pxq3pe_subdev_info, pxq3pe_start_feed, pxq3pe_stop_feed);
+	return err ? ptx_abort(pdev, pxq3pe_remove, err, "Unable to register DVB adapter & frontend") : 0;
+}
+
+static struct pci_driver pxq3pe_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= pxq3pe_id_table,
+	.probe		= pxq3pe_probe,
+	.remove		= pxq3pe_remove,
+};
+module_pci_driver(pxq3pe_driver);
+
-- 
2.3.10

