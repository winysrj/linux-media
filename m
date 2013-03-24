Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39721 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3CXSTI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 14:19:08 -0400
Message-ID: <514F4375.3060309@iki.fi>
Date: Sun, 24 Mar 2013 20:18:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ua>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r_t2: Multistream support (MultiPLP)
References: <302151362615390@web22d.yandex.ru>
In-Reply-To: <302151362615390@web22d.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there anyone who could test that patch?

I have no multi PLP signal here.

Also there is minor issue on that patch. As stream ID validy is already 
checked there is no reason for bit AND 0xff.


Antti

On 03/07/2013 02:16 AM, CrazyCat wrote:
> MultiPLP filtering support for CXD2820r, not tested.
> Somebody from Russia please test (exclude Moscow, because used singlePLP). Usual used PLP 0 (4TV + 3 radio) and 1 (4TV). PLP 2,3 reserved (regional channels).
>
> P.S. You can use my scan-s2 with multistream support - https://bitbucket.org/CrazyCat/scan-s2. Generated channel list compatible with current VDR 1.7.3x
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
> index 9b658c1..7ca5c69 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_core.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_core.c
> @@ -660,7 +660,8 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
>   			FE_CAN_GUARD_INTERVAL_AUTO	|
>   			FE_CAN_HIERARCHY_AUTO		|
>   			FE_CAN_MUTE_TS			|
> -			FE_CAN_2G_MODULATION
> +			FE_CAN_2G_MODULATION		|
> +			FE_CAN_MULTISTREAM
>   		},
>
>   	.release		= cxd2820r_release,
> diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
> index e82d82a..c2bfea7 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_t2.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
> @@ -124,6 +124,23 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
>   	buf[1] = ((if_ctl >>  8) & 0xff);
>   	buf[2] = ((if_ctl >>  0) & 0xff);
>
> +	/* PLP filtering */
> +	if (c->stream_id < 0 || c->stream_id > 255) {
> +		dev_dbg(&priv->i2c->dev, "%s: Disable PLP filtering\n", __func__);
> +		ret = cxd2820r_wr_reg(priv, 0x023ad , 0);
> +		if (ret)
> +			goto error;
> +	} else {
> +		dev_dbg(&priv->i2c->dev, "%s: Enable PLP filtering = %d\n", __func__,
> +				c->stream_id);
> +		ret = cxd2820r_wr_reg(priv, 0x023af , c->stream_id & 0xFF);
> +		if (ret)
> +			goto error;
> +		ret = cxd2820r_wr_reg(priv, 0x023ad , 1);
> +		if (ret)
> +			goto error;
> +	}
> +
>   	ret = cxd2820r_wr_regs(priv, 0x020b6, buf, 3);
>   	if (ret)
>   		goto error;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
