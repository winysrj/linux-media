Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34785 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2JCIxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 04:53:16 -0400
Received: by ieak13 with SMTP id k13so16755007iea.19
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 01:53:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506BF93B.5010805@vmware.com>
References: <20120928124148.14366.21063.stgit@patser.local>
	<5065B0C9.7040209@canonical.com>
	<5065FDAA.5080103@vmware.com>
	<50696699.7020009@canonical.com>
	<506A8DC8.5020706@vmware.com>
	<20121002080341.GA5679@phenom.ffwll.local>
	<506BED25.2060804@vmware.com>
	<CAKMK7uGDaCCL-UT7JaArd3qrnMSc74r32fQ2dnouO3csRGvakg@mail.gmail.com>
	<506BF93B.5010805@vmware.com>
Date: Wed, 3 Oct 2012 10:53:16 +0200
Message-ID: <CAKMK7uGg5pbReAUA+cKWk-jyS3YwkUaZXE7MTcv9w7sk-4a10A@mail.gmail.com>
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 3, 2012 at 10:37 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>>> So if I understand you correctly, the reservation changes in TTM are
>>> motivated by the
>>> fact that otherwise, in the generic reservation code, lockdep can only be
>>> annotated for a trylock and not a waiting lock, when it *is* in fact a
>>> waiting lock.
>>>
>>> I'm completely unfamiliar with setting up lockdep annotations, but the
>>> only
>>> place a
>>> deadlock might occur is if the trylock fails and we do a
>>> wait_for_unreserve().
>>> Isn't it possible to annotate the call to wait_for_unreserve() just like
>>> an
>>> interruptible waiting lock
>>> (that is always interrupted, but at least any deadlock will be catched?).
>>
>> Hm, I have to admit that idea hasn't crossed my mind, but it's indeed
>> a hole in our current reservation lockdep annotations - since we're
>> blocking for the unreserve, other threads could potential block
>> waiting on us to release a lock we're holding already, resulting in a
>> deadlock.
>>
>> Since no other locking primitive that I know of has this
>> wait_for_unlocked interface, I don't know how we could map this in
>> lockdep. One idea is to grab the lock and release it again immediately
>> (only in the annotations, not the real lock ofc). But I need to check
>> the lockdep code to see whether that doesn't trip it up.
>
>
> I imagine doing the same as mutex_lock_interruptible() does in the
> interrupted path should work...

It simply calls the unlock lockdep annotation function if it breaks
out. So doing a lock/unlock cycle in wait_unreserve should do what we
want.

And to properly annotate the ttm reserve paths we could just add an
unconditional wait_unreserve call at the beginning like you suggested
(maybe with #ifdef CONFIG_PROVE_LOCKING in case ppl freak out about
the added atomic read in the uncontended case).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
