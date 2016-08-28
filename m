Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33042 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755737AbcH1REj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Aug 2016 13:04:39 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so6541308wme.0
        for <linux-media@vger.kernel.org>; Sun, 28 Aug 2016 10:04:38 -0700 (PDT)
Date: Sun, 28 Aug 2016 19:04:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] dma-buf: Do a fast lockless check for poll
 with timeout=0
Message-ID: <20160828170435.GC10980@phenom.ffwll.local>
References: <20160828163747.32751-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160828163747.32751-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 28, 2016 at 05:37:47PM +0100, Chris Wilson wrote:
> Currently we install a callback for performing poll on a dma-buf,
> irrespective of the timeout. This involves taking a spinlock, as well as
> unnecessary work, and greatly reduces scaling of poll(.timeout=0) across
> multiple threads.
> 
> We can query whether the poll will block prior to installing the
> callback to make the busy-query fast.
> 
> Single thread: 60% faster
> 8 threads on 4 (+4 HT) cores: 600% faster
> 
> Still not quite the perfect scaling we get with a native busy ioctl, but
> poll(dmabuf) is faster due to the quicker lookup of the object and
> avoiding drm_ioctl().
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/dma-buf/dma-buf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index cf04d249a6a4..c7a7bc579941 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -156,6 +156,18 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
>  	if (!events)
>  		return 0;
>  
> +	if (poll_does_not_wait(poll)) {
> +		if (events & POLLOUT &&
> +		    !reservation_object_test_signaled_rcu(resv, true))
> +			events &= ~(POLLOUT | POLLIN);
> +
> +		if (events & POLLIN &&
> +		    !reservation_object_test_signaled_rcu(resv, false))
> +			events &= ~POLLIN;
> +
> +		return events;
> +	}
> +
>  retry:
>  	seq = read_seqcount_begin(&resv->seq);
>  	rcu_read_lock();
> -- 
> 2.9.3
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
