Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:56699 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751712AbdIKKBy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 06:01:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Chris Wilson <chris@chris-wilson.co.uk>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        daniel.vetter@ffwll.ch, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
 <150453243791.23157.6907537389223890207@mail.alporthouse.com>
 <67fe7e05-7743-40c8-558b-41b08eb986e9@amd.com>
 <150512037119.16759.472484663447331384@mail.alporthouse.com>
 <3c412ee3-854a-292a-e036-7c5fd7888979@amd.com>
 <150512178199.16759.73667469529688@mail.alporthouse.com>
 <5ff4b100-b580-a93d-aa5e-c66173ac091d@amd.com>
In-Reply-To: <5ff4b100-b580-a93d-aa5e-c66173ac091d@amd.com>
Message-ID: <150512410278.16759.10537429613477592631@mail.alporthouse.com>
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
Date: Mon, 11 Sep 2017 11:01:42 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Christian König (2017-09-11 10:57:57)
> Am 11.09.2017 um 11:23 schrieb Chris Wilson:
> > Quoting Christian König (2017-09-11 10:06:50)
> >> Am 11.09.2017 um 10:59 schrieb Chris Wilson:
> >>> Quoting Christian König (2017-09-11 09:50:40)
> >>>> Sorry for the delayed response, but your mail somehow ended up in the
> >>>> Spam folder.
> >>>>
> >>>> Am 04.09.2017 um 15:40 schrieb Chris Wilson:
> >>>>> Quoting Christian König (2017-09-04 14:27:33)
> >>>>>> From: Christian König <christian.koenig@amd.com>
> >>>>>>
> >>>>>> The logic is buggy and unnecessary complex. When dma_fence_get_rcu() fails to
> >>>>>> acquire a reference it doesn't necessary mean that there is no fence at all.
> >>>>>>
> >>>>>> It usually mean that the fence was replaced by a new one and in this situation
> >>>>>> we certainly want to have the new one as result and *NOT* NULL.
> >>>>> Which is not guaranteed by the code you wrote either.
> >>>>>
> >>>>> The point of the comment is that the mb is only inside the successful
> >>>>> kref_atomic_inc_unless_zero, and that only after that mb do you know
> >>>>> whether or not you have the current fence.
> >>>>>
> >>>>> You can argue that you want to replace the
> >>>>>         if (!dma_fence_get_rcu())
> >>>>>                 return NULL
> >>>>> with
> >>>>>         if (!dma_fence_get_rcu()
> >>>>>                 continue;
> >>>>> but it would be incorrect to say that by simply ignoring the
> >>>>> post-condition check that you do have the right fence.
> >>>> You are completely missing the point here.
> >>>>
> >>>> It is irrelevant if you have the current fence or not when you return.
> >>>> You can only guarantee that it is the current fence when you take a look
> >>>> and that is exactly what we want to avoid.
> >>>>
> >>>> So the existing code is complete nonsense. Instead what we need to
> >>>> guarantee is that we return *ANY* fence which we can grab a reference for.
> >>> Not quite. We can grab a reference on a fence that was already freed and
> >>> reused between the rcu_dereference() and dma_fence_get_rcu().
> >> Reusing a memory structure before the RCU grace period is completed is
> >> illegal, otherwise the whole RCU approach won't work.
> > RCU only protects that the pointer remains valid. If you use
> > SLAB_TYPESAFE_BY_RCU, it is possible to reuse the pointer within a grace
> > period. It does happen and that is the point the comment is trying to
> > make.
> 
> Yeah, but that is illegal with a fence objects.
> 
> When anybody allocates fences this way it breaks at least 
> reservation_object_get_fences_rcu(), 
> reservation_object_wait_timeout_rcu() and 
> reservation_object_test_signaled_single().

Many, many months ago I sent patches to fix them all.
-Chris
