Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19922 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab3EGNnq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 09:43:46 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMF001RZKN4FN00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 May 2013 14:43:44 +0100 (BST)
Message-id: <51890507.20501@samsung.com>
Date: Tue, 07 May 2013 15:43:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com, pawel@osciak.com, kyungmin.park@samsung.com
Subject: Re: [RFC][PATCH 2/2] media: v4l2-mem2mem: return for polling if a
 buffer is available
References: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
 <1364798447-32224-3-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1364798447-32224-3-git-send-email-sw0312.kim@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 4/1/2013 8:40 AM, Seung-Woo Kim wrote:
> The v4l2_m2m_poll() does not need to wait if there is already a buffer in
> done_list of source and destination queues, but current v4l2_m2m_poll() always
> waits. So done_list of each queue is checked before calling poll_wait().
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>

Right now I have no idea how to fix this better than it has been 
proposed in your patch. I wonder what will happen if the device doesn't 
release both source and destination buffers at the same time, but this 
situation is purely hypothetical as there is no driver which does it 
such way, therefore:

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Sorry for a long delay, I had to find some time to analyze the code.

> ---
>   drivers/media/v4l2-core/v4l2-mem2mem.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index da99cf7..b6f0316 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -458,8 +458,10 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>   	if (m2m_ctx->m2m_dev->m2m_ops->unlock)
>   		m2m_ctx->m2m_dev->m2m_ops->unlock(m2m_ctx->priv);
>   
> -	poll_wait(file, &src_q->done_wq, wait);
> -	poll_wait(file, &dst_q->done_wq, wait);
> +	if (list_empty(&src_q->done_list))
> +		poll_wait(file, &src_q->done_wq, wait);
> +	if (list_empty(&dst_q->done_list))
> +		poll_wait(file, &dst_q->done_wq, wait);
>   
>   	if (m2m_ctx->m2m_dev->m2m_ops->lock)
>   		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


