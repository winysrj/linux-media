Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9416 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaEUKgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 06:36:32 -0400
Message-id: <537C81AC.60901@samsung.com>
Date: Wed, 21 May 2014 12:36:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Victor Lambret <victor.lambret.ext@parrot.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] videobuf2-core: remove duplicated code
References: <1400665723-21695-1-git-send-email-victor.lambret.ext@parrot.com>
In-reply-to: <1400665723-21695-1-git-send-email-victor.lambret.ext@parrot.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-05-21 11:48, Victor Lambret wrote:
> Remove duplicated test of buffer presence at streamon
>
> Signed-off-by: Victor Lambret <victor.lambret.ext@parrot.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f9059bb..b731b66 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2067,10 +2067,6 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return -EINVAL;
>   	}
>   
> -	if (!q->num_buffers) {
> -		dprintk(1, "streamon: no buffers have been allocated\n");
> -		return -EINVAL;
> -	}
>   	if (q->num_buffers < q->min_buffers_needed) {
>   		dprintk(1, "streamon: need at least %u allocated buffers\n",
>   				q->min_buffers_needed);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

