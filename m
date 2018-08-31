Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbeHaLK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 07:10:28 -0400
Date: Fri, 31 Aug 2018 09:04:24 +0200
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
Message-ID: <20180831070424.3xoxfy54vyxbdfzd@sirius.home.kraxel.org>
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
 <9818b301-9c9d-c703-d4fe-7c2d4d43ed66@collabora.com>
 <20180704080005.juutrwri4kxm7yim@sirius.home.kraxel.org>
 <06d8aa8d-5eac-64e2-f21e-43fe7ca96cc2@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06d8aa8d-5eac-64e2-f21e-43fe7ca96cc2@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > qemu can use memfd to allocate guest ram.  Now, with the help of
> > udmabuf, qemu can create a *host* dma-buf for the *guest* graphics
> > buffer.
> 
> Guess each physical address in the iovec in
> VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING can be passed as the offset in the
> udmabuf_create_item struct?

Exactly.

https://git.kraxel.org/cgit/qemu/commit/?h=sirius/udmabuf&id=515a5b9f1215ea668a992e39d66993a17a940801

> Are you thinking of anything else besides passing the winsrv protocol across
> the guest/host boundary? Just wondering if I'm missing something.

The patch above uses the dmabuf internally in qemu.  It simply mmaps it,
so qemu has a linear representation of the resource and can use it as
pixman image backing storage without copying the pixel data.

So it is useful even without actually exporting the dmabuf to other
processes.

cheers,
  Gerd

PS: Any chance you can review the v7 patch?
