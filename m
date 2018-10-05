Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39614 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727830AbeJEOeo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:34:44 -0400
Subject: Re: [PATCH] media: cec: name for RC passthrough device does not need
 'RC for'
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <20181004222113.13600-1-sean@mess.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4b8d8969-ac99-94f9-7ae1-b9e3df6e8331@xs4all.nl>
Date: Fri, 5 Oct 2018 09:37:11 +0200
MIME-Version: 1.0
In-Reply-To: <20181004222113.13600-1-sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2018 12:21 AM, Sean Young wrote:
> An RC device is does not need to be called 'RC for'. Simply the name
> will suffice.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

OK if I take this patch? I have a cec pull request upcoming anyway.

Regards,

	Hans

> ---
>  drivers/media/cec/cec-core.c | 6 ++----
>  include/media/cec.h          | 2 --
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> index 74596f089ec9..e4edc930d4ed 100644
> --- a/drivers/media/cec/cec-core.c
> +++ b/drivers/media/cec/cec-core.c
> @@ -307,12 +307,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	snprintf(adap->device_name, sizeof(adap->device_name),
> -		 "RC for %s", name);
>  	snprintf(adap->input_phys, sizeof(adap->input_phys),
> -		 "%s/input0", name);
> +		 "%s/input0", adap->name);
>  
> -	adap->rc->device_name = adap->device_name;
> +	adap->rc->device_name = adap->name;
>  	adap->rc->input_phys = adap->input_phys;
>  	adap->rc->input_id.bustype = BUS_CEC;
>  	adap->rc->input_id.vendor = 0;
> diff --git a/include/media/cec.h b/include/media/cec.h
> index 9f382f0c2970..73ed28b076ce 100644
> --- a/include/media/cec.h
> +++ b/include/media/cec.h
> @@ -198,9 +198,7 @@ struct cec_adapter {
>  	u16 phys_addrs[15];
>  	u32 sequence;
>  
> -	char device_name[32];
>  	char input_phys[32];
> -	char input_drv[32];
>  };
>  
>  static inline void *cec_get_drvdata(const struct cec_adapter *adap)
> 
