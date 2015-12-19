Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24998 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbbLSUnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 15:43:17 -0500
Date: Sat, 19 Dec 2015 23:42:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] [media] gsc-m2m: Use an unsigned data type for a variable
Message-ID: <20151219204222.GU5284@mwanda>
References: <5675765F.9020002@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5675765F.9020002@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 19, 2015 at 04:23:11PM +0100, SF Markus Elfring wrote:
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index d82e717..f2c091c 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -701,7 +701,7 @@ static unsigned int gsc_m2m_poll(struct file *file,
>  {
>  	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>  	struct gsc_dev *gsc = ctx->gsc_dev;
> -	int ret;
> +	unsigned int ret;
>  
>  	if (mutex_lock_interruptible(&gsc->lock))
>  		return -ERESTARTSYS;

I'm suspect returning -ERESTARTSYS is a bug.

regards,
dan carpenter

