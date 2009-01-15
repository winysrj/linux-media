Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:41514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZAOBOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 20:14:12 -0500
Received: by fg-out-1718.google.com with SMTP id 19so434477fgg.17
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2009 17:14:10 -0800 (PST)
Message-ID: <208cbae30901141714h749086b3vc5e5ae243d81f88a@mail.gmail.com>
Date: Thu, 15 Jan 2009 04:14:10 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Jochen Friedrich" <jochen@scram.de>
Subject: Re: [PATCHv2] Add Freescale MC44S803 tuner driver
Cc: linux-media@vger.kernel.org, "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <496E2912.8030604@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496E2912.8030604@scram.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 14, 2009 at 9:04 PM, Jochen Friedrich <jochen@scram.de> wrote:
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>
> Changes since v1:
> - rebase against official linux tree. v1 was based against a local tree and didn't apply cleanly.
>
>
>  drivers/media/common/tuners/Kconfig         |    8 +
>  drivers/media/common/tuners/Makefile        |    1 +
>  drivers/media/common/tuners/mc44s803.c      |  366 +++++++++++++++++++++++++++
>  drivers/media/common/tuners/mc44s803.h      |   46 ++++
>  drivers/media/common/tuners/mc44s803_priv.h |  208 +++++++++++++++
>  5 files changed, 629 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/common/tuners/mc44s803.c
>  create mode 100644 drivers/media/common/tuners/mc44s803.h
>  create mode 100644 drivers/media/common/tuners/mc44s803_priv.h
>
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index 6f92bea..7969b69 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -29,6 +29,7 @@ config MEDIA_TUNER
>        select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMIZE
>        select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMIZE
>        select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMIZE
> +       select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMIZE
>
>  menuconfig MEDIA_TUNER_CUSTOMIZE
>        bool "Customize analog and hybrid tuner modules to build"
> @@ -164,4 +165,11 @@ config MEDIA_TUNER_MXL5007T
>        help
>          A driver for the silicon tuner MxL5007T from MaxLinear.
>
> +config MEDIA_TUNER_MC44S803
> +       tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
> +       depends on VIDEO_MEDIA && I2C
> +       default m if DVB_FE_CUSTOMISE
> +       help
> +         Say Y here to support the Freescale MC44S803 based tuners
> +
>  endif # MEDIA_TUNER_CUSTOMIZE
> diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
> index 4dfbe5b..4132b2b 100644
> --- a/drivers/media/common/tuners/Makefile
> +++ b/drivers/media/common/tuners/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
>  obj-$(CONFIG_MEDIA_TUNER_MT2131) += mt2131.o
>  obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
>  obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
> +obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
>
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/common/tuners/mc44s803.c
> new file mode 100644
> index 0000000..8fd7fc1
> --- /dev/null
> +++ b/drivers/media/common/tuners/mc44s803.c
> @@ -0,0 +1,366 @@
> +/*
> + *  Driver for Freescale MC44S803 Low Power CMOS Broadband Tuner
> + *
> + *  Copyright (c) 2009 Jochen Friedrich <jochen@scram.de>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/dvb/frontend.h>
> +#include <linux/i2c.h>
> +
> +#include "dvb_frontend.h"
> +
> +#include "mc44s803.h"
> +#include "mc44s803_priv.h"
> +
> +/* Writes a single register */
> +static int mc44s803_writereg(struct mc44s803_priv *priv, u32 val)
> +{
> +       u8 buf[3];
> +       struct i2c_msg msg = {
> +               .addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 3
> +       };
> +
> +       buf[0] = (val & 0xFF0000) >> 16;
> +       buf[1] = (val & 0xFF00) >> 8;
> +       buf[2] = (val & 0xFF);
> +
> +       if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
> +               printk(KERN_WARNING "mc44s803 I2C write failed\n");
> +               return -EREMOTEIO;
> +       }
> +       return 0;
> +}
> +
> +/* Reads a single register */
> +static int mc44s803_readreg(struct mc44s803_priv *priv, u8 reg, u32 *val)
> +{
> +       u32 wval;
> +       u8 buf[3];
> +       u8 ret;
> +       struct i2c_msg msg[] = {
> +               { .addr = priv->cfg->i2c_address, .flags = I2C_M_RD,
> +                 .buf = buf, .len = 3 },
> +       };
> +
> +       wval = MC44S803_REG_SM(MC44S803_REG_DATAREG, MC44S803_ADDR) |
> +              MC44S803_REG_SM(reg, MC44S803_D);
> +
> +       ret = mc44s803_writereg(priv, wval);
> +       if (ret)
> +               return ret;
> +
> +       if (i2c_transfer(priv->i2c, msg, 1) != 1) {
> +               printk(KERN_WARNING "mc44s803 I2C read failed\n");
> +               return -EREMOTEIO;
> +       }
> +
> +       *val = (buf[0] << 16) | (buf[1] << 8) | buf[2];
> +
> +       return 0;
> +}
> +
> +static int mc44s803_release(struct dvb_frontend *fe)
> +{
> +       struct mc44s803_priv *priv = fe->tuner_priv;
> +
> +       fe->tuner_priv = NULL;
> +       kfree(priv);
> +
> +       return 0;
> +}
> +
> +static int mc44s803_init(struct dvb_frontend *fe)
> +{
> +       struct mc44s803_priv *priv = fe->tuner_priv;
> +       u32 val;
> +       int err;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +/* Reset chip */
> +       val = MC44S803_REG_SM(MC44S803_REG_RESET, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_RS);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_RESET, MC44S803_ADDR);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +/* Power Up and Start Osc */
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_REFOSC, MC44S803_ADDR) |
> +             MC44S803_REG_SM(0xC0, MC44S803_REFOSC) |
> +             MC44S803_REG_SM(1, MC44S803_OSCSEL);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_POWER, MC44S803_ADDR) |
> +             MC44S803_REG_SM(0x200, MC44S803_POWER);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       msleep(10);
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_REFOSC, MC44S803_ADDR) |
> +             MC44S803_REG_SM(0x40, MC44S803_REFOSC) |
> +             MC44S803_REG_SM(1, MC44S803_OSCSEL);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       msleep(20);
> +
> +/* Setup Mixer */
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_MIXER, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_TRI_STATE) |
> +             MC44S803_REG_SM(0x7F, MC44S803_MIXER_RES);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +/* Setup Cirquit Adjust */
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_CIRCADJ, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_G1) |
> +             MC44S803_REG_SM(1, MC44S803_G3) |
> +             MC44S803_REG_SM(0x3, MC44S803_CIRCADJ_RES) |
> +             MC44S803_REG_SM(1, MC44S803_G6) |
> +             MC44S803_REG_SM(priv->cfg->dig_out, MC44S803_S1) |
> +             MC44S803_REG_SM(0x3, MC44S803_LP) |
> +             MC44S803_REG_SM(1, MC44S803_CLRF) |
> +             MC44S803_REG_SM(1, MC44S803_CLIF);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_CIRCADJ, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_G1) |
> +             MC44S803_REG_SM(1, MC44S803_G3) |
> +             MC44S803_REG_SM(1, MC44S803_G6) |
> +             MC44S803_REG_SM(priv->cfg->dig_out, MC44S803_S1) |
> +             MC44S803_REG_SM(0x3, MC44S803_LP);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +/* Setup Digtune */
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
> +             MC44S803_REG_SM(3, MC44S803_XOD);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +/* Setup AGC */
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_LNAAGC, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_AT1) |
> +             MC44S803_REG_SM(1, MC44S803_AT2) |
> +             MC44S803_REG_SM(1, MC44S803_AGC_AN_DIG) |
> +             MC44S803_REG_SM(1, MC44S803_AGC_READ_EN) |
> +             MC44S803_REG_SM(1, MC44S803_LNA0);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +       return 0;
> +
> +exit:
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       printk(KERN_WARNING "mc44s803: I/O Error\n");
> +       return err;
> +}
> +
> +static int mc44s803_set_params(struct dvb_frontend *fe,
> +                              struct dvb_frontend_parameters *params)
> +{
> +       struct mc44s803_priv *priv = fe->tuner_priv;
> +       u32 r1, r2, n1, n2, lo1, lo2, freq, val;
> +       int err;
> +
> +       priv->frequency = params->frequency;
> +
> +       r1 = MC44S803_OSC / 1000000;
> +       r2 = MC44S803_OSC /  100000;
> +
> +       n1 = (params->frequency + MC44S803_IF1 + 500000) / 1000000;
> +       freq = MC44S803_OSC / r1 * n1;
> +       lo1 = ((60 * n1) + (r1 / 2)) / r1;
> +       freq = freq - params->frequency;
> +
> +       n2 = (freq - MC44S803_IF2 + 50000) / 100000;
> +       lo2 = ((60 * n2) + (r2 / 2)) / r2;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_REFDIV, MC44S803_ADDR) |
> +             MC44S803_REG_SM(r1-1, MC44S803_R1) |
> +             MC44S803_REG_SM(r2-1, MC44S803_R2) |
> +             MC44S803_REG_SM(1, MC44S803_REFBUF_EN);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_LO1, MC44S803_ADDR) |
> +             MC44S803_REG_SM(n1-2, MC44S803_LO1);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_LO2, MC44S803_ADDR) |
> +             MC44S803_REG_SM(n2-2, MC44S803_LO2);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
> +             MC44S803_REG_SM(1, MC44S803_DA) |
> +             MC44S803_REG_SM(lo1, MC44S803_LO_REF) |
> +             MC44S803_REG_SM(1, MC44S803_AT);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
> +             MC44S803_REG_SM(2, MC44S803_DA) |
> +             MC44S803_REG_SM(lo2, MC44S803_LO_REF) |
> +             MC44S803_REG_SM(1, MC44S803_AT);
> +
> +       err = mc44s803_writereg(priv, val);
> +       if (err)
> +               goto exit;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       return 0;
> +
> +exit:
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +       printk(KERN_WARNING "mc44s803: I/O Error\n");
> +       return err;
> +}
> +
> +static int mc44s803_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +       struct mc44s803_priv *priv = fe->tuner_priv;
> +       *frequency = priv->frequency;
> +       return 0;
> +}
> +
> +static const struct dvb_tuner_ops mc44s803_tuner_ops = {
> +       .info = {
> +               .name           = "Freescale MC44S803",
> +               .frequency_min  =   48000000,
> +               .frequency_max  = 1000000000,
> +               .frequency_step =     100000,
> +       },
> +
> +       .release       = mc44s803_release,
> +       .init          = mc44s803_init,
> +       .set_params    = mc44s803_set_params,
> +       .get_frequency = mc44s803_get_frequency
> +};
> +
> +/* This functions tries to identify a MC44S803 tuner by reading the ID
> +   register. This is hasty. */
> +struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
> +        struct i2c_adapter *i2c, struct mc44s803_config *cfg)
> +{
> +       struct mc44s803_priv *priv = NULL;

Do you really need *priv set to NULL here ?

> +       u32 reg;
> +       u8 ret, id;
> +
> +       reg = 0;
> +
> +       priv = kzalloc(sizeof(struct mc44s803_priv), GFP_KERNEL);
> +       if (priv == NULL)
> +               return NULL;

Maybe return -ENOMEM; ? I don't sure about return NULL, may be your
variant is right.

> +       priv->cfg = cfg;
> +       priv->i2c = i2c;
> +       priv->fe  = fe;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
> +
> +       ret = mc44s803_readreg(priv, MC44S803_REG_ID, &reg);
> +       if (ret)
> +               goto error;
> +
> +       id = MC44S803_REG_MS(reg, MC44S803_ID);
> +
> +       if (id != 0x14) {
> +               printk(KERN_ERROR "MC44S803: unsupported ID "

You pass the name of driver directly to printk messages in few places.
Is it better to use such approach:
#define MC44S803_DRIVER_NAME "mc44s803"

printk (KERN_ERR MC44S803_DRIVER_NAME ": something\n");

?
What do you think?

> +                      "(%x should be 0x14)\n", id);
> +               goto error;
> +       }
> +
> +       printk(KERN_INFO "MC44S803: successfully identified (ID = %x)\n", id);
> +       memcpy(&fe->ops.tuner_ops, &mc44s803_tuner_ops,
> +              sizeof(struct dvb_tuner_ops));
> +
> +       fe->tuner_priv = priv;
> +
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
> +
> +       return fe;
> +
> +error:
> +       if (fe->ops.i2c_gate_ctrl)
> +               fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
> +
> +       kfree(priv);
> +       return NULL;

I'm not sure is it right to return NULL here.. May be some negative
error number ?

<snip>

-- 
Best regards, Klimov Alexey
