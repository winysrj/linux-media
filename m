Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35171 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753257AbdCFPJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 10:09:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, Laura Abbott <labbott@redhat.com>,
        devel@driverdev.osuosl.org, romlem@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        arve@android.com, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Riley Andrews <riandrews@android.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of staging
Date: Mon, 06 Mar 2017 17:02:05 +0200
Message-ID: <9366352.DJUlrUijoL@avalon>
In-Reply-To: <20170306103820.ixuvs7fd6s4tvfzy@phenom.ffwll.local>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com> <10344634.XsotFaGzfj@avalon> <20170306103820.ixuvs7fd6s4tvfzy@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Monday 06 Mar 2017 11:38:20 Daniel Vetter wrote:
> On Fri, Mar 03, 2017 at 06:45:40PM +0200, Laurent Pinchart wrote:
> > - I haven't seen any proposal how a heap-based solution could be used in a
> > generic distribution. This needs to be figured out before committing to
> > any API/ABI.
> 
> Two replies from my side:
> 
> - Just because a patch doesn't solve world hunger isn't really a good
>   reason to reject it.

As long as it goes in the right direction, sure :-) The points I mentioned 
were to be interpreted that way, I want to make sure we're not going in a 
dead-end (or worse, driving full speed into a wall).

> - Heap doesn't mean its not resizeable (but I'm not sure that's really
>   your concern).

Not really, no. Heap is another word to mean pool here. It might not be the 
best term in this context as it has a precise meaning in the context of memory 
allocation, but that's a detail.

> - Imo ION is very much part of the picture here to solve this for real. We
>   need to bits:
> 
>   * Be able to allocate memory from specific pools, not going through a
>     specific driver. ION gives us that interface. This is e.g. also needed
>     for "special" memory, like SMA tries to expose.
> 
>   * Some way to figure out how&where to allocate the buffer object. This
>     is purely a userspace problem, and this is the part the unix memory
>     allocator tries to solve. There's no plans in there for big kernel
>     changes, instead userspace does a dance to reconcile all the
>     constraints, and one of the constraints might be "you have to allocate
>     this from this special ION heap". The only thing the kernel needs to
>     expose is which devices use which ION heaps (we kinda do that
>     already), and maybe some hints of how they can be generalized (but I
>     guess stuff like "minimal pagesize of x KB" is also fulfilled by any
>     CMA heap is knowledge userspace needs).

The constraint solver could live in userspace, I'm open to a solution that 
would go in that direction, but it will require help from the kernel to fetch 
the constraints from the devices that need to be involved in buffer sharing.

Given a userspace constraint resolver, the interface with the kernel allocator 
will likely be based on pools. I'm not opposed to that, as long as pool are 
identified by opaque handles. I don't want userspace to know about the meaning 
of any particular ION heap. Application must not attempt to "allocate from 
CMA" for instance, that would lock us to a crazy API that will grow completely 
out of hands as vendors will start adding all kind of custom heaps, and 
applications will have to follow (or will be patched out-of-tree by vendors).

> Again I think waiting for this to be fully implemented before we merge any
> part is going to just kill any upstreaming efforts. ION in itself, without
> the full buffer negotiation dance seems clearly useful (also for stuff
> like SMA), and having it merged will help with moving the buffer
> allocation dance forward.

Again I'm not opposed to a kernel allocator based on pools/heaps, as long as

- pools/heaps stay internal to the kernel and are not directly exposed to 
userspace

- a reasonable way to size the different kinds of pools in a generic 
distribution kernel can be found

-- 
Regards,

Laurent Pinchart
