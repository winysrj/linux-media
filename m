Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab2DSSGf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 14:06:35 -0400
Message-ID: <4F905425.4030102@redhat.com>
Date: Thu, 19 Apr 2012 15:06:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com> <201204152353103757288@gmail.com>
In-Reply-To: <201204152353103757288@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Max,

Em 15-04-2012 12:53, nibble.max escreveu:
> Montage m88ds3103 demodulator and ts2022 tuner driver.
> 
> Signed-off-by: Max nibble <nibble.max@gmail.com>

Please always test any patch you send upstream with ./scripts/checkpatch.pl.

It analyses the code and checks if it is following the Linux Coding Style
(Documentation/CodingStyle).

>From what I've seen, there are several small CodingStyle issues on this patch.

There's also another problem here: this driver is mixing an I2C tuner driver
with the demod one. Please split. If the tuner is simple enough, you an add
it to:
	drivers/media/common/tuners/tuner-simple.c
or at:
	drivers/media/dvb/frontends/dvb-pll.c

But please don't mix tuners with demods. Mixing it causes code duplication and
more time lost when debugging it (as two different version of the same driver
can have different bugs).

I'll analyze it deeper after you fix those two issues.

Thanks,
Mauro


> ---
>  drivers/media/dvb/frontends/Kconfig     |    7 +
>  drivers/media/dvb/frontends/Makefile    |    2 +
>  drivers/media/dvb/frontends/m88ds3103.c | 1851 +++++++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/m88ds3103.h |   53 +
>  4 files changed, 1913 insertions(+)
>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.c
>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.h
> 
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index e11adb6..d2bb312 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -214,6 +214,13 @@ config DVB_CX24116
>  	help
>  	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
>  
> +config DVB_M88DS3103
> +	tristate "Montage DS3103 based"
> +	depends on DVB_CORE && I2C
> +	default m if DVB_FE_CUSTOMISE
> +	help
> +	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
> +	  
>  config DVB_SI21XX
>  	tristate "Silicon Labs SI21XX based"
>  	depends on DVB_CORE && I2C
> diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
> index 6ca7557..84ddf41 100644
> --- a/drivers/media/dvb/frontends/Makefile
> +++ b/drivers/media/dvb/frontends/Makefile
> @@ -98,5 +98,7 @@ obj-$(CONFIG_DVB_A8293) += a8293.o
>  obj-$(CONFIG_DVB_TDA10071) += tda10071.o
>  obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>  obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
> +obj-$(CONFIG_DVB_M88DS3103) += m88ds3103.o
>  obj-$(CONFIG_DVB_AF9033) += af9033.o
>  
> +
> diff --git a/drivers/media/dvb/frontends/m88ds3103.c b/drivers/media/dvb/frontends/m88ds3103.c
> new file mode 100644
> index 0000000..a186ba0
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/m88ds3103.c
> @@ -0,0 +1,1851 @@
> +/*
> +    Montage Technology M88DS3103/M88TS2022 - DVBS/S2 Satellite demod/tuner driver
> +
> +    Copyright (C) 2011 Max nibble<nibble.max@gmail.com>
> +    Copyright (C) 2010 Montage Technology<www.montage-tech.com>
> +    Copyright (C) 2009 Konstantin Dimitrov.
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/firmware.h>
> +
> +#include "dvb_frontend.h"
> +#include "m88ds3103.h"
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
> +
> +#define dprintk(args...) \
> +	do { \
> +		if (debug) \
> +			printk(KERN_INFO "m88ds3103: " args); \
> +	} while (0)
> +
> +#define FW_DOWN_SIZE 32
> +#define FW_DOWN_LOOP (8192/FW_DOWN_SIZE)
> +#define DS3103_DEFAULT_FIRMWARE "dvb-fe-ds3103.fw"
> +#define DS3000_DEFAULT_FIRMWARE "dvb-fe-ds300x.fw"
> +#define MT_FE_MCLK_KHZ 96000 /* in kHz */
> +#define MT_FE_CRYSTAL_KHZ   27000 /* in kHz */
> +#define FREQ_OFFSET_AT_SMALL_SYM_RATE_KHz 3000
> +#define DS3000_ID	0x3000
> +#define DS3103_ID	0x3103
> +#define TS2020_ID	0x2020
> +#define TS2022_ID	0x2022
> +#define UNKNOW_ID	0x0000
> +
> +/* For M88DS3103 demod dvbs mode.*/
> +static u8 ds3103_dvbs_init_tab[] = {
> +	0x23, 0x07,
> +	0x08, 0x03,
> +	0x0c, 0x02,
> +	0x21, 0x54,
> +	0x25, 0x82,
> +	0x27, 0x31,
> +	0x30, 0x08,
> +	0x31, 0x40,
> +	0x32, 0x32,
> +	0x33, 0x35,
> +	0x35, 0xff,
> +	0x3a, 0x00,
> +	0x37, 0x10,
> +	0x38, 0x10,
> +	0x39, 0x02,
> +	0x42, 0x60,
> +	0x4a, 0x80,
> +	0x4b, 0x04,
> +	0x4d, 0x91,
> +	0x5d, 0xc8,
> +	0x50, 0x36,
> +	0x51, 0x36,
> +	0x52, 0x36,
> +	0x53, 0x36,
> +	0x63, 0x0f,
> +	0x64, 0x30,
> +	0x65, 0x40,
> +	0x68, 0x26,
> +	0x69, 0x4c,
> +	0x70, 0x20,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x40,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x60,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x80,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0xa0,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x1f,
> +	0x76, 0x38,
> +	0x77, 0xa6,
> +	0x78, 0x0c,
> +	0x79, 0x80,
> +	0x7f, 0x14,
> +	0x7c, 0x00,
> +	0xae, 0x82,
> +	0x80, 0x64,
> +	0x81, 0x66,
> +	0x82, 0x44,
> +	0x85, 0x04,
> +	0xcd, 0xf4,
> +	0x90, 0x33,
> +	0xa0, 0x44,
> +	0xc0, 0x08,
> +	0xc3, 0x10,
> +	0xc4, 0x08,
> +	0xc5, 0xf0,
> +	0xc6, 0xff,
> +	0xc7, 0x00,
> +	0xc8, 0x1a,
> +	0xc9, 0x80,
> +	0xe0, 0xf8,
> +	0xe6, 0x8b,
> +	0xd0, 0x40,
> +	0xf8, 0x20,
> +	0xfa, 0x0f,
> +	0x00, 0x00,
> +	0xbd, 0x01,
> +	0xb8, 0x00,
> +};
> +/* For M88DS3103 demod dvbs2 mode.*/
> +static u8 ds3103_dvbs2_init_tab[] = {
> +	0x23, 0x07,
> +	0x08, 0x07,
> +	0x0c, 0x02,
> +	0x21, 0x54,
> +	0x25, 0x82,
> +	0x27, 0x31,
> +	0x30, 0x08,
> +	0x32, 0x32,
> +	0x33, 0x35,
> +	0x35, 0xff,
> +	0x3a, 0x00,
> +	0x37, 0x10,
> +	0x38, 0x10,
> +	0x39, 0x02,
> +	0x42, 0x60,
> +	0x4a, 0x80,
> +	0x4b, 0x04,
> +	0x4d, 0x91,
> +	0x5d, 0xc8,
> +	0x50, 0x36,
> +	0x51, 0x36,
> +	0x52, 0x36,
> +	0x53, 0x36,
> +	0x63, 0x0f,
> +	0x64, 0x10,
> +	0x65, 0x20,
> +	0x68, 0x46,
> +	0x69, 0xcd,
> +	0x70, 0x20,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x40,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x60,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x80,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0xa0,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x1f,
> +	0x76, 0x38,
> +	0x77, 0xa6,
> +	0x78, 0x0c,
> +	0x79, 0x80,
> +	0x7f, 0x14,
> +	0x85, 0x08,
> +	0xcd, 0xf4,
> +	0x90, 0x33,
> +	0x86, 0x00,
> +	0x87, 0x0f,
> +	0x89, 0x00,
> +	0x8b, 0x44,
> +	0x8c, 0x66,
> +	0x9d, 0xc1,
> +	0x8a, 0x10,
> +	0xad, 0x40,
> +	0xa0, 0x44,
> +	0xc0, 0x08,
> +	0xc1, 0x10,
> +	0xc2, 0x08,
> +	0xc3, 0x10,
> +	0xc4, 0x08,
> +	0xc5, 0xf0,
> +	0xc6, 0xff,
> +	0xc7, 0x00,
> +	0xc8, 0x1a,
> +	0xc9, 0x80,
> +	0xca, 0x23,
> +	0xcb, 0x24,
> +	0xcc, 0xf4,
> +	0xce, 0x74,
> +	0x00, 0x00,
> +	0xbd, 0x01,
> +	0xb8, 0x00,
> +};
> +
> +/* For M88DS3000 demod dvbs mode.*/
> +static u8 ds3000_dvbs_init_tab[] = {
> +	0x23, 0x05,
> +	0x08, 0x03,
> +	0x0c, 0x02,
> +	0x21, 0x54,
> +	0x25, 0x82,
> +	0x27, 0x31,
> +	0x30, 0x08,
> +	0x31, 0x40,
> +	0x32, 0x32,
> +	0x33, 0x35,
> +	0x35, 0xff,
> +	0x3a, 0x00,
> +	0x37, 0x10,
> +	0x38, 0x10,
> +	0x39, 0x02,
> +	0x42, 0x60,
> +	0x4a, 0x40,
> +	0x4b, 0x04,
> +	0x4d, 0x91,
> +	0x5d, 0xc8,
> +	0x50, 0x77,
> +	0x51, 0x77,
> +	0x52, 0x36,
> +	0x53, 0x36,
> +	0x56, 0x01,
> +	0x63, 0x47,
> +	0x64, 0x30,
> +	0x65, 0x40,
> +	0x68, 0x26,
> +	0x69, 0x4c,
> +	0x70, 0x20,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x40,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x60,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x80,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0xa0,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x1f,
> +	0x76, 0x00,
> +	0x77, 0xd1,
> +	0x78, 0x0c,
> +	0x79, 0x80,
> +	0x7f, 0x04,
> +	0x7c, 0x00,
> +	0x80, 0x86,
> +	0x81, 0xa6,
> +	0x85, 0x04,
> +	0xcd, 0xf4,
> +	0x90, 0x33,
> +	0xa0, 0x44,
> +	0xc0, 0x18,
> +	0xc3, 0x10,
> +	0xc4, 0x08,
> +	0xc5, 0x80,
> +	0xc6, 0x80,
> +	0xc7, 0x0a,
> +	0xc8, 0x1a,
> +	0xc9, 0x80,
> +	0xfe, 0xb6,
> +	0xe0, 0xf8,
> +	0xe6, 0x8b,
> +	0xd0, 0x40,
> +	0xf8, 0x20,
> +	0xfa, 0x0f,
> +	0xad, 0x20,
> +	0xae, 0x07,
> +	0xb8, 0x00,
> +};
> +
> +/* For M88DS3000 demod dvbs2 mode.*/
> +static u8 ds3000_dvbs2_init_tab[] = {
> +	0x23, 0x0f,
> +	0x08, 0x07,
> +	0x0c, 0x02,
> +	0x21, 0x54,
> +	0x25, 0x82,
> +	0x27, 0x31,
> +	0x30, 0x08,
> +	0x31, 0x32,
> +	0x32, 0x32,
> +	0x33, 0x35,
> +	0x35, 0xff,
> +	0x3a, 0x00,
> +	0x37, 0x10,
> +	0x38, 0x10,
> +	0x39, 0x02,
> +	0x42, 0x60,
> +	0x4a, 0x80,
> +	0x4b, 0x04,
> +	0x4d, 0x91,
> +	0x5d, 0x88,
> +	0x50, 0x36,
> +	0x51, 0x36,
> +	0x52, 0x36,
> +	0x53, 0x36,
> +	0x63, 0x60,
> +	0x64, 0x10,
> +	0x65, 0x10,
> +	0x68, 0x04,
> +	0x69, 0x29,
> +	0x70, 0x20,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x40,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x60,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x80,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0xa0,
> +	0x71, 0x70,
> +	0x72, 0x04,
> +	0x73, 0x00,
> +	0x70, 0x1f,
> +	0xa0, 0x44,
> +	0xc0, 0x08,
> +	0xc1, 0x10,
> +	0xc2, 0x08,
> +	0xc3, 0x10,
> +	0xc4, 0x08,
> +	0xc5, 0xf0,
> +	0xc6, 0xf0,
> +	0xc7, 0x0a,
> +	0xc8, 0x1a,
> +	0xc9, 0x80,
> +	0xca, 0x23,
> +	0xcb, 0x24,
> +	0xce, 0x74,
> +	0x56, 0x01,
> +	0x90, 0x03,
> +	0x76, 0x80,
> +	0x77, 0x42,
> +	0x78, 0x0a,
> +	0x79, 0x80,
> +	0xad, 0x40,
> +	0xae, 0x07,
> +	0x7f, 0xd4,
> +	0x7c, 0x00,
> +	0x80, 0xa8,
> +	0x81, 0xda,
> +	0x7c, 0x01,
> +	0x80, 0xda,
> +	0x81, 0xec,
> +	0x7c, 0x02,
> +	0x80, 0xca,
> +	0x81, 0xeb,
> +	0x7c, 0x03,
> +	0x80, 0xba,
> +	0x81, 0xdb,
> +	0x85, 0x08,
> +	0x86, 0x00,
> +	0x87, 0x02,
> +	0x89, 0x80,
> +	0x8b, 0x44,
> +	0x8c, 0xaa,
> +	0x8a, 0x10,
> +	0xba, 0x00,
> +	0xf5, 0x04,
> +	0xd2, 0x32,
> +	0xb8, 0x00,
> +};
> +
> +struct m88ds3103_state {
> +	struct i2c_adapter *i2c;
> +	const struct m88ds3103_config *config;
> +	
> +	struct dvb_frontend frontend;
> +	
> +	u32 preBer;
> +	u8 skip_fw_load;	
> +	u8 first_lock; /* The first time of signal lock */
> +	u16 demod_id; /* demod chip type */
> +	u16 tuner_id; /* tuner chip type */
> +	fe_delivery_system_t delivery_system;
> +};
> +
> +/*demod register operations.*/
> +static int m88ds3103_writereg(struct m88ds3103_state *state, int reg, int data)
> +{
> +	u8 buf[] = { reg, data };
> +	struct i2c_msg msg = { .addr = state->config->demod_address,
> +		.flags = 0, .buf = buf, .len = 2 };
> +	int err;
> +
> +	if (debug > 1)
> +		printk("m88ds3103: %s: write reg 0x%02x, value 0x%02x\n",
> +			__func__, reg, data);
> +
> +	err = i2c_transfer(state->i2c, &msg, 1);
> +	if (err != 1) {
> +		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x,"
> +			 " value == 0x%02x)\n", __func__, err, reg, data);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int m88ds3103_readreg(struct m88ds3103_state *state, u8 reg)
> +{
> +	int ret;
> +	u8 b0[] = { reg };
> +	u8 b1[] = { 0 };
> +	struct i2c_msg msg[] = {
> +		{ .addr = state->config->demod_address, .flags = 0,
> +			.buf = b0, .len = 1 },
> +		{ .addr = state->config->demod_address, .flags = I2C_M_RD,
> +			.buf = b1, .len = 1 }
> +	};
> +	ret = i2c_transfer(state->i2c, msg, 2);
> +
> +	if (ret != 2) {
> +		printk(KERN_ERR "%s: reg=0x%x (error=%d)\n",
> +			__func__, reg, ret);
> +		return ret;
> +	}
> +
> +	if (debug > 1)
> +		printk(KERN_INFO "m88ds3103: read reg 0x%02x, value 0x%02x\n",
> +			reg, b1[0]);
> +
> +	return b1[0];
> +}
> +
> +/*tuner register operations.*/
> +static int m88ds3103_tuner_writereg(struct m88ds3103_state *state, int reg, int data)
> +{
> +	u8 buf[] = { reg, data };
> +	struct i2c_msg msg = { .addr = 0x60,
> +		.flags = 0, .buf = buf, .len = 2 };
> +	int err;
> +
> +	m88ds3103_writereg(state, 0x03, 0x11);
> +	err = i2c_transfer(state->i2c, &msg, 1);
> +	
> +	if (err != 1) {
> +		printk("%s: writereg error(err == %i, reg == 0x%02x,"
> +			 " value == 0x%02x)\n", __func__, err, reg, data);
> +		return -EREMOTEIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_tuner_readreg(struct m88ds3103_state *state, u8 reg)
> +{
> +	int ret;
> +	u8 b0[] = { reg };
> +	u8 b1[] = { 0 };
> +	struct i2c_msg msg[] = {
> +		{ .addr = 0x60, .flags = 0,
> +			.buf = b0, .len = 1 },
> +		{ .addr = 0x60, .flags = I2C_M_RD,
> +			.buf = b1, .len = 1 }
> +	};
> +
> +	m88ds3103_writereg(state, 0x03, 0x11);	
> +	ret = i2c_transfer(state->i2c, msg, 2);
> +
> +	if (ret != 2) {
> +		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
> +		return ret;
> +	}
> +
> +	return b1[0];
> +}
> +
> +/* Bulk demod I2C write, for firmware download. */
> +static int m88ds3103_writeregN(struct m88ds3103_state *state, int reg,
> +				const u8 *data, u16 len)
> +{
> +	int ret = -EREMOTEIO;
> +	struct i2c_msg msg;
> +	u8 *buf;
> +
> +	buf = kmalloc(len + 1, GFP_KERNEL);
> +	if (buf == NULL) {
> +		printk("Unable to kmalloc\n");
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
> +	*(buf) = reg;
> +	memcpy(buf + 1, data, len);
> +
> +	msg.addr = state->config->demod_address;
> +	msg.flags = 0;
> +	msg.buf = buf;
> +	msg.len = len + 1;
> +
> +	if (debug > 1)
> +		printk(KERN_INFO "m88ds3103: %s:  write regN 0x%02x, len = %d\n",
> +			__func__, reg, len);
> +
> +	ret = i2c_transfer(state->i2c, &msg, 1);
> +	if (ret != 1) {
> +		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x\n",
> +			 __func__, ret, reg);
> +		ret = -EREMOTEIO;
> +	}
> +	
> +error:
> +	kfree(buf);
> +
> +	return ret;
> +}
> +
> +static int m88ds3103_load_firmware(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	const struct firmware *fw;
> +	int i, ret = 0;
> +
> +	dprintk("%s()\n", __func__);
> +		
> +	if (state->skip_fw_load)
> +		return 0;
> +	/* Load firmware */
> +	/* request the firmware, this will block until someone uploads it */	
> +	if(state->demod_id == DS3000_ID){
> +		printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
> +				DS3000_DEFAULT_FIRMWARE);		
> +		ret = request_firmware(&fw, DS3000_DEFAULT_FIRMWARE,
> +					state->i2c->dev.parent);
> +	}else if(state->demod_id == DS3103_ID){
> +		printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
> +				DS3103_DEFAULT_FIRMWARE);
> +		ret = request_firmware(&fw, DS3103_DEFAULT_FIRMWARE,
> +					state->i2c->dev.parent);
> +	}
> +	
> +	printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n", __func__);
> +	if (ret) {
> +		printk(KERN_ERR "%s: No firmware uploaded (timeout or file not "
> +				"found?)\n", __func__);
> +		return ret;
> +	}
> +
> +	/* Make sure we don't recurse back through here during loading */
> +	state->skip_fw_load = 1;
> +
> +	dprintk("Firmware is %zu bytes (%02x %02x .. %02x %02x)\n",
> +			fw->size,
> +			fw->data[0],
> +			fw->data[1],
> +			fw->data[fw->size - 2],
> +			fw->data[fw->size - 1]);
> +			
> +	/* stop internal mcu. */
> +	m88ds3103_writereg(state, 0xb2, 0x01);
> +	/* split firmware to download.*/
> +	for(i = 0; i < FW_DOWN_LOOP; i++){
> +		ret = m88ds3103_writeregN(state, 0xb0, &(fw->data[FW_DOWN_SIZE*i]), FW_DOWN_SIZE);
> +		if(ret != 1) break;		
> +	}
> +	/* start internal mcu. */
> +	if(ret == 1)
> +		m88ds3103_writereg(state, 0xb2, 0x00);
> +		
> +	release_firmware(fw);
> +
> +	dprintk("%s: Firmware upload %s\n", __func__,
> +			ret == 1 ? "complete" : "failed");
> +
> +	if(ret == 1) ret = 0;
> +	
> +	/* Ensure firmware is always loaded if required */
> +	state->skip_fw_load = 0;
> +
> +	return ret;
> +}
> +
> +
> +static int m88ds3103_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 data;
> +
> +	dprintk("%s(%d)\n", __func__, voltage);
> +
> +	dprintk("m88ds3103:pin_ctrl = (%02x)\n", state->config->pin_ctrl);
> +	
> +	if(state->config->set_voltage)
> +		state->config->set_voltage(fe, voltage);
> +	
> +	data = m88ds3103_readreg(state, 0xa2);
> +	
> +        if(state->config->pin_ctrl & 0x80){ /*If control pin is assigned.*/
> +	        data &= ~0x03; /* bit0 V/H, bit1 off/on */
> +	        if(state->config->pin_ctrl & 0x02)
> +		     data |= 0x02;
> +
> +	        switch (voltage) {
> +	        case SEC_VOLTAGE_18:
> +		     if((state->config->pin_ctrl & 0x01) == 0)
> +			  data |= 0x01;
> +		     break;
> +	        case SEC_VOLTAGE_13:
> +		     if(state->config->pin_ctrl & 0x01)
> +			  data |= 0x01;
> +		     break;
> +	        case SEC_VOLTAGE_OFF:
> +		     if(state->config->pin_ctrl & 0x02)
> +			   data &= ~0x02;			
> +		     else
> +			   data |= 0x02;
> +		     break;
> +	         }
> +        }
> +
> +	m88ds3103_writereg(state, 0xa2, data);
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t* status)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	int lock = 0;
> +	
> +	*status = 0;
> +	
> +	switch (state->delivery_system){
> +	case SYS_DVBS:
> +		lock = m88ds3103_readreg(state, 0xd1);
> +		dprintk("%s: SYS_DVBS status=%x.\n", __func__, lock);
> +		
> +		if ((lock & 0x07) == 0x07){
> +			/*if((m88ds3103_readreg(state, 0x0d) & 0x07) == 0x07)*/
> +				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER 
> +					| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
> +			
> +		}
> +		break;
> +	case SYS_DVBS2:
> +		lock = m88ds3103_readreg(state, 0x0d);
> +		dprintk("%s: SYS_DVBS2 status=%x.\n", __func__, lock);
> +
> +		if ((lock & 0x8f) == 0x8f)
> +			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER 
> +				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
> +			
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_read_ber(struct dvb_frontend *fe, u32* ber)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 tmp1, tmp2, tmp3;
> +	u32 ldpc_frame_cnt, pre_err_packags, code_rate_fac = 0;
> +
> +	dprintk("%s()\n", __func__);
> +
> +	switch (state->delivery_system) {
> +	case SYS_DVBS:
> +		m88ds3103_writereg(state, 0xf9, 0x04);
> +		tmp3 = m88ds3103_readreg(state, 0xf8);
> +		if ((tmp3&0x10) == 0){
> +			tmp1 = m88ds3103_readreg(state, 0xf7);
> +			tmp2 = m88ds3103_readreg(state, 0xf6);
> +			tmp3 |= 0x10;
> +			m88ds3103_writereg(state, 0xf8, tmp3);
> +			state->preBer = (tmp1<<8) | tmp2;
> +		}
> +		break;
> +	case SYS_DVBS2:
> +		tmp1 = m88ds3103_readreg(state, 0x7e) & 0x0f;
> +		switch(tmp1){
> +		case 0:	code_rate_fac = 16008 - 80; break;
> +		case 1:	code_rate_fac = 21408 - 80; break;
> +		case 2:	code_rate_fac = 25728 - 80; break;
> +		case 3:	code_rate_fac = 32208 - 80; break;
> +		case 4:	code_rate_fac = 38688 - 80; break;
> +		case 5:	code_rate_fac = 43040 - 80; break;
> +		case 6:	code_rate_fac = 48408 - 80; break;
> +		case 7:	code_rate_fac = 51648 - 80; break;
> +		case 8:	code_rate_fac = 53840 - 80; break;
> +		case 9:	code_rate_fac = 57472 - 80; break;
> +		case 10: code_rate_fac = 58192 - 80; break;
> +		}
> +		
> +		tmp1 = m88ds3103_readreg(state, 0xd7) & 0xff;
> +		tmp2 = m88ds3103_readreg(state, 0xd6) & 0xff;
> +		tmp3 = m88ds3103_readreg(state, 0xd5) & 0xff;		
> +		ldpc_frame_cnt = (tmp1 << 16) | (tmp2 << 8) | tmp3;
> +
> +		tmp1 = m88ds3103_readreg(state, 0xf8) & 0xff;
> +		tmp2 = m88ds3103_readreg(state, 0xf7) & 0xff;
> +		pre_err_packags = tmp1<<8 | tmp2;
> +		
> +		if (ldpc_frame_cnt > 1000){
> +			m88ds3103_writereg(state, 0xd1, 0x01);
> +			m88ds3103_writereg(state, 0xf9, 0x01);
> +			m88ds3103_writereg(state, 0xf9, 0x00);
> +			m88ds3103_writereg(state, 0xd1, 0x00);
> +			state->preBer = pre_err_packags;
> +		} 				
> +		break;
> +	default:
> +		break;
> +	}
> +	*ber = state->preBer;
> +	
> +	return 0;
> +}
> +
> +static int m88ds3103_read_signal_strength(struct dvb_frontend *fe,
> +						u16 *signal_strength)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u16 gain;
> +	u8 gain1, gain2, gain3 = 0;
> +
> +	dprintk("%s()\n", __func__);
> +
> +	gain1 = m88ds3103_tuner_readreg(state, 0x3d) & 0x1f;
> +	dprintk("%s: gain1 = 0x%02x \n", __func__, gain1);
> +	
> +	if (gain1 > 15) gain1 = 15;
> +	gain2 = m88ds3103_tuner_readreg(state, 0x21) & 0x1f;
> +	dprintk("%s: gain2 = 0x%02x \n", __func__, gain2);
> +	
> +	if(state->tuner_id == TS2022_ID){
> +		gain3 = (m88ds3103_tuner_readreg(state, 0x66)>>3) & 0x07;
> +		dprintk("%s: gain3 = 0x%02x \n", __func__, gain3);
> +		
> +		if (gain2 > 16) gain2 = 16;
> +		if (gain2 < 2) gain2 = 2;			
> +		if (gain3 > 6) gain3 = 6;
> +	}else{
> +		if (gain2 > 13) gain2 = 13;
> +		gain3 = 0;
> +	}
> +
> +	gain = gain1*23 + gain2*35 + gain3*29;
> +	*signal_strength = 60000 - gain*55;
> +
> +	return 0;
> +}
> +
> +
> +static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *p_snr)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 val, npow1, npow2, spow1, cnt;
> +	u16 tmp, snr;
> +	u32 npow, spow, snr_total;	
> +	static const u16 mes_log10[] ={
> +		0,	3010,	4771,	6021, 	6990,	7781,	8451,	9031,	9542,	10000,
> +		10414,	10792,	11139,	11461,	11761,	12041,	12304,	12553,	12788,	13010,
> +		13222,	13424,	13617,	13802,	13979,	14150,	14314,	14472,	14624,	14771,
> +		14914,	15052,	15185,	15315,	15441,	15563,	15682,	15798,	15911,	16021,
> +		16128,	16232,	16335,	16435,	16532,	16628,	16721,	16812,	16902,	16990,
> +		17076,	17160,	17243,	17324,	17404,	17482,	17559,	17634,	17709,	17782,
> +		17853,	17924,	17993,	18062,	18129,	18195,	18261,	18325,	18388,	18451,
> +		18513,	18573,	18633,	18692,	18751,	18808,	18865,	18921,	18976,	19031
> +	};
> +	static const u16 mes_loge[] ={
> +		0,	6931,	10986,	13863, 	16094,	17918,	19459,	20794,	21972,	23026,
> +		23979,	24849,	25649,	26391,	27081,	27726,	28332,	28904,	29444,	29957,
> +		30445,	30910,	31355,	31781,	32189,	32581,	32958,	33322,	33673,	34012,
> +		34340,	34657,
> +	};
> +
> +	dprintk("%s()\n", __func__);
> +
> +	snr = 0;
> +	
> +	switch (state->delivery_system){
> +	case SYS_DVBS:
> +		cnt = 10; snr_total = 0;
> +		while(cnt > 0){
> +			val = m88ds3103_readreg(state, 0xff);
> +			snr_total += val;
> +			cnt--;
> +		}
> +		tmp = (u16)(snr_total/80);
> +		if(tmp > 0){
> +			if (tmp > 32) tmp = 32;
> +			snr = (mes_loge[tmp - 1] * 100) / 45;
> +		}else{
> +			snr = 0;
> +		}
> +		break;
> +	case SYS_DVBS2:
> +		cnt  = 10; npow = 0; spow = 0;
> +		while(cnt >0){
> +			npow1 = m88ds3103_readreg(state, 0x8c) & 0xff;
> +			npow2 = m88ds3103_readreg(state, 0x8d) & 0xff;
> +			npow += (((npow1 & 0x3f) + (u16)(npow2 << 6)) >> 2);
> +
> +			spow1 = m88ds3103_readreg(state, 0x8e) & 0xff;
> +			spow += ((spow1 * spow1) >> 1);
> +			cnt--;
> +		}
> +		npow /= 10; spow /= 10;
> +		if(spow == 0){
> +			snr = 0;
> +		}else if(npow == 0){
> +			snr = 19;
> +		}else{
> +			if(spow > npow){
> +				tmp = (u16)(spow / npow);
> +				if (tmp > 80) tmp = 80;
> +				snr = mes_log10[tmp - 1]*3;
> +			}else{
> +				tmp = (u16)(npow / spow);
> +				if (tmp > 80) tmp = 80;
> +				snr = -(mes_log10[tmp - 1] / 1000);
> +			}
> +		}			
> +		break;
> +	default:
> +		break;
> +	}
> +	*p_snr = snr;
> +
> +	return 0;
> +}
> +
> +
> +static int m88ds3103_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 tmp1, tmp2, tmp3, data;
> +
> +	dprintk("%s()\n", __func__);
> +
> +	switch (state->delivery_system) {
> +	case SYS_DVBS:
> +		data = m88ds3103_readreg(state, 0xf8);
> +		data |= 0x40;
> +		m88ds3103_writereg(state, 0xf8, data);		
> +		tmp1 = m88ds3103_readreg(state, 0xf5);
> +		tmp2 = m88ds3103_readreg(state, 0xf4);
> +		*ucblocks = (tmp1 <<8) | tmp2;		
> +		data &= ~0x20;
> +		m88ds3103_writereg(state, 0xf8, data);
> +		data |= 0x20;
> +		m88ds3103_writereg(state, 0xf8, data);
> +		data &= ~0x40;
> +		m88ds3103_writereg(state, 0xf8, data);
> +		break;
> +	case SYS_DVBS2:
> +		tmp1 = m88ds3103_readreg(state, 0xda);
> +		tmp2 = m88ds3103_readreg(state, 0xd9);
> +		tmp3 = m88ds3103_readreg(state, 0xd8);
> +		*ucblocks = (tmp1 <<16)|(tmp2 <<8)|tmp3;
> +		data = m88ds3103_readreg(state, 0xd1);
> +		data |= 0x01;
> +		m88ds3103_writereg(state, 0xd1, data);
> +		data &= ~0x01;
> +		m88ds3103_writereg(state, 0xd1, data);
> +		break;
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int m88ds3103_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 data_a1, data_a2;
> +
> +	dprintk("%s(%d)\n", __func__, tone);
> +	if ((tone != SEC_TONE_ON) && (tone != SEC_TONE_OFF)) {
> +		printk(KERN_ERR "%s: Invalid, tone=%d\n", __func__, tone);
> +		return -EINVAL;
> +	}
> +
> +	data_a1 = m88ds3103_readreg(state, 0xa1);
> +	data_a2 = m88ds3103_readreg(state, 0xa2);
> +	if(state->demod_id == DS3103_ID)
> +		data_a2 &= 0xdf; /* Normal mode */
> +	switch (tone) {
> +	case SEC_TONE_ON:
> +		dprintk("%s: SEC_TONE_ON\n", __func__);
> +		data_a1 |= 0x04;
> +		data_a1 &= ~0x03;
> +		data_a1 &= ~0x40;
> +		data_a2 &= ~0xc0;
> +		break;
> +	case SEC_TONE_OFF:
> +		dprintk("%s: SEC_TONE_OFF\n", __func__);
> +		data_a2 &= ~0xc0;
> +		data_a2 |= 0x80;
> +		break;
> +	}
> +	m88ds3103_writereg(state, 0xa2, data_a2);
> +	m88ds3103_writereg(state, 0xa1, data_a1);
> +	return 0;
> +}
> +
> +static int m88ds3103_send_diseqc_msg(struct dvb_frontend *fe,
> +				struct dvb_diseqc_master_cmd *d)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	int i, ret = 0;
> +	u8 tmp, time_out;
> +
> +	/* Dump DiSEqC message */
> +	if (debug) {
> +		printk(KERN_INFO "m88ds3103: %s(", __func__);
> +		for (i = 0 ; i < d->msg_len ;) {
> +			printk(KERN_INFO "0x%02x", d->msg[i]);
> +			if (++i < d->msg_len)
> +				printk(KERN_INFO ", ");
> +		}
> +	}
> +
> +	tmp = m88ds3103_readreg(state, 0xa2);
> +	tmp &= ~0xc0;
> +	if(state->demod_id == DS3103_ID)
> +		tmp &= ~0x20;
> +	m88ds3103_writereg(state, 0xa2, tmp);
> +	
> +	for (i = 0; i < d->msg_len; i ++)
> +		m88ds3103_writereg(state, (0xa3+i), d->msg[i]);
> +
> +	tmp = m88ds3103_readreg(state, 0xa1);	
> +	tmp &= ~0x38;
> +	tmp &= ~0x40;
> +	tmp |= ((d->msg_len-1) << 3) | 0x07;
> +	tmp &= ~0x80;
> +	m88ds3103_writereg(state, 0xa1, tmp);
> +	/*	1.5 * 9 * 8	= 108ms	*/
> +	time_out = 150;
> +	while (time_out > 0){
> +		msleep(10);
> +		time_out -= 10;
> +		tmp = m88ds3103_readreg(state, 0xa1);		
> +		if ((tmp & 0x40) == 0)
> +			break;
> +	}
> +	if (time_out == 0){
> +		tmp = m88ds3103_readreg(state, 0xa1);
> +		tmp &= ~0x80;
> +		tmp |= 0x40;
> +		m88ds3103_writereg(state, 0xa1, tmp);
> +		ret = 1;
> +	}
> +	tmp = m88ds3103_readreg(state, 0xa2);
> +	tmp &= ~0xc0;
> +	tmp |= 0x80;
> +	m88ds3103_writereg(state, 0xa2, tmp);	
> +	return ret;
> +}
> +
> +
> +static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
> +					fe_sec_mini_cmd_t burst)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8	val, time_out;
> +	
> +	dprintk("%s()\n", __func__);
> +
> +	val = m88ds3103_readreg(state, 0xa2);
> +	val &= ~0xc0;
> +	if(state->demod_id == DS3103_ID)
> +		val &= 0xdf; /* Normal mode */
> +	m88ds3103_writereg(state, 0xa2, val);
> +	/* DiSEqC burst */
> +	if (burst == SEC_MINI_B)
> +		m88ds3103_writereg(state, 0xa1, 0x01);
> +	else
> +		m88ds3103_writereg(state, 0xa1, 0x02);
> +
> +	msleep(13);
> +
> +	time_out = 5;
> +	do{
> +		val = m88ds3103_readreg(state, 0xa1);
> +		if ((val & 0x40) == 0)
> +			break;
> +		msleep(1);
> +		time_out --;
> +	} while (time_out > 0);
> +
> +	val = m88ds3103_readreg(state, 0xa2);
> +	val &= ~0xc0;
> +	val |= 0x80;
> +	m88ds3103_writereg(state, 0xa2, val);
> +	
> +	return 0;
> +}
> +
> +static void m88ds3103_release(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +
> +	dprintk("%s\n", __func__);
> +	kfree(state);
> +}
> +
> +static int m88ds3103_check_id(struct m88ds3103_state *state)
> +{
> +	int val_00, val_01;
> +	
> +	/*check demod id*/
> +	val_01 = m88ds3103_readreg(state, 0x01);
> +	printk(KERN_INFO "DS3000 chip version: %x attached.\n", val_01);
> +			
> +	if(val_01 == 0xD0)
> +		state->demod_id = DS3103_ID;
> +	else if(val_01 == 0xC0)
> +		state->demod_id = DS3000_ID;
> +	else
> +		state->demod_id = UNKNOW_ID;
> +		
> +	/*check tuner id*/
> +	val_00 = m88ds3103_tuner_readreg(state, 0x00);
> +	printk(KERN_INFO "TS202x chip version[1]: %x attached.\n", val_00);
> +	val_00 &= 0x03;
> +	if(val_00 == 0)
> +	{
> +		m88ds3103_tuner_writereg(state, 0x00, 0x01);
> +		msleep(3);		
> +	}
> +	m88ds3103_tuner_writereg(state, 0x00, 0x03);
> +	msleep(5);
> +	
> +	val_00 = m88ds3103_tuner_readreg(state, 0x00);
> +	printk(KERN_INFO "TS202x chip version[2]: %x attached.\n", val_00);
> +	val_00 &= 0xff;
> +	if((val_00 == 0x01) || (val_00 == 0x41) || (val_00 == 0x81))
> +		state->tuner_id = TS2020_ID;
> +	else if(((val_00 & 0xc0)== 0xc0) || (val_00 == 0x83))
> +		state->tuner_id = TS2022_ID;
> +	else
> +		state->tuner_id = UNKNOW_ID;
> +			
> +	return state->demod_id;	
> +}
> +
> +static struct dvb_frontend_ops m88ds3103_ops;
> +static int m88ds3103_initilaze(struct dvb_frontend *fe);
> +
> +struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *config,
> +				    struct i2c_adapter *i2c)
> +{
> +	struct m88ds3103_state *state = NULL;
> +
> +	dprintk("%s\n", __func__);
> +
> +	/* allocate memory for the internal state */
> +	state = kzalloc(sizeof(struct m88ds3103_state), GFP_KERNEL);
> +	if (state == NULL) {
> +		printk(KERN_ERR "Unable to kmalloc\n");
> +		goto error2;
> +	}
> +
> +	state->config = config;
> +	state->i2c = i2c;
> +	state->preBer = 0xffff;
> +	state->delivery_system = SYS_DVBS; /*Default to DVB-S.*/
> +	
> +	/* check demod id */
> +	if(m88ds3103_check_id(state) == UNKNOW_ID){
> +		printk(KERN_ERR "Unable to find Montage chip\n");
> +		goto error3;
> +	}
> +
> +	memcpy(&state->frontend.ops, &m88ds3103_ops,
> +			sizeof(struct dvb_frontend_ops));
> +	state->frontend.demodulator_priv = state;
> +	
> +	m88ds3103_initilaze(&state->frontend);
> +	
> +	return &state->frontend;
> +
> +error3:
> +	kfree(state);
> +error2:
> +	return NULL;
> +}
> +EXPORT_SYMBOL(m88ds3103_attach);
> +
> +static int m88ds3103_set_carrier_offset(struct dvb_frontend *fe,
> +					s32 carrier_offset_khz)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	s32 tmp;
> +
> +	tmp = carrier_offset_khz;
> +	tmp *= 65536;
> +	
> +	tmp = (2*tmp + MT_FE_MCLK_KHZ) / (2*MT_FE_MCLK_KHZ);
> +
> +	if (tmp < 0)
> +		tmp += 65536;
> +
> +	m88ds3103_writereg(state, 0x5f, tmp >> 8);
> +	m88ds3103_writereg(state, 0x5e, tmp & 0xff);
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_set_symrate(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u16 value;
> +	
> +	value = (((c->symbol_rate / 1000) << 15) + (MT_FE_MCLK_KHZ / 4)) / (MT_FE_MCLK_KHZ / 2);
> +	m88ds3103_writereg(state, 0x61, value & 0x00ff);
> +	m88ds3103_writereg(state, 0x62, (value & 0xff00) >> 8);
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_set_CCI(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 tmp;
> +
> +	tmp = m88ds3103_readreg(state, 0x56);
> +	tmp &= ~0x01;
> +	m88ds3103_writereg(state, 0x56, tmp);
> +
> +	tmp = m88ds3103_readreg(state, 0x76);
> +	tmp &= ~0x80;
> +	m88ds3103_writereg(state, 0x76, tmp);
> +
> +	return 0;
> +}
> +
> +static int m88ds3103_init_reg(struct m88ds3103_state *state, const u8 *p_reg_tab, u32 size)
> +{
> +	u32 i;
> +	
> +	for(i = 0; i < size; i+=2)
> +		m88ds3103_writereg(state, p_reg_tab[i], p_reg_tab[i+1]);
> +		
> +	return 0;
> +}
> +
> +static int m88ds3103_demod_connect(struct dvb_frontend *fe, s32 carrier_offset_khz) 
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u16 value;
> +	u8 val1,val2,data;
> +	
> +	dprintk("connect delivery system = %d\n", state->delivery_system);
> +	
> +	/* ds3000 global reset */
> +	m88ds3103_writereg(state, 0x07, 0x80);
> +	m88ds3103_writereg(state, 0x07, 0x00);
> +	/* ds3000 build-in uC reset */
> +	m88ds3103_writereg(state, 0xb2, 0x01);
> +	/* ds3000 software reset */
> +	m88ds3103_writereg(state, 0x00, 0x01);
> +
> +	switch (state->delivery_system) {
> +	case SYS_DVBS:
> +		/* initialise the demod in DVB-S mode */
> +		if(state->demod_id == DS3000_ID){
> +			m88ds3103_init_reg(state, ds3000_dvbs_init_tab, sizeof(ds3000_dvbs_init_tab));
> +			
> +			value = m88ds3103_readreg(state, 0xfe);
> +			value &= 0xc0;
> +			value |= 0x1b;
> +			m88ds3103_writereg(state, 0xfe, value);
> +			
> +			if(state->config->ci_mode)
> +				val1 = 0x80;
> +			else if(state->config->ts_mode)
> +				val1 = 0x60;
> +			else
> +				val1 = 0x20;
> +			m88ds3103_writereg(state, 0xfd, val1);
> +			
> +		}else if(state->demod_id == DS3103_ID){
> +			m88ds3103_init_reg(state, ds3103_dvbs_init_tab, sizeof(ds3103_dvbs_init_tab));
> +			
> +			/* set ts clock */
> +			if(state->config->ts_mode == 0)	{
> +				val1 = 3; val2 = 3;
> +			}else{
> +				val1 = 0; val2 = 0;
> +			}
> +			val1 -= 1; val2 -= 1;
> +			val1 &= 0x3f; val2 &= 0x3f;
> +			data = m88ds3103_readreg(state, 0xfe);
> +			data &= 0xf0;
> +			data |= (val2 >> 2) & 0x0f;
> +			m88ds3103_writereg(state, 0xfe, data);
> +			data = (val2 & 0x03) << 6;
> +			data |= val1;
> +			m88ds3103_writereg(state, 0xea, data);
> +			
> +			m88ds3103_writereg(state, 0x4d, 0xfd & m88ds3103_readreg(state, 0x4d));
> +			m88ds3103_writereg(state, 0x30, 0xef & m88ds3103_readreg(state, 0x30));
> +			
> +			/* set master clock */
> +			val1 = m88ds3103_readreg(state, 0x22);
> +			val2 = m88ds3103_readreg(state, 0x24);
> +			
> +			val1 &= 0x3f;
> +			val2 &= 0x3f;
> +			val1 |= 0x80;
> +			val2 |= 0x40;
> +
> +			m88ds3103_writereg(state, 0x22, val1);
> +			m88ds3103_writereg(state, 0x24, val2);	
> +			
> +			if(state->config->ci_mode)
> +				val1 = 0x03;
> +			else if(state->config->ts_mode)
> +				val1 = 0x06;
> +			else
> +				val1 = 0x42;
> +			m88ds3103_writereg(state, 0xfd, val1);		
> +		}
> +		break;
> +	case SYS_DVBS2:
> +		/* initialise the demod in DVB-S2 mode */
> +		if(state->demod_id == DS3000_ID){
> +			m88ds3103_init_reg(state, ds3000_dvbs2_init_tab, sizeof(ds3000_dvbs2_init_tab));
> +		
> +			if (c->symbol_rate >= 30000000)
> +				m88ds3103_writereg(state, 0xfe, 0x54);
> +			else
> +				m88ds3103_writereg(state, 0xfe, 0x98);
> +								
> +		}else if(state->demod_id == DS3103_ID){
> +			m88ds3103_init_reg(state, ds3103_dvbs2_init_tab, sizeof(ds3103_dvbs2_init_tab));
> +
> +			/* set ts clock */
> +			if(state->config->ts_mode == 0){
> +				val1 = 5; val2 = 4;
> +			}else{
> +				val1 = 0; val2 = 0;
> +			}
> +			val1 -= 1; val2 -= 1;
> +			val1 &= 0x3f; val2 &= 0x3f;
> +			data = m88ds3103_readreg(state, 0xfe);
> +			data &= 0xf0;
> +			data |= (val2 >> 2) & 0x0f;
> +			m88ds3103_writereg(state, 0xfe, data);
> +			data = (val2 & 0x03) << 6;
> +			data |= val1;
> +			m88ds3103_writereg(state, 0xea, data);
> +			
> +			m88ds3103_writereg(state, 0x4d, 0xfd & m88ds3103_readreg(state, 0x4d));
> +			m88ds3103_writereg(state, 0x30, 0xef & m88ds3103_readreg(state, 0x30));
> +			
> +			/* set master clock */
> +			val1 = m88ds3103_readreg(state, 0x22);
> +			val2 = m88ds3103_readreg(state, 0x24);
> +			
> +			val1 &= 0x3f;
> +			val2 &= 0x3f;
> +			if(state->config->ts_mode == 1){
> +				val1 |= 0x80;
> +				val2 |= 0x40;
> +			}else{
> +				if (c->symbol_rate >= 28000000){
> +					val1 |= 0xc0;
> +				}else if (c->symbol_rate >= 18000000){
> +					val2 |= 0x40;
> +				}else{
> +					val1 |= 0x80;
> +					val2 |= 0x40;
> +				}				
> +			}
> +			m88ds3103_writereg(state, 0x22, val1);
> +			m88ds3103_writereg(state, 0x24, val2);					
> +		}
> +		
> +		if(state->config->ci_mode)
> +			val1 = 0x03;
> +		else if(state->config->ts_mode)
> +			val1 = 0x06;
> +		else
> +			val1 = 0x42;
> +		m88ds3103_writereg(state, 0xfd, val1);
> +		
> +		break;
> +	default:
> +		return 1;
> +	}
> +	/* disable 27MHz clock output */
> +	m88ds3103_writereg(state, 0x29, 0x80);
> +	/* enable ac coupling */
> +	m88ds3103_writereg(state, 0x25, 0x8a);
> +
> +	if ((c->symbol_rate / 1000) <= 3000){
> +		m88ds3103_writereg(state, 0xc3, 0x08); /* 8 * 32 * 100 / 64 = 400*/
> +		m88ds3103_writereg(state, 0xc8, 0x20);
> +		m88ds3103_writereg(state, 0xc4, 0x08); /* 8 * 0 * 100 / 128 = 0*/
> +		m88ds3103_writereg(state, 0xc7, 0x00);
> +	}else if((c->symbol_rate / 1000) <= 10000){
> +		m88ds3103_writereg(state, 0xc3, 0x08); /* 8 * 16 * 100 / 64 = 200*/
> +		m88ds3103_writereg(state, 0xc8, 0x10);
> +		m88ds3103_writereg(state, 0xc4, 0x08); /* 8 * 0 * 100 / 128 = 0*/
> +		m88ds3103_writereg(state, 0xc7, 0x00);
> +	}else{
> +		m88ds3103_writereg(state, 0xc3, 0x08); /* 8 * 6 * 100 / 64 = 75*/
> +		m88ds3103_writereg(state, 0xc8, 0x06);
> +		m88ds3103_writereg(state, 0xc4, 0x08); /* 8 * 0 * 100 / 128 = 0*/
> +		m88ds3103_writereg(state, 0xc7, 0x00);
> +	}
> +
> +	m88ds3103_set_symrate(fe);
> +	
> +	m88ds3103_set_CCI(fe);
> +
> +	m88ds3103_set_carrier_offset(fe, carrier_offset_khz);
> +		
> +	/* ds3000 out of software reset */
> +	m88ds3103_writereg(state, 0x00, 0x00);
> +	/* start ds3000 build-in uC */
> +	m88ds3103_writereg(state, 0xb2, 0x00);	
> +	
> +	return 0;
> +}
> +
> +static int m88ds3103_set_frontend(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +
> +	int i;
> +	fe_status_t status;
> +	u8 lpf_mxdiv, mlpf_max, mlpf_min, nlpf, div4, capCode, changePLL;
> +	s32 offset_khz, lpf_offset_KHz;
> +	u16 value, ndiv, lpf_coeff;
> +	u32 f3db, gdiv28, realFreq;
> +	u8 RFgain;
> +
> +	dprintk("%s() ", __func__);
> +	dprintk("c frequency = %d\n", c->frequency);
> +	dprintk("symbol rate = %d\n", c->symbol_rate);
> +	dprintk("delivery system = %d\n", c->delivery_system);
> +	
> +	realFreq = c->frequency;
> +	lpf_offset_KHz = 0;
> +	if(c->symbol_rate < 5000000){
> +		lpf_offset_KHz = FREQ_OFFSET_AT_SMALL_SYM_RATE_KHz;
> +		realFreq += FREQ_OFFSET_AT_SMALL_SYM_RATE_KHz;
> +	}
> +	
> +	if (state->config->set_ts_params)
> +		state->config->set_ts_params(fe, 0);
> +
> +	div4 = 0;
> +	RFgain = 0;
> +	if(state->tuner_id == TS2022_ID){
> +		m88ds3103_tuner_writereg(state, 0x10, 0x0a);
> +		m88ds3103_tuner_writereg(state, 0x11, 0x40);
> +		if (realFreq < 1103000) {
> +			m88ds3103_tuner_writereg(state, 0x10, 0x1b);
> +			div4 = 1;
> +			ndiv = (realFreq * (6 + 8) * 4)/MT_FE_CRYSTAL_KHZ;				
> +		}else {
> +			ndiv = (realFreq * (6 + 8) * 2)/MT_FE_CRYSTAL_KHZ;
> +		}
> +		ndiv = ndiv + ndiv%2;
> +		if(ndiv < 4095)
> +			ndiv = ndiv - 1024;
> +		else if (ndiv < 6143)
> +			ndiv = ndiv + 1024;
> +		else
> +			ndiv = ndiv + 3072;	
> +		
> +		m88ds3103_tuner_writereg(state, 0x01, (ndiv & 0x3f00) >> 8);											
> +	}else{
> +		m88ds3103_tuner_writereg(state, 0x10, 0x00);			
> +		if (realFreq < 1146000){
> +			m88ds3103_tuner_writereg(state, 0x10, 0x11);
> +			div4 = 1;
> +			ndiv = (realFreq * (6 + 8) * 4) / MT_FE_CRYSTAL_KHZ;
> +		}else{
> +			m88ds3103_tuner_writereg(state, 0x10, 0x01);
> +			ndiv = (realFreq * (6 + 8) * 2) / MT_FE_CRYSTAL_KHZ;
> +		}
> +		ndiv = ndiv + ndiv%2;
> +		ndiv = ndiv - 1024;
> +		m88ds3103_tuner_writereg(state, 0x01, (ndiv>>8)&0x0f);
> +	}
> +	/* set pll */
> +	m88ds3103_tuner_writereg(state, 0x02, ndiv & 0x00ff);
> +	m88ds3103_tuner_writereg(state, 0x03, 0x06);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x0f);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x10);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x00);	
> +
> +	if(state->tuner_id == TS2022_ID){
> +		if(( realFreq >= 1650000 ) && (realFreq <= 1850000)){
> +			msleep(5);
> +			value = m88ds3103_tuner_readreg(state, 0x14);
> +			value &= 0x7f;
> +			if(value < 64){
> +				m88ds3103_tuner_writereg(state, 0x10, 0x82);
> +				m88ds3103_tuner_writereg(state, 0x11, 0x6f);
> +
> +				m88ds3103_tuner_writereg(state, 0x51, 0x0f);
> +				m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +				m88ds3103_tuner_writereg(state, 0x50, 0x10);
> +				m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +			}
> +		}
> +		msleep(5);
> +		value = m88ds3103_tuner_readreg(state, 0x14);
> +		value &= 0x1f;
> +
> +		if(value > 19){
> +			value = m88ds3103_tuner_readreg(state, 0x10);
> +			value &= 0x1d;
> +			m88ds3103_tuner_writereg(state, 0x10, value);
> +		}				
> +	}else{
> +		msleep(5);
> +		value = m88ds3103_tuner_readreg(state, 0x66);
> +		changePLL = (((value & 0x80) >> 7) != div4);
> +
> +		if(changePLL){
> +			m88ds3103_tuner_writereg(state, 0x10, 0x11);
> +			div4 = 1;
> +			ndiv = (realFreq * (6 + 8) * 4)/MT_FE_CRYSTAL_KHZ;
> +			ndiv = ndiv + ndiv%2;
> +			ndiv = ndiv - 1024;
> +					
> +			m88ds3103_tuner_writereg(state, 0x01, (ndiv>>8) & 0x0f);
> +			m88ds3103_tuner_writereg(state, 0x02, ndiv & 0xff);
> +			
> +			m88ds3103_tuner_writereg(state, 0x51, 0x0f);
> +			m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +			m88ds3103_tuner_writereg(state, 0x50, 0x10);
> +			m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +		}		
> +	}
> +	/*set the RF gain*/
> +	if(state->tuner_id == TS2020_ID)
> +		m88ds3103_tuner_writereg(state, 0x60, 0x79);
> +			
> +	m88ds3103_tuner_writereg(state, 0x51, 0x17);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x08);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	if(state->tuner_id == TS2020_ID){
> +		RFgain = m88ds3103_tuner_readreg(state, 0x3d);
> +		RFgain &= 0x0f;
> +		if(RFgain < 15){
> +			if(RFgain < 4) 
> +				RFgain = 0;
> +			else
> +				RFgain = RFgain -3;
> +			value = ((RFgain << 3) | 0x01) & 0x79;
> +			m88ds3103_tuner_writereg(state, 0x60, value);
> +			m88ds3103_tuner_writereg(state, 0x51, 0x17);
> +			m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +			m88ds3103_tuner_writereg(state, 0x50, 0x08);
> +			m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +		}
> +	}
> +	
> +	/* set the LPF */
> +	if(state->tuner_id == TS2022_ID){
> +		m88ds3103_tuner_writereg(state, 0x25, 0x00);
> +		m88ds3103_tuner_writereg(state, 0x27, 0x70);
> +		m88ds3103_tuner_writereg(state, 0x41, 0x09);
> +		m88ds3103_tuner_writereg(state, 0x08, 0x0b);
> +	}
> +
> +	f3db = ((c->symbol_rate / 1000) *135) / 200 + 2000;
> +	f3db += lpf_offset_KHz;
> +	if (f3db < 7000)
> +		f3db = 7000;
> +	if (f3db > 40000)
> +		f3db = 40000;
> +			
> +	gdiv28 = (MT_FE_CRYSTAL_KHZ / 1000 * 1694 + 500) / 1000;
> +	m88ds3103_tuner_writereg(state, 0x04, gdiv28 & 0xff);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1b);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x04);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	value = m88ds3103_tuner_readreg(state, 0x26);
> +	capCode = value & 0x3f;
> +	if(state->tuner_id == TS2022_ID){
> +		m88ds3103_tuner_writereg(state, 0x41, 0x0d);
> +
> +		m88ds3103_tuner_writereg(state, 0x51, 0x1b);
> +		m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +		m88ds3103_tuner_writereg(state, 0x50, 0x04);
> +		m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +
> +		msleep(2);
> +
> +		value = m88ds3103_tuner_readreg(state, 0x26);
> +		value &= 0x3f;
> +		value = (capCode + value) / 2;		
> +	}
> +	else
> +		value = capCode;
> +		
> +	gdiv28 = gdiv28 * 207 / (value * 2 + 151);	
> +	mlpf_max = gdiv28 * 135 / 100;
> +	mlpf_min = gdiv28 * 78 / 100;
> +	if (mlpf_max > 63)
> +		mlpf_max = 63;
> +
> +	if(state->tuner_id == TS2022_ID)
> +		lpf_coeff = 3200;
> +	else
> +		lpf_coeff = 2766;
> +		
> +	nlpf = (f3db * gdiv28 * 2 / lpf_coeff / (MT_FE_CRYSTAL_KHZ / 1000)  + 1) / 2 ;	
> +	if (nlpf > 23) nlpf = 23;
> +	if (nlpf < 1) nlpf = 1;
> +
> +	lpf_mxdiv = (nlpf * (MT_FE_CRYSTAL_KHZ / 1000) * lpf_coeff * 2 / f3db + 1) / 2;
> +
> +	if (lpf_mxdiv < mlpf_min){
> +		nlpf++;
> +		lpf_mxdiv = (nlpf * (MT_FE_CRYSTAL_KHZ / 1000) * lpf_coeff * 2  / f3db + 1) / 2;
> +	}
> +
> +	if (lpf_mxdiv > mlpf_max)
> +		lpf_mxdiv = mlpf_max;
> +
> +	m88ds3103_tuner_writereg(state, 0x04, lpf_mxdiv);
> +	m88ds3103_tuner_writereg(state, 0x06, nlpf);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1b);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x04);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +	
> +	if(state->tuner_id == TS2022_ID){
> +		msleep(2);
> +		value = m88ds3103_tuner_readreg(state, 0x26);
> +		capCode = value & 0x3f;
> +
> +		m88ds3103_tuner_writereg(state, 0x41, 0x09);
> +
> +		m88ds3103_tuner_writereg(state, 0x51, 0x1b);
> +		m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +		m88ds3103_tuner_writereg(state, 0x50, 0x04);
> +		m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +
> +		msleep(2);
> +		value = m88ds3103_tuner_readreg(state, 0x26);
> +		value &= 0x3f;
> +		value = (capCode + value) / 2;
> +
> +		value = value | 0x80;
> +		m88ds3103_tuner_writereg(state, 0x25, value);
> +		m88ds3103_tuner_writereg(state, 0x27, 0x30);
> +
> +		m88ds3103_tuner_writereg(state, 0x08, 0x09);		
> +	}
> +
> +	/* Set the BB gain */
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1e);
> +	m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x01);
> +	m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +	if(state->tuner_id == TS2020_ID){
> +		if(RFgain == 15){
> +			msleep(40);
> +			value = m88ds3103_tuner_readreg(state, 0x21);
> +			value &= 0x0f;
> +			if(value < 3){
> +				m88ds3103_tuner_writereg(state, 0x60, 0x61);
> +				m88ds3103_tuner_writereg(state, 0x51, 0x17);
> +				m88ds3103_tuner_writereg(state, 0x51, 0x1f);
> +				m88ds3103_tuner_writereg(state, 0x50, 0x08);
> +				m88ds3103_tuner_writereg(state, 0x50, 0x00);
> +			}			
> +		}
> +	}
> +	msleep(60);
> +	
> +	offset_khz = (ndiv - ndiv % 2 + 1024) * MT_FE_CRYSTAL_KHZ
> +		/ (6 + 8) / (div4 + 1) / 2 - realFreq;
> +
> +	m88ds3103_demod_connect(fe, offset_khz+lpf_offset_KHz);
> +
> +	for (i = 0; i < 30 ; i++) {
> +		m88ds3103_read_status(fe, &status);
> +		if (status & FE_HAS_LOCK){
> +			break;
> +                }
> +		msleep(20);
> +	}
> +	
> +	if((status & FE_HAS_LOCK) == 0){
> +		state->delivery_system = (state->delivery_system == SYS_DVBS) ? SYS_DVBS2 : SYS_DVBS;
> +		m88ds3103_demod_connect(fe, offset_khz);
> +	
> +		for (i = 0; i < 30 ; i++) {
> +			m88ds3103_read_status(fe, &status);
> +			if (status & FE_HAS_LOCK){
> +				break;
> +                	}
> +			msleep(20);
> +		}
> +	}
> +	
> +	if (status & FE_HAS_LOCK){
> +		if(state->config->start_ctrl){
> +			if(state->first_lock == 0){
> +				state->config->start_ctrl(fe);
> +				state->first_lock = 1;	
> +			}
> +		}		
> +	}
> +		
> +	return 0;
> +}
> +
> +static int m88ds3103_tune(struct dvb_frontend *fe,
> +			bool re_tune,
> +			unsigned int mode_flags,
> +			unsigned int *delay,
> +			fe_status_t *status)
> +{	
> +	*delay = HZ / 5;
> +	
> +	dprintk("%s() ", __func__);
> +	dprintk("re_tune = %d\n", re_tune);
> +	
> +	if (re_tune) {
> +		int ret = m88ds3103_set_frontend(fe);
> +		if (ret)
> +			return ret;
> +	}
> +	
> +	return m88ds3103_read_status(fe, status);
> +}
> +
> +static enum dvbfe_algo m88ds3103_get_algo(struct dvb_frontend *fe)
> +{
> +	return DVBFE_ALGO_HW;
> +}
> + 
> + /*
> + * Power config will reset and load initial firmware if required
> + */
> +static int m88ds3103_initilaze(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	int ret;
> +
> +	dprintk("%s()\n", __func__);
> +	/* hard reset */
> +	m88ds3103_writereg(state, 0x07, 0x80);
> +	m88ds3103_writereg(state, 0x07, 0x00);
> +	msleep(1);
> +	
> +	m88ds3103_writereg(state, 0x08, 0x01 | m88ds3103_readreg(state, 0x08));
> +	msleep(1);
> +
> +	if(state->tuner_id == TS2020_ID){
> +		/* TS2020 init */
> +		m88ds3103_tuner_writereg(state, 0x42, 0x73);
> +		msleep(2);
> +		m88ds3103_tuner_writereg(state, 0x05, 0x01);
> +		m88ds3103_tuner_writereg(state, 0x62, 0xb5);
> +		m88ds3103_tuner_writereg(state, 0x07, 0x02);
> +		m88ds3103_tuner_writereg(state, 0x08, 0x01);
> +	}
> +	else if(state->tuner_id == TS2022_ID){
> +		/* TS2022 init */
> +		m88ds3103_tuner_writereg(state, 0x62, 0x6c);
> +		msleep(2);
> +		m88ds3103_tuner_writereg(state, 0x42, 0x6c);
> +		msleep(2);
> +		m88ds3103_tuner_writereg(state, 0x7d, 0x9d);
> +		m88ds3103_tuner_writereg(state, 0x7c, 0x9a);
> +		m88ds3103_tuner_writereg(state, 0x7a, 0x76);
> +
> +		m88ds3103_tuner_writereg(state, 0x3b, 0x01);
> +		m88ds3103_tuner_writereg(state, 0x63, 0x88);
> +
> +		m88ds3103_tuner_writereg(state, 0x61, 0x85);
> +		m88ds3103_tuner_writereg(state, 0x22, 0x30);
> +		m88ds3103_tuner_writereg(state, 0x30, 0x40);
> +		m88ds3103_tuner_writereg(state, 0x20, 0x23);
> +		m88ds3103_tuner_writereg(state, 0x24, 0x02);
> +		m88ds3103_tuner_writereg(state, 0x12, 0xa0);	
> +	}
> +		
> +	if(state->demod_id == DS3103_ID){
> +		m88ds3103_writereg(state, 0x07, 0xe0);
> +		m88ds3103_writereg(state, 0x07, 0x00);
> +		msleep(1);		
> +	}
> +	m88ds3103_writereg(state, 0xb2, 0x01);
> +	
> +	/* Load the firmware if required */
> +	ret = m88ds3103_load_firmware(fe);
> +	if (ret != 0){
> +		printk(KERN_ERR "%s: Unable initialize firmware\n", __func__);
> +		return ret;
> +	}
> +	if(state->demod_id == DS3103_ID){
> +		m88ds3103_writereg(state, 0x4d, 0xfd & m88ds3103_readreg(state, 0x4d));
> +		m88ds3103_writereg(state, 0x30, 0xef & m88ds3103_readreg(state, 0x30));		
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Initialise or wake up device
> + */
> +static int m88ds3103_initfe(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +	u8 val;
> +
> +	dprintk("%s()\n", __func__);
> +
> +	/* 1st step to wake up demod */
> +	m88ds3103_writereg(state, 0x08, 0x01 | m88ds3103_readreg(state, 0x08));
> +	m88ds3103_writereg(state, 0x04, 0xfe & m88ds3103_readreg(state, 0x04));
> +	m88ds3103_writereg(state, 0x23, 0xef & m88ds3103_readreg(state, 0x23));
> +	
> +	/* 2nd step to wake up tuner */
> +	val = m88ds3103_tuner_readreg(state, 0x00) & 0xff;
> +	if((val & 0x01) == 0){
> +		m88ds3103_tuner_writereg(state, 0x00, 0x01);
> +		msleep(50);
> +	}
> +	m88ds3103_tuner_writereg(state, 0x00, 0x03);
> +	msleep(50);
> +	
> +	return 0;	
> +}
> +
> +/* Put device to sleep */
> +static int m88ds3103_sleep(struct dvb_frontend *fe)
> +{
> +	struct m88ds3103_state *state = fe->demodulator_priv;
> +
> +	dprintk("%s()\n", __func__);
> +	
> +	/* 1st step to sleep tuner */
> +	m88ds3103_tuner_writereg(state, 0x00, 0x00);
> +	
> +	/* 2nd step to sleep demod */
> +	m88ds3103_writereg(state, 0x08, 0xfe & m88ds3103_readreg(state, 0x08));
> +	m88ds3103_writereg(state, 0x04, 0x01 | m88ds3103_readreg(state, 0x04));
> +	m88ds3103_writereg(state, 0x23, 0x10 | m88ds3103_readreg(state, 0x23));
> +	
> +
> +	return 0;
> +}
> +
> +static struct dvb_frontend_ops m88ds3103_ops = {
> +	.delsys = { SYS_DVBS, SYS_DVBS2},
> +	.info = {
> +		.name = "Montage DS3103/TS2022",
> +		.type = FE_QPSK,
> +		.frequency_min = 950000,
> +		.frequency_max = 2150000,
> +		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
> +		.frequency_tolerance = 5000,
> +		.symbol_rate_min = 1000000,
> +		.symbol_rate_max = 45000000,
> +		.caps = FE_CAN_INVERSION_AUTO |
> +			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> +			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
> +			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +			FE_CAN_2G_MODULATION |
> +			FE_CAN_QPSK | FE_CAN_RECOVER
> +	},
> +
> +	.release = m88ds3103_release,
> +
> +	.init = m88ds3103_initfe,
> +	.sleep = m88ds3103_sleep,
> +	.read_status = m88ds3103_read_status,
> +	.read_ber = m88ds3103_read_ber,
> +	.read_signal_strength = m88ds3103_read_signal_strength,
> +	.read_snr = m88ds3103_read_snr,
> +	.read_ucblocks = m88ds3103_read_ucblocks,
> +	.set_tone = m88ds3103_set_tone,
> +	.set_voltage = m88ds3103_set_voltage,
> +	.diseqc_send_master_cmd = m88ds3103_send_diseqc_msg,
> +	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
> +	.get_frontend_algo = m88ds3103_get_algo,
> +	.tune = m88ds3103_tune,
> +	.set_frontend = m88ds3103_set_frontend,
> +};
> +
> +MODULE_DESCRIPTION("DVB Frontend module for Montage DS3103/TS2022 hardware");
> +MODULE_AUTHOR("Max nibble");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/frontends/m88ds3103.h b/drivers/media/dvb/frontends/m88ds3103.h
> new file mode 100644
> index 0000000..c7b690e
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/m88ds3103.h
> @@ -0,0 +1,53 @@
> +/*
> +    Montage Technology M88DS3103/M88TS2022 - DVBS/S2 Satellite demod/tuner driver
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef M88DS3103_H
> +#define M88DS3103_H
> +
> +#include <linux/dvb/frontend.h>
> +
> +struct m88ds3103_config {
> +	/* the demodulator's i2c address */
> +	u8 demod_address;
> +	u8 ci_mode;
> +	u8 pin_ctrl;
> +	u8 ts_mode; /* 0: Parallel, 1: Serial */
> +
> +	/* Set device param to start dma */
> +	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
> +    /* Start to transfer data */
> +    int (*start_ctrl)(struct dvb_frontend *fe);
> +    /* Set LNB voltage */
> +    int (*set_voltage)(struct dvb_frontend* fe, fe_sec_voltage_t voltage);
> +};
> +
> +#if defined(CONFIG_DVB_M88DS3103) || \
> +	(defined(CONFIG_DVB_M88DS3103_MODULE) && defined(MODULE))
> +extern struct dvb_frontend *m88ds3103_attach(
> +       const struct m88ds3103_config *config,
> +       struct i2c_adapter *i2c);
> +#else
> +static inline struct dvb_frontend *m88ds3103_attach(
> +       const struct m88ds3103_config *config,
> +       struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif /* CONFIG_DVB_M88DS3103 */
> +#endif /* M88DS3103_H */

