Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42348 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934821Ab3E1Qtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 12:49:46 -0400
Received: by mail-ie0-f179.google.com with SMTP id c13so22189322ieb.10
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 09:49:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00de01ce5bb2$aa7c6b30$ff754190$%dae@samsung.com>
References: <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
	<CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
	<006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
	<CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
	<00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
	<CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
	<CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
	<20130520211304.GV12292@phenom.ffwll.local>
	<20130520213033.GW12292@phenom.ffwll.local>
	<032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
	<20130521074441.GZ12292@phenom.ffwll.local>
	<033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
	<CAKMK7uHtk+A7CDZH3qHt+F3H_fdSsWwt-bEPn-N0919oOE+Jkg@mail.gmail.com>
	<012801ce57ba$a5a87fa0$f0f97ee0$%dae@samsung.com>
	<014501ce5ac6$511a8500$f34f8f00$%dae@samsung.com>
	<CAF6AEGvGv539Ktdeg03n783nD+HofDamcJCLX93rzzKGOCV8_Q@mail.gmail.com>
	<005701ce5b57$667c7d40$337577c0$%dae@samsung.com>
	<CAF6AEGv6E38bwszcFV3sV3yMPjD9BkLM4asEscJ8Jt5z+duxTQ@mail.gmail.com>
	<00de01ce5bb2$aa7c6b30$ff754190$%dae@samsung.com>
Date: Tue, 28 May 2013 18:49:45 +0200
Message-ID: <CAKMK7uHf0G4-3YU6mouUTf4n50Q+viNAA13BzSLDWjPNWLwJVQ@mail.gmail.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
From: Daniel Vetter <daniel@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: Rob Clark <robdclark@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	YoungJun Cho <yj44.cho@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 28, 2013 at 4:50 PM, Inki Dae <inki.dae@samsung.com> wrote:
> I think I already used reservation stuff any time in that way except
> ww-mutex. And I'm not sure that embedded system really needs ww-mutex. If
> there is any case,
> could you tell me the case? I really need more advice and understanding :)

If you have only one driver, you can get away without ww_mutex.
drm/i915 does it, all buffer state is protected by dev->struct_mutex.
But as soon as you have multiple drivers sharing buffers with dma_buf
things will blow up.

Yep, current prime is broken and can lead to deadlocks.

In practice it doesn't (yet) matter since only the X server does the
sharing dance, and that one's single-threaded. Now you can claim that
since you have all buffers pinned in embedded gfx anyway, you don't
care. But both in desktop gfx and embedded gfx the real fun starts
once you put fences into the mix and link them up with buffers, then
every command submission risks that deadlock. Furthermore you can get
unlucky and construct a circle of fences waiting on each another (only
though if the fence singalling fires off the next batchbuffer
asynchronously).

To prevent such deadlocks you _absolutely_ need to lock _all_ buffers
that take part in a command submission at once. To do that you either
need a global lock (ugh) or ww_mutexes.

So ww_mutexes are the fundamental ingredient of all this, if you don't
see why you need them then everything piled on top is broken. I think
until you've understood why exactly we need ww_mutexes there's not
much point in discussing the finer issues of fences, reservation
objects and how to integrate it with dma_bufs exactly.

I'll try to clarify the motivating example in the ww_mutex
documentation a bit, but I dunno how else I could explain this ...

Yours, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
