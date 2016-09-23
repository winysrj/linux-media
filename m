Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:59874 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1035037AbcIWPHA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 11:07:00 -0400
Date: Fri, 23 Sep 2016 16:06:54 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [Intel-gfx] [PATCH 11/11] dma-buf: Do a fast lockless check for
 poll with timeout=0
Message-ID: <20160923150654.GF28107@nuc-i3427.alporthouse.com>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-11-chris@chris-wilson.co.uk>
 <20160923135044.GM3988@dvetter-linux.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160923135044.GM3988@dvetter-linux.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 23, 2016 at 03:50:44PM +0200, Daniel Vetter wrote:
> On Mon, Aug 29, 2016 at 08:08:34AM +0100, Chris Wilson wrote:
> > Currently we install a callback for performing poll on a dma-buf,
> > irrespective of the timeout. This involves taking a spinlock, as well as
> > unnecessary work, and greatly reduces scaling of poll(.timeout=0) across
> > multiple threads.
> > 
> > We can query whether the poll will block prior to installing the
> > callback to make the busy-query fast.
> > 
> > Single thread: 60% faster
> > 8 threads on 4 (+4 HT) cores: 600% faster
> > 
> > Still not quite the perfect scaling we get with a native busy ioctl, but
> > poll(dmabuf) is faster due to the quicker lookup of the object and
> > avoiding drm_ioctl().
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linaro-mm-sig@lists.linaro.org
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Need to strike the r-b here, since Christian König pointed out that
> objects won't magically switch signalling on.

Propagating a flag through to sync_file is trivial, but not through to
the dma_buf->resv. Looks like dma-buf will be without a fast busy query,
which I guess in the grand scheme of things (i.e. dma-buf itself is not
intended to be used as a fence) is not that important.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
