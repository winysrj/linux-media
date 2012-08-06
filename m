Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2HFPui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 11:50:38 -0400
Message-ID: <501FE7CB.1050201@redhat.com>
Date: Mon, 06 Aug 2012 12:50:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] make the other drivers take use of the new ts2020
 driver
References: <CAF0Ff2m+CEqxgX0i0XbRR=+7Esf6czJKUyEUvAGeRFOm5iRD_g@mail.gmail.com>
In-Reply-To: <CAF0Ff2m+CEqxgX0i0XbRR=+7Esf6czJKUyEUvAGeRFOm5iRD_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-05-2012 18:25, Konstantin Dimitrov escreveu:
> make the other drivers take use of the separate ts2020 driver
> 
> Signed-off-by: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> 
> --- a/linux/drivers/media/dvb/frontends/ds3000.c	2012-05-07
> 02:24:25.900920554 +0300
> +++ b/linux/drivers/media/dvb/frontends/ds3000.c	2012-05-07
> 02:26:01.728919348 +0300
> @@ -27,6 +27,7 @@
>  #include <linux/firmware.h>
> 
>  #include "dvb_frontend.h"
> +#include "ts2020.h"
>  #include "ds3000.h"
> 
>  static int debug;
> @@ -539,8 +540,7 @@
>  static int ds3000_read_signal_strength(struct dvb_frontend *fe,
>  						u16 *signal_strength)
>  {
> -	/* temporary disabled until seperate ts2020 tuner driver is merged */
> -	*signal_strength = 0xffff;
> +	ts2020_get_signal_strength(fe, signal_strength);
> 
>  	return 0;
>  }

No. Either call get_rf_strength here or, even better, don't implement it,
and, at the tuner attach logic, you can do:

	fe[i]->ops.read_signal_strength = fe[i]->ops.tuner_ops.get_rf_strength;

