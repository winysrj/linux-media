Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbeAVUuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 15:50:09 -0500
Subject: Re: [PATCH] [media] s3c-camif: array underflow in
 __camif_subdev_try_format()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <20180122103714.GA25044@mwanda>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <5b3b7195-930c-58c3-d52f-b2738c3fde1e@kernel.org>
Date: Mon, 22 Jan 2018 21:50:04 +0100
MIME-Version: 1.0
In-Reply-To: <20180122103714.GA25044@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2018 11:37 AM, Dan Carpenter wrote:
> The while loop is a post op, "while (i-- >= 0)" so the last iteration
> will read camif_mbus_formats[-1] and then the loop will exit with "i"
> set to -2 and so we do: "mf->code = camif_mbus_formats[-2];".
> 
> I've changed it to a pre-op, I've added a check to ensure we found the
> right format and I've removed the "mf->code = camif_mbus_formats[i];"
> because that is a no-op anyway.
> 
> Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 437395a61065..012f4b389c55 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1261,11 +1261,11 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
>   	/* FIXME: constraints against codec or preview path ? */
>   	pix_lim = &variant->vp_pix_limits[VP_CODEC];
>   
> -	while (i-- >= 0)
> +	while (--i >= 0)
>   		if (camif_mbus_formats[i] == mf->code)
>   			break;
> -
> -	mf->code = camif_mbus_formats[i];
> +	if (i < 0)
> +		return;

Thanks for the patch Dan. mf->width needs to be aligned by this try_format
function so we shouldn't return here. Also it needs to be ensured mf->code 
is set to one of the supported values when this function returns. Sorry,
the current code really doesn't give a clue what was intended.

There is already queued a patch from Arnd [1] addressing the issues you 
have found.
 
>   	if (pad == CAMIF_SD_PAD_SINK) {
>   		v4l_bound_align_image(&mf->width, 8, CAMIF_MAX_PIX_WIDTH,
> 

[1] https://patchwork.linuxtv.org/patch/46508

--
Regards,
Sylwester
