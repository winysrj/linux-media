Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33792 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeDFMgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 08:36:07 -0400
Subject: Re: [RfC PATCH] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Dongwon Kim <dongwon.kim@intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        qemu-devel@nongnu.org,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        Matt Roper <matthew.d.roper@intel.com>
References: <20180313154826.20436-1-kraxel@redhat.com>
 <20180313161035.GL4788@phenom.ffwll.local>
 <20180314080301.366zycak3whqvvqx@sirius.home.kraxel.org>
 <CAKMK7uGG6Z6XLc6GuKv7-3grCNg+EK2Lh6XWpavjsbZWF_L5Wg@mail.gmail.com>
 <20180406001117.GD31612@mdroper-desk.amr.corp.intel.com>
 <2411d2c1-33c0-2ba5-67ea-3bb9af5d5ec9@epam.com>
 <20180406090747.gwiegu22z4noj23i@sirius.home.kraxel.org>
 <9a085854-3758-1500-9971-806c611cb54f@gmail.com>
 <20180406115730.jtwcbz5okrphlxli@sirius.home.kraxel.org>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <7ef89a29-6584-d23c-efd1-f30d9b767a24@gmail.com>
Date: Fri, 6 Apr 2018 15:36:03 +0300
MIME-Version: 1.0
In-Reply-To: <20180406115730.jtwcbz5okrphlxli@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2018 02:57 PM, Gerd Hoffmann wrote:
>    Hi,
>
>>> I fail to see any common ground for xen-zcopy and udmabuf ...
>> Does the above mean you can assume that xen-zcopy and udmabuf
>> can co-exist as two different solutions?
> Well, udmabuf route isn't fully clear yet, but yes.
>
> See also gvt (intel vgpu), where the hypervisor interface is abstracted
> away into a separate kernel modules even though most of the actual vgpu
> emulation code is common.
Thank you for your input, I'm just trying to figure out
which of the three z-copy solutions intersect and how much
>> And what about hyper-dmabuf?
> No idea, didn't look at it in detail.
>
> Looks pretty complex from a distant view.  Maybe because it tries to
> build a communication framework using dma-bufs instead of a simple
> dma-buf passing mechanism.
Yes, I am looking at it now, trying to figure out the full story
and its implementation. BTW, Intel guys were about to share some
test application for hyper-dmabuf, maybe I have missed one.
It could probably better explain the use-cases and the complexity
they have in hyper-dmabuf.
>
> Like xen-zcopy it seems to depend on the idea that the hypervisor
> manages all memory it is easy for guests to share pages with the help of
> the hypervisor.
So, for xen-zcopy we were not trying to make it generic,
it just solves display (dumb) zero-copying use-cases for Xen.
We implemented it as a DRM helper driver because we can't see any
other use-cases as of now.
For example, we also have Xen para-virtualized sound driver, but
its buffer memory usage is not comparable to what display wants
and it works somewhat differently (e.g. there is no "frame done"
event, so one can't tell when the sound buffer can be "flipped").
At the same time, we do not use virtio-gpu, so this could probably
be one more candidate for shared dma-bufs some day.
>    Which simply isn't the case on kvm.
>
> hyper-dmabuf and xen-zcopy could maybe share code, or hyper-dmabuf build
> on top of xen-zcopy.
Hm, I can imagine that: xen-zcopy could be a library code for hyper-dmabuf
in terms of implementing all that page sharing fun in multiple directions,
e.g. Host->Guest, Guest->Host, Guest<->Guest.
But I'll let Matt and Dongwon to comment on that.

>
> cheers,
>    Gerd
>
Thank you,
Oleksandr

P.S. Sorry for making your original mail thread to discuss things much
broader than your RFC...
