Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63913 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeC0FAt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 01:00:49 -0400
Date: Tue, 27 Mar 2018 14:00:45 +0900
From: Ji-Hun Kim <ji_hun.kim@samsung.com>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        mchehab@kernel.org
Cc: arvind.yadav.cs@gmail.com, ji_hun.kim@samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3 1/2] staging: media: davinci_vpfe: add error handling
 on kmalloc failure
Message-id: <20180327050045.GA12754@ubuntu>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <1521607150-31307-1-git-send-email-ji_hun.kim@samsung.com>
References: <CGME20180321043915epcas1p3955f5a57c6728cd1f386f805879fc3f2@epcas1p3.samsung.com>
        <1521607150-31307-1-git-send-email-ji_hun.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 21, 2018 at 01:39:09PM +0900, Ji-Hun Kim wrote:
> There is no failure checking on the param value which will be allocated
> memory by kmalloc. Add a null pointer checking statement. Then goto error:
> and return -ENOMEM error code when kmalloc is failed.
> 
> Signed-off-by: Ji-Hun Kim <ji_hun.kim@samsung.com>
> ---
> Changes since v1:
>   - Return with -ENOMEM directly, instead of goto error: then return.
>   - [Patch v3 1/2] is same with [patch v2]
> 
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> index 6a3434c..ffcd86d 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -1280,6 +1280,9 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>  
>  			params = kmalloc(sizeof(struct ipipe_module_params),
>  					 GFP_KERNEL);
> +			if (!params)
> +				return -ENOMEM;
> +
>  			to = (void *)params + module_if->param_offset;
>  			size = module_if->param_size;
>  
> @@ -1323,6 +1326,9 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>  
>  			params =  kmalloc(sizeof(struct ipipe_module_params),
>  						GFP_KERNEL);
> +			if (!params)
> +				return -ENOMEM;
> +
>  			from = (void *)params + module_if->param_offset;
>  			size = module_if->param_size;
>  
> -- 
> 1.9.1
> 
> 

Are there any opinions? I'd like to know how this patch is going.

Best regards,
Ji-Hun
