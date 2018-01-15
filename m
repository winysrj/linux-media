Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42256 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932385AbeAOJrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:47:23 -0500
Received: by mail-wm0-f68.google.com with SMTP id b141so569008wme.1
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 01:47:22 -0800 (PST)
Date: Mon, 15 Jan 2018 10:47:19 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf/sw_sync: fix document of
 sw_sync_create_fence_data
Message-ID: <20180115094719.GL13066@phenom.ffwll.local>
References: <1515988079-8677-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515988079-8677-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 11:47:59AM +0800, Shawn Guo wrote:
> The structure should really be sw_sync_create_fence_data rather than
> sw_sync_ioctl_create_fence which is the function name.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Applied, thanks for your patch.
-Daniel

> ---
>  drivers/dma-buf/sw_sync.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 24f83f9eeaed..7779bdbd18d1 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -43,14 +43,14 @@
>   * timelines.
>   *
>   * Fences can be created with SW_SYNC_IOC_CREATE_FENCE ioctl with struct
> - * sw_sync_ioctl_create_fence as parameter.
> + * sw_sync_create_fence_data as parameter.
>   *
>   * To increment the timeline counter, SW_SYNC_IOC_INC ioctl should be used
>   * with the increment as u32. This will update the last signaled value
>   * from the timeline and signal any fence that has a seqno smaller or equal
>   * to it.
>   *
> - * struct sw_sync_ioctl_create_fence
> + * struct sw_sync_create_fence_data
>   * @value:	the seqno to initialise the fence with
>   * @name:	the name of the new sync point
>   * @fence:	return the fd of the new sync_file with the created fence
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
