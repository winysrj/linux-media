Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0JTT0N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 15:26:13 -0400
Date: Wed, 20 Oct 2010 15:26:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, mrechberger@gmail.com, mkrufky@kernellabs.com
Subject: [PATCH] dvb: remove obsolete lgdt3304 driver
Message-ID: <20101020192609.GE15314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20131B.5090101@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some time ago, Mauro wrote:
...
> From the patch comments:
> 
> 	There's a currently-unused lgdt3304 demod driver, which leaves a lot to
> 	be desired as far as functionality. The 3304 is unsurprisingly quite
> 	similar to the 3305, and empirical testing yeilds far better results
> 	and more complete functionality by merging 3304 support into the 3305
> 	driver. (For example, the current lgdt3304 driver lacks support for
> 	signal strength, snr, ucblocks, etc., which we get w/the lgdt3305).
> 
> 	For the moment, not dropping the lgdt3304 driver, and its still up to
>	a given device's config setup to choose which demod driver to use, but
>	I'd suggest dropping the 3304 driver entirely.
>
> If lgdt3305 driver got superseded, just send me a patch dropping it.
>
> Jarod/Michael,
>
> Please send me a patch removing the legacy driver.

More complete support for the lgdt3304 atsc demodulator was added by way
of the lgdt3305 driver. There's only one device supported in-tree that
has an lgdt3304 (the kworld 340u/ub435-q em28xx stick), and its already
using the lgdt3305-provided variant of lgdt3304 support.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/dvb/frontends/Kconfig    |   10 +-
 drivers/media/dvb/frontends/Makefile   |    1 -
 drivers/media/dvb/frontends/lgdt3304.c |  380 --------------------------------
 drivers/media/dvb/frontends/lgdt3304.h |   45 ----
 4 files changed, 1 insertions(+), 435 deletions(-)
 delete mode 100644 drivers/media/dvb/frontends/lgdt3304.c
 delete mode 100644 drivers/media/dvb/frontends/lgdt3304.h

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 35cb8c5..e9062b0 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -462,16 +462,8 @@ config DVB_LGDT330X
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-config DVB_LGDT3304
-	tristate "LG Electronics LGDT3304"
-	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
-	help
-	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
-	  to support this frontend.
-
 config DVB_LGDT3305
-	tristate "LG Electronics LGDT3305 based"
+	tristate "LG Electronics LGDT3304 and LGDT3305 based"
 	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
 	help
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 63cf3d0..9a31985 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_DVB_OR51132) += or51132.o
 obj-$(CONFIG_DVB_BCM3510) += bcm3510.o
 obj-$(CONFIG_DVB_S5H1420) += s5h1420.o
 obj-$(CONFIG_DVB_LGDT330X) += lgdt330x.o
-obj-$(CONFIG_DVB_LGDT3304) += lgdt3304.o
 obj-$(CONFIG_DVB_LGDT3305) += lgdt3305.o
 obj-$(CONFIG_DVB_CX24123) += cx24123.o
 obj-$(CONFIG_DVB_LNBP21) += lnbp21.o
