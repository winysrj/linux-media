Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:62824 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbaKTUDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:03:46 -0500
Received: by mail-la0-f45.google.com with SMTP id gq15so3096051lab.18
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 12:03:45 -0800 (PST)
Date: Thu, 20 Nov 2014 22:03:42 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: CrazyCat <crazycat69@narod.ru>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] cxusb: Geniatech T230 support.
In-Reply-To: <7329493.WxyJoRadkM@computer>
Message-ID: <alpine.DEB.2.10.1411202203220.1388@dl160.lan>
References: <7329493.WxyJoRadkM@computer>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Fri, 14 Nov 2014, CrazyCat wrote:

> Geniatech Mygica T230 DVB-T/T2/C USB stick support.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
> drivers/media/dvb-core/dvb-usb-ids.h |   1 +
> drivers/media/usb/dvb-usb/cxusb.c    | 127 +++++++++++++++++++++++++++++++++++
> 2 files changed, 128 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index e07a84e..80ab8d0 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -356,6 +356,7 @@
> #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
> #define USB_PID_SONY_PLAYTV				0x0003
> #define USB_PID_MYGICA_D689				0xd811
> +#define USB_PID_MYGICA_T230				0xc688
> #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
> #define USB_PID_ELGATO_EYETV_DTT			0x0021
> #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index b46f84d..7346698 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1408,6 +1408,76 @@ static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
> 	return 0;
> }
>
> +static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
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
> +	st->i2c_client_demod = client_demod;
> +
> +	/* attach tuner */
> +	memset(&si2157_config, 0, sizeof(si2157_config));
> +	si2157_config.fe = adap->fe_adap[0].fe;
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> +	info.addr = 0x60;
> +	info.platform_data = &si2157_config;
> +	request_module(info.type);
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
> +	st->i2c_client_tuner = client_tuner;
> +
> +	return 0;
> +}
> +
> static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
> {
> 	struct dvb_usb_device *d = adap->dev;
> @@ -1609,6 +1679,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
> static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
> static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
> static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
> +static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
> static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties;
>
> static int cxusb_probe(struct usb_interface *intf,
> @@ -1640,6 +1711,8 @@ static int cxusb_probe(struct usb_interface *intf,
> 				     THIS_MODULE, NULL, adapter_nr) ||
> 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_d689_properties,
> 				     THIS_MODULE, NULL, adapter_nr) ||
> +	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
> +				     THIS_MODULE, NULL, adapter_nr) ||
> 	    0 == dvb_usb_device_init(intf, &cxusb_tt_ct2_4400_properties,
> 				     THIS_MODULE, NULL, adapter_nr) ||
> 	    0)
> @@ -1701,6 +1774,7 @@ static struct usb_device_id cxusb_table [] = {
> 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
> 	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_TVSTICK_CT2_4400) },
> 	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) },
> +	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230) },
> 	{}		/* Terminating entry */
> };
> MODULE_DEVICE_TABLE (usb, cxusb_table);
> @@ -2407,6 +2481,59 @@ static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
> 	}
> };
>
> +static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
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
> +			.frontend_attach  = cxusb_mygica_t230_frontend_attach,
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
> +		.rc_map_table     = rc_map_d680_dmb_table,
> +		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
> +		.rc_query         = cxusb_d680_dmb_rc_query,
> +	},
> +
> +	.num_device_descs = 1,
> +	.devices = {
> +		{
> +			"Mygica T230 DVB-T/T2/C",
> +			{ NULL },
> +			{ &cxusb_table[22], NULL },
> +		},
> +	}
> +};
> +
> static struct usb_driver cxusb_driver = {
> 	.name		= "dvb_usb_cxusb",
> 	.probe		= cxusb_probe,
> -- 
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
