Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42856 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2JCAmS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 20:42:18 -0400
Message-ID: <506B89D3.7030405@iki.fi>
Date: Wed, 03 Oct 2012 03:41:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 7/7] [media] dw2102: Declare MODULE_FIRMWARE usage
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com> <1348837172-11784-8-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1348837172-11784-8-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/usb/dvb-usb/dw2102.c |   36 ++++++++++++++++++++++++++----------
>   1 file changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 9382895..937c744 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -80,6 +80,15 @@
>   #define DW2102_RC_QUERY (0x1a00)
>   #define DW2102_LED_CTRL (0x1b00)
>
> +#define DW2101_FIRMWARE "dvb-usb-dw2101.fw"
> +#define DW2102_FIRMWARE "dvb-usb-dw2102.fw"
> +#define DW2104_FIRMWARE "dvb-usb-dw2104.fw"
> +#define DW3101_FIRMWARE "dvb-usb-dw3101.fw"
> +#define S630_FIRMWARE   "dvb-usb-s630.fw"
> +#define S660_FIRMWARE   "dvb-usb-s660.fw"
> +#define P1100_FIRMWARE  "dvb-usb-p1100.fw"
> +#define P7500_FIRMWARE  "dvb-usb-p7500.fw"
> +
>   #define	err_str "did not find the firmware file. (%s) " \
>   		"Please see linux/Documentation/dvb/ for more details " \
>   		"on firmware-problems."
> @@ -1478,13 +1487,12 @@ static int dw2102_load_firmware(struct usb_device *dev,
>   	u8 reset;
>   	u8 reset16[] = {0, 0, 0, 0, 0, 0, 0};
>   	const struct firmware *fw;
> -	const char *fw_2101 = "dvb-usb-dw2101.fw";
>
>   	switch (dev->descriptor.idProduct) {
>   	case 0x2101:
> -		ret = request_firmware(&fw, fw_2101, &dev->dev);
> +		ret = request_firmware(&fw, DW2101_FIRMWARE, &dev->dev);
>   		if (ret != 0) {
> -			err(err_str, fw_2101);
> +			err(err_str, DW2101_FIRMWARE);
>   			return ret;
>   		}
>   		break;
> @@ -1586,7 +1594,7 @@ static int dw2102_load_firmware(struct usb_device *dev,
>   static struct dvb_usb_device_properties dw2102_properties = {
>   	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
>   	.usb_ctrl = DEVICE_SPECIFIC,
> -	.firmware = "dvb-usb-dw2102.fw",
> +	.firmware = DW2102_FIRMWARE,
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &dw2102_serit_i2c_algo,
> @@ -1641,7 +1649,7 @@ static struct dvb_usb_device_properties dw2102_properties = {
>   static struct dvb_usb_device_properties dw2104_properties = {
>   	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
>   	.usb_ctrl = DEVICE_SPECIFIC,
> -	.firmware = "dvb-usb-dw2104.fw",
> +	.firmware = DW2104_FIRMWARE,
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &dw2104_i2c_algo,
> @@ -1691,7 +1699,7 @@ static struct dvb_usb_device_properties dw2104_properties = {
>   static struct dvb_usb_device_properties dw3101_properties = {
>   	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
>   	.usb_ctrl = DEVICE_SPECIFIC,
> -	.firmware = "dvb-usb-dw3101.fw",
> +	.firmware = DW3101_FIRMWARE,
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &dw3101_i2c_algo,
> @@ -1739,7 +1747,7 @@ static struct dvb_usb_device_properties s6x0_properties = {
>   	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
>   	.usb_ctrl = DEVICE_SPECIFIC,
>   	.size_of_priv = sizeof(struct s6x0_state),
> -	.firmware = "dvb-usb-s630.fw",
> +	.firmware = S630_FIRMWARE,
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &s6x0_i2c_algo,
> @@ -1879,7 +1887,7 @@ static int dw2102_probe(struct usb_interface *intf,
>   		return -ENOMEM;
>   	/* copy default structure */
>   	/* fill only different fields */
> -	p1100->firmware = "dvb-usb-p1100.fw";
> +	p1100->firmware = P1100_FIRMWARE;
>   	p1100->devices[0] = d1100;
>   	p1100->rc.legacy.rc_map_table = rc_map_tbs_table;
>   	p1100->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
> @@ -1891,7 +1899,7 @@ static int dw2102_probe(struct usb_interface *intf,
>   		kfree(p1100);
>   		return -ENOMEM;
>   	}
> -	s660->firmware = "dvb-usb-s660.fw";
> +	s660->firmware = S660_FIRMWARE;
>   	s660->num_device_descs = 3;
>   	s660->devices[0] = d660;
>   	s660->devices[1] = d480_1;
> @@ -1905,7 +1913,7 @@ static int dw2102_probe(struct usb_interface *intf,
>   		kfree(s660);
>   		return -ENOMEM;
>   	}
> -	p7500->firmware = "dvb-usb-p7500.fw";
> +	p7500->firmware = P7500_FIRMWARE;
>   	p7500->devices[0] = d7500;
>   	p7500->rc.legacy.rc_map_table = rc_map_tbs_table;
>   	p7500->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
> @@ -1949,3 +1957,11 @@ MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
>   				" Geniatech SU3000 devices");
>   MODULE_VERSION("0.1");
>   MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(DW2101_FIRMWARE);
> +MODULE_FIRMWARE(DW2102_FIRMWARE);
> +MODULE_FIRMWARE(DW2104_FIRMWARE);
> +MODULE_FIRMWARE(DW3101_FIRMWARE);
> +MODULE_FIRMWARE(S630_FIRMWARE);
> +MODULE_FIRMWARE(S660_FIRMWARE);
> +MODULE_FIRMWARE(P1100_FIRMWARE);
> +MODULE_FIRMWARE(P7500_FIRMWARE);
>


-- 
http://palosaari.fi/
