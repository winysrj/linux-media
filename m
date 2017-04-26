Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:42766 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041178AbdDZOuL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 10:50:11 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pegasos-out.vodafone.de (Rohrpostix1  Daemon) with ESMTP id C74C4261F70
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 16:50:09 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
        by localhost (rohrpostix1.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H7IhrpSTiQnp for <linux-media@vger.kernel.org>;
        Wed, 26 Apr 2017 16:50:07 +0200 (CEST)
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query v2
To: Andres Rodriguez <andresx7@gmail.com>,
        dri-devel@lists.freedesktop.org
References: <20170426144620.3560-1-andresx7@gmail.com>
Cc: sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <92c9bc96-cf60-f246-a82e-47653472521e@vodafone.de>
Date: Wed, 26 Apr 2017 16:49:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170426144620.3560-1-andresx7@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.04.2017 um 16:46 schrieb Andres Rodriguez:
> When a timeout of zero is specified, the caller is only interested in
> the fence status.
>
> In the current implementation, dma_fence_default_wait will always call
> schedule_timeout() at least once for an unsignaled fence. This adds a
> significant overhead to a fence status query.
>
> Avoid this overhead by returning early if a zero timeout is specified.
>
> v2: move early return after enable_signaling
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>
>   If I'm understanding correctly, I don't think we need to register the
>   default wait callback. But if that isn't the case please let me know.
>
>   This patch has the same perf improvements as v1.
>
>   drivers/dma-buf/dma-fence.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> index 0918d3f..57da14c 100644
> --- a/drivers/dma-buf/dma-fence.c
> +++ b/drivers/dma-buf/dma-fence.c
> @@ -402,6 +402,11 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
>   		}
>   	}
>   
> +	if (!timeout) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>   	cb.base.func = dma_fence_default_wait_cb;
>   	cb.task = current;
>   	list_add(&cb.base.node, &fence->cb_list);
