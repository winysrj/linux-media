Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35659 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaGWCnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 22:43:55 -0400
Message-id: <53CF216E.9040209@samsung.com>
Date: Wed, 23 Jul 2014 11:43:58 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] media: s5p_mfc: remove unnecessary calling to function
 video_devdata()
References: <1406076572-5719-1-git-send-email-zhaowei.yuan@samsung.com>
In-reply-to: <1406076572-5719-1-git-send-email-zhaowei.yuan@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zhaowei,

On 07/23/2014 09:49 AM, Zhaowei Yuan wrote:
> Since we have get vdev by calling video_devdata() at the beginning of
> s5p_mfc_open(), we should just use vdev instead of calling video_devdata()
> again in the following code.
> 
> Change-Id: I869051762d33b50a7c0dbc8149b072e70b89c6b9

Please don't put this in patch when you submit at upstream. Change-Id
means nothing to us.

> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index d57b306..d508cbc 100755
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -709,7 +709,7 @@ static int s5p_mfc_open(struct file *file)
>  		ret = -ENOMEM;
>  		goto err_alloc;
>  	}
> -	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	v4l2_fh_init(&ctx->fh, vdev);
>  	file->private_data = &ctx->fh;
>  	v4l2_fh_add(&ctx->fh);
>  	ctx->dev = dev;
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

