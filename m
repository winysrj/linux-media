Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ctb-mesg5.saix.net ([196.25.240.75])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jd.louw@mweb.co.za>) id 1Jq2iZ-0000Yq-AI
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 10:58:45 +0200
From: "Jan D. Louw" <jd.louw@mweb.co.za>
To: Matthias Schwarzott <zzam@gentoo.org>
Date: Sun, 27 Apr 2008 10:57:59 +0200
References: <20080412150444.987445669@gentoo.org>
	<000a01c8a7b7$5cc2c060$0500000a@Core2Duo>
	<200804270551.30966.zzam@gentoo.org>
In-Reply-To: <200804270551.30966.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XAEFIlXK8j81QxH"
Message-Id: <200804271057.59210.jd.louw@mweb.co.za>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch 0/5] mt312: Add support for zl10313 demod
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_XAEFIlXK8j81QxH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 27 April 2008 05:51:30 Matthias Schwarzott wrote:
> On Samstag, 26. April 2008, Jan Louw wrote:
> > Hi Matthias,
> >
> > It still works. I combined your zl10313 modulator patch  with my earlier
> > zl10039 frontend patch. The additional modifications necesary are in (see
> > previous patch):
> >
> > ~/schwarzottv4l/v4l-dvb $ hg status
> > M linux/drivers/media/dvb/frontends/Kconfig
> > M linux/drivers/media/dvb/frontends/Makefile
> > M linux/drivers/media/video/saa7134/Kconfig
> > M linux/drivers/media/video/saa7134/saa7134-cards.c
> > M linux/drivers/media/video/saa7134/saa7134-dvb.c
> > M linux/drivers/media/video/saa7134/saa7134.h
> > A linux/drivers/media/dvb/frontends/zl10039.c
> > A linux/drivers/media/dvb/frontends/zl10039.h
> > A linux/drivers/media/dvb/frontends/zl10039_priv.h
> >
> > To keep it simple I omitted the previous remote control code.
>
> As you see here my zl10036 driver seems to work to some point:
> http://thread.gmane.org/gmane.linux.drivers.dvb/41015/focus=41303
>
> Could you please mail your current driver for zl10039.
> Maybe it is worth merging both.
>
> Regards
> Matthias

Hi Matthias,

Here's the zl10039 driver. With the zl10039 I did not bother with offsets or 
gains - even the weak channels lock stable :-)

I used a constant bandwidth resolution of 200KHz (reference divider of 10) and 
a PLL frequency divider of 80.

Regards
JD





--Boundary-00=_XAEFIlXK8j81QxH
Content-Type: text/x-csrc;
  charset="utf-8";
  name="zl10039.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="zl10039.c"

/*
 *  Driver for Zarlink ZL10039 DVB-S tuner
 *
 *  Copyright 2007 Jan Dani=EBl Louw <jd.louw@mweb.co.za>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=3D
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/string.h>
#include <linux/slab.h>
#include <linux/dvb/frontend.h>

#include "dvb_frontend.h"
#include "zl10039.h"
#include "zl10039_priv.h"


static int zl10039_read(const struct zl10039_state *state,
			const enum zl10039_reg_addr reg, u8 *buf,
			const size_t count)
{
	struct i2c_msg msg[2];
	u8 regbuf[1] =3D { reg };
	int i;

	io_printk("%s\n", __FUNCTION__);
	/* Write register address */
	msg[0].addr =3D state->config.tuner_address;
	msg[0].flags =3D 0;
	msg[0].buf =3D regbuf;
	msg[0].len =3D 1;
	/* Read count bytes */
	msg[1].addr =3D state->config.tuner_address;
	msg[1].flags =3D I2C_M_RD;
	msg[1].buf =3D buf;
	msg[1].len =3D count;
	if (i2c_transfer(state->i2c, msg, 2) !=3D 2) {
		eprintk("%s: i2c read error\n", __FUNCTION__);
		return -EREMOTEIO;
	}
	for (i =3D 0; i < count; i++) {
		io_printk("R[%s] =3D 0x%x\n", zl10039_reg_names[reg + i], buf[i]);
	}
	return 0; /* Success */
}

