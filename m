Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33709 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbcDEQnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 12:43:55 -0400
Date: Tue, 5 Apr 2016 09:43:51 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: <info@are.ma>
Cc: <linux-media@vger.kernel.org>,
	"=?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC?= =?UTF-8?B?0L4s?= AreMa Inc"
	<knightrider@are.ma>, <linux-kernel@vger.kernel.org>,
	<crope@iki.fi>, <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
	<laurent.pinchart@ideasonboard.com>, <mkrufky@linuxtv.org>,
	<sylvester.nawrocki@gmail.com>, <g.liakhovetski@gmx.de>,
	<peter.senna@gmail.com>
Subject: Re: [media 5/5] Bridge driver for PT3, PX-Q3PE & PX-BCUD
Message-ID: <20160405094351.63fba9cf@vela.lan>
In-Reply-To: <7dc21a98db6f3b42c53e03977a9d37306315a314.1459872226.git.knightrider@are.ma>
References: <cover.1459872226.git.knightrider@are.ma>
	<7dc21a98db6f3b42c53e03977a9d37306315a314.1459872226.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 6 Apr 2016 01:14:14 +0900
<info@are.ma> escreveu:

> From: Буди Романто, AreMa Inc <knightrider@are.ma>
> 
> Bridge driver for Earthsoft PT3, PLEX PX-Q3PE ISDB-S/T PCIE cards & PX-BCUD ISDB-S USB dongle.
> Including simplified Nagahama's patch for PLEX PX-BCUD (ISDB-S usb dongle)...
> Please read cover letter for details.

This is not a full patch review. As I said before, the right procedure is
to modify the existing drivers and not replace them by some other driver.

So, I'll wait for you to take the right approach to review, as otherwise
it is impossible to see if this would cause regressions.

Yet, I'd like to add some quick notes. See below.

> 
> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
> ---
>  drivers/media/Kconfig                   |   5 +-
>  drivers/media/pci/Kconfig               |   2 +-
>  drivers/media/pci/Makefile              |   2 +-
>  drivers/media/pci/ptx/Kconfig           |  23 ++
>  drivers/media/pci/ptx/Makefile          |   6 +
>  drivers/media/pci/ptx/pt3.c             | 426 +++++++++++++++++++++++
>  drivers/media/pci/ptx/ptx_common.c      | 266 +++++++++++++++
>  drivers/media/pci/ptx/ptx_common.h      |  76 +++++
>  drivers/media/pci/ptx/pxq3pe.c          | 588 ++++++++++++++++++++++++++++++++
>  drivers/media/usb/em28xx/Kconfig        |   3 +
>  drivers/media/usb/em28xx/Makefile       |   1 +
>  drivers/media/usb/em28xx/em28xx-cards.c |  27 ++
>  drivers/media/usb/em28xx/em28xx-dvb.c   |  81 ++++-
>  drivers/media/usb/em28xx/em28xx.h       |   1 +

Please split em28xx changes from PT3 PCI driver changes.

>  14 files changed, 1502 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/media/pci/ptx/Kconfig
>  create mode 100644 drivers/media/pci/ptx/Makefile
>  create mode 100644 drivers/media/pci/ptx/pt3.c
>  create mode 100644 drivers/media/pci/ptx/ptx_common.c
>  create mode 100644 drivers/media/pci/ptx/ptx_common.h
>  create mode 100644 drivers/media/pci/ptx/pxq3pe.c
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index a8518fb..37fae59 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -149,7 +149,10 @@ config DVB_NET
>  	  You may want to disable the network support on embedded devices. If
>  	  unsure say Y.
>  
> -# This Kconfig option is used by both PCI and USB drivers
> +# Options used by both PCI and USB drivers
> +config DVB_PTX_COMMON
> +	tristate
> +

No, this approach looks wrong, and will cause build troubles depending on
the options the user is selecting.

