Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752925AbeDJOWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 10:22:18 -0400
Date: Tue, 10 Apr 2018 16:22:12 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Daniel Stone <daniel@fooishbar.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>, qemu-devel@nongnu.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [RfC PATCH] Add udmabuf misc device
Message-ID: <20180410142212.f3mudidizexxvnys@sirius.home.kraxel.org>
References: <20180313154826.20436-1-kraxel@redhat.com>
 <20180313161035.GL4788@phenom.ffwll.local>
 <20180314080301.366zycak3whqvvqx@sirius.home.kraxel.org>
 <CAPj87rPKtuQ4SZePYDUesWY9VSSGR=1p-LO=yByY_6Q8=BfoyA@mail.gmail.com>
 <20180406105422.6tewkkciwerud3tm@sirius.home.kraxel.org>
 <20180409080051.GD31310@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409080051.GD31310@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> Generally we try to cache mappings as much as possible. And wrt finding a
> slot: Create a sufficiently sized BAR on the virgl device, just for that?

Well.  virtio has no concept of "bars" ...

The most common virtio transport layer happens to be pci, which actually
has bars.  But we also have virtio-mmio (largely unused since arm got
pci) and virtio-ccw (used on s390x).

In any case it would be a layering violation.

Figured meanwhile qemu got memfd support recently, i.e. it can be
configured to back guest memory with memfd.  Which makes the memfd route
quite attractive.  Guess I try switch udmabuf to require memfd storage
as proof-of-concept.

cheers,
  Gerd
