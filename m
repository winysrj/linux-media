Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbeDFL5h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 07:57:37 -0400
Date: Fri, 6 Apr 2018 13:57:30 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oleksandr Andrushchenko <andr2000@gmail.com>
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
        <linux-media@vger.kernel.org>
Subject: Re: [RfC PATCH] Add udmabuf misc device
Message-ID: <20180406115730.jtwcbz5okrphlxli@sirius.home.kraxel.org>
References: <20180313154826.20436-1-kraxel@redhat.com>
 <20180313161035.GL4788@phenom.ffwll.local>
 <20180314080301.366zycak3whqvvqx@sirius.home.kraxel.org>
 <CAKMK7uGG6Z6XLc6GuKv7-3grCNg+EK2Lh6XWpavjsbZWF_L5Wg@mail.gmail.com>
 <20180406001117.GD31612@mdroper-desk.amr.corp.intel.com>
 <2411d2c1-33c0-2ba5-67ea-3bb9af5d5ec9@epam.com>
 <20180406090747.gwiegu22z4noj23i@sirius.home.kraxel.org>
 <9a085854-3758-1500-9971-806c611cb54f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a085854-3758-1500-9971-806c611cb54f@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > I fail to see any common ground for xen-zcopy and udmabuf ...

> Does the above mean you can assume that xen-zcopy and udmabuf
> can co-exist as two different solutions?

Well, udmabuf route isn't fully clear yet, but yes.

See also gvt (intel vgpu), where the hypervisor interface is abstracted
away into a separate kernel modules even though most of the actual vgpu
emulation code is common.

> And what about hyper-dmabuf?

No idea, didn't look at it in detail.

Looks pretty complex from a distant view.  Maybe because it tries to
build a communication framework using dma-bufs instead of a simple
dma-buf passing mechanism.

Like xen-zcopy it seems to depend on the idea that the hypervisor
manages all memory it is easy for guests to share pages with the help of
the hypervisor.  Which simply isn't the case on kvm.

hyper-dmabuf and xen-zcopy could maybe share code, or hyper-dmabuf build
on top of xen-zcopy.

cheers,
  Gerd
