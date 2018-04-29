Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:2465
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751898AbeD2HLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Apr 2018 03:11:53 -0400
Subject: Re: [PATCH 04/17] dma-fence: Allow wait_any_timeout for all fences
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Alex Deucher <alexander.deucher@amd.com>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
 <20180427061724.28497-5-daniel.vetter@ffwll.ch>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <1df9beec-8ee4-5740-954a-a2a5dbc4fd03@amd.com>
Date: Sun, 29 Apr 2018 09:11:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180427061724.28497-5-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.04.2018 um 08:17 schrieb Daniel Vetter:
> When this was introduced in
>
> commit a519435a96597d8cd96123246fea4ae5a6c90b02
> Author: Christian König <christian.koenig@amd.com>
> Date:   Tue Oct 20 16:34:16 2015 +0200
>
>      dma-buf/fence: add fence_wait_any_timeout function v2
>
> there was a restriction added that this only works if the dma-fence
> uses the dma_fence_default_wait hook. Which works for amdgpu, which is
> the only caller. Well, until you share some buffers with e.g. i915,
> then you get an -EINVAL.
>
> But there's really no reason for this, because all drivers must
> support callbacks. The special ->wait hook is only as an optimization;
> if the driver needs to create a worker thread for an active callback,
> then it can avoid to do that if it knows that there's a process
> context available already. So ->wait is just an optimization, just
> using the logic in dma_fence_default_wait() should work for all
> drivers.
>
> Let's remove this restriction.

Mhm, that was intentional introduced because for radeon that is not only 
an optimization, but mandatory for correct operation.

On the other hand radeon isn't using this function, so it should be fine 
as long as the Intel driver can live with it.

Christian.

>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> ---
>   drivers/dma-buf/dma-fence.c | 5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> index 7b5b40d6b70e..59049375bd19 100644
> --- a/drivers/dma-buf/dma-fence.c
> +++ b/drivers/dma-buf/dma-fence.c
> @@ -503,11 +503,6 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
>   	for (i = 0; i < count; ++i) {
>   		struct dma_fence *fence = fences[i];
>   
> -		if (fence->ops->wait != dma_fence_default_wait) {
> -			ret = -EINVAL;
> -			goto fence_rm_cb;
> -		}
> -
>   		cb[i].task = current;
>   		if (dma_fence_add_callback(fence, &cb[i].base,
>   					   dma_fence_default_wait_cb)) {
