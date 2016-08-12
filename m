Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33743 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbcHLJAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:00:09 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so1692280wme.0
        for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 02:00:09 -0700 (PDT)
Date: Fri, 12 Aug 2016 10:44:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: [RFC 2/4] dma-buf/fence: kerneldoc: remove spurious section
 header
Message-ID: <20160812084441.GR6232@phenom.ffwll.local>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
 <1470912480-32304-3-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470912480-32304-3-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2016 at 04:17:58PM +0530, Sumit Semwal wrote:
> Commit e941759c74a44d6ac2eed21bb0a38b21fe4559e2 ("fence: dma-buf
> cross-device synchronization (v18)") had a spurious kerneldoc section
> header that caused Sphinx to complain. Fix it.
> 
> Fixes: e941759c74a4 ("fence: dma-buf cross-device synchronization (v18)")
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

On patches 1&2 Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>


> ---
>  include/linux/fence.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/fence.h b/include/linux/fence.h
> index 5aa95eb886f7..5de89dab0013 100644
> --- a/include/linux/fence.h
> +++ b/include/linux/fence.h
> @@ -60,7 +60,7 @@ struct fence_cb;
>   * implementer of the fence for its own purposes. Can be used in different
>   * ways by different fence implementers, so do not rely on this.
>   *
> - * *) Since atomic bitops are used, this is not guaranteed to be the case.
> + * Since atomic bitops are used, this is not guaranteed to be the case.
>   * Particularly, if the bit was set, but fence_signal was called right
>   * before this bit was set, it would have been able to set the
>   * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
> -- 
> 2.7.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
