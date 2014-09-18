Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36552 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaIRMbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:31:20 -0400
Date: Thu, 18 Sep 2014 09:31:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/8] anysee: convert tda18212 tuner to I2C client
Message-ID: <20140918093115.4e37c3a7@recife.lan>
In-Reply-To: <1410055200-32170-3-git-send-email-crope@iki.fi>
References: <1410055200-32170-1-git-send-email-crope@iki.fi>
	<1410055200-32170-3-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  7 Sep 2014 04:59:55 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Used tda18212 tuner is implemented as I2C driver. Implement I2C
> client to anysee and use it for tda18212.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/anysee.c | 185 +++++++++++++++++++++++++++-------
>  drivers/media/usb/dvb-usb-v2/anysee.h |   3 +
>  2 files changed, 152 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
> index e4a2382..d3c5f23 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> @@ -332,7 +332,6 @@ static struct tda10023_config anysee_tda10023_tda18212_config = {
>  };
>  
>  static struct tda18212_config anysee_tda18212_config = {
> -	.i2c_address = (0xc0 >> 1),
>  	.if_dvbt_6 = 4150,
>  	.if_dvbt_7 = 4150,
>  	.if_dvbt_8 = 4150,
> @@ -340,7 +339,6 @@ static struct tda18212_config anysee_tda18212_config = {
>  };
>  
>  static struct tda18212_config anysee_tda18212_config2 = {
> -	.i2c_address = 0x60 /* (0xc0 >> 1) */,
>  	.if_dvbt_6 = 3550,
>  	.if_dvbt_7 = 3700,
>  	.if_dvbt_8 = 4150,
> @@ -632,6 +630,92 @@ error:
>  	return ret;
>  }
>  
> +static int anysee_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
> +		void *platform_data)
> +{
> +	int ret, num;
> +	struct anysee_state *state = d_to_priv(d);
> +	struct i2c_client *client;
> +	struct i2c_adapter *adapter = &d->i2c_adap;
> +	struct i2c_board_info board_info = {
> +		.addr = addr,
> +		.platform_data = platform_data,
> +	};
> +
> +	strlcpy(board_info.type, type, I2C_NAME_SIZE);
> +
> +	/* find first free client */
> +	for (num = 0; num < ANYSEE_I2C_CLIENT_MAX; num++) {
> +		if (state->i2c_client[num] == NULL)
> +			break;
> +	}
> +
> +	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
> +
> +	if (num == ANYSEE_I2C_CLIENT_MAX) {
> +		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
> +				KBUILD_MODNAME);
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	request_module(board_info.type);
> +
> +	/* register I2C device */
> +	client = i2c_new_device(adapter, &board_info);
> +	if (client == NULL || client->dev.driver == NULL) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	/* increase I2C driver usage count */
> +	if (!try_module_get(client->dev.driver->owner)) {
> +		i2c_unregister_device(client);
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	state->i2c_client[num] = client;
> +	return 0;
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	return ret;
> +}
> +
> +static void anysee_del_i2c_dev(struct dvb_usb_device *d)
> +{
> +	int num;
> +	struct anysee_state *state = d_to_priv(d);
> +	struct i2c_client *client;
> +
> +	/* find last used client */
> +	num = ANYSEE_I2C_CLIENT_MAX;
> +	while (num--) {
> +		if (state->i2c_client[num] != NULL)
> +			break;
> +	}
> +
> +	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
> +
> +	if (num == -1) {
> +		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
> +				KBUILD_MODNAME);
> +		goto err;
> +	}
> +
> +	client = state->i2c_client[num];
> +
> +	/* decrease I2C driver usage count */
> +	module_put(client->dev.driver->owner);
> +
> +	/* unregister I2C device */
> +	i2c_unregister_device(client);
> +
> +	state->i2c_client[num] = NULL;
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed\n", __func__);
> +}
> +

Please, instead of adding a function to insert/remove an I2C driver on every
place, put them into a common place.

I would actually very much prefer if you could reuse the same code that
are already at the media subsystem (see v4l2_i2c_new_subdev_board &
friends at drivers/media/v4l2-core/v4l2-common.c), eventually making it
more generic.

Btw, as we want to use the media controller also for DVB, we'll end
by needing to use a call similar to v4l2_device_register_subdev().
So, having this code all on just one place will make easier for us to
go to this next step.

