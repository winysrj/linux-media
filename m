Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3GQPT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 11:19:57 -0400
Date: Thu, 18 Jul 2013 00:19:40 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx24117: Add new dvb-frontend driver (tested cards:
 TBS6980 and TBS6981 Dual tuner DVB-S/S2)
Message-ID: <20130718001940.77341fd7.mchehab@infradead.org>
In-Reply-To: <51E54C16.3090108@iki.fi>
References: <1373902089-11406-1-git-send-email-ljalvs@gmail.com>
	<51E54C16.3090108@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Jul 2013 16:35:18 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Hello Luis,
> 
> I reviewed it, comments between the code and end of mail. Please fix 
> those (at least partly you agree my findings) and resend.

I also have some comments. Please see below.

Regards,
Mauro

> 
> regards
> Antti
> 
> On 07/15/2013 06:28 PM, Luis Alves wrote:
> > Hi all,
> >
> > This patch adds support for the following CX24117 demod based cards:
> > TBS6980, TBS6981 (Dual tuner DVB-S/S2).
> > (tested with both cards)
> >
> > Regards,
> > Luis
> >
> > Signed-off-by: Luis Alves <ljalvs@gmail.com>
> > ---
> >   drivers/media/dvb-frontends/Kconfig       |    7 +
> >   drivers/media/dvb-frontends/Makefile      |    1 +
> >   drivers/media/dvb-frontends/cx24117.c     | 1666 +++++++++++++++++++++++++++++
> >   drivers/media/dvb-frontends/cx24117.h     |   47 +
> >   drivers/media/pci/cx23885/Kconfig         |    1 +
> >   drivers/media/pci/cx23885/cx23885-cards.c |   65 ++
> >   drivers/media/pci/cx23885/cx23885-dvb.c   |   31 +
> >   drivers/media/pci/cx23885/cx23885-input.c |   12 +
> >   drivers/media/pci/cx23885/cx23885.h       |    2 +
> >   9 files changed, 1832 insertions(+)
> >   create mode 100644 drivers/media/dvb-frontends/cx24117.c
> >   create mode 100644 drivers/media/dvb-frontends/cx24117.h

Luis,

Please split the new driver from the cx23885 changes on a next version.


> >
> > diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> > index 0e2ec6f..bddbab4 100644
> > --- a/drivers/media/dvb-frontends/Kconfig
> > +++ b/drivers/media/dvb-frontends/Kconfig
> > @@ -200,6 +200,13 @@ config DVB_CX24116
> >   	help
> >   	  A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
> >
> > +config DVB_CX24117
> > +	tristate "Conexant CX24117 based"
> > +	depends on DVB_CORE && I2C
> > +	default m if !MEDIA_SUBDRV_AUTOSELECT
> > +	help
> > +	  A Dual DVB-S/S2 tuner module. Say Y when you want to support this frontend.
> > +
> >   config DVB_SI21XX
> >   	tristate "Silicon Labs SI21XX based"
> >   	depends on DVB_CORE && I2C
> > diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> > index cebc0fa..f9cb43d 100644
> > --- a/drivers/media/dvb-frontends/Makefile
> > +++ b/drivers/media/dvb-frontends/Makefile
> > @@ -76,6 +76,7 @@ obj-$(CONFIG_DVB_ATBM8830) += atbm8830.o
> >   obj-$(CONFIG_DVB_DUMMY_FE) += dvb_dummy_fe.o
> >   obj-$(CONFIG_DVB_AF9013) += af9013.o
> >   obj-$(CONFIG_DVB_CX24116) += cx24116.o
> > +obj-$(CONFIG_DVB_CX24117) += cx24117.o
> >   obj-$(CONFIG_DVB_SI21XX) += si21xx.o
> >   obj-$(CONFIG_DVB_STV0288) += stv0288.o
> >   obj-$(CONFIG_DVB_STB6000) += stb6000.o
> > diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
> > new file mode 100644
> > index 0000000..691ab5c
> > --- /dev/null
> > +++ b/drivers/media/dvb-frontends/cx24117.c
> > @@ -0,0 +1,1666 @@
> > +/*
> > +    Conexant cx24117/cx24132 - Dual DVBS/S2 Satellite demod/tuner driver
> > +
> > +    Copyright (C) 2013 Luis Alves <ljalvs@gmail.com>
> > +	July, 6th 2013
> > +	    First release based on cx24116 driver by:
> > +	    Steven Toth and Georg Acher, Darron Broad, Igor Liplianin
> > +            Cards currently supported:
> > +		TBS6980 - Dual DVBS/S2 PCIe card
> > +		TBS6981 - Dual DVBS/S2 PCIe card
> > +
> > +    This program is free software; you can redistribute it and/or modify
> > +    it under the terms of the GNU General Public License as published by
> > +    the Free Software Foundation; either version 2 of the License, or
> > +    (at your option) any later version.
> > +
> > +    This program is distributed in the hope that it will be useful,
> > +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +    GNU General Public License for more details.
> > +
> > +    You should have received a copy of the GNU General Public License
> > +    along with this program; if not, write to the Free Software
> > +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > +*/
> > +
> > +#include <linux/slab.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/init.h>
> > +#include <linux/firmware.h>
> > +
> > +#include "dvb_frontend.h"
> > +#include "cx24117.h"
> > +
> > +/* SNR measurements */
> > +static int esno_snr;
> > +module_param(esno_snr, int, 0644);
> > +MODULE_PARM_DESC(esno_snr, "SNR return units, 0=ESNO(db * 10), "\
> > +	"1=PERCENTAGE 0-100 (default:0)");
> 
> Maybe this parameter could be dropped. We has new API for signal 
> statistics which prefers dB scale (that driver is not using that API 
> yet, but could be converted later). I don't see need for percentage at 
> all - instead someone could be blaming later that module parameter has 
> removed (when driver is converted to new statistics API).

I'd say that the better is to implement it already using the new
statistics API. There's no sense on adding new drivers to the
Kernel using the obsolete API.

