Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62112 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649Ab2HWNtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:49:09 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M97003ZONQRFP30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 14:49:39 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M9700FJ7NPUYH20@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 14:49:07 +0100 (BST)
Message-id: <503634D2.9000301@samsung.com>
Date: Thu, 23 Aug 2012 15:49:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/10] mem2mem_testdev: Remove unneeded struct vb2_queue
 clear on queue_init()
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
 <1345727311-27478-4-git-send-email-elezegarcia@gmail.com>
In-reply-to: <1345727311-27478-4-git-send-email-elezegarcia@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 08/23/2012 03:08 PM, Ezequiel Garcia wrote:
> queue_init() is always called by v4l2_m2m_ctx_init(), which allocates
> a context struct v4l2_m2m_ctx with kzalloc.
> Therefore, there is no need to clear vb2_queue src/dst structs.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Looks good to me. Let me pick this and s5p-jpeg, s5p-g2d patches for v3.7.

It might be good to add some kerneldoc documentation for v4l2_m2m_ctx_init()
function in include/media/v4l2-mem2mem.h, so it is clear what are exact
semantics for the queue_init callback.

Regards,
Sylwester

> ---
>  drivers/media/platform/mem2mem_testdev.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 51b6dd4..9a8b14f 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -838,7 +838,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	struct m2mtest_ctx *ctx = priv;
>  	int ret;
>  
> -	memset(src_vq, 0, sizeof(*src_vq));
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>  	src_vq->io_modes = VB2_MMAP;
>  	src_vq->drv_priv = ctx;
> @@ -850,7 +849,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	if (ret)
>  		return ret;
>  
> -	memset(dst_vq, 0, sizeof(*dst_vq));
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	dst_vq->io_modes = VB2_MMAP;
>  	dst_vq->drv_priv = ctx;
