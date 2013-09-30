Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1641 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3I3Lo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 07:44:59 -0400
Message-ID: <52496420.5020601@xs4all.nl>
Date: Mon, 30 Sep 2013 13:44:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] [media] videobuf2-core: call __setup_offsets only for
 mmap memory type
References: <1379576249-16909-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1379576249-16909-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2013 09:37 AM, Philipp Zabel wrote:
> __setup_offsets fills the v4l2_planes' mem_offset fields, which is only valid
> for V4L2_MEMORY_MMAP type buffers. For V4L2_MEMORY_DMABUF and _USERPTR buffers,
> this incorrectly overwrites the fd and userptr fields.
> 
> Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9c865da..95a798e 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -241,7 +241,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>  		q->bufs[q->num_buffers + buffer] = vb;
>  	}
>  
> -	__setup_offsets(q, buffer);
> +	if (memory == V4L2_MEMORY_MMAP)
> +		__setup_offsets(q, buffer);
>  
>  	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
>  			buffer, num_planes);
> 

