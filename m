Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2071 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaEIPtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 11:49:05 -0400
Message-ID: <536CF8D6.50903@xs4all.nl>
Date: Fri, 09 May 2014 17:48:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] [media] vb2: fix num_buffers calculation if req->count
 > VIDEO_MAX_FRAMES
References: <1399649530-20885-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1399649530-20885-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/2014 05:32 PM, Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 40024d7..4d4f6ba 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -905,7 +905,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	 * Make sure the requested values and current defaults are sane.
>  	 */
>  	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
> -	num_buffers = max_t(unsigned int, req->count, q->min_buffers_needed);
> +	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
>  	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>  	q->memory = req->memory;
> 