>  config TTPCI_EEPROM
>  	tristate
>  	depends on I2C
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 48a611b..9d63ad6 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -44,7 +44,7 @@ source "drivers/media/pci/b2c2/Kconfig"
>  source "drivers/media/pci/pluto2/Kconfig"
>  source "drivers/media/pci/dm1105/Kconfig"
>  source "drivers/media/pci/pt1/Kconfig"
> -source "drivers/media/pci/pt3/Kconfig"
> +source "drivers/media/pci/ptx/Kconfig"
>  source "drivers/media/pci/mantis/Kconfig"
>  source "drivers/media/pci/ngene/Kconfig"
>  source "drivers/media/pci/ddbridge/Kconfig"
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index 5f8aacb..984e37c 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -7,7 +7,7 @@ obj-y        +=	ttpci/		\
>  		pluto2/		\
>  		dm1105/		\
>  		pt1/		\
> -		pt3/		\
> +		ptx/		\
>  		mantis/		\
>  		ngene/		\
>  		ddbridge/	\
> diff --git a/drivers/media/pci/ptx/Kconfig b/drivers/media/pci/ptx/Kconfig
> new file mode 100644
> index 0000000..53ec5ea
> --- /dev/null
> +++ b/drivers/media/pci/ptx/Kconfig
> @@ -0,0 +1,23 @@
> +config DVB_PT3
> +	tristate "Earthsoft PT3 cards"
> +	depends on DVB_CORE && PCI && I2C
> +	select DVB_PTX_COMMON
> +	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_QM1D1C004X if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Support for Earthsoft PT3 ISDB-S/T PCIe cards.
> +
> +	  Say Y or M if you own such a device and want to use it.
> +
> +config DVB_PXQ3PE
> +	tristate "PLEX PX-Q3PE cards"
> +	depends on DVB_CORE && PCI && I2C
> +	select DVB_PTX_COMMON
> +	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_QM1D1C004X if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Support for PLEX PX-Q3PE ISDB-S/T PCIe cards.
> +
> +	  Say Y or M if you own such a device and want to use it.
> diff --git a/drivers/media/pci/ptx/Makefile b/drivers/media/pci/ptx/Makefile
> new file mode 100644
> index 0000000..9c41328
> --- /dev/null
> +++ b/drivers/media/pci/ptx/Makefile
> @@ -0,0 +1,6 @@
> +obj-$(CONFIG_DVB_PTX_COMMON)	+= ptx_common.o
> +obj-$(CONFIG_DVB_PT3)		+= pt3.o
> +obj-$(CONFIG_DVB_PXQ3PE)	+= pxq3pe.o
> +
> +ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
> +
> diff --git a/drivers/media/pci/ptx/pt3.c b/drivers/media/pci/ptx/pt3.c
> new file mode 100644
> index 0000000..0f67751
> --- /dev/null
> +++ b/drivers/media/pci/ptx/pt3.c
> @@ -0,0 +1,426 @@
> +/*
> +	DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
> +
> +	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
> +
> +	This program is distributed in the hope that it will be useful,
> +	but WITHOUT ANY WARRANTY; without even the implied warranty of
> +	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +	GNU General Public License for more details.
> +*/
> +
> +#include "ptx_common.h"
> +#include "tc90522.h"
> +#include "qm1d1c004x.h"
> +#include "mxl301rf.h"
> +
> +MODULE_AUTHOR(PTX_AUTH);
> +MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
> +MODULE_LICENSE("GPL");
> +
> +static struct pci_device_id pt3_id[] = {
> +	{PCI_DEVICE(0x1172, 0x4c15)},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(pci, pt3_id);
> +
> +enum ePT3 {
> +	PT3_REG_VERSION	= 0x00,	/*	R	Version		*/
> +	PT3_REG_BUS	= 0x04,	/*	R	Bus		*/
> +	PT3_REG_SYS_W	= 0x08,	/*	W	System		*/
> +	PT3_REG_SYS_R	= 0x0c,	/*	R	System		*/
> +	PT3_REG_I2C_W	= 0x10,	/*	W	I2C		*/
> +	PT3_REG_I2C_R	= 0x14,	/*	R	I2C		*/
> +	PT3_REG_RAM_W	= 0x18,	/*	W	RAM		*/
> +	PT3_REG_RAM_R	= 0x1c,	/*	R	RAM		*/
> +	PT3_DMA_BASE	= 0x40,	/* + 0x18*idx			*/
> +	PT3_DMA_OFFSET	= 0x18,
> +	PT3_DMA_DESC	= 0x00,	/*	W	DMA descriptor	*/
> +	PT3_DMA_CTL	= 0x08,	/*	W	DMA		*/
> +	PT3_TS_CTL	= 0x0c,	/*	W	TS		*/
> +	PT3_STATUS	= 0x10,	/*	R	DMA/FIFO/TS	*/
> +	PT3_TS_ERR	= 0x14,	/*	R	TS		*/
> +
> +	PT3_I2C_DATA_OFFSET	= 0x800,
> +	PT3_I2C_START_ADDR	= 0x17fa,
> +
> +	PT3_PWR_OFF		= 0x00,
> +	PT3_PWR_AMP_ON		= 0x04,
> +	PT3_PWR_TUNER_ON	= 0x40,
> +};
> +
> +struct pt3_card {
> +	void __iomem	*bar_reg,
> +			*bar_mem;
> +};
> +
> +struct pt3_dma {
> +	dma_addr_t	adr;
> +	u8		*dat;
> +	u32		sz;
> +};
> +
> +struct pt3_adap {
> +	u32	ts_blk_idx,
> +		ts_blk_cnt,
> +		desc_pg_cnt;
> +	void __iomem	*dma_base;
> +	struct pt3_dma	*ts_info,
> +			*desc_info;
> +};
> +
> +int pt3_i2c_flush(struct pt3_card *c, u32 start_addr)
> +{
> +	u32	val	= 0b0110,
> +		i	= 999;
> +
> +	void i2c_wait(void)
> +	{
> +		while (1) {
> +			val = readl(c->bar_reg + PT3_REG_I2C_R);
> +
> +			if (!(val & 1))						/* sequence stopped */
> +				return;
> +			msleep_interruptible(0);
> +		}
> +	}
> +
> +	while ((val & 0b0110) && i--) {						/* I2C bus is dirty */
> +		i2c_wait();
> +		writel(1 << 16 | start_addr, c->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
> +		i2c_wait();
> +	}
> +	return val & 0b0110 ? -EIO : 0;						/* ACK status */
> +}
> +
> +int pt3_i2c_xfr(struct i2c_adapter *i2c, struct i2c_msg *msg, int sz)
> +{
> +	enum pt3_i2c_cmd {
> +		I_END,
> +		I_ADDRESS,
> +		I_CLOCK_L,
> +		I_CLOCK_H,
> +		I_DATA_L,
> +		I_DATA_H,
> +		I_RESET,
> +		I_SLEEP,
> +		I_DATA_L_NOP	= 0x08,
> +		I_DATA_H_NOP	= 0x0c,
> +		I_DATA_H_READ	= 0x0d,
> +		I_DATA_H_ACK0	= 0x0e,
> +	};
> +	struct ptx_card *card	= i2c_get_adapdata(i2c);
> +	struct pt3_card *c	= card->priv;
> +	u32	offset		= 0;
> +	u8	buf;
> +	bool	filled		= false;
> +
> +	void i2c_shoot(u8 dat)
> +	{
> +		if (filled) {
> +			buf |= dat << 4;
> +			writeb(buf, c->bar_mem + PT3_I2C_DATA_OFFSET + offset);
> +			offset++;
> +		} else
> +			buf = dat;
> +		filled ^= true;
> +	}
> +
> +	void i2c_w(const u8 *dat, u32 size)
> +	{
> +		u32 i, j;
> +
> +		for (i = 0; i < size; i++) {
> +			for (j = 0; j < 8; j++)
> +				i2c_shoot((dat[i] >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
> +			i2c_shoot(I_DATA_H_ACK0);
> +		}
> +	}
> +
> +	void i2c_r(u32 size)
> +	{
> +		u32 i, j;
> +
> +		for (i = 0; i < size; i++) {
> +			for (j = 0; j < 8; j++)
> +				i2c_shoot(I_DATA_H_READ);
> +			if (i == (size - 1))
> +				i2c_shoot(I_DATA_H_NOP);
> +			else
> +				i2c_shoot(I_DATA_L_NOP);
> +		}
> +	}
> +	int i, j;
> +
> +	if (sz < 1 || sz > 3 || !msg || msg[0].flags)		/* always write first */
> +		return -ENOTSUPP;
> +	mutex_lock(&card->lock);
> +	for (i = 0; i < sz; i++) {
> +		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
> +
> +		/* start */
> +		i2c_shoot(I_DATA_H);
> +		i2c_shoot(I_CLOCK_H);
> +		i2c_shoot(I_DATA_L);
> +		i2c_shoot(I_CLOCK_L);
> +		i2c_w(&byte, 1);
> +		if (msg[i].flags == I2C_M_RD)
> +			i2c_r(msg[i].len);
> +		else
> +			i2c_w(msg[i].buf, msg[i].len);
> +	}
> +
> +	/* stop */
> +	i2c_shoot(I_DATA_L);
> +	i2c_shoot(I_CLOCK_H);
> +	i2c_shoot(I_DATA_H);
> +	i2c_shoot(I_END);
> +	if (filled)
> +		i2c_shoot(I_END);
> +	if (pt3_i2c_flush(c, 0))
> +		sz = -EIO;
> +	else
> +		for (i = 1; i < sz; i++)
> +			if (msg[i].flags == I2C_M_RD)
> +				for (j = 0; j < msg[i].len; j++)
> +					msg[i].buf[j] = readb(c->bar_mem + PT3_I2C_DATA_OFFSET + j);
> +	mutex_unlock(&card->lock);
> +	return sz;
> +}
> +
> +static const struct i2c_algorithm pt3_i2c_algo = {
> +	.functionality	= ptx_i2c_func,
> +	.master_xfer	= pt3_i2c_xfr,
> +};
> +
> +void pt3_lnb(struct ptx_card *card, bool lnb)
> +{
> +	struct pt3_card *c = card->priv;
> +
> +	writel(lnb ? 15 : 12, c->bar_reg + PT3_REG_SYS_W);
> +}
> +
> +int pt3_power(struct dvb_frontend *fe, u8 pwr)
> +{
> +	struct i2c_client	*d	= fe->demodulator_priv;
> +	u8		buf[]	= {0x1E, pwr | 0b10011001};
> +	struct i2c_msg	msg[]	= {
> +		{.addr = d->addr,	.flags = 0,	.buf = buf,	.len = 2,},
> +	};
> +
> +	return i2c_transfer(d->adapter, msg, 1) == 1 ? 0 : -EIO;
> +}
> +
> +int pt3_dma_run(struct ptx_adap *adap, bool ON)
> +{
> +	struct pt3_adap	*p	= adap->priv;
> +	void __iomem	*base	= p->dma_base;
> +	int		i	= 999;
> +
> +	if (ON) {
> +		for (i = 0; i < p->ts_blk_cnt; i++)		/* 17 */
> +			*p->ts_info[i].dat	= PTX_TS_NOT_SYNC;
> +		p->ts_blk_idx = 0;
> +		writel(2, base + PT3_DMA_CTL);			/* stop DMA */
> +		writel(p->desc_info->adr & 0xffffffff, base + PT3_DMA_DESC);
> +		writel((u64)p->desc_info->adr >> 32, base + PT3_DMA_DESC + 4);
> +		writel(1, base + PT3_DMA_CTL);			/* start DMA */
> +	} else {
> +		writel(2, base + PT3_DMA_CTL);			/* stop DMA */
> +		while (i--) {
> +			if (!(readl(base + PT3_STATUS) & 1))
> +				break;
> +			msleep_interruptible(0);
> +		}
> +	}
> +	return i ? 0 : -ETIMEDOUT;
> +}
> +
> +int pt3_thread(void *dat)
> +{
> +	struct ptx_adap	*adap	= dat;
> +	struct pt3_adap	*p	= adap->priv;
> +	struct pt3_dma	*ts;
> +
> +	set_freezable();
> +	while (!kthread_should_stop()) {
> +		u32 next = (p->ts_blk_idx + 1) % p->ts_blk_cnt;
> +
> +		try_to_freeze();
> +		ts = p->ts_info + next;
> +		if (*ts->dat != PTX_TS_SYNC) {		/* wait until 1 TS block is full */
> +			schedule_timeout_interruptible(0);
> +			continue;
> +		}
> +		ts = p->ts_info + p->ts_blk_idx;
> +		dvb_dmx_swfilter_packets(&adap->demux, ts->dat, ts->sz / PTX_TS_SIZE);
> +		*ts->dat	= PTX_TS_NOT_SYNC;	/* mark as read */
> +		p->ts_blk_idx	= next;
> +	}
> +	return 0;
> +}
> +
> +void pt3_remove(struct pci_dev *pdev)
> +{
> +	struct ptx_card	*card	= pci_get_drvdata(pdev);
> +	struct pt3_card	*c;
> +	struct ptx_adap	*adap;
> +	int		i;
> +
> +	if (!card)
> +		return;
> +	c	= card->priv;
> +	adap	= card->adap;
> +	for (i = 0; i < card->adapn; i++, adap++) {
> +		struct pt3_adap	*p	= adap->priv;
> +		struct pt3_dma	*page;
> +		u32		j;
> +
> +		pt3_dma_run(adap, false);
> +		if (p->ts_info) {
> +			for (j = 0; j < p->ts_blk_cnt; j++) {
> +				page = &p->ts_info[j];
> +				if (page->dat)
> +					pci_free_consistent(adap->card->pdev, page->sz, page->dat, page->adr);
> +			}
> +			kfree(p->ts_info);
> +		}
> +		if (p->desc_info) {
> +			for (j = 0; j < p->desc_pg_cnt; j++) {
> +				page = &p->desc_info[j];
> +				if (page->dat)
> +					pci_free_consistent(adap->card->pdev, page->sz, page->dat, page->adr);
> +			}
> +			kfree(p->desc_info);
> +		}
> +		if (adap->fe) {
> +			ptx_sleep(adap->fe);
> +			pt3_power(adap->fe, PT3_PWR_OFF);
> +		}
> +	}
> +	ptx_unregister_adap(card);
> +	if (c->bar_reg)
> +		iounmap(c->bar_reg);
> +	if (c->bar_mem)
> +		iounmap(c->bar_mem);
> +}
> +
> +int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct ptx_adap	*adap;
> +	struct pt3_card	*c;
> +	struct ptx_subdev_info	pt3_subdev_info[] = {
> +		{SYS_ISDBS, 0b00010001, TC90522_MODNAME, 0x63, QM1D1C004X_MODNAME},
> +		{SYS_ISDBS, 0b00010011, TC90522_MODNAME, 0x60, QM1D1C004X_MODNAME},
> +		{SYS_ISDBT, 0b00010000, TC90522_MODNAME, 0x62, MXL301RF_MODNAME},
> +		{SYS_ISDBT, 0b00010010, TC90522_MODNAME, 0x61, MXL301RF_MODNAME},
> +	};
> +	struct ptx_card	*card	= ptx_alloc(pdev, KBUILD_MODNAME, ARRAY_SIZE(pt3_subdev_info),
> +					sizeof(struct pt3_card), sizeof(struct pt3_adap), pt3_lnb);
> +
> +	bool dma_create(struct pt3_adap	*p)
> +	{
> +		struct dma_desc {
> +			u64 page_addr;
> +			u32 page_size;
> +			u64 next_desc;
> +		} __packed;		/* 20B */
> +		enum {
> +			DESC_SZ		= sizeof(struct dma_desc),		/* 20B	*/
> +			DESC_MAX	= 4096 / DESC_SZ,			/* 204	*/
> +			DESC_PAGE_SZ	= DESC_MAX * DESC_SZ,			/* 4080	*/
> +			TS_PAGE_CNT	= PTX_TS_SIZE / 4,			/* 47	*/
> +			TS_BLOCK_CNT	= 17,
> +		};
> +		struct pt3_dma	*descinfo;
> +		struct dma_desc	*prev		= NULL,
> +				*curr		= NULL;
> +		u32		i,
> +				j,
> +				desc_todo	= 0,
> +				desc_pg_idx	= 0;
> +		u64		desc_addr	= 0;
> +
> +		p->ts_blk_cnt	= TS_BLOCK_CNT;							/* 17	*/
> +		p->desc_pg_cnt	= roundup(TS_PAGE_CNT * p->ts_blk_cnt, DESC_MAX);		/* 4	*/
> +		p->ts_info	= kcalloc(p->ts_blk_cnt, sizeof(struct pt3_dma), GFP_KERNEL);
> +		p->desc_info	= kcalloc(p->desc_pg_cnt, sizeof(struct pt3_dma), GFP_KERNEL);
> +		if (!p->ts_info || !p->desc_info)
> +			return false;
> +		for (i = 0; i < p->desc_pg_cnt; i++) {						/* 4	*/
> +			p->desc_info[i].sz	= DESC_PAGE_SZ;					/* 4080B, max 204 * 4 = 816 descs */
> +			p->desc_info[i].dat	= pci_alloc_consistent(card->pdev, p->desc_info[i].sz, &p->desc_info[i].adr);
> +			if (!p->desc_info[i].dat)
> +				return false;
> +			memset(p->desc_info[i].dat, 0, p->desc_info[i].sz);
> +		}
> +		for (i = 0; i < p->ts_blk_cnt; i++) {						/* 17	*/
> +			p->ts_info[i].sz	= DESC_PAGE_SZ * TS_PAGE_CNT;			/* 1020 pkts, 4080 * 47 = 191760B, total 3259920B */
> +			p->ts_info[i].dat	= pci_alloc_consistent(card->pdev, p->ts_info[i].sz, &p->ts_info[i].adr);
> +			if (!p->ts_info[i].dat)
> +				return false;
> +			for (j = 0; j < TS_PAGE_CNT; j++) {					/* 47, total 47 * 17 = 799 pages */
> +				if (!desc_todo) {						/* 20	*/
> +					descinfo	= p->desc_info + desc_pg_idx;		/* jump to next desc_pg */
> +					curr		= (struct dma_desc *)descinfo->dat;
> +					desc_addr	= descinfo->adr;
> +					desc_todo	= DESC_MAX;				/* 204	*/
> +					desc_pg_idx++;
> +				}
> +				if (prev)
> +					prev->next_desc = desc_addr;
> +				curr->page_addr = p->ts_info[i].adr + DESC_PAGE_SZ * j;
> +				curr->page_size = DESC_PAGE_SZ;
> +				curr->next_desc = p->desc_info->adr;				/* circular link */
> +				prev		= curr;
> +				curr++;
> +				desc_addr	+= DESC_SZ;
> +				desc_todo--;
> +			}
> +		}
> +		return true;
> +	}
> +
> +	u8	i;
> +	int	ret	= !card || pci_read_config_byte(pdev, PCI_CLASS_REVISION, &i);
> +
> +	if (ret)
> +		return ptx_abort(pdev, pt3_remove, ret, "PCI/DMA/memory error");
> +	if (i != 1)
> +		return ptx_abort(pdev, pt3_remove, -ENOTSUPP, "PCI Rev%d not supported", i);
> +	pci_set_master(pdev);
> +	c		= card->priv;
> +	c->bar_reg	= pci_ioremap_bar(pdev, 0);
> +	c->bar_mem	= pci_ioremap_bar(pdev, 2);
> +	if (!c->bar_reg || !c->bar_mem)
> +		return ptx_abort(pdev, pt3_remove, -EIO, "Failed pci_ioremap_bar");
> +	ret = (readl(c->bar_reg + PT3_REG_VERSION) >> 8) & 0xFF00FF;
> +	if (ret != 0x030004)
> +		return ptx_abort(pdev, pt3_remove, -ENOTSUPP, "PT%d FPGA v%d not supported", ret >> 16, ret & 0xFF);
> +	for (i = 0, adap = card->adap; i < card->adapn; i++, adap++) {
> +		struct pt3_adap	*p	= adap->priv;
> +
> +		p->dma_base	= c->bar_reg + PT3_DMA_BASE + PT3_DMA_OFFSET * i;
> +		if (!dma_create(p))
> +			return ptx_abort(pdev, pt3_remove, -ENOMEM, "Failed dma_create");
> +	}
> +	adap--;
> +	ret =	ptx_i2c_add_adapter(card, &pt3_i2c_algo)				||
> +		pt3_i2c_flush(c, 0)							||
> +		ptx_register_adap(card, pt3_subdev_info, pt3_thread, pt3_dma_run)	||
> +		pt3_power(adap->fe, PT3_PWR_TUNER_ON)					||
> +		pt3_i2c_flush(c, PT3_I2C_START_ADDR)					||
> +		pt3_power(adap->fe, PT3_PWR_TUNER_ON | PT3_PWR_AMP_ON);
> +	return	ret ?
> +		ptx_abort(pdev, pt3_remove, ret, "Unable to register I2C/DVB adapter/frontend") :
> +		0;
> +}
> +
> +static struct pci_driver pt3_driver = {
> +	.name		= KBUILD_MODNAME,
> +	.id_table	= pt3_id,
> +	.probe		= pt3_probe,
> +	.remove		= pt3_remove,
> +};
> +module_pci_driver(pt3_driver);
> +
> diff --git a/drivers/media/pci/ptx/ptx_common.c b/drivers/media/pci/ptx/ptx_common.c
> new file mode 100644
> index 0000000..75cae15
> --- /dev/null
> +++ b/drivers/media/pci/ptx/ptx_common.c
> @@ -0,0 +1,266 @@
> +/*
> +	Registration procedures for PT3, PX-Q3PE, PX-BCUD and other DVB drivers
> +
> +	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
> +*/
> +
> +#include "ptx_common.h"
> +
> +MODULE_AUTHOR(PTX_AUTH);
> +MODULE_DESCRIPTION("Common DVB registration procedures");
> +MODULE_LICENSE("GPL");
> +
> +void ptx_lnb(struct ptx_card *card)
> +{
> +	struct ptx_adap	*adap;
> +	int	i;
> +	bool	lnb = false;
> +
> +	for (i = 0, adap = card->adap; adap->fe && i < card->adapn; i++, adap++)
> +		if (adap->fe->dtv_property_cache.delivery_system == SYS_ISDBS && adap->ON) {
> +			lnb = true;
> +			break;
> +	}
> +	if (card->lnbON != lnb) {
> +		card->lnb(card, lnb);
> +		card->lnbON = lnb;
> +	}
> +}
> +
> +int ptx_sleep(struct dvb_frontend *fe)
> +{
> +	struct ptx_adap	*adap	= container_of(fe->dvb, struct ptx_adap, dvb);
> +
> +	adap->ON = false;
> +	ptx_lnb(adap->card);
> +	return adap->fe_sleep ? adap->fe_sleep(fe) : 0;
> +}
> +
> +int ptx_wakeup(struct dvb_frontend *fe)
> +{
> +	struct ptx_adap	*adap	= container_of(fe->dvb, struct ptx_adap, dvb);
> +
> +	adap->ON = true;
> +	ptx_lnb(adap->card);
> +	return adap->fe_wakeup ? adap->fe_wakeup(fe) : 0;
> +}
> +
> +int ptx_stop_feed(struct dvb_demux_feed *feed)
> +{
> +	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
> +
> +	adap->card->dma(adap, false);
> +	if (adap->kthread)
> +		kthread_stop(adap->kthread);
> +	return 0;
> +}
> +
> +int ptx_start_feed(struct dvb_demux_feed *feed)
> +{
> +	struct ptx_adap	*adap	= container_of(feed->demux, struct ptx_adap, demux);
> +
> +	if (adap->card->thread)
> +		adap->kthread = kthread_run(adap->card->thread, adap, "%s_%d%c", adap->dvb.name, adap->dvb.num,
> +					adap->fe->dtv_property_cache.delivery_system == SYS_ISDBS ? 's' : 't');
> +	return IS_ERR(adap->kthread) ? PTR_ERR(adap->kthread) : adap->card->dma(adap, true);
> +}
> +
> +struct ptx_card *ptx_alloc(struct pci_dev *pdev, u8 *name, u8 adapn, u32 sz_card_priv, u32 sz_adap_priv,
> +			void (*lnb)(struct ptx_card *, bool))
> +{
> +	u8 i;
> +	struct ptx_card *card = kzalloc(sizeof(struct ptx_card) + sz_card_priv + adapn *
> +					(sizeof(struct ptx_adap) + sz_adap_priv), GFP_KERNEL);
> +	if (!card)
> +		return NULL;
> +	card->priv	= sz_card_priv ? &card[1] : NULL;
> +	card->adap	= (struct ptx_adap *)((u8 *)&card[1] + sz_card_priv);
> +	card->pdev	= pdev;
> +	card->adapn	= adapn;
> +	card->name	= name;
> +	card->lnbON	= true;
> +	card->lnb	= lnb;
> +	for (i = 0; i < card->adapn; i++) {
> +		struct ptx_adap *p = &card->adap[i];
> +
> +		p->card	= card;
> +		p->priv	= sz_adap_priv ? (u8 *)&card->adap[card->adapn] + i * sz_adap_priv : NULL;
> +	}
> +	if (pci_enable_device(pdev)					||
> +		pci_set_dma_mask(pdev, DMA_BIT_MASK(32))		||
> +		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))	||
> +		pci_request_regions(pdev, name)) {
> +		kfree(card);
> +		return NULL;
> +	}
> +	pci_set_drvdata(pdev, card);
> +	return card;
> +}
> +
> +int ptx_i2c_add_adapter(struct ptx_card *card, const struct i2c_algorithm *algo)
> +{
> +	struct i2c_adapter *i2c = &card->i2c;
> +
> +	i2c->algo	= algo;
> +	i2c->dev.parent	= &card->pdev->dev;
> +	strcpy(i2c->name, card->name);
> +	i2c_set_adapdata(i2c, card);
> +	mutex_init(&card->lock);
> +	return	i2c_add_adapter(i2c);
> +}
> +
> +void ptx_unregister_subdev(struct i2c_client *c)
> +{
> +	if (!c)
> +		return;
> +	if (c->dev.driver)
> +		module_put(c->dev.driver->owner);
> +	i2c_unregister_device(c);
> +}
> +
> +struct i2c_client *ptx_register_subdev(struct i2c_adapter *i2c, struct dvb_frontend *fe, u16 adr, char *name)
> +{
> +	struct i2c_client	*c;
> +	struct i2c_board_info	info = {
> +		.platform_data	= fe,
> +		.addr		= adr,
> +	};
> +
> +	strlcpy(info.type, name, I2C_NAME_SIZE);
> +	request_module("%s", info.type);
> +	c = i2c_new_device(i2c, &info);
> +	if (!c)
> +		return NULL;
> +	if (c->dev.driver && try_module_get(c->dev.driver->owner))
> +		return c;
> +	ptx_unregister_subdev(c);
> +	return NULL;
> +}
> +
> +void ptx_unregister_fe(struct dvb_frontend *fe)
> +{
> +	if (!fe)
> +		return;
> +	if (fe->frontend_priv)
> +		dvb_unregister_frontend(fe);
> +	ptx_unregister_subdev(fe->tuner_priv);
> +	ptx_unregister_subdev(fe->demodulator_priv);
> +	kfree(fe);
> +}
> +
> +struct dvb_frontend *ptx_register_fe(struct i2c_adapter *i2c, struct dvb_adapter *dvb, const struct ptx_subdev_info *info)
> +{
> +	struct dvb_frontend *fe = kzalloc(sizeof(struct dvb_frontend), GFP_KERNEL);
> +
> +	if (!fe)
> +		return	NULL;
> +	fe->demodulator_priv	= ptx_register_subdev(i2c, fe, info->demod_addr, info->demod_name);
> +	fe->tuner_priv		= ptx_register_subdev(i2c, fe, info->tuner_addr, info->tuner_name);
> +	if (info->type)
> +		fe->ops.delsys[0] = info->type;
> +	if (!fe->demodulator_priv || !fe->tuner_priv || (dvb && dvb_register_frontend(dvb, fe))) {
> +		ptx_unregister_fe(fe);
> +		return	NULL;
> +	}
> +	return fe;
> +}
> +
> +void ptx_unregister_adap(struct ptx_card *card)
> +{
> +	int		i	= card->adapn - 1;
> +	struct ptx_adap	*adap	= card->adap + i;
> +
> +	for (; i >= 0; i--, adap--) {
> +		ptx_unregister_fe(adap->fe);
> +		if (adap->demux.dmx.close)
> +			adap->demux.dmx.close(&adap->demux.dmx);
> +		if (adap->dmxdev.filter)
> +			dvb_dmxdev_release(&adap->dmxdev);
> +		if (adap->demux.cnt_storage)
> +			dvb_dmx_release(&adap->demux);
> +		if (adap->dvb.name)
> +			dvb_unregister_adapter(&adap->dvb);
> +	}
> +	i2c_del_adapter(&card->i2c);
> +	pci_release_regions(card->pdev);
> +	pci_set_drvdata(card->pdev, NULL);
> +	pci_disable_device(card->pdev);
> +	kfree(card);
> +}
> +
> +int ptx_register_adap(struct ptx_card *card, const struct ptx_subdev_info *info,
> +			int (*thread)(void *), int (*dma)(struct ptx_adap *, bool))
> +{
> +	struct ptx_adap	*adap;
> +	short	adap_no[DVB_MAX_ADAPTERS] = {};
> +	u8	i;
> +	int	err;
> +
> +	card->thread	= thread;
> +	card->dma	= dma;
> +	for (i = 0, adap = card->adap; i < card->adapn; i++, adap++) {
> +		struct dvb_adapter	*dvb	= &adap->dvb;
> +		struct dvb_demux	*demux	= &adap->demux;
> +		struct dmxdev		*dmxdev	= &adap->dmxdev;
> +
> +		if (dvb_register_adapter(dvb, card->name, THIS_MODULE, &card->pdev->dev, adap_no) < 0)
> +			return -ENFILE;
> +		demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
> +		demux->feednum		= 1;
> +		demux->filternum	= 1;
> +		demux->start_feed	= ptx_start_feed;
> +		demux->stop_feed	= ptx_stop_feed;
> +		if (dvb_dmx_init(demux) < 0)
> +			return -ENOMEM;
> +		dmxdev->filternum	= 1;
> +		dmxdev->demux		= &demux->dmx;
> +		err			= dvb_dmxdev_init(dmxdev, dvb);
> +		if (err)
> +			return err;
> +		adap->fe		= ptx_register_fe(&adap->card->i2c, &adap->dvb, &info[i]);
> +		if (!adap->fe)
> +			return -ENOMEM;
> +		adap->fe_sleep		= adap->fe->ops.sleep;
> +		adap->fe_wakeup		= adap->fe->ops.init;
> +		adap->fe->ops.sleep	= ptx_sleep;
> +		adap->fe->ops.init	= ptx_wakeup;
> +		ptx_sleep(adap->fe);
> +	}
> +	return 0;
> +}
> +
> +int ptx_abort(struct pci_dev *pdev, void remover(struct pci_dev *), int err, char *fmt, ...)
> +{
> +	va_list	ap;
> +	char	*s = NULL;
> +	int	slen;
> +
> +	va_start(ap, fmt);
> +	slen	= vsnprintf(s, 0, fmt, ap) + 1;
> +	s	= kzalloc(slen, GFP_ATOMIC);
> +	if (s) {
> +		vsnprintf(s, slen, fmt, ap);
> +		dev_err(&pdev->dev, "%s", s);
> +		kfree(s);
> +	}
> +	va_end(ap);
> +	remover(pdev);
> +	return err;
> +}
> +
> +u32 ptx_i2c_func(struct i2c_adapter *i2c)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_NOSTART;
> +}
> +
> +EXPORT_SYMBOL(ptx_alloc);
> +EXPORT_SYMBOL(ptx_sleep);
> +EXPORT_SYMBOL(ptx_wakeup);
> +EXPORT_SYMBOL(ptx_i2c_add_adapter);
> +EXPORT_SYMBOL(ptx_unregister_fe);
> +EXPORT_SYMBOL(ptx_register_fe);
> +EXPORT_SYMBOL(ptx_unregister_adap);
> +EXPORT_SYMBOL(ptx_register_adap);
> +EXPORT_SYMBOL(ptx_abort);
> +EXPORT_SYMBOL(ptx_i2c_func);
> +
> diff --git a/drivers/media/pci/ptx/ptx_common.h b/drivers/media/pci/ptx/ptx_common.h
> new file mode 100644
> index 0000000..444b4b8
> --- /dev/null
> +++ b/drivers/media/pci/ptx/ptx_common.h
> @@ -0,0 +1,76 @@
> +/*
> +	Definitions & prototypes for PT3, PX-Q3PE, PX-BCUD and other DVB drivers
> +
> +	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
> +
> +	This program is distributed in hope that it will be useful,
> +	but WITHOUT ANY WARRANTY; without even the implied warranty of
> +	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +	GNU General Public License for more details.
> +*/
> +
> +#ifndef	PTX_COMMON_H
> +#define PTX_COMMON_H
> +
> +#include <linux/freezer.h>
> +#include <linux/kthread.h>
> +#include <linux/pci.h>
> +#include "dvb_demux.h"
> +#include "dvb_frontend.h"
> +#include "dmxdev.h"
> +
> +#define PTX_AUTH "Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>"
> +
> +enum ePTX {
> +	PTX_TS_SIZE	= 188,
> +	PTX_TS_SYNC	= 0x47,
> +	PTX_TS_NOT_SYNC	= 0x74,
> +};
> +
> +struct ptx_subdev_info {
> +	enum fe_delivery_system	type;
> +	u8	demod_addr,	*demod_name,
> +		tuner_addr,	*tuner_name;
> +};
> +
> +struct ptx_card {
> +	struct ptx_adap		*adap;
> +	struct mutex		lock;
> +	struct i2c_adapter	i2c;
> +	struct pci_dev		*pdev;
> +	u8	*name,
> +		adapn;
> +	bool	lnbON;
> +	void	*priv,
> +		(*lnb)(struct ptx_card *card, bool lnb);
> +	int	(*thread)(void *dat),
> +		(*dma)(struct ptx_adap *adap, bool ON);
> +};
> +
> +struct ptx_adap {
> +	struct ptx_card		*card;
> +	bool			ON;
> +	struct dvb_adapter	dvb;
> +	struct dvb_demux	demux;
> +	struct dmxdev		dmxdev;
> +	struct dvb_frontend	*fe;
> +	struct task_struct	*kthread;
> +	void			*priv;
> +	int	(*fe_sleep)(struct dvb_frontend *),
> +		(*fe_wakeup)(struct dvb_frontend *);
> +};
> +
> +struct ptx_card *ptx_alloc(struct pci_dev *pdev, u8 *name, u8 adapn, u32 sz_card_priv, u32 sz_adap_priv,
> +			void (*lnb)(struct ptx_card *, bool));
> +int ptx_sleep(struct dvb_frontend *fe);
> +int ptx_wakeup(struct dvb_frontend *fe);
> +int ptx_i2c_add_adapter(struct ptx_card *card, const struct i2c_algorithm *algo);
> +void ptx_unregister_fe(struct dvb_frontend *fe);
> +struct dvb_frontend *ptx_register_fe(struct i2c_adapter *i2c, struct dvb_adapter *dvb, const struct ptx_subdev_info *info);
> +void ptx_unregister_adap(struct ptx_card *card);
> +int ptx_register_adap(struct ptx_card *card, const struct ptx_subdev_info *info,
> +			int (*thread)(void *), int (*dma)(struct ptx_adap *, bool));
> +int ptx_abort(struct pci_dev *pdev, void remover(struct pci_dev *), int err, char *fmt, ...);
> +u32 ptx_i2c_func(struct i2c_adapter *i2c);

