Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46756 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaHIWv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 18:51:59 -0400
Message-ID: <53E6A60D.2040901@iki.fi>
Date: Sun, 10 Aug 2014 01:51:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 3/4] cxusb: Add support for TechnoTrend TT-connect CT2-4650
 CI
References: <1407481598-24598-1-git-send-email-olli.salonen@iki.fi> <1407481598-24598-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407481598-24598-3-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

cxusb_ctrl_msg() uses USB buffers from the stack which is no-no. But it 
is old mistake...

regards
Antti

On 08/08/2014 10:06 AM, Olli Salonen wrote:
> TechnoTrend TT-connect CT2-4650 CI (0b48:3012) is an USB DVB-T2/C tuner with
> the following components:
>
>   USB interface: Cypress CY7C68013A-56LTXC
>   Demodulator: Silicon Labs Si2168-A20
>   Tuner: Silicon Labs Si2158-A20
>   CI chip: CIMaX SP2HF
>
> The firmware for the tuner is the same as for TechnoTrend TT-TVStick CT2-4400.
> See https://www.mail-archive.com/linux-media@vger.kernel.org/msg76944.html
>
> The demodulator needs a firmware that can be extracted from the Windows drivers.
> File ttConnect4650_64.sys should be extracted from
> http://www.tt-downloads.de/bda-treiber_4.1.0.4.zip (MD5 sum below).
>
> 3464bfc37a47b4032568718bacba23fb  ttConnect4650_64.sys
>
> Then the firmware can be extracted:
> dd if=ttConnect4650_64.sys ibs=1 skip=273376 count=6424 of=dvb-demod-si2168-a20-01.fw
>
> The SP2 CI module requires a definition of a function cxusb_tt_ct2_4650_ci_ctrl
> that is passed on to the SP2 driver and called back for CAM operations.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/dvb-usb/Kconfig |  2 +-
>   drivers/media/usb/dvb-usb/cxusb.c | 92 ++++++++++++++++++++++++++++++++++++++-
>   drivers/media/usb/dvb-usb/cxusb.h |  4 ++
>   3 files changed, 96 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
> index 10aef21..41d3eb9 100644
> --- a/drivers/media/usb/dvb-usb/Kconfig
> +++ b/drivers/media/usb/dvb-usb/Kconfig
> @@ -130,7 +130,7 @@ config DVB_USB_CXUSB
>
>   	  Medion MD95700 hybrid USB2.0 device.
>   	  DViCO FusionHDTV (Bluebird) USB2.0 devices
> -	  TechnoTrend TVStick CT2-4400
> +	  TechnoTrend TVStick CT2-4400 and CT2-4650 CI devices
>
>   config DVB_USB_M920X
>   	tristate "Uli m920x DVB-T USB2.0 support"
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 16bc579..c3a44c7 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -44,6 +44,7 @@
>   #include "atbm8830.h"
>   #include "si2168.h"
>   #include "si2157.h"
> +#include "sp2.h"
>
>   /* Max transfer size done by I2C transfer functions */
>   #define MAX_XFER_SIZE  80
> @@ -672,6 +673,37 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
>   	{ 0x0025, KEY_POWER },
>   };
>
> +static int cxusb_tt_ct2_4650_ci_ctrl(void *priv, u8 read, int addr,
> +					u8 data, int *mem)
> +{
> +	struct dvb_usb_device *d = priv;
> +	u8 wbuf[3];
> +	u8 rbuf[2];
> +	int ret;
> +
> +	wbuf[0] = (addr >> 8) & 0xff;
> +	wbuf[1] = addr & 0xff;
> +
> +	if (read) {
> +		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_READ, wbuf, 2, rbuf, 2);
> +	} else {
> +		wbuf[2] = data;
> +		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_WRITE, wbuf, 3, rbuf, 1);
> +	}
> +
> +	if (ret)
> +		goto err;
> +
> +	if (read)
> +		*mem = rbuf[1];
> +
> +	return 0;
> +err:
> +	deb_info("%s: ci usb write returned %d\n", __func__, ret);
> +	return ret;
> +
> +}
> +
>   static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
>   {
>   	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
> @@ -1350,9 +1382,12 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>   	struct i2c_adapter *adapter;
>   	struct i2c_client *client_demod;
>   	struct i2c_client *client_tuner;
> +	struct i2c_client *client_ci;
>   	struct i2c_board_info info;
>   	struct si2168_config si2168_config;
>   	struct si2157_config si2157_config;
> +	struct sp2_config sp2_config;
> +	u8 o[2], i;
>
>   	/* reset the tuner */
>   	if (cxusb_tt_ct2_4400_gpio_tuner(d, 0) < 0) {
> @@ -1408,6 +1443,48 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>
>   	st->i2c_client_tuner = client_tuner;
>
> +	/* initialize CI */
> +	if (d->udev->descriptor.idProduct ==
> +		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) {
> +
> +		memcpy(o, "\xc0\x01", 2);
> +		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
> +		msleep(100);
> +
> +		memcpy(o, "\xc0\x00", 2);
> +		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
> +		msleep(100);
> +
> +		memset(&sp2_config, 0, sizeof(sp2_config));
> +		sp2_config.dvb_adap = &adap->dvb_adap;
> +		sp2_config.priv = d;
> +		sp2_config.ci_control = cxusb_tt_ct2_4650_ci_ctrl;
> +		memset(&info, 0, sizeof(struct i2c_board_info));
> +		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
> +		info.addr = 0x40;
> +		info.platform_data = &sp2_config;
> +		request_module(info.type);
> +		client_ci = i2c_new_device(&d->i2c_adap, &info);
> +		if (client_ci == NULL || client_ci->dev.driver == NULL) {
> +			module_put(client_tuner->dev.driver->owner);
> +			i2c_unregister_device(client_tuner);
> +			module_put(client_demod->dev.driver->owner);
> +			i2c_unregister_device(client_demod);
> +			return -ENODEV;
> +		}
> +		if (!try_module_get(client_ci->dev.driver->owner)) {
> +			i2c_unregister_device(client_ci);
> +			module_put(client_tuner->dev.driver->owner);
> +			i2c_unregister_device(client_tuner);
> +			module_put(client_demod->dev.driver->owner);
> +			i2c_unregister_device(client_demod);
> +			return -ENODEV;
> +		}
> +
> +		st->i2c_client_ci = client_ci;
> +
> +	}
> +
>   	return 0;
>   }
>
> @@ -1537,6 +1614,13 @@ static void cxusb_disconnect(struct usb_interface *intf)
>   	struct cxusb_state *st = d->priv;
>   	struct i2c_client *client;
>
> +	/* remove I2C client for CI */
> +	client = st->i2c_client_ci;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
>   	/* remove I2C client for tuner */
>   	client = st->i2c_client_tuner;
>   	if (client) {
> @@ -1576,6 +1660,7 @@ static struct usb_device_id cxusb_table [] = {
>   	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
>   	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
>   	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_TVSTICK_CT2_4400) },
> +	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) },
>   	{}		/* Terminating entry */
>   };
>   MODULE_DEVICE_TABLE (usb, cxusb_table);
> @@ -2265,13 +2350,18 @@ static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
>   		.rc_interval    = 150,
>   	},
>
> -	.num_device_descs = 1,
> +	.num_device_descs = 2,
>   	.devices = {
>   		{
>   			"TechnoTrend TVStick CT2-4400",
>   			{ NULL },
>   			{ &cxusb_table[20], NULL },
>   		},
> +		{
> +			"TechnoTrend TT-connect CT2-4650 CI",
> +			{ NULL },
> +			{ &cxusb_table[21], NULL },
> +		},
>   	}
>   };
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
> index 527ff79..29f3e2e 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.h
> +++ b/drivers/media/usb/dvb-usb/cxusb.h
> @@ -28,10 +28,14 @@
>   #define CMD_ANALOG        0x50
>   #define CMD_DIGITAL       0x51
>
> +#define CMD_SP2_CI_WRITE  0x70
> +#define CMD_SP2_CI_READ   0x71
> +
>   struct cxusb_state {
>   	u8 gpio_write_state[3];
>   	struct i2c_client *i2c_client_demod;
>   	struct i2c_client *i2c_client_tuner;
> +	struct i2c_client *i2c_client_ci;
>   };
>
>   #endif
>

-- 
http://palosaari.fi/
