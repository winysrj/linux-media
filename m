Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:58731 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaHFO4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 10:56:12 -0400
Date: Wed, 06 Aug 2014 11:56:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] [media] dvb: fix decimal printf format specifiers
 prefixed with 0x
Message-id: <20140806115607.1946e967.m.chehab@samsung.com>
In-reply-to: <1407300137-32480-1-git-send-email-hans@hanshq.net>
References: <1407300137-32480-1-git-send-email-hans@hanshq.net>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 05 Aug 2014 21:42:17 -0700
Hans Wennborg <hans@hanshq.net> escreveu:

> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/media/dvb-frontends/mb86a16.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
> index 9ae40ab..5939133 100644
> --- a/drivers/media/dvb-frontends/mb86a16.c
> +++ b/drivers/media/dvb-frontends/mb86a16.c
> @@ -115,7 +115,7 @@ static int mb86a16_read(struct mb86a16_state *state, u8 reg, u8 *val)
>  	};
>  	ret = i2c_transfer(state->i2c_adap, msg, 2);
>  	if (ret != 2) {
> -		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%i)",
> +		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%x)",
>  			reg, ret);

Hmm... returning it in hex doesn't make much sense. the better would
be to remove the "0x" prefix here...

>  
>  		return -EREMOTEIO;

Btw, what we're doing on modern drivers is to return the error
as reported by i2c_transfer if it is negative. So, the best would be
to do:
	if (ret < 0)
		return ret;
	return -EREMOTEIO;

Thanks,
Mauro
