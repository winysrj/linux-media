Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:28510 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725733AbeHUFxt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 01:53:49 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        <linux-media@vger.kernel.org>
Cc: "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20180803020839.5967-1-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180803020839.5967-1-suzuki.katsuhiro@socionext.com>
Subject: Re: [PATCH v2] media: dvb-frontends: add LNBH29 LNB supply driver
Date: Tue, 21 Aug 2018 11:35:36 +0900
Message-ID: <000001d438f7$a4764940$ed62dbc0$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

This is ping...


> -----Original Message-----
> From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> Sent: Friday, August 3, 2018 11:09 AM
> To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>;
> linux-media@vger.kernel.org
> Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>; Jassi Brar
> <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Suzuki, Katsuhiro/鈴木 勝博
> <suzuki.katsuhiro@socionext.com>
> Subject: [PATCH v2] media: dvb-frontends: add LNBH29 LNB supply driver
> 
> Add support for STMicroelectronics LNBH29 LNB supply driver.
> 
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> 
> ---
> 
> Changes since v1:
>   - Fix wrong I2C transfer routine
>   - Remove unused headers
> ---
>  drivers/media/dvb-frontends/Kconfig  |  10 ++
>  drivers/media/dvb-frontends/Makefile |   1 +
>  drivers/media/dvb-frontends/lnbh29.c | 168 +++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/lnbh29.h |  36 ++++++
>  4 files changed, 215 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/lnbh29.c
>  create mode 100644 drivers/media/dvb-frontends/lnbh29.h
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig
> b/drivers/media/dvb-frontends/Kconfig
> index 048285134cdf..847da72d1256 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -791,6 +791,16 @@ config DVB_LNBH25
>  	  An SEC control chip.
>  	  Say Y when you want to support this chip.
> 
> +config DVB_LNBH29
> +	tristate "LNBH29 SEC controller"
> +	depends on DVB_CORE && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  LNB power supply and control voltage
> +	  regulator chip with step-up converter
> +	  and I2C interface for STMicroelectronics LNBH29.
> +	  Say Y when you want to support this chip.
> +
>  config DVB_LNBP21
>  	tristate "LNBP21/LNBH24 SEC controllers"
>  	depends on DVB_CORE && I2C
> diff --git a/drivers/media/dvb-frontends/Makefile
> b/drivers/media/dvb-frontends/Makefile
> index 779dfd027b24..e9179162658c 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -58,6 +58,7 @@ obj-$(CONFIG_DVB_LGDT3306A) += lgdt3306a.o
>  obj-$(CONFIG_DVB_LG2160) += lg2160.o
>  obj-$(CONFIG_DVB_CX24123) += cx24123.o
>  obj-$(CONFIG_DVB_LNBH25) += lnbh25.o
> +obj-$(CONFIG_DVB_LNBH29) += lnbh29.o
>  obj-$(CONFIG_DVB_LNBP21) += lnbp21.o
>  obj-$(CONFIG_DVB_LNBP22) += lnbp22.o
>  obj-$(CONFIG_DVB_ISL6405) += isl6405.o
> diff --git a/drivers/media/dvb-frontends/lnbh29.c
> b/drivers/media/dvb-frontends/lnbh29.c
> new file mode 100644
> index 000000000000..410bae099c32
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/lnbh29.c
> @@ -0,0 +1,168 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +// Driver for LNB supply and control IC STMicroelectronics LNBH29
> +//
> +// Copyright (c) 2018 Socionext Inc.
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +
> +#include <media/dvb_frontend.h>
> +#include "lnbh29.h"
> +
> +/**
> + * struct lnbh29_priv - LNBH29 driver private data
> + * @i2c:         Pointer to the I2C adapter structure
> + * @i2c_address: I2C address of LNBH29 chip
> + * @config:      Registers configuration
> + *               offset 0: 1st register address, always 0x01 (DATA)
> + *               offset 1: DATA register value
> + */
> +struct lnbh29_priv {
> +	struct i2c_adapter *i2c;
> +	u8 i2c_address;
> +	u8 config[2];
> +};
> +
> +#define LNBH29_STATUS_OLF     BIT(0)
> +#define LNBH29_STATUS_OTF     BIT(1)
> +#define LNBH29_STATUS_VMON    BIT(2)
> +#define LNBH29_STATUS_PNG     BIT(3)
> +#define LNBH29_STATUS_PDO     BIT(4)
> +#define LNBH29_VSEL_MASK      GENMASK(2, 0)
> +#define LNBH29_VSEL_0         0x00
> +/* Min: 13.188V, Typ: 13.667V, Max:14V */
> +#define LNBH29_VSEL_13        0x03
> +/* Min: 18.158V, Typ: 18.817V, Max:19.475V */
> +#define LNBH29_VSEL_18        0x07
> +
> +static int lnbh29_read_vmon(struct lnbh29_priv *priv)
> +{
> +	u8 addr = 0x00;
> +	u8 status[2];
> +	int ret;
> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = priv->i2c_address,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &addr
> +		}, {
> +			.addr = priv->i2c_address,
> +			.flags = I2C_M_RD,
> +			.len = sizeof(status),
> +			.buf = status
> +		}
> +	};
> +
> +	ret = i2c_transfer(priv->i2c, msg, 2);
> +	if (ret >= 0 && ret != 2)
> +		ret = -EIO;
> +	if (ret < 0) {
> +		dev_dbg(&priv->i2c->dev, "LNBH29 I2C transfer failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	if (status[0] & (LNBH29_STATUS_OLF | LNBH29_STATUS_VMON)) {
> +		dev_err(&priv->i2c->dev,
> +			"LNBH29 voltage in failure state, status reg 0x%x\n",
> +			status[0]);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lnbh29_set_voltage(struct dvb_frontend *fe,
> +			      enum fe_sec_voltage voltage)
> +{
> +	struct lnbh29_priv *priv = fe->sec_priv;
> +	u8 data_reg;
> +	int ret;
> +	struct i2c_msg msg = {
> +		.addr = priv->i2c_address,
> +		.flags = 0,
> +		.len = sizeof(priv->config),
> +		.buf = priv->config
> +	};
> +
> +	switch (voltage) {
> +	case SEC_VOLTAGE_OFF:
> +		data_reg = LNBH29_VSEL_0;
> +		break;
> +	case SEC_VOLTAGE_13:
> +		data_reg = LNBH29_VSEL_13;
> +		break;
> +	case SEC_VOLTAGE_18:
> +		data_reg = LNBH29_VSEL_18;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	priv->config[1] &= ~LNBH29_VSEL_MASK;
> +	priv->config[1] |= data_reg;
> +
> +	ret = i2c_transfer(priv->i2c, &msg, 1);
> +	if (ret >= 0 && ret != 1)
> +		ret = -EIO;
> +	if (ret < 0) {
> +		dev_err(&priv->i2c->dev, "LNBH29 I2C transfer error (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	/* Soft-start time (Vout 0V to 18V) is Typ. 6ms. */
> +	usleep_range(6000, 20000);
> +
> +	if (voltage == SEC_VOLTAGE_OFF)
> +		return 0;
> +
> +	return lnbh29_read_vmon(priv);
> +}
> +
> +static void lnbh29_release(struct dvb_frontend *fe)
> +{
> +	lnbh29_set_voltage(fe, SEC_VOLTAGE_OFF);
> +	kfree(fe->sec_priv);
> +	fe->sec_priv = NULL;
> +}
> +
> +struct dvb_frontend *lnbh29_attach(struct dvb_frontend *fe,
> +				   struct lnbh29_config *cfg,
> +				   struct i2c_adapter *i2c)
> +{
> +	struct lnbh29_priv *priv;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return NULL;
> +
> +	priv->i2c_address = (cfg->i2c_address >> 1);
> +	priv->i2c = i2c;
> +	priv->config[0] = 0x01;
> +	priv->config[1] = cfg->data_config;
> +	fe->sec_priv = priv;
> +
> +	if (lnbh29_set_voltage(fe, SEC_VOLTAGE_OFF)) {
> +		dev_err(&i2c->dev, "no LNBH29 found at I2C addr 0x%02x\n",
> +			priv->i2c_address);
> +		kfree(priv);
> +		fe->sec_priv = NULL;
> +		return NULL;
> +	}
> +
> +	fe->ops.release_sec = lnbh29_release;
> +	fe->ops.set_voltage = lnbh29_set_voltage;
> +
> +	dev_info(&i2c->dev, "LNBH29 attached at I2C addr 0x%02x\n",
> +		 priv->i2c_address);
> +
> +	return fe;
> +}
> +EXPORT_SYMBOL(lnbh29_attach);
> +
> +MODULE_AUTHOR("Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>");
> +MODULE_DESCRIPTION("STMicroelectronics LNBH29 driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/dvb-frontends/lnbh29.h
> b/drivers/media/dvb-frontends/lnbh29.h
> new file mode 100644
> index 000000000000..6179921520d9
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/lnbh29.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Driver for LNB supply and control IC STMicroelectronics LNBH29
> + *
> + * Copyright (c) 2018 Socionext Inc.
> + */
> +
> +#ifndef LNBH29_H
> +#define LNBH29_H
> +
> +#include <linux/i2c.h>
> +#include <linux/dvb/frontend.h>
> +
> +/* Using very low E.S.R. capacitors or ceramic caps */
> +#define LNBH29_DATA_COMP    BIT(3)
> +
> +struct lnbh29_config {
> +	u8 i2c_address;
> +	u8 data_config;
> +};
> +
> +#if IS_REACHABLE(CONFIG_DVB_LNBH29)
> +struct dvb_frontend *lnbh29_attach(struct dvb_frontend *fe,
> +				   struct lnbh29_config *cfg,
> +				   struct i2c_adapter *i2c);
> +#else
> +static inline struct dvb_frontend *lnbh29_attach(struct dvb_frontend *fe,
> +						 struct lnbh29_config *cfg,
> +						 struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif
> --
> 2.18.0