static int zl10039_write(struct zl10039_state *state,
			const enum zl10039_reg_addr reg, const u8 *src,
			const size_t count)
{
	u8 buf[count + 1];
	struct i2c_msg msg;
	int i;

	io_printk("%s\n", __FUNCTION__);
	for (i =3D 0; i < count; i++) {
		io_printk("W[%s] =3D 0x%x\n", zl10039_reg_names[reg + i], src[i]);
	}
	/* Write register address and data in one go */
	buf[0] =3D reg;
	memcpy(&buf[1], src, count);
	msg.addr =3D state->config.tuner_address;
	msg.flags =3D 0;
	msg.buf =3D buf;
	msg.len =3D count + 1;
	if (i2c_transfer(state->i2c, &msg, 1) !=3D 1) {
		eprintk("%s: i2c write error\n", __FUNCTION__);
		return -EREMOTEIO;
	}
	return 0; /* Success */
}

static inline int zl10039_readreg(struct zl10039_state *state,
				const enum zl10039_reg_addr reg, u8 *val)
{
	return zl10039_read(state, reg, val, 1);
}

static inline int zl10039_writereg(struct zl10039_state *state,
				const enum zl10039_reg_addr reg,
				const u8 val)
{
	return zl10039_write(state, reg, &val, 1);
}

static int zl10039_init(struct dvb_frontend *fe)
{
	struct zl10039_state *state =3D fe->tuner_priv;
	int ret;

	trace_printk("%s\n", __FUNCTION__);
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 1);
	/* Reset logic */
	ret =3D zl10039_writereg(state, GENERAL, 0x40);
	if (ret < 0) {
		eprintk("Note: i2c write error normal when resetting the "
			"tuner\n");
	}
	/* Wake up */
	ret =3D zl10039_writereg(state, GENERAL, 0x01);
	if (ret < 0) {
		eprintk("Tuner power up failed\n");
		return ret;
	}
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
	return 0;
}

static int zl10039_sleep(struct dvb_frontend *fe)
{
	struct zl10039_state *state =3D fe->tuner_priv;
	int ret;

	trace_printk("%s\n", __FUNCTION__);
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 1);
	ret =3D zl10039_writereg(state, GENERAL, 0x80);
	if (ret < 0) {
		eprintk("Tuner sleep failed\n");
		return ret;
	}
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
	return 0;
}

static int zl10039_set_params(struct dvb_frontend *fe,
			struct dvb_frontend_parameters *params)
{
	struct zl10039_state *state =3D fe->tuner_priv;
	u8 buf[6];
	u8 bf;
	u32 fbw;
	u32 div;
	int ret;

	trace_printk("%s\n", __FUNCTION__);
	params_printk("Set frequency =3D %d, symbol rate =3D %d\n",
			params->frequency, params->u.qpsk.symbol_rate);

	/* Assumed 10.111 MHz crystal oscillator */
	/* Cancelled num/den 80 to prevent overflow */
	div =3D (params->frequency * 1000) / 126387;
	fbw =3D (params->u.qpsk.symbol_rate * 27) / 32000;
	/* Cancelled num/den 10 to prevent overflow */
	bf =3D ((fbw * 5088) / 1011100) - 1;

	/*PLL divider*/
	buf[0] =3D (div >> 8) & 0x7f;
	buf[1] =3D (div >> 0) & 0xff;
	/*Reference divider*/
	/* Select reference ratio of 80 */
	buf[2] =3D 0x1D;
	/*PLL test modes*/
	buf[3] =3D 0x40;
	/*RF Control register*/
	buf[4] =3D 0x6E; /* Bypass enable */
	/*Baseband filter cutoff */
	buf[5] =3D bf;

