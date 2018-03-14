Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751317AbeCNIDH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 04:03:07 -0400
Date: Wed, 14 Mar 2018 09:03:01 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [RfC PATCH] Add udmabuf misc device
Message-ID: <20180314080301.366zycak3whqvvqx@sirius.home.kraxel.org>
References: <20180313154826.20436-1-kraxel@redhat.com>
 <20180313161035.GL4788@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180313161035.GL4788@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> Either mlock account (because it's mlocked defacto), and get_user_pages
> won't do that for you.
> 
> Or you write the full-blown userptr implementation, including mmu_notifier
> support (see i915 or amdgpu), but that also requires Christian Königs
> latest ->invalidate_mapping RFC for dma-buf (since atm exporting userptr
> buffers is a no-go).

I guess I'll look at mlock accounting for starters then.  Easier for
now, and leaves the door open to switch to userptr later as this should
be transparent to userspace.

> > Known issue:  Driver API isn't complete yet.  Need add some flags, for
> > example to support read-only buffers.
> 
> dma-buf has no concept of read-only. I don't think we can even enforce
> that (not many iommus can enforce this iirc), so pretty much need to
> require r/w memory.

Ah, ok.  Just saw the 'write' arg for get_user_pages_fast and figured we
might support that, but if iommus can't handle that anyway it's
pointless indeed.

> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> btw there's also the hyperdmabuf stuff from the xen folks, but imo their
> solution of forwarding the entire dma-buf api is over the top. This here
> looks _much_ better, pls cc all the hyperdmabuf people on your next
> version.

Fun fact: googling for "hyperdmabuf" found me your mail and nothing else :-o
(Trying "hyper dmabuf" instead worked better then).

Yes, will cc them on the next version.  Not sure it'll help much on xen
though due to the memory management being very different.  Basically xen
owns the memory, not the kernel of the control domain (dom0), so
creating dmabufs for guest memory chunks isn't that simple ...

Also it's not clear whenever they really need guest -> guest exports or
guest -> dom0 exports.

> Overall I like the idea, but too lazy to review.

Cool.  General comments on the idea was all I was looking for for the
moment.  Spare yor review cycles for the next version ;)

> Oh, some kselftests for this stuff would be lovely.

I'll look into it.

thanks,
  Gerd
