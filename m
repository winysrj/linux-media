Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:51355 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdKCHhN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 03:37:13 -0400
Received: by mail-lf0-f65.google.com with SMTP id r129so2085842lff.8
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 00:37:12 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 3 Nov 2017 08:37:09 +0100
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: async: fix return of unitialized variable ret
Message-ID: <20171103073709.GD24132@bigcity.dyn.berto.se>
References: <20171103065827.25988-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171103065827.25988-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

Thanks for your patch.

On 2017-11-03 06:58:27 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A shadow declaration of variable ret is being assigned a return error
> status and this value is being lost when the error exit goto's jump
> out of the local scope. This leads to an uninitalized error return value
> in the outer scope being returned. Fix this by removing the inner scoped
> declaration of variable ret.
> 
> Detected by CoverityScan, CID#1460380 ("Uninitialized scalar variable")
> 
> Fixes: fb45f436b818 ("media: v4l: async: Fix notifier complete callback error handling")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 49f7eccc76db..7020b2e6d158 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -550,7 +550,6 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  		struct v4l2_device *v4l2_dev =
>  			v4l2_async_notifier_find_v4l2_dev(notifier);
>  		struct v4l2_async_subdev *asd;
> -		int ret;
>  
>  		if (!v4l2_dev)
>  			continue;
> -- 
> 2.14.1
> 

-- 
Regards,
Niklas Söderlund
