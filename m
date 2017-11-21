Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:41519 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdKUO1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 09:27:34 -0500
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH] reservation: don't wait when timeout=0
To: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20171121140850.23401-1-robdclark@gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <52253a44-112a-9bcb-bceb-2ea53a444265@gmail.com>
Date: Tue, 21 Nov 2017 15:27:26 +0100
MIME-Version: 1.0
In-Reply-To: <20171121140850.23401-1-robdclark@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.11.2017 um 15:08 schrieb Rob Clark:
> If we are testing if a reservation object's fences have been
> signaled with timeout=0 (non-blocking), we need to pass 0 for
> timeout to dma_fence_wait_timeout().
>
> Plus bonus spelling correction.
>
> Signed-off-by: Rob Clark <robdclark@gmail.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/dma-buf/reservation.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index dec3a815455d..71f51140a9ad 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -420,7 +420,7 @@ EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
>    *
>    * RETURNS
>    * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or
> - * greater than zer on success.
> + * greater than zero on success.
>    */
>   long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>   					 bool wait_all, bool intr,
> @@ -483,7 +483,14 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>   			goto retry;
>   		}
>   
> -		ret = dma_fence_wait_timeout(fence, intr, ret);
> +		/*
> +		 * Note that dma_fence_wait_timeout() will return 1 if
> +		 * the fence is already signaled, so in the wait_all
> +		 * case when we go through the retry loop again, ret
> +		 * will be greater than 0 and we don't want this to
> +		 * cause _wait_timeout() to block
> +		 */
> +		ret = dma_fence_wait_timeout(fence, intr, timeout ? ret : 0);
>   		dma_fence_put(fence);
>   		if (ret > 0 && wait_all && (i + 1 < shared_count))
>   			goto retry;