> --- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	2012-01-17
> 06:45:50.000000000 +0200
> +++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	2012-05-07
> 01:48:37.352505509 +0300
> @@ -57,6 +57,8 @@
>  #include "netup-init.h"
>  #include "lgdt3305.h"
>  #include "atbm8830.h"
> +#include "ts2020.h"
> +#include "ts2020_cfg.h"
>  #include "ds3000.h"
>  #include "cx23885-f300.h"
>  #include "altera-ci.h"
> @@ -464,6 +466,13 @@
> 
>  static struct ds3000_config tevii_ds3000_config = {
>  	.demod_address = 0x68,
> +
> +	.tuner_get_frequency = ts2020_get_frequency,
> +	.tuner_set_frequency = ts2020_set_frequency,

Not needed/wanted.

> +};
> +
> +static struct ts2020_config tevii_ts2020_config  = {
> +	.tuner_address = 0x60,
>  };
> 
>  static struct cx24116_config dvbworld_cx24116_config = {
> @@ -966,8 +975,11 @@
>  		fe0->dvb.frontend = dvb_attach(ds3000_attach,
>  					&tevii_ds3000_config,
>  					&i2c_bus->i2c_adap);
> -		if (fe0->dvb.frontend != NULL)
> +		if (fe0->dvb.frontend != NULL) {
> +			dvb_attach(ts2020_attach, fe0->dvb.frontend,
> +				&tevii_ts2020_config, &i2c_bus->i2c_adap);
>  			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;

You'll be adding here something like:
	fe0->dvb.frontend->ops.read_signal_strength = fe0->dvb.frontend->ops.tuner_ops.get_rf_strength;

The same applies to the similar code below.

> +		}
> 
>  		break;
>  	case CX23885_BOARD_DVBWORLD_2005:
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c	2012-01-08
> 06:45:35.000000000 +0200
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c	2012-05-07
> 03:02:54.359917746 +0300
> @@ -58,6 +58,8 @@
>  #include "stb6100.h"
>  #include "stb6100_proc.h"
>  #include "mb86a16.h"
> +#include "ts2020.h"
> +#include "ts2020_cfg.h"
>  #include "ds3000.h"
> 
>  MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
> @@ -698,6 +700,13 @@
>  static struct ds3000_config tevii_ds3000_config = {
>  	.demod_address = 0x68,
>  	.set_ts_params = ds3000_set_ts_param,
> +
> +	.tuner_get_frequency = ts2020_get_frequency,
> +	.tuner_set_frequency = ts2020_set_frequency,

Not needed/wanted.

> +};
> +
> +static struct ts2020_config tevii_ts2020_config  = {
> +	.tuner_address = 0x60,
>  };
> 
>  static const struct stv0900_config prof_7301_stv0900_config = {
> @@ -1466,9 +1475,12 @@
>  		fe0->dvb.frontend = dvb_attach(ds3000_attach,
>  						&tevii_ds3000_config,
>  						&core->i2c_adap);
> -		if (fe0->dvb.frontend != NULL)
> +		if (fe0->dvb.frontend != NULL) {
> +			dvb_attach(ts2020_attach, fe0->dvb.frontend,
> +				&tevii_ts2020_config, &core->i2c_adap);
>  			fe0->dvb.frontend->ops.set_voltage =
>  							tevii_dvbs_set_voltage;
> +		}
>  		break;
>  	case CX88_BOARD_OMICOM_SS4_PCI:
>  	case CX88_BOARD_TBS_8920:
> --- a/linux/drivers/media/dvb/dm1105/dm1105.c	2012-01-08
> 06:45:35.000000000 +0200
> +++ b/linux/drivers/media/dvb/dm1105/dm1105.c	2012-05-07
> 03:03:10.899917539 +0300
> @@ -45,6 +45,8 @@
>  #include "si21xx.h"
>  #include "cx24116.h"
>  #include "z0194a.h"
> +#include "ts2020.h"
> +#include "ts2020_cfg.h"
>  #include "ds3000.h"
> 
>  #define MODULE_NAME "dm1105"
> @@ -847,6 +849,13 @@
> 
>  static struct ds3000_config dvbworld_ds3000_config = {
>  	.demod_address = 0x68,
> +
> +	.tuner_get_frequency = ts2020_get_frequency,
> +	.tuner_set_frequency = ts2020_set_frequency,

Not needed/wanted.

> +};
> +
> +static struct ts2020_config dvbworld_ts2020_config  = {
> +	.tuner_address = 0x60,
>  };
> 
>  static int __devinit frontend_init(struct dm1105_dev *dev)
> @@ -898,8 +907,11 @@
>  		dev->fe = dvb_attach(
>  			ds3000_attach, &dvbworld_ds3000_config,
>  			&dev->i2c_adap);
> -		if (dev->fe)
> +		if (dev->fe) {
> +			dvb_attach(ts2020_attach, dev->fe,
> +				&dvbworld_ts2020_config, &dev->i2c_adap);
>  			dev->fe->ops.set_voltage = dm1105_set_voltage;
> +		}
> 
>  		break;
>  	case DM1105_BOARD_DVBWORLD_2002:
> --- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	2012-01-22
> 03:53:17.000000000 +0200
> +++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	2012-05-07
> 03:03:22.739917389 +0300
> @@ -22,6 +22,8 @@
>  #include "tda1002x.h"
>  #include "mt312.h"
>  #include "zl10039.h"
> +#include "ts2020.h"
> +#include "ts2020_cfg.h"
>  #include "ds3000.h"
>  #include "stv0900.h"
>  #include "stv6110.h"
> @@ -934,6 +936,13 @@
> 
>  static struct ds3000_config dw2104_ds3000_config = {
>  	.demod_address = 0x68,
> +
> +	.tuner_get_frequency = ts2020_get_frequency,
> +	.tuner_set_frequency = ts2020_set_frequency,

Not needed/wanted.

> +};
> +
> +static struct ts2020_config dw2104_ts2020_config  = {
> +	.tuner_address = 0x60,
>  };
> 
>  static struct stv0900_config dw2104a_stv0900_config = {
> @@ -985,6 +994,13 @@
>  static struct ds3000_config su3000_ds3000_config = {
>  	.demod_address = 0x68,
>  	.ci_mode = 1,
> +
> +	.tuner_get_frequency = ts2020_get_frequency,
> +	.tuner_set_frequency = ts2020_set_frequency,

Not needed/wanted.

> +};
> +
> +static struct ts2020_config su3000_ts2020_config  = {
> +	.tuner_address = 0x60,
>  };
> 
>  static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
> @@ -1037,6 +1053,8 @@
>  	d->fe_adap[0].fe = dvb_attach(ds3000_attach, &dw2104_ds3000_config,
>  			&d->dev->i2c_adap);
>  	if (d->fe_adap[0].fe != NULL) {
> +		dvb_attach(ts2020_attach, d->fe_adap[0].fe,
> +			&dw2104_ts2020_config, &d->dev->i2c_adap);
>  		d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
>  		info("Attached DS3000!\n");
>  		return 0;
> @@ -1149,6 +1167,9 @@
>  	if (d->fe_adap[0].fe == NULL)
>  		return -EIO;
> 
> +	dvb_attach(ts2020_attach, d->fe_adap[0].fe, &dw2104_ts2020_config,
> +		&d->dev->i2c_adap);
> +
>  	st->old_set_voltage = d->fe_adap[0].fe->ops.set_voltage;
>  	d->fe_adap[0].fe->ops.set_voltage = s660_set_voltage;
> 
> @@ -1209,6 +1230,9 @@
>  	if (d->fe_adap[0].fe == NULL)
>  		return -EIO;
> 
> +	dvb_attach(ts2020_attach, d->fe_adap[0].fe, &su3000_ts2020_config,
> +		&d->dev->i2c_adap);
> +
>  	info("Attached DS3000!\n");
> 
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

