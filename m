Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52909
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753186AbdBCLHA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 06:07:00 -0500
Date: Fri, 3 Feb 2017 09:06:54 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: CrazyCat <crazycat69@narod.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] dvb-usb-cxusb: Geniatech Mygica T230C support.
Message-ID: <20170203090648.7d5ebd3f@vento.lan>
In-Reply-To: <1534970.1pLvRSzKZX@computer>
References: <1534970.1pLvRSzKZX@computer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 09 Dec 2016 02:21:20 +0200
CrazyCat <crazycat69@narod.ru> escreveu:

> Updated Geniatech DVB-T/T2 stick support.
> 
> Signed-off-by: CrazyCat <crazycat69@narod.ru>
> ---
>  drivers/media/usb/dvb-usb/cxusb.c | 136 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 136 insertions(+)
> 
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 3edc30d..4bf4c68 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1439,6 +1439,82 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +static int cxusb_mygica_t230c_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct dvb_usb_device *d = adap->dev;
> +	struct cxusb_state *st = d->priv;
> +	struct i2c_adapter *adapter;
> +	struct i2c_client *client_demod;
> +	struct i2c_client *client_tuner;
> +	struct i2c_board_info info;
> +	struct si2168_config si2168_config;
> +	struct si2157_config si2157_config;
> +
> +	/* Select required USB configuration */
> +	if (usb_set_interface(d->udev, 0, 0) < 0)
> +		err("set interface failed");
> +
> +	/* Unblock all USB pipes */
> +	usb_clear_halt(d->udev,
> +		usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
> +	usb_clear_halt(d->udev,
> +		usb_rcvbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
> +	usb_clear_halt(d->udev,
> +		usb_rcvbulkpipe(d->udev, d->props.adapter[0].fe[0].stream.endpoint));
> +
> +	/* attach frontend */
> +	memset(&si2168_config, 0, sizeof(si2168_config));
> +	si2168_config.i2c_adapter = &adapter;
> +	si2168_config.fe = &adap->fe_adap[0].fe;
> +	si2168_config.ts_mode = SI2168_TS_PARALLEL;
> +	si2168_config.ts_clock_inv = 1;
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
> +	info.addr = 0x64;
> +	info.platform_data = &si2168_config;
> +	request_module(info.type);
> +	client_demod = i2c_new_device(&d->i2c_adap, &info);
> +	if (client_demod == NULL || client_demod->dev.driver == NULL)
> +		return -ENODEV;
> +
> +	if (!try_module_get(client_demod->dev.driver->owner)) {
> +		i2c_unregister_device(client_demod);
> +		return -ENODEV;
> +	}
> +
> +	/* attach tuner */
> +	memset(&si2157_config, 0, sizeof(si2157_config));
> +	si2157_config.fe = adap->fe_adap[0].fe;
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "si2141", I2C_NAME_SIZE);
> +	info.addr = 0x60;
> +	info.platform_data = &si2157_config;
> +	request_module("si2157");
> +	client_tuner = i2c_new_device(adapter, &info);
> +	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> +		module_put(client_demod->dev.driver->owner);
> +		i2c_unregister_device(client_demod);
> +		return -ENODEV;
> +	}
> +	if (!try_module_get(client_tuner->dev.driver->owner)) {
> +		i2c_unregister_device(client_tuner);
> +		module_put(client_demod->dev.driver->owner);
> +		i2c_unregister_device(client_demod);
> +		return -ENODEV;
> +	}
> +
> +	st->i2c_client_demod = client_demod;
> +	st->i2c_client_tuner = client_tuner;
> +
> +	/* hook fe: need to resync the slave fifo when signal locks. */
> +	mutex_init(&st->stream_mutex);
> +	st->last_lock = 0;
> +	st->fe_read_status = adap->fe_adap[0].fe->ops.read_status;
> +	adap->fe_adap[0].fe->ops.read_status = cxusb_read_status;
> +
> +	return 0;
> +}
> +
>  /*
>   * DViCO has shipped two devices with the same USB ID, but only one of them
>   * needs a firmware download.  Check the device class details to see if they
> @@ -1521,6 +1597,7 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
>  static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
>  static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
>  static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
> +static struct dvb_usb_device_properties cxusb_mygica_t230c_properties;
>  
>  static int cxusb_probe(struct usb_interface *intf,
>  		       const struct usb_device_id *id)
> @@ -1553,6 +1630,8 @@ static int cxusb_probe(struct usb_interface *intf,
>  				     THIS_MODULE, NULL, adapter_nr) ||
>  	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
>  				     THIS_MODULE, NULL, adapter_nr) ||
> +	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230c_properties,
> +				     THIS_MODULE, NULL, adapter_nr) ||
>  	    0)
>  		return 0;
>  
> @@ -1604,6 +1683,7 @@ enum cxusb_table_index {
>  	CONEXANT_D680_DMB,
>  	MYGICA_D689,
>  	MYGICA_T230,
> +	MYGICA_T230C,
>  	NR__cxusb_table_index
>  };
>  
> @@ -1671,6 +1751,9 @@ enum cxusb_table_index {
>  	[MYGICA_T230] = {
>  		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
>  	},
> +	[MYGICA_T230C] = {
> +		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230+1)
> +	},
>  	{}		/* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE (usb, cxusb_table);
> @@ -2370,6 +2453,59 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
>  	}
>  };
>  
> +static struct dvb_usb_device_properties cxusb_mygica_t230c_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +
> +	.usb_ctrl         = CYPRESS_FX2,
> +
> +	.size_of_priv     = sizeof(struct cxusb_state),
> +
> +	.num_adapters = 1,
> +	.adapter = {
> +		{
> +		.num_frontends = 1,
> +		.fe = {{
> +			.streaming_ctrl   = cxusb_streaming_ctrl,
> +			.frontend_attach  = cxusb_mygica_t230c_frontend_attach,
> +
> +			/* parameter for the MPEG2-data transfer */
> +			.stream = {
> +				.type = USB_BULK,
> +				.count = 5,
> +				.endpoint = 0x02,
> +				.u = {
> +					.bulk = {
> +						.buffersize = 8192,
> +					}
> +				}
> +			},
> +		} },
> +		},
> +	},
> +
> +	.power_ctrl       = cxusb_d680_dmb_power_ctrl,
> +
> +	.i2c_algo         = &cxusb_i2c_algo,
> +
> +	.generic_bulk_ctrl_endpoint = 0x01,
> +
> +	.rc.legacy = {
> +		.rc_interval      = 100,
> +		.rc_map_table     = rc_map_t230_table,
> +		.rc_map_size      = ARRAY_SIZE(rc_map_t230_table),
> +		.rc_query         = cxusb_d680_dmb_rc_query,
> +	},

This also require rebase.

> +
> +	.num_device_descs = 1,
> +	.devices = {
> +		{
> +			"Mygica T230C DVB-T/T2/C",
> +			{ NULL },
> +			{ &cxusb_table[MYGICA_T230C], NULL },
> +		},
> +	}
> +};
> +
>  static struct usb_driver cxusb_driver = {
>  	.name		= "dvb_usb_cxusb",
>  	.probe		= cxusb_probe,



Thanks,
Mauro
