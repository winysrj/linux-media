Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34408 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbeIKMgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 08:36:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id u1-v6so18467874eds.1
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 00:38:47 -0700 (PDT)
Date: Tue, 11 Sep 2018 09:38:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        laurent.pinchart@ideasonboard.com,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 03/10] udmabuf: use pgoff_t for pagecount
Message-ID: <20180911073844.GH19774@phenom.ffwll.local>
References: <20180911065921.23818-1-kraxel@redhat.com>
 <20180911065921.23818-4-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180911065921.23818-4-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 11, 2018 at 08:59:14AM +0200, Gerd Hoffmann wrote:
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

TIL pgoff_t stands for page cache offset. I think we're pretty bad at
using that within i915 :-)

On the entire series Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I did try to review in depth, but my brain is offline and coffee not
working :-) Hence just an ack.
-Daniel

> ---
>  drivers/dma-buf/udmabuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index 19bd918209..ec22f203b5 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -13,7 +13,7 @@
>  #include <linux/udmabuf.h>
>  
>  struct udmabuf {
> -	u32 pagecount;
> +	pgoff_t pagecount;
>  	struct page **pages;
>  };
>  
> -- 
> 2.9.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