You should add stubs to be used when this driver is not selected. See other
demods/tuners headers for examples on how to do it.

> +
> +#endif
> diff --git a/drivers/media/pci/ptx/pxq3pe.c b/drivers/media/pci/ptx/pxq3pe.c
> new file mode 100644
> index 0000000..16c2aba
> --- /dev/null
> +++ b/drivers/media/pci/ptx/pxq3pe.c
> @@ -0,0 +1,588 @@
> +/*
> +	DVB driver for PLEX PX-Q3PE ISDB-S/T PCIE receiver
> +
> +	Copyright (C) Budi Rachmanto, AreMa Inc. <info@are.ma>
> +
> +	Main components:
> +	ASIE5606X8	- controller
> +	TC90522		- 2ch OFDM ISDB-T + 2ch 8PSK ISDB-S demodulator
> +	TDA20142	- ISDB-S tuner
> +	NM120		- ISDB-T tuner
> +*/
> +
> +#include <linux/interrupt.h>
> +#include <linux/vmalloc.h>
> +#include "ptx_common.h"
> +#include "tc90522.h"
> +#include "tda2014x.h"
> +#include "nm131.h"
> +
> +MODULE_AUTHOR(PTX_AUTH);
> +MODULE_DESCRIPTION("PLEX PX-Q3PE Driver");
> +MODULE_LICENSE("GPL");
> +
> +static char	*auth	= PTX_AUTH;
> +static int	ni,
> +		nx,
> +		idx[8]	= {},
> +		xor[4]	= {};
> +module_param(auth, charp, 0);
> +module_param_array(idx, int, &ni, 0);
> +module_param_array(xor, int, &nx, 0);
> +
> +static struct pci_device_id pxq3pe_id_table[] = {
> +	{0x188B, 0x5220, 0x0B06, 0x0002, 0, 0, 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, pxq3pe_id_table);
> +
> +enum ePXQ3PE {
> +	PKT_NUM		= 312,
> +	PKT_BUFSZ	= PTX_TS_SIZE * PKT_NUM,
> +
> +	PXQ3PE_MOD_GPIO		= 0,
> +	PXQ3PE_MOD_TUNER	= 1,
> +	PXQ3PE_MOD_STAT		= 2,
> +
> +	PXQ3PE_IRQ_STAT		= 0x808,
> +	PXQ3PE_IRQ_CLEAR	= 0x80C,
> +	PXQ3PE_IRQ_ACTIVE	= 0x814,
> +	PXQ3PE_IRQ_DISABLE	= 0x818,
> +	PXQ3PE_IRQ_ENABLE	= 0x81C,
> +
> +	PXQ3PE_I2C_ADR_GPIO	= 0x4A,
> +	PXQ3PE_I2C_CTL_STAT	= 0x940,
> +	PXQ3PE_I2C_ADR		= 0x944,
> +	PXQ3PE_I2C_SW_CTL	= 0x948,
> +	PXQ3PE_I2C_FIFO_STAT	= 0x950,
> +	PXQ3PE_I2C_FIFO_DATA	= 0x960,
> +
> +	PXQ3PE_DMA_OFFSET_PORT	= 0x140,
> +	PXQ3PE_DMA_TSMODE	= 0xA00,
> +	PXQ3PE_DMA_MGMT		= 0xAE0,
> +	PXQ3PE_DMA_OFFSET_CH	= 0x10,
> +	PXQ3PE_DMA_ADR_LO	= 0xAC0,
> +	PXQ3PE_DMA_ADR_HI	= 0xAC4,
> +	PXQ3PE_DMA_XFR_STAT	= 0xAC8,
> +	PXQ3PE_DMA_CTL		= 0xACC,
> +
> +	PXQ3PE_MAX_LOOP		= 1000,
> +};
> +
> +struct pxq3pe_card {
> +	void __iomem		*bar;
> +	struct {
> +		dma_addr_t	adr;
> +		u8		*dat;
> +		u32		sz;
> +		bool		ON[2];
> +	} dma;
> +};
> +
> +struct pxq3pe_adap {
> +	u8	tBuf[PKT_BUFSZ],
> +		*sBuf;
> +	u32	tBufIdx,
> +		sBufSize,
> +		sBufStart,
> +		sBufStop,
> +		sBufByteCnt;
> +};
> +
> +bool pxq3pe_i2c_clean(struct ptx_card *card)
> +{
> +	struct pxq3pe_card	*c	= card->priv;
> +	void __iomem		*bar	= c->bar;
> +
> +	if ((readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F) != 0x10 || readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00) {
> +		u32 stat = readl(bar + PXQ3PE_I2C_SW_CTL) | 0x20;
> +
> +		writel(stat, bar + PXQ3PE_I2C_SW_CTL);
> +		writel(stat & 0xFFFFFFDF, bar + PXQ3PE_I2C_SW_CTL);
> +		if ((readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F) != 0x10) {
> +			dev_err(&card->pdev->dev, "%s FIFO error", __func__);
> +			return false;
> +		}
> +	}
> +	writel(0, bar + PXQ3PE_I2C_CTL_STAT);
> +	return true;
> +}
> +
> +bool pxq3pe_w(struct ptx_card *card, u8 slvadr, u8 regadr, u8 *wdat, u8 bytelen, u8 mode)
> +{
> +	struct pxq3pe_card	*c	= card->priv;
> +	void __iomem		*bar	= c->bar;
> +	int	i,
> +		j,
> +		k;
> +	u8	i2cCtlByte,
> +		i2cFifoWSz;
> +
> +	if (!pxq3pe_i2c_clean(card))
> +		return false;
> +	switch (mode) {
> +	case PXQ3PE_MOD_GPIO:
> +		i2cCtlByte = 0xC0;
> +		break;
> +	case PXQ3PE_MOD_TUNER:
> +		regadr = 0;
> +		i2cCtlByte = 0x80;
> +		break;
> +	case PXQ3PE_MOD_STAT:
> +		regadr = 0;
> +		i2cCtlByte = 0x84;
> +		break;
> +	default:
> +		return false;
> +	}
> +	writel((slvadr << 8) + regadr, bar + PXQ3PE_I2C_ADR);
> +	for (i = 0; i < 16 && i < bytelen; i += 4) {
> +		udelay(1000);
> +		writel(*((u32 *)(wdat + i)), bar + PXQ3PE_I2C_FIFO_DATA);
> +	}
> +	writew((bytelen << 8) + i2cCtlByte, bar + PXQ3PE_I2C_CTL_STAT);
> +	for (j = 0; j < PXQ3PE_MAX_LOOP; j++) {
> +		if (i < bytelen) {
> +			i2cFifoWSz = readb(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F;
> +			for (k = 0; bytelen > 16 && k < PXQ3PE_MAX_LOOP && i2cFifoWSz < bytelen - 16; k++) {
> +				i2cFifoWSz = readb(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F;
> +				udelay(1000);
> +			}
> +			if (i2cFifoWSz & 3)
> +				continue;
> +			if (i2cFifoWSz) {
> +				for (k = i; k < bytelen && k - i < i2cFifoWSz; k += 4)
> +					writel(*((u32 *)(wdat + k)), bar + PXQ3PE_I2C_FIFO_DATA);
> +				i = k;
> +			}
> +		}
> +		udelay(10);
> +		if (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0x400000)
> +			break;
> +	}
> +	return j < PXQ3PE_MAX_LOOP ? !(readl(bar + PXQ3PE_I2C_CTL_STAT) & 0x280000) : false;
> +}
> +
> +bool pxq3pe_r(struct ptx_card *card, u8 slvadr, u8 regadr, u8 *rdat, u8 bytelen, u8 mode)
> +{
> +	struct pxq3pe_card	*c	= card->priv;
> +	void __iomem		*bar	= c->bar;
> +	u8	i2cCtlByte,
> +		i2cStat,
> +		i2cFifoRSz,
> +		i2cByteCnt;
> +	int	i		= 0,
> +		j,
> +		idx;
> +	bool	ret		= false;
> +
> +	if (!pxq3pe_i2c_clean(card))
> +		return false;
> +	switch (mode) {
> +	case PXQ3PE_MOD_GPIO:
> +		i2cCtlByte = 0xE0;
> +		break;
> +	case PXQ3PE_MOD_TUNER:
> +		regadr = 0;
> +		i2cCtlByte = 0xA0;
> +		break;
> +	default:
> +		return false;
> +	}
> +	writel((slvadr << 8) + regadr, bar + PXQ3PE_I2C_ADR);
> +	writew(i2cCtlByte + (bytelen << 8), bar + PXQ3PE_I2C_CTL_STAT);
> +	i2cByteCnt = bytelen;
> +	j = 0;
> +	while (j < PXQ3PE_MAX_LOOP) {
> +		udelay(10);
> +		i2cStat = (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0xFF0000) >> 16;
> +		if (i2cStat & 0x80) {
> +			if (i2cStat & 0x28)
> +				break;
> +			ret = true;
> +		}
> +		i2cFifoRSz = (readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00) >> 8;
> +		if (i2cFifoRSz & 3) {
> +			++j;
> +			continue;
> +		}
> +		for (idx = i; i2cFifoRSz && idx < i2cByteCnt && idx - i < i2cFifoRSz; idx += 4)
> +			*(u32 *)(rdat + idx) = readl(bar + PXQ3PE_I2C_FIFO_DATA);
> +		i = idx;
> +		if (i < bytelen) {
> +			if (i2cFifoRSz)
> +				i2cByteCnt -= i2cFifoRSz;
> +			else
> +				++j;
> +			continue;
> +		}
> +		i2cStat = (readl(bar + PXQ3PE_I2C_CTL_STAT) & 0xFF0000) >> 16;
> +		if (i2cStat & 0x80) {
> +			if (i2cStat & 0x28)
> +				break;
> +			ret = true;
> +			break;
> +		}
> +		++j;
> +	}
> +	return !(readl(bar + PXQ3PE_I2C_FIFO_STAT) & 0x1F00) && ret;
> +}
> +
> +int pxq3pe_xfr(struct i2c_adapter *i2c, struct i2c_msg *msg, int sz)
> +{
> +	struct ptx_card	*card	= i2c_get_adapdata(i2c);
> +	u8		i;
> +	bool		ret	= true;
> +
> +	if (!i2c || !card || !msg)
> +		return -EINVAL;
> +	for (i = 0; i < sz && ret; i++, msg++) {
> +		u8	slvadr	= msg->addr,
> +			regadr	= msg->len ? *msg->buf : 0,
> +			mode	= slvadr == PXQ3PE_I2C_ADR_GPIO	? PXQ3PE_MOD_GPIO
> +				: sz > 1 && i == sz - 2		? PXQ3PE_MOD_STAT
> +				: PXQ3PE_MOD_TUNER;
> +
> +		mutex_lock(&card->lock);
> +		if (msg->flags & I2C_M_RD) {
> +			u8 *buf	= kzalloc(sz, GFP_KERNEL);
> +
> +			if (!buf)
> +				return -ENOMEM;
> +			ret	= pxq3pe_r(card, slvadr, regadr, buf, msg->len, mode);
> +			memcpy(msg->buf, buf, msg->len);
> +			kfree(buf);
> +		} else
> +			ret = pxq3pe_w(card, slvadr, regadr, msg->buf, msg->len, mode);
> +		mutex_unlock(&card->lock);
> +	}
> +	return i;
> +}
> +
> +bool pxq3pe_w_gpio2(struct ptx_card *card, u8 dat, u8 mask)
> +{
> +	u8 val;
> +
> +	return	pxq3pe_r(card, PXQ3PE_I2C_ADR_GPIO, 0xB, &val, 1, PXQ3PE_MOD_GPIO)	&&
> +		(val = (mask & dat) | (val & ~mask), pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0xB, &val, 1, PXQ3PE_MOD_GPIO));
> +}
> +
> +void pxq3pe_w_gpio1(struct ptx_card *card, u8 dat, u8 mask)
> +{
> +	struct pxq3pe_card *c = card->priv;
> +
> +	mask <<= 3;
> +	writeb((readb(c->bar + 0x890) & ~mask) | ((dat << 3) & mask), c->bar + 0x890);
> +}
> +
> +void pxq3pe_w_gpio0(struct ptx_card *card, u8 dat, u8 mask)
> +{
> +	struct pxq3pe_card *c = card->priv;
> +
> +	writeb((-(mask & 1) & 4 & -(dat & 1)) | (readb(c->bar + 0x890) & ~(-(mask & 1) & 4)), c->bar + 0x890);
> +	writeb((mask & dat) | (readb(c->bar + 0x894) & ~mask), c->bar + 0x894);
> +}
> +
> +void pxq3pe_power(struct ptx_card *card, bool ON)
> +{
> +	if (ON) {
> +		pxq3pe_w_gpio0(card, 1, 1);
> +		pxq3pe_w_gpio0(card, 0, 1);
> +		pxq3pe_w_gpio0(card, 1, 1);
> +		pxq3pe_w_gpio1(card, 1, 1);
> +		pxq3pe_w_gpio1(card, 0, 1);
> +		pxq3pe_w_gpio2(card, 2, 2);
> +		pxq3pe_w_gpio2(card, 0, 2);
> +		pxq3pe_w_gpio2(card, 2, 2);
> +		pxq3pe_w_gpio2(card, 4, 4);
> +		pxq3pe_w_gpio2(card, 0, 4);
> +		pxq3pe_w_gpio2(card, 4, 4);
> +	} else {
> +		pxq3pe_w_gpio0(card, 0, 1);
> +		pxq3pe_w_gpio0(card, 1, 1);
> +		pxq3pe_w_gpio1(card, 1, 1);
> +	}
> +}
> +
> +irqreturn_t pxq3pe_irq(int irq, void *ctx)
> +{
> +	struct ptx_card		*card	= ctx;
> +	struct pxq3pe_card	*c	= card->priv;
> +	void __iomem		*bar	= c->bar;
> +	u32	dmamgmt,
> +		i,
> +		irqstat = readl(bar + PXQ3PE_IRQ_STAT);
> +	bool	ch	= irqstat & 0b0101 ? 0 : 1,
> +		port	= irqstat & 0b0011 ? 0 : 1;
> +	u8	*tbuf	= c->dma.dat + PKT_BUFSZ * (port * 2 + ch);
> +
> +	void pxq3pe_dma_put_stream(struct pxq3pe_adap *p)
> +	{
> +		u8	*src	= p->tBuf;
> +		u32	len	= p->tBufIdx,
> +			savesz	= len <= p->sBufSize - p->sBufStop ? len : p->sBufSize - p->sBufStop,
> +			remain	= len - savesz;
> +
> +		memcpy(&p->sBuf[p->sBufStop], src, savesz);
> +		if (remain)
> +			memcpy(p->sBuf, &src[savesz], remain);
> +		p->sBufStop = (p->sBufStop + len) % p->sBufSize;
> +		if (p->sBufByteCnt == p->sBufSize)
> +			p->sBufStart = p->sBufStop;
> +		else {
> +			if (p->sBufSize >= p->sBufByteCnt + len)
> +				p->sBufByteCnt += len;
> +			else {
> +				p->sBufStart = p->sBufStop;
> +				p->sBufByteCnt = p->sBufSize;
> +			}
> +		}
> +	}
> +
> +	if (!(irqstat & 0b1111))
> +		return IRQ_HANDLED;
> +	writel(irqstat, bar + PXQ3PE_IRQ_CLEAR);
> +	dmamgmt = readl(bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +	if ((readl(bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * ch + PXQ3PE_DMA_XFR_STAT) & 0x3FFFFF) == PKT_BUFSZ)
> +		for (i = 0; i < PKT_BUFSZ; i += PTX_TS_SIZE) {
> +			u8 idx = !port * 4 + (tbuf[i] == 0xC7 ? 0 : tbuf[i] == 0x47 ?
> +					1 : tbuf[i] == 0x07 ? 2 : tbuf[i] == 0x87 ? 3 : card->adapn);
> +			struct ptx_adap		*adap	= &card->adap[idx];
> +			struct pxq3pe_adap	*p	= adap->priv;
> +
> +			if (idx < card->adapn && adap->ON) {
> +				tbuf[i] = PTX_TS_SYNC;
> +				memcpy(&p->tBuf[p->tBufIdx], &tbuf[i], PTX_TS_SIZE);
> +				p->tBufIdx += PTX_TS_SIZE;
> +				if (p->tBufIdx >= PKT_BUFSZ) {
> +					pxq3pe_dma_put_stream(p);
> +					p->tBufIdx = 0;
> +				}
> +			}
> +		}
> +	if (c->dma.ON[port])
> +		writel(dmamgmt | (2 << (ch * 16)), bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +	return IRQ_HANDLED;
> +}
> +
> +int pxq3pe_thread(void *dat)
> +{
> +	struct ptx_adap		*adap	= dat;
> +	struct pxq3pe_adap	*p	= adap->priv;
> +
> +	set_freezable();
> +	while (!kthread_should_stop()) {
> +		u8	*rbuf	= &p->sBuf[p->sBufStart];
> +		int	i	= 0,
> +			j	= 0,
> +			k,
> +			sz	= p->sBufSize - p->sBufStart;
> +
> +		try_to_freeze();
> +		if (!p->sBufByteCnt) {
> +			msleep_interruptible(0);
> +			continue;
> +		}
> +		if (sz > p->sBufByteCnt)
> +			sz = p->sBufByteCnt;
> +		while (j < sz / PTX_TS_SIZE) {
> +			j++;
> +			i += 4;
> +			while (i < j * PTX_TS_SIZE)
> +				for (k = 0; k < 8; k++, i++)
> +					rbuf[i] ^= xor[idx[k]];
> +		}
> +		dvb_dmx_swfilter(&adap->demux, rbuf, sz);
> +		p->sBufStart	= (p->sBufStart + sz) % p->sBufSize;
> +		p->sBufByteCnt -= sz;
> +	}
> +	return 0;
> +}
> +
> +int pxq3pe_dma(struct ptx_adap *adap, bool ON)
> +{
> +	struct ptx_card		*card	= adap->card;
> +	struct pxq3pe_card	*c	= card->priv;
> +	struct pxq3pe_adap	*p	= adap->priv;
> +	struct i2c_client	*d	= adap->fe->demodulator_priv;
> +	u8			idx	= (d->addr / 2) & (card->adapn - 1),
> +				i;
> +	bool			port	= !(idx & 4);
> +	u32			val	= 0b0011 << (port * 2);
> +
> +	if (!ON) {
> +		for (i = 0; i < card->adapn; i++)
> +			if (!c->dma.ON[port] || (idx != i && (i & 4) == (idx & 4) && c->dma.ON[port]))
> +				return 0;
> +
> +		i = readb(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +		if ((i & 0b1100) == 4)
> +			writeb(i & 0xFD, c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +		writeb(0b0011 << (port * 2), c->bar + PXQ3PE_IRQ_DISABLE);
> +		c->dma.ON[port] = false;
> +		return 0;
> +	}
> +
> +	p->sBufByteCnt	= 0;
> +	p->sBufStop	= 0;
> +	p->sBufStart	= 0;
> +	if (c->dma.ON[port])
> +		return 0;
> +
> +	/* SetTSMode */
> +	i = readb(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_TSMODE);
> +	if ((i & 0x80) == 0)
> +		writeb(i | 0x80, c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_TSMODE);
> +
> +	/* irq_enable */
> +	writel(val, c->bar + PXQ3PE_IRQ_ENABLE);
> +	if (val != (readl(c->bar + PXQ3PE_IRQ_ACTIVE) & val))
> +		return -EIO;
> +
> +	/* cfg_dma */
> +	for (i = 0; i < 2; i++) {
> +		val		= readl(c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +		writel(c->dma.adr + PKT_BUFSZ * (port * 2 + i),
> +					c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_ADR_LO);
> +		writel(0,		c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_ADR_HI);
> +		writel(0x11C0E520,	c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_OFFSET_CH * i + PXQ3PE_DMA_CTL);
> +		writel(val | 3 << (i * 16),
> +					c->bar + PXQ3PE_DMA_OFFSET_PORT * port + PXQ3PE_DMA_MGMT);
> +	}
> +	c->dma.ON[port] = true;
> +	return 0;
> +}
> +
> +void pxq3pe_lnb(struct ptx_card *card, bool lnb)
> +{
> +	pxq3pe_w_gpio2(card, lnb ? 0x20 : 0, 0x20);
> +}
> +
> +void pxq3pe_remove(struct pci_dev *pdev)
> +{
> +	struct ptx_card		*card	= pci_get_drvdata(pdev);
> +	struct ptx_adap		*adap;
> +	struct pxq3pe_card	*c;
> +	u8	regctl = 0,
> +		i;
> +
> +	if (!card)
> +		return;
> +	c	= card->priv;
> +	for (i = 0, adap = card->adap; adap->fe && i < card->adapn; i++, adap++) {
> +		pxq3pe_dma(adap, false);
> +		ptx_sleep(adap->fe);
> +	}
> +	pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0x80, &regctl, 1, PXQ3PE_MOD_GPIO);
> +	pxq3pe_power(card, false);
> +
> +	/* dma_hw_unmap */
> +	free_irq(pdev->irq, card);
> +	if (c->dma.dat)
> +		pci_free_consistent(card->pdev, c->dma.sz, c->dma.dat, c->dma.adr);
> +	for (i = 0; i < card->adapn; i++) {
> +		struct ptx_adap		*adap	= &card->adap[i];
> +		struct pxq3pe_adap	*p	= adap->priv;
> +
> +		vfree(p->sBuf);
> +	}
> +	if (c->bar)
> +		pci_iounmap(pdev, c->bar);
> +	ptx_unregister_adap(card);
> +}
> +
> +static const struct i2c_algorithm pxq3pe_algo = {
> +	.functionality	= ptx_i2c_func,
> +	.master_xfer	= pxq3pe_xfr,
> +};
> +
> +static int pxq3pe_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
> +{
> +	struct ptx_subdev_info	pxq3pe_subdev_info[] = {
> +		{SYS_ISDBT, 0x20, TC90522_MODNAME, 0x10, NM131_MODNAME},
> +		{SYS_ISDBS, 0x22, TC90522_MODNAME, 0x11, TDA2014X_MODNAME},
> +		{SYS_ISDBT, 0x24, TC90522_MODNAME, 0x12, NM131_MODNAME},
> +		{SYS_ISDBS, 0x26, TC90522_MODNAME, 0x13, TDA2014X_MODNAME},
> +		{SYS_ISDBT, 0x28, TC90522_MODNAME, 0x14, NM131_MODNAME},
> +		{SYS_ISDBS, 0x2A, TC90522_MODNAME, 0x15, TDA2014X_MODNAME},
> +		{SYS_ISDBT, 0x2C, TC90522_MODNAME, 0x16, NM131_MODNAME},
> +		{SYS_ISDBS, 0x2E, TC90522_MODNAME, 0x17, TDA2014X_MODNAME},
> +	};
> +	struct ptx_card		*card	= ptx_alloc(pdev, KBUILD_MODNAME, ARRAY_SIZE(pxq3pe_subdev_info),
> +						sizeof(struct pxq3pe_card), sizeof(struct pxq3pe_adap), pxq3pe_lnb);
> +	struct pxq3pe_card	*c;
> +	u8	regctl	= 0xA0,
> +		i;
> +	u16	cfg;
> +	int	err	= !card || pci_read_config_word(pdev, PCI_COMMAND, &cfg);
> +
> +	if (err)
> +		return ptx_abort(pdev, pxq3pe_remove, err, "Memory/PCI error, card=%p", card);
> +	c	= card->priv;
> +	if (!(cfg & PCI_COMMAND_MASTER)) {
> +		pci_set_master(pdev);
> +		pci_read_config_word(pdev, PCI_COMMAND, &cfg);
> +		if (!(cfg & PCI_COMMAND_MASTER))
> +			return ptx_abort(pdev, pxq3pe_remove, -EIO, "Bus Mastering is disabled");
> +	}
> +	c->bar	= pci_iomap(pdev, 0, 0);
> +	if (!c->bar)
> +		return ptx_abort(pdev, pxq3pe_remove, -EIO, "I/O map failed");
> +	if (ptx_i2c_add_adapter(card, &pxq3pe_algo))
> +		return ptx_abort(pdev, pxq3pe_remove, -EIO, "Cannot add I2C");
> +
> +	for (i = 0; i < card->adapn; i++) {
> +		struct ptx_adap		*adap	= &card->adap[i];
> +		struct pxq3pe_adap	*p	= adap->priv;
> +
> +		p->sBufSize	= PTX_TS_SIZE * 100 << 9;
> +		p->sBuf		= vzalloc(p->sBufSize);
> +		if (!p->sBuf)
> +			return ptx_abort(pdev, pxq3pe_remove, -ENOMEM, "No memory for stream buffer");
> +	}
> +
> +	/* dma_map */
> +	if (request_irq(pdev->irq, pxq3pe_irq, IRQF_SHARED, KBUILD_MODNAME, card))
> +		return ptx_abort(pdev, pxq3pe_remove, -EIO, "IRQ failed");
> +	c->dma.sz	= PKT_BUFSZ * 4;
> +	c->dma.dat	= pci_alloc_consistent(card->pdev, c->dma.sz, &c->dma.adr);
> +	if (!c->dma.dat)
> +		return ptx_abort(pdev, pxq3pe_remove, -EIO, "DMA mapping failed");
> +
> +	/* hw_init */
> +	writeb(readb(c->bar + 0x880) & 0xC0, c->bar + 0x880);
> +	writel(0x3200C8, c->bar + 0x904);
> +	writel(0x90,	 c->bar + 0x900);
> +	writel(0x10000,	 c->bar + 0x880);
> +	writel(0x0080,	 c->bar + PXQ3PE_DMA_TSMODE);				/* port 0 */
> +	writel(0x0080,	 c->bar + PXQ3PE_DMA_TSMODE + PXQ3PE_DMA_OFFSET_PORT);	/* port 1 */
> +	writel(0x0000,	 c->bar + 0x888);
> +	writel(0x00CF,	 c->bar + 0x894);
> +	writel(0x8000,	 c->bar + 0x88C);
> +	writel(0x1004,	 c->bar + 0x890);
> +	writel(0x0090,	 c->bar + 0x900);
> +	writel(0x3200C8, c->bar + 0x904);
> +	pxq3pe_w_gpio0(card, 8, 0xFF);
> +	pxq3pe_w_gpio1(card, 0, 2);
> +	pxq3pe_w_gpio1(card, 1, 1);
> +	pxq3pe_w_gpio0(card, 1, 1);
> +	pxq3pe_w_gpio0(card, 0, 1);
> +	pxq3pe_w_gpio0(card, 1, 1);
> +	for (i = 0; i < 16; i++)
> +		if (!pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 0x10 + i, auth + i, 1, PXQ3PE_MOD_GPIO))
> +			break;
> +	if (i < 16 || !pxq3pe_w(card, PXQ3PE_I2C_ADR_GPIO, 5, &regctl, 1, PXQ3PE_MOD_GPIO))
> +		return ptx_abort(pdev, pxq3pe_remove, -EIO, "hw_init failed i=%d", i);
> +	pxq3pe_power(card, true);
> +	err = ptx_register_adap(card, pxq3pe_subdev_info, pxq3pe_thread, pxq3pe_dma);
> +	return err ? ptx_abort(pdev, pxq3pe_remove, err, "Unable to register DVB adapter & frontend") : 0;
> +}
> +
> +static struct pci_driver pxq3pe_driver = {
> +	.name		= KBUILD_MODNAME,
> +	.id_table	= pxq3pe_id_table,
> +	.probe		= pxq3pe_probe,
> +	.remove		= pxq3pe_remove,
> +};
> +module_pci_driver(pxq3pe_driver);
> +
> diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
> index e382210..fc19edc 100644
> --- a/drivers/media/usb/em28xx/Kconfig
> +++ b/drivers/media/usb/em28xx/Kconfig
> @@ -59,6 +59,9 @@ config VIDEO_EM28XX_DVB
>  	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_PTX_COMMON

Should select DVB_PTX only if MEDIA_SUBDRV_AUTOSELECT. Not all em28xx-based
devices depend on it. We don't want to add an extra overhead for users that
want to generate customized Kernels to work with just one specific device.

> +	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_QM1D1C004X if MEDIA_SUBDRV_AUTOSELECT
>  	---help---
>  	  This adds support for DVB cards based on the
>  	  Empiatech em28xx chips.
> diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
> index 3f850d5..1488829 100644
> --- a/drivers/media/usb/em28xx/Makefile
> +++ b/drivers/media/usb/em28xx/Makefile
> @@ -14,3 +14,4 @@ ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
>  ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> +ccflags-y += -Idrivers/media/pci/ptx
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 930e3e3..772a8f8 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -492,6 +492,20 @@ static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
>  	{-1,                             -1,   -1,     -1},
>  };
>  
> +static struct em28xx_reg_seq plex_px_bcud[] = {
> +	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0},
> +	{0x0d,				0xff,	0xff,	0},
> +	{EM2874_R50_IR_CONFIG,		0x01,	0xff,	0},
> +	{EM28XX_R06_I2C_CLK,		0x40,	0xff,	0},
> +	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	100},
> +	{EM28XX_R12_VINENABLE,		0x20,	0x20,	0},
> +	{0x0d,				0x42,	0xff,	1000},
> +	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	10},
> +	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	10},
> +	{0x73,				0xfd,	0xff,	100},
> +	{-1,				-1,	-1,	-1},
> +};
> +
>  /*
>   *  Button definitions
>   */
> @@ -2306,6 +2320,17 @@ struct em28xx_board em28xx_boards[] = {
>  		.has_dvb       = 1,
>  		.ir_codes      = RC_MAP_TERRATEC_SLIM_2,
>  	},
> +	/* 3275:0085 PLEX PX-BCUD.
> +	 * Empia EM28178, TOSHIBA TC90532XBG, Sharp QM1D1C0042 */
> +	[EM28178_BOARD_PLEX_PX_BCUD] = {
> +		.name          = "PLEX PX-BCUD",
> +		.xclk          = EM28XX_XCLK_FREQUENCY_4_3MHZ,
> +		.def_i2c_bus   = 1,
> +		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE,
> +		.tuner_type    = TUNER_ABSENT,
> +		.tuner_gpio    = plex_px_bcud,
> +		.has_dvb       = 1,
> +	},
>  };
>  EXPORT_SYMBOL_GPL(em28xx_boards);
>  
> @@ -2495,6 +2520,8 @@ struct usb_device_id em28xx_id_table[] = {
>  			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
>  	{ USB_DEVICE(0xeb1a, 0x8179),
>  			.driver_info = EM28178_BOARD_TERRATEC_T2_STICK_HD },
> +	{ USB_DEVICE(0x3275, 0x0085),
> +			.driver_info = EM28178_BOARD_PLEX_PX_BCUD },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(usb, em28xx_id_table);
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 5d209c7..c45112e 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -12,6 +12,10 @@
>  
>   (c) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
>  
> + (c) 2016 Nagahama Satoshi <sattnag@aim.com>
> +	  Budi Rachmanto, AreMa Inc. <info@are.ma>
> +	- PLEX PX-BCUD support
> +

No, you should not add your credits here. You're just adding some new board
definitions, not rewriting a significant amount of the driver. The credits
of your work will be preserved via the git log. A gold rule we use in
Kernel when adding credits info is when the changes touch more than 30% of
the driver's code.
 
>   Based on cx88-dvb, saa7134-dvb and videobuf-dvb originally written by:
>  	(c) 2004, 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
>  	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
> @@ -25,11 +29,10 @@
>  #include <linux/slab.h>
>  #include <linux/usb.h>
>  
> +#include "ptx_common.h"
>  #include "em28xx.h"
>  #include <media/v4l2-common.h>
> -#include <dvb_demux.h>
>  #include <dvb_net.h>
> -#include <dmxdev.h>

No. Don't remove DVB core headers from here. The ptx demux should be
optional, not mandatory.

>  #include <media/tuner.h>
>  #include "tuner-simple.h"
>  #include <linux/gpio.h>
> @@ -58,6 +61,8 @@
>  #include "ts2020.h"
>  #include "si2168.h"
>  #include "si2157.h"
> +#include "tc90522.h"
> +#include "qm1d1c004x.h"
>  
>  MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
>  MODULE_LICENSE("GPL");
> @@ -787,6 +792,65 @@ static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
>  	return 0;
>  }
>  
> +static void px_bcud_init(struct em28xx *dev)
> +{
> +	int i;
> +	struct {
> +		unsigned char r[4];
> +		int len;
> +	} regs1[] = {
> +		{{ 0x0e, 0x77 }, 2},
> +		{{ 0x0f, 0x77 }, 2},
> +		{{ 0x03, 0x90 }, 2},
> +	}, regs2[] = {
> +		{{ 0x07, 0x01 }, 2},
> +		{{ 0x08, 0x10 }, 2},
> +		{{ 0x13, 0x00 }, 2},
> +		{{ 0x17, 0x00 }, 2},
> +		{{ 0x03, 0x01 }, 2},
> +		{{ 0x10, 0xb1 }, 2},
> +		{{ 0x11, 0x40 }, 2},
> +		{{ 0x85, 0x7a }, 2},
> +		{{ 0x87, 0x04 }, 2},
> +	};
> +	static struct em28xx_reg_seq gpio[] = {
> +		{EM28XX_R06_I2C_CLK,		0x40,	0xff,	300},
> +		{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	60},
> +		{EM28XX_R15_RGAIN,		0x20,	0xff,	0},
> +		{EM28XX_R16_GGAIN,		0x20,	0xff,	0},
> +		{EM28XX_R17_BGAIN,		0x20,	0xff,	0},
> +		{EM28XX_R18_ROFFSET,		0x00,	0xff,	0},
> +		{EM28XX_R19_GOFFSET,		0x00,	0xff,	0},
> +		{EM28XX_R1A_BOFFSET,		0x00,	0xff,	0},
> +		{EM28XX_R23_UOFFSET,		0x00,	0xff,	0},
> +		{EM28XX_R24_VOFFSET,		0x00,	0xff,	0},
> +		{EM28XX_R26_COMPR,		0x00,	0xff,	0},
> +		{0x13,				0x08,	0xff,	0},

You should, instead, add a new macro at em28xx-regs.h for the register
at 0x13 address.

> +		{EM28XX_R12_VINENABLE,		0x27,	0xff,	0},
> +		{EM28XX_R0C_USBSUSP,		0x10,	0xff,	0},
> +		{EM28XX_R27_OUTFMT,		0x00,	0xff,	0},
> +		{EM28XX_R10_VINMODE,		0x00,	0xff,	0},
> +		{EM28XX_R11_VINCTRL,		0x11,	0xff,	0},
> +		{EM2874_R50_IR_CONFIG,		0x01,	0xff,	0},
> +		{EM2874_R5F_TS_ENABLE,		0x80,	0xff,	0},
> +		{EM28XX_R06_I2C_CLK,		0x46,	0xff,	0},
> +	};
> +	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x46);
> +	/* sleeping ISDB-T */
> +	dev->dvb->i2c_client_demod->addr = 0x14;
> +	for (i = 0; i < ARRAY_SIZE(regs1); i++)
> +		i2c_master_send(dev->dvb->i2c_client_demod, regs1[i].r, regs1[i].len);
> +	/* sleeping ISDB-S */
> +	dev->dvb->i2c_client_demod->addr = 0x15;
> +	for (i = 0; i < ARRAY_SIZE(regs2); i++)
> +		i2c_master_send(dev->dvb->i2c_client_demod, regs2[i].r, regs2[i].len);
> +	for (i = 0; i < ARRAY_SIZE(gpio); i++) {
> +		em28xx_write_reg_bits(dev, gpio[i].reg, gpio[i].val, gpio[i].mask);
> +		if (gpio[i].sleep > 0)
> +			msleep(gpio[i].sleep);
> +	}
> +};
> +
>  static struct mt352_config terratec_xs_mt352_cfg = {
>  	.demod_address = (0x1e >> 1),
>  	.no_tuner = 1,
> @@ -1762,6 +1826,19 @@ static int em28xx_dvb_init(struct em28xx *dev)
>  			dvb->i2c_client_tuner = client;
>  		}
>  		break;
> +	case EM28178_BOARD_PLEX_PX_BCUD:
> +		{
> +			struct ptx_subdev_info	pxbcud_subdev_info =
> +				{SYS_ISDBS, 0x15, TC90522_MODNAME, 0x61, QM1D1C004X_MODNAME};
> +
> +			dvb->fe[0] = ptx_register_fe(&dev->i2c_adap[dev->def_i2c_bus], NULL, &pxbcud_subdev_info);
> +			if (!dvb->fe[0])
> +                                goto out_free;
> +			dvb->i2c_client_demod = dvb->fe[0]->demodulator_priv;
> +                        dvb->i2c_client_tuner = dvb->fe[0]->tuner_priv;
> +			px_bcud_init(dev);
> +		}
> +		break;
>  	default:
>  		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
>  				" isn't supported yet\n");
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 2674449..9ad1240 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -145,6 +145,7 @@
>  #define EM2861_BOARD_LEADTEK_VC100                95
>  #define EM28178_BOARD_TERRATEC_T2_STICK_HD        96
>  #define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008     97
> +#define EM28178_BOARD_PLEX_PX_BCUD                98
>  
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4


-- 

Cheers,
Mauro
