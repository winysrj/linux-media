Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46064 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909AbcGTTwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 15:52:33 -0400
Date: Wed, 20 Jul 2016 22:52:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] vb2: include lengths in dmabuf qbuf debug
 message
Message-ID: <20160720195228.GD7976@valkosipuli.retiisi.org.uk>
References: <1469030875-2246-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469030875-2246-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2016 at 12:07:55PM -0400, Javier Martinez Canillas wrote:
> If the VIDIOC_QBUF ioctl fails due a wrong dmabuf length, it's
> useful to get the invalid and minimum lengths as a debug info.
> 
> Before this patch:
> 
> vb2-core: __qbuf_dmabuf: invalid dmabuf length for plane 1
> 
> After this patch:
> 
> vb2-core: __qbuf_dmabuf: invalid dmabuf length 221248 for plane 1, minimum length 410880
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> Changes in v2:
> - Use %u instead of %d (Sakari Ailus)
> - Include min_length (Sakari Ailus)
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b6fbc04f9699..bbba50d6e1ad 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1227,8 +1227,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  			planes[plane].length = dbuf->size;
>  
>  		if (planes[plane].length < vb->planes[plane].min_length) {
> -			dprintk(1, "invalid dmabuf length for plane %d\n",
> -				plane);
> +			dprintk(1, "invalid dmabuf length %u for plane %d, "
> +				"minimum length %u\n",

You shouldn't split strings. It breaks grep.

With that changed,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +				planes[plane].length, plane,
> +				vb->planes[plane].min_length);
>  			dma_buf_put(dbuf);
>  			ret = -EINVAL;
>  			goto err;

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