> > +
> > +
> > +#define CX24117_DEFAULT_FIRMWARE "dvb-fe-cx24117.fw"
> > +#define CX24117_SEARCH_RANGE_KHZ 5000
> > +
> > +/* known registers */
> > +#define CX24117_REG_COMMAND      (0x00)      /* command buffer */
> > +#define CX24117_REG_EXECUTE      (0x1f)      /* execute command */
> > +
> > +#define CX24117_REG_FREQ3_0      (0x34)      /* frequency */
> > +#define CX24117_REG_FREQ2_0      (0x35)
> > +#define CX24117_REG_FREQ1_0      (0x36)
> > +#define CX24117_REG_STATE0       (0x39)
> > +#define CX24117_REG_SSTATUS0     (0x3a)      /* demod0 signal high / status */
> > +#define CX24117_REG_SIGNAL0      (0x3b)
> > +#define CX24117_REG_FREQ5_0      (0x3c)      /* +-freq */
> > +#define CX24117_REG_FREQ6_0      (0x3d)
> > +#define CX24117_REG_SRATE2_0     (0x3e)      /* +- 1000 * srate */
> > +#define CX24117_REG_SRATE1_0     (0x3f)
> > +#define CX24117_REG_QUALITY2_0   (0x40)
> > +#define CX24117_REG_QUALITY1_0   (0x41)
> > +
> > +#define CX24117_REG_BER4_0       (0x47)
> > +#define CX24117_REG_BER3_0       (0x48)
> > +#define CX24117_REG_BER2_0       (0x49)
> > +#define CX24117_REG_BER1_0       (0x4a)
> > +#define CX24117_REG_DVBS_UCB2_0  (0x4b)
> > +#define CX24117_REG_DVBS_UCB1_0  (0x4c)
> > +#define CX24117_REG_DVBS2_UCB2_0 (0x50)
> > +#define CX24117_REG_DVBS2_UCB1_0 (0x51)
> > +#define CX24117_REG_QSTATUS0     (0x93)
> > +#define CX24117_REG_CLKDIV0      (0xe6)
> > +#define CX24117_REG_RATEDIV0     (0xf0)
> > +
> > +
> > +#define CX24117_REG_FREQ3_1      (0x55)      /* frequency */
> > +#define CX24117_REG_FREQ2_1      (0x56)
> > +#define CX24117_REG_FREQ1_1      (0x57)
> > +#define CX24117_REG_STATE1       (0x5a)
> > +#define CX24117_REG_SSTATUS1     (0x5b)      /* demod1 signal high / status */
> > +#define CX24117_REG_SIGNAL1      (0x5c)
> > +#define CX24117_REG_FREQ5_1      (0x5d)      /* +- freq */
> > +#define CX24117_REG_FREQ4_1      (0x5e)
> > +#define CX24117_REG_SRATE2_1     (0x5f)
> > +#define CX24117_REG_SRATE1_1     (0x60)
> > +#define CX24117_REG_QUALITY2_1   (0x61)
> > +#define CX24117_REG_QUALITY1_1   (0x62)
> > +#define CX24117_REG_BER4_1       (0x68)
> > +#define CX24117_REG_BER3_1       (0x69)
> > +#define CX24117_REG_BER2_1       (0x6a)
> > +#define CX24117_REG_BER1_1       (0x6b)
> > +#define CX24117_REG_DVBS_UCB2_1  (0x6c)
> > +#define CX24117_REG_DVBS_UCB1_1  (0x6d)
> > +#define CX24117_REG_DVBS2_UCB2_1 (0x71)
> > +#define CX24117_REG_DVBS2_UCB1_1 (0x72)
> > +#define CX24117_REG_QSTATUS1     (0x9f)
> > +#define CX24117_REG_CLKDIV1      (0xe7)
> > +#define CX24117_REG_RATEDIV1     (0xf1)
> > +
> > +
> > +/* arg buffer size */
> > +#define CX24117_ARGLEN       (0x1e)
> > +
> > +/* rolloff */
> > +#define CX24117_ROLLOFF_020  (0x00)
> > +#define CX24117_ROLLOFF_025  (0x01)
> > +#define CX24117_ROLLOFF_035  (0x02)
> > +
> > +/* pilot bit */
> > +#define CX24117_PILOT_OFF    (0x00)
> > +#define CX24117_PILOT_ON     (0x40)
> > +#define CX24117_PILOT_AUTO   (0x80)
> > +
> > +/* signal status */
> > +#define CX24117_HAS_SIGNAL   (0x01)
> > +#define CX24117_HAS_CARRIER  (0x02)
> > +#define CX24117_HAS_VITERBI  (0x04)
> > +#define CX24117_HAS_SYNCLOCK (0x08)
> > +#define CX24117_HAS_UNKNOWN1 (0x10)
> > +#define CX24117_HAS_UNKNOWN2 (0x20)
> > +#define CX24117_STATUS_MASK  (0x0f)
> > +#define CX24117_SIGNAL_MASK  (0xc0)
> > +
> > +
> > +/* arg offset for DiSEqC */
> > +#define CX24117_DISEQC_DEMOD  (1)
> > +#define CX24117_DISEQC_BURST  (2)
> > +#define CX24117_DISEQC_ARG3_2 (3)   /* unknown value=2 */
> > +#define CX24117_DISEQC_ARG4_0 (4)   /* unknown value=0 */
> > +#define CX24117_DISEQC_ARG5_0 (5)   /* unknown value=0 */
> > +#define CX24117_DISEQC_MSGLEN (6)
> > +#define CX24117_DISEQC_MSGOFS (7)
> > +
> > +/* DiSEqC burst */
> > +#define CX24117_DISEQC_MINI_A (0)
> > +#define CX24117_DISEQC_MINI_B (1)
> > +
> > +
> > +#define CX24117_PNE	(0) /* 0 disabled / 2 enabled */
> > +#define CX24117_OCC	(1) /* 0 disabled / 1 enabled */
> > +
> > +
> > +enum cmds {
> > +	CMD_SET_VCO     = 0x10,
> > +	CMD_TUNEREQUEST = 0x11,
> > +	CMD_MPEGCONFIG  = 0x13,
> > +	CMD_TUNERINIT   = 0x14,
> > +//	CMD_BANDWIDTH   = 0x15,
> > +//	CMD_GETAGC      = 0x19,
> > +//	CMD_LNBCONFIG   = 0x20,

Please don't use C99 comments. Either use /* */ or enclose
those things at a #if 0...#endif block (or just remove, if
there's no intention to implement/use it in the future).

> > +	CMD_LNBSEND     = 0x21, /* Formerly CMD_SEND_DISEQC */
> > +	CMD_LNBDCLEVEL  = 0x22,
> > +	CMD_SET_TONE    = 0x23,
> > +	CMD_UPDFWVERS   = 0x35,
> > +	CMD_TUNERSLEEP  = 0x36,
> > +//	CMD_AGCCONTROL  = 0x3b, /* Unknown */
> > +};
> 
> Remove unneeded & unknown stuff that is already commented out.
> 
> > +
> > +/* The Demod/Tuner can't easily provide these, we cache them */
> > +struct cx24117_tuning {
> > +	u32 frequency;
> > +	u32 symbol_rate;
> > +	fe_spectral_inversion_t inversion;
> > +	fe_code_rate_t fec;
> > +
> > +	fe_delivery_system_t delsys;
> > +	fe_modulation_t modulation;
> > +	fe_pilot_t pilot;
> > +	fe_rolloff_t rolloff;
> > +
> > +	/* Demod values */
> > +	u8 fec_val;
> > +	u8 fec_mask;
> > +	u8 inversion_val;
> > +	u8 pilot_val;
> > +	u8 rolloff_val;
> > +};
> > +
> > +/* Basic commands that are sent to the firmware */
> > +struct cx24117_cmd {
> > +	u8 len;
> > +	u8 args[CX24117_ARGLEN];
> > +};
> > +
> > +/* common to both fe's */
> > +struct cx24117_priv {
> > +	u8 demod_address;
> > +	struct i2c_adapter *i2c;
> > +	u8 skip_fw_load;
> > +
> > +	struct mutex fe_lock;
> > +	atomic_t fe_nr;
> > +};
> > +
> > +/* one per each fe */
> > +struct cx24117_state {
> > +	struct cx24117_priv *priv;
> > +	struct dvb_frontend frontend;
> > +
> > +	struct cx24117_tuning dcur;
> > +	struct cx24117_tuning dnxt;
> > +	struct cx24117_cmd dsec_cmd;
> > +
> > +	int demod;
> > +};
> > +
> > +/* modfec (modulation and FEC) lookup table */
> > +/* Check cx24116.c for a detailed description of each field */
> > +static struct cx24117_modfec {
> > +	fe_delivery_system_t delivery_system;
> > +	fe_modulation_t modulation;
> > +	fe_code_rate_t fec;
> > +	u8 mask;	/* In DVBS mode this is used to autodetect */
> > +	u8 val;		/* Passed to the firmware to indicate mode selection */
> > +} CX24117_MODFEC_MODES[] = {

Don't use upper case. We only user uppercase on #define constants.

> > + /* QPSK. For unknown rates we set hardware to auto detect 0xfe 0x30 */
> > +
> > + /*mod   fec       mask  val */
> > + { SYS_DVBS, QPSK, FEC_NONE, 0xfe, 0x30 },
> > + { SYS_DVBS, QPSK, FEC_1_2,  0x02, 0x2e }, /* 00000010 00101110 */
> > + { SYS_DVBS, QPSK, FEC_2_3,  0x04, 0x2f }, /* 00000100 00101111 */
> > + { SYS_DVBS, QPSK, FEC_3_4,  0x08, 0x30 }, /* 00001000 00110000 */
> > + { SYS_DVBS, QPSK, FEC_4_5,  0xfe, 0x30 }, /* 000?0000 ?        */
> > + { SYS_DVBS, QPSK, FEC_5_6,  0x20, 0x31 }, /* 00100000 00110001 */
> > + { SYS_DVBS, QPSK, FEC_6_7,  0xfe, 0x30 }, /* 0?000000 ?        */
> > + { SYS_DVBS, QPSK, FEC_7_8,  0x80, 0x32 }, /* 10000000 00110010 */
> > + { SYS_DVBS, QPSK, FEC_8_9,  0xfe, 0x30 }, /* 0000000? ?        */
> > + { SYS_DVBS, QPSK, FEC_AUTO, 0xfe, 0x30 },
> > + /* NBC-QPSK */
> > + { SYS_DVBS2, QPSK, FEC_NONE, 0x00, 0x00 },
> > + { SYS_DVBS2, QPSK, FEC_1_2,  0x00, 0x04 },
> > + { SYS_DVBS2, QPSK, FEC_3_5,  0x00, 0x05 },
> > + { SYS_DVBS2, QPSK, FEC_2_3,  0x00, 0x06 },
> > + { SYS_DVBS2, QPSK, FEC_3_4,  0x00, 0x07 },
> > + { SYS_DVBS2, QPSK, FEC_4_5,  0x00, 0x08 },
> > + { SYS_DVBS2, QPSK, FEC_5_6,  0x00, 0x09 },
> > + { SYS_DVBS2, QPSK, FEC_8_9,  0x00, 0x0a },
> > + { SYS_DVBS2, QPSK, FEC_9_10, 0x00, 0x0b },
> > + { SYS_DVBS2, QPSK, FEC_AUTO, 0x00, 0x00 },
> > + /* 8PSK */
> > + { SYS_DVBS2, PSK_8, FEC_NONE, 0x00, 0x00 },
> > + { SYS_DVBS2, PSK_8, FEC_3_5,  0x00, 0x0c },
> > + { SYS_DVBS2, PSK_8, FEC_2_3,  0x00, 0x0d },
> > + { SYS_DVBS2, PSK_8, FEC_3_4,  0x00, 0x0e },
> > + { SYS_DVBS2, PSK_8, FEC_5_6,  0x00, 0x0f },
> > + { SYS_DVBS2, PSK_8, FEC_8_9,  0x00, 0x10 },
> > + { SYS_DVBS2, PSK_8, FEC_9_10, 0x00, 0x11 },
> > + { SYS_DVBS2, PSK_8, FEC_AUTO, 0x00, 0x00 },
> > + /*
> > +  * 'val' can be found in the FECSTATUS register when tuning.
> > +  * FECSTATUS will give the actual FEC in use if tuning was successful.
> > +  */
> > +};
> > +
> > +
> > +static int cx24117_writereg(struct cx24117_state *state, u8 reg, u8 data)
> > +{
> > +	u8 buf[] = { reg, data };
> > +	struct i2c_msg msg = { .addr = state->priv->demod_address,
> > +		.flags = 0, .buf = buf, .len = 2 };
> > +	int err;
> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +			"%s() demod%d i2c wr @0x%02x=0x%02x\n",
> > +			__func__, state->demod, reg, data);
> > +
> > +	err = i2c_transfer(state->priv->i2c, &msg, 1);
> > +	if (err != 1) {
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod%d i2c wr err(%i) @0x%02x=0x%02x\n",
> > +			KBUILD_MODNAME, state->demod, err, reg, data);
> > +		return -EREMOTEIO;

Hmm.. if err is less then 0, just return the error.

Also, I think we use a different code for errors at I2C transfers
(-EIO, I think).


> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_writecmd(struct cx24117_state *state,
> > +	struct cx24117_cmd *cmd)
> > +{
> > +	struct i2c_msg msg;
> > +	u8 buf[CX24117_ARGLEN+1];
> > +	int ret = 0;
> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +			"%s() demod%d i2c wr cmd len=%d\n",
> > +			__func__, state->demod, cmd->len);
> > +
> > +	buf[0] = CX24117_REG_COMMAND;
> > +	memcpy(&buf[1], cmd->args, cmd->len);
> > +
> > +	msg.addr = state->priv->demod_address;
> > +	msg.flags = 0;
> > +	msg.len = cmd->len+1;
> > +	msg.buf = buf;
> > +	ret = i2c_transfer(state->priv->i2c, &msg, 1);
> > +	if (ret != 1) {
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod%d i2c wr cmd err(%i) len=%d\n",
> > +			KBUILD_MODNAME, state->demod, ret, cmd->len);
> > +		return -EREMOTEIO;

Same here.

> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_readreg(struct cx24117_state *state, u8 reg)
> > +{
> > +	int ret;
> > +	u8 recv = 0;
> > +	struct i2c_msg msg[] = {
> > +		{ .addr = state->priv->demod_address, .flags = 0,
> > +			.buf = &reg, .len = 1 },
> > +		{ .addr = state->priv->demod_address, .flags = I2C_M_RD,
> > +			.buf = &recv, .len = 1 }
> > +	};
> > +
> > +	ret = i2c_transfer(state->priv->i2c, msg, 2);
> > +
> > +	if (ret != 2) {
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod%d i2c rd err(%d) @0x%x\n",
> > +			KBUILD_MODNAME, state->demod, ret, reg);
> > +		return -EREMOTEIO;

Same here.

> > +	}
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d i2c rd @0x%02x=0x%02x\n",
> > +		__func__, state->demod, reg, recv);
> > +
> > +	return recv;
> > +}
> > +
> > +static int cx24117_readregN(struct cx24117_state *state,
> > +	u8 reg, u8 *buf, int len)
> > +{
> > +	int ret;
> > +	struct i2c_msg msg[] = {
> > +		{ .addr = state->priv->demod_address, .flags = 0,
> > +			.buf = &reg, .len = 1 },
> > +		{ .addr = state->priv->demod_address, .flags = I2C_M_RD,
> > +			.buf = buf, .len = len }
> > +	};
> > +
> > +	ret = i2c_transfer(state->priv->i2c, msg, 2);
> > +
> > +	if (ret != 2) {
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod%d i2c rd err(%d) @0x%x\n",
> > +			KBUILD_MODNAME, state->demod, ret, reg);
> > +		return -EREMOTEIO;

Same here.

> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_set_inversion(struct cx24117_state *state,
> > +	fe_spectral_inversion_t inversion)
> > +{
> > +	dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
> > +		__func__, inversion, state->demod);
> > +
> > +	switch (inversion) {
> > +	case INVERSION_OFF:
> > +		state->dnxt.inversion_val = 0x00;
> > +		break;
> > +	case INVERSION_ON:
> > +		state->dnxt.inversion_val = 0x04;
> > +		break;
> > +	case INVERSION_AUTO:
> > +		state->dnxt.inversion_val = 0x0C;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	state->dnxt.inversion = inversion;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_lookup_fecmod(struct cx24117_state *state,
> > +	fe_delivery_system_t d, fe_modulation_t m, fe_code_rate_t f)
> > +{
> > +	int i, ret = -EOPNOTSUPP;

-EINVAL seems more appropriate.

> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s(demod(0x%02x,0x%02x) demod%d\n",
> > +		__func__, m, f, state->demod);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(CX24117_MODFEC_MODES); i++) {
> > +		if ((d == CX24117_MODFEC_MODES[i].delivery_system) &&
> > +			(m == CX24117_MODFEC_MODES[i].modulation) &&
> > +			(f == CX24117_MODFEC_MODES[i].fec)) {
> > +				ret = i;
> > +				break;
> > +			}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int cx24117_set_fec(struct cx24117_state *state,
> > +	fe_delivery_system_t delsys, fe_modulation_t mod, fe_code_rate_t fec)
> > +{
> > +	int ret;
> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s(0x%02x,0x%02x) demod%d\n",
> > +		__func__, mod, fec, state->demod);
> > +
> > +	ret = cx24117_lookup_fecmod(state, delsys, mod, fec);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	state->dnxt.fec = fec;
> > +	state->dnxt.fec_val = CX24117_MODFEC_MODES[ret].val;
> > +	state->dnxt.fec_mask = CX24117_MODFEC_MODES[ret].mask;
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s() demod%d mask/val = 0x%02x/0x%02x\n", __func__,
> > +		state->demod, state->dnxt.fec_mask, state->dnxt.fec_val);
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_set_symbolrate(struct cx24117_state *state, u32 rate)
> > +{
> > +	dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
> > +		__func__, rate, state->demod);
> > +
> > +	/*  check if symbol rate is within limits */
> > +	if ((rate > state->frontend.ops.info.symbol_rate_max) ||
> > +	    (rate < state->frontend.ops.info.symbol_rate_min)) {
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod%d unsupported symbol_rate = %d\n",
> > +			KBUILD_MODNAME, state->demod, rate);
> > +		return -EOPNOTSUPP;
> > +	}
> 
> IIRC limits are already checked by dvb-frontend.

Yes, and the proper return value for an invalid value should be -EINVAL.

> 
> > +
> > +	state->dnxt.symbol_rate = rate;
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s() demod%d symbol_rate = %d\n",
> > +		__func__, state->demod, rate);
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_load_firmware(struct dvb_frontend *fe,
> > +	const struct firmware *fw);
> > +
> > +static int cx24117_firmware_ondemand(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	const struct firmware *fw;
> > +	int ret = 0;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d skip_fw_load=%d\n",
> > +		__func__, state->demod, state->priv->skip_fw_load);
> > +
> > +	/* check if firmware if already running */
> > +	if (cx24117_readreg(state, 0xeb) != 0xa) {
> > +		if (state->priv->skip_fw_load)
> > +			return 0;
> 
> How about checking skip_fw_load at the very first? Register reading is 
> not needed at all in case of skip_fw_load is set.
> 
> > +
> > +		/* Load firmware */
> > +		/* request the firmware, this will block until loaded */
> > +		printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n",
> > +			__func__, CX24117_DEFAULT_FIRMWARE);
> > +		ret = request_firmware(&fw, CX24117_DEFAULT_FIRMWARE,
> > +			state->priv->i2c->dev.parent);
> > +		printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n",
> > +			__func__);

Why to do the two above printk? Ok, they could be interesting for debug, but
a normal driver should not pollute the logs with those messages.
Also, the printks below will print a message anyway if an error happened or
if the firmware got loaded properly.

> > +		if (ret) {
> > +			printk(KERN_ERR "%s: No firmware uploaded "
> > +				"(timeout or file not found?)\n", __func__);
> > +			return ret;
> > +		}
> > +
> > +		/* Make sure we don't recurse back through here
> > +		 * during loading */
> > +		state->priv->skip_fw_load = 1;
> > +
> > +		ret = cx24117_load_firmware(fe, fw);
> > +		if (ret)
> > +			printk(KERN_ERR "%s: Writing firmware failed\n",
> > +				__func__);
> > +
> > +		release_firmware(fw);
> > +
> > +		printk(KERN_INFO "%s: Firmware upload %s\n", __func__,
> > +			ret == 0 ? "complete" : "failed");
> > +
> > +		/* Ensure firmware is always loaded if required */
> > +		state->priv->skip_fw_load = 0;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/* Take a basic firmware command structure, format it
> > + * and forward it for processing
> > + */
> > +static int cx24117_cmd_execute_nolock(struct dvb_frontend *fe,
> > +	struct cx24117_cmd *cmd)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int i, ret;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
> > +		__func__, state->demod);
> > +
> > +	/* Load the firmware if required */
> > +	ret = cx24117_firmware_ondemand(fe);
> > +	if (ret != 0) {
> > +		printk(KERN_ERR "%s(): Unable initialise the firmware\n",
> > +			__func__);

No need for the above printk, as the driver is already printing an
error message if firmware load fail.

> > +		return ret;
> > +	}
> > +
> > +	/* Write the command */
> > +	cx24117_writecmd(state, cmd);
> > +
> > +	/* Start execution and wait for cmd to terminate */
> > +	cx24117_writereg(state, CX24117_REG_EXECUTE, 0x01);
> > +	i = 0;
> > +	while (cx24117_readreg(state, CX24117_REG_EXECUTE)) {
> > +		msleep(10);
> > +		if (i++ > 64) {
> > +			/* Avoid looping forever if the firmware does
> > +				not respond */
> > +			printk(KERN_WARNING "%s() Firmware not responding\n",
> > +				__func__);
> > +			return -EREMOTEIO;

-EIO.

> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int cx24117_cmd_execute(struct dvb_frontend *fe, struct cx24117_cmd *cmd)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int ret;
> > +	
> > +	mutex_lock(&state->priv->fe_lock);
> > +	ret = cx24117_cmd_execute_nolock(fe, cmd);
> > +	mutex_unlock(&state->priv->fe_lock);
> > +	
> > +	return ret;
> > +}
> 
> Is there some special requirement you dont lock firmware command 
> execution everytime? You want to use same lock for protect FE0 and FE1 
> perform FE init() same time?
> 
> > +
> > +static int cx24117_load_firmware(struct dvb_frontend *fe,
> > +	const struct firmware *fw)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +	int i, ret;
> > +	unsigned char vers[4];
> > +
> > +	struct i2c_msg msg;
> > +	u8 *buf;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d " \
> > +		"Firmware is %zu bytes (%02x %02x .. %02x %02x)\n",
> > +		__func__, state->demod, fw->size,
> > +		fw->data[0], fw->data[1],
> > +		fw->data[fw->size-2], fw->data[fw->size-1]);
> > +
> > +	cx24117_writereg(state, 0xea, 0x00);
> > +	cx24117_writereg(state, 0xea, 0x01);
> > +	cx24117_writereg(state, 0xea, 0x00);
> > +
> > +	cx24117_writereg(state, 0xce, 0x92);
> > +
> > +	cx24117_writereg(state, 0xfb, 0x00);
> > +	cx24117_writereg(state, 0xfc, 0x00);
> > +
> > +	cx24117_writereg(state, 0xc3, 0x04);
> > +	cx24117_writereg(state, 0xc4, 0x04);
> > +
> > +	cx24117_writereg(state, 0xce, 0x00);
> > +	cx24117_writereg(state, 0xcf, 0x00);
> > +
> > +	cx24117_writereg(state, 0xea, 0x00);
> > +	cx24117_writereg(state, 0xeb, 0x0c);
> > +	cx24117_writereg(state, 0xec, 0x06);
> > +	cx24117_writereg(state, 0xed, 0x05);
> > +	cx24117_writereg(state, 0xee, 0x03);
> > +	cx24117_writereg(state, 0xef, 0x05);
> > +
> > +	cx24117_writereg(state, 0xf3, 0x03);
> > +	cx24117_writereg(state, 0xf4, 0x44);
> > +	
> > +	cx24117_writereg(state, CX24117_REG_RATEDIV0, 0x04);
> > +	cx24117_writereg(state, CX24117_REG_CLKDIV0, 0x02);
> > +
> > +	cx24117_writereg(state, CX24117_REG_RATEDIV1, 0x04);
> > +	cx24117_writereg(state, CX24117_REG_CLKDIV1, 0x02);
> > +
> > +	cx24117_writereg(state, 0xf2, 0x04);
> > +	cx24117_writereg(state, 0xe8, 0x02);
> > +	cx24117_writereg(state, 0xea, 0x01);
> > +	cx24117_writereg(state, 0xc8, 0x00);
> > +	cx24117_writereg(state, 0xc9, 0x00);
> > +	cx24117_writereg(state, 0xca, 0x00);
> > +	cx24117_writereg(state, 0xcb, 0x00);
> > +	cx24117_writereg(state, 0xcc, 0x00);
> > +	cx24117_writereg(state, 0xcd, 0x00);
> > +	cx24117_writereg(state, 0xe4, 0x03);
> > +	cx24117_writereg(state, 0xeb, 0x0a);
> > +
> > +	cx24117_writereg(state, 0xfb, 0x00);
> > +	cx24117_writereg(state, 0xe0, 0x76);
> > +	cx24117_writereg(state, 0xf7, 0x81);
> > +	cx24117_writereg(state, 0xf8, 0x00);
> > +	cx24117_writereg(state, 0xf9, 0x00);
> > +
> > +	buf = kmalloc(fw->size+1, GFP_KERNEL);