>  static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
>  {
>  	struct anysee_state *state = adap_to_priv(adap);
> @@ -640,12 +724,12 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
>  	u8 tmp;
>  	struct i2c_msg msg[2] = {
>  		{
> -			.addr = anysee_tda18212_config.i2c_address,
> +			.addr = 0x60,
>  			.flags = 0,
>  			.len = 1,
>  			.buf = "\x00",
>  		}, {
> -			.addr = anysee_tda18212_config.i2c_address,
> +			.addr = 0x60,
>  			.flags = I2C_M_RD,
>  			.len = 1,
>  			.buf = &tmp,
> @@ -723,9 +807,11 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
>  		/* probe TDA18212 */
>  		tmp = 0;
>  		ret = i2c_transfer(&d->i2c_adap, msg, 2);
> -		if (ret == 2 && tmp == 0xc7)
> +		if (ret == 2 && tmp == 0xc7) {
>  			dev_dbg(&d->udev->dev, "%s: TDA18212 found\n",
>  					__func__);
> +			state->has_tda18212 = true;
> +		}
>  		else
>  			tmp = 0;
>  
> @@ -939,46 +1025,63 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
>  		 * fails attach old simple PLL. */
>  
>  		/* attach tuner */
> -		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
> -				&anysee_tda18212_config);
> +		if (state->has_tda18212) {
> +			struct tda18212_config tda18212_config =
> +					anysee_tda18212_config;
>  
> -		if (fe && adap->fe[1]) {
> -			/* attach tuner for 2nd FE */
> -			fe = dvb_attach(tda18212_attach, adap->fe[1],
> -					&d->i2c_adap, &anysee_tda18212_config);
> -			break;
> -		} else if (fe) {
> -			break;
> -		}
> -
> -		/* attach tuner */
> -		fe = dvb_attach(dvb_pll_attach, adap->fe[0], (0xc0 >> 1),
> -				&d->i2c_adap, DVB_PLL_SAMSUNG_DTOS403IH102A);
> +			tda18212_config.fe = adap->fe[0];
> +			ret = anysee_add_i2c_dev(d, "tda18212", 0x60,
> +					&tda18212_config);
> +			if (ret)
> +				goto err;
> +
> +			/* copy tuner ops for 2nd FE as tuner is shared */
> +			if (adap->fe[1]) {
> +				adap->fe[1]->tuner_priv =
> +						adap->fe[0]->tuner_priv;
> +				memcpy(&adap->fe[1]->ops.tuner_ops,
> +						&adap->fe[0]->ops.tuner_ops,
> +						sizeof(struct dvb_tuner_ops));
> +			}
>  
> -		if (fe && adap->fe[1]) {
> -			/* attach tuner for 2nd FE */
> -			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
> +			return 0;
> +		} else {
> +			/* attach tuner */
> +			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
>  					(0xc0 >> 1), &d->i2c_adap,
>  					DVB_PLL_SAMSUNG_DTOS403IH102A);

Please don't use dvb_attach() for those converted modules. The
dvb_attach() is a very dirty hack that was created as an alternative
to provide an abstraction similar to the one that the I2C core already
provides. See how V4L calls the subdev callbacks at
include/media/v4l2-subdev.h.

One of the big disadvantages of the dvb_attach() is that it allows just
_one_ entry point function on a sub-device. This only works for very
simple demods that don't provide, for example, hardware filtering.

> +
> +			if (fe && adap->fe[1]) {
> +				/* attach tuner for 2nd FE */
> +				fe = dvb_attach(dvb_pll_attach, adap->fe[1],
> +						(0xc0 >> 1), &d->i2c_adap,
> +						DVB_PLL_SAMSUNG_DTOS403IH102A);
> +			}
>  		}
>  
>  		break;
>  	case ANYSEE_HW_508TC: /* 18 */
>  	case ANYSEE_HW_508PTC: /* 21 */
> +	{
>  		/* E7 TC */
>  		/* E7 PTC */
> +		struct tda18212_config tda18212_config = anysee_tda18212_config;
>  
> -		/* attach tuner */
> -		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
> -				&anysee_tda18212_config);
> -
> -		if (fe) {
> -			/* attach tuner for 2nd FE */
> -			fe = dvb_attach(tda18212_attach, adap->fe[1],
> -					&d->i2c_adap, &anysee_tda18212_config);
> +		tda18212_config.fe = adap->fe[0];
> +		ret = anysee_add_i2c_dev(d, "tda18212", 0x60, &tda18212_config);
> +		if (ret)
> +			goto err;
> +
> +		/* copy tuner ops for 2nd FE as tuner is shared */
> +		if (adap->fe[1]) {
> +			adap->fe[1]->tuner_priv = adap->fe[0]->tuner_priv;
> +			memcpy(&adap->fe[1]->ops.tuner_ops,
> +					&adap->fe[0]->ops.tuner_ops,
> +					sizeof(struct dvb_tuner_ops));
>  		}
>  
> -		break;
> +		return 0;
> +	}
>  	case ANYSEE_HW_508S2: /* 19 */
>  	case ANYSEE_HW_508PS2: /* 22 */
>  		/* E7 S2 */
> @@ -997,13 +1100,18 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
>  		break;
>  
>  	case ANYSEE_HW_508T2C: /* 20 */
> +	{
>  		/* E7 T2C */
> +		struct tda18212_config tda18212_config =
> +				anysee_tda18212_config2;
>  
> -		/* attach tuner */
> -		fe = dvb_attach(tda18212_attach, adap->fe[0], &d->i2c_adap,
> -				&anysee_tda18212_config2);
> +		tda18212_config.fe = adap->fe[0];
> +		ret = anysee_add_i2c_dev(d, "tda18212", 0x60, &tda18212_config);
> +		if (ret)
> +			goto err;
>  
> -		break;
> +		return 0;
> +	}
>  	default:
>  		fe = NULL;
>  	}
> @@ -1012,7 +1120,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
>  		ret = 0;
>  	else
>  		ret = -ENODEV;
> -
> +err:
>  	return ret;
>  }
>  
> @@ -1270,6 +1378,11 @@ static int anysee_init(struct dvb_usb_device *d)
>  
>  static void anysee_exit(struct dvb_usb_device *d)
>  {
> +	struct anysee_state *state = d_to_priv(d);
> +
> +	if (state->i2c_client[0])
> +		anysee_del_i2c_dev(d);
> +
>  	return anysee_ci_release(d);
>  }
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
> index 8f426d9..3ca2bca 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.h
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.h
> @@ -55,8 +55,11 @@ struct anysee_state {
>  	u8 buf[64];
>  	u8 seq;
>  	u8 hw; /* PCB ID */
> +	#define ANYSEE_I2C_CLIENT_MAX 1
> +	struct i2c_client *i2c_client[ANYSEE_I2C_CLIENT_MAX];
>  	u8 fe_id:1; /* frondend ID */
>  	u8 has_ci:1;
> +	u8 has_tda18212:1;
>  	u8 ci_attached:1;
>  	struct dvb_ca_en50221 ci;
>  	unsigned long ci_cam_ready; /* jiffies */
