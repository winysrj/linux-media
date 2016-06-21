Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:36391 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbcFULKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 07:10:14 -0400
Received: by mail-ob0-f195.google.com with SMTP id du1so2097324obc.3
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2016 04:10:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466492640-12551-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466492640-12551-1-git-send-email-chris@chris-wilson.co.uk>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 21 Jun 2016 10:44:15 +0200
Message-ID: <CAKMK7uHRATM5FFxF54C6LcBp+6h0yzbs+BmNK-2b5VO477-Abg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Wait on the reservation object when sync'ing
 before CPU access
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Sean Paul <seanpaul@google.com>,
	Zach Reizner <zachr@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 21, 2016 at 08:04:00AM +0100, Chris Wilson wrote:
> Rendering operations to the dma-buf are tracked implicitly via the
> reservation_object (dmabuf->resv). This is used to allow poll() to
> wait upon outstanding rendering (or just query the current status of
> rendering). The dma-buf sync ioctl allows userspace to prepare the
> dma-buf for CPU access, which should include waiting upon rendering.
> (Some drivers may need to do more work to ensure that the dma-buf mmap
> is coherent as well as complete.)
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: linux-kernel@vger.kernel.org
> ---
>
> I'm wondering whether it makes sense just to always do the wait first.
> It is one of the first operations every driver has to make. A driver
> that wants to implement it differently (e.g. they can special case
> native waits) will still require a wait on the reservation object to
> finish external rendering.

Worst case (if the driver uses reservation objects also internally) we'll
end up calling this twice. It should be cheap enough to do that. I'll add
a few folks who might want to chip in with an opinion ...
-Daniel

> -Chris
>
> ---
>  drivers/dma-buf/dma-buf.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index ddaee60ae52a..123f14b8e882 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -586,6 +586,22 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>
> +static int __dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> +      enum dma_data_direction direction)
> +{
> + bool write = (direction == DMA_BIDIRECTIONAL ||
> +      direction == DMA_TO_DEVICE);
> + struct reservation_object *resv = dma_buf->resv;
> + long ret;
> +
> + /* Wait on any implicit rendering fences */
> + ret = reservation_object_wait_timeout_rcu(resv, write, true,
> +  MAX_SCHEDULE_TIMEOUT);
> + if (ret < 0)
> + return ret;
> +
> + return 0;
> +}
>
>  /**
>   * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
> @@ -607,6 +623,8 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
>
>   if (dmabuf->ops->begin_cpu_access)
>   ret = dmabuf->ops->begin_cpu_access(dmabuf, direction);
> + else
> + ret = __dma_buf_begin_cpu_access(dmabuf, direction);
>
>   return ret;
>  }
> --
> 2.8.1
>

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
