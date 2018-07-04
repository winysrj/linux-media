Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934034AbeGDIAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 04:00:07 -0400
Date: Wed, 4 Jul 2018 10:00:05 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Zach Reizner <zachr@google.com>,
        Daniel Stone <daniels@collabora.com>
Subject: Re: [PATCH v6] Add udmabuf misc device
Message-ID: <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
 <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 04, 2018 at 09:26:39AM +0200, Tomeu Vizoso wrote:
> On 07/04/2018 07:53 AM, Gerd Hoffmann wrote:
> > On Tue, Jul 03, 2018 at 10:37:57AM +0200, Daniel Vetter wrote:
> > > On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
> > > > A driver to let userspace turn memfd regions into dma-bufs.
> > > > 
> > > > Use case:  Allows qemu create dmabufs for the vga framebuffer or
> > > > virtio-gpu ressources.  Then they can be passed around to display
> > > > those guest things on the host.  To spice client for classic full
> > > > framebuffer display, and hopefully some day to wayland server for
> > > > seamless guest window display.
> > > > 
> > > > qemu test branch:
> > > >    https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
> > > > 
> > > > Cc: David Airlie <airlied@linux.ie>
> > > > Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > > 
> > > I think some ack for a 2nd use-case, like virtio-wl or whatever would be
> > > really cool. To give us some assurance that this is generically useful.
> > 
> > Tomeu?  Laurent?
> 
> Sorry, but I think I will need some help to understand how this could help
> in the virtio-wl case [adding Zach Reizner to CC].
> 
> Any graphics buffers that are allocated with memfd will be shared with the
> compositor via wl_shm, without need for dmabufs.

Within one machine, yes.  Once virtualization is added to the mix things
become more complicated ...

When using virtio-gpu the guest will allocate graphics buffers from
normal (guest) ram, then register these buffers (which are allowed to be
scattered) with the host as resource.

qemu can use memfd to allocate guest ram.  Now, with the help of
udmabuf, qemu can create a *host* dma-buf for the *guest* graphics
buffer.

That dma-buf can be used by qemu internally (mmap it to get a linear
mapping of the resource, to avoid copying).  It can be passed on to
spice-client, to display the guest framebuffer.

And I think it could also be quite useful to pass guest wayland windows
to the host compositor, without mapping host-allocated buffers into the
guest, so we don't have do deal with the "find some address space for
the mapping" issue in the first place.  There are more things needed to
complete this of course, but it's a building block ...

cheers,
  Gerd
