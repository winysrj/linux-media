Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35467 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953551AbdDZCu3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 22:50:29 -0400
Received: by mail-it0-f67.google.com with SMTP id 70so5217231ita.2
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 19:50:29 -0700 (PDT)
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query
To: dri-devel@lists.freedesktop.org
References: <20170426013632.4716-1-andresx7@gmail.com>
Cc: deathsimple@vodafone.de, linaro-mm-sig@lists.linaro.org,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
From: Andres Rodriguez <andresx7@gmail.com>
Message-ID: <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
Date: Tue, 25 Apr 2017 22:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170426013632.4716-1-andresx7@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC a few extra lists I missed.

Regards,
Andres

On 2017-04-25 09:36 PM, Andres Rodriguez wrote:
> When a timeout of zero is specified, the caller is only interested in
> the fence status.
>
> In the current implementation, dma_fence_default_wait will always call
> schedule_timeout() at least once for an unsignaled fence. This adds a
> significant overhead to a fence status query.
>
> Avoid this overhead by returning early if a zero timeout is specified.
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>
> This heavily affects the performance of the Source2 engine running on
> radv.
>
> This patch improves dota2(radv) perf on a i7-6700k+RX480 system from
> 72fps->81fps.
>
>  drivers/dma-buf/dma-fence.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> index 0918d3f..348e9e2 100644
> --- a/drivers/dma-buf/dma-fence.c
> +++ b/drivers/dma-buf/dma-fence.c
> @@ -380,6 +380,9 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
>  	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>  		return ret;
>
> +	if (!timeout)
> +		return 0;
> +
>  	spin_lock_irqsave(fence->lock, flags);
>
>  	if (intr && signal_pending(current)) {
>
