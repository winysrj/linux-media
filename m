Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:50580 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751260AbdKUOiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 09:38:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20171121140850.23401-1-robdclark@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20171121140850.23401-1-robdclark@gmail.com>
Message-ID: <151127508188.436.3320065005004428970@mail.alporthouse.com>
Subject: Re: [PATCH] reservation: don't wait when timeout=0
Date: Tue, 21 Nov 2017 14:38:01 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Rob Clark (2017-11-21 14:08:46)
> If we are testing if a reservation object's fences have been
> signaled with timeout=0 (non-blocking), we need to pass 0 for
> timeout to dma_fence_wait_timeout().
> 
> Plus bonus spelling correction.
> 
> Signed-off-by: Rob Clark <robdclark@gmail.com>
> ---
>  drivers/dma-buf/reservation.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index dec3a815455d..71f51140a9ad 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -420,7 +420,7 @@ EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
>   *
>   * RETURNS
>   * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or
> - * greater than zer on success.
> + * greater than zero on success.
>   */
>  long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>                                          bool wait_all, bool intr,
> @@ -483,7 +483,14 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>                         goto retry;
>                 }
>  
> -               ret = dma_fence_wait_timeout(fence, intr, ret);
> +               /*
> +                * Note that dma_fence_wait_timeout() will return 1 if
> +                * the fence is already signaled, so in the wait_all
> +                * case when we go through the retry loop again, ret
> +                * will be greater than 0 and we don't want this to
> +                * cause _wait_timeout() to block
> +                */
> +               ret = dma_fence_wait_timeout(fence, intr, timeout ? ret : 0);

One should ask if we should just fix the interface to stop returning
incorrect results (stop "correcting" a completion with 0 jiffies remaining
as 1). A timeout can be distinguished by -ETIME (or your pick of errno).
-Chris
