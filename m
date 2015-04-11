Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52031 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbbDKK4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2015 06:56:35 -0400
Message-ID: <1428749792.17822.101.camel@x220>
Subject: Re: [PATCH] [media] dvb-usb/dvb-usb-v2: use IS_REACHABLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org
Date: Sat, 11 Apr 2015 12:56:32 +0200
In-Reply-To: <2280698.HtVfESyfme@wuerfel>
References: <2280698.HtVfESyfme@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2015-04-10 at 22:28 +0200, Arnd Bergmann wrote:
> Tha ARM randconfig builds came up with another rare build
> failure for the dib3000mc driver, when dibusb is built-in
> and dib3000mc is a loadable module:
> 
> ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
> ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
> 
> Apparently this used to be a valid configuration (build-time,
> not run-time), but broke as part of a cleanup.
> I tried reverting the cleanup, but saw that the code was still
> wrong then. This tries to fix the code properly, by moving the
> problematic functions into a new file that now is built as a
> loadable module or built-in, whichever is correct for a particular
> configuration. It fixes the regression as well as the run-time
> problem that already existed before.
> 
> I have also checked the two other files that were changed in
> the original cleanup, and found them to be correct in either
> version, so I do not touch that part.
> 
> As this is a rather obscure bug, there is no need for backports.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 028c70ff42783 ("[media] dvb-usb/dvb-usb-v2: use IS_ENABLED")
> ---
>  drivers/media/usb/dvb-usb/Kconfig            |  20 +++-
>  drivers/media/usb/dvb-usb/Makefile           |   3 +
>  drivers/media/usb/dvb-usb/dibusb-common.c    | 158 -------------------------
>  drivers/media/usb/dvb-usb/dibusb-mc-common.c | 168 +++++++++++++++++++++++++++
>  4 files changed, 186 insertions(+), 163 deletions(-)

(dibusb-mc-common.c is a new file, so you'd expect here a line reading
    create mode 100644 drivers/media/usb/dvb-usb/dibusb-mc-common.c

Or do not all versions of git do that?)

> --- a/drivers/media/usb/dvb-usb/Kconfig
> +++ b/drivers/media/usb/dvb-usb/Kconfig

> +config DVB_USB_DIB3000MC
> +	tristate
> +	depends on DVB_USB
> +	select DVB_DIB3000MC
> +	help
> +	  This is a module with helper functions for accessing the
> +	  DIB3000MC from USB DVB devices. It must be a separate module
> +	  in case DVB_USB is built-in and DVB_DIB3000MC is a module,
> +	  and gets selected automatically when needed.

> --- a/drivers/media/usb/dvb-usb/Makefile
> +++ b/drivers/media/usb/dvb-usb/Makefile
 
> +dvb-usb-dibusb-mc-common-objs := dibusb-mc-common.o
> +obj-$(CONFIG_DVB_USB_DIB3000MC)	+= dvb-usb-dibusb-mc-common.o

To make sure I'm reading this change correctly: this will create a
module named dvb-usb-dibusb-mc-common.ko if DVB_USB_DIB3000MC is set to
'm', right?