diff --git a/drivers/media/dvb/frontends/lgdt3304.c b/drivers/media/dvb/frontends/lgdt3304.c
deleted file mode 100644
index 45a529b..0000000
--- a/drivers/media/dvb/frontends/lgdt3304.c
+++ /dev/null
@@ -1,380 +0,0 @@
-/*
- * Driver for LG ATSC lgdt3304 driver
- *
- * Copyright (C) 2008 Markus Rechberger <mrechberger@sundtek.de>
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include "dvb_frontend.h"
-#include "lgdt3304.h"
-
-static  unsigned int debug = 0;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"lgdt3304 debugging (default off)");
-
-#define dprintk(fmt, args...) if (debug) do {\
-			printk("lgdt3304 debug: " fmt, ##args); } while (0)
-
-struct lgdt3304_state
-{
-	struct dvb_frontend frontend;
-	fe_modulation_t current_modulation;
-	__u32 snr;
-	__u32 current_frequency;
-	__u8 addr;
-	struct i2c_adapter *i2c;
-};
-
-static int i2c_write_demod_bytes (struct dvb_frontend *fe, __u8 *buf, int len)
-{
-	struct lgdt3304_state *state = fe->demodulator_priv;
-	struct i2c_msg i2cmsgs = {
-		.addr = state->addr,
-		.flags = 0,
-		.len = 3,
-		.buf = buf
-	};
-	int i;
-	int err;
-
-	for (i=0; i<len-1; i+=3){
-		if((err = i2c_transfer(state->i2c, &i2cmsgs, 1))<0) {
-			printk("%s i2c_transfer error %d\n", __func__, err);
-			if (err < 0)
-				return err;
-			else
-				return -EREMOTEIO;
-		}
-		i2cmsgs.buf += 3;
-	}
-	return 0;
-}
-
-static int lgdt3304_i2c_read_reg(struct dvb_frontend *fe, unsigned int reg)
-{
-	struct lgdt3304_state *state = fe->demodulator_priv;
-	struct i2c_msg i2cmsgs[2];
-	int ret;
-	__u8 buf;
-
-	__u8 regbuf[2] = { reg>>8, reg&0xff };
-
-	i2cmsgs[0].addr = state->addr;
-	i2cmsgs[0].flags = 0;
-	i2cmsgs[0].len = 2;
-	i2cmsgs[0].buf = regbuf;
-
-	i2cmsgs[1].addr = state->addr;
-	i2cmsgs[1].flags = I2C_M_RD;
-	i2cmsgs[1].len = 1;
-	i2cmsgs[1].buf = &buf;
-
-	if((ret = i2c_transfer(state->i2c, i2cmsgs, 2))<0) {
-		printk("%s i2c_transfer error %d\n", __func__, ret);
-		return ret;
-	}
-
-	return buf;
-}
-
-static int lgdt3304_i2c_write_reg(struct dvb_frontend *fe, int reg, int val)
-{
-	struct lgdt3304_state *state = fe->demodulator_priv;
-	char buffer[3] = { reg>>8, reg&0xff, val };
-	int ret;
-
-	struct i2c_msg i2cmsgs = {
-		.addr = state->addr,
-		.flags = 0,
-		.len = 3,
-		.buf=buffer
-	};
-	ret = i2c_transfer(state->i2c, &i2cmsgs, 1);
-	if (ret != 1) {
-		printk("%s i2c_transfer error %d\n", __func__, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-
-static int lgdt3304_soft_Reset(struct dvb_frontend *fe)
-{
-	lgdt3304_i2c_write_reg(fe, 0x0002, 0x9a);
-	lgdt3304_i2c_write_reg(fe, 0x0002, 0x9b);
-	mdelay(200);
-	return 0;
-}
-
-static int lgdt3304_set_parameters(struct dvb_frontend *fe, struct dvb_frontend_parameters *param) {
-	int err = 0;
-
-	static __u8 lgdt3304_vsb8_data[] = {
-		/* 16bit  , 8bit */
-		/* regs   , val  */
-		0x00, 0x00, 0x02,
-		0x00, 0x00, 0x13,
-		0x00, 0x0d, 0x02,
-		0x00, 0x0e, 0x02,
-		0x00, 0x12, 0x32,
-		0x00, 0x13, 0xc4,
-		0x01, 0x12, 0x17,
-		0x01, 0x13, 0x15,
-		0x01, 0x14, 0x18,
-		0x01, 0x15, 0xff,
-		0x01, 0x16, 0x2c,
-		0x02, 0x14, 0x67,
-		0x02, 0x24, 0x8d,
-		0x04, 0x27, 0x12,
-		0x04, 0x28, 0x4f,
-		0x03, 0x08, 0x80,
-		0x03, 0x09, 0x00,
-		0x03, 0x0d, 0x00,
-		0x03, 0x0e, 0x1c,
-		0x03, 0x14, 0xe1,
-		0x05, 0x0e, 0x5b,
-	};
-
-	/* not yet tested .. */
-	static __u8 lgdt3304_qam64_data[] = {
-		/* 16bit  , 8bit */
-		/* regs   , val  */
-		0x00, 0x00, 0x18,
-		0x00, 0x0d, 0x02,
-		//0x00, 0x0e, 0x02,
-		0x00, 0x12, 0x2a,
-		0x00, 0x13, 0x00,
-		0x03, 0x14, 0xe3,
-		0x03, 0x0e, 0x1c,
-		0x03, 0x08, 0x66,
-		0x03, 0x09, 0x66,
-		0x03, 0x0a, 0x08,
-		0x03, 0x0b, 0x9b,
-		0x05, 0x0e, 0x5b,
-	};
-
-
-	/* tested with KWorld a340 */
-	static __u8 lgdt3304_qam256_data[] = {
-		/* 16bit  , 8bit */
-		/* regs   , val  */
-		0x00, 0x00, 0x01,  //0x19,
-		0x00, 0x12, 0x2a,
-		0x00, 0x13, 0x80,
-		0x00, 0x0d, 0x02,
-		0x03, 0x14, 0xe3,
-
-		0x03, 0x0e, 0x1c,
-		0x03, 0x08, 0x66,
-		0x03, 0x09, 0x66,
-		0x03, 0x0a, 0x08,
-		0x03, 0x0b, 0x9b,
-
-		0x03, 0x0d, 0x14,
-		//0x05, 0x0e, 0x5b,
-		0x01, 0x06, 0x4a,
-		0x01, 0x07, 0x3d,
-		0x01, 0x08, 0x70,
-		0x01, 0x09, 0xa3,
-
-		0x05, 0x04, 0xfd,
-
-		0x00, 0x0d, 0x82,
-
-		0x05, 0x0e, 0x5b,
-
-		0x05, 0x0e, 0x5b,
-
-		0x00, 0x02, 0x9a,
-
-		0x00, 0x02, 0x9b,
-
-		0x00, 0x00, 0x01,
-		0x00, 0x12, 0x2a,
-		0x00, 0x13, 0x80,
-		0x00, 0x0d, 0x02,
-		0x03, 0x14, 0xe3,
-
-		0x03, 0x0e, 0x1c,
-		0x03, 0x08, 0x66,
-		0x03, 0x09, 0x66,
-		0x03, 0x0a, 0x08,
-		0x03, 0x0b, 0x9b,
-
-		0x03, 0x0d, 0x14,
-		0x01, 0x06, 0x4a,
-		0x01, 0x07, 0x3d,
-		0x01, 0x08, 0x70,
-		0x01, 0x09, 0xa3,
-
-		0x05, 0x04, 0xfd,
-
-		0x00, 0x0d, 0x82,
-
-		0x05, 0x0e, 0x5b,
-	};
-
-	struct lgdt3304_state *state = fe->demodulator_priv;
-	if (state->current_modulation != param->u.vsb.modulation) {
-		switch(param->u.vsb.modulation) {
-		case VSB_8:
-			err = i2c_write_demod_bytes(fe, lgdt3304_vsb8_data,
-					sizeof(lgdt3304_vsb8_data));
-			break;
-		case QAM_64:
-			err = i2c_write_demod_bytes(fe, lgdt3304_qam64_data,
-					sizeof(lgdt3304_qam64_data));
-			break;
-		case QAM_256:
-			err = i2c_write_demod_bytes(fe, lgdt3304_qam256_data,
-					sizeof(lgdt3304_qam256_data));
-			break;
-		default:
-			break;
-		}
-
-		if (err) {
-			printk("%s error setting modulation\n", __func__);
-		} else {
-			state->current_modulation = param->u.vsb.modulation;
-		}
-	}
-	state->current_frequency = param->frequency;
-
-	lgdt3304_soft_Reset(fe);
-
-
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, param);
-
-	return 0;
-}
-
-static int lgdt3304_init(struct dvb_frontend *fe) {
-	return 0;
-}
-
-static int lgdt3304_sleep(struct dvb_frontend *fe) {
-	return 0;
-}
-
-
-static int lgdt3304_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct lgdt3304_state *state = fe->demodulator_priv;
-	int r011d;
-	int qam_lck;
-
-	*status = 0;
-	dprintk("lgdt read status\n");
-
-	r011d = lgdt3304_i2c_read_reg(fe, 0x011d);
-
-	dprintk("%02x\n", r011d);
-
-	switch(state->current_modulation) {
-	case VSB_8:
-		if (r011d & 0x80) {
-			dprintk("VSB Locked\n");
-			*status |= FE_HAS_CARRIER;
-			*status |= FE_HAS_LOCK;
-			*status |= FE_HAS_SYNC;
-			*status |= FE_HAS_SIGNAL;
-		}
-		break;
-	case QAM_64:
-	case QAM_256:
-		qam_lck = r011d & 0x7;
-		switch(qam_lck) {
-			case 0x0: dprintk("Unlock\n");
-				  break;
-			case 0x4: dprintk("1st Lock in acquisition state\n");
-				  break;
-			case 0x6: dprintk("2nd Lock in acquisition state\n");
-				  break;
-			case 0x7: dprintk("Final Lock in good reception state\n");
-				  *status |= FE_HAS_CARRIER;
-				  *status |= FE_HAS_LOCK;
-				  *status |= FE_HAS_SYNC;
-				  *status |= FE_HAS_SIGNAL;
-				  break;
-		}
-		break;
-	default:
-		printk("%s unhandled modulation\n", __func__);
-	}
-
-
-	return 0;
-}
-
-static int lgdt3304_read_ber(struct dvb_frontend *fe, __u32 *ber)
-{
-	dprintk("read ber\n");
-	return 0;
-}
-
-static int lgdt3304_read_snr(struct dvb_frontend *fe, __u16 *snr)
-{
-	dprintk("read snr\n");
-	return 0;
-}
-
-static int lgdt3304_read_ucblocks(struct dvb_frontend *fe, __u32 *ucblocks)
-{
-	dprintk("read ucblocks\n");
-	return 0;
-}
-
-static void lgdt3304_release(struct dvb_frontend *fe)
-{
-	struct lgdt3304_state *state = (struct lgdt3304_state *)fe->demodulator_priv;
-	kfree(state);
-}
-
-static struct dvb_frontend_ops demod_lgdt3304={
-	.info = {
-		.name = "LG 3304",
-		.type = FE_ATSC,
-		.frequency_min = 54000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 62500,
-		.symbol_rate_min = 5056941,
-		.symbol_rate_max = 10762000,
-		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
-	},
-	.init = lgdt3304_init,
-	.sleep = lgdt3304_sleep,
-	.set_frontend = lgdt3304_set_parameters,
-	.read_snr = lgdt3304_read_snr,
-	.read_ber = lgdt3304_read_ber,
-	.read_status = lgdt3304_read_status,
-	.read_ucblocks = lgdt3304_read_ucblocks,
-	.release = lgdt3304_release,
-};
-
-struct dvb_frontend* lgdt3304_attach(const struct lgdt3304_config *config,
-					   struct i2c_adapter *i2c)
-{
-
-	struct lgdt3304_state *state;
-	state = kzalloc(sizeof(struct lgdt3304_state), GFP_KERNEL);
-	if (state == NULL)
-		return NULL;
-	state->addr = config->i2c_address;
-	state->i2c = i2c;
-
-	memcpy(&state->frontend.ops, &demod_lgdt3304, sizeof(struct dvb_frontend_ops));
-	state->frontend.demodulator_priv = state;
-	return &state->frontend;
-}
-
-EXPORT_SYMBOL_GPL(lgdt3304_attach);
-MODULE_AUTHOR("Markus Rechberger <mrechberger@empiatech.com>");
-MODULE_DESCRIPTION("LGE LGDT3304 DVB-T demodulator driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/lgdt3304.h b/drivers/media/dvb/frontends/lgdt3304.h
deleted file mode 100644
index fc409fe..0000000
--- a/drivers/media/dvb/frontends/lgdt3304.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- *  Driver for DVB-T lgdt3304 demodulator
- *
- *  Copyright (C) 2008 Markus Rechberger <mrechberger@gmail.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
- */
-
-#ifndef LGDT3304_H
-#define LGDT3304_H
-
-#include <linux/dvb/frontend.h>
-
-struct lgdt3304_config
-{
-	/* demodulator's I2C address */
-	u8 i2c_address;
-};
-
-#if defined(CONFIG_DVB_LGDT3304) || (defined(CONFIG_DVB_LGDT3304_MODULE) && defined(MODULE))
-extern struct dvb_frontend* lgdt3304_attach(const struct lgdt3304_config *config,
-					   struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend* lgdt3304_attach(const struct lgdt3304_config *config,
-					   struct i2c_adapter *i2c)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif /* CONFIG_DVB_LGDT */
-
-#endif /* LGDT3304_H */
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

