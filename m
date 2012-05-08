Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60699 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2EHHtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 03:49:35 -0400
Received: by bkcji2 with SMTP id ji2so4330083bkc.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 00:49:33 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Re: [PATCH 2/3] ts2020: add ts2020 tuner driver
Date: Tue, 08 May 2012 10:49:41 +0300
Message-ID: <2460134.Dt7ONZjyvc@useri>
In-Reply-To: <CAF0Ff2kwMb87svyKyTh_20ou6=Quvxf4JUx8LpDLV_bTqUF2eA@mail.gmail.com>
References: <CAF0Ff2=_mLSCvnE2mrwGHuJRWfJ0mGowrNxEXhc0PioiuT9gEw@mail.gmail.com> <14221045.uNfrtNFNKi@useri> <CAF0Ff2kwMb87svyKyTh_20ou6=Quvxf4JUx8LpDLV_bTqUF2eA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8 Ð¼Ð°Ñ 2012 10:09:47 Konstantin Dimitrov wrote:
> On Tue, May 8, 2012 at 9:32 AM, Igor M. Liplianin <liplianin@me.by> wrote:
> > On 7 ÃÂ¼ÃÂ°Ã‘ Â 2012 00:22:30 Konstantin Dimitrov wrote:
> >> add separate ts2020 tuner driver
> >> 
> >> Signed-off-by: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> >> 
> >> --- a/linux/drivers/media/dvb/frontends/Kconfig Â  Â  Â  2012-04-20
> >> 06:45:55.000000000 +0300
> >> +++ b/linux/drivers/media/dvb/frontends/Kconfig Â  Â  Â  2012-05-07
> >> 00:58:26.888543350 +0300
> >> @@ -221,6 +221,13 @@
> >> Â  Â  Â  help
> >> Â  Â  Â  Â  A DVB-S tuner module. Say Y when you want to support this
> >> frontend.
> >> 
> >> +config DVB_TS2020
> >> + Â  Â  tristate "Montage Tehnology TS2020 based tuners"
> >> + Â  Â  depends on DVB_CORE && I2C
> >> + Â  Â  default m if DVB_FE_CUSTOMISE
> >> + Â  Â  help
> >> + Â  Â  Â  A DVB-S/S2 silicon tuner. Say Y when you want to support this
> >> tuner. +
> >> Â config DVB_DS3000
> >> Â  Â  Â  tristate "Montage Tehnology DS3000 based"
> >> Â  Â  Â  depends on DVB_CORE && I2C
> >> --- a/linux/drivers/media/dvb/frontends/Makefile Â  Â  Â 2012-04-20
> >> 06:45:55.000000000 +0300
> >> +++ b/linux/drivers/media/dvb/frontends/Makefile Â  Â  Â 2012-05-07
> >> 00:54:44.624546145 +0300
> >> @@ -87,6 +87,7 @@
> >> Â obj-$(CONFIG_DVB_EC100) += ec100.o
> >> Â obj-$(CONFIG_DVB_HD29L2) += hd29l2.o
> >> Â obj-$(CONFIG_DVB_DS3000) += ds3000.o
> >> +obj-$(CONFIG_DVB_TS2020) += ts2020.o
> >> Â obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
> >> Â obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
> >> Â obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
> >> --- a/linux/drivers/media/dvb/frontends/ts2020.h Â  Â  Â 2012-05-07
> >> 01:36:49.876514403 +0300
> >> +++ b/linux/drivers/media/dvb/frontends/ts2020.h Â  Â  Â 2012-05-07
> >> 01:12:54.148532449 +0300
> >> @@ -0,0 +1,68 @@
> >> +/*
> >> + Â  Â Montage Technology TS2020 - Silicon Tuner driver
> >> + Â  Â Copyright (C) 2009-2012 Konstantin Dimitrov
> >> <kosio.dimitrov@gmail.com>
> >> +
> >> + Â  Â Copyright (C) 2009-2012 TurboSight.com
> >> +
> >> + Â  Â This program is free software; you can redistribute it and/or 
modify
> >> + Â  Â it under the terms of the GNU General Public License as published 
by
> >> + Â  Â the Free Software Foundation; either version 2 of the License, or
> >> + Â  Â (at your option) any later version.
> >> +
> >> + Â  Â This program is distributed in the hope that it will be useful,
> >> + Â  Â but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + Â  Â MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Â See the
> >> + Â  Â GNU General Public License for more details.
> >> +
> >> + Â  Â You should have received a copy of the GNU General Public License
> >> + Â  Â along with this program; if not, write to the Free Software
> >> + Â  Â Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >> + */
> >> +
> >> +#ifndef TS2020_H
> >> +#define TS2020_H
> >> +
> >> +#include <linux/dvb/frontend.h>
> >> +
> >> +struct ts2020_config {
> >> + Â  Â  u8 tuner_address;
> >> +};
> >> +
> >> +struct ts2020_state {
> >> + Â  Â  struct i2c_adapter *i2c;
> >> + Â  Â  const struct ts2020_config *config;
> >> + Â  Â  struct dvb_frontend *frontend;
> >> + Â  Â  int status;
> >> +};
> >> +
> >> +#if defined(CONFIG_DVB_TS2020) || \
> >> + Â  Â  (defined(CONFIG_DVB_TS2020_MODULE) && defined(MODULE))
> >> +
> >> +extern struct dvb_frontend *ts2020_attach(
> >> + Â  Â  struct dvb_frontend *fe,
> >> + Â  Â  const struct ts2020_config *config,
> >> + Â  Â  struct i2c_adapter *i2c);
> >> +
> >> +extern int ts2020_get_signal_strength(
> >> + Â  Â  struct dvb_frontend *fe,
> >> + Â  Â  u16 *strength);
> >> +#else
> >> +static inline struct dvb_frontend *ts2020_attach(
> >> + Â  Â  struct dvb_frontend *fe,
> >> + Â  Â  const struct ts2020_config *config,
> >> + Â  Â  struct i2c_adapter *i2c)
> >> +{
> >> + Â  Â  printk(KERN_WARNING "%s: driver disabled by Kconfig\n", 
__func__);
> >> + Â  Â  return NULL;
> >> +}
> >> +
> >> +static inline int ts2020_get_signal_strength(
> >> + Â  Â  struct dvb_frontend *fe,
> >> + Â  Â  u16 *strength)
> >> +{
> >> + Â  Â  printk(KERN_WARNING "%s: driver disabled by Kconfig\n", 
__func__);
> >> + Â  Â  return NULL;
> >> +}
> >> +#endif
> >> +
> >> +#endif /* TS2020_H */
> >> --- a/linux/drivers/media/dvb/frontends/ts2020_cfg.h Â 2012-05-07
> >> 01:36:59.836514279 +0300
> >> +++ b/linux/drivers/media/dvb/frontends/ts2020_cfg.h Â 2012-05-07
> >> 01:12:56.248532422 +0300
> >> @@ -0,0 +1,64 @@
> >> +/*
> >> + Â  Â Montage Technology TS2020 - Silicon Tuner driver
> >> + Â  Â Copyright (C) 2009-2012 Konstantin Dimitrov
> >> <kosio.dimitrov@gmail.com>
> >> +
> >> + Â  Â Copyright (C) 2009-2012 TurboSight.com
> >> +
> >> + Â  Â This program is free software; you can redistribute it and/or 
modify
> >> + Â  Â it under the terms of the GNU General Public License as published 
by
> >> + Â  Â the Free Software Foundation; either version 2 of the License, or
> >> + Â  Â (at your option) any later version.
> >> +
> >> + Â  Â This program is distributed in the hope that it will be useful,
> >> + Â  Â but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + Â  Â MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Â See the
> >> + Â  Â GNU General Public License for more details.
> >> +
> >> + Â  Â You should have received a copy of the GNU General Public License
> >> + Â  Â along with this program; if not, write to the Free Software
> >> + Â  Â Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >> + */
> >> +
> >> +static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> >> +{
> >> + Â  Â  struct dvb_frontend_ops *frontend_ops = NULL;
> >> + Â  Â  struct dvb_tuner_ops *tuner_ops = NULL;
> >> + Â  Â  struct tuner_state t_state;
> >> + Â  Â  int ret = 0;
> >> +
> >> + Â  Â  if (&fe->ops)
> >> + Â  Â  Â  Â  Â  Â  frontend_ops = &fe->ops;
> >> + Â  Â  if (&frontend_ops->tuner_ops)
> >> + Â  Â  Â  Â  Â  Â  tuner_ops = &frontend_ops->tuner_ops;
> >> + Â  Â  if (tuner_ops->get_state) {
> >> + Â  Â  Â  Â  Â  Â  ret = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY,
> >> &t_state); + Â  Â  Â  Â  Â  Â  if (ret < 0) {
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  printk(KERN_ERR "%s: Invalid 
parameter\n",
> >> __func__);
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return ret;
> >> + Â  Â  Â  Â  Â  Â  }
> >> + Â  Â  Â  Â  Â  Â  *frequency = t_state.frequency;
> >> + Â  Â  }
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_set_frequency(struct dvb_frontend *fe, u32 frequency)
> >> +{
> >> + Â  Â  struct dvb_frontend_ops *frontend_ops = NULL;
> >> + Â  Â  struct dvb_tuner_ops *tuner_ops = NULL;
> >> + Â  Â  struct tuner_state t_state;
> >> + Â  Â  int ret = 0;
> >> +
> >> + Â  Â  t_state.frequency = frequency;
> >> + Â  Â  if (&fe->ops)
> >> + Â  Â  Â  Â  Â  Â  frontend_ops = &fe->ops;
> >> + Â  Â  if (&frontend_ops->tuner_ops)
> >> + Â  Â  Â  Â  Â  Â  tuner_ops = &frontend_ops->tuner_ops;
> >> + Â  Â  if (tuner_ops->set_state) {
> >> + Â  Â  Â  Â  Â  Â  ret = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY,
> >> &t_state); + Â  Â  Â  Â  Â  Â  if (ret < 0) {
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  printk(KERN_ERR "%s: Invalid 
parameter\n",
> >> __func__);
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return ret;
> >> + Â  Â  Â  Â  Â  Â  }
> >> + Â  Â  }
> >> + Â  Â  return 0;
> >> +}
> >> --- a/linux/drivers/media/dvb/frontends/ts2020.c Â  Â  Â 2012-05-07
> >> 01:36:51.428514382 +0300
> >> +++ b/linux/drivers/media/dvb/frontends/ts2020.c Â  Â  Â 2012-05-07
> >> 01:27:55.832521116 +0300
> >> @@ -0,0 +1,369 @@
> >> +/*
> >> + Â  Â Montage Technology TS2020 - Silicon Tuner driver
> >> + Â  Â Copyright (C) 2009-2012 Konstantin Dimitrov
> >> <kosio.dimitrov@gmail.com>
> >> +
> >> + Â  Â Copyright (C) 2009-2012 TurboSight.com
> >> +
> >> + Â  Â This program is free software; you can redistribute it and/or 
modify
> >> + Â  Â it under the terms of the GNU General Public License as published 
by
> >> + Â  Â the Free Software Foundation; either version 2 of the License, or
> >> + Â  Â (at your option) any later version.
> >> +
> >> + Â  Â This program is distributed in the hope that it will be useful,
> >> + Â  Â but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + Â  Â MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Â See the
> >> + Â  Â GNU General Public License for more details.
> >> +
> >> + Â  Â You should have received a copy of the GNU General Public License
> >> + Â  Â along with this program; if not, write to the Free Software
> >> + Â  Â Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >> + */
> >> +
> >> +#include "dvb_frontend.h"
> >> +#include "ts2020.h"
> >> +
> >> +#define TS2020_XTAL_FREQ Â  27000 /* in kHz */
> >> +
> >> +static int ts2020_readreg(struct dvb_frontend *fe, u8 reg)
> >> +{
> >> + Â  Â  struct ts2020_state *state = fe->tuner_priv;
> >> +
> >> + Â  Â  int ret;
> >> + Â  Â  u8 b0[] = { reg };
> >> + Â  Â  u8 b1[] = { 0 };
> >> + Â  Â  struct i2c_msg msg[] = {
> >> + Â  Â  Â  Â  Â  Â  {
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .addr = state->config->tuner_address,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .flags = 0,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .buf = b0,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .len = 1
> >> + Â  Â  Â  Â  Â  Â  }, {
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .addr = state->config->tuner_address,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .flags = I2C_M_RD,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .buf = b1,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  .len = 1
> >> + Â  Â  Â  Â  Â  Â  }
> >> + Â  Â  };
> >> +
> >> + Â  Â  if (fe->ops.i2c_gate_ctrl)
> >> + Â  Â  Â  Â  Â  Â  fe->ops.i2c_gate_ctrl(fe, 1);
> >> +
> >> + Â  Â  ret = i2c_transfer(state->i2c, msg, 2);
> >> +
> >> + Â  Â  if (fe->ops.i2c_gate_ctrl)
> >> + Â  Â  Â  Â  Â  Â  fe->ops.i2c_gate_ctrl(fe, 0);
> >> +
> >> + Â  Â  if (ret != 2) {
> >> + Â  Â  Â  Â  Â  Â  printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, 
reg,
> >> ret); + Â  Â  Â  Â  Â  Â  return ret;
> >> + Â  Â  }
> >> +
> >> + Â  Â  return b1[0];
> >> +}
> >> +
> >> +static int ts2020_writereg(struct dvb_frontend *fe, int reg, int data)
> >> +{
> >> + Â  Â  struct ts2020_state *state = fe->tuner_priv;
> >> +
> >> + Â  Â  u8 buf[] = { reg, data };
> >> + Â  Â  struct i2c_msg msg = { .addr = state->config->tuner_address,
> >> + Â  Â  Â  Â  Â  Â  .flags = 0, .buf = buf, .len = 2 };
> >> + Â  Â  int err;
> >> +
> >> +
> >> + Â  Â  if (fe->ops.i2c_gate_ctrl)
> >> + Â  Â  Â  Â  Â  Â  fe->ops.i2c_gate_ctrl(fe, 1);
> >> +
> >> + Â  Â  err = i2c_transfer(state->i2c, &msg, 1);
> >> +
> >> + Â  Â  if (fe->ops.i2c_gate_ctrl)
> >> + Â  Â  Â  Â  Â  Â  fe->ops.i2c_gate_ctrl(fe, 0);
> >> +
> >> + Â  Â  if (err != 1) {
> >> + Â  Â  Â  Â  Â  Â  printk(KERN_ERR "%s: writereg error(err == %i, reg ==
> >> 0x%02x," + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â " value == 0x%02x)\n", 
__func__, err,
> >> reg, data); + Â  Â  Â  Â  Â  Â  return -EREMOTEIO;
> >> + Â  Â  }
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_get_status(struct dvb_frontend *fe, u32 *status)
> >> +{
> >> + Â  Â  return TUNER_STATUS_LOCKED;
> >> +}
> >> +
> >> +static int ts2020_init(struct dvb_frontend *fe)
> >> +{
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> >> +{
> >> + Â  Â  u16 ndiv, div4;
> >> +
> >> + Â  Â  div4 = (ts2020_readreg(fe, 0x10) & 0x10) >> 4;
> >> +
> >> + Â  Â  ndiv = ts2020_readreg(fe, 0x01);
> >> + Â  Â  ndiv &= 0x0f;
> >> + Â  Â  ndiv <<= 8;
> >> + Â  Â  ndiv |= ts2020_readreg(fe, 0x02);
> >> +
> >> + Â  Â  /* actual tuned frequency, i.e. including the offset */
> >> + Â  Â  *frequency = (ndiv - ndiv % 2 + 1024) * TS2020_XTAL_FREQ
> >> + Â  Â  Â  Â  Â  Â  / (6 + 8) / (div4 + 1) / 2;
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_set_frequency(struct dvb_frontend *fe, u32 frequency)
> >> +{
> >> + Â  Â  struct ts2020_state *state = fe->tuner_priv;
> >> + Â  Â  struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> >> +
> >> + Â  Â  u8 mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
> >> + Â  Â  u16 value, ndiv;
> >> + Â  Â  u32 srate = 0, f3db;
> >> +
> >> + Â  Â  if (state->status == 0) {
> >> + Â  Â  Â  Â  Â  Â  /* TS2020 init */
> >> + Â  Â  Â  Â  Â  Â  ts2020_writereg(fe, 0x42, 0x73);
> >> + Â  Â  Â  Â  Â  Â  ts2020_writereg(fe, 0x05, 0x01);
> >> + Â  Â  Â  Â  Â  Â  ts2020_writereg(fe, 0x62, 0xf5);
> >> +
> >> + Â  Â  Â  Â  Â  Â  state->status = 1;
> >> + Â  Â  }
> >> +
> >> + Â  Â  /* unknown */
> >> + Â  Â  ts2020_writereg(fe, 0x07, 0x02);
> >> + Â  Â  ts2020_writereg(fe, 0x10, 0x00);
> >> + Â  Â  ts2020_writereg(fe, 0x60, 0x79);
> >> + Â  Â  ts2020_writereg(fe, 0x08, 0x01);
> >> + Â  Â  ts2020_writereg(fe, 0x00, 0x01);
> >> + Â  Â  div4 = 0;
> >> +
> >> + Â  Â  /* calculate and set freq divider */
> >> + Â  Â  if (frequency < 1146000) {
> >> + Â  Â  Â  Â  Â  Â  ts2020_writereg(fe, 0x10, 0x11);
> >> + Â  Â  Â  Â  Â  Â  div4 = 1;
> >> + Â  Â  Â  Â  Â  Â  ndiv = ((frequency * (6 + 8) * 4) +
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (TS2020_XTAL_FREQ / 2)) /
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  TS2020_XTAL_FREQ - 1024;
> >> + Â  Â  } else {
> >> + Â  Â  Â  Â  Â  Â  ts2020_writereg(fe, 0x10, 0x01);
> >> + Â  Â  Â  Â  Â  Â  ndiv = ((frequency * (6 + 8) * 2) +
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (TS2020_XTAL_FREQ / 2)) /
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  TS2020_XTAL_FREQ - 1024;
> >> + Â  Â  }
> >> +
> >> + Â  Â  ts2020_writereg(fe, 0x01, (ndiv & 0x0f00) >> 8);
> >> + Â  Â  ts2020_writereg(fe, 0x02, ndiv & 0x00ff);
> >> +
> >> + Â  Â  /* set pll */
> >> + Â  Â  ts2020_writereg(fe, 0x03, 0x06);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x0f);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x10);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> + Â  Â  msleep(5);
> >> +
> >> + Â  Â  /* unknown */
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x17);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x08);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> + Â  Â  msleep(5);
> >> +
> >> + Â  Â  value = ts2020_readreg(fe, 0x3d);
> >> + Â  Â  value &= 0x0f;
> >> + Â  Â  if ((value > 4) && (value < 15)) {
> >> + Â  Â  Â  Â  Â  Â  value -= 3;
> >> + Â  Â  Â  Â  Â  Â  if (value < 4)
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  value = 4;
> >> + Â  Â  Â  Â  Â  Â  value = ((value << 3) | 0x01) & 0x79;
> >> + Â  Â  }
> >> +
> >> + Â  Â  ts2020_writereg(fe, 0x60, value);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x17);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x08);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> +
> >> + Â  Â  /* set low-pass filter period */
> >> + Â  Â  ts2020_writereg(fe, 0x04, 0x2e);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1b);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x04);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> + Â  Â  msleep(5);
> >> +
> >> + Â  Â  /* get current symbol rate */
> >> + Â  Â  if (fe->ops.get_frontend)
> >> + Â  Â  Â  Â  Â  Â  fe->ops.get_frontend(fe);
> >> + Â  Â  srate = p->symbol_rate / 1000;
> >> +
> >> + Â  Â  f3db = (srate << 2) / 5 + 2000;
> >> + Â  Â  if (srate < 5000)
> >> + Â  Â  Â  Â  Â  Â  f3db += 3000;
> >> + Â  Â  if (f3db < 7000)
> >> + Â  Â  Â  Â  Â  Â  f3db = 7000;
> >> + Â  Â  if (f3db > 40000)
> >> + Â  Â  Â  Â  Â  Â  f3db = 40000;
> >> +
> >> + Â  Â  /* set low-pass filter baseband */
> >> + Â  Â  value = ts2020_readreg(fe, 0x26);
> >> + Â  Â  mlpf = 0x2e * 207 / ((value << 1) + 151);
> >> + Â  Â  mlpf_max = mlpf * 135 / 100;
> >> + Â  Â  mlpf_min = mlpf * 78 / 100;
> >> + Â  Â  if (mlpf_max > 63)
> >> + Â  Â  Â  Â  Â  Â  mlpf_max = 63;
> >> +
> >> + Â  Â  /* rounded to the closest integer */
> >> + Â  Â  nlpf = ((mlpf * f3db * 1000) + (2766 * TS2020_XTAL_FREQ / 2))
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  / (2766 * TS2020_XTAL_FREQ);
> >> + Â  Â  if (nlpf > 23)
> >> + Â  Â  Â  Â  Â  Â  nlpf = 23;
> >> + Â  Â  if (nlpf < 1)
> >> + Â  Â  Â  Â  Â  Â  nlpf = 1;
> >> +
> >> + Â  Â  /* rounded to the closest integer */
> >> + Â  Â  mlpf_new = ((TS2020_XTAL_FREQ * nlpf * 2766) +
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (1000 * f3db / 2)) / (1000 * f3db);
> >> +
> >> + Â  Â  if (mlpf_new < mlpf_min) {
> >> + Â  Â  Â  Â  Â  Â  nlpf++;
> >> + Â  Â  Â  Â  Â  Â  mlpf_new = ((TS2020_XTAL_FREQ * nlpf * 2766) +
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (1000 * f3db / 2)) / (1000 * 
f3db);
> >> + Â  Â  }
> >> +
> >> + Â  Â  if (mlpf_new > mlpf_max)
> >> + Â  Â  Â  Â  Â  Â  mlpf_new = mlpf_max;
> >> +
> >> + Â  Â  ts2020_writereg(fe, 0x04, mlpf_new);
> >> + Â  Â  ts2020_writereg(fe, 0x06, nlpf);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1b);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x04);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> + Â  Â  msleep(5);
> >> +
> >> + Â  Â  /* unknown */
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1e);
> >> + Â  Â  ts2020_writereg(fe, 0x51, 0x1f);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x01);
> >> + Â  Â  ts2020_writereg(fe, 0x50, 0x00);
> >> + Â  Â  msleep(60);
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_sleep(struct dvb_frontend *fe)
> >> +{
> >> + Â  Â  /* TODO: power down */
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_release(struct dvb_frontend *fe)
> >> +{
> >> + Â  Â  struct ts2020_state *state = fe->tuner_priv;
> >> +
> >> + Â  Â  fe->tuner_priv = NULL;
> >> + Â  Â  kfree(state);
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_get_state(struct dvb_frontend *fe,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  enum tuner_param param, struct 
tuner_state *state)
> >> +{
> >> + Â  Â  switch (param) {
> >> + Â  Â  case DVBFE_TUNER_FREQUENCY:
> >> + Â  Â  Â  Â  Â  Â  ts2020_get_frequency(fe, &state->frequency);
> >> + Â  Â  Â  Â  Â  Â  break;
> >> + Â  Â  default:
> >> + Â  Â  Â  Â  Â  Â  break;
> >> + Â  Â  }
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static int ts2020_set_state(struct dvb_frontend *fe,
> >> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  enum tuner_param param, struct 
tuner_state *state)
> >> +{
> >> + Â  Â  switch (param) {
> >> + Â  Â  case DVBFE_TUNER_FREQUENCY:
> >> + Â  Â  Â  Â  Â  Â  ts2020_set_frequency(fe, state->frequency);
> >> + Â  Â  Â  Â  Â  Â  break;
> >> + Â  Â  default:
> >> + Â  Â  Â  Â  Â  Â  return -EINVAL;
> >> + Â  Â  Â  Â  Â  Â  break;
> >> + Â  Â  }
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +
> >> +static struct dvb_tuner_ops ts2020_ops = {
> >> + Â  Â  .info = {
> >> + Â  Â  Â  Â  Â  Â  .name = "Montage Technology TS2020 Silicon Tuner",
> >> + Â  Â  Â  Â  Â  Â  .frequency_min = 950000,
> >> + Â  Â  Â  Â  Â  Â  .frequency_max = 2150000,
> >> + Â  Â  Â  Â  Â  Â  .frequency_step = 0,
> >> + Â  Â  },
> >> +
> >> + Â  Â  .init = ts2020_init,
> >> + Â  Â  .sleep = ts2020_sleep,
> >> + Â  Â  .get_status = ts2020_get_status,
> >> + Â  Â  .get_state = ts2020_get_state,
> >> + Â  Â  .set_state = ts2020_set_state,
> > 
> > Why not to use set_frequency/get_frequency directly, without payload of
> > state structure and get_state/set_state and separate header file?
> > Truly, it is expansion of code for just simple operation.
> > I don't buy that stuff.
> 
> Igor, one of the main motivations behind splitting the ts2020 tuner
> code from the ds3000 demodulator driver code was that it turned out
> there is actually 3rd party tuner, which is at least confirmed to work
> both with Montage and ST Microelectronics DVB-S2 demodulators
> (reference design available) - that's why what you're asking is made
> in that way - to make it for sure be compatible with the way how
> drivers for ST Microelectronics DVB-S2 tuners and demodulators in the
> kernel are made since i have no hardware to test anything about them.
> so, i get your point, but it's just legacy situation, because of those
> other drivers. however, in my opinion too, your suggestion is the
> better way if there wasn't such legacy situation.
It is like virus, one frontend or tuner inserted here - all others must go by 
chain.
Konstantin, it is the same old stuff, don't get me wrong. The way of 
programming, nothing more. What we have here, it is for future which maybe 
never comes. Let's do things simple for ds3000/ts2020/rs2000, and make 
separate wrapper header for future designs if and when needed.

> 
> >> + Â  Â  .release = ts2020_release
> >> +};
> >> +
> >> +int ts2020_get_signal_strength(struct dvb_frontend *fe,
> >> + Â  Â  u16 *signal_strength)
> >> +{
> >> + Â  Â  u16 sig_reading, sig_strength;
> >> + Â  Â  u8 rfgain, bbgain;
> >> +
> >> + Â  Â  rfgain = ts2020_readreg(fe, 0x3d) & 0x1f;
> >> + Â  Â  bbgain = ts2020_readreg(fe, 0x21) & 0x1f;
> >> +
> >> + Â  Â  if (rfgain > 15)
> >> + Â  Â  Â  Â  Â  Â  rfgain = 15;
> >> + Â  Â  if (bbgain > 13)
> >> + Â  Â  Â  Â  Â  Â  bbgain = 13;
> >> +
> >> + Â  Â  sig_reading = rfgain * 2 + bbgain * 3;
> >> +
> >> + Â  Â  sig_strength = 40 + (64 - sig_reading) * 50 / 64 ;
> >> +
> >> + Â  Â  /* cook the value to be suitable for szap-s2 human readable 
output
> >> */
> >> + Â  Â  *signal_strength = sig_strength * 1000;
> >> +
> >> + Â  Â  return 0;
> >> +}
> >> +EXPORT_SYMBOL(ts2020_get_signal_strength);
> >> +
> >> +struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
> >> + Â  Â  const struct ts2020_config *config, struct i2c_adapter *i2c)
> >> +{
> >> + Â  Â  struct ts2020_state *state = NULL;
> >> +
> >> + Â  Â  /* allocate memory for the internal state */
> >> + Â  Â  state = kzalloc(sizeof(struct ts2020_state), GFP_KERNEL);
> >> + Â  Â  if (!state)
> >> + Â  Â  Â  Â  Â  Â  return NULL;
> >> +
> >> + Â  Â  /* setup the state */
> >> + Â  Â  state->config = config;
> >> + Â  Â  state->i2c = i2c;
> >> + Â  Â  state->frontend = fe;
> >> + Â  Â  fe->tuner_priv = state;
> >> + Â  Â  fe->ops.tuner_ops = ts2020_ops;
> >> +
> >> + Â  Â  return fe;
> >> +}
> >> +EXPORT_SYMBOL(ts2020_attach);
> >> +
> >> +MODULE_AUTHOR("Konstantin Dimitrov <kosio.dimitrov@gmail.com>");
> >> +MODULE_DESCRIPTION("Montage Technology TS2020 - Silicon tuner driver
> >> module"); +MODULE_LICENSE("GPL");
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at Â http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > Igor M. Liplianin
> > Microsoft Windows Free Zone - Linux used for all Computing Tasks
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
