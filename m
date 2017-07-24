Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0064.outbound.protection.outlook.com ([104.47.42.64]:36054
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751543AbdGXIet (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 04:34:49 -0400
Message-ID: <5975B0FD.5070908@amd.com>
Date: Mon, 24 Jul 2017 16:34:05 +0800
From: zhoucm1 <david1.zhou@amd.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
In-Reply-To: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2017年07月22日 00:20, Christian König wrote:
> From: Christian König <christian.koenig@amd.com>
>
> With hardware resets in mind it is possible that all shared fences are
> signaled, but the exlusive isn't. Fix waiting for everything in this situation.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>   drivers/dma-buf/reservation.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index e2eff86..ce3f9c1 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -461,7 +461,7 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>   		}
>   	}
>   
> -	if (!shared_count) {
> +	if (!fence) {
previous code seems be a bug, the exclusive fence isn't be waited at all 
if shared_count != 0.

With your fix, there still is a case the exclusive fence could be 
skipped, that when fobj->shared[shared_count-1] isn't signalled.

Regards,
David Zhou
>   		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
>   
>   		if (fence_excl &&