	/* Open i2c gate */
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 1);
	/* BR =3D 10, Enable filter adjustment */
	ret =3D zl10039_writereg(state, BASE1, 0x0A);
	if (ret < 0) goto error;
	/* Write new config values */
	ret =3D zl10039_write(state, PLL0, buf, sizeof(buf));
	if (ret < 0) goto error;
	/* BR =3D 10, Disable filter adjustment */
	ret =3D zl10039_writereg(state, BASE1, 0x6A);
	if (ret < 0) goto error;

	zl10039_dump_registers(state);
	/* Close i2c gate */
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
	return 0;
error:
	eprintk("Error setting tuner\n");
	return ret;
}

static struct dvb_tuner_ops zl10039_ops;

struct dvb_frontend * zl10039_attach(struct dvb_frontend *fe,
		const struct zl10039_config *config, struct i2c_adapter *i2c)
{
	struct zl10039_state *state =3D NULL;

	trace_printk("%s\n", __FUNCTION__);
	state =3D kmalloc(sizeof(struct zl10039_state), GFP_KERNEL);
	if (state =3D=3D NULL) goto error;

	state->i2c =3D i2c;
	state->config.tuner_address =3D config->tuner_address;

	/* Open i2c gate */
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 1);
	/* check if this is a valid tuner */
	if (zl10039_readreg(state, GENERAL, &state->id) < 0) {
		/* Close i2c gate */
		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
		goto error;
	}
	/* Close i2c gate */
	if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);

	state->id =3D state->id & 0x0F;
	switch (state->id) {
	case ID_ZL10039:
		strcpy(fe->ops.tuner_ops.info.name,
			"Zarlink ZL10039 DVB-S tuner");
		break;
	default:
		eprintk("Chip ID does not match a known type\n");
		goto error;
	}
	memcpy(&fe->ops.tuner_ops, &zl10039_ops, sizeof(struct dvb_tuner_ops));
	fe->tuner_priv =3D state;
	iprintk("Tuner attached @ i2c address 0x%02x\n", config->tuner_address);
	return fe;
error:
	kfree(state);
	return NULL;
}

static int zl10039_release(struct dvb_frontend *fe)
{
	struct zl10039_state *state =3D fe->tuner_priv;

	trace_printk("%s\n", __FUNCTION__);
	kfree(state);
	fe->tuner_priv =3D NULL;
	return 0;
}

static struct dvb_tuner_ops zl10039_ops =3D {
	.release =3D zl10039_release,
	.init =3D zl10039_init,
	.sleep =3D zl10039_sleep,
	.set_params =3D zl10039_set_params,
};

EXPORT_SYMBOL(zl10039_attach);

MODULE_DESCRIPTION("Zarlink ZL10039 DVB-S tuner driver");
MODULE_AUTHOR("Jan Dani=EBl Louw <jd.louw@mweb.co.za>");
MODULE_LICENSE("GPL");

--Boundary-00=_XAEFIlXK8j81QxH
Content-Type: text/x-chdr;
  charset="utf-8";
  name="zl10039.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="zl10039.h"

/*
    Driver for Zarlink ZL10039 DVB-S tuner

    Copyright (C) 2007 Jan Dani=EBl Louw <jd.louw@mweb.co.za>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#ifndef ZL10039_H
#define ZL10039_H

struct zl10039_config
{
	/* tuner's i2c address */
	u8 tuner_address;
};

#if defined(CONFIG_DVB_ZL10039) || (defined(CONFIG_DVB_ZL10039_MODULE) \
	    && defined(MODULE))
struct dvb_frontend * zl10039_attach(struct dvb_frontend *fe,
					const struct zl10039_config *config,
					struct i2c_adapter *i2c);
#else
static inline struct dvb_frontend * zl10039_attach(struct dvb_frontend *fe,
					const struct zl10039_config *config,
					struct i2c_adapter *i2c)
{
	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
	return NULL;
}
#endif /* CONFIG_DVB_ZL10039 */

#endif /* ZL10039_H */

