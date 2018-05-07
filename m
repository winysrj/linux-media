Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36012 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752290AbeEGN6Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 09:58:16 -0400
Received: by mail-wm0-f67.google.com with SMTP id n10-v6so15565456wmc.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 06:58:16 -0700 (PDT)
Date: Mon, 7 May 2018 15:58:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>, kernel@collabora.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Remove unneeded stubs around sync_debug
 interfaces
Message-ID: <20180507135813.GK12521@phenom.ffwll.local>
References: <20180504180037.10661-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504180037.10661-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 03:00:37PM -0300, Ezequiel Garcia wrote:
> The sync_debug.h header is internal, and only used by
> sw_sync.c. Therefore, SW_SYNC is always defined and there
> is no need for the stubs. Remove them and make the code
> simpler.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

Applied, thanks.
-Daniel
> ---
>  drivers/dma-buf/sync_debug.h | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/dma-buf/sync_debug.h b/drivers/dma-buf/sync_debug.h
> index d615a89f774c..05e33f937ad0 100644
> --- a/drivers/dma-buf/sync_debug.h
> +++ b/drivers/dma-buf/sync_debug.h
> @@ -62,8 +62,6 @@ struct sync_pt {
>  	struct rb_node node;
>  };
>  
> -#ifdef CONFIG_SW_SYNC
> -
>  extern const struct file_operations sw_sync_debugfs_fops;
>  
>  void sync_timeline_debug_add(struct sync_timeline *obj);
> @@ -72,12 +70,4 @@ void sync_file_debug_add(struct sync_file *fence);
>  void sync_file_debug_remove(struct sync_file *fence);
>  void sync_dump(void);
>  
> -#else
> -# define sync_timeline_debug_add(obj)
> -# define sync_timeline_debug_remove(obj)
> -# define sync_file_debug_add(fence)
> -# define sync_file_debug_remove(fence)
> -# define sync_dump()
> -#endif
> -
>  #endif /* _LINUX_SYNC_H */
> -- 
> 2.16.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
