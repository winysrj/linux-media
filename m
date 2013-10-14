Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50223 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab3JNCb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 22:31:27 -0400
Received: from dyn3-82-128-185-216.psoas.suomi.net ([82.128.185.216] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VVXwL-0007P6-VD
	for linux-media@vger.kernel.org; Mon, 14 Oct 2013 05:31:25 +0300
Message-ID: <525B577D.2050105@iki.fi>
Date: Mon, 14 Oct 2013 05:31:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cannot ret error from probe - switch tuner to I2C driver model
References: <1381709450-14345-1-git-send-email-crope@iki.fi>
In-Reply-To: <1381709450-14345-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.10.2013 03:10, Antti Palosaari wrote:
> kernel: usb 1-2: rtl2832u_tuner_attach:
> kernel: e4000 5-0064: e4000_probe:
> kernel: usb 1-2: rtl2832u_tuner_attach: client ptr ffff88030a849000
>
> See attached patch.
>
> Is there any way to return error to caller?
>
> Abuse platform data ptr from struct i2c_board_info and call i2c_unregister_device() ?

Answer to myself: best option seems to be check i2c_get_clientdata() 
pointer after i2c_new_device().

client = i2c_new_device(&d->i2c_adap, &info);
if (client)
     if (i2c_get_clientdata(client) == NULL)
         // OOPS, I2C probe fails

That is because it is set NULL in error case by really_probe() in 
drivers/base/dd.c. Error status is also cleared there with comment:
/*
  * Ignore errors returned by ->probe so that the next driver can try
  * its luck.
  */

That is told in I2C documentation too:
Note that starting with kernel 2.6.34, you don't have to set the `data' 
field
to NULL in remove() or if probe() failed anymore. The i2c-core does this
automatically on these occasions. Those are also the only times the core 
will
touch this field.



But maybe the comment for actual function, i2c_new_device, is still a 
bit misleading as it says NULL is returned for the error. All the other 
errors yes, but not for the I2C .probe() as it is reseted by device core.

* This returns the new i2c client, which may be saved for later use with
  * i2c_unregister_device(); or NULL to indicate an error.
  */
struct i2c_client *
i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)


regards
Antti


>
> regards
> Antti
>
> ---
>   drivers/media/tuners/e4000.c            | 31 +++++++++++++++++++++++++++++++
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 18 ++++++++++++++++--
>   2 files changed, 47 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index 54e2d8a..f4e0567 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -442,6 +442,37 @@ err:
>   }
>   EXPORT_SYMBOL(e4000_attach);
>
> +static int e4000_probe(struct i2c_client *client, const struct i2c_device_id *did)
> +{
> +	dev_info(&client->dev, "%s:\n", __func__);
> +	return -ENODEV;
> +}
> +
> +static int e4000_remove(struct i2c_client *client)
> +{
> +	dev_info(&client->dev, "%s:\n", __func__);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id e4000_id[] = {
> +	{"e4000", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, e4000_id);
> +
> +static struct i2c_driver e4000_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "e4000",
> +	},
> +	.probe		= e4000_probe,
> +	.remove		= e4000_remove,
> +	.id_table	= e4000_id,
> +};
> +
> +module_i2c_driver(e4000_driver);
> +
>   MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index defc491..fbbe867 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -898,8 +898,22 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>   				adap->fe[0]->ops.tuner_ops.get_rf_strength;
>   		return 0;
>   	case TUNER_RTL2832_E4000:
> -		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
> -				&rtl2832u_e4000_config);
> +//		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
> +//				&rtl2832u_e4000_config);
> +		{
> +			static const struct i2c_board_info info = {
> +				.type = "e4000",
> +				.addr = 0x64,
> +			};
> +			struct i2c_client *client;
> +
> +			fe = NULL;
> +			client = i2c_new_device(&d->i2c_adap, &info);
> +			if (IS_ERR_OR_NULL(client))
> +				dev_err(&d->udev->dev, "e4000 probe failed\n");
> +
> +			dev_dbg(&d->udev->dev, "%s: client ptr %p\n", __func__, client);
> +		}
>   		break;
>   	case TUNER_RTL2832_FC2580:
>   		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
>


-- 
http://palosaari.fi/
