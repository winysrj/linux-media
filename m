Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:46857 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaFSM2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 08:28:15 -0400
Received: by mail-ig0-f176.google.com with SMTP id c1so773477igq.9
        for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 05:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140619114825.GB28111@ulmo>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103711.15728.97842.stgit@patser>
	<20140619011556.GE10921@kroah.com>
	<20140619063727.GL5821@phenom.ffwll.local>
	<20140619114825.GB28111@ulmo>
Date: Thu, 19 Jun 2014 14:28:14 +0200
Message-ID: <CAKMK7uE_B3pCZB9orh5+BJGooNfyEa0APrZqRpXqYu5xfQ0PCQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"Clark, Rob" <robdclark@gmail.com>,
	Colin Cross <ccross@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 19, 2014 at 1:48 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
>> > With these changes, can we pull the android sync logic out of
>> > drivers/staging/ now?
>>
>> Afaik the google guys never really looked at this and acked it. So I'm not
>> sure whether they'll follow along. The other issue I have as the
>> maintainer of gfx driver is that I don't want to implement support for two
>> different sync object primitives (once for dma-buf and once for android
>> syncpts), and my impression thus far has been that even with this we're
>> not there.
>>
>> I'm trying to get our own android guys to upstream their i915 syncpts
>> support, but thus far I haven't managed to convince them to throw people's
>> time at this.
>
> This has been discussed a fair bit internally recently and some of our
> GPU experts have raised concerns that this may result in seriously
> degraded performance in our proprietary graphics stack. Now I don't care
> very much for the proprietary graphics stack, but by extension I would
> assume that the same restrictions are relevant for any open-source
> driver as well.
>
> I'm still trying to fully understand all the implications and at the
> same time get some of the people who raised concerns to join in this
> discussion. As I understand it the concern is mostly about explicit vs.
> implicit synchronization and having this mechanism in the kernel will
> implicitly synchronize all accesses to these buffers even in cases where
> it's not needed (read vs. write locks, etc.). In one particular instance
> it was even mentioned that this kind of implicit synchronization can
> lead to deadlocks in some use-cases (this was mentioned for Android
> compositing, but I suspect that the same may happen for Wayland or X
> compositors).

Well the implicit fences here actually can't deadlock. That's the
entire point behind using ww mutexes. I've also heard tons of
complaints about implicit enforced syncing (especially from opencl
people), but in the end drivers and always expose unsynchronized
access for specific cases. We do that in i915 for upload buffers and
other fun stuff. This is about shared stuff across different drivers
and different processes.

I also expect that i915 will loose implicit syncing in a few upcoming
hw modes because explicit syncing is a more natural fit there.

All that isn't about the discussion at hand imo since no matter what
i915 needs to have on internal representation for a bit of gpu work,
and afaics right now we don't have that. With this patch android
syncpts use Maarten's fences internally, but I can't freely exchange
one for the other. So in i915 I still expect to get stuck with both of
them, which is one too many.

The other issue (and I haven't dug into details that much) I have with
syncpts are some of the interface choices. Apparently you can commit a
fence after creation (or at least the hw composer interface works like
that) which means userspace can construct deadlocks with android
syncpts if I'm not super careful in my driver. I haven't seen any
generic code to do that, so I presume everyone just blindly trusts
surface-flinger to not do that. Speaks of the average quality of an
android gfx driver if the kernel is less trusted than the compositor
in userspace ...

There's a few other things like exposing timestamps (which are tricky
to do right, our driver is littered with wrong attempts) and other
details.

Finally I've never seen anyone from google or any android product guy
push a real driver enabling for syncpts to upstream, and google itself
has a bit a history of constantly exchanging their gfx framework for
the next best thing. So I really doubt this is worthwhile to pursue in
upstream with our essentially eternal api guarantees. At least until
we see serious uptake from vendors and gfx driver guys. Unfortunately
the Intel android folks are no exception here and haven't pushed
anything like this in my direction yet at all. Despite multiple pokes
from my side.

So from my side I think we should move ahead with Maarten's work and
figure the android side out once there's real interest.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
