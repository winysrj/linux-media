Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52335 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbbCCJJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 04:09:39 -0500
Message-ID: <54F57A43.30101@xs4all.nl>
Date: Tue, 03 Mar 2015 10:09:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] media: i2c: s5c73m3: make sure we destroy the mutex
References: <1425308434-26549-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425308434-26549-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/2015 04:00 PM, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Make sure to call mutex_destroy() in case of probe failure or module
> unload.

It's not actually necessary to destroy a mutex. Most drivers never do this.
It only helps a bit in debugging.

I'll delegate this patch to Kamil, and he can decide whether or not to apply
this.

Regards,

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index ee0f57e..da0b3a3 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1658,7 +1658,6 @@ static int s5c73m3_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> -	mutex_init(&state->lock);
>  	sd = &state->sensor_sd;
>  	oif_sd = &state->oif_sd;
>  
> @@ -1695,6 +1694,8 @@ static int s5c73m3_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> +	mutex_init(&state->lock);
> +
>  	ret = s5c73m3_configure_gpios(state);
>  	if (ret)
>  		goto out_err;
> @@ -1754,6 +1755,7 @@ out_err1:
>  	s5c73m3_unregister_spi_driver(state);
>  out_err:
>  	media_entity_cleanup(&sd->entity);
> +	mutex_destroy(&state->lock);
>  	return ret;
>  }
>  
> @@ -1772,6 +1774,7 @@ static int s5c73m3_remove(struct i2c_client *client)
>  	media_entity_cleanup(&sensor_sd->entity);
>  
>  	s5c73m3_unregister_spi_driver(state);
> +	mutex_destroy(&state->lock);
>  
>  	return 0;
>  }
> 

