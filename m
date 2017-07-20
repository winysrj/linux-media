Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38389
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935106AbdGTRVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 13:21:35 -0400
Date: Thu, 20 Jul 2017 14:21:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at,
        rjkm@metzlerbros.de
Subject: Re: [PATCH v3 01/10] [media] dvb-frontends: add ST STV0910 DVB-S/S2
 demodulator frontend driver
Message-ID: <20170720142124.0363f432@vento.lan>
In-Reply-To: <20170703172104.27283-2-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
        <20170703172104.27283-2-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  3 Jul 2017 19:20:54 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> This adds a multi frontend driver for the ST STV0910 DVB-S/S2 demodulator
> frontends. The driver code originates from the Digital Devices' dddvb
> vendor driver package as of version 0.9.29, and has been cleaned up from
> core API usage which isn't supported yet in the kernel, and additionally
> all obvious style issues have been resolved. All camel case and allcaps
> have been converted to kernel_case and lowercase. Patches have been sent
> to the vendor package maintainers to fix this aswell. Signal statistics
> acquisition has been refactored to comply with standards.
> 
> Permission to reuse and mainline the driver code was formally granted by
> Ralph Metzler <rjkm@metzlerbros.de>.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> Tested-by: Richard Scobie <r.scobie@clear.net.nz>
> ---
>  drivers/media/dvb-frontends/Kconfig        |    9 +
>  drivers/media/dvb-frontends/Makefile       |    1 +
>  drivers/media/dvb-frontends/stv0910.c      | 1702 ++++++++++
>  drivers/media/dvb-frontends/stv0910.h      |   32 +
>  drivers/media/dvb-frontends/stv0910_regs.h | 4759 ++++++++++++++++++++++++++++
>  5 files changed, 6503 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/stv0910.c
>  create mode 100644 drivers/media/dvb-frontends/stv0910.h
>  create mode 100644 drivers/media/dvb-frontends/stv0910_regs.h
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 3a260b82b3e8..773de5e264e3 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -28,6 +28,15 @@ config DVB_STV090x
>  	  DVB-S/S2/DSS Multistandard Professional/Broadcast demodulators.
>  	  Say Y when you want to support these frontends.
>  
> +config DVB_STV0910
> +	tristate "STV0910 based"
> +	depends on DVB_CORE && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  ST STV0910 DVB-S/S2 demodulator driver.
> +
> +	  Say Y when you want to support these frontends.
> +
>  config DVB_STV6110x
>  	tristate "STV6110/(A) based tuners"
>  	depends on DVB_CORE && I2C
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index 3fccaf34ef52..c302b2d07499 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
>  obj-$(CONFIG_DVB_CXD2841ER) += cxd2841er.o
>  obj-$(CONFIG_DVB_DRXK) += drxk.o
>  obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
> +obj-$(CONFIG_DVB_STV0910) += stv0910.o
>  obj-$(CONFIG_DVB_SI2165) += si2165.o
>  obj-$(CONFIG_DVB_A8293) += a8293.o
>  obj-$(CONFIG_DVB_SP2) += sp2.o
> diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
> new file mode 100644
> index 000000000000..9dfcaf5e067f
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/stv0910.c
> @@ -0,0 +1,1702 @@
> +/*
> + * Driver for the ST STV0910 DVB-S/S2 demodulator.
> + *
> + * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
> + *                         Marcus Metzler <mocm@metzlerbros.de>
> + *                         developed for Digital Devices GmbH
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 only, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/i2c.h>
> +#include <asm/div64.h>
> +
> +#include "dvb_math.h"
> +#include "dvb_frontend.h"
> +#include "stv0910.h"
> +#include "stv0910_regs.h"
> +
> +#define EXT_CLOCK    30000000
> +#define TUNING_DELAY 200
> +#define BER_SRC_S    0x20
> +#define BER_SRC_S2   0x20
> +
> +LIST_HEAD(stvlist);
> +
> +enum receive_mode { RCVMODE_NONE, RCVMODE_DVBS, RCVMODE_DVBS2, RCVMODE_AUTO };
> +
> +enum dvbs2_fectype { DVBS2_64K, DVBS2_16K };
> +
> +enum dvbs2_mod_cod {
> +	DVBS2_DUMMY_PLF, DVBS2_QPSK_1_4, DVBS2_QPSK_1_3, DVBS2_QPSK_2_5,
> +	DVBS2_QPSK_1_2, DVBS2_QPSK_3_5, DVBS2_QPSK_2_3,	DVBS2_QPSK_3_4,
> +	DVBS2_QPSK_4_5,	DVBS2_QPSK_5_6,	DVBS2_QPSK_8_9,	DVBS2_QPSK_9_10,
> +	DVBS2_8PSK_3_5,	DVBS2_8PSK_2_3,	DVBS2_8PSK_3_4,	DVBS2_8PSK_5_6,
> +	DVBS2_8PSK_8_9,	DVBS2_8PSK_9_10, DVBS2_16APSK_2_3, DVBS2_16APSK_3_4,
> +	DVBS2_16APSK_4_5, DVBS2_16APSK_5_6, DVBS2_16APSK_8_9, DVBS2_16APSK_9_10,
> +	DVBS2_32APSK_3_4, DVBS2_32APSK_4_5, DVBS2_32APSK_5_6, DVBS2_32APSK_8_9,
> +	DVBS2_32APSK_9_10
> +};
> +
> +enum fe_stv0910_mod_cod {
> +	FE_DUMMY_PLF, FE_QPSK_14, FE_QPSK_13, FE_QPSK_25,
> +	FE_QPSK_12, FE_QPSK_35, FE_QPSK_23, FE_QPSK_34,
> +	FE_QPSK_45, FE_QPSK_56, FE_QPSK_89, FE_QPSK_910,
> +	FE_8PSK_35, FE_8PSK_23, FE_8PSK_34, FE_8PSK_56,
> +	FE_8PSK_89, FE_8PSK_910, FE_16APSK_23, FE_16APSK_34,
> +	FE_16APSK_45, FE_16APSK_56, FE_16APSK_89, FE_16APSK_910,
> +	FE_32APSK_34, FE_32APSK_45, FE_32APSK_56, FE_32APSK_89,
> +	FE_32APSK_910
> +};
> +
> +enum fe_stv0910_roll_off { FE_SAT_35, FE_SAT_25, FE_SAT_20, FE_SAT_15 };
> +
> +static inline u32 muldiv32(u32 a, u32 b, u32 c)
> +{
> +	u64 tmp64;
> +
> +	tmp64 = (u64)a * (u64)b;
> +	do_div(tmp64, c);
> +
> +	return (u32) tmp64;
> +}
> +
> +struct stv_base {
> +	struct list_head     stvlist;
> +
> +	u8                   adr;
> +	struct i2c_adapter  *i2c;
> +	struct mutex         i2c_lock;
> +	struct mutex         reg_lock;
> +	int                  count;
> +
> +	u32                  extclk;
> +	u32                  mclk;
> +};
> +
> +struct stv {
> +	struct stv_base     *base;
> +	struct dvb_frontend  fe;
> +	int                  nr;
> +	u16                  regoff;
> +	u8                   i2crpt;
> +	u8                   tscfgh;
> +	u8                   tsgeneral;
> +	u8                   tsspeed;
> +	u8                   single;
> +	unsigned long        tune_time;
> +
> +	s32                  search_range;
> +	u32                  started;
> +	u32                  demod_lock_time;
> +	enum receive_mode    receive_mode;
> +	u32                  demod_timeout;
> +	u32                  fec_timeout;
> +	u32                  first_time_lock;
> +	u8                   demod_bits;
> +	u32                  symbol_rate;
> +
> +	u8                       last_viterbi_rate;
> +	enum fe_code_rate        puncture_rate;
> +	enum fe_stv0910_mod_cod  mod_cod;
> +	enum dvbs2_fectype       fectype;
> +	u32                      pilots;
> +	enum fe_stv0910_roll_off feroll_off;
> +
> +	int   is_standard_broadcast;
> +	int   is_vcm;
> +
> +	u32   last_bernumerator;
> +	u32   last_berdenominator;
> +	u8    berscale;
> +
> +	u8    vth[6];
> +};
> +
> +struct sinit_table {
> +	u16  address;
> +	u8   data;
> +};
> +
> +struct slookup {
> +	s16  value;
> +	u16  reg_value;
> +};
> +
> +static inline int i2c_write(struct i2c_adapter *adap, u8 adr,
> +			    u8 *data, int len)
> +{
> +	struct i2c_msg msg = {.addr = adr, .flags = 0,
> +			      .buf = data, .len = len};
> +
> +	if (i2c_transfer(adap, &msg, 1) != 1) {
> +		dev_warn(&adap->dev, "i2c write error ([%02x] %04x: %02x)\n",
> +			adr, (data[0] << 8) | data[1],
> +			(len > 2 ? data[2] : 0));
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int i2c_write_reg16(struct i2c_adapter *adap, u8 adr, u16 reg, u8 val)
> +{
> +	u8 msg[3] = {reg >> 8, reg & 0xff, val};
> +
> +	return i2c_write(adap, adr, msg, 3);
> +}
> +
> +static int write_reg(struct stv *state, u16 reg, u8 val)
> +{
> +	return i2c_write_reg16(state->base->i2c, state->base->adr, reg, val);
> +}
> +
> +static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
> +				 u16 reg, u8 *val, int count)
> +{
> +	u8 msg[2] = {reg >> 8, reg & 0xff};
> +	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
> +				   .buf  = msg, .len   = 2},
> +				  {.addr = adr, .flags = I2C_M_RD,
> +				   .buf  = val, .len   = count } };
> +
> +	if (i2c_transfer(adapter, msgs, 2) != 2) {
> +		dev_warn(&adapter->dev, "i2c read error ([%02x] %04x)\n",
> +			adr, reg);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int read_reg(struct stv *state, u16 reg, u8 *val)
> +{
> +	return i2c_read_regs16(state->base->i2c, state->base->adr,
> +		reg, val, 1);
> +}
> +
> +static int read_regs(struct stv *state, u16 reg, u8 *val, int len)
> +{
> +	return i2c_read_regs16(state->base->i2c, state->base->adr,
> +			       reg, val, len);
> +}
> +
> +static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
> +{
> +	int status;
> +	u8 tmp;
> +
> +	mutex_lock(&state->base->reg_lock);
> +	status = read_reg(state, reg, &tmp);
> +	if (!status)
> +		status = write_reg(state, reg, (tmp & ~mask) | (val & mask));
> +	mutex_unlock(&state->base->reg_lock);
> +	return status;
> +}
> +
> +struct slookup s1_sn_lookup[] = {
> +	{   0,    9242  },  /*C/N=  0dB*/
> +	{   5,    9105  },  /*C/N=0.5dB*/
> +	{  10,    8950  },  /*C/N=1.0dB*/
> +	{  15,    8780  },  /*C/N=1.5dB*/
> +	{  20,    8566  },  /*C/N=2.0dB*/
> +	{  25,    8366  },  /*C/N=2.5dB*/
> +	{  30,    8146  },  /*C/N=3.0dB*/
> +	{  35,    7908  },  /*C/N=3.5dB*/
> +	{  40,    7666  },  /*C/N=4.0dB*/
> +	{  45,    7405  },  /*C/N=4.5dB*/
> +	{  50,    7136  },  /*C/N=5.0dB*/
> +	{  55,    6861  },  /*C/N=5.5dB*/
> +	{  60,    6576  },  /*C/N=6.0dB*/
> +	{  65,    6330  },  /*C/N=6.5dB*/
> +	{  70,    6048  },  /*C/N=7.0dB*/
> +	{  75,    5768  },  /*C/N=7.5dB*/
> +	{  80,    5492  },  /*C/N=8.0dB*/
> +	{  85,    5224  },  /*C/N=8.5dB*/
> +	{  90,    4959  },  /*C/N=9.0dB*/
> +	{  95,    4709  },  /*C/N=9.5dB*/
> +	{  100,   4467  },  /*C/N=10.0dB*/
> +	{  105,   4236  },  /*C/N=10.5dB*/
> +	{  110,   4013  },  /*C/N=11.0dB*/
> +	{  115,   3800  },  /*C/N=11.5dB*/
> +	{  120,   3598  },  /*C/N=12.0dB*/
> +	{  125,   3406  },  /*C/N=12.5dB*/
> +	{  130,   3225  },  /*C/N=13.0dB*/
> +	{  135,   3052  },  /*C/N=13.5dB*/
> +	{  140,   2889  },  /*C/N=14.0dB*/
> +	{  145,   2733  },  /*C/N=14.5dB*/
> +	{  150,   2587  },  /*C/N=15.0dB*/
> +	{  160,   2318  },  /*C/N=16.0dB*/
> +	{  170,   2077  },  /*C/N=17.0dB*/
> +	{  180,   1862  },  /*C/N=18.0dB*/
> +	{  190,   1670  },  /*C/N=19.0dB*/
> +	{  200,   1499  },  /*C/N=20.0dB*/
> +	{  210,   1347  },  /*C/N=21.0dB*/
> +	{  220,   1213  },  /*C/N=22.0dB*/
> +	{  230,   1095  },  /*C/N=23.0dB*/
> +	{  240,    992  },  /*C/N=24.0dB*/
> +	{  250,    900  },  /*C/N=25.0dB*/
> +	{  260,    826  },  /*C/N=26.0dB*/
> +	{  270,    758  },  /*C/N=27.0dB*/
> +	{  280,    702  },  /*C/N=28.0dB*/
> +	{  290,    653  },  /*C/N=29.0dB*/
> +	{  300,    613  },  /*C/N=30.0dB*/
> +	{  310,    579  },  /*C/N=31.0dB*/
> +	{  320,    550  },  /*C/N=32.0dB*/
> +	{  330,    526  },  /*C/N=33.0dB*/
> +	{  350,    490  },  /*C/N=33.0dB*/
> +	{  400,    445  },  /*C/N=40.0dB*/
> +	{  450,    430  },  /*C/N=45.0dB*/
> +	{  500,    426  },  /*C/N=50.0dB*/
> +	{  510,    425  }   /*C/N=51.0dB*/
> +};
> +
> +struct slookup s2_sn_lookup[] = {
> +	{  -30,  13950  },  /*C/N=-2.5dB*/
> +	{  -25,  13580  },  /*C/N=-2.5dB*/
> +	{  -20,  13150  },  /*C/N=-2.0dB*/
> +	{  -15,  12760  },  /*C/N=-1.5dB*/
> +	{  -10,  12345  },  /*C/N=-1.0dB*/
> +	{   -5,  11900  },  /*C/N=-0.5dB*/
> +	{    0,  11520  },  /*C/N=   0dB*/
> +	{    5,  11080  },  /*C/N= 0.5dB*/
> +	{   10,  10630  },  /*C/N= 1.0dB*/
> +	{   15,  10210  },  /*C/N= 1.5dB*/
> +	{   20,   9790  },  /*C/N= 2.0dB*/
> +	{   25,   9390  },  /*C/N= 2.5dB*/
> +	{   30,   8970  },  /*C/N= 3.0dB*/
> +	{   35,   8575  },  /*C/N= 3.5dB*/
> +	{   40,   8180  },  /*C/N= 4.0dB*/
> +	{   45,   7800  },  /*C/N= 4.5dB*/
> +	{   50,   7430  },  /*C/N= 5.0dB*/
> +	{   55,   7080  },  /*C/N= 5.5dB*/
> +	{   60,   6720  },  /*C/N= 6.0dB*/
> +	{   65,   6320  },  /*C/N= 6.5dB*/
> +	{   70,   6060  },  /*C/N= 7.0dB*/
> +	{   75,   5760  },  /*C/N= 7.5dB*/
> +	{   80,   5480  },  /*C/N= 8.0dB*/
> +	{   85,   5200  },  /*C/N= 8.5dB*/
> +	{   90,   4930  },  /*C/N= 9.0dB*/
> +	{   95,   4680  },  /*C/N= 9.5dB*/
> +	{  100,   4425  },  /*C/N=10.0dB*/
> +	{  105,   4210  },  /*C/N=10.5dB*/
> +	{  110,   3980  },  /*C/N=11.0dB*/
> +	{  115,   3765  },  /*C/N=11.5dB*/
> +	{  120,   3570  },  /*C/N=12.0dB*/
> +	{  125,   3315  },  /*C/N=12.5dB*/
> +	{  130,   3140  },  /*C/N=13.0dB*/
> +	{  135,   2980  },  /*C/N=13.5dB*/
> +	{  140,   2820  },  /*C/N=14.0dB*/
> +	{  145,   2670  },  /*C/N=14.5dB*/
> +	{  150,   2535  },  /*C/N=15.0dB*/
> +	{  160,   2270  },  /*C/N=16.0dB*/
> +	{  170,   2035  },  /*C/N=17.0dB*/
> +	{  180,   1825  },  /*C/N=18.0dB*/
> +	{  190,   1650  },  /*C/N=19.0dB*/
> +	{  200,   1485  },  /*C/N=20.0dB*/
> +	{  210,   1340  },  /*C/N=21.0dB*/
> +	{  220,   1212  },  /*C/N=22.0dB*/
> +	{  230,   1100  },  /*C/N=23.0dB*/
> +	{  240,   1000  },  /*C/N=24.0dB*/
> +	{  250,    910  },  /*C/N=25.0dB*/
> +	{  260,    836  },  /*C/N=26.0dB*/
> +	{  270,    772  },  /*C/N=27.0dB*/
> +	{  280,    718  },  /*C/N=28.0dB*/
> +	{  290,    671  },  /*C/N=29.0dB*/
> +	{  300,    635  },  /*C/N=30.0dB*/
> +	{  310,    602  },  /*C/N=31.0dB*/
> +	{  320,    575  },  /*C/N=32.0dB*/
> +	{  330,    550  },  /*C/N=33.0dB*/
> +	{  350,    517  },  /*C/N=35.0dB*/
> +	{  400,    480  },  /*C/N=40.0dB*/
> +	{  450,    466  },  /*C/N=45.0dB*/
> +	{  500,    464  },  /*C/N=50.0dB*/
> +	{  510,    463  },  /*C/N=51.0dB*/
> +};
> +
> +/*********************************************************************
> + * Tracking carrier loop carrier QPSK 1/4 to 8PSK 9/10 long Frame
> + *********************************************************************/
> +static u8 s2car_loop[] =	{
> +	/* Modcod  2MPon 2MPoff 5MPon 5MPoff 10MPon 10MPoff
> +	 * 20MPon 20MPoff 30MPon 30MPoff
> +	 */

The right coding style for multi-line comments is:

	/*
	 * foo
	 * bar
	 */

I ended by merging this series, but please send a fixup patch when
you have some time.

Btw, specially for new drivers, it could worth running checkpatch in
scritct mode:

$ git diff 435945e08551|./scripts/checkpatch.pl --terse --strict
-:36: WARNING: please write a paragraph that describes the config symbol fully
-:52: WARNING: please write a paragraph that describes the config symbol fully
-:78: WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
-:156: CHECK: No space is necessary after a cast
-:164: CHECK: struct mutex definition without comment
-:165: CHECK: struct mutex definition without comment
-:231: CHECK: Alignment should match open parenthesis
-:251: CHECK: Alignment should match open parenthesis
-:261: CHECK: Alignment should match open parenthesis
-:558: CHECK: No space is necessary after a cast
-:559: CHECK: No space is necessary after a cast
-:560: CHECK: No space is necessary after a cast
-:561: CHECK: No space is necessary after a cast
-:563: CHECK: spaces preferred around that '<<' (ctx:VxV)
-:566: CHECK: No space is necessary after a cast
-:567: CHECK: No space is necessary after a cast
-:583: CHECK: No space is necessary after a cast
-:585: CHECK: No space is necessary after a cast
-:671: CHECK: Alignment should match open parenthesis
-:680: CHECK: braces {} should be used on all arms of this statement
-:684: CHECK: Unbalanced braces around else statement
-:685: CHECK: spaces preferred around that '-' (ctx:VxV)
-:688: CHECK: Alignment should match open parenthesis
-:734: CHECK: No space is necessary after a cast
-:740: CHECK: Alignment should match open parenthesis
-:754: CHECK: No space is necessary after a cast
-:755: CHECK: No space is necessary after a cast
-:815: CHECK: Alignment should match open parenthesis
-:827: CHECK: No space is necessary after a cast
-:830: CHECK: No space is necessary after a cast
-:831: CHECK: No space is necessary after a cast
-:849: CHECK: Alignment should match open parenthesis
-:1296: CHECK: Please don't use multiple blank lines
-:1358: CHECK: Alignment should match open parenthesis
-:1360: CHECK: No space is necessary after a cast
-:1377: CHECK: braces {} should be used on all arms of this statement
-:1380: CHECK: Unbalanced braces around else statement
-:1414: CHECK: No space is necessary after a cast
-:1418: CHECK: No space is necessary after a cast
-:1419: CHECK: No space is necessary after a cast
-:1578: CHECK: braces {} should be used on all arms of this statement
-:1580: CHECK: Unbalanced braces around else statement
-:1672: CHECK: Please don't use multiple blank lines
-:1794: CHECK: Prefer kzalloc(sizeof(*state)...) over kzalloc(sizeof(struct stv)...)
-:1815: CHECK: Prefer kzalloc(sizeof(*base)...) over kzalloc(sizeof(struct stv_base)...)
-:1828: CHECK: Alignment should match open parenthesis
-:1839: CHECK: Alignment should match open parenthesis
-:1876: CHECK: extern prototypes should be avoided in .h files
-:3364: WARNING: 'VALIDE' may be misspelled - perhaps 'VALID'?
-:4927: WARNING: 'VALIDE' may be misspelled - perhaps 'VALID'?
-:6963: CHECK: No space is necessary after a cast
-:7094: CHECK: spaces preferred around that '-' (ctx:VxV)
-:7097: CHECK: spaces preferred around that '-' (ctx:VxV)
-:7207: CHECK: braces {} should be used on all arms of this statement
-:7211: CHECK: Unbalanced braces around else statement
-:7212: CHECK: spaces preferred around that '-' (ctx:VxV)
-:7223: CHECK: No space is necessary after a cast
-:7225: CHECK: spaces preferred around that '/' (ctx:VxV)
-:7252: CHECK: Alignment should match open parenthesis
-:7256: CHECK: Alignment should match open parenthesis
-:7266: CHECK: Alignment should match open parenthesis
-:7271: CHECK: Alignment should match open parenthesis
-:7312: CHECK: Prefer kzalloc(sizeof(*state)...) over kzalloc(sizeof(struct stv)...)
-:7348: CHECK: extern prototypes should be avoided in .h files
-:7349: CHECK: Alignment should match open parenthesis
-:7354: CHECK: Alignment should match open parenthesis
-:7439: CHECK: Alignment should match open parenthesis
-:7564: CHECK: Alignment should match open parenthesis
total: 0 errors, 5 warnings, 63 checks, 7552 lines checked

Several of those warnings can be automatically fixed with:

./scripts/checkpatch.pl -f $(git diff 435945e08551|diffstat -p1 -l|grep -v MAINT) --strict --fix-inplace

But you need to review if the results are ok.

Regards,
Mauro
