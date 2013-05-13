Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3160 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3EMGyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 02:54:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH] [media] ad9389b: fix error return code in ad9389b_probe()
Date: Mon, 13 May 2013 08:54:14 +0200
Cc: hans.verkuil@cisco.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
References: <CAPgLHd_5h-ZBTB+ouZ9At1MRR8tCf2XFUD2qag3p=ceMdVfgUA@mail.gmail.com>
In-Reply-To: <CAPgLHd_5h-ZBTB+ouZ9At1MRR8tCf2XFUD2qag3p=ceMdVfgUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305130854.14615.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 13 2013 08:00:10 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/i2c/ad9389b.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
> index 58344b6..decef36 100644
> --- a/drivers/media/i2c/ad9389b.c
> +++ b/drivers/media/i2c/ad9389b.c
> @@ -1251,12 +1251,14 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
>  	state->edid_i2c_client = i2c_new_dummy(client->adapter, (0x7e>>1));
>  	if (state->edid_i2c_client == NULL) {
>  		v4l2_err(sd, "failed to register edid i2c client\n");
> +		err = -ENOMEM;
>  		goto err_entity;
>  	}
>  
>  	state->work_queue = create_singlethread_workqueue(sd->name);
>  	if (state->work_queue == NULL) {
>  		v4l2_err(sd, "could not create workqueue\n");
> +		err = -ENOMEM;
>  		goto err_unreg;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
