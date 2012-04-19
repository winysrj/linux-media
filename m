Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab2DSSJP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 14:09:15 -0400
Message-ID: <4F9054C7.10201@redhat.com>
Date: Thu, 19 Apr 2012 15:09:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] m88ds3103, dvbsky dvb-s2 usb box.
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com> <201204152353240317150@gmail.com>
In-Reply-To: <201204152353240317150@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-04-2012 12:53, nibble.max escreveu:
> dvbsky dvb-s2 usb box based on montage m88ds3103 demodulator.
> 
> Signed-off-by: Max nibble <nibble.max@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/Kconfig  |    1 +
>  drivers/media/dvb/dvb-usb/dw2102.c |  236 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 236 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index be1db75..bf63f29 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -279,6 +279,7 @@ config DVB_USB_DW2102
>  	select DVB_STV0288 if !DVB_FE_CUSTOMISE
>  	select DVB_STB6000 if !DVB_FE_CUSTOMISE
>  	select DVB_CX24116 if !DVB_FE_CUSTOMISE
> +	select DVB_M88DS3103 if !DVB_FE_CUSTOMISE
>  	select DVB_SI21XX if !DVB_FE_CUSTOMISE
>  	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
>  	select DVB_MT312 if !DVB_FE_CUSTOMISE
> diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
> index 451c5a7..0b1bbd2 100644
> --- a/drivers/media/dvb/dvb-usb/dw2102.c
> +++ b/drivers/media/dvb/dvb-usb/dw2102.c
> @@ -19,6 +19,7 @@
>  #include "stb6000.h"
>  #include "eds1547.h"
>  #include "cx24116.h"
> +#include "m88ds3103.h"
>  #include "tda1002x.h"
>  #include "mt312.h"
>  #include "zl10039.h"
> @@ -882,6 +883,44 @@ static int s660_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
>  	return 0;
>  }
>  
> +static int bstusb_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
> +{
> +
> +	struct dvb_usb_adapter *udev_adap =
> +		(struct dvb_usb_adapter *)(fe->dvb->priv);
> +
> +	u8 obuf[3] = { 0xe, 0x80, 0 };
> +	u8 ibuf[] = { 0 };
> +		
> +	info("US6830: %s!\n", __func__);
> +				
> +	if (voltage == SEC_VOLTAGE_OFF)
> +		obuf[2] = 0;
> +	else 
> +		obuf[2] = 1;
> +		
> +	if (dvb_usb_generic_rw(udev_adap->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +	
> +	return 0;
> +}
> +
> +static int bstusb_restart(struct dvb_frontend *fe)
> +{
> +
> +	struct dvb_usb_adapter *udev_adap =
> +		(struct dvb_usb_adapter *)(fe->dvb->priv);
> +	
> +	u8 obuf[3] = { 0x36, 3, 0 };
> +	u8 ibuf[] = { 0 };
> +			
> +
> +	if (dvb_usb_generic_rw(udev_adap->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x36 transfer failed.");
> +	
> +	return 0;
> +}
> +
>  static void dw210x_led_ctrl(struct dvb_frontend *fe, int offon)
>  {
>  	static u8 led_off[] = { 0 };
> @@ -987,6 +1026,24 @@ static struct ds3000_config su3000_ds3000_config = {
>  	.ci_mode = 1,
>  };
>  
> +static struct m88ds3103_config US6830_ds3103_config = {
> +	.demod_address = 0x68,
> +	.ci_mode = 1,
> +	.pin_ctrl = 0x83,
> +	.ts_mode = 0,
> +	.start_ctrl = bstusb_restart,
> +	.set_voltage = bstusb_set_voltage,
> +};
> +
> +static struct m88ds3103_config US6832_ds3103_config = {
> +	.demod_address = 0x68,
> +	.ci_mode = 1,
> +	.pin_ctrl = 0x80,
> +	.ts_mode = 0,
> +	.start_ctrl = bstusb_restart,
> +	.set_voltage = bstusb_set_voltage,
> +};
> +
>  static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
>  {
>  	struct dvb_tuner_ops *tuner_ops = NULL;
> @@ -1214,6 +1271,72 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
>  	return 0;
>  }
>  
> +static int US6830_frontend_attach(struct dvb_usb_adapter *d)
> +{
> +	u8 obuf[3] = { 0xe, 0x83, 0 };
> +	u8 ibuf[] = { 0 };
> +
> +
> +	info("US6830: %s!\n", __func__);
> +	
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x83;
> +	obuf[2] = 1;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0x51;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
> +		err("command 0x51 transfer failed.");
> +
> +	d->fe_adap[0].fe = dvb_attach(m88ds3103_attach, &US6830_ds3103_config,
> +					&d->dev->i2c_adap);
> +	if (d->fe_adap[0].fe == NULL)
> +		return -EIO;
> +
> +	info("Attached M88DS3103!\n");
> +
> +	return 0;
> +}
> +
> +static int US6832_frontend_attach(struct dvb_usb_adapter *d)
> +{
> +	u8 obuf[3] = { 0xe, 0x83, 0 };
> +	u8 ibuf[] = { 0 };
> +
> +
> +	info("US6832: %s!\n", __func__);
> +	
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x83;
> +	obuf[2] = 1;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0x51;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
> +		err("command 0x51 transfer failed.");
> +
> +	d->fe_adap[0].fe = dvb_attach(m88ds3103_attach, &US6832_ds3103_config,
> +					&d->dev->i2c_adap);
> +	if (d->fe_adap[0].fe == NULL)
> +		return -EIO;
> +
> +	info("Attached M88DS3103!\n");
> +
> +	return 0;
> +}
> +
>  static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
>  {
>  	dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60,
> @@ -1451,6 +1574,9 @@ enum dw2102_table_entry {
>  	TEVII_S480_1,
>  	TEVII_S480_2,
>  	X3M_SPC1400HD,
> +	BST_US6830HD,
> +	BST_US6831HD,
> +	BST_US6832HD,
>  };
>  
>  static struct usb_device_id dw2102_table[] = {
> @@ -1469,6 +1595,9 @@ static struct usb_device_id dw2102_table[] = {
>  	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
>  	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
>  	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
> +	[BST_US6830HD] = {USB_DEVICE(0x0572, 0x6830)},
> +	[BST_US6831HD] = {USB_DEVICE(0x0572, 0x6831)},
> +	[BST_US6832HD] = {USB_DEVICE(0x0572, 0x6832)},
>  	{ }
>  };
>  
> @@ -1874,6 +2003,107 @@ static struct dvb_usb_device_properties su3000_properties = {
>  	}
>  };
>  
> +static struct dvb_usb_device_properties US6830_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	.usb_ctrl = DEVICE_SPECIFIC,
> +	.size_of_priv = sizeof(struct su3000_state),
> +	.power_ctrl = su3000_power_ctrl,
> +	.num_adapters = 1,
> +	.identify_state	= su3000_identify_state,
> +	.i2c_algo = &su3000_i2c_algo,
> +
> +	.rc.legacy = {
> +		.rc_map_table = rc_map_su3000_table,
> +		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
> +		.rc_interval = 150,
> +		.rc_query = dw2102_rc_query,
> +	},


New drivers should use .rc.core instead. For a simple example on how to use,
please take a look at the az6007 driver.

> +
> +	.read_mac_address = su3000_read_mac_address,
> +
> +	.generic_bulk_ctrl_endpoint = 0x01,
> +	
> +	.adapter = {
> +		{
> +		.num_frontends = 1,
> +		.fe = {{
> +			.streaming_ctrl   = su3000_streaming_ctrl,
> +			.frontend_attach  = US6830_frontend_attach,
> +			.stream = {
> +				.type = USB_BULK,
> +				.count = 8,
> +				.endpoint = 0x82,
> +				.u = {
> +					.bulk = {
> +						.buffersize = 4096,
> +					}
> +				}
> +			}
> +		}},
> +		}
> +	},
> +	.num_device_descs = 2,
> +	.devices = {
> +		{ "Bestunar US6830 HD",
> +			{ &dw2102_table[BST_US6830HD], NULL },
> +			{ NULL },
> +		},
> +		{ "Bestunar US6831 HD",
> +			{ &dw2102_table[BST_US6831HD], NULL },
> +			{ NULL },
> +		},				
> +	}
> +};
> +
> +static struct dvb_usb_device_properties US6832_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	.usb_ctrl = DEVICE_SPECIFIC,
> +	.size_of_priv = sizeof(struct su3000_state),
> +	.power_ctrl = su3000_power_ctrl,
> +	.num_adapters = 1,
> +	.identify_state	= su3000_identify_state,
> +	.i2c_algo = &su3000_i2c_algo,
> +
> +	.rc.legacy = {
> +		.rc_map_table = rc_map_su3000_table,
> +		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
> +		.rc_interval = 150,
> +		.rc_query = dw2102_rc_query,
> +	},
> +
> +	.read_mac_address = su3000_read_mac_address,
> +
> +	.generic_bulk_ctrl_endpoint = 0x01,
> +
> +	.adapter = {
> +		{
> +		.num_frontends = 1,
> +		.fe = {{
> +			.streaming_ctrl   = su3000_streaming_ctrl,
> +			.frontend_attach  = US6832_frontend_attach,
> +			.stream = {
> +				.type = USB_BULK,
> +				.count = 8,
> +				.endpoint = 0x82,
> +				.u = {
> +					.bulk = {
> +						.buffersize = 4096,
> +					}
> +				}
> +			}
> +		}},
> +		}
> +	},
> +	.num_device_descs = 1,
> +	.devices = {
> +		{ "Bestunar US6832 HD",
> +			{ &dw2102_table[BST_US6832HD], NULL },
> +			{ NULL },
> +		},
> +				
> +	}
> +};
> +
>  static int dw2102_probe(struct usb_interface *intf,
>  		const struct usb_device_id *id)
>  {
> @@ -1930,7 +2160,11 @@ static int dw2102_probe(struct usb_interface *intf,
>  	    0 == dvb_usb_device_init(intf, p7500,
>  			THIS_MODULE, NULL, adapter_nr) ||
>  	    0 == dvb_usb_device_init(intf, &su3000_properties,
> -				     THIS_MODULE, NULL, adapter_nr))
> +     			THIS_MODULE, NULL, adapter_nr) ||
> +	    0 == dvb_usb_device_init(intf, &US6830_properties,
> +			THIS_MODULE, NULL, adapter_nr) ||
> +	    0 == dvb_usb_device_init(intf, &US6832_properties,
> +			THIS_MODULE, NULL, adapter_nr))
>  		return 0;
>  
>  	return -ENODEV;

