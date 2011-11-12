Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34617 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1KLQzg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:55:36 -0500
Message-ID: <4EBEA506.3030003@iki.fi>
Date: Sat, 12 Nov 2011 18:55:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 7/7] af9013 empty buffer overflow command.
References: <4ebe9734.d4c7e30a.6b0e.ffff9414@mx.google.com>
In-Reply-To: <4ebe9734.d4c7e30a.6b0e.ffff9414@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:56 PM, Malcolm Priestley wrote:
> This command is present in other Afatech devices zeroing bit 7
> seems to force streaming output even if it isn't one.
>
> I was considering timing it out, but it seems to have no harmful effect
> on streaming output.

You didn't find any reason this makes sense?

regards
Antti


>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/frontends/af9013.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
> index 6a5b40c..fbf6bca 100644
> --- a/drivers/media/dvb/frontends/af9013.c
> +++ b/drivers/media/dvb/frontends/af9013.c
> @@ -1094,7 +1094,10 @@ static int af9013_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   	}
>
>   	ret = af9013_update_statistics(fe);
> -
> +	if (ret)
> +		goto error;
> +	/* Force empty stream buffer if overflow */
> +	ret = af9013_write_reg_bits(state, 0xd500, 7, 1, 0);
>   error:
>   	return ret;
>   }


-- 
http://palosaari.fi/
