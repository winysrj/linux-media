Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41506 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728125AbeKOBII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:08:08 -0500
Subject: Re: [PATCH][staging-next] drivers: staging: cedrus: find ctx before
 dereferencing it ctx
To: Colin King <colin.king@canonical.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181102190126.5628-1-colin.king@canonical.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c54b52b2-c0b2-6afc-ad35-bbf396650418@xs4all.nl>
Date: Wed, 14 Nov 2018 16:04:19 +0100
MIME-Version: 1.0
In-Reply-To: <20181102190126.5628-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/18 20:01, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if count is an invalid value the v4l2_info message will
> dereference a null ctx pointer to get the dev information. Fix
> this by finding ctx first and then checking for an invalid count,
> this way ctxt will be non-null hence avoiding the null pointer
> dereference.
> 
> Detected by CoverityScan, CID#1475337 ("Explicit null dereferenced")
> 
> Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus.c | 22 ++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> index 82558455384a..699d62dceb6c 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> @@ -108,17 +108,6 @@ static int cedrus_request_validate(struct media_request *req)
>  	unsigned int count;
>  	unsigned int i;
>  
> -	count = vb2_request_buffer_cnt(req);
> -	if (!count) {
> -		v4l2_info(&ctx->dev->v4l2_dev,
> -			  "No buffer was provided with the request\n");
> -		return -ENOENT;
> -	} else if (count > 1) {
> -		v4l2_info(&ctx->dev->v4l2_dev,
> -			  "More than one buffer was provided with the request\n");
> -		return -EINVAL;
> -	}
> -
>  	list_for_each_entry(obj, &req->objects, list) {
>  		struct vb2_buffer *vb;
>  
> @@ -133,6 +122,17 @@ static int cedrus_request_validate(struct media_request *req)
>  	if (!ctx)
>  		return -ENOENT;
>  
> +	count = vb2_request_buffer_cnt(req);
> +	if (!count) {
> +		v4l2_info(&ctx->dev->v4l2_dev,
> +			  "No buffer was provided with the request\n");
> +		return -ENOENT;
> +	} else if (count > 1) {
> +		v4l2_info(&ctx->dev->v4l2_dev,
> +			  "More than one buffer was provided with the request\n");
> +		return -EINVAL;
> +	}
> +

Is this right? If there are no buffers in the request, then the list_for_each_entry()
loop won't find a ctx either. This needs to be done differently: for these initial
v4l2_info() statements you can get the cedrus_dev struct from req->mdev since the
media_device is embedded in the cedrus_dev struct. In other words, some
container_of magic is needed here.

Regards,

	Hans

>  	parent_hdl = &ctx->hdl;
>  
>  	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
> 
