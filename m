Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:63904 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752724AbcLSKX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 05:23:56 -0500
Date: Mon, 19 Dec 2016 10:23:48 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-buf: Wait on the reservation object when sync'ing
 before CPU access
Message-ID: <20161219102348.GK29871@nuc-i3427.alporthouse.com>
References: <1466492640-12551-1-git-send-email-chris@chris-wilson.co.uk>
 <1471275738-31994-1-git-send-email-chris@chris-wilson.co.uk>
 <CGME20160815160224epcas1p4e018a4a885cf4af16563cc3b26ec4b6e@epcas1p4.samsung.com>
 <20160815160214.GK6232@phenom.ffwll.local>
 <58573A99.2050809@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58573A99.2050809@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 19, 2016 at 10:40:41AM +0900, Inki Dae wrote:
> 
> 
> 2016년 08월 16일 01:02에 Daniel Vetter 이(가) 쓴 글:
> > On Mon, Aug 15, 2016 at 04:42:18PM +0100, Chris Wilson wrote:
> >> Rendering operations to the dma-buf are tracked implicitly via the
> >> reservation_object (dmabuf->resv). This is used to allow poll() to
> >> wait upon outstanding rendering (or just query the current status of
> >> rendering). The dma-buf sync ioctl allows userspace to prepare the
> >> dma-buf for CPU access, which should include waiting upon rendering.
> >> (Some drivers may need to do more work to ensure that the dma-buf mmap
> >> is coherent as well as complete.)
> >>
> >> v2: Always wait upon the reservation object implicitly. We choose to do
> >> it after the native handler in case it can do so more efficiently.
> >>
> >> Testcase: igt/prime_vgem
> >> Testcase: igt/gem_concurrent_blit # *vgem*
> >> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Cc: Eric Anholt <eric@anholt.net>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: dri-devel@lists.freedesktop.org
> >> Cc: linaro-mm-sig@lists.linaro.org
> >> Cc: linux-kernel@vger.kernel.org
> >> ---
> >>  drivers/dma-buf/dma-buf.c | 23 +++++++++++++++++++++++
> >>  1 file changed, 23 insertions(+)
> >>
> >> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >> index ddaee60ae52a..cf04d249a6a4 100644
> >> --- a/drivers/dma-buf/dma-buf.c
> >> +++ b/drivers/dma-buf/dma-buf.c
> >> @@ -586,6 +586,22 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
> >>  }
> >>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
> >>  
> >> +static int __dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> >> +				      enum dma_data_direction direction)
> >> +{
> >> +	bool write = (direction == DMA_BIDIRECTIONAL ||
> >> +		      direction == DMA_TO_DEVICE);
> >> +	struct reservation_object *resv = dmabuf->resv;
> >> +	long ret;
> >> +
> >> +	/* Wait on any implicit rendering fences */
> >> +	ret = reservation_object_wait_timeout_rcu(resv, write, true,
> >> +						  MAX_SCHEDULE_TIMEOUT);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	return 0;
> >> +}
> >>  
> >>  /**
> >>   * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
> >> @@ -608,6 +624,13 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> >>  	if (dmabuf->ops->begin_cpu_access)
> >>  		ret = dmabuf->ops->begin_cpu_access(dmabuf, direction);
> >>  
> >> +	/* Ensure that all fences are waited upon - but we first allow
> >> +	 * the native handler the chance to do so more efficiently if it
> >> +	 * chooses. A double invocation here will be reasonably cheap no-op.
> >> +	 */
> >> +	if (ret == 0)
> >> +		ret = __dma_buf_begin_cpu_access(dmabuf, direction);
> > 
> > Not sure we should wait first and the flush or the other way round. But I
> > don't think it'll matter for any current dma-buf exporter, so meh.
> > 
> 
> Sorry for late comment. I wonder there is no problem in case that GPU or other DMA device tries to access this dma buffer after dma_buf_begin_cpu_access call.
> I think in this case, they - GPU or DMA devices - would make a mess of the dma buffer while CPU is accessing the buffer.
> 
> This patch is in mainline already so if this is real problem then I think we sould choose,
> 1. revert this patch from mainline

That scenario is irrespective of this patch. It just depends on there
being concurrent CPU access with destructive DMA access (or vice-versa).

> 2. make sure to prevent other DMA devices to try to access the buffer while CPU is accessing the buffer.

Is the safeguard you want, and the one employed elsewhere, which you could
accomplish by adding a fence to the reservation object for the CPU access
in begin_access and signaling from end_access. It would need to be an
autosignaled fence because userspace may forget to end its access
(or otherwise be terminated whilst holding the fence).

Everyone using the mmap without begin/end can of course still reek havoc
on the buffer.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
