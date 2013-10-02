Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45745 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3JBPZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 11:25:47 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so1173144pad.0
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 08:25:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGj5WxD=iPSjQ=faDe=CTM0PMnEBe81RLFCCO9JpB_LAROpFNw@mail.gmail.com>
References: <1374679132-30672-1-git-send-email-ljalvs@gmail.com>
	<51EFF4AF.1030206@iki.fi>
	<CAOcJUbxCCHbtOT4ePXQLYh2yUUFuhso=D4jk4_dKw4ctCpt2JA@mail.gmail.com>
	<CAGj5WxD=iPSjQ=faDe=CTM0PMnEBe81RLFCCO9JpB_LAROpFNw@mail.gmail.com>
Date: Wed, 2 Oct 2013 11:25:46 -0400
Message-ID: <CAOcJUbw0eRCT7VAjZyxEC3LegMkaaNS_JHod7HZjziqcHuOYdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cx24117[v4]: Add new dvb-frontend.
From: Michael Krufky <mkrufky@linuxtv.org>
To: Luis Alves <ljalvs@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 2, 2013 at 10:19 AM, Luis Alves <ljalvs@gmail.com> wrote:
> Hi Michael,
>
> A bit of background. The cx24117 is a dual tuner/demod and both share
> a single i2c bus.
> The way I found (at that time) to share the same i2c bus on 2
> different frontend instances was to create a mutex that will deal with
> concurrent i2c bus accesses when both FEs will try to issue a command
> to the demod.
>
> So I created a struct cx24117_priv that both frontends share (the
> mutex is in there among other shared variables) and how I pass a
> pointer to that struct to both instances of the cx24117 is through the
> attach function.
>
> When attaching the cx24117, this should happen:
> 1st attach call: the passed pointer is NULL so the attach function
> will know that it is the first demod being attached.
> 2nd attach call: the passed pointer is pointing to the first FE, so it
> will know that theres already a priv struct allocated and gets it.
>
> Personally I also don't like this solution, but it was the only way I
> found to do it from cx23885 module.
>
> I'll be glad to change the method if a better solution is provided.
>
> Thanks and Regards,
> Luis
>
>
>
> 2013/10/2 Michael Krufky <mkrufky@linuxtv.org>:
>> On Wed, Jul 24, 2013 at 11:37 AM, Antti Palosaari <crope@iki.fi> wrote:
>>> On 07/24/2013 06:18 PM, Luis Alves wrote:
>>>>
>>>> v4:
>>>> Patch order fixed.
>>>> Changed some msleep's to clear checkpatch warning.
>>>>
>>>>
>>>> Signed-off-by: Luis Alves <ljalvs@gmail.com>
>>>
>>>
>>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>>
>>>
>>>
>>>> ---
>>>>   drivers/media/dvb-frontends/Kconfig   |    7 +
>>>>   drivers/media/dvb-frontends/Makefile  |    1 +
>>>>   drivers/media/dvb-frontends/cx24117.c | 1621
>>>> +++++++++++++++++++++++++++++++++
>>>>   drivers/media/dvb-frontends/cx24117.h |   47 +
>>>>   4 files changed, 1676 insertions(+)
>>>>   create mode 100644 drivers/media/dvb-frontends/cx24117.c
>>>>   create mode 100644 drivers/media/dvb-frontends/cx24117.h
>>>>
>>>> diff --git a/drivers/media/dvb-frontends/Kconfig
>>>> b/drivers/media/dvb-frontends/Kconfig
>>>> index 0e2ec6f..bddbab4 100644
>>>> --- a/drivers/media/dvb-frontends/Kconfig
>>>> +++ b/drivers/media/dvb-frontends/Kconfig
>>>> @@ -200,6 +200,13 @@ config DVB_CX24116
>>>>         help
>>>>           A DVB-S/S2 tuner module. Say Y when you want to support this
>>>> frontend.
>>>>
>>>> +config DVB_CX24117
>>>> +       tristate "Conexant CX24117 based"
>>>> +       depends on DVB_CORE && I2C
>>>> +       default m if !MEDIA_SUBDRV_AUTOSELECT
>>>> +       help
>>>> +         A Dual DVB-S/S2 tuner module. Say Y when you want to support
>>>> this frontend.
>>>> +
>>>>   config DVB_SI21XX
>>>>         tristate "Silicon Labs SI21XX based"
>>>>         depends on DVB_CORE && I2C
>>>> diff --git a/drivers/media/dvb-frontends/Makefile
>>>> b/drivers/media/dvb-frontends/Makefile
>>>> index cebc0fa..f9cb43d 100644
>>>> --- a/drivers/media/dvb-frontends/Makefile
>>>> +++ b/drivers/media/dvb-frontends/Makefile
>>>> @@ -76,6 +76,7 @@ obj-$(CONFIG_DVB_ATBM8830) += atbm8830.o
>>>>   obj-$(CONFIG_DVB_DUMMY_FE) += dvb_dummy_fe.o
>>>>   obj-$(CONFIG_DVB_AF9013) += af9013.o
>>>>   obj-$(CONFIG_DVB_CX24116) += cx24116.o
>>>> +obj-$(CONFIG_DVB_CX24117) += cx24117.o
>>>>   obj-$(CONFIG_DVB_SI21XX) += si21xx.o
>>>>   obj-$(CONFIG_DVB_STV0288) += stv0288.o
>>>>   obj-$(CONFIG_DVB_STB6000) += stb6000.o
>>>> diff --git a/drivers/media/dvb-frontends/cx24117.c
>>>> b/drivers/media/dvb-frontends/cx24117.c
>>>> new file mode 100644
>>>> index 0000000..3b63913
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb-frontends/cx24117.c
>>>> @@ -0,0 +1,1621 @@
>>>> +/*
>>>> +    Conexant cx24117/cx24132 - Dual DVBS/S2 Satellite demod/tuner driver
>>>> +
>>>> +    Copyright (C) 2013 Luis Alves <ljalvs@gmail.com>
>>>> +       July, 6th 2013
>>>> +           First release based on cx24116 driver by:
>>>> +           Steven Toth and Georg Acher, Darron Broad, Igor Liplianin
>>>> +           Cards currently supported:
>>>> +               TBS6980 - Dual DVBS/S2 PCIe card
>>>> +               TBS6981 - Dual DVBS/S2 PCIe card
>>>> +
>>>> +    This program is free software; you can redistribute it and/or modify
>>>> +    it under the terms of the GNU General Public License as published by
>>>> +    the Free Software Foundation; either version 2 of the License, or
>>>> +    (at your option) any later version.
>>>> +
>>>> +    This program is distributed in the hope that it will be useful,
>>>> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +    GNU General Public License for more details.
>>>> +
>>>> +    You should have received a copy of the GNU General Public License
>>>> +    along with this program; if not, write to the Free Software
>>>> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>>> +*/
>>>> +
>>>> +#include <linux/slab.h>
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/moduleparam.h>
>>>> +#include <linux/init.h>
>>>> +#include <linux/firmware.h>
>>>> +
>>>> +#include "dvb_frontend.h"
>>>> +#include "cx24117.h"
>>>> +
>>>> +
>>>> +#define CX24117_DEFAULT_FIRMWARE "dvb-fe-cx24117.fw"
>>>> +#define CX24117_SEARCH_RANGE_KHZ 5000
>>>> +
>>>> +/* known registers */
>>>> +#define CX24117_REG_COMMAND      (0x00)      /* command buffer */
>>>> +#define CX24117_REG_EXECUTE      (0x1f)      /* execute command */
>>>> +
>>>> +#define CX24117_REG_FREQ3_0      (0x34)      /* frequency */
>>>> +#define CX24117_REG_FREQ2_0      (0x35)
>>>> +#define CX24117_REG_FREQ1_0      (0x36)
>>>> +#define CX24117_REG_STATE0       (0x39)
>>>> +#define CX24117_REG_SSTATUS0     (0x3a)      /* demod0 signal high /
>>>> status */
>>>> +#define CX24117_REG_SIGNAL0      (0x3b)
>>>> +#define CX24117_REG_FREQ5_0      (0x3c)      /* +-freq */
>>>> +#define CX24117_REG_FREQ6_0      (0x3d)
>>>> +#define CX24117_REG_SRATE2_0     (0x3e)      /* +- 1000 * srate */
>>>> +#define CX24117_REG_SRATE1_0     (0x3f)
>>>> +#define CX24117_REG_QUALITY2_0   (0x40)
>>>> +#define CX24117_REG_QUALITY1_0   (0x41)
>>>> +
>>>> +#define CX24117_REG_BER4_0       (0x47)
>>>> +#define CX24117_REG_BER3_0       (0x48)
>>>> +#define CX24117_REG_BER2_0       (0x49)
>>>> +#define CX24117_REG_BER1_0       (0x4a)
>>>> +#define CX24117_REG_DVBS_UCB2_0  (0x4b)
>>>> +#define CX24117_REG_DVBS_UCB1_0  (0x4c)
>>>> +#define CX24117_REG_DVBS2_UCB2_0 (0x50)
>>>> +#define CX24117_REG_DVBS2_UCB1_0 (0x51)
>>>> +#define CX24117_REG_QSTATUS0     (0x93)
>>>> +#define CX24117_REG_CLKDIV0      (0xe6)
>>>> +#define CX24117_REG_RATEDIV0     (0xf0)
>>>> +
>>>> +
>>>> +#define CX24117_REG_FREQ3_1      (0x55)      /* frequency */
>>>> +#define CX24117_REG_FREQ2_1      (0x56)
>>>> +#define CX24117_REG_FREQ1_1      (0x57)
>>>> +#define CX24117_REG_STATE1       (0x5a)
>>>> +#define CX24117_REG_SSTATUS1     (0x5b)      /* demod1 signal high /
>>>> status */
>>>> +#define CX24117_REG_SIGNAL1      (0x5c)
>>>> +#define CX24117_REG_FREQ5_1      (0x5d)      /* +- freq */
>>>> +#define CX24117_REG_FREQ4_1      (0x5e)
>>>> +#define CX24117_REG_SRATE2_1     (0x5f)
>>>> +#define CX24117_REG_SRATE1_1     (0x60)
>>>> +#define CX24117_REG_QUALITY2_1   (0x61)
>>>> +#define CX24117_REG_QUALITY1_1   (0x62)
>>>> +#define CX24117_REG_BER4_1       (0x68)
>>>> +#define CX24117_REG_BER3_1       (0x69)
>>>> +#define CX24117_REG_BER2_1       (0x6a)
>>>> +#define CX24117_REG_BER1_1       (0x6b)
>>>> +#define CX24117_REG_DVBS_UCB2_1  (0x6c)
>>>> +#define CX24117_REG_DVBS_UCB1_1  (0x6d)
>>>> +#define CX24117_REG_DVBS2_UCB2_1 (0x71)
>>>> +#define CX24117_REG_DVBS2_UCB1_1 (0x72)
>>>> +#define CX24117_REG_QSTATUS1     (0x9f)
>>>> +#define CX24117_REG_CLKDIV1      (0xe7)
>>>> +#define CX24117_REG_RATEDIV1     (0xf1)
>>>> +
>>>> +
>>>> +/* arg buffer size */
>>>> +#define CX24117_ARGLEN       (0x1e)
>>>> +
>>>> +/* rolloff */
>>>> +#define CX24117_ROLLOFF_020  (0x00)
>>>> +#define CX24117_ROLLOFF_025  (0x01)
>>>> +#define CX24117_ROLLOFF_035  (0x02)
>>>> +
>>>> +/* pilot bit */
>>>> +#define CX24117_PILOT_OFF    (0x00)
>>>> +#define CX24117_PILOT_ON     (0x40)
>>>> +#define CX24117_PILOT_AUTO   (0x80)
>>>> +
>>>> +/* signal status */
>>>> +#define CX24117_HAS_SIGNAL   (0x01)
>>>> +#define CX24117_HAS_CARRIER  (0x02)
>>>> +#define CX24117_HAS_VITERBI  (0x04)
>>>> +#define CX24117_HAS_SYNCLOCK (0x08)
>>>> +#define CX24117_STATUS_MASK  (0x0f)
>>>> +#define CX24117_SIGNAL_MASK  (0xc0)
>>>> +
>>>> +
>>>> +/* arg offset for DiSEqC */
>>>> +#define CX24117_DISEQC_DEMOD  (1)
>>>> +#define CX24117_DISEQC_BURST  (2)
>>>> +#define CX24117_DISEQC_ARG3_2 (3)   /* unknown value=2 */
>>>> +#define CX24117_DISEQC_ARG4_0 (4)   /* unknown value=0 */
>>>> +#define CX24117_DISEQC_ARG5_0 (5)   /* unknown value=0 */
>>>> +#define CX24117_DISEQC_MSGLEN (6)
>>>> +#define CX24117_DISEQC_MSGOFS (7)
>>>> +
>>>> +/* DiSEqC burst */
>>>> +#define CX24117_DISEQC_MINI_A (0)
>>>> +#define CX24117_DISEQC_MINI_B (1)
>>>> +
>>>> +
>>>> +#define CX24117_PNE    (0) /* 0 disabled / 2 enabled */
>>>> +#define CX24117_OCC    (1) /* 0 disabled / 1 enabled */
>>>> +
>>>> +
>>>> +enum cmds {
>>>> +       CMD_SET_VCO     = 0x10,
>>>> +       CMD_TUNEREQUEST = 0x11,
>>>> +       CMD_MPEGCONFIG  = 0x13,
>>>> +       CMD_TUNERINIT   = 0x14,
>>>> +       CMD_LNBSEND     = 0x21, /* Formerly CMD_SEND_DISEQC */
>>>> +       CMD_LNBDCLEVEL  = 0x22,
>>>> +       CMD_SET_TONE    = 0x23,
>>>> +       CMD_UPDFWVERS   = 0x35,
>>>> +       CMD_TUNERSLEEP  = 0x36,
>>>> +};
>>>> +
>>>> +/* The Demod/Tuner can't easily provide these, we cache them */
>>>> +struct cx24117_tuning {
>>>> +       u32 frequency;
>>>> +       u32 symbol_rate;
>>>> +       fe_spectral_inversion_t inversion;
>>>> +       fe_code_rate_t fec;
>>>> +
>>>> +       fe_delivery_system_t delsys;
>>>> +       fe_modulation_t modulation;
>>>> +       fe_pilot_t pilot;
>>>> +       fe_rolloff_t rolloff;
>>>> +
>>>> +       /* Demod values */
>>>> +       u8 fec_val;
>>>> +       u8 fec_mask;
>>>> +       u8 inversion_val;
>>>> +       u8 pilot_val;
>>>> +       u8 rolloff_val;
>>>> +};
>>>> +
>>>> +/* Basic commands that are sent to the firmware */
>>>> +struct cx24117_cmd {
>>>> +       u8 len;
>>>> +       u8 args[CX24117_ARGLEN];
>>>> +};
>>>> +
>>>> +/* common to both fe's */
>>>> +struct cx24117_priv {
>>>> +       u8 demod_address;
>>>> +       struct i2c_adapter *i2c;
>>>> +       u8 skip_fw_load;
>>>> +
>>>> +       struct mutex fe_lock;
>>>> +       atomic_t fe_nr;
>>>> +};
>>>> +
>>>> +/* one per each fe */
>>>> +struct cx24117_state {
>>>> +       struct cx24117_priv *priv;
>>>> +       struct dvb_frontend frontend;
>>>> +
>>>> +       struct cx24117_tuning dcur;
>>>> +       struct cx24117_tuning dnxt;
>>>> +       struct cx24117_cmd dsec_cmd;
>>>> +
>>>> +       int demod;
>>>> +};
>>>> +
>>>> +/* modfec (modulation and FEC) lookup table */
>>>> +/* Check cx24116.c for a detailed description of each field */
>>>> +static struct cx24117_modfec {
>>>> +       fe_delivery_system_t delivery_system;
>>>> +       fe_modulation_t modulation;
>>>> +       fe_code_rate_t fec;
>>>> +       u8 mask;        /* In DVBS mode this is used to autodetect */
>>>> +       u8 val;         /* Passed to the firmware to indicate mode
>>>> selection */
>>>> +} cx24117_modfec_modes[] = {
>>>> +       /* QPSK. For unknown rates we set hardware to auto detect 0xfe
>>>> 0x30 */
>>>> +
>>>> +       /*mod   fec       mask  val */
>>>> +       { SYS_DVBS, QPSK, FEC_NONE, 0xfe, 0x30 },
>>>> +       { SYS_DVBS, QPSK, FEC_1_2,  0x02, 0x2e }, /* 00000010 00101110 */
>>>> +       { SYS_DVBS, QPSK, FEC_2_3,  0x04, 0x2f }, /* 00000100 00101111 */
>>>> +       { SYS_DVBS, QPSK, FEC_3_4,  0x08, 0x30 }, /* 00001000 00110000 */
>>>> +       { SYS_DVBS, QPSK, FEC_4_5,  0xfe, 0x30 }, /* 000?0000 ?        */
>>>> +       { SYS_DVBS, QPSK, FEC_5_6,  0x20, 0x31 }, /* 00100000 00110001 */
>>>> +       { SYS_DVBS, QPSK, FEC_6_7,  0xfe, 0x30 }, /* 0?000000 ?        */
>>>> +       { SYS_DVBS, QPSK, FEC_7_8,  0x80, 0x32 }, /* 10000000 00110010 */
>>>> +       { SYS_DVBS, QPSK, FEC_8_9,  0xfe, 0x30 }, /* 0000000? ?        */
>>>> +       { SYS_DVBS, QPSK, FEC_AUTO, 0xfe, 0x30 },
>>>> +       /* NBC-QPSK */
>>>> +       { SYS_DVBS2, QPSK, FEC_NONE, 0x00, 0x00 },
>>>> +       { SYS_DVBS2, QPSK, FEC_1_2,  0x00, 0x04 },
>>>> +       { SYS_DVBS2, QPSK, FEC_3_5,  0x00, 0x05 },
>>>> +       { SYS_DVBS2, QPSK, FEC_2_3,  0x00, 0x06 },
>>>> +       { SYS_DVBS2, QPSK, FEC_3_4,  0x00, 0x07 },
>>>> +       { SYS_DVBS2, QPSK, FEC_4_5,  0x00, 0x08 },
>>>> +       { SYS_DVBS2, QPSK, FEC_5_6,  0x00, 0x09 },
>>>> +       { SYS_DVBS2, QPSK, FEC_8_9,  0x00, 0x0a },
>>>> +       { SYS_DVBS2, QPSK, FEC_9_10, 0x00, 0x0b },
>>>> +       { SYS_DVBS2, QPSK, FEC_AUTO, 0x00, 0x00 },
>>>> +       /* 8PSK */
>>>> +       { SYS_DVBS2, PSK_8, FEC_NONE, 0x00, 0x00 },
>>>> +       { SYS_DVBS2, PSK_8, FEC_3_5,  0x00, 0x0c },
>>>> +       { SYS_DVBS2, PSK_8, FEC_2_3,  0x00, 0x0d },
>>>> +       { SYS_DVBS2, PSK_8, FEC_3_4,  0x00, 0x0e },
>>>> +       { SYS_DVBS2, PSK_8, FEC_5_6,  0x00, 0x0f },
>>>> +       { SYS_DVBS2, PSK_8, FEC_8_9,  0x00, 0x10 },
>>>> +       { SYS_DVBS2, PSK_8, FEC_9_10, 0x00, 0x11 },
>>>> +       { SYS_DVBS2, PSK_8, FEC_AUTO, 0x00, 0x00 },
>>>> +       /*
>>>> +        * 'val' can be found in the FECSTATUS register when tuning.
>>>> +        * FECSTATUS will give the actual FEC in use if tuning was
>>>> successful.
>>>> +        */
>>>> +};
>>>> +
>>>> +
>>>> +static int cx24117_writereg(struct cx24117_state *state, u8 reg, u8 data)
>>>> +{
>>>> +       u8 buf[] = { reg, data };
>>>> +       struct i2c_msg msg = { .addr = state->priv->demod_address,
>>>> +               .flags = 0, .buf = buf, .len = 2 };
>>>> +       int ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +                       "%s() demod%d i2c wr @0x%02x=0x%02x\n",
>>>> +                       __func__, state->demod, reg, data);
>>>> +
>>>> +       ret = i2c_transfer(state->priv->i2c, &msg, 1);
>>>> +       if (ret < 0) {
>>>> +               dev_warn(&state->priv->i2c->dev,
>>>> +                       "%s: demod%d i2c wr err(%i) @0x%02x=0x%02x\n",
>>>> +                       KBUILD_MODNAME, state->demod, ret, reg, data);
>>>> +               return ret;
>>>> +       }
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_writecmd(struct cx24117_state *state,
>>>> +       struct cx24117_cmd *cmd)
>>>> +{
>>>> +       struct i2c_msg msg;
>>>> +       u8 buf[CX24117_ARGLEN+1];
>>>> +       int ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +                       "%s() demod%d i2c wr cmd len=%d\n",
>>>> +                       __func__, state->demod, cmd->len);
>>>> +
>>>> +       buf[0] = CX24117_REG_COMMAND;
>>>> +       memcpy(&buf[1], cmd->args, cmd->len);
>>>> +
>>>> +       msg.addr = state->priv->demod_address;
>>>> +       msg.flags = 0;
>>>> +       msg.len = cmd->len+1;
>>>> +       msg.buf = buf;
>>>> +       ret = i2c_transfer(state->priv->i2c, &msg, 1);
>>>> +       if (ret < 0) {
>>>> +               dev_warn(&state->priv->i2c->dev,
>>>> +                       "%s: demod%d i2c wr cmd err(%i) len=%d\n",
>>>> +                       KBUILD_MODNAME, state->demod, ret, cmd->len);
>>>> +               return ret;
>>>> +       }
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_readreg(struct cx24117_state *state, u8 reg)
>>>> +{
>>>> +       int ret;
>>>> +       u8 recv = 0;
>>>> +       struct i2c_msg msg[] = {
>>>> +               { .addr = state->priv->demod_address, .flags = 0,
>>>> +                       .buf = &reg, .len = 1 },
>>>> +               { .addr = state->priv->demod_address, .flags = I2C_M_RD,
>>>> +                       .buf = &recv, .len = 1 }
>>>> +       };
>>>> +
>>>> +       ret = i2c_transfer(state->priv->i2c, msg, 2);
>>>> +       if (ret < 0) {
>>>> +               dev_warn(&state->priv->i2c->dev,
>>>> +                       "%s: demod%d i2c rd err(%d) @0x%x\n",
>>>> +                       KBUILD_MODNAME, state->demod, ret, reg);
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d i2c rd
>>>> @0x%02x=0x%02x\n",
>>>> +               __func__, state->demod, reg, recv);
>>>> +
>>>> +       return recv;
>>>> +}
>>>> +
>>>> +static int cx24117_readregN(struct cx24117_state *state,
>>>> +       u8 reg, u8 *buf, int len)
>>>> +{
>>>> +       int ret;
>>>> +       struct i2c_msg msg[] = {
>>>> +               { .addr = state->priv->demod_address, .flags = 0,
>>>> +                       .buf = &reg, .len = 1 },
>>>> +               { .addr = state->priv->demod_address, .flags = I2C_M_RD,
>>>> +                       .buf = buf, .len = len }
>>>> +       };
>>>> +
>>>> +       ret = i2c_transfer(state->priv->i2c, msg, 2);
>>>> +       if (ret < 0) {
>>>> +               dev_warn(&state->priv->i2c->dev,
>>>> +                       "%s: demod%d i2c rd err(%d) @0x%x\n",
>>>> +                       KBUILD_MODNAME, state->demod, ret, reg);
>>>> +               return ret;
>>>> +       }
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_set_inversion(struct cx24117_state *state,
>>>> +       fe_spectral_inversion_t inversion)
>>>> +{
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
>>>> +               __func__, inversion, state->demod);
>>>> +
>>>> +       switch (inversion) {
>>>> +       case INVERSION_OFF:
>>>> +               state->dnxt.inversion_val = 0x00;
>>>> +               break;
>>>> +       case INVERSION_ON:
>>>> +               state->dnxt.inversion_val = 0x04;
>>>> +               break;
>>>> +       case INVERSION_AUTO:
>>>> +               state->dnxt.inversion_val = 0x0C;
>>>> +               break;
>>>> +       default:
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>> +       state->dnxt.inversion = inversion;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_lookup_fecmod(struct cx24117_state *state,
>>>> +       fe_delivery_system_t d, fe_modulation_t m, fe_code_rate_t f)
>>>> +{
>>>> +       int i, ret = -EINVAL;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s(demod(0x%02x,0x%02x) demod%d\n",
>>>> +               __func__, m, f, state->demod);
>>>> +
>>>> +       for (i = 0; i < ARRAY_SIZE(cx24117_modfec_modes); i++) {
>>>> +               if ((d == cx24117_modfec_modes[i].delivery_system) &&
>>>> +                       (m == cx24117_modfec_modes[i].modulation) &&
>>>> +                       (f == cx24117_modfec_modes[i].fec)) {
>>>> +                               ret = i;
>>>> +                               break;
>>>> +                       }
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int cx24117_set_fec(struct cx24117_state *state,
>>>> +       fe_delivery_system_t delsys, fe_modulation_t mod, fe_code_rate_t
>>>> fec)
>>>> +{
>>>> +       int ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s(0x%02x,0x%02x) demod%d\n",
>>>> +               __func__, mod, fec, state->demod);
>>>> +
>>>> +       ret = cx24117_lookup_fecmod(state, delsys, mod, fec);
>>>> +       if (ret < 0)
>>>> +               return ret;
>>>> +
>>>> +       state->dnxt.fec = fec;
>>>> +       state->dnxt.fec_val = cx24117_modfec_modes[ret].val;
>>>> +       state->dnxt.fec_mask = cx24117_modfec_modes[ret].mask;
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s() demod%d mask/val = 0x%02x/0x%02x\n", __func__,
>>>> +               state->demod, state->dnxt.fec_mask, state->dnxt.fec_val);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_set_symbolrate(struct cx24117_state *state, u32 rate)
>>>> +{
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
>>>> +               __func__, rate, state->demod);
>>>> +
>>>> +       state->dnxt.symbol_rate = rate;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s() demod%d symbol_rate = %d\n",
>>>> +               __func__, state->demod, rate);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_load_firmware(struct dvb_frontend *fe,
>>>> +       const struct firmware *fw);
>>>> +
>>>> +static int cx24117_firmware_ondemand(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       const struct firmware *fw;
>>>> +       int ret = 0;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d skip_fw_load=%d\n",
>>>> +               __func__, state->demod, state->priv->skip_fw_load);
>>>> +
>>>> +       if (state->priv->skip_fw_load)
>>>> +               return 0;
>>>> +
>>>> +       /* check if firmware if already running */
>>>> +       if (cx24117_readreg(state, 0xeb) != 0xa) {
>>>> +               /* Load firmware */
>>>> +               /* request the firmware, this will block until loaded */
>>>> +               dev_dbg(&state->priv->i2c->dev,
>>>> +                       "%s: Waiting for firmware upload (%s)...\n",
>>>> +                       __func__, CX24117_DEFAULT_FIRMWARE);
>>>> +               ret = request_firmware(&fw, CX24117_DEFAULT_FIRMWARE,
>>>> +                       state->priv->i2c->dev.parent);
>>>> +               dev_dbg(&state->priv->i2c->dev,
>>>> +                       "%s: Waiting for firmware upload(2)...\n",
>>>> __func__);
>>>> +               if (ret) {
>>>> +                       dev_err(&state->priv->i2c->dev,
>>>> +                               "%s: No firmware uploaded "
>>>> +                               "(timeout or file not found?)\n",
>>>> __func__);
>>>> +                       return ret;
>>>> +               }
>>>> +
>>>> +               /* Make sure we don't recurse back through here
>>>> +                * during loading */
>>>> +               state->priv->skip_fw_load = 1;
>>>> +
>>>> +               ret = cx24117_load_firmware(fe, fw);
>>>> +               if (ret)
>>>> +                       dev_err(&state->priv->i2c->dev,
>>>> +                               "%s: Writing firmware failed\n",
>>>> __func__);
>>>> +               release_firmware(fw);
>>>> +
>>>> +               dev_info(&state->priv->i2c->dev,
>>>> +                       "%s: Firmware upload %s\n", __func__,
>>>> +                       ret == 0 ? "complete" : "failed");
>>>> +
>>>> +               /* Ensure firmware is always loaded if required */
>>>> +               state->priv->skip_fw_load = 0;
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +/* Take a basic firmware command structure, format it
>>>> + * and forward it for processing
>>>> + */
>>>> +static int cx24117_cmd_execute_nolock(struct dvb_frontend *fe,
>>>> +       struct cx24117_cmd *cmd)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int i, ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
>>>> +               __func__, state->demod);
>>>> +
>>>> +       /* Load the firmware if required */
>>>> +       ret = cx24117_firmware_ondemand(fe);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* Write the command */
>>>> +       cx24117_writecmd(state, cmd);
>>>> +
>>>> +       /* Start execution and wait for cmd to terminate */
>>>> +       cx24117_writereg(state, CX24117_REG_EXECUTE, 0x01);
>>>> +       i = 0;
>>>> +       while (cx24117_readreg(state, CX24117_REG_EXECUTE)) {
>>>> +               msleep(20);
>>>> +               if (i++ > 40) {
>>>> +                       /* Avoid looping forever if the firmware does
>>>> +                               not respond */
>>>> +                       dev_warn(&state->priv->i2c->dev,
>>>> +                               "%s() Firmware not responding\n",
>>>> __func__);
>>>> +                       return -EIO;
>>>> +               }
>>>> +       }
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_cmd_execute(struct dvb_frontend *fe, struct
>>>> cx24117_cmd *cmd)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int ret;
>>>> +
>>>> +       mutex_lock(&state->priv->fe_lock);
>>>> +       ret = cx24117_cmd_execute_nolock(fe, cmd);
>>>> +       mutex_unlock(&state->priv->fe_lock);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int cx24117_load_firmware(struct dvb_frontend *fe,
>>>> +       const struct firmware *fw)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +       int i, ret;
>>>> +       unsigned char vers[4];
>>>> +
>>>> +       struct i2c_msg msg;
>>>> +       u8 *buf;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s() demod%d FW is %zu bytes (%02x %02x .. %02x %02x)\n",
>>>> +               __func__, state->demod, fw->size, fw->data[0],
>>>> fw->data[1],
>>>> +               fw->data[fw->size-2], fw->data[fw->size-1]);
>>>> +
>>>> +       cx24117_writereg(state, 0xea, 0x00);
>>>> +       cx24117_writereg(state, 0xea, 0x01);
>>>> +       cx24117_writereg(state, 0xea, 0x00);
>>>> +
>>>> +       cx24117_writereg(state, 0xce, 0x92);
>>>> +
>>>> +       cx24117_writereg(state, 0xfb, 0x00);
>>>> +       cx24117_writereg(state, 0xfc, 0x00);
>>>> +
>>>> +       cx24117_writereg(state, 0xc3, 0x04);
>>>> +       cx24117_writereg(state, 0xc4, 0x04);
>>>> +
>>>> +       cx24117_writereg(state, 0xce, 0x00);
>>>> +       cx24117_writereg(state, 0xcf, 0x00);
>>>> +
>>>> +       cx24117_writereg(state, 0xea, 0x00);
>>>> +       cx24117_writereg(state, 0xeb, 0x0c);
>>>> +       cx24117_writereg(state, 0xec, 0x06);
>>>> +       cx24117_writereg(state, 0xed, 0x05);
>>>> +       cx24117_writereg(state, 0xee, 0x03);
>>>> +       cx24117_writereg(state, 0xef, 0x05);
>>>> +
>>>> +       cx24117_writereg(state, 0xf3, 0x03);
>>>> +       cx24117_writereg(state, 0xf4, 0x44);
>>>> +
>>>> +       cx24117_writereg(state, CX24117_REG_RATEDIV0, 0x04);
>>>> +       cx24117_writereg(state, CX24117_REG_CLKDIV0, 0x02);
>>>> +
>>>> +       cx24117_writereg(state, CX24117_REG_RATEDIV1, 0x04);
>>>> +       cx24117_writereg(state, CX24117_REG_CLKDIV1, 0x02);
>>>> +
>>>> +       cx24117_writereg(state, 0xf2, 0x04);
>>>> +       cx24117_writereg(state, 0xe8, 0x02);
>>>> +       cx24117_writereg(state, 0xea, 0x01);
>>>> +       cx24117_writereg(state, 0xc8, 0x00);
>>>> +       cx24117_writereg(state, 0xc9, 0x00);
>>>> +       cx24117_writereg(state, 0xca, 0x00);
>>>> +       cx24117_writereg(state, 0xcb, 0x00);
>>>> +       cx24117_writereg(state, 0xcc, 0x00);
>>>> +       cx24117_writereg(state, 0xcd, 0x00);
>>>> +       cx24117_writereg(state, 0xe4, 0x03);
>>>> +       cx24117_writereg(state, 0xeb, 0x0a);
>>>> +
>>>> +       cx24117_writereg(state, 0xfb, 0x00);
>>>> +       cx24117_writereg(state, 0xe0, 0x76);
>>>> +       cx24117_writereg(state, 0xf7, 0x81);
>>>> +       cx24117_writereg(state, 0xf8, 0x00);
>>>> +       cx24117_writereg(state, 0xf9, 0x00);
>>>> +
>>>> +       buf = kmalloc(fw->size + 1, GFP_KERNEL);
>>>> +       if (buf == NULL) {
>>>> +               state->priv->skip_fw_load = 0;
>>>> +               return -ENOMEM;
>>>> +       }
>>>> +
>>>> +       /* fw upload reg */
>>>> +       buf[0] = 0xfa;
>>>> +       memcpy(&buf[1], fw->data, fw->size);
>>>> +
>>>> +       /* prepare i2c message to send */
>>>> +       msg.addr = state->priv->demod_address;
>>>> +       msg.flags = 0;
>>>> +       msg.len = fw->size + 1;
>>>> +       msg.buf = buf;
>>>> +
>>>> +       /* send fw */
>>>> +       ret = i2c_transfer(state->priv->i2c, &msg, 1);
>>>> +       if (ret < 0)
>>>> +               return ret;
>>>> +
>>>> +       kfree(buf);
>>>> +
>>>> +       cx24117_writereg(state, 0xf7, 0x0c);
>>>> +       cx24117_writereg(state, 0xe0, 0x00);
>>>> +
>>>> +       /* CMD 1B */
>>>> +       cmd.args[0] = 0x1b;
>>>> +       cmd.args[1] = 0x00;
>>>> +       cmd.args[2] = 0x01;
>>>> +       cmd.args[3] = 0x00;
>>>> +       cmd.len = 4;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               goto error;
>>>> +
>>>> +       /* CMD 10 */
>>>> +       cmd.args[0] = CMD_SET_VCO;
>>>> +       cmd.args[1] = 0x06;
>>>> +       cmd.args[2] = 0x2b;
>>>> +       cmd.args[3] = 0xd8;
>>>> +       cmd.args[4] = 0xa5;
>>>> +       cmd.args[5] = 0xee;
>>>> +       cmd.args[6] = 0x03;
>>>> +       cmd.args[7] = 0x9d;
>>>> +       cmd.args[8] = 0xfc;
>>>> +       cmd.args[9] = 0x06;
>>>> +       cmd.args[10] = 0x02;
>>>> +       cmd.args[11] = 0x9d;
>>>> +       cmd.args[12] = 0xfc;
>>>> +       cmd.len = 13;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               goto error;
>>>> +
>>>> +       /* CMD 15 */
>>>> +       cmd.args[0] = 0x15;
>>>> +       cmd.args[1] = 0x00;
>>>> +       cmd.args[2] = 0x01;
>>>> +       cmd.args[3] = 0x00;
>>>> +       cmd.args[4] = 0x00;
>>>> +       cmd.args[5] = 0x01;
>>>> +       cmd.args[6] = 0x01;
>>>> +       cmd.args[7] = 0x01;
>>>> +       cmd.args[8] = 0x00;
>>>> +       cmd.args[9] = 0x05;
>>>> +       cmd.args[10] = 0x02;
>>>> +       cmd.args[11] = 0x02;
>>>> +       cmd.args[12] = 0x00;
>>>> +       cmd.len = 13;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               goto error;
>>>> +
>>>> +       /* CMD 13 */
>>>> +       cmd.args[0] = CMD_MPEGCONFIG;
>>>> +       cmd.args[1] = 0x00;
>>>> +       cmd.args[2] = 0x00;
>>>> +       cmd.args[3] = 0x00;
>>>> +       cmd.args[4] = 0x01;
>>>> +       cmd.args[5] = 0x00;
>>>> +       cmd.len = 6;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               goto error;
>>>> +
>>>> +       /* CMD 14 */
>>>> +       for (i = 0; i < 2; i++) {
>>>> +               cmd.args[0] = CMD_TUNERINIT;
>>>> +               cmd.args[1] = (u8) i;
>>>> +               cmd.args[2] = 0x00;
>>>> +               cmd.args[3] = 0x05;
>>>> +               cmd.args[4] = 0x00;
>>>> +               cmd.args[5] = 0x00;
>>>> +               cmd.args[6] = 0x55;
>>>> +               cmd.args[7] = 0x00;
>>>> +               cmd.len = 8;
>>>> +               ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +               if (ret != 0)
>>>> +                       goto error;
>>>> +       }
>>>> +
>>>> +       cx24117_writereg(state, 0xce, 0xc0);
>>>> +       cx24117_writereg(state, 0xcf, 0x00);
>>>> +       cx24117_writereg(state, 0xe5, 0x04);
>>>> +
>>>> +       /* Firmware CMD 35: Get firmware version */
>>>> +       cmd.args[0] = CMD_UPDFWVERS;
>>>> +       cmd.len = 2;
>>>> +       for (i = 0; i < 4; i++) {
>>>> +               cmd.args[1] = i;
>>>> +               ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +               if (ret != 0)
>>>> +                       goto error;
>>>> +               vers[i] = cx24117_readreg(state, 0x33);
>>>> +       }
>>>> +       dev_info(&state->priv->i2c->dev,
>>>> +               "%s: FW version %i.%i.%i.%i\n", __func__,
>>>> +               vers[0], vers[1], vers[2], vers[3]);
>>>> +       return 0;
>>>> +error:
>>>> +       state->priv->skip_fw_load = 0;
>>>> +       dev_err(&state->priv->i2c->dev, "%s() Error running FW.\n",
>>>> __func__);
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int cx24117_read_status(struct dvb_frontend *fe, fe_status_t
>>>> *status)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int lock;
>>>> +
>>>> +       lock = cx24117_readreg(state,
>>>> +               (state->demod == 0) ? CX24117_REG_SSTATUS0 :
>>>> +                                     CX24117_REG_SSTATUS1) &
>>>> +               CX24117_STATUS_MASK;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d status = 0x%02x\n",
>>>> +               __func__, state->demod, lock);
>>>> +
>>>> +       *status = 0;
>>>> +
>>>> +       if (lock & CX24117_HAS_SIGNAL)
>>>> +               *status |= FE_HAS_SIGNAL;
>>>> +       if (lock & CX24117_HAS_CARRIER)
>>>> +               *status |= FE_HAS_CARRIER;
>>>> +       if (lock & CX24117_HAS_VITERBI)
>>>> +               *status |= FE_HAS_VITERBI;
>>>> +       if (lock & CX24117_HAS_SYNCLOCK)
>>>> +               *status |= FE_HAS_SYNC | FE_HAS_LOCK;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_read_ber(struct dvb_frontend *fe, u32 *ber)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int ret;
>>>> +       u8 buf[4];
>>>> +       u8 base_reg = (state->demod == 0) ?
>>>> +                       CX24117_REG_BER4_0 :
>>>> +                       CX24117_REG_BER4_1;
>>>> +
>>>> +       ret = cx24117_readregN(state, base_reg, buf, 4);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       *ber = (buf[0] << 24) | (buf[1] << 16) |
>>>> +               (buf[1] << 8) | buf[0];
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d ber=0x%04x\n",
>>>> +               __func__, state->demod, *ber);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_read_signal_strength(struct dvb_frontend *fe,
>>>> +       u16 *signal_strength)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +       int ret;
>>>> +       u16 sig_reading;
>>>> +       u8 buf[2];
>>>> +       u8 reg = (state->demod == 0) ?
>>>> +               CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1;
>>>> +
>>>> +       /* Firmware CMD 1A */
>>>> +       cmd.args[0] = 0x1a;
>>>> +       cmd.args[1] = (u8) state->demod;
>>>> +       cmd.len = 2;
>>>> +       ret = cx24117_cmd_execute(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       ret = cx24117_readregN(state, reg, buf, 2);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +       sig_reading = ((buf[0] & CX24117_SIGNAL_MASK) << 2) | buf[1];
>>>> +
>>>> +       *signal_strength = -100 * sig_reading + 94324;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s() demod%d raw / cooked = 0x%04x / 0x%04x\n",
>>>> +               __func__, state->demod, sig_reading, *signal_strength);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int cx24117_read_snr(struct dvb_frontend *fe, u16 *snr)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int ret;
>>>> +       u8 buf[2];
>>>> +       u8 reg = (state->demod == 0) ?
>>>> +               CX24117_REG_QUALITY2_0 : CX24117_REG_QUALITY2_1;
>>>> +
>>>> +       ret = cx24117_readregN(state, reg, buf, 2);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       *snr = (buf[0] << 8) | buf[1];
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s() demod%d snr = 0x%04x\n",
>>>> +               __func__, state->demod, *snr);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int cx24117_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       fe_delivery_system_t delsys =
>>>> fe->dtv_property_cache.delivery_system;
>>>> +       int ret;
>>>> +       u8 buf[2];
>>>> +       u8 reg = (state->demod == 0) ?
>>>> +               CX24117_REG_DVBS_UCB2_0 :
>>>> +               CX24117_REG_DVBS_UCB2_1;
>>>> +
>>>> +       switch (delsys) {
>>>> +       case SYS_DVBS:
>>>> +               break;
>>>> +       case SYS_DVBS2:
>>>> +               reg += (CX24117_REG_DVBS2_UCB2_0 -
>>>> CX24117_REG_DVBS_UCB2_0);
>>>> +               break;
>>>> +       default:
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>> +       ret = cx24117_readregN(state, reg, buf, 2);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +       *ucblocks = (buf[0] << 8) | buf[1];
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d ucb=0x%04x\n",
>>>> +               __func__, state->demod, *ucblocks);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/* Overwrite the current tuning params, we are about to tune */
>>>> +static void cx24117_clone_params(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       state->dcur = state->dnxt;
>>>> +}
>>>> +
>>>> +/* Wait for LNB */
>>>> +static int cx24117_wait_for_lnb(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int i;
>>>> +       u8 val, reg = (state->demod == 0) ? CX24117_REG_QSTATUS0 :
>>>> +                                           CX24117_REG_QSTATUS1;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d qstatus = 0x%02x\n",
>>>> +               __func__, state->demod, cx24117_readreg(state, reg));
>>>> +
>>>> +       /* Wait for up to 300 ms */
>>>> +       for (i = 0; i < 10; i++) {
>>>> +               val = cx24117_readreg(state, reg) & 0x01;
>>>> +               if (val != 0)
>>>> +                       return 0;
>>>> +               msleep(30);
>>>> +       }
>>>> +
>>>> +       dev_warn(&state->priv->i2c->dev, "%s: demod%d LNB not ready\n",
>>>> +               KBUILD_MODNAME, state->demod);
>>>> +
>>>> +       return -ETIMEDOUT; /* -EBUSY ? */
>>>> +}
>>>> +
>>>> +static int cx24117_set_voltage(struct dvb_frontend *fe,
>>>> +       fe_sec_voltage_t voltage)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +       int ret;
>>>> +       u8 reg = (state->demod == 0) ? 0x10 : 0x20;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d %s\n",
>>>> +               __func__, state->demod,
>>>> +               voltage == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
>>>> +               voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" :
>>>> +               "SEC_VOLTAGE_OFF");
>>>> +
>>>> +       /* CMD 32 */
>>>> +       cmd.args[0] = 0x32;
>>>> +       cmd.args[1] = reg;
>>>> +       cmd.args[2] = reg;
>>>> +       cmd.len = 3;
>>>> +       ret = cx24117_cmd_execute(fe, &cmd);
>>>> +       if (ret)
>>>> +               return ret;
>>>> +
>>>> +       if ((voltage == SEC_VOLTAGE_13) ||
>>>> +           (voltage == SEC_VOLTAGE_18)) {
>>>> +               /* CMD 33 */
>>>> +               cmd.args[0] = 0x33;
>>>> +               cmd.args[1] = reg;
>>>> +               cmd.args[2] = reg;
>>>> +               cmd.len = 3;
>>>> +               ret = cx24117_cmd_execute(fe, &cmd);
>>>> +               if (ret != 0)
>>>> +                       return ret;
>>>> +
>>>> +               ret = cx24117_wait_for_lnb(fe);
>>>> +               if (ret != 0)
>>>> +                       return ret;
>>>> +
>>>> +               /* Wait for voltage/min repeat delay */
>>>> +               msleep(100);
>>>> +
>>>> +               /* CMD 22 - CMD_LNBDCLEVEL */
>>>> +               cmd.args[0] = CMD_LNBDCLEVEL;
>>>> +               cmd.args[1] = state->demod ? 0 : 1;
>>>> +               cmd.args[2] = (voltage == SEC_VOLTAGE_18 ? 0x01 : 0x00);
>>>> +               cmd.len = 3;
>>>> +
>>>> +               /* Min delay time before DiSEqC send */
>>>> +               msleep(20);
>>>> +       } else {
>>>> +               cmd.args[0] = 0x33;
>>>> +               cmd.args[1] = 0x00;
>>>> +               cmd.args[2] = reg;
>>>> +               cmd.len = 3;
>>>> +       }
>>>> +
>>>> +       return cx24117_cmd_execute(fe, &cmd);
>>>> +}
>>>> +
>>>> +static int cx24117_set_tone(struct dvb_frontend *fe,
>>>> +       fe_sec_tone_mode_t tone)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +       int ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s(%d) demod%d\n",
>>>> +               __func__, state->demod, tone);
>>>> +       if ((tone != SEC_TONE_ON) && (tone != SEC_TONE_OFF)) {
>>>> +               dev_warn(&state->priv->i2c->dev, "%s: demod%d invalid
>>>> tone=%d\n",
>>>> +                       KBUILD_MODNAME, state->demod, tone);
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>> +       /* Wait for LNB ready */
>>>> +       ret = cx24117_wait_for_lnb(fe);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* Min delay time after DiSEqC send */
>>>> +       msleep(20);
>>>> +
>>>> +       /* Set the tone */
>>>> +       /* CMD 23 - CMD_SET_TONE */
>>>> +       cmd.args[0] = CMD_SET_TONE;
>>>> +       cmd.args[1] = (state->demod ? 0 : 1);
>>>> +       cmd.args[2] = 0x00;
>>>> +       cmd.args[3] = 0x00;
>>>> +       cmd.len = 5;
>>>> +       switch (tone) {
>>>> +       case SEC_TONE_ON:
>>>> +               cmd.args[4] = 0x01;
>>>> +               break;
>>>> +       case SEC_TONE_OFF:
>>>> +               cmd.args[4] = 0x00;
>>>> +               break;
>>>> +       }
>>>> +
>>>> +       msleep(20);
>>>> +
>>>> +       return cx24117_cmd_execute(fe, &cmd);
>>>> +}
>>>> +
>>>> +/* Initialise DiSEqC */
>>>> +static int cx24117_diseqc_init(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +
>>>> +       /* Prepare a DiSEqC command */
>>>> +       state->dsec_cmd.args[0] = CMD_LNBSEND;
>>>> +
>>>> +       /* demod */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_DEMOD] = state->demod ? 0 : 1;
>>>> +
>>>> +       /* DiSEqC burst */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_BURST] =
>>>> CX24117_DISEQC_MINI_A;
>>>> +
>>>> +       /* Unknown */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_ARG3_2] = 0x02;
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_ARG4_0] = 0x00;
>>>> +
>>>> +       /* Continuation flag? */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_ARG5_0] = 0x00;
>>>> +
>>>> +       /* DiSEqC message length */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] = 0x00;
>>>> +
>>>> +       /* Command length */
>>>> +       state->dsec_cmd.len = 7;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/* Send DiSEqC message */
>>>> +static int cx24117_send_diseqc_msg(struct dvb_frontend *fe,
>>>> +       struct dvb_diseqc_master_cmd *d)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       int i, ret;
>>>> +
>>>> +       /* Dump DiSEqC message */
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s: demod %d (",
>>>> +               __func__, state->demod);
>>>> +       for (i = 0; i < d->msg_len; i++)
>>>> +               dev_dbg(&state->priv->i2c->dev, "0x%02x ", d->msg[i]);
>>>> +       dev_dbg(&state->priv->i2c->dev, ")\n");
>>>> +
>>>> +       /* Validate length */
>>>> +       if (d->msg_len > 15)
>>>> +               return -EINVAL;
>>>> +
>>>> +       /* DiSEqC message */
>>>> +       for (i = 0; i < d->msg_len; i++)
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_MSGOFS + i] =
>>>> d->msg[i];
>>>> +
>>>> +       /* DiSEqC message length */
>>>> +       state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] = d->msg_len;
>>>> +
>>>> +       /* Command length */
>>>> +       state->dsec_cmd.len = CX24117_DISEQC_MSGOFS +
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_MSGLEN];
>>>> +
>>>> +       /*
>>>> +        * Message is sent with derived else cached burst
>>>> +        *
>>>> +        * WRITE PORT GROUP COMMAND 38
>>>> +        *
>>>> +        * 0/A/A: E0 10 38 F0..F3
>>>> +        * 1/B/B: E0 10 38 F4..F7
>>>> +        * 2/C/A: E0 10 38 F8..FB
>>>> +        * 3/D/B: E0 10 38 FC..FF
>>>> +        *
>>>> +        * databyte[3]= 8421:8421
>>>> +        *              ABCD:WXYZ
>>>> +        *              CLR :SET
>>>> +        *
>>>> +        *              WX= PORT SELECT 0..3    (X=TONEBURST)
>>>> +        *              Y = VOLTAGE             (0=13V, 1=18V)
>>>> +        *              Z = BAND                (0=LOW, 1=HIGH(22K))
>>>> +        */
>>>> +       if (d->msg_len >= 4 && d->msg[2] == 0x38)
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_BURST] =
>>>> +                       ((d->msg[3] & 4) >> 2);
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d burst=%d\n",
>>>> +               __func__, state->demod,
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_BURST]);
>>>> +
>>>> +       /* Wait for LNB ready */
>>>> +       ret = cx24117_wait_for_lnb(fe);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* Wait for voltage/min repeat delay */
>>>> +       msleep(100);
>>>> +
>>>> +       /* Command */
>>>> +       ret = cx24117_cmd_execute(fe, &state->dsec_cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +       /*
>>>> +        * Wait for send
>>>> +        *
>>>> +        * Eutelsat spec:
>>>> +        * >15ms delay          + (XXX determine if FW does this, see
>>>> set_tone)
>>>> +        *  13.5ms per byte     +
>>>> +        * >15ms delay          +
>>>> +        *  12.5ms burst        +
>>>> +        * >15ms delay            (XXX determine if FW does this, see
>>>> set_tone)
>>>> +        */
>>>> +       msleep((state->dsec_cmd.args[CX24117_DISEQC_MSGLEN] << 4) + 60);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/* Send DiSEqC burst */
>>>> +static int cx24117_diseqc_send_burst(struct dvb_frontend *fe,
>>>> +       fe_sec_mini_cmd_t burst)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s(%d) demod=%d\n",
>>>> +               __func__, burst, state->demod);
>>>> +
>>>> +       /* DiSEqC burst */
>>>> +       if (burst == SEC_MINI_A)
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_BURST] =
>>>> +                       CX24117_DISEQC_MINI_A;
>>>> +       else if (burst == SEC_MINI_B)
>>>> +               state->dsec_cmd.args[CX24117_DISEQC_BURST] =
>>>> +                       CX24117_DISEQC_MINI_B;
>>>> +       else
>>>> +               return -EINVAL;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static void cx24117_release(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s demod%d\n",
>>>> +               __func__, state->demod);
>>>> +       if (!atomic_dec_and_test(&state->priv->fe_nr))
>>>> +               kfree(state->priv);
>>>> +       kfree(state);
>>>> +}
>>>> +
>>>> +static struct dvb_frontend_ops cx24117_ops;
>>>> +
>>>> +struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
>>>> +       struct i2c_adapter *i2c, struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = NULL;
>>>> +       struct cx24117_priv *priv = NULL;
>>>> +       int demod = 0;
>>>> +
>>>> +       /* first frontend attaching */
>>>> +       /* allocate shared priv struct */
>>>> +       if (fe == NULL) {
>>>> +               priv = kzalloc(sizeof(struct cx24117_priv), GFP_KERNEL);
>>>> +               if (priv == NULL)
>>>> +                       goto error1;
>>>> +               priv->i2c = i2c;
>>>> +               priv->demod_address = config->demod_address;
>>>> +               mutex_init(&priv->fe_lock);
>>>> +       } else {
>>>> +               demod = 1;
>>>> +               priv = ((struct cx24117_state *)
>>>> fe->demodulator_priv)->priv;
>>>> +       }
>>>> +
>>>> +       /* allocate memory for the internal state */
>>>> +       state = kzalloc(sizeof(struct cx24117_state), GFP_KERNEL);
>>>> +       if (state == NULL)
>>>> +               goto error2;
>>>> +
>>>> +       state->demod = demod;
>>>> +       state->priv = priv;
>>>> +
>>>> +       /* test i2c bus for ack */
>>>> +       if (demod == 0) {
>>>> +               if (cx24117_readreg(state, 0x00) < 0)
>>>> +                       goto error3;
>>>> +       }
>>>> +
>>>> +       /* nr of frontends using the module */
>>>> +       atomic_inc(&priv->fe_nr);
>>>> +
>>>> +       dev_info(&state->priv->i2c->dev,
>>>> +               "%s: Attaching frontend %d\n",
>>>> +               KBUILD_MODNAME, demod);
>>>> +
>>>> +       /* create dvb_frontend */
>>>> +       memcpy(&state->frontend.ops, &cx24117_ops,
>>>> +               sizeof(struct dvb_frontend_ops));
>>>> +       state->frontend.demodulator_priv = state;
>>>> +       return &state->frontend;
>>>> +
>>>> +error3:
>>>> +       kfree(state);
>>>> +error2:
>>>> +       kfree(priv);
>>>> +error1:
>>>> +       return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(cx24117_attach);
>>>> +
>>>> +/*
>>>> + * Initialise or wake up device
>>>> + *
>>>> + * Power config will reset and load initial firmware if required
>>>> + */
>>>> +static int cx24117_initfe(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +       int ret;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
>>>> +               __func__, state->demod);
>>>> +
>>>> +       mutex_lock(&state->priv->fe_lock);
>>>> +
>>>> +       /* Firmware CMD 36: Power config */
>>>> +       cmd.args[0] = CMD_TUNERSLEEP;
>>>> +       cmd.args[1] = (state->demod ? 1 : 0);
>>>> +       cmd.args[2] = 0;
>>>> +       cmd.len = 3;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       ret = cx24117_diseqc_init(fe);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* CMD 3C */
>>>> +       cmd.args[0] = 0x3c;
>>>> +       cmd.args[1] = (state->demod ? 1 : 0);
>>>> +       cmd.args[2] = 0x10;
>>>> +       cmd.args[3] = 0x10;
>>>> +       cmd.len = 4;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* CMD 34 */
>>>> +       cmd.args[0] = 0x34;
>>>> +       cmd.args[1] = (state->demod ? 1 : 0);
>>>> +       cmd.args[2] = CX24117_OCC;
>>>> +       cmd.len = 3;
>>>> +       ret = cx24117_cmd_execute_nolock(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       mutex_unlock(&state->priv->fe_lock);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Put device to sleep
>>>> + */
>>>> +static int cx24117_sleep(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct cx24117_cmd cmd;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
>>>> +               __func__, state->demod);
>>>> +
>>>> +       /* Firmware CMD 36: Power config */
>>>> +       cmd.args[0] = CMD_TUNERSLEEP;
>>>> +       cmd.args[1] = (state->demod ? 1 : 0);
>>>> +       cmd.args[2] = 1;
>>>> +       cmd.len = 3;
>>>> +       return cx24117_cmd_execute(fe, &cmd);
>>>> +}
>>>> +
>>>> +/* dvb-core told us to tune, the tv property cache will be complete,
>>>> + * it's safe for is to pull values and use them for tuning purposes.
>>>> + */
>>>> +static int cx24117_set_frontend(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>> +       struct cx24117_cmd cmd;
>>>> +       fe_status_t tunerstat;
>>>> +       int i, status, ret, retune = 1;
>>>> +       u8 reg_clkdiv, reg_ratediv;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
>>>> +               __func__, state->demod);
>>>> +
>>>> +       switch (c->delivery_system) {
>>>> +       case SYS_DVBS:
>>>> +               dev_dbg(&state->priv->i2c->dev, "%s() demod%d DVB-S\n",
>>>> +                       __func__, state->demod);
>>>> +
>>>> +               /* Only QPSK is supported for DVB-S */
>>>> +               if (c->modulation != QPSK) {
>>>> +                       dev_dbg(&state->priv->i2c->dev,
>>>> +                               "%s() demod%d unsupported modulation
>>>> (%d)\n",
>>>> +                               __func__, state->demod, c->modulation);
>>>> +                       return -EINVAL;
>>>> +               }
>>>> +
>>>> +               /* Pilot doesn't exist in DVB-S, turn bit off */
>>>> +               state->dnxt.pilot_val = CX24117_PILOT_OFF;
>>>> +
>>>> +               /* DVB-S only supports 0.35 */
>>>> +               state->dnxt.rolloff_val = CX24117_ROLLOFF_035;
>>>> +               break;
>>>> +
>>>> +       case SYS_DVBS2:
>>>> +               dev_dbg(&state->priv->i2c->dev, "%s() demod%d DVB-S2\n",
>>>> +                       __func__, state->demod);
>>>> +
>>>> +               /*
>>>> +                * NBC 8PSK/QPSK with DVB-S is supported for DVB-S2,
>>>> +                * but not hardware auto detection
>>>> +                */
>>>> +               if (c->modulation != PSK_8 && c->modulation != QPSK) {
>>>> +                       dev_dbg(&state->priv->i2c->dev,
>>>> +                               "%s() demod%d unsupported modulation
>>>> (%d)\n",
>>>> +                               __func__, state->demod, c->modulation);
>>>> +                       return -EOPNOTSUPP;
>>>> +               }
>>>> +
>>>> +               switch (c->pilot) {
>>>> +               case PILOT_AUTO:
>>>> +                       state->dnxt.pilot_val = CX24117_PILOT_AUTO;
>>>> +                       break;
>>>> +               case PILOT_OFF:
>>>> +                       state->dnxt.pilot_val = CX24117_PILOT_OFF;
>>>> +                       break;
>>>> +               case PILOT_ON:
>>>> +                       state->dnxt.pilot_val = CX24117_PILOT_ON;
>>>> +                       break;
>>>> +               default:
>>>> +                       dev_dbg(&state->priv->i2c->dev,
>>>> +                               "%s() demod%d unsupported pilot mode
>>>> (%d)\n",
>>>> +                               __func__, state->demod, c->pilot);
>>>> +                       return -EOPNOTSUPP;
>>>> +               }
>>>> +
>>>> +               switch (c->rolloff) {
>>>> +               case ROLLOFF_20:
>>>> +                       state->dnxt.rolloff_val = CX24117_ROLLOFF_020;
>>>> +                       break;
>>>> +               case ROLLOFF_25:
>>>> +                       state->dnxt.rolloff_val = CX24117_ROLLOFF_025;
>>>> +                       break;
>>>> +               case ROLLOFF_35:
>>>> +                       state->dnxt.rolloff_val = CX24117_ROLLOFF_035;
>>>> +                       break;
>>>> +               case ROLLOFF_AUTO:
>>>> +                       state->dnxt.rolloff_val = CX24117_ROLLOFF_035;
>>>> +                       /* soft-auto rolloff */
>>>> +                       retune = 3;
>>>> +                       break;
>>>> +               default:
>>>> +                       dev_warn(&state->priv->i2c->dev,
>>>> +                               "%s: demod%d unsupported rolloff (%d)\n",
>>>> +                               KBUILD_MODNAME, state->demod, c->rolloff);
>>>> +                       return -EOPNOTSUPP;
>>>> +               }
>>>> +               break;
>>>> +
>>>> +       default:
>>>> +               dev_warn(&state->priv->i2c->dev,
>>>> +                       "%s: demod %d unsupported delivery system (%d)\n",
>>>> +                       KBUILD_MODNAME, state->demod, c->delivery_system);
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>> +       state->dnxt.delsys = c->delivery_system;
>>>> +       state->dnxt.modulation = c->modulation;
>>>> +       state->dnxt.frequency = c->frequency;
>>>> +       state->dnxt.pilot = c->pilot;
>>>> +       state->dnxt.rolloff = c->rolloff;
>>>> +
>>>> +       ret = cx24117_set_inversion(state, c->inversion);
>>>> +       if (ret !=  0)
>>>> +               return ret;
>>>> +
>>>> +       ret = cx24117_set_fec(state,
>>>> +               c->delivery_system, c->modulation, c->fec_inner);
>>>> +       if (ret !=  0)
>>>> +               return ret;
>>>> +
>>>> +       ret = cx24117_set_symbolrate(state, c->symbol_rate);
>>>> +       if (ret !=  0)
>>>> +               return ret;
>>>> +
>>>> +       /* discard the 'current' tuning parameters and prepare to tune */
>>>> +       cx24117_clone_params(fe);
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: delsys      = %d\n", __func__, state->dcur.delsys);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: modulation  = %d\n", __func__,
>>>> state->dcur.modulation);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: frequency   = %d\n", __func__,
>>>> state->dcur.frequency);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: pilot       = %d (val = 0x%02x)\n", __func__,
>>>> +               state->dcur.pilot, state->dcur.pilot_val);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: retune      = %d\n", __func__, retune);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: rolloff     = %d (val = 0x%02x)\n", __func__,
>>>> +               state->dcur.rolloff, state->dcur.rolloff_val);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: symbol_rate = %d\n", __func__,
>>>> state->dcur.symbol_rate);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: FEC         = %d (mask/val = 0x%02x/0x%02x)\n",
>>>> __func__,
>>>> +               state->dcur.fec, state->dcur.fec_mask,
>>>> state->dcur.fec_val);
>>>> +       dev_dbg(&state->priv->i2c->dev,
>>>> +               "%s: Inversion   = %d (val = 0x%02x)\n", __func__,
>>>> +               state->dcur.inversion, state->dcur.inversion_val);
>>>> +
>>>> +       /* Prepare a tune request */
>>>> +       cmd.args[0] = CMD_TUNEREQUEST;
>>>> +
>>>> +       /* demod */
>>>> +       cmd.args[1] = state->demod;
>>>> +
>>>> +       /* Frequency */
>>>> +       cmd.args[2] = (state->dcur.frequency & 0xff0000) >> 16;
>>>> +       cmd.args[3] = (state->dcur.frequency & 0x00ff00) >> 8;
>>>> +       cmd.args[4] = (state->dcur.frequency & 0x0000ff);
>>>> +
>>>> +       /* Symbol Rate */
>>>> +       cmd.args[5] = ((state->dcur.symbol_rate / 1000) & 0xff00) >> 8;
>>>> +       cmd.args[6] = ((state->dcur.symbol_rate / 1000) & 0x00ff);
>>>> +
>>>> +       /* Automatic Inversion */
>>>> +       cmd.args[7] = state->dcur.inversion_val;
>>>> +
>>>> +       /* Modulation / FEC / Pilot */
>>>> +       cmd.args[8] = state->dcur.fec_val | state->dcur.pilot_val;
>>>> +
>>>> +       cmd.args[9] = CX24117_SEARCH_RANGE_KHZ >> 8;
>>>> +       cmd.args[10] = CX24117_SEARCH_RANGE_KHZ & 0xff;
>>>> +
>>>> +       cmd.args[11] = state->dcur.rolloff_val;
>>>> +       cmd.args[12] = state->dcur.fec_mask;
>>>> +
>>>> +       if (state->dcur.symbol_rate > 30000000) {
>>>> +               reg_ratediv = 0x04;
>>>> +               reg_clkdiv = 0x02;
>>>> +       } else if (state->dcur.symbol_rate > 10000000) {
>>>> +               reg_ratediv = 0x06;
>>>> +               reg_clkdiv = 0x03;
>>>> +       } else {
>>>> +               reg_ratediv = 0x0a;
>>>> +               reg_clkdiv = 0x05;
>>>> +       }
>>>> +
>>>> +       cmd.args[13] = reg_ratediv;
>>>> +       cmd.args[14] = reg_clkdiv;
>>>> +
>>>> +       cx24117_writereg(state, (state->demod == 0) ?
>>>> +               CX24117_REG_CLKDIV0 : CX24117_REG_CLKDIV1, reg_clkdiv);
>>>> +       cx24117_writereg(state, (state->demod == 0) ?
>>>> +               CX24117_REG_RATEDIV0 : CX24117_REG_RATEDIV1, reg_ratediv);
>>>> +
>>>> +       cmd.args[15] = CX24117_PNE;
>>>> +       cmd.len = 16;
>>>> +
>>>> +       do {
>>>> +               /* Reset status register */
>>>> +               status = cx24117_readreg(state, (state->demod == 0) ?
>>>> +                       CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1) &
>>>> +                       CX24117_SIGNAL_MASK;
>>>> +
>>>> +               dev_dbg(&state->priv->i2c->dev,
>>>> +                       "%s() demod%d status_setfe = %02x\n",
>>>> +                       __func__, state->demod, status);
>>>> +
>>>> +               cx24117_writereg(state, (state->demod == 0) ?
>>>> +                       CX24117_REG_SSTATUS0 : CX24117_REG_SSTATUS1,
>>>> status);
>>>> +
>>>> +               /* Tune */
>>>> +               ret = cx24117_cmd_execute(fe, &cmd);
>>>> +               if (ret != 0)
>>>> +                       break;
>>>> +
>>>> +               /*
>>>> +                * Wait for up to 500 ms before retrying
>>>> +                *
>>>> +                * If we are able to tune then generally it occurs within
>>>> 100ms.
>>>> +                * If it takes longer, try a different rolloff setting.
>>>> +                */
>>>> +               for (i = 0; i < 50; i++) {
>>>> +                       cx24117_read_status(fe, &tunerstat);
>>>> +                       status = tunerstat & (FE_HAS_SIGNAL |
>>>> FE_HAS_SYNC);
>>>> +                       if (status == (FE_HAS_SIGNAL | FE_HAS_SYNC)) {
>>>> +                               dev_dbg(&state->priv->i2c->dev,
>>>> +                                       "%s() demod%d tuned\n",
>>>> +                                       __func__, state->demod);
>>>> +                               return 0;
>>>> +                       }
>>>> +                       msleep(20);
>>>> +               }
>>>> +
>>>> +               dev_dbg(&state->priv->i2c->dev, "%s() demod%d not
>>>> tuned\n",
>>>> +                       __func__, state->demod);
>>>> +
>>>> +               /* try next rolloff value */
>>>> +               if (state->dcur.rolloff == 3)
>>>> +                       cmd.args[11]--;
>>>> +
>>>> +       } while (--retune);
>>>> +       return -EINVAL;
>>>> +}
>>>> +
>>>> +static int cx24117_tune(struct dvb_frontend *fe, bool re_tune,
>>>> +       unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +
>>>> +       dev_dbg(&state->priv->i2c->dev, "%s() demod%d\n",
>>>> +               __func__, state->demod);
>>>> +
>>>> +       *delay = HZ / 5;
>>>> +       if (re_tune) {
>>>> +               int ret = cx24117_set_frontend(fe);
>>>> +               if (ret)
>>>> +                       return ret;
>>>> +       }
>>>> +       return cx24117_read_status(fe, status);
>>>> +}
>>>> +
>>>> +static int cx24117_get_algo(struct dvb_frontend *fe)
>>>> +{
>>>> +       return DVBFE_ALGO_HW;
>>>> +}
>>>> +
>>>> +static int cx24117_get_frontend(struct dvb_frontend *fe)
>>>> +{
>>>> +       struct cx24117_state *state = fe->demodulator_priv;
>>>> +       struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>> +       struct cx24117_cmd cmd;
>>>> +       u8 reg, st, inv;
>>>> +       int ret, idx;
>>>> +       unsigned int freq;
>>>> +       short srate_os, freq_os;
>>>> +
>>>> +       u8 buf[0x1f-4];
>>>> +
>>>> +       cmd.args[0] = 0x1c;
>>>> +       cmd.args[1] = (u8) state->demod;
>>>> +       cmd.len = 2;
>>>> +       ret = cx24117_cmd_execute(fe, &cmd);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       /* read all required regs at once */
>>>> +       reg = (state->demod == 0) ? CX24117_REG_FREQ3_0 :
>>>> CX24117_REG_FREQ3_1;
>>>> +       ret = cx24117_readregN(state, reg, buf, 0x1f-4);
>>>> +       if (ret != 0)
>>>> +               return ret;
>>>> +
>>>> +       st = buf[5];
>>>> +
>>>> +       /* get spectral inversion */
>>>> +       inv = (((state->demod == 0) ? ~st : st) >> 6) & 1;
>>>> +       if (inv == 0)
>>>> +               c->inversion = INVERSION_OFF;
>>>> +       else
>>>> +               c->inversion = INVERSION_ON;
>>>> +
>>>> +       /* modulation and fec */
>>>> +       idx = st & 0x3f;
>>>> +       if (c->delivery_system == SYS_DVBS2) {
>>>> +               if (idx > 11)
>>>> +                       idx += 9;
>>>> +               else
>>>> +                       idx += 7;
>>>> +       }
>>>> +
>>>> +       c->modulation = cx24117_modfec_modes[idx].modulation;
>>>> +       c->fec_inner = cx24117_modfec_modes[idx].fec;
>>>> +
>>>> +       /* frequency */
>>>> +       freq = (buf[0] << 16) | (buf[1] << 8) | buf[2];
>>>> +       freq_os = (buf[8] << 8) | buf[9];
>>>> +       c->frequency = freq + freq_os;
>>>> +
>>>> +       /* symbol rate */
>>>> +       srate_os = (buf[10] << 8) | buf[11];
>>>> +       c->symbol_rate = -1000 * srate_os + state->dcur.symbol_rate;
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static struct dvb_frontend_ops cx24117_ops = {
>>>> +       .delsys = { SYS_DVBS, SYS_DVBS2 },
>>>> +       .info = {
>>>> +               .name = "Conexant CX24117/CX24132",
>>>> +               .frequency_min = 950000,
>>>> +               .frequency_max = 2150000,
>>>> +               .frequency_stepsize = 1011, /* kHz for QPSK frontends */
>>>> +               .frequency_tolerance = 5000,
>>>> +               .symbol_rate_min = 1000000,
>>>> +               .symbol_rate_max = 45000000,
>>>> +               .caps = FE_CAN_INVERSION_AUTO |
>>>> +                       FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
>>>> +                       FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>>>> +                       FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>>>> +                       FE_CAN_2G_MODULATION |
>>>> +                       FE_CAN_QPSK | FE_CAN_RECOVER
>>>> +       },
>>>> +
>>>> +       .release = cx24117_release,
>>>> +
>>>> +       .init = cx24117_initfe,
>>>> +       .sleep = cx24117_sleep,
>>>> +       .read_status = cx24117_read_status,
>>>> +       .read_ber = cx24117_read_ber,
>>>> +       .read_signal_strength = cx24117_read_signal_strength,
>>>> +       .read_snr = cx24117_read_snr,
>>>> +       .read_ucblocks = cx24117_read_ucblocks,
>>>> +       .set_tone = cx24117_set_tone,
>>>> +       .set_voltage = cx24117_set_voltage,
>>>> +       .diseqc_send_master_cmd = cx24117_send_diseqc_msg,
>>>> +       .diseqc_send_burst = cx24117_diseqc_send_burst,
>>>> +       .get_frontend_algo = cx24117_get_algo,
>>>> +       .tune = cx24117_tune,
>>>> +
>>>> +       .set_frontend = cx24117_set_frontend,
>>>> +       .get_frontend = cx24117_get_frontend,
>>>> +};
>>>> +
>>>> +
>>>> +MODULE_DESCRIPTION("DVB Frontend module for Conexant cx24117/cx24132
>>>> hardware");
>>>> +MODULE_AUTHOR("Luis Alves (ljalvs@gmail.com)");
>>>> +MODULE_LICENSE("GPL");
>>>> +MODULE_VERSION("1.1");
>>>> +MODULE_FIRMWARE(CX24117_DEFAULT_FIRMWARE);
>>>> +
>>>> diff --git a/drivers/media/dvb-frontends/cx24117.h
>>>> b/drivers/media/dvb-frontends/cx24117.h
>>>> new file mode 100644
>>>> index 0000000..5bc8f11
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb-frontends/cx24117.h
>>>> @@ -0,0 +1,47 @@
>>>> +/*
>>>> +    Conexant cx24117/cx24132 - Dual DVBS/S2 Satellite demod/tuner driver
>>>> +
>>>> +    Copyright (C) 2013 Luis Alves <ljalvs@gmail.com>
>>>> +       (based on cx24116.h by Steven Toth)
>>>> +
>>>> +    This program is free software; you can redistribute it and/or modify
>>>> +    it under the terms of the GNU General Public License as published by
>>>> +    the Free Software Foundation; either version 2 of the License, or
>>>> +    (at your option) any later version.
>>>> +
>>>> +    This program is distributed in the hope that it will be useful,
>>>> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +    GNU General Public License for more details.
>>>> +
>>>> +    You should have received a copy of the GNU General Public License
>>>> +    along with this program; if not, write to the Free Software
>>>> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>>> +*/
>>>> +
>>>> +#ifndef CX24117_H
>>>> +#define CX24117_H
>>>> +
>>>> +#include <linux/kconfig.h>
>>>> +#include <linux/dvb/frontend.h>
>>>> +
>>>> +struct cx24117_config {
>>>> +       /* the demodulator's i2c address */
>>>> +       u8 demod_address;
>>>> +};
>>>> +
>>>> +#if IS_ENABLED(CONFIG_DVB_CX24117)
>>>> +extern struct dvb_frontend *cx24117_attach(
>>>> +       const struct cx24117_config *config,
>>>> +       struct i2c_adapter *i2c, struct dvb_frontend *fe);
>>>> +#else
>>>> +static inline struct dvb_frontend *cx24117_attach(
>>>> +       const struct cx24117_config *config,
>>>> +       struct i2c_adapter *i2c, struct dvb_frontend *fe)
>>>> +{
>>>> +       dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
>>>> +       return NULL;
>>>> +}
>>>> +#endif
>>>> +
>>>> +#endif /* CX24117_H */
>>>>
>>>
>>>
>>> --
>>> http://palosaari.fi/
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> (Apologies if you may have received this twice - I'm not sure if the
>> first one went through)
>>
>> Luis,
>>
>> I have your patches queued in the 'cx24117' branch of my dvb.git tree:
>>
>> git://linuxtv.org/mkrufky/dvb cx24117
>>
>> It feels a bit strange to me that we are passing a struct dvb_frontend
>> * into cx24117_attach() ...  Looking at the code, my understanding is
>> that multiple cx24117's share some data between their driver
>> instances?  Could you explain a bit more about the need for doing
>> this?
>>
>> If you should decide to send in additional patches, please feel free
>> to send changes in against this cx24117 branch until we merge it into
>> master.
>>
>> Cheers,
>>
>> Mike Krufky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Luis,

OK, makes sense.  Please take a look at the
"hybrid_tuner_request_state()" api located in
drivers/media/tuners/tuner-i2c.h

For a good example of how to use this API in such a situation as a
demodulator, take a look at
drivers/media/dvb-frontends/au8522_common.c

Don't let the "hybrid_tuner_" prefix to the API prevent you from using
it to share state on a digital demodulator - it can definitely be used
for this purpose.

Again, don't regenerate the patchset - just send patches against the
cx24117 branch that I created.

Let me know if you have any questions.

Best regards,

Mike Krufky
