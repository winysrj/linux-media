Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:44848 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbcACDzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jan 2016 22:55:37 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave08.hostedemail.com (Postfix) with ESMTP id CB3EE21195A
	for <linux-media@vger.kernel.org>; Sun,  3 Jan 2016 03:47:59 +0000 (UTC)
Message-ID: <1451792869.4334.33.camel@perches.com>
Subject: Re: [RFC PATCH v0] Add tw5864 driver
From: Joe Perches <joe@perches.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrey Utkin <andrey.od.utkin@gmail.com>
Date: Sat, 02 Jan 2016 19:47:49 -0800
In-Reply-To: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-01-03 at 03:41 +0200, Andrey Utkin wrote:
> (Disclaimer up to scissors mark)
> 
> Please be so kind to take a look at a new driver.

trivial comments only:
> diff --git a/drivers/staging/media/tw5864/tw5864-bs.h b/drivers/staging/media/tw5864/tw5864-bs.h
[]
> +static inline int bs_pos(struct bs *s)
> +{
> +	return (8 * (s->p - s->p_start) + 8 - s->i_left);
> +}

several of these have unnecessary parentheses

> +static inline int bs_eof(struct bs *s)
> +{
> +	return (s->p >= s->p_end ? 1 : 0);
> +}

Maybe use bool a bit more
> +/* golomb functions */
> +static inline void bs_write_ue(struct bs *s, u32 val)
> +{
> +	int i_size = 0;
> +	static const int i_size0_255[256] = {

Maybe use s8 instead of int to reduce object size

> +		1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,
> +		5, 5,
> +		5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
> +		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,

Perhaps it'd be clearer to use gcc's ranged initializer syntax

	[  0 ...   1] = 1,
	[  2 ...   3] = 2,
	[  4 ...   7] = 3,
	[  8 ...  15] = 4,
	[ 16 ...  31] = 5,
	[ 32 ...  63] = 6,
etc...

or maybe just use fls

> +static inline int bs_size_ue(unsigned int val)
> +{
> +	int i_size = 0;
> +	static const int i_size0_254[255] = {

Same sort of thing

> diff --git a/drivers/staging/media/tw5864/tw5864-config.c b/drivers/staging/media/tw5864/tw5864-config.c
[]
> +u8 tw_indir_readb(struct tw5864_dev *dev, u16 addr)
> +{
> +	int timeout = 30000;

misleading name, retries would be more proper,
or maybe use real timed loops.

> +	u32 data = 0;
> +
> +	addr <<= 2;
> +
> +	while ((tw_readl(TW5864_IND_CTL) >> 31) && (timeout--))
> +		;
> +	if (!timeout)
> +		dev_err(&dev->pci->dev,
> +			"tw_indir_writel() timeout before reading\n");
> +
> +	tw_writel(TW5864_IND_CTL, addr | TW5864_ENABLE);
> +
> +	timeout = 30000;
> +	while ((tw_readl(TW5864_IND_CTL) >> 31) && (timeout--))
> +		;
> +	if (!timeout)
> +		dev_err(&dev->pci->dev,
> +			"tw_indir_writel() timeout at reading\n");
> +
> +	data = tw_readl(TW5864_IND_DATA);
> +	return data & 0xff;
> +}
[]
> +static size_t regs_dump(struct tw5864_dev *dev, char *buf, size_t size)
> +{
> +	size_t count = 0;
> +
> +	u32 reg_addr;
> +	u32 value;
> +
> +	for (reg_addr = 0x0000; (count < size) && (reg_addr <= 0x2FFC);
> +	     reg_addr += 4) {
> +		value = tw_readl(reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "[0x%05x] = 0x%08x\n", reg_addr, value);
> +	}
> +
> +	for (reg_addr = 0x4000; (count < size) && (reg_addr <= 0x4FFC);
> +	     reg_addr += 4) {
> +		value = tw_readl(reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "[0x%05x] = 0x%08x\n", reg_addr, value);
> +	}
> +
> +	for (reg_addr = 0x8000; (count < size) && (reg_addr <= 0x180DC);
> +	     reg_addr += 4) {
> +		value = tw_readl(reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "[0x%05x] = 0x%08x\n", reg_addr, value);
> +	}
> +
> +	for (reg_addr = 0x18100; (count < size) && (reg_addr <= 0x1817C);
> +	     reg_addr += 4) {
> +		value = tw_readl(reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "[0x%05x] = 0x%08x\n", reg_addr, value);
> +	}
> +
> +	for (reg_addr = 0x80000; (count < size) && (reg_addr <= 0x87FFF);
> +	     reg_addr += 4) {
> +		value = tw_readl(reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "[0x%05x] = 0x%08x\n", reg_addr, value);
> +	}

This seems a little repetitive.

> diff --git a/drivers/staging/media/tw5864/tw5864-tables.h b/drivers/staging/media/tw5864/tw5864-tables.h
[]
> +static const u32 forward_quantization_table[QUANTIZATION_TABLE_LEN] = {

u16?


> +		static const struct v4l2_ctrl_config tw5864_md_thresholds = {
> +			.ops = &tw5864_ctrl_ops,
> +			.id = V4L2_CID_DETECT_MD_THRESHOLD_GRID,
> +			.dims = {MD_CELLS_HOR, MD_CELLS_VERT},
> +			.def = 14,
> +			/* See tw5864_md_metric_from_mvd() */
> +			.max = 2 * 0x0f,
> +			.step = 1,
> +		};

odd indentation

> +#ifdef DEBUG
> +	dev_dbg(&input->root->pci->dev,
> +		"input %d, frame md stats: min %u, max %u, avg %u, cells above threshold: %u\n",
> +		input->input_number, min, max, sum / md_cells,
> +		cnt_above_thresh);
> +#endif

unnecessary #ifdef

