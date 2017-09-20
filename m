Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:52222 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdITSU5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 14:20:57 -0400
Received: by mail-io0-f177.google.com with SMTP id l15so5544462iol.8
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 11:20:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79e447f8-f2e3-57e3-b5fe-503e5feb2f82@amd.com>
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
 <150453243791.23157.6907537389223890207@mail.alporthouse.com>
 <67fe7e05-7743-40c8-558b-41b08eb986e9@amd.com> <150512037119.16759.472484663447331384@mail.alporthouse.com>
 <3c412ee3-854a-292a-e036-7c5fd7888979@amd.com> <150512178199.16759.73667469529688@mail.alporthouse.com>
 <5ff4b100-b580-a93d-aa5e-c66173ac091d@amd.com> <150512410278.16759.10537429613477592631@mail.alporthouse.com>
 <79e447f8-f2e3-57e3-b5fe-503e5feb2f82@amd.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 20 Sep 2017 20:20:56 +0200
Message-ID: <CAKMK7uGkEFzbrhAS1qWs-g3dC20jubXitR5ALkTg4PhMwoQ-Rg@mail.gmail.com>
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 01:06:32PM +0200, Christian K=C3=B6nig wrote:
> Am 11.09.2017 um 12:01 schrieb Chris Wilson:
> > [SNIP]
> > > Yeah, but that is illegal with a fence objects.
> > >
> > > When anybody allocates fences this way it breaks at least
> > > reservation_object_get_fences_rcu(),
> > > reservation_object_wait_timeout_rcu() and
> > > reservation_object_test_signaled_single().
> > Many, many months ago I sent patches to fix them all.
>
> Found those after a bit a searching. Yeah, those patches where proposed m=
ore
> than a year ago, but never pushed upstream.
>
> Not sure if we really should go this way. dma_fence objects are shared
> between drivers and since we can't judge if it's the correct fence based =
on
> a criteria in the object (only the read counter which is outside) all
> drivers need to be correct for this.
>
> I would rather go the way and change dma_fence_release() to wrap
> fence->ops->release into call_rcu() to keep the whole RCU handling outsid=
e
> of the individual drivers.

Hm, I entirely dropped the ball on this, I kinda assumed that we managed
to get some agreement on this between i915 and dma_fence. Adding a pile
more people.

Joonas, Tvrtko, I guess we need to fix this one way or the other.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
