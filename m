Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43043 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeGFEA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 00:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
References: <20180703075359.30349-1-kraxel@redhat.com> <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org> <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
 <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
From: Dave Airlie <airlied@gmail.com>
Date: Fri, 6 Jul 2018 14:00:55 +1000
Message-ID: <CAPM=9tyRRSPa2xk1ZjWLVYG2mro=wMNFK3T70m0TtME-wg9dBA@mail.gmail.com>
Subject: Re: [PATCH v6] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Daniel Stone <daniels@collabora.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Airlie <airlied@linux.ie>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 July 2018 at 18:00, Gerd Hoffmann <kraxel@redhat.com> wrote:
> On Wed, Jul 04, 2018 at 09:26:39AM +0200, Tomeu Vizoso wrote:
>> On 07/04/2018 07:53 AM, Gerd Hoffmann wrote:
>> > On Tue, Jul 03, 2018 at 10:37:57AM +0200, Daniel Vetter wrote:
>> > > On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
>> > > > A driver to let userspace turn memfd regions into dma-bufs.
>> > > >
>> > > > Use case:  Allows qemu create dmabufs for the vga framebuffer or
>> > > > virtio-gpu ressources.  Then they can be passed around to display
>> > > > those guest things on the host.  To spice client for classic full
>> > > > framebuffer display, and hopefully some day to wayland server for
>> > > > seamless guest window display.
>> > > >
>> > > > qemu test branch:
>> > > >    https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
>> > > >
>> > > > Cc: David Airlie <airlied@linux.ie>
>> > > > Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
>> > > > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> > >
>> > > I think some ack for a 2nd use-case, like virtio-wl or whatever would be
>> > > really cool. To give us some assurance that this is generically useful.
>> >
>> > Tomeu?  Laurent?
>>
>> Sorry, but I think I will need some help to understand how this could help
>> in the virtio-wl case [adding Zach Reizner to CC].
>>
>> Any graphics buffers that are allocated with memfd will be shared with the
>> compositor via wl_shm, without need for dmabufs.
>
> Within one machine, yes.  Once virtualization is added to the mix things
> become more complicated ...
>
> When using virtio-gpu the guest will allocate graphics buffers from
> normal (guest) ram, then register these buffers (which are allowed to be
> scattered) with the host as resource.
>
> qemu can use memfd to allocate guest ram.  Now, with the help of
> udmabuf, qemu can create a *host* dma-buf for the *guest* graphics
> buffer.
>
> That dma-buf can be used by qemu internally (mmap it to get a linear
> mapping of the resource, to avoid copying).  It can be passed on to
> spice-client, to display the guest framebuffer.
>
> And I think it could also be quite useful to pass guest wayland windows
> to the host compositor, without mapping host-allocated buffers into the
> guest, so we don't have do deal with the "find some address space for
> the mapping" issue in the first place.  There are more things needed to
> complete this of course, but it's a building block ...

There is a use case where I think we have to deal with the "find some address
space" problem. For GL4.4 ARB_buffer_storage and Vulkan memory mangement
there is the concept of coherent buffers between GPU and CPU. From the
virgl point of view, we'd create a host buffer in GL, and then create
a mapping from
it on the host that we'd need to present in the guest userspace as a
linear buffer.

Just in case we think this can solve all our problems :-)

Dave.
