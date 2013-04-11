Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37910 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3DKLP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 07:15:29 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML3006IM8LJ2580@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Apr 2013 12:15:27 +0100 (BST)
Message-id: <51669B4E.9080701@samsung.com>
Date: Thu, 11 Apr 2013 13:15:26 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com, pawel@osciak.com, kyungmin.park@samsung.com
Subject: Re: [RFC][PATCH 1/2] media: vb2: return for polling if a buffer is
 available
References: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
 <1364798447-32224-2-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1364798447-32224-2-git-send-email-sw0312.kim@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 4/1/2013 8:40 AM, Seung-Woo Kim wrote:
> The vb2_poll() does not need to wait next vb_buffer_done() if there is already
> a buffer in done_list of queue, but current vb2_poll() always waits.
> So done_list is checked before calling poll_wait().
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index db1235d..e941d2b 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1996,7 +1996,8 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>   	if (list_empty(&q->queued_list))
>   		return res | POLLERR;
>   
> -	poll_wait(file, &q->done_wq, wait);
> +	if (list_empty(&q->done_list))
> +		poll_wait(file, &q->done_wq, wait);
>   
>   	/*
>   	 * Take first buffer available for dequeuing.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