(If I'm wrong you can stop reading here.)

> --- /dev/null
> +++ b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
> @@ -0,0 +1,168 @@
> +/* Common methods for dibusb-based-receivers.
> + *
> + * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
> + *
> + *	This program is free software; you can redistribute it and/or modify it
> + *	under the terms of the GNU General Public License as published by the Free
> + *	Software Foundation, version 2.
> + *
> + * see Documentation/dvb/README.dvb-usb for more information
> + */
> +
> +#include <linux/kconfig.h>
> +#include "dibusb.h"
> +
> +/* 3000MC/P stuff */
> +// Config Adjacent channels  Perf -cal22
> +static struct dibx000_agc_config dib3000p_mt2060_agc_config = {
> +	.band_caps = BAND_VHF | BAND_UHF,
> +	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
> +
> +	.agc1_max = 48497,
> +	.agc1_min = 23593,
> +	.agc2_max = 46531,
> +	.agc2_min = 24904,
> +
> +	.agc1_pt1 = 0x65,
> +	.agc1_pt2 = 0x69,
> +
> +	.agc1_slope1 = 0x51,
> +	.agc1_slope2 = 0x27,
> +
> +	.agc2_pt1 = 0,
> +	.agc2_pt2 = 0x33,
> +
> +	.agc2_slope1 = 0x35,
> +	.agc2_slope2 = 0x37,
> +};
> +
> +static struct dib3000mc_config stk3000p_dib3000p_config = {
> +	&dib3000p_mt2060_agc_config,
> +
> +	.max_time     = 0x196,
> +	.ln_adc_level = 0x1cc7,
> +
> +	.output_mpeg2_in_188_bytes = 1,
> +
> +	.agc_command1 = 1,
> +	.agc_command2 = 1,
> +};
> +
> +static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
> +	.band_caps = BAND_VHF | BAND_UHF,
> +	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
> +
> +	.agc1_max = 56361,
> +	.agc1_min = 22282,
> +	.agc2_max = 47841,
> +	.agc2_min = 36045,
> +
> +	.agc1_pt1 = 0x3b,
> +	.agc1_pt2 = 0x6b,
> +
> +	.agc1_slope1 = 0x55,
> +	.agc1_slope2 = 0x1d,
> +
> +	.agc2_pt1 = 0,
> +	.agc2_pt2 = 0x0a,
> +
> +	.agc2_slope1 = 0x95,
> +	.agc2_slope2 = 0x1e,
> +};
> +
> +static struct dib3000mc_config mod3000p_dib3000p_config = {
> +	&dib3000p_panasonic_agc_config,
> +
> +	.max_time     = 0x51,
> +	.ln_adc_level = 0x1cc7,
> +
> +	.output_mpeg2_in_188_bytes = 1,
> +
> +	.agc_command1 = 1,
> +	.agc_command2 = 1,
> +};
> +
> +int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
> +	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) ==
> +			USB_PID_LITEON_DVB_T_WARM) {
> +		msleep(1000);
> +	}
> +
> +	adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
> +					 &adap->dev->i2c_adap,
> +					 DEFAULT_DIB3000P_I2C_ADDRESS,
> +					 &mod3000p_dib3000p_config);
> +	if ((adap->fe_adap[0].fe) == NULL)
> +		adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
> +						 &adap->dev->i2c_adap,
> +						 DEFAULT_DIB3000MC_I2C_ADDRESS,
> +						 &mod3000p_dib3000p_config);
> +	if ((adap->fe_adap[0].fe) != NULL) {
> +		if (adap->priv != NULL) {
> +			struct dibusb_state *st = adap->priv;
> +			st->ops.pid_parse = dib3000mc_pid_parse;
> +			st->ops.pid_ctrl  = dib3000mc_pid_control;
> +		}
> +		return 0;
> +	}
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(dibusb_dib3000mc_frontend_attach);
> +
> +static struct mt2060_config stk3000p_mt2060_config = {
> +	0x60
> +};
> +
> +int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct dibusb_state *st = adap->priv;
> +	u8 a,b;
> +	u16 if1 = 1220;
> +	struct i2c_adapter *tun_i2c;
> +
> +	// First IF calibration for Liteon Sticks
> +	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
> +	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_LITEON_DVB_T_WARM) {
> +
> +		dibusb_read_eeprom_byte(adap->dev,0x7E,&a);
> +		dibusb_read_eeprom_byte(adap->dev,0x7F,&b);
> +
> +		if (a == 0x00)
> +			if1 += b;
> +		else if (a == 0x80)
> +			if1 -= b;
> +		else
> +			warn("LITE-ON DVB-T: Strange IF1 calibration :%2X %2X\n", a, b);
> +
> +	} else if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_DIBCOM &&
> +		   le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_DIBCOM_MOD3001_WARM) {
> +		u8 desc;
> +		dibusb_read_eeprom_byte(adap->dev, 7, &desc);
> +		if (desc == 2) {
> +			a = 127;
> +			do {
> +				dibusb_read_eeprom_byte(adap->dev, a, &desc);
> +				a--;
> +			} while (a > 7 && (desc == 0xff || desc == 0x00));
> +			if (desc & 0x80)
> +				if1 -= (0xff - desc);
> +			else
> +				if1 += desc;
> +		}
> +	}
> +
> +	tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe_adap[0].fe, 1);
> +	if (dvb_attach(mt2060_attach, adap->fe_adap[0].fe, tun_i2c, &stk3000p_mt2060_config, if1) == NULL) {
> +		/* not found - use panasonic pll parameters */
> +		if (dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
> +			return -ENOMEM;
> +	} else {
> +		st->mt2060_present = 1;
> +		/* set the correct parameters for the dib3000p */
> +		dib3000mc_set_config(adap->fe_adap[0].fe, &stk3000p_dib3000p_config);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);

But without a MODULE_LICENSE() macro loading that module will taint the
kernel (see set_license() in kernel/module.c). So, although it seems
this driver can do without most of the usual module boilerplate, a
MODULE_LICENSE() macro would still be needed.


Paul Bolle

