Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19199 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGYFVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 01:21:34 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N99006W95JM4110@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 06:21:22 +0100 (BST)
Message-id: <53D1E95F.7050601@samsung.com>
Date: Fri, 25 Jul 2014 07:21:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] vb2: fix vb2_poll for output streams
References: <53D0F9D9.7080003@xs4all.nl>
In-reply-to: <53D0F9D9.7080003@xs4all.nl>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-07-24 14:19, Hans Verkuil wrote:
> vb2_poll should always return POLLOUT | POLLWRNORM as long as there
> are fewer buffers queued than there are buffers available. Poll for
> an output stream should only wait if all buffers are queued and nobody
> is dequeuing them.
>
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f33508f..c359006 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2596,6 +2596,13 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>   	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
>   		return res | POLLERR;
>   
> +	/*
> +	 * For output streams you can write as long as there are fewer buffers
> +	 * queued than there are buffers available.
> +	 */
> +	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
> +		return res | POLLOUT | POLLWRNORM;
> +
>   	if (list_empty(&q->done_list))
>   		poll_wait(file, &q->done_wq, wait);
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

