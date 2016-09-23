Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:61523 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1035155AbcIWPUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 11:20:53 -0400
Date: Fri, 23 Sep 2016 16:20:44 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [Intel-gfx] [PATCH 11/11] dma-buf: Do a fast lockless check for
 poll with timeout=0
Message-ID: <20160923152044.GG28107@nuc-i3427.alporthouse.com>
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

Oh, it also means that

commit fb8b7d2b9d80e1e71f379e57355936bd2b024be9
Author: Jammy Zhou <Jammy.Zhou@amd.com>
Date:   Wed Jan 21 18:35:47 2015 +0800

    reservation: wait only with non-zero timeout specified (v3)
    
    When the timeout value passed to reservation_object_wait_timeout_rcu
    is zero, no wait should be done if the fences are not signaled.
    
    Return '1' for idle and '0' for busy if the specified timeout is '0'
    to keep consistent with the case of non-zero timeout.
    
    v2: call fence_put if not signaled in the case of timeout==0
    
    v3: switch to reservation_object_test_signaled_rcu
    
    Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
    Reviewed-by: Christian König <christian.koenig@amd.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Reviewed-By: Maarten Lankhorst <maarten.lankhorst@canonical.com>
    Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

is wrong. And reservation_object_test_signaled_rcu() is unreliable.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
