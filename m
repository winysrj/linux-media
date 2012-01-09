Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48718 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab2AIRlA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jan 2012 12:41:00 -0500
Message-ID: <4F0B26A1.2020402@iki.fi>
Date: Mon, 09 Jan 2012 19:40:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] af9013: change & to &&
References: <20120105062328.GA25744@elgon.mountain>
In-Reply-To: <20120105062328.GA25744@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clear bug, I will test it later when applied to master if not already. 
Thanks!

Acked-by: Antti Palosaari <crope@iki.fi>


On 01/05/2012 08:23 AM, Dan Carpenter wrote:
> This is just a cleanup, it doesn't change how the code works.  These
> are compound conditions and not bitwise operations so it should be&&
> and not&.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
> index e6ba3e0..1413c51 100644
> --- a/drivers/media/dvb/frontends/af9013.c
> +++ b/drivers/media/dvb/frontends/af9013.c
> @@ -120,8 +120,8 @@ static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
>   	int ret, i;
>   	u8 mbox = (0<<  7)|(0<<  6)|(1<<  1)|(1<<  0);
>
> -	if ((priv->config.ts_mode == AF9013_TS_USB)&
> -		((reg&  0xff00) != 0xff00)&  ((reg&  0xff00) != 0xae00)) {
> +	if ((priv->config.ts_mode == AF9013_TS_USB)&&
> +		((reg&  0xff00) != 0xff00)&&  ((reg&  0xff00) != 0xae00)) {
>   		mbox |= ((len - 1)<<  2);
>   		ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
>   	} else {
> @@ -142,8 +142,8 @@ static int af9013_rd_regs(struct af9013_state *priv, u16 reg, u8 *val, int len)
>   	int ret, i;
>   	u8 mbox = (0<<  7)|(0<<  6)|(1<<  1)|(0<<  0);
>
> -	if ((priv->config.ts_mode == AF9013_TS_USB)&
> -		((reg&  0xff00) != 0xff00)&  ((reg&  0xff00) != 0xae00)) {
> +	if ((priv->config.ts_mode == AF9013_TS_USB)&&
> +		((reg&  0xff00) != 0xff00)&&  ((reg&  0xff00) != 0xae00)) {
>   		mbox |= ((len - 1)<<  2);
>   		ret = af9013_rd_regs_i2c(priv, mbox, reg, val, len);
>   	} else {


-- 
http://palosaari.fi/