--Boundary-00=_XAEFIlXK8j81QxH
Content-Type: text/x-chdr;
  charset="utf-8";
  name="zl10039_priv.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="zl10039_priv.h"

/*
 *  Driver for Zarlink ZL10039 DVB-S tuner
 *
 *  Copyright 2007 Jan Dani=EBl Louw <jd.louw@mweb.co.za>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=3D
 */

#ifndef DVB_FRONTENDS_ZL10039_PRIV
#define DVB_FRONTENDS_ZL10039_PRIV

/* Trace function calls */
#define DEBUG_CALL_TRACE	0
/* Trace read/write function calls - information overload */
#define DEBUG_IO_TRACE		0
/* Print register values at critical points */
#define DEBUG_DUMP_REGISTERS	0
/* Print important params passed to functions */
#define DEBUG_PRINT_PARAMS	0

#if DEBUG_CALL_TRACE
	#define trace_printk(args...) printk(KERN_DEBUG "tuner: zl10039: " args)
#else
	#define trace_printk(args...)
#endif

#if DEBUG_IO_TRACE
	#define io_printk(args...) printk(KERN_DEBUG "tuner: zl10039: " args)
#else
	#define io_printk(args...)
#endif

#if DEBUG_PRINT_PARAMS
	#define params_printk(args...) printk(KERN_DEBUG "tuner: zl10039: " \
						args)
#else
	#define params_printk(args...)
#endif

#define eprintk(args...) printk(KERN_ERR "tuner: zl10039: " args)
#define iprintk(args...) printk(KERN_INFO "tuner: zl10039: " args)

enum zl10039_model_id {
	ID_ZL10039 =3D 1
};

struct zl10039_state {
	struct i2c_adapter *i2c;
	struct zl10039_config config;
	u8 id;
};

enum zl10039_reg_addr {
	PLL0 =3D 0,
	PLL1,
	PLL2,
	PLL3,
	RFFE,
	BASE0,
	BASE1,
	BASE2,
	LO0,
	LO1,
	LO2,
	LO3,
	LO4,
	LO5,
	LO6,
	GENERAL
};

#if DEBUG_DUMP_REGISTERS || DEBUG_IO_TRACE
static const char *zl10039_reg_names[] =3D {
	"PLL_0", "PLL_1", "PLL_2", "PLL_3",
	"RF_FRONT_END", "BASE_BAND_0", "BASE_BAND_1", "BASE_BAND_2",
	"LOCAL_OSC_0", "LOCAL_OSC_1", "LOCAL_OSC_2", "LOCAL_OSC_3",
	"LOCAL_OSC_4", "LOCAL_OSC_5", "LOCAL_OSC_6", "GENERAL"
};
#endif

#if DEBUG_DUMP_REGISTERS
static int zl10039_read(const struct zl10039_state *state,
			const enum zl10039_reg_addr reg, u8 *buf,
			const size_t count);

static void zl10039_dump_registers(const struct zl10039_state *state)
{
	u8 buf[16];
	int ret;
	u8 reg;

	trace_printk("%s\n", __FUNCTION__);
	ret =3D zl10039_read(state, PLL0, buf, sizeof(buf));
	if (ret < 0) return;
	for (reg =3D PLL0; reg <=3D GENERAL; reg +=3D 4) {
		printk(KERN_DEBUG "%03x: [%02x %13s] [%02x %13s] [%02x %13s] "
			"[%02x %13s]\n", reg, buf[reg], zl10039_reg_names[reg],
			buf[reg+1], zl10039_reg_names[reg+1], buf[reg+2],
			zl10039_reg_names[reg+2], buf[reg+3],
			zl10039_reg_names[reg+3]);
	}
}
#else
static inline void zl10039_dump_registers(const struct zl10039_state *state=
) {}
#endif /* DEBUG_DUMP_REGISTERS */

#endif /* DVB_FRONTENDS_ZL10039_PRIV */


--Boundary-00=_XAEFIlXK8j81QxH
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_XAEFIlXK8j81QxH--
