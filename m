Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44001 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933324AbeGDIIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:08:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id u11-v6so3387506eds.10
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 01:08:11 -0700 (PDT)
Date: Wed, 4 Jul 2018 10:08:07 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
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
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6] Add udmabuf misc device
Message-ID: <20180704080807.GH3891@phenom.ffwll.local>
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 04, 2018 at 07:53:38AM +0200, Gerd Hoffmann wrote:
> On Tue, Jul 03, 2018 at 10:37:57AM +0200, Daniel Vetter wrote:
> > On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
> > > A driver to let userspace turn memfd regions into dma-bufs.
> > > 
> > > Use case:  Allows qemu create dmabufs for the vga framebuffer or
> > > virtio-gpu ressources.  Then they can be passed around to display
> > > those guest things on the host.  To spice client for classic full
> > > framebuffer display, and hopefully some day to wayland server for
> > > seamless guest window display.
> > > 
> > > qemu test branch:
> > >   https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
> > > 
> > > Cc: David Airlie <airlied@linux.ie>
> > > Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > 
> > I think some ack for a 2nd use-case, like virtio-wl or whatever would be
> > really cool. To give us some assurance that this is generically useful.
> 
> Tomeu?  Laurent?
> 
> > Plus an ack from dma-buf folks (nag them on irc, you don't have them on Cc
> > here).
> 
> Hmm, does MAINTAINERS need an update then?  Maintainer and mailing lists
> listed in the "DMA BUFFER SHARING FRAMEWORK" entry are on Cc.

Yeah, maintainers entry with you as maintainer plus dri-devel as mailing
list plus drm-misc as repo would be good. Just grep for drm-misc.git for
tons of examples.

> Who should be Cc'ed?

dim add-missing-cc ftw :-)

Cheers, Daniel
> 
> > Then this is imo good to go.
> > 
> > I assume you'll push it to drm-misc, like all the other dma-buf stuff?
> 
> Can do that, sure, after collecting the acks ...
> 
> thanks,
>   Gerd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