Coding style, please add spaces, like:
		fw->size + 1

> > +	if (buf == NULL) {
> > +		state->priv->skip_fw_load = 0;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* fw upload reg */
> > +	buf[0] = 0xfa;
> > +	memcpy(&buf[1], fw->data, fw->size);
> > +
> > +	/* prepare i2c message to send */
> > +	msg.addr = (u16) state->priv->demod_address;
> 
> unneeded casting
> 
> > +	msg.flags = 0;
> > +	msg.len = fw->size+1;

Same here. Did you check it with checkpatch.pl?

> > +	msg.buf = buf;
> > +
> > +	/* send fw */
> > +	i2c_transfer(state->priv->i2c, &msg, 1);

Please do error check.

> > +
> > +	kfree(buf);
> > +
> > +	cx24117_writereg(state, 0xf7, 0x0c);
> > +	cx24117_writereg(state, 0xe0, 0x00);
> > +
> > +	/* CMD 1B */
> > +	cmd.args[0] = 0x1b;
> > +	cmd.args[1] = 0x00;
> > +	cmd.args[2] = 0x01;
> > +	cmd.args[3] = 0x00;
> > +	cmd.len = 4;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0) {
> > +		state->priv->skip_fw_load = 0;
> > +		printk("%s() Error running FW.\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* CMD 10 */
> > +	cmd.args[0] = CMD_SET_VCO;
> > +	cmd.args[1] = 0x06;
> > +	cmd.args[2] = 0x2b;
> > +	cmd.args[3] = 0xd8;
> > +	cmd.args[4] = 0xa5;
> > +	cmd.args[5] = 0xee;
> > +	cmd.args[6] = 0x03;
> > +	cmd.args[7] = 0x9d;
> > +	cmd.args[8] = 0xfc;
> > +	cmd.args[9] = 0x06;
> > +	cmd.args[10] = 0x02;
> > +	cmd.args[11] = 0x9d;
> > +	cmd.args[12] = 0xfc;
> > +	cmd.len = 13;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0) {
> > +		state->priv->skip_fw_load = 0;
> > +		printk("%s() Error2 running FW.\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* CMD 15 */
> > +	cmd.args[0] = 0x15;
> > +	cmd.args[1] = 0x00;
> > +	cmd.args[2] = 0x01;
> > +	cmd.args[3] = 0x00;
> > +	cmd.args[4] = 0x00;
> > +	cmd.args[5] = 0x01;
> > +	cmd.args[6] = 0x01;
> > +	cmd.args[7] = 0x01;
> > +	cmd.args[8] = 0x00;
> > +	cmd.args[9] = 0x05;
> > +	cmd.args[10] = 0x02;
> > +	cmd.args[11] = 0x02;
> > +	cmd.args[12] = 0x00;
> > +	cmd.len = 13;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0) {
> > +		state->priv->skip_fw_load = 0;
> > +		printk("%s() Error3 running FW.\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* CMD 13 */
> > +	cmd.args[0] = CMD_MPEGCONFIG;
> > +	cmd.args[1] = 0x00;
> > +	cmd.args[2] = 0x00;
> > +	cmd.args[3] = 0x00;
> > +	cmd.args[4] = 0x01;
> > +	cmd.args[5] = 0x00;
> > +	cmd.len = 6;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0) {
> > +		state->priv->skip_fw_load = 0;
> > +		printk("%s() Error4 running FW.\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* CMD 14 */
> > +	for (i = 0; i < 2; i++) {
> > +		cmd.args[0] = CMD_TUNERINIT;
> > +		cmd.args[1] = (u8) i;
> > +		cmd.args[2] = 0x00;
> > +		cmd.args[3] = 0x05;
> > +		cmd.args[4] = 0x00;
> > +		cmd.args[5] = 0x00;
> > +		cmd.args[6] = 0x55;
> > +		cmd.args[7] = 0x00;
> > +		cmd.len = 8;
> > +		ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +		if (ret != 0) {
> > +			state->priv->skip_fw_load = 0;
> > +			printk("%s() Error5 running FW.\n", __func__);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	cx24117_writereg(state, 0xce, 0xc0);
> > +	cx24117_writereg(state, 0xcf, 0x00);
> > +	cx24117_writereg(state, 0xe5, 0x04);
> > +
> > +
> > +	/* Firmware CMD 35: Get firmware version */
> > +	cmd.args[0] = CMD_UPDFWVERS;
> > +	cmd.len = 2;
> > +	for (i = 0; i < 4; i++) {
> > +		cmd.args[1] = i;
> > +		ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +		if (ret != 0) {
> > +			state->priv->skip_fw_load = 0;
> > +			printk("%s() Error7 running FW.\n", __func__);
> > +			return ret;
> > +		}
> > +		vers[i] = cx24117_readreg(state, 0x33);
> > +	}
> > +	printk(KERN_INFO "%s: FW version %i.%i.%i.%i\n", __func__,
> > +		vers[0], vers[1], vers[2], vers[3]);
> > +	return 0;
> > +}
> > +
> > +static int cx24117_read_status(struct dvb_frontend *fe, fe_status_t *status)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int lock;
> > +
> > +	lock = cx24117_readreg(state,
> > +		(state->demod == 0) ? CX24117_REG_SSTATUS0 :
> > +				      CX24117_REG_SSTATUS1 ) &
> > +		CX24117_STATUS_MASK;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d status = 0x%02x\n",
> > +		__func__, state->demod, lock);
> > +
> > +	*status = 0;
> > +
> > +	if (lock & CX24117_HAS_SIGNAL)
> > +		*status |= FE_HAS_SIGNAL;
> > +	if (lock & CX24117_HAS_CARRIER)
> > +		*status |= FE_HAS_CARRIER;
> > +	if (lock & CX24117_HAS_VITERBI)
> > +		*status |= FE_HAS_VITERBI;
> > +	if (lock & CX24117_HAS_SYNCLOCK)
> > +		*status |= FE_HAS_SYNC | FE_HAS_LOCK;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_read_ber(struct dvb_frontend *fe, u32 *ber)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int ret;
> > +	u8 buf[4];
> > +	u8 base_reg = (state->demod == 0) ?
> > +			CX24117_REG_BER4_0 :
> > +			CX24117_REG_BER4_1;
> > +
> > +	ret = cx24117_readregN(state, base_reg, buf, 4);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	*ber = (buf[0] << 24) | (buf[1] << 16) |
> > +		(buf[1] << 8) | buf[0];
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d ber=0x%04x\n",
> > +		__func__, state->demod, *ber);
> > +
> > +	return 0;
> > +}
> > +
> > +static int cx24117_read_signal_strength(struct dvb_frontend *fe,
> > +	u16 *signal_strength)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +	int ret;
> > +	u16 sig_reading;
> > +	u8 buf[2];
> > +	u8 reg = (state->demod == 0) ?
> > +		CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1;
> > +
> > +	/* Firmware CMD 1A */
> > +	cmd.args[0] = 0x1a;
> > +	cmd.args[1] = (u8) state->demod;
> > +	cmd.len = 2;
> > +	ret = cx24117_cmd_execute(fe, &cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	ret = cx24117_readregN(state, reg, buf, 2);
> > +	if (ret != 0)
> > +		return ret;
> > +	sig_reading = ((buf[0] & CX24117_SIGNAL_MASK) << 2) | buf[1];
> > +
> > +	*signal_strength = -100 * sig_reading + 94324;
> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s() demod%d raw / cooked = 0x%04x / 0x%04x\n",
> > +		__func__, state->demod, sig_reading, *signal_strength);
> > +
> > +	return 0;	
> > +}
> > +
> > +static int cx24117_read_snr(struct dvb_frontend *fe, u16 *snr)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int ret;
> > +	u16 snr_reading;
> > +	u8 buf[2];
> > +	u8 reg = (state->demod == 0) ?
> > +		CX24117_REG_QUALITY2_0 : CX24117_REG_QUALITY2_1;
> > +
> > +	ret = cx24117_readregN(state, reg, buf, 2);
> > +	if (ret != 0)
> > +		return ret;
> > +	snr_reading = (buf[0] << 8) | buf[1];
> > +
> > +	/* display in percentage */
> > +	if (esno_snr == 1) {
> > +		if (snr_reading >= 0xa0 /* 100% */)
> > +			*snr = 0xffff;
> > +		else
> > +			*snr = 4530 * snr_reading / 11;
> > +	} else {
> > +		*snr = snr_reading;
> > +	}

Just do it in dB. Please notice that the scale with DVBv5 stats is
actually 0.001 dB (and if you'll also be implementing a DVBv3 legacy stats,
scale there is generally 0.1dB).

> > +
> > +	dev_dbg(&state->priv->i2c->dev,
> > +		"%s() demod%d raw / cooked=%d%% / 0x%04x\n",
> > +		__func__, state->demod, snr_reading, *snr);
> > +
> > +	return ret;
> > +}
> > +
> > +static int cx24117_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	fe_delivery_system_t delsys = fe->dtv_property_cache.delivery_system;
> > +	int ret;
> > +	u8 buf[2];
> > +	u8 reg = (state->demod == 0) ?
> > +		CX24117_REG_DVBS_UCB2_0 :
> > +		CX24117_REG_DVBS_UCB2_1;
> > +
> > +	switch (delsys) {
> > +	case SYS_DVBS:
> > +		break;
> > +	case SYS_DVBS2:
> > +		reg += (CX24117_REG_DVBS2_UCB2_0 - CX24117_REG_DVBS_UCB2_0);
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;

-EINVAL.

> > +	}
> > +
> > +	ret = cx24117_readregN(state, reg, buf, 2);
> > +	if (ret != 0)
> > +		return ret;
> > +	*ucblocks = (buf[0] << 8) | buf[1];
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d ucb=0x%04x\n",
> > +		__func__, state->demod, *ucblocks);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Overwrite the current tuning params, we are about to tune */
> > +static void cx24117_clone_params(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	state->dcur = state->dnxt;
> > +}
> > +
> > +/* Wait for LNB */
> > +static int cx24117_wait_for_lnb(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int i;
> > +	u8 val, reg = (state->demod == 0) ? CX24117_REG_QSTATUS0 :
> > +					    CX24117_REG_QSTATUS1;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d qstatus = 0x%02x\n",
> > +		__func__, state->demod, cx24117_readreg(state, reg));
> > +
> > +	/* Wait for up to 300 ms */
> > +	for (i = 0; i < 10 ; i++) {
> > +		val = cx24117_readreg(state, reg) & 0x01;
> > +		if (val != 0)
> > +			return 0;
> > +		msleep(30);
> > +	}
> > +
> > +	dev_warn(&state->priv->i2c->dev, "%s: demod%d LNB not ready\n",
> > +		KBUILD_MODNAME, state->demod);
> > +
> > +	return -ETIMEDOUT; /* -EBUSY ? */
> > +}
> > +
> > +static int cx24117_set_voltage(struct dvb_frontend *fe,
> > +	fe_sec_voltage_t voltage)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +	int ret;
> > +	u8 reg = (state->demod == 0) ? 0x10 : 0x20;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d %s\n",
> > +		__func__, state->demod,
> > +		voltage == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
> > +		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "SEC_VOLTAGE_OFF");
> > +
> > +	/* CMD 32 */
> > +	cmd.args[0] = 0x32;
> > +	cmd.args[1] = reg;
> > +	cmd.args[2] = reg;
> > +	cmd.len = 3;
> > +	ret = cx24117_cmd_execute(fe, &cmd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if ((voltage == SEC_VOLTAGE_13) ||
> > +	    (voltage == SEC_VOLTAGE_18)) {
> > +		/* CMD 33 */
> > +		cmd.args[0] = 0x33;
> > +		cmd.args[1] = reg;
> > +		cmd.args[2] = reg;
> > +		cmd.len = 3;
> > +		ret = cx24117_cmd_execute(fe, &cmd);
> > +		if (ret != 0)
> > +			return ret;
> > +	
> > +		ret = cx24117_wait_for_lnb(fe);
> > +		if (ret != 0)
> > +			return ret;
> > +
> > +		/* Wait for voltage/min repeat delay */
> > +		msleep(100);
> > +
> > +		/* CMD 22 - CMD_LNBDCLEVEL */
> > +		cmd.args[0] = CMD_LNBDCLEVEL;
> > +		cmd.args[1] = state->demod ? 0 : 1;
> > +		cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 0x01 : 0x00);
> > +		cmd.len = 3;
> > +
> > +		/* Min delay time before DiSEqC send */
> > +		msleep(15);
> > +	} else {
> > +		cmd.args[0] = 0x33;
> > +		cmd.args[1] = 0x00;
> > +		cmd.args[2] = reg;
> > +		cmd.len = 3;
> > +	}
> > +
> > +	return cx24117_cmd_execute(fe, &cmd);
> > +}
> > +
> > +static int cx24117_set_tone(struct dvb_frontend *fe,
> > +	fe_sec_tone_mode_t tone)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +	int ret;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
> > +		__func__, state->demod, tone);
> > +	if ((tone != SEC_TONE_ON) && (tone != SEC_TONE_OFF)) {
> > +		dev_warn(&state->priv->i2c->dev, "%s: demod%d invalid tone=%d\n",
> > +			KBUILD_MODNAME, state->demod, tone);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Wait for LNB ready */
> > +	ret = cx24117_wait_for_lnb(fe);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	/* Min delay time after DiSEqC send */
> > +	msleep(15);
> > +
> > +	/* Set the tone */
> > +	/* CMD 23 - CMD_SET_TONE */
> > +	cmd.args[0] = CMD_SET_TONE;
> > +	cmd.args[1] = (state->demod ? 0 : 1);
> > +	cmd.args[2] = 0x00;
> > +	cmd.args[3] = 0x00;
> > +	cmd.len = 5;
> > +	switch (tone) {
> > +	case SEC_TONE_ON:
> > +		cmd.args[4] = 0x01;
> > +		break;
> > +	case SEC_TONE_OFF:
> > +		cmd.args[4] = 0x00;
> > +		break;
> > +	}
> > +
> > +	msleep(15);
> > +
> > +	return cx24117_cmd_execute(fe, &cmd);
> > +}
> > +
> > +/* Initialise DiSEqC */
> > +static int cx24117_diseqc_init(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +
> > +	/* Prepare a DiSEqC command */
> > +	state->dsec_cmd.args[0] = CMD_LNBSEND;
> > +
> > +	/* demod */
> > +	state->dsec_cmd.args[CX24117_DISEQC_DEMOD] = state->demod ? 0 : 1;
> > +
> > +	/* DiSEqC burst */
> > +	state->dsec_cmd.args[CX24117_DISEQC_BURST] = CX24117_DISEQC_MINI_A;
> > +
> > +	/* Unknown */
> > +	state->dsec_cmd.args[CX24117_DISEQC_ARG3_2] = 0x02;
> > +	state->dsec_cmd.args[CX24117_DISEQC_ARG4_0] = 0x00;
> > +
> > +	/* Continuation flag? */
> > +	state->dsec_cmd.args[CX24117_DISEQC_ARG5_0] = 0x00;
> > +
> > +	/* DiSEqC message length */
> > +	state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] = 0x00;
> > +
> > +	/* Command length */
> > +	state->dsec_cmd.len = 7;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Send DiSEqC message */
> > +static int cx24117_send_diseqc_msg(struct dvb_frontend *fe,
> > +	struct dvb_diseqc_master_cmd *d)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	int i, ret;
> > +
> > +	/* Dump DiSEqC message */
> > +	/*if (debug) {
> > +		printk(KERN_INFO "cx24117: demod %d %s(",
> > +			state->demod, __func__);
> > +		for (i = 0 ; i < d->msg_len ;) {
> > +			printk(KERN_INFO "0x%02x", d->msg[i]);
> > +			if (++i < d->msg_len)
> > +				printk(KERN_INFO ", ");
> > +		}
> > +		printk(")\n");
> > +	}*/
> > +
> > +	/* Validate length */
> > +	if (d->msg_len > 15)
> > +		return -EINVAL;
> > +
> > +	/* DiSEqC message */
> > +	for (i = 0; i < d->msg_len; i++)
> > +		state->dsec_cmd.args[CX24117_DISEQC_MSGOFS + i] = d->msg[i];
> > +
> > +	/* DiSEqC message length */
> > +	state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] = d->msg_len;
> > +
> > +	/* Command length */
> > +	state->dsec_cmd.len = CX24117_DISEQC_MSGOFS +
> > +		state->dsec_cmd.args[CX24117_DISEQC_MSGLEN];
> > +
> > +	/*
> > +	 * Message is sent with derived else cached burst
> > +	 *
> > +	 * WRITE PORT GROUP COMMAND 38
> > +	 *
> > +	 * 0/A/A: E0 10 38 F0..F3
> > +	 * 1/B/B: E0 10 38 F4..F7
> > +	 * 2/C/A: E0 10 38 F8..FB
> > +	 * 3/D/B: E0 10 38 FC..FF
> > +	 *
> > +	 * databyte[3]= 8421:8421
> > +	 *              ABCD:WXYZ
> > +	 *              CLR :SET
> > +	 *
> > +	 *              WX= PORT SELECT 0..3    (X=TONEBURST)
> > +	 *              Y = VOLTAGE             (0=13V, 1=18V)
> > +	 *              Z = BAND                (0=LOW, 1=HIGH(22K))
> > +	 */
> > +	if (d->msg_len >= 4 && d->msg[2] == 0x38)
> > +		state->dsec_cmd.args[CX24117_DISEQC_BURST] =
> > +			((d->msg[3] & 4) >> 2);
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d burst=%d\n",
> > +		__func__, state->demod,
> > +		state->dsec_cmd.args[CX24117_DISEQC_BURST]);
> > +
> > +	/* Wait for LNB ready */
> > +	ret = cx24117_wait_for_lnb(fe);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	/* Wait for voltage/min repeat delay */
> > +	msleep(100);
> > +
> > +	/* Command */
> > +	ret = cx24117_cmd_execute(fe, &state->dsec_cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +	/*
> > +	 * Wait for send
> > +	 *
> > +	 * Eutelsat spec:
> > +	 * >15ms delay          + (XXX determine if FW does this, see set_tone)
> > +	 *  13.5ms per byte     +
> > +	 * >15ms delay          +
> > +	 *  12.5ms burst        +
> > +	 * >15ms delay            (XXX determine if FW does this, see set_tone)
> > +	 */
> > +	msleep((state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] << 4) + 60);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Send DiSEqC burst */
> > +static int cx24117_diseqc_send_burst(struct dvb_frontend *fe,
> > +	fe_sec_mini_cmd_t burst)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s(%d) demod=%d\n",
> > +		__func__, burst, state->demod);
> > +
> > +	/* DiSEqC burst */
> > +	if (burst == SEC_MINI_A)
> > +		state->dsec_cmd.args[CX24117_DISEQC_BURST] =
> > +			CX24117_DISEQC_MINI_A;
> > +	else if (burst == SEC_MINI_B)
> > +		state->dsec_cmd.args[CX24117_DISEQC_BURST] =
> > +			CX24117_DISEQC_MINI_B;
> > +	else
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static void cx24117_release(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	dev_dbg(&state->priv->i2c->dev, "%s demod%d\n",
> > +		__func__, state->demod);
> > +	if (!atomic_dec_and_test(&state->priv->fe_nr))
> > +		kfree(state->priv);
> > +	kfree(state);
> > +}
> > +
> > +static struct dvb_frontend_ops cx24117_ops;
> > +
> > +struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
> > +	struct i2c_adapter *i2c, struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = NULL;
> > +	struct cx24117_priv *priv = NULL;
> > +	int demod = 0;
> > +
> > +	/* first frontend attaching */
> > +	/* allocate shared priv struct */
> > +	if (fe == NULL) {
> > +		priv = (struct cx24117_priv*) kzalloc(
> > +			sizeof(struct cx24117_priv), GFP_KERNEL);
> > +		if (priv == NULL)
> > +			goto error1;
> > +
> > +		priv->i2c = i2c;
> > +		priv->demod_address = config->demod_address;
> > +		mutex_init(&priv->fe_lock);
> > +	} else {
> > +		demod = 1;
> > +		priv = ((struct cx24117_state*) fe->demodulator_priv)->priv;
> > +	}
> > +
> > +	printk("CX24117 attaching frontend %d\n", demod);
> > +
> > +	/* nr of frontends using the module */
> > +	atomic_inc(&priv->fe_nr);
> > +
> > +	/* allocate memory for the internal state */
> > +	state = kzalloc(sizeof(struct cx24117_state), GFP_KERNEL);
> > +	if (state == NULL)
> > +		goto error2;
> > +
> > +	state->demod = demod;
> > +	state->priv = priv;
> > +
> > +	/* TODO: confirm device presence */
> 
> If you don't know which is ID register, it is still good idea just read 
> register 0 and check it does not fail (== confirm at least I2C 
> communication is working). You will need to do it only for the first FE 
> attach. Chip ID is usually register 0x00 or 0xff.
> 
> > +
> > +	/* create dvb_frontend */
> > +	memcpy(&state->frontend.ops, &cx24117_ops,
> > +		sizeof(struct dvb_frontend_ops));
> > +	state->frontend.demodulator_priv = state;
> > +	return &state->frontend;
> > +
> > +error2:	kfree(priv);
> > +error1:	return NULL;

