Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59303 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493AbaGOLIS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 07:08:18 -0400
Message-ID: <53C50BA0.2000800@iki.fi>
Date: Tue, 15 Jul 2014 14:08:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] si2157: Add support for spectrum inversion
References: <1405411120-9569-1-git-send-email-zzam@gentoo.org> <1405411120-9569-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1405411120-9569-2-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Matthias!
Idea of patch is correct, but I think implementation not. You set FE to 
si2157_config on variable define, but on that point FE is NULL. FE 
pointer is populated by demodulator driver, si2168. Right?

And you could split that to 3 patches too, one for prepare em28xx, one 
for cxusb and last is patch itself.

regards
Antti


On 07/15/2014 10:58 AM, Matthias Schwarzott wrote:
> This is needed for PCTV 522e support.
> Modify all users of si2157_config to correctly initialize all not
> mentioned values to 0.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/tuners/si2157.c         | 3 +++
>   drivers/media/tuners/si2157.h         | 5 +++++
>   drivers/media/tuners/si2157_priv.h    | 1 +
>   drivers/media/usb/dvb-usb/cxusb.c     | 3 +--
>   drivers/media/usb/em28xx/em28xx-dvb.c | 5 +++--
>   5 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 329004f..4dbd3f1 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -253,6 +253,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
>
>   	memcpy(cmd.args, "\x14\x00\x03\x07\x00\x00", 6);
>   	cmd.args[4] = delivery_system | bandwidth;
> +	if (s->inversion)
> +		cmd.args[5] = 0x01;
>   	cmd.wlen = 6;
>   	cmd.rlen = 1;
>   	ret = si2157_cmd_execute(s, &cmd);
> @@ -307,6 +309,7 @@ static int si2157_probe(struct i2c_client *client,
>
>   	s->client = client;
>   	s->fe = cfg->fe;
> +	s->inversion = cfg->inversion;
>   	mutex_init(&s->i2c_mutex);
>
>   	/* check if the tuner is there */
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index 4465c46..6da4d5d 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -29,6 +29,11 @@ struct si2157_config {
>   	 * frontend
>   	 */
>   	struct dvb_frontend *fe;
> +
> +	/*
> +	 * Spectral Inversion
> +	 */
> +	bool inversion;
>   };
>
>   #endif
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index db79f3c..3ddab5e 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -26,6 +26,7 @@ struct si2157 {
>   	struct i2c_client *client;
>   	struct dvb_frontend *fe;
>   	bool active;
> +	bool inversion;
>   };
>
>   /* firmare command struct */
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index ad20c39..c94a704 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1337,7 +1337,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>   	struct i2c_client *client_tuner;
>   	struct i2c_board_info info;
>   	struct si2168_config si2168_config;
> -	struct si2157_config si2157_config;
> +	struct si2157_config si2157_config = { .fe = adap->fe_adap[0].fe };
>
>   	/* reset the tuner */
>   	if (cxusb_tt_ct2_4400_gpio_tuner(d, 0) < 0) {
> @@ -1371,7 +1371,6 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>   	st->i2c_client_demod = client_demod;
>
>   	/* attach tuner */
> -	si2157_config.fe = adap->fe_adap[0].fe;
>   	memset(&info, 0, sizeof(struct i2c_board_info));
>   	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
>   	info.addr = 0x60;
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index a121ed9..d472dc9 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1520,7 +1520,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   			struct i2c_client *client;
>   			struct i2c_board_info info;
>   			struct si2168_config si2168_config;
> -			struct si2157_config si2157_config;
> +			struct si2157_config si2157_config = {
> +				.fe = dvb->fe[0]
> +			};
>
>   			/* attach demod */
>   			si2168_config.i2c_adapter = &adapter;
> @@ -1545,7 +1547,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   			dvb->i2c_client_demod = client;
>
>   			/* attach tuner */
> -			si2157_config.fe = dvb->fe[0];
>   			memset(&info, 0, sizeof(struct i2c_board_info));
>   			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
>   			info.addr = 0x60;
>

-- 
http://palosaari.fi/
