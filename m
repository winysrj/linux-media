Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36693 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034605AbcIWNut (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 09:50:49 -0400
Received: by mail-lf0-f65.google.com with SMTP id s29so5759515lfg.3
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 06:50:48 -0700 (PDT)
Date: Fri, 23 Sep 2016 15:50:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [Intel-gfx] [PATCH 11/11] dma-buf: Do a fast lockless check for
 poll with timeout=0
Message-ID: <20160923135044.GM3988@dvetter-linux.ger.corp.intel.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-11-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160829070834.22296-11-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2016 at 08:08:34AM +0100, Chris Wilson wrote:
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
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Need to strike the r-b here, since Christian König pointed out that
objects won't magically switch signalling on.
-Daniel

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
