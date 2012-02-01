Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42013 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2BAJBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 04:01:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYP001TYIE7XU20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 09:01:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYP00M2NIE6Q0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 09:01:19 +0000 (GMT)
Date: Wed, 01 Feb 2012 10:01:18 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3] [media] s5p-g2d: Add HFLIP and VFLIP support
In-reply-to: <1328072989-12498-1-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com, patches@linaro.org
Message-id: <4F28FF5E.30407@samsung.com>
References: <1328072989-12498-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 02/01/2012 06:09 AM, Sachin Kamat wrote:
> @@ -200,11 +206,7 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>  {
>  	struct g2d_dev *dev = ctx->dev;
>  
> -	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
> -	if (ctx->ctrl_handler.error) {
> -		v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
> -		return ctx->ctrl_handler.error;
> -	}
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
>  
>  	v4l2_ctrl_new_std_menu(
>  		&ctx->ctrl_handler,
> @@ -214,11 +216,20 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>  		~((1 << V4L2_COLORFX_NONE) | (1 << V4L2_COLORFX_NEGATIVE)),
>  		V4L2_COLORFX_NONE);
>  
> +
> +	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> +						V4L2_CID_HFLIP, 0, 1, 1, 0);
> +
> +	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> +						V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
>  	if (ctx->ctrl_handler.error) {
>  		v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");

It's not only v4l2_ctrl_handler_init() that might have failed at this point,
therefore you need to also call v4l2_ctrl_handler_free() here. There is an
example of that in Documentation/v4l2-controls.txt.

>  		return ctx->ctrl_handler.error;
>  	}

--

Thanks,
Sylwester
