Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36264 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbeGDH0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 03:26:44 -0400
Subject: Re: [PATCH v6] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
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
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Message-ID: <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
Date: Wed, 4 Jul 2018 09:26:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2018 07:53 AM, Gerd Hoffmann wrote:
> On Tue, Jul 03, 2018 at 10:37:57AM +0200, Daniel Vetter wrote:
>> On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
>>> A driver to let userspace turn memfd regions into dma-bufs.
>>>
>>> Use case:  Allows qemu create dmabufs for the vga framebuffer or
>>> virtio-gpu ressources.  Then they can be passed around to display
>>> those guest things on the host.  To spice client for classic full
>>> framebuffer display, and hopefully some day to wayland server for
>>> seamless guest window display.
>>>
>>> qemu test branch:
>>>    https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
>>>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>>
>> I think some ack for a 2nd use-case, like virtio-wl or whatever would be
>> really cool. To give us some assurance that this is generically useful.
> 
> Tomeu?  Laurent?

Sorry, but I think I will need some help to understand how this could 
help in the virtio-wl case [adding Zach Reizner to CC].

Any graphics buffers that are allocated with memfd will be shared with 
the compositor via wl_shm, without need for dmabufs.

Daniel Stone [added to CC] commented though that this could be useful for 
browsers that composite pages with a nested Wayland compositor, to avoid 
having to blit each layer so that the EGL platform notifies the 
compositor of new contents.

Cheers,

Tomeu

>> Plus an ack from dma-buf folks (nag them on irc, you don't have them on Cc
>> here).
> 
> Hmm, does MAINTAINERS need an update then?  Maintainer and mailing lists
> listed in the "DMA BUFFER SHARING FRAMEWORK" entry are on Cc.
> 
> Who should be Cc'ed?
> 
>> Then this is imo good to go.
>>
>> I assume you'll push it to drm-misc, like all the other dma-buf stuff?
> 
> Can do that, sure, after collecting the acks ...
> 
> thanks,
>    Gerd
> 
