Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52199 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1KLQSH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:18:07 -0500
Message-ID: <4EBE9C3C.4070201@iki.fi>
Date: Sat, 12 Nov 2011 18:18:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] af9015 Remove call to get config from probe.
References: <4ebe96dc.d467e30a.389b.ffff8e28@mx.google.com>
In-Reply-To: <4ebe96dc.d467e30a.389b.ffff8e28@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
> Remove get config from probe and move to identify_state.
>
> intf->cur_altsetting->desc.bInterfaceNumber is always expected to be zero, so there
> no point in checking for it.

Are you sure? IIRC there is HID remote on interface 1 or 2 or so (some 
other than 0). Please double check.

> Calling from probe seems to cause a race condition with some USB controllers.

Why?

Unless reasons are not clear it should not be moved.

Antti

> The first call fails as the device appears to busy with USB sub system
> control calls.
>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/af9015.c |   87 ++++++++++++++---------------------
>   1 files changed, 35 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index dc6e4ec..eb464c8 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -820,7 +820,8 @@ static void af9015_set_remote_config(struct usb_device *udev,
>   	return;
>   }
>
> -static int af9015_read_config(struct usb_device *udev)
> +static int af9015_read_config(struct usb_device *udev,
> +		struct dvb_usb_device_properties *props)
>   {
>   	int ret;
>   	u8 val, i, offset = 0;
> @@ -842,12 +843,10 @@ static int af9015_read_config(struct usb_device *udev)
>   		goto error;
>
>   	deb_info("%s: IR mode:%d\n", __func__, val);
> -	for (i = 0; i<  af9015_properties_count; i++) {
> -		if (val == AF9015_IR_MODE_DISABLED)
> -			af9015_properties[i].rc.core.rc_codes = NULL;
> -		else
> -			af9015_set_remote_config(udev,&af9015_properties[i]);
> -	}
> +	if (val == AF9015_IR_MODE_DISABLED)
> +		props->rc.core.rc_codes = NULL;
> +	else
> +		af9015_set_remote_config(udev, props);
>
>   	/* TS mode - one or two receivers */
>   	req.addr = AF9015_EEPROM_TS_MODE;
> @@ -859,18 +858,16 @@ static int af9015_read_config(struct usb_device *udev)
>
>   	/* Set adapter0 buffer size according to USB port speed, adapter1 buffer
>   	   size can be static because it is enabled only USB2.0 */
> -	for (i = 0; i<  af9015_properties_count; i++) {
> -		/* USB1.1 set smaller buffersize and disable 2nd adapter */
> -		if (udev->speed == USB_SPEED_FULL) {
> -			af9015_properties[i].adapter[0].fe[0].stream.u.bulk.buffersize
> -				= TS_USB11_FRAME_SIZE;
> -			/* disable 2nd adapter because we don't have
> +	/* USB1.1 set smaller buffersize and disable 2nd adapter */
> +	if (udev->speed == USB_SPEED_FULL) {
> +		props->adapter[0].fe[0].stream.u.bulk.buffersize
> +			= TS_USB11_FRAME_SIZE;
> +		/* disable 2nd adapter because we don't have
>   			   PID-filters */
> -			af9015_config.dual_mode = 0;
> -		} else {
> -			af9015_properties[i].adapter[0].fe[0].stream.u.bulk.buffersize
> -				= TS_USB20_FRAME_SIZE;
> -		}
> +		af9015_config.dual_mode = 0;
> +	} else {
> +		props->adapter[0].fe[0].stream.u.bulk.buffersize
> +			= TS_USB20_FRAME_SIZE;
>   	}
>
>   	if (af9015_config.dual_mode) {
> @@ -882,16 +879,11 @@ static int af9015_read_config(struct usb_device *udev)
>   		af9015_af9013_config[1].demod_address = val;
>
>   		/* enable 2nd adapter */
> -		for (i = 0; i<  af9015_properties_count; i++)
> -			af9015_properties[i].num_adapters = 2;
> +		props->num_adapters = 2;
> +	} else /* disable 2nd adapter */
> +		props->num_adapters = 1;
>
> -	} else {
> -		 /* disable 2nd adapter */
> -		for (i = 0; i<  af9015_properties_count; i++)
> -			af9015_properties[i].num_adapters = 1;
> -	}
> -
> -	for (i = 0; i<  af9015_properties[0].num_adapters; i++) {
> +	for (i = 0; i<  props->num_adapters; i++) {
>   		if (i == 1)
>   			offset = AF9015_EEPROM_OFFSET;
>   		/* xtal */
> @@ -995,8 +987,7 @@ error:
>   		/* disable dual mode */
>   		af9015_config.dual_mode = 0;
>   		 /* disable 2nd adapter */
> -		for (i = 0; i<  af9015_properties_count; i++)
> -			af9015_properties[i].num_adapters = 1;
> +		props->num_adapters = 1;
>
>   		/* set correct IF */
>   		af9015_af9013_config[0].tuner_if = 4570;
> @@ -1014,6 +1005,10 @@ static int af9015_identify_state(struct usb_device *udev,
>   	u8 reply;
>   	struct req_t req = {GET_CONFIG, 0, 0, 0, 0, 1,&reply};
>
> +	ret = af9015_read_config(udev, props);
> +	if (ret)
> +		return ret;
> +
>   	ret = af9015_rw_udev(udev,&req);
>   	if (ret)
>   		return ret;
> @@ -1675,33 +1670,21 @@ static int af9015_usb_probe(struct usb_interface *intf,
>   {
>   	int ret = 0;
>   	struct dvb_usb_device *d = NULL;
> -	struct usb_device *udev = interface_to_usbdev(intf);
>   	u8 i;
>
> -	deb_info("%s: interface:%d\n", __func__,
> -		intf->cur_altsetting->desc.bInterfaceNumber);
> -
> -	/* interface 0 is used by DVB-T receiver and
> -	   interface 1 is for remote controller (HID) */
> -	if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {
> -		ret = af9015_read_config(udev);
> -		if (ret)
> -			return ret;
> -
> -		for (i = 0; i<  af9015_properties_count; i++) {
> -			ret = dvb_usb_device_init(intf,&af9015_properties[i],
> -				THIS_MODULE,&d, adapter_nr);
> -			if (!ret)
> -				break;
> -			if (ret != -ENODEV)
> -				return ret;
> -		}
> -		if (ret)
> +	for (i = 0; i<  af9015_properties_count; i++) {
> +		ret = dvb_usb_device_init(intf,&af9015_properties[i],
> +			THIS_MODULE,&d, adapter_nr);
> +		if (!ret)
> +			break;
> +		if (ret != -ENODEV)
>   			return ret;
> -
> -		if (d)
> -			ret = af9015_init(d);
>   	}
> +	if (ret)
> +		return ret;
> +
> +	if (d)
> +		ret = af9015_init(d);
>
>   	return ret;
>   }


-- 
http://palosaari.fi/
