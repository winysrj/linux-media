Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab2IWXR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 19:17:56 -0400
Date: Sun, 23 Sep 2012 20:17:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/16] rtl2830: use .get_if_frequency()
Message-ID: <20120923201742.4eaf7455@redhat.com>
In-Reply-To: <1347495837-3244-7-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
	<1347495837-3244-7-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Sep 2012 03:23:48 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Use .get_if_frequency() as all used tuner drivers
> (mt2060/qt1010/mxl5005s) supports it.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

> @@ -240,26 +237,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
>  	if (ret)
>  		goto err;
>  
> -	num = priv->cfg.if_dvbt % priv->cfg.xtal;
> -	num *= 0x400000;
> -	num = div_u64(num, priv->cfg.xtal);
> -	num = -num;
> -	if_ctl = num & 0x3fffff;
> -	dev_dbg(&priv->i2c->dev, "%s: if_ctl=%08x\n", __func__, if_ctl);
> -
> -	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
> -	if (ret)
> -		goto err;
> -
> -	buf[0] = tmp << 6;
> -	buf[0] |= (if_ctl >> 16) & 0x3f;
> -	buf[1] = (if_ctl >>  8) & 0xff;
> -	buf[2] = (if_ctl >>  0) & 0xff;

Patch applied, but there was a context difference above:

 --- a/drivers/media/dvb-frontends/rtl2830.c
 +++ b/drivers/media/dvb-frontends/rtl2830.c
 @@ -182,9 +182,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
@@ -28,7 +50,7 @@ index eca1d72..3954760 100644
 -		goto err;
 -
 -	buf[0] = tmp << 6;
--	buf[0] = (if_ctl >> 16) & 0x3f;
+-	buf[0] |= (if_ctl >> 16) & 0x3f;
 -	buf[1] = (if_ctl >>  8) & 0xff;
 -	buf[2] = (if_ctl >>  0) & 0xff;
 -

(that's the diff between the patch applied and your original one)

-- 
Regards,
Mauro
