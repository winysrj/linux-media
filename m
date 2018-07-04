Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46260 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932815AbeGDJT6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 05:19:58 -0400
Received: by mail-ed1-f67.google.com with SMTP id r17-v6so3539849edo.13
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 02:19:57 -0700 (PDT)
Date: Wed, 4 Jul 2018 11:19:54 +0200
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
Message-ID: <20180704091954.GQ3891@phenom.ffwll.local>
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
 <20180704080807.GH3891@phenom.ffwll.local>
 <20180704085825.nfkv5i7ultaavjve@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704085825.nfkv5i7ultaavjve@sirius.home.kraxel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 04, 2018 at 10:58:25AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > > Hmm, does MAINTAINERS need an update then?  Maintainer and mailing lists
> > > listed in the "DMA BUFFER SHARING FRAMEWORK" entry are on Cc.
> > 
> > Yeah, maintainers entry with you as maintainer plus dri-devel as mailing
> > list plus drm-misc as repo would be good. Just grep for drm-misc.git for
> > tons of examples.
> 
> There is an *existing* entry covering drivers/dma-buf/, and I've dropped
> udmabuf.c into that directory, so I've assumed get_maintainers.pl picks
> up all relevant dma-buf folks ...
> 
> Covering udmabuf.c maintainance is a different issue.  I could just add
> myself to the existing entry, or create a new one specifically for
> udmabuf.

That's what I meant, do a more specific entry to add yourself just for
udmabuf.

> > > Who should be Cc'ed?
> > 
> > dim add-missing-cc ftw :-)
> 
> That just uses get_maintainer.pl according to the docs, so that wouldn't
> change things as that is wired up as sendemail.cccmd already.  Except
> that dim would probably add the list of people to the commit message.

Ah right, I totally missed that you have more on the mail's Cc: than on
the patch. I never do that, so always miss them :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
