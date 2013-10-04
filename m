Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38151 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3JDOgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 10:36:49 -0400
Message-ID: <524ED27F.2010803@iki.fi>
Date: Fri, 04 Oct 2013 17:36:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 05/14] cxd2820r_core: fix sparse warnings
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl> <1380895312-30863-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-6-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.10.2013 17:01, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/dvb-frontends/cxd2820r_core.c:34:32: error: cannot size expression
> drivers/media/dvb-frontends/cxd2820r_core.c:68:32: error: cannot size expression
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> Cc: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb-frontends/cxd2820r_core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
> index 7ca5c69..d9eeeb1 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_core.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_core.c
> @@ -31,7 +31,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
>   		{
>   			.addr = i2c,
>   			.flags = 0,
> -			.len = sizeof(buf),
> +			.len = len + 1,
>   			.buf = buf,
>   		}
>   	};
> @@ -65,7 +65,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
>   		}, {
>   			.addr = i2c,
>   			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> +			.len = len,
>   			.buf = buf,
>   		}
>   	};
>


-- 
http://palosaari.fi/
