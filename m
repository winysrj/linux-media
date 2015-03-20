Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCTOlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 10:41:49 -0400
Message-ID: <550C31AA.5040803@iki.fi>
Date: Fri, 20 Mar 2015 16:41:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] m88ts2022: Nested loops shouldn't use the same index
 variable
References: <20150320133738.19894.45270.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150320133738.19894.45270.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/20/2015 03:37 PM, David Howells wrote:
> There are a pair of nested loops inside m88ts2022_cmd() that use the same
> index variable, but for different things.  Split the variable.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

> ---
>
>   drivers/media/tuners/m88ts2022.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
> index 066e543..cdf9fe5 100644
> --- a/drivers/media/tuners/m88ts2022.c
> +++ b/drivers/media/tuners/m88ts2022.c
> @@ -21,7 +21,7 @@
>   static int m88ts2022_cmd(struct m88ts2022_dev *dev, int op, int sleep, u8 reg,
>   		u8 mask, u8 val, u8 *reg_val)
>   {
> -	int ret, i;
> +	int ret, i, j;
>   	unsigned int utmp;
>   	struct m88ts2022_reg_val reg_vals[] = {
>   		{0x51, 0x1f - op},
> @@ -35,9 +35,9 @@ static int m88ts2022_cmd(struct m88ts2022_dev *dev, int op, int sleep, u8 reg,
>   				"i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
>   				i, op, reg, mask, val);
>
> -		for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
> -			ret = regmap_write(dev->regmap, reg_vals[i].reg,
> -					reg_vals[i].val);
> +		for (j = 0; j < ARRAY_SIZE(reg_vals); j++) {
> +			ret = regmap_write(dev->regmap, reg_vals[j].reg,
> +					reg_vals[j].val);
>   			if (ret)
>   				goto err;
>   		}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
