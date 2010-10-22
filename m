Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9109 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0JVG5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 02:57:41 -0400
Date: Fri, 22 Oct 2010 08:57:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [patch 1/3] V4L/DVB: s5p-fimc: add unlock on error path
In-reply-to: <20101021192243.GJ5985@bicker>
To: 'Dan Carpenter' <error27@gmail.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-id: <000901cb71b6$68d076b0$3a716410$%nawrocki@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <20101021192243.GJ5985@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Thursday, October 21, 2010 9:23 PM
> To: Mauro Carvalho Chehab
> Cc: Kyungmin Park; Sylwester Nawrocki; Marek Szyprowski; Pawel Osciak;
> linux-media@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 1/3] V4L/DVB: s5p-fimc: add unlock on error path
> 
> There was an unlock missing if kzalloc() failed.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
> b/drivers/media/video/s5p-fimc/fimc-core.c
> index 1802701..8335045 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -1326,16 +1326,18 @@ static int fimc_m2m_open(struct file *file)
>  	 * is already opened.
>  	 */
>  	if (fimc->vid_cap.refcnt > 0) {
> -		mutex_unlock(&fimc->lock);
> -		return -EBUSY;
> +		err = -EBUSY;
> +		goto err_unlock;
>  	}
> 
>  	fimc->m2m.refcnt++;
>  	set_bit(ST_OUTDMA_RUN, &fimc->state);
> 
>  	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> -	if (!ctx)
> -		return -ENOMEM;
> +	if (!ctx) {
> +		err = -ENOMEM;
> +		goto err_unlock;
> +	}
> 
>  	file->private_data = ctx;
>  	ctx->fimc_dev = fimc;
> @@ -1355,6 +1357,7 @@ static int fimc_m2m_open(struct file *file)
>  		kfree(ctx);
>  	}
> 
> +err_unlock:
>  	mutex_unlock(&fimc->lock);
>  	return err;
>  }

Indeed it's my omission. Thanks.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center

