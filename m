Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56709 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaFKXTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 19:19:55 -0400
Message-ID: <5398E418.2070806@iki.fi>
Date: Thu, 12 Jun 2014 02:19:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH]cxd2820r: TS clock inversion in config
References: <5029507.eCaNK20ghe@computer>
In-Reply-To: <5029507.eCaNK20ghe@computer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>
Acked-by: Antti Palosaari <crope@iki.fi>


On 06/03/2014 08:19 PM, CrazyCat wrote:
> TS clock inversion in config.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
>   drivers/media/dvb-frontends/cxd2820r.h    | 6 ++++++
>   drivers/media/dvb-frontends/cxd2820r_c.c  | 1 +
>   drivers/media/dvb-frontends/cxd2820r_t.c  | 1 +
>   drivers/media/dvb-frontends/cxd2820r_t2.c | 1 +
>   4 files changed, 9 insertions(+)
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
>


-- 
http://palosaari.fi/
