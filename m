Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37972 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbeDIIVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 04:21:35 -0400
Received: by mail-wm0-f41.google.com with SMTP id i3so14734609wmf.3
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 01:21:34 -0700 (PDT)
Date: Mon, 9 Apr 2018 10:21:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] Add udmabuf misc device
Message-ID: <20180409082131.GF31310@phenom.ffwll.local>
References: <20180316074650.5415-1-kraxel@redhat.com>
 <7547e99b-0e3c-264e-e52b-40ad5d52b49a@gmail.com>
 <20180406093307.s7wkhpmddd5d4r7a@sirius.home.kraxel.org>
 <5d88baad-a956-6bd5-e0d6-aabae6647f3e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d88baad-a956-6bd5-e0d6-aabae6647f3e@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 06, 2018 at 02:24:46PM +0200, Christian König wrote:
> Am 06.04.2018 um 11:33 schrieb Gerd Hoffmann:
> >    Hi,
> > 
> > > The pages backing a DMA-buf are not allowed to move (at least not without a
> > > patch set I'm currently working on), but for certain MM operations to work
> > > correctly you must be able to modify the page tables entries and move the
> > > pages backing them around.
> > > 
> > > For example try to use fork() with some copy on write pages with this
> > > approach. You will find that you have only two options to correctly handle
> > > this.
> > The fork() issue should go away with shared memory pages (no cow).
> > I guess this is the reason why vgem is internally backed by shmem.
> 
> Yes, exactly that is also an approach which should work fine. Just don't try
> to get this working with get_user_pages().
> 
> > 
> > Hmm.  So I could try to limit the udmabuf driver to shmem too (i.e.
> > have the ioctl take a shmem filehandle and offset instead of a virtual
> > address).
> > 
> > But maybe it is better then to just extend vgem, i.e. add support to
> > create gem objects from existing shmem.
> > 
> > Comments?
> 
> Yes, extending vgem instead of creating something new sounds like a good
> idea to me as well.

+1 on adding a vgem "import from shmem/memfd" ioctl. Sounds like a good
idea, and generally useful.

We might want to limit to memfd though for semantic reasons: dma-buf have
invariant size, shmem not so much. memfd can be locked down to not change
their size anymore. And iirc the core mm page invalidation protocol around
truncate() is about as bad as get_user_pages vs cow :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
