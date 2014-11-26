Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53793 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaKZT4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 14:56:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 04/12] vb2: don't free alloc context if it is ERR_PTR
Date: Wed, 26 Nov 2014 21:57:16 +0200
Message-ID: <2976231.bHTBT3GSj5@avalon>
In-Reply-To: <1416315068-22936-5-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 18 November 2014 13:51:00 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Don't try to free a pointer containing an ERR_PTR().

Wouldn't it be easier to return NULL from vb2_dma_contig_alloc_ctx() instead 
of an ERR_PTR ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index c4305bf..0bfc488
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -854,7 +854,8 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
> 
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
>  {
> -	kfree(alloc_ctx);
> +	if (!IS_ERR_OR_NULL(alloc_ctx))
> +		kfree(alloc_ctx);
>  }
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);

-- 
Regards,

Laurent Pinchart

