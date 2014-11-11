Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43355 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753201AbaKKLOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 06:14:12 -0500
Date: Tue, 11 Nov 2014 13:13:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	linux-samsung-soc@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] media: v4l2: make alloction alogthim more robust and
 flexible
Message-ID: <20141111111338.GC8214@valkosipuli.retiisi.org.uk>
References: <1406692532-31800-1-git-send-email-zhaowei.yuan@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406692532-31800-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zhaowei,

My apologies for the delayed reply.

On Wed, Jul 30, 2014 at 11:55:32AM +0800, Zhaowei Yuan wrote:
> Current algothim relies on the fact that caller will align the
> size to PAGE_SIZE, otherwise order will be decreased to negative
> when remain size is less than PAGE_SIZE, it makes the function
> hard to be migrated.
> This patch sloves the hidden problem.
> 
> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index adefc31..40d18aa 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -58,7 +58,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> 
>  		order = get_order(size);
>  		/* Dont over allocate*/
> -		if ((PAGE_SIZE << order) > size)
> +		if (order > 0 && (PAGE_SIZE << order) > size)
>  			order--;
> 
>  		pages = NULL;

With comments from Andreas taken into account,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I'd consider this for the stable series as well.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
