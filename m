Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57279 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbaEEVLT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 May 2014 17:11:19 -0400
Message-ID: <5367FE75.5040208@iki.fi>
Date: Tue, 06 May 2014 00:11:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r: TS clock inversion in config
References: <6929939.mWPG6Zt5A4@ubuntu>
In-Reply-To: <6929939.mWPG6Zt5A4@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch does more than it says and due to that I don't want it. Just 
implement cxd2820r clock inversion and nothing more. Put the rest stuff, 
which does not belong to cxd2820r, to another patch.

Antti



On 05.05.2014 23:46, CrazyCat wrote:
> TS clock inversion in config.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
>
> diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
> index 82b3d93..6095dbc 100644
> --- a/drivers/media/dvb-frontends/cxd2820r.h
> +++ b/drivers/media/dvb-frontends/cxd2820r.h
> @@ -52,6 +52,12 @@ struct cxd2820r_config {
>   	 */
>   	u8 ts_mode;
>
> +	/* TS clock inverted.
> +	 * Default: 0
> +	 * Values: 0, 1
> +	 */
> +	bool ts_clock_inv;
> +
>   	/* IF AGC polarity.
>   	 * Default: 0
>   	 * Values: 0, 1
> diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
> index 5c6ab49..0f4657e 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_c.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_c.c
> @@ -45,6 +45,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
>   		{ 0x1008b, 0x07, 0xff },
>   		{ 0x1001f, priv->cfg.if_agc_polarity << 7, 0x80 },
>   		{ 0x10070, priv->cfg.ts_mode, 0xff },
> +		{ 0x10071, !priv->cfg.ts_clock_inv << 4, 0x10 },
>   	};
>
>   	dev_dbg(&priv->i2c->dev, "%s: frequency=%d symbol_rate=%d\n", __func__,
> diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
> index fa184ca..9b5a45b 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_t.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_t.c
> @@ -46,6 +46,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
>   		{ 0x00088, 0x01, 0xff },
>
>   		{ 0x00070, priv->cfg.ts_mode, 0xff },
> +		{ 0x00071, !priv->cfg.ts_clock_inv << 4, 0x10 },
>   		{ 0x000cb, priv->cfg.if_agc_polarity << 6, 0x40 },
>   		{ 0x000a5, 0x00, 0x01 },
>   		{ 0x00082, 0x20, 0x60 },
> diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
> index 2ba130e..9c0c4f4 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_t2.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
> @@ -47,6 +47,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
>   		{ 0x02083, 0x0a, 0xff },
>   		{ 0x020cb, priv->cfg.if_agc_polarity << 6, 0x40 },
>   		{ 0x02070, priv->cfg.ts_mode, 0xff },
> +		{ 0x02071, !priv->cfg.ts_clock_inv << 6, 0x40 },
>   		{ 0x020b5, priv->cfg.spec_inv << 4, 0x10 },
>   		{ 0x02567, 0x07, 0x0f },
>   		{ 0x02569, 0x03, 0x03 },
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index ae0f56a..7135a3e 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -1109,6 +1109,7 @@ static struct ds3000_config su3000_ds3000_config = {
>   static struct cxd2820r_config cxd2820r_config = {
>   	.i2c_address = 0x6c, /* (0xd8 >> 1) */
>   	.ts_mode = 0x38,
> +	.ts_clock_inv = 1,
>   };
>
>   static struct tda18271_config tda18271_config = {
> @@ -1387,20 +1388,27 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
>
>   static int t220_frontend_attach(struct dvb_usb_adapter *d)
>   {
> -	u8 obuf[3] = { 0xe, 0x80, 0 };
> +	u8 obuf[3] = { 0xe, 0x87, 0 };
>   	u8 ibuf[] = { 0 };
>
>   	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
>   		err("command 0x0e transfer failed.");
>
>   	obuf[0] = 0xe;
> -	obuf[1] = 0x83;
> +	obuf[1] = 0x86;
> +	obuf[2] = 1;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x80;
>   	obuf[2] = 0;
>
>   	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
>   		err("command 0x0e transfer failed.");
>
> -	msleep(100);
> +	msleep(50);
>
>   	obuf[0] = 0xe;
>   	obuf[1] = 0x80;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
