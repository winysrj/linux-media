Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40264 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753189AbcGTNED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:04:03 -0400
Date: Wed, 20 Jul 2016 16:03:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] vb2: include length in dmabuf qbuf debug message
Message-ID: <20160720130356.GB7976@valkosipuli.retiisi.org.uk>
References: <1468508975-6146-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468508975-6146-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thanks for the patch!

On Thu, Jul 14, 2016 at 11:09:34AM -0400, Javier Martinez Canillas wrote:
> If the the VIDIOC_QBUF ioctl fails due a wrong dmabuf length,
> it's useful to get the invalid length as a debug information.
> 
> Before this patch:
> 
> vb2-core: __qbuf_dmabuf: invalid dmabuf length for plane 1
> 
> After this patch:
> 
> vb2-core: __qbuf_dmabuf: invalid dmabuf length 221248 for plane 1
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ca8ffeb56d72..97d1483e0f7a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1228,8 +1228,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  			planes[plane].length = dbuf->size;
>  
>  		if (planes[plane].length < vb->planes[plane].min_length) {
> -			dprintk(1, "invalid dmabuf length for plane %d\n",
> -				plane);
> +			dprintk(1, "invalid dmabuf length %d for plane %d\n",

%u, please. You might want to print the minimum length as well.

> +				planes[plane].length, plane);
>  			dma_buf_put(dbuf);
>  			ret = -EINVAL;
>  			goto err;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
