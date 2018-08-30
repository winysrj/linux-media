Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37284 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeH3TUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 15:20:17 -0400
Subject: Re: [PATCH v6] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
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
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
 <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
 <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Message-ID: <06d8aa8d-5eac-64e2-f21e-43fe7ca96cc2@collabora.com>
Date: Thu, 30 Aug 2018 17:17:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2018 10:00 AM, Gerd Hoffmann wrote:
> On Wed, Jul 04, 2018 at 09:26:39AM +0200, Tomeu Vizoso wrote:
>> On 07/04/2018 07:53 AM, Gerd Hoffmann wrote:
>>> On Tue, Jul 03, 2018 at 10:37:57AM +0200, Daniel Vetter wrote:
>>>> On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
>>>>> A driver to let userspace turn memfd regions into dma-bufs.
>>>>>
>>>>> Use case:  Allows qemu create dmabufs for the vga framebuffer or
>>>>> virtio-gpu ressources.  Then they can be passed around to display
>>>>> those guest things on the host.  To spice client for classic full
>>>>> framebuffer display, and hopefully some day to wayland server for
>>>>> seamless guest window display.
>>>>>
>>>>> qemu test branch:
>>>>>     https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
>>>>>
>>>>> Cc: David Airlie <airlied@linux.ie>
>>>>> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>>>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>>>>
>>>> I think some ack for a 2nd use-case, like virtio-wl or whatever would be
>>>> really cool. To give us some assurance that this is generically useful.
>>>
>>> Tomeu?  Laurent?
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

Guess each physical address in the iovec in 
VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING can be passed as the offset in the 
udmabuf_create_item struct?

> That dma-buf can be used by qemu internally (mmap it to get a linear
> mapping of the resource, to avoid copying).  It can be passed on to
> spice-client, to display the guest framebuffer.
> 
> And I think it could also be quite useful to pass guest wayland windows
> to the host compositor, without mapping host-allocated buffers into the
> guest, so we don't have do deal with the "find some address space for
> the mapping" issue in the first place.

Sounds good to me if the answer to the above is "yes".

> There are more things needed to
> complete this of course, but it's a building block ...

Are you thinking of anything else besides passing the winsrv protocol 
across the guest/host boundary? Just wondering if I'm missing something.

Thanks,

Tomeu