Please put the labels on a separate line, like:

error2:
	kfree(priv);
error1:
	return NULL;

> > +}
> > +EXPORT_SYMBOL(cx24117_attach);

EXPORT_SYMBOL_GPL().

> > +
> > +/*
> > + * Initialise or wake up device
> > + *
> > + * Power config will reset and load initial firmware if required
> > + */
> > +static int cx24117_initfe(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +	int ret;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
> > +		__func__, state->demod);
> > +
> > +	mutex_lock(&state->priv->fe_lock);
> > +
> > +	/* Firmware CMD 36: Power config */
> > +	cmd.args[0] = CMD_TUNERSLEEP;
> > +	cmd.args[1] = (state->demod ? 1 : 0);
> > +	cmd.args[2] = 0;
> > +	cmd.len = 3;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	ret = cx24117_diseqc_init(fe);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	/* CMD 3C */
> > +	cmd.args[0] = 0x3c;
> > +	cmd.args[1] = (state->demod ? 1 : 0);
> > +	cmd.args[2] = 0x10;
> > +	cmd.args[3] = 0x10;
> > +	cmd.len = 4;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	/* CMD 34 */
> > +	cmd.args[0] = 0x34;
> > +	cmd.args[1] = (state->demod ? 1 : 0);
> > +	cmd.args[2] = CX24117_OCC;
> > +	cmd.len = 3;
> > +	ret = cx24117_cmd_execute_nolock(fe, &cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	mutex_unlock(&state->priv->fe_lock);
> > +
> > +	return cx24117_set_voltage(fe, SEC_VOLTAGE_13);
> 
> Is setting LNB voltage really needed at that early? dvb-frontend will 
> set it just a little bit later, according to tuning request.
> 
> > +}
> > +
> > +/*
> > + * Put device to sleep
> > + */
> > +static int cx24117_sleep(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct cx24117_cmd cmd;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
> > +		__func__, state->demod);
> > +
> > +	/* Firmware CMD 36: Power config */
> > +	cmd.args[0] = CMD_TUNERSLEEP;
> > +	cmd.args[1] = (state->demod ? 1 : 0);
> > +	cmd.args[2] = 1;
> > +	cmd.len = 3;
> > +	return cx24117_cmd_execute(fe, &cmd);
> > +}
> > +
> > +/* dvb-core told us to tune, the tv property cache will be complete,
> > + * it's safe for is to pull values and use them for tuning purposes.
> > + */
> > +static int cx24117_set_frontend(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> > +	struct cx24117_cmd cmd;
> > +	fe_status_t tunerstat;
> > +	int i, status, ret, retune = 1;
> > +	u8 reg_clkdiv, reg_ratediv;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
> > +		__func__, state->demod);
> > +
> > +	switch (c->delivery_system) {
> > +	case SYS_DVBS:
> > +		dev_dbg(&state->priv->i2c->dev, "%s() demod%d DVB-S\n",
> > +			__func__, state->demod);
> > +
> > +		/* Only QPSK is supported for DVB-S */
> > +		if (c->modulation != QPSK) {
> > +			dev_dbg(&state->priv->i2c->dev,
> > +				"%s() demod%d unsupported modulation (%d)\n",
> > +				__func__, state->demod, c->modulation);
> > +			return -EOPNOTSUPP;

-EINVAL.

> > +		}
> > +
> > +		/* Pilot doesn't exist in DVB-S, turn bit off */
> > +		state->dnxt.pilot_val = CX24117_PILOT_OFF;
> > +
> > +		/* DVB-S only supports 0.35 */
> > +		if (c->rolloff != ROLLOFF_35) {
> > +			dev_dbg(&state->priv->i2c->dev,
> > +				"%s() demod%d unsupported rolloff (%d)\n",
> > +				__func__, state->demod, c->rolloff);
> > +			return -EOPNOTSUPP;

In the case of DVB-S, just set c->rolloff to 0.35, as a DVB-S client will
never fill c->rolloff. If you fail to do that, a switch from DVB-S2 to 
DVB-S will fail, if the previous channel was using a different rolloff.

> > +		}
> > +		state->dnxt.rolloff_val = CX24117_ROLLOFF_035;

Not actually needed, as you'll be already doing that at the
switch(c->rolloff) logic below.

> > +		break;
> > +
> > +	case SYS_DVBS2:
> > +		dev_dbg(&state->priv->i2c->dev, "%s() demod%d DVB-S2\n",
> > +			__func__, state->demod);
> > +
> > +		/*
> > +		 * NBC 8PSK/QPSK with DVB-S is supported for DVB-S2,
> > +		 * but not hardware auto detection
> > +		 */
> > +		if (c->modulation != PSK_8 && c->modulation != QPSK) {
> > +			dev_dbg(&state->priv->i2c->dev, "%s() demod%d"
> > +				"unsupported modulation (%d)\n",
> > +				__func__, state->demod, c->modulation);
> > +			return -EOPNOTSUPP;

-EINVAL.

> > +		}
> > +
> > +		switch (c->pilot) {
> > +		case PILOT_AUTO:
> > +			state->dnxt.pilot_val = CX24117_PILOT_AUTO;
> > +			break;
> > +		case PILOT_OFF:
> > +			state->dnxt.pilot_val = CX24117_PILOT_OFF;
> > +			break;
> > +		case PILOT_ON:
> > +			state->dnxt.pilot_val = CX24117_PILOT_ON;
> > +			break;
> > +		default:
> > +			dev_dbg(&state->priv->i2c->dev,
> > +				"%s() demod%d unsupported pilot mode (%d)\n",
> > +				__func__, state->demod, c->pilot);
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		switch (c->rolloff) {
> > +		case ROLLOFF_20:
> > +			state->dnxt.rolloff_val = CX24117_ROLLOFF_020;
> > +			break;
> > +		case ROLLOFF_25:
> > +			state->dnxt.rolloff_val = CX24117_ROLLOFF_025;
> > +			break;
> > +		case ROLLOFF_35:
> > +			state->dnxt.rolloff_val = CX24117_ROLLOFF_035;
> > +			break;
> > +		case ROLLOFF_AUTO:
> > +			state->dnxt.rolloff_val = CX24117_ROLLOFF_035;
> > +			/* soft-auto rolloff */
> > +			retune = 3;
> > +			break;
> > +		default:
> > +			dev_warn(&state->priv->i2c->dev,
> > +				"%s: demod%d unsupported rolloff (%d)\n",
> > +				KBUILD_MODNAME, state->demod, c->rolloff);
> > +			return -EOPNOTSUPP;
> > +		}
> > +		break;
> > +
> > +	default:
> > +		dev_warn(&state->priv->i2c->dev,
> > +			"%s: demod %d unsupported delivery system (%d)\n",
> > +			KBUILD_MODNAME, state->demod, c->delivery_system);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	state->dnxt.delsys = c->delivery_system;
> > +	state->dnxt.modulation = c->modulation;
> > +	state->dnxt.frequency = c->frequency;
> > +	state->dnxt.pilot = c->pilot;
> > +	state->dnxt.rolloff = c->rolloff;
> > +
> > +	ret = cx24117_set_inversion(state, c->inversion);
> > +	if (ret !=  0)
> > +		return ret;
> > +
> > +	ret = cx24117_set_fec(state, c->delivery_system, c->modulation, c->fec_inner);
> > +	if (ret !=  0)
> > +		return ret;
> > +
> > +	ret = cx24117_set_symbolrate(state, c->symbol_rate);
> > +	if (ret !=  0)
> > +		return ret;
> > +
> > +	/* discard the 'current' tuning parameters and prepare to tune */
> > +	cx24117_clone_params(fe);
> > +
> > +	/*
> > +	dprintk("%s:   delsys      = %d\n", __func__, state->dcur.delsys);
> > +	dprintk("%s:   modulation  = %d\n", __func__, state->dcur.modulation);
> > +	dprintk("%s:   frequency   = %d\n", __func__, state->dcur.frequency);
> > +	dprintk("%s:   pilot       = %d (val = 0x%02x)\n", __func__,
> > +		state->dcur.pilot, state->dcur.pilot_val);
> > +	dprintk("%s:   retune      = %d\n", __func__, retune);
> > +	dprintk("%s:   rolloff     = %d (val = 0x%02x)\n", __func__,
> > +		state->dcur.rolloff, state->dcur.rolloff_val);
> > +	dprintk("%s:   symbol_rate = %d\n", __func__, state->dcur.symbol_rate);
> > +	dprintk("%s:   FEC         = %d (mask/val = 0x%02x/0x%02x)\n", __func__,
> > +		state->dcur.fec, state->dcur.fec_mask, state->dcur.fec_val);
> > +	dprintk("%s:   Inversion   = %d (val = 0x%02x)\n", __func__,
> > +		state->dcur.inversion, state->dcur.inversion_val);
> > +	*/
> 
> These debugs could be removed or at least converted to the current 
> Kernel dynamic debug model (dev_dbg()).
> 
> > +
> > +	/* Prepare a tune request */
> > +	cmd.args[0] = CMD_TUNEREQUEST;
> > +
> > +	/* demod */
> > +	cmd.args[1] = (u8) state->demod;
> 
> casting
> 
> > +
> > +	/* Frequency */
> > +	cmd.args[2] = (state->dcur.frequency & 0xff0000) >> 16;
> > +	cmd.args[3] = (state->dcur.frequency & 0x00ff00) >> 8;
> > +	cmd.args[4] = (state->dcur.frequency & 0x0000ff);
> > +
> > +	/* Symbol Rate */
> > +	cmd.args[5] = ((state->dcur.symbol_rate / 1000) & 0xff00) >> 8;
> > +	cmd.args[6] = ((state->dcur.symbol_rate / 1000) & 0x00ff);
> > +
> > +	/* Automatic Inversion */
> > +	cmd.args[7] = state->dcur.inversion_val;
> > +
> > +	/* Modulation / FEC / Pilot */
> > +	cmd.args[8] = state->dcur.fec_val | state->dcur.pilot_val;
> > +
> > +	cmd.args[9] = CX24117_SEARCH_RANGE_KHZ >> 8;
> > +	cmd.args[10] = CX24117_SEARCH_RANGE_KHZ & 0xff;
> > +
> > +	cmd.args[11] = state->dcur.rolloff_val;
> > +	cmd.args[12] = state->dcur.fec_mask;
> > +
> > +	if (state->dcur.symbol_rate > 30000000) {
> > +		reg_ratediv = 0x04;
> > +		reg_clkdiv = 0x02;
> > +	} else if (state->dcur.symbol_rate > 10000000) {
> > +		reg_ratediv = 0x06;
> > +		reg_clkdiv = 0x03;
> > +	} else {
> > +		reg_ratediv = 0x0a;
> > +		reg_clkdiv = 0x05;
> > +	}
> > +
> > +	cmd.args[13] = reg_ratediv;
> > +	cmd.args[14] = reg_clkdiv;
> > +
> > +	cx24117_writereg(state, (state->demod == 0) ?
> > +		CX24117_REG_CLKDIV0 : CX24117_REG_CLKDIV1, reg_clkdiv);
> > +	cx24117_writereg(state, (state->demod == 0) ?
> > +		CX24117_REG_RATEDIV0 : CX24117_REG_RATEDIV1, reg_ratediv);
> > +
> > +	cmd.args[15] = CX24117_PNE;
> > +	cmd.len = 16;
> > +
> > +	do {
> > +		/* Reset status register */
> > +		status = cx24117_readreg(state, (state->demod == 0) ?
> > +			CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1) &
> > +			CX24117_SIGNAL_MASK;
> > +
> > +		dev_dbg(&state->priv->i2c->dev,
> > +			"%s() demod%d status_setfe = %02x\n",
> > +			__func__, state->demod, status);
> > +
> > +		cx24117_writereg(state, (state->demod == 0) ?
> > +			CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1, status);
> > +
> > +		/* Tune */
> > +		ret = cx24117_cmd_execute(fe, &cmd);
> > +		if (ret != 0)
> > +			break;
> > +
> > +		/*
> > +		 * Wait for up to 500 ms before retrying
> > +		 *
> > +		 * If we are able to tune then generally it occurs within 100ms.
> > +		 * If it takes longer, try a different rolloff setting.
> > +		 */
> > +		for (i = 0; i < 50 ; i++) {
> > +			cx24117_read_status(fe, &tunerstat);
> > +			status = tunerstat & (FE_HAS_SIGNAL | FE_HAS_SYNC);
> > +			if (status == (FE_HAS_SIGNAL | FE_HAS_SYNC)) {
> > +				dev_dbg(&state->priv->i2c->dev,
> > +					"%s() demod%d tuned\n",
> > +					__func__, state->demod);
> > +				return 0;
> > +			}
> > +			msleep(10);
> > +		}
> > +
> > +		dev_dbg(&state->priv->i2c->dev, "%s() demod%d not tuned\n",
> > +			__func__, state->demod);
> > +
> > +		/* try next rolloff value */
> > +		if (state->dcur.rolloff == 3)
> > +			cmd.args[11]--;
> > +
> > +	} while (--retune);
> > +	return -EINVAL;
> > +}
> > +
> > +static int cx24117_tune(struct dvb_frontend *fe, bool re_tune,
> > +	unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +
> > +	dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
> > +		__func__, state->demod);
> > +
> > +	*delay = HZ / 5;
> > +	if (re_tune) {
> > +		int ret = cx24117_set_frontend(fe);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return cx24117_read_status(fe, status);
> > +}
> > +
> > +static int cx24117_get_algo(struct dvb_frontend *fe)
> > +{
> > +	return DVBFE_ALGO_HW;
> > +}
> > +
> > +static int cx24117_get_frontend(struct dvb_frontend *fe)
> > +{
> > +	struct cx24117_state *state = fe->demodulator_priv;
> > +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> > +	struct cx24117_cmd cmd;
> > +	u8 reg, st, inv;
> > +	int ret, idx;
> > +	unsigned int freq;
> > +	short srate_os, freq_os;
> > +
> > +	u8 buf[0x1f-4];
> > +
> > +	cmd.args[0] = 0x1c;
> > +	cmd.args[1] = (u8) state->demod;
> > +	cmd.len = 2;
> > +	ret = cx24117_cmd_execute(fe, &cmd);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	/* read all required regs at once */
> > +	
> > +	reg = (state->demod == 0) ? CX24117_REG_FREQ3_0 : CX24117_REG_FREQ3_1;
> > +	ret = cx24117_readregN(state, reg, buf, 0x1f-4);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	st = buf[5];
> > +	//printk("%s() demod%d reg 0x5a = %02x\n", __func__, state->demod, st);
> > +
> > +	/* get spectral inversion */
> > +	inv = (((state->demod == 0) ? ~st : st) >> 6) & 1;
> > +	if (inv == 0)
> > +		c->inversion = INVERSION_OFF;
> > +	else
> > +		c->inversion = INVERSION_ON;
> > +
> > +	/* modulation and fec */
> > +	idx = st & 0x3f;
> > +	if (c->delivery_system == SYS_DVBS2) {
> > +		if (idx > 11)
> > +			idx += 9;
> > +		else
> > +			idx += 7;
> > +	}
> > +
> > +	//c->delivery_system = CX24117_MODFEC_MODES[idx].delivery_system;
> > +	c->modulation = CX24117_MODFEC_MODES[idx].modulation;
> > +	c->fec_inner = CX24117_MODFEC_MODES[idx].fec;
> > +	
> > +	/* frequency */
> > +	freq = (buf[0] << 16) | (buf[1] << 8) | buf[2];
> > +	freq_os = (buf[8] << 8) | buf[9];
> > +	c->frequency = freq + freq_os;
> > +
> > +	/* symbol rate */
> > +	srate_os = (buf[10] << 8) | buf[11];
> > +	c->symbol_rate = -1000*srate_os + state->dcur.symbol_rate;

CodingStyle:
	c->symbol_rate = -1000 * srate_os + state->dcur.symbol_rate;

> > +	return 0;
> > +}
> > +
> > +static struct dvb_frontend_ops cx24117_ops = {
> > +	.delsys = { SYS_DVBS, SYS_DVBS2 },
> > +	.info = {
> > +		.name = "Conexant CX24117/CX24132",
> > +		.frequency_min = 950000,
> > +		.frequency_max = 2150000,
> > +		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
> > +		.frequency_tolerance = 5000,
> > +		.symbol_rate_min = 1000000,
> > +		.symbol_rate_max = 45000000,
> > +		.caps = FE_CAN_INVERSION_AUTO |
> > +			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> > +			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
> > +			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> > +			FE_CAN_2G_MODULATION |
> > +			FE_CAN_QPSK | FE_CAN_RECOVER
> > +	},
> > +
> > +	.release = cx24117_release,
> > +
> > +	.init = cx24117_initfe,
> > +	.sleep = cx24117_sleep,
> > +	.read_status = cx24117_read_status,
> > +	.read_ber = cx24117_read_ber,
> > +	.read_signal_strength = cx24117_read_signal_strength,
> > +	.read_snr = cx24117_read_snr,
> > +	.read_ucblocks = cx24117_read_ucblocks,
> > +	.set_tone = cx24117_set_tone,
> > +	.set_voltage = cx24117_set_voltage,
> > +	.diseqc_send_master_cmd = cx24117_send_diseqc_msg,
> > +	.diseqc_send_burst = cx24117_diseqc_send_burst,
> > +	.get_frontend_algo = cx24117_get_algo,
> > +	.tune = cx24117_tune,
> > +
> > +	.set_frontend = cx24117_set_frontend,
> > +	.get_frontend = cx24117_get_frontend,
> > +};
> > +
> > +
> > +MODULE_DESCRIPTION("DVB Frontend module for Conexant cx24117/cx24132 hardware");
> > +MODULE_AUTHOR("Luis Alves (ljalvs@gmail.com)");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("1.1");
> > +
> > diff --git a/drivers/media/dvb-frontends/cx24117.h b/drivers/media/dvb-frontends/cx24117.h
> > new file mode 100644
> > index 0000000..fb918f3
> > --- /dev/null
> > +++ b/drivers/media/dvb-frontends/cx24117.h
> > @@ -0,0 +1,47 @@
> > +/*
> > +    Conexant cx24117/cx24132 - Dual DVBS/S2 Satellite demod/tuner driver
> > +
> > +    Copyright (C) 2013 Luis Alves <ljalvs@gmail.com>
> > +	(based on cx24116.h by Steven Toth)
> > +
> > +    This program is free software; you can redistribute it and/or modify
> > +    it under the terms of the GNU General Public License as published by
> > +    the Free Software Foundation; either version 2 of the License, or
> > +    (at your option) any later version.
> > +
> > +    This program is distributed in the hope that it will be useful,
> > +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +    GNU General Public License for more details.
> > +
> > +    You should have received a copy of the GNU General Public License
> > +    along with this program; if not, write to the Free Software
> > +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > +*/
> > +
> > +#ifndef CX24117_H
> > +#define CX24117_H
> > +
> > +#include <linux/kconfig.h>
> > +#include <linux/dvb/frontend.h>
> > +
> > +struct cx24117_config {
> > +	/* the demodulator's i2c address */
> > +	u8 demod_address;
> > +};
> > +
> > +#if IS_ENABLED(CONFIG_DVB_CX24117)
> > +extern struct dvb_frontend *cx24117_attach(
> > +	const struct cx24117_config *config,
> > +	struct i2c_adapter *i2c, struct dvb_frontend *fe);
> > +#else
> > +static inline struct dvb_frontend *cx24117_attach(
> > +	const struct cx24117_config *config,
> > +	struct i2c_adapter *i2c, struct dvb_frontend *fe)
> > +{
> > +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> > +	return NULL;
> > +}
> > +#endif
> > +
> > +#endif /* CX24117_H */
> > diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
> > index b3688aa..91b2ed7 100644
> > --- a/drivers/media/pci/cx23885/Kconfig
> > +++ b/drivers/media/pci/cx23885/Kconfig
> > @@ -23,6 +23,7 @@ config VIDEO_CX23885
> >   	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
> >   	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
> >   	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
> > +	select DVB_CX24117 if MEDIA_SUBDRV_AUTOSELECT
> >   	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
> >   	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
> >   	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
> > diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> > index 7e923f8..357eb3b 100644
> > --- a/drivers/media/pci/cx23885/cx23885-cards.c
> > +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> > @@ -259,6 +259,16 @@ struct cx23885_board cx23885_boards[] = {
> >   		.name		= "TurboSight TBS 6920",
> >   		.portb		= CX23885_MPEG_DVB,
> >   	},
> > +	[CX23885_BOARD_TBS_6980] = {
> > +		.name		= "TurboSight TBS 6980",
> > +		.portb		= CX23885_MPEG_DVB,
> > +		.portc		= CX23885_MPEG_DVB,
> > +	},
> > +	[CX23885_BOARD_TBS_6981] = {
> > +		.name		= "TurboSight TBS 6981",
> > +		.portb		= CX23885_MPEG_DVB,
> > +		.portc		= CX23885_MPEG_DVB,
> > +	},
> >   	[CX23885_BOARD_TEVII_S470] = {
> >   		.name		= "TeVii S470",
> >   		.portb		= CX23885_MPEG_DVB,
> > @@ -698,6 +708,14 @@ struct cx23885_subid cx23885_subids[] = {
> >   		.subdevice = 0x8888,
> >   		.card      = CX23885_BOARD_TBS_6920,
> >   	}, {
> > +		.subvendor = 0x6980,
> > +		.subdevice = 0x8888,
> > +		.card      = CX23885_BOARD_TBS_6980,
> > +	}, {
> > +		.subvendor = 0x6981,
> > +		.subdevice = 0x8888,
> > +		.card      = CX23885_BOARD_TBS_6981,
> > +	}, {
> >   		.subvendor = 0xd470,
> >   		.subdevice = 0x9022,
> >   		.card      = CX23885_BOARD_TEVII_S470,
> > @@ -1022,6 +1040,33 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
> >   			dev->name, tv.model);
> >   }
> >
> > +/* some TBS cards require init */
> > +static void tbs_card_init(struct cx23885_dev *dev)
> > +{
> > +	int i;
> > +	const u8 buf[] = {
> > +		0xe0, 0x06, 0x66, 0x33, 0x65,
> > +		0x01, 0x17, 0x06, 0xde};
> > +	
> > +	switch (dev->board) {
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> > +		cx_set(GP0_IO, 0x00070007);
> > +		mdelay(1);
> > +		cx_clear(GP0_IO, 2);
> > +		mdelay(1);
> 
> I suspect using Ndelay() is against Kernel documentation. Generally you 
> should use some suitable Nsleep() instead as delay will not sleep => 
> damage system performance. That kind of GPIO reset is not critical at 
> all, likely msleep(20) is something you would like to use.
> 
> 
> > +		/* send init bitstream */
> > +		for (i=0; i<9 * 8; i++) {

CodingStyle:
		i < 9

> > +			cx_clear(GP0_IO, 7);
> > +			udelay(100);
> > +			cx_set(GP0_IO, ((buf[i>>3]>>(7-(i&7)))&1)|4);

CodingStyle: Please add whitespaces before and after each operator.

> > +			udelay(100);
> > +		}
> > +		cx_set(GP0_IO, 7);
> 
> hmm, what that does? is it bitbang I2C over GPIO?
> It looks so special that comments will not surely hurt.
> 
> > +		break;
> > +	}
> > +}
> > +
> >   int cx23885_tuner_callback(void *priv, int component, int command, int arg)
> >   {
> >   	struct cx23885_tsport *port = priv;
> > @@ -1224,6 +1269,8 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
> >   		cx_set(GP0_IO, 0x00040004);
> >   		break;
> >   	case CX23885_BOARD_TBS_6920:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   	case CX23885_BOARD_PROF_8000:
> >   		cx_write(MC417_CTL, 0x00000036);
> >   		cx_write(MC417_OEN, 0x00001000);
> > @@ -1472,6 +1519,8 @@ int cx23885_ir_init(struct cx23885_dev *dev)
> >   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
> >   	case CX23885_BOARD_TEVII_S470:
> >   	case CX23885_BOARD_MYGICA_X8507:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		if (!enable_885_ir)
> >   			break;
> >   		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
> > @@ -1515,6 +1564,8 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
> >   	case CX23885_BOARD_TEVII_S470:
> >   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> >   	case CX23885_BOARD_MYGICA_X8507:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
> >   		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
> >   		dev->sd_ir = NULL;
> > @@ -1560,6 +1611,8 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
> >   	case CX23885_BOARD_TEVII_S470:
> >   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> >   	case CX23885_BOARD_MYGICA_X8507:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		if (dev->sd_ir)
> >   			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
> >   		break;
> > @@ -1675,6 +1728,16 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> >   		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> >   		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> >   		break;
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> > +		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> > +		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> > +		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> > +		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> > +		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> > +		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> > +		tbs_card_init(dev);
> > +		break;
> >   	case CX23885_BOARD_MYGICA_X8506:
> >   	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
> >   		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> > @@ -1750,6 +1813,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> >   	case CX23885_BOARD_MYGICA_X8507:
> >   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
> >   	case CX23885_BOARD_AVERMEDIA_HC81R:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
> >   				&dev->i2c_bus[2].i2c_adap,
> >   				"cx25840", 0x88 >> 1, NULL);
> > diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> > index 9c5ed10..bfb7e33 100644
> > --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> > +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> > @@ -51,6 +51,7 @@
> >   #include "stv6110.h"
> >   #include "lnbh24.h"
> >   #include "cx24116.h"
> > +#include "cx24117.h"
> >   #include "cimax2.h"
> >   #include "lgs8gxx.h"
> >   #include "netup-eeprom.h"
> > @@ -468,6 +469,10 @@ static struct cx24116_config tbs_cx24116_config = {
> >   	.demod_address = 0x55,
> >   };
> >
> > +static struct cx24117_config tbs_cx24117_config = {
> > +	.demod_address = 0x55,
> > +};
> > +
> >   static struct ds3000_config tevii_ds3000_config = {
> >   	.demod_address = 0x68,
> >   };
> > @@ -1027,6 +1032,32 @@ static int dvb_register(struct cx23885_tsport *port)
> >   			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
> >
> >   		break;
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> > +		i2c_bus = &dev->i2c_bus[1];
> > +
> > +		switch (port->nr) {
> > +		/* PORT B */
> > +		case 1:
> > +			fe0->dvb.frontend = dvb_attach(cx24117_attach,
> > +					&tbs_cx24117_config,
> > +					&i2c_bus->i2c_adap, NULL);
> > +			break;
> > +		/* PORT C */
> > +		case 2:
> > +			/* use fe1 pointer as temporary holder */
> > +			/* for the first frontend */
> > +			fe1 = videobuf_dvb_get_frontend(
> > +				&port->dev->ts1.frontends, 1);
> > +
> > +			fe0->dvb.frontend = dvb_attach(cx24117_attach,
> > +					&tbs_cx24117_config,
> > +					&i2c_bus->i2c_adap, fe1->dvb.frontend);
> > +			/* we're done, so clear fe1 pointer */
> > +			fe1 = NULL;
> > +			break;
> > +		}
> > +		break;
> >   	case CX23885_BOARD_TEVII_S470:
> >   		i2c_bus = &dev->i2c_bus[1];
> >
> > diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> > index 7875dfb..8a49e7c 100644
> > --- a/drivers/media/pci/cx23885/cx23885-input.c
> > +++ b/drivers/media/pci/cx23885/cx23885-input.c
> > @@ -90,6 +90,8 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
> >   	case CX23885_BOARD_TEVII_S470:
> >   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> >   	case CX23885_BOARD_MYGICA_X8507:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		/*
> >   		 * The only boards we handle right now.  However other boards
> >   		 * using the CX2388x integrated IR controller should be similar
> > @@ -168,6 +170,8 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
> >   		break;
> >   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
> >   	case CX23885_BOARD_TEVII_S470:
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> >   		/*
> >   		 * The IR controller on this board only returns pulse widths.
> >   		 * Any other mode setting will fail to set up the device.
> > @@ -298,6 +302,14 @@ int cx23885_input_init(struct cx23885_dev *dev)
> >   		/* A guess at the remote */
> >   		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
> >   		break;
> > +	case CX23885_BOARD_TBS_6980:
> > +	case CX23885_BOARD_TBS_6981:
> > +		/* Integrated CX23885 IR controller */
> > +		driver_type = RC_DRIVER_IR_RAW;
> > +		allowed_protos = RC_BIT_ALL;
> > +		/* A guess at the remote */
> > +		rc_map = RC_MAP_TBS_NEC;
> > +		break;
> >   	default:
> >   		return -ENODEV;
> >   	}
> > diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> > index 5687d3f..ebcc63e 100644
> > --- a/drivers/media/pci/cx23885/cx23885.h
> > +++ b/drivers/media/pci/cx23885/cx23885.h
> > @@ -93,6 +93,8 @@
> >   #define CX23885_BOARD_PROF_8000                37
> >   #define CX23885_BOARD_HAUPPAUGE_HVR4400        38
> >   #define CX23885_BOARD_AVERMEDIA_HC81R          39
> > +#define CX23885_BOARD_TBS_6981                 40
> > +#define CX23885_BOARD_TBS_6980                 41
> >
> >   #define GPIO_0 0x00000001
> >   #define GPIO_1 0x00000002
> >
> 
> Applying that patch makes bunch of warnings and errors which should be 
> fixed (at least checkpatch errors are not allowed, some warings are OK 
> if is makes code more readable like too long lines).
> 
> Applying: cx24117: Add new dvb-frontend driver (tested cards: TBS6980 
> and TBS6981 Dual tuner DVB-S/S2)
> /home/crope/linuxtv/code/linux/.git/rebase-apply/patch:593: trailing 
> whitespace.
> 	
> /home/crope/linuxtv/code/linux/.git/rebase-apply/patch:597: trailing 
> whitespace.
> 	
> /home/crope/linuxtv/code/linux/.git/rebase-apply/patch:642: trailing 
> whitespace.
> 	
> /home/crope/linuxtv/code/linux/.git/rebase-apply/patch:812: trailing 
> whitespace.
> 				      CX24117_REG_SSTATUS1 ) &
> /home/crope/linuxtv/code/linux/.git/rebase-apply/patch:884: trailing 
> whitespace.
> 	return 0;	
> warning: squelched 5 whitespace errors
> warning: 10 lines add whitespace errors.
> 
> 
> git show --format=email | ./scripts/checkpatch.pl -
> total: 21 errors, 59 warnings, 1946 lines checked
> 
> 
> For addition of those comments I added between the code I would like to 
> point few more general findings, which are more style issues than real 
> issues:
> 
> * There was 5 pieces of i2c_transfer(). Generally you will only need 2 
> i2c_transfer(), one for read_regs() and one for write_regs()
> 
> * DiSEqC caching to state. I looked that very many times as it looked 
> abnormal. Why you will cache DiSEqC commands?
> 
> * There was legacy printk used (also current ones). You must change all 
> printings to new style, dev_foo()
> 
> * unneeded castings
> 
> * some extra new lines
> 
> * Could you resend that patchset as two parts, first indroduce new demod 
> driver and second patch adding support for those devices.
> 
> 
> I think checkpatch.pl will already show most of those, use it. Use it 
> also verifying patch before sending new version of patch.
> 
> 
> regards
> Antti
> 
> 


Cheers,
Mauro
