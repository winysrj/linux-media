Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60721 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3AAVzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 16:55:06 -0500
Message-ID: <50E35B16.4080503@iki.fi>
Date: Tue, 01 Jan 2013 23:54:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 05/17] fc0012: use struct for driver config
References: <1355082988-6211-1-git-send-email-crope@iki.fi> <1355082988-6211-5-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-5-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans-Frieder,
Care to ack fc0012 related changes from that patch serie?

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035

6cfc01f fc0012: remove unused callback and correct one comment
2e9fffb fc0012: use Kernel dev_foo() logging
909d2c0 fc0012: rework attach() to check chip id and I/O errors
4a6831e fc0012: use config directly from the config struct
52728ff fc0012: enable clock output on attach()
b6262d2 fc0012: add RF loop through
cb5bd3d fc0012: use struct for driver config

I will pull request these in next days anyway.

regards
Antti


On 12/09/2012 09:56 PM, Antti Palosaari wrote:
> I need even more configuration options and overloading dvb_attach()
> for all those sounds quite stupid. Due to that switch struct and make
> room for new options.
>
> Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/tuners/fc0012.c           |  9 ++++-----
>   drivers/media/tuners/fc0012.h           | 20 ++++++++++++++++----
>   drivers/media/usb/dvb-usb-v2/af9035.c   | 10 ++++++++--
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  7 ++++++-
>   4 files changed, 34 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
> index 308135a..5ede0c0 100644
> --- a/drivers/media/tuners/fc0012.c
> +++ b/drivers/media/tuners/fc0012.c
> @@ -436,8 +436,7 @@ static const struct dvb_tuner_ops fc0012_tuner_ops = {
>   };
>
>   struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> -	struct i2c_adapter *i2c, u8 i2c_address, int dual_master,
> -	enum fc001x_xtal_freq xtal_freq)
> +	struct i2c_adapter *i2c, const struct fc0012_config *cfg)
>   {
>   	struct fc0012_priv *priv = NULL;
>
> @@ -446,9 +445,9 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
>   		return NULL;
>
>   	priv->i2c = i2c;
> -	priv->dual_master = dual_master;
> -	priv->addr = i2c_address;
> -	priv->xtal_freq = xtal_freq;
> +	priv->dual_master = cfg->dual_master;
> +	priv->addr = cfg->i2c_address;
> +	priv->xtal_freq = cfg->xtal_freq;
>
>   	info("Fitipower FC0012 successfully attached.");
>
> diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
> index 4dbd5ef..41946f8 100644
> --- a/drivers/media/tuners/fc0012.h
> +++ b/drivers/media/tuners/fc0012.h
> @@ -24,17 +24,29 @@
>   #include "dvb_frontend.h"
>   #include "fc001x-common.h"
>
> +struct fc0012_config {
> +	/*
> +	 * I2C address
> +	 */
> +	u8 i2c_address;
> +
> +	/*
> +	 * clock
> +	 */
> +	enum fc001x_xtal_freq xtal_freq;
> +
> +	int dual_master;
> +};
> +
>   #if defined(CONFIG_MEDIA_TUNER_FC0012) || \
>   	(defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
>   extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
>   					struct i2c_adapter *i2c,
> -					u8 i2c_address, int dual_master,
> -					enum fc001x_xtal_freq xtal_freq);
> +					const struct fc0012_config *cfg);
>   #else
>   static inline struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
>   					struct i2c_adapter *i2c,
> -					u8 i2c_address, int dual_master,
> -					enum fc001x_xtal_freq xtal_freq)
> +					const struct fc0012_config *cfg)
>   {
>   	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>   	return NULL;
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index d1beb7f..6cf9ad5 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -900,6 +900,12 @@ static const struct fc2580_config af9035_fc2580_config = {
>   	.clock = 16384000,
>   };
>
> +static const struct fc0012_config af9035_fc0012_config = {
> +	.i2c_address = 0x63,
> +	.xtal_freq = FC_XTAL_36_MHZ,
> +	.dual_master = 1,
> +};
> +
>   static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
>   {
>   	struct state *state = adap_to_priv(adap);
> @@ -1043,8 +1049,8 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
>
>   		usleep_range(10000, 50000);
>
> -		fe = dvb_attach(fc0012_attach, adap->fe[0], &d->i2c_adap, 0x63,
> -				1, FC_XTAL_36_MHZ);
> +		fe = dvb_attach(fc0012_attach, adap->fe[0], &d->i2c_adap,
> +				&af9035_fc0012_config);
>   		break;
>   	default:
>   		fe = NULL;
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index a4c302d..eddda69 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -835,6 +835,11 @@ static struct tua9001_config rtl2832u_tua9001_config = {
>   	.i2c_addr = 0x60,
>   };
>
> +static const struct fc0012_config rtl2832u_fc0012_config = {
> +	.i2c_address = 0x63, /* 0xc6 >> 1 */
> +	.xtal_freq = FC_XTAL_28_8_MHZ,
> +};
> +
>   static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>   {
>   	int ret;
> @@ -847,7 +852,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>   	switch (priv->tuner) {
>   	case TUNER_RTL2832_FC0012:
>   		fe = dvb_attach(fc0012_attach, adap->fe[0],
> -			&d->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
> +			&d->i2c_adap, &rtl2832u_fc0012_config);
>
>   		/* since fc0012 includs reading the signal strength delegate
>   		 * that to the tuner driver */
>


-- 
http://palosaari.fi/
